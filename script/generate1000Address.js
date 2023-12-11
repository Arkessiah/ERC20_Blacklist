require('dotenv').config();
const ethers = require('ethers');
const axios = require('axios');

// Ethereum provider URL (Polygon Mumbai testnet)
const providerUrl = 'https://rpc.ankr.com/polygon_mumbai'; 

// Polygonscan API for fetching gas prices
const polygonExplorerApi = 'https://api.polygonscan.com/api'; 
const polygonExplorerApiKey = process.env.POLYGON_EXPLORER_API_KEY || '';

// Wallet private key and contract information
const ownerPrivateKey = process.env.OWNER_PRIVATE_KEY || '';
const provider = new ethers.providers.JsonRpcProvider(providerUrl);
const wallet = new ethers.Wallet(ownerPrivateKey, provider);

// Gas limit for each transaction
const gasLimit = ethers.BigNumber.from("8000000");
const maxPriorityFeePerGas = ethers.utils.parseUnits('2', 'gwei'); // Max fee per gas
const maxFeePerGas = ethers.utils.parseUnits('73', 'gwei'); // Max fee per gas

// Contract address and ABI
const contractAddress = process.env.CONTRACT_ADDRESS || '';
const contractAbi = require('./contractABI');
const contract = new ethers.Contract(contractAddress, contractAbi, wallet);

// Generate a specified number of random Ethereum addresses
async function generateRandomAddresses(count) {
  const addresses = [];
  for (let i = 0; i < count; i++) {
    const wallet = ethers.Wallet.createRandom();
    addresses.push(wallet.address);
  }
  return addresses;
}

// Get the current gas price from Polygonscan
async function getGasPrice() {
  try {
    const response = await axios.get(polygonExplorerApi, {
      params: {
        module: 'gastracker',
        action: 'gasoracle',
        apikey: polygonExplorerApiKey,
      },
    });

    if (response.data.status === '1') {
      const gasPrice = ethers.utils.parseUnits(response.data.result.ProposeGasPrice, 'gwei');
      return gasPrice;
    } else {
      throw new Error('Failed to fetch gas price from Polygonscan');
    }
  } catch (error) {
    throw error;
  }
}

// Calculate the total gas cost for adding multiple addresses to the blacklist
async function calculateGasCosts(addressesToAdd) {
  const gasPrice = await getGasPrice();
  const gasLimitPerTransaction = ethers.BigNumber.from(21000); // Estimate for a simple transaction
  const gasCostPerTransaction = gasLimitPerTransaction.mul(gasPrice);

  const totalGasCost = gasCostPerTransaction.mul(addressesToAdd.length);
  return totalGasCost;
}

// Add a list of addresses to the blacklist in the smart contract
async function addToBlacklist(addresses) {
  const reason = "Blacklisted"; // Customizable reason for blacklisting
  const tx = await contract.addMultipleToBlacklist(addresses, reason, {
    gasLimit: gasLimit,
    maxPriorityFeePerGas: maxPriorityFeePerGas,
    maxFeePerGas: maxFeePerGas
  });
  const receipt = await tx.wait();

  console.log(`${addresses.length} addresses added to blacklist.`);
}

// Main function to generate addresses and calculate gas costs
async function main() {
  const totalAddressesToAdd = 1000;
  const randomAddresses = await generateRandomAddresses(totalAddressesToAdd);
  const estimatedGasCost = await calculateGasCosts(randomAddresses);

  console.log(`Generated ${totalAddressesToAdd} random addresses.`);
  console.log(`Estimated gas cost to blacklist ${totalAddressesToAdd} addresses: ${ethers.utils.formatUnits(estimatedGasCost, 'gwei')} gwei`);


  await addToBlacklist(randomAddresses);
}

main().catch(error => console.error('Error:', error));
