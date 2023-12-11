const ethers = require('ethers');


// Configuration
const provider = new ethers.providers.JsonRpcProvider('https://polygon-mumbai-pokt.nodies.app');
const ownerPrivateKey = process.env.OWNER_PRIVATE_KEY || '';
const contractAddress = process.env.CONTRACT_ADDRESS || '';
const contractABI = require('./contractABI');


const wallet = new ethers.Wallet(ownerPrivateKey, provider);
const optoken = new ethers.Contract(contractAddress, contractABI, wallet);

async function modifyBlacklist(walletAddress, action) {
    try {
        if (action === 'add') {
            const tx = await optoken.addToBlacklist(walletAddress, "Reason for blacklisting");
            await tx.wait();
            console.log(`Wallet ${walletAddress} added to the blacklist.`);
        } else if (action === 'remove') {
            const tx = await optoken.removeFromBlacklist(walletAddress);
            await tx.wait();
            console.log(`Wallet ${walletAddress} removed from the blacklist.`);
        } else {
            console.log("Unrecognized action.");
        }

        // Display the updated blacklist
        await showBlacklist();
    } catch (error) {
        console.error(error);
    }
}

async function showBlacklist() {
    const filter = optoken.filters.AddedToBlacklist();
    const events = await optoken.queryFilter(filter);

    console.log("Wallets in the Blacklist:");
    for (let event of events) {
        const details = await optoken.blacklist(event.args.account);
        console.log(`Wallet: ${event.args.account}, Reason: ${details.reason}`);
    }
}

// Example usage:
// modifyBlacklist('wallet_address', 'add' or 'remove');