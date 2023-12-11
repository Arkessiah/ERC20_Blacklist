# REQUIREMENTS:

1. Create an ERC20 Contract with a black list of wallets which are not allowed to transfer tokens
2. Create a node.js script which can add wallets to the blacklist (wallet address is a parameter)
3. The node.js script output should be able to show a list of blacklisted wallets in the ERC20 Contract

* deploy on any testnet of your choice
* use any SDK of your choice
* calculate gas fees in case we want to blacklist 1000 wallets a day
* write tests


--------------------------------------------------------------------------------------------------------------------------------------
# APPROACH:
--------------------------------------------------------------------------------------------------------------------------------------

#### ERC20 contract: **Contracts folder / OPToken.sol**
#### Script NodeJS: **Folder script / blacklist.js**
#### Script Add 1000 Wallet and view cost: **Folder script / generate1000Address.js**
#### Test contract: **Test / OPToken_test.sol folder**

#### Blockchain Net: **Mumbai (Polygon Testnet)**
#### Contract Deployed and Verified: **0xeafA2a9336fc936F196e834CcaF8fe29e01deb1A**

I have not used any development environment like Hardhat or Foundry to avoid weighting the project, I have used remix to deploy the contract.

#### I have also done these functional tests on the deployed contract: 
https://mumbai.polygonscan.com/address/0xA7B7123987A9DBcCe84C2f08dBAaD031BA839eC4

Contract Address v1: 0xA7B7123987A9DBcCe84C2f08dBAaD031BA839eC4
Contract Address v2 Final: 0xA7B7123987A9DBcCe84C2f08dBAaD031BA839eC4

- I have minted 1000 OPToken tokens. ✅
- I have burned 100 OPToken tokens.  ✅
- I have added the 0x60f3c9C7bc50D8A6FBEbb6BFCb882E24534b3F86 wallet to the blacklist   ✅
- I have removed the 0x60f3c9C7bc50D8A6FBEbb6BFCb882E24534b3F86 wallet to the blacklist ✅

[Test Result](img/test.png)

#### The estimated cost per transaction of adding a wallet to the Blacklist is: 

##### Manual estimate based on the cost of a transaction.
1 Transaction: 0.00016886257953256 MATIC
1000 Transactions: 0.168886257953256 MATIC
1 Matic = 0.86 USD
Estimated 1000Tx/Day: 0.1452218 USD

##### Automatic estimation by executing the generate1000Address script 1 to 1
1000 Tx/Day: 2377200000.0 gwei
2,377,200,000.0 gwei = 2,377,200,000.0/10^9 MATIC
The estimated transaction cost of 2,377,200,000.0 gwei equals approximately 2.04 USD *, considering that 1 MATIC equals 0.86 USD.

[generate1000Address execution](img/add1000wallet.png)

##### Automatic estimation by executing the generate1000Address script 1000 using the function Add Multiple To Black List 
I have not been able to finish this estimation because I do not have enough funds to do the test and the Mumbai faucet does not give me more until tomorrow.

* Estimates made on the Mumbai test network, on Polygon's Mainnet may vary.

--------------------------------------------------------------------------------------------------------------------------------------
###### Author: Antonio Maroto
--------------------------------------------------------------------------------------------------------------------------------------
NOTICE:  *.ens file needed to check operation not included, sending method: email*