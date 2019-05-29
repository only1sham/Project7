# Supply chain & data auditing

This repository containts an Ethereum DApp that demonstrates a Supply Chain flow for TunaFish tracking. The user story is similar to any commonly used 
supply chain process. A Fisherman can record details after catching TunaFish to the inventory system stored in the blockchain. A Regulator can 
then audit the TunaFish and update the status on the inventory system. Then, a Restaurant can query the inventory Blockchain and decide to buy 
TunaFish if the audit is passed.

## The UML diagrams can be found in the following "Writeups" folder 

## Roles
There are Three roles in the application - Fisherman, Regulator and Restaurant

## Flow details
1. Fisherman catches Tuna which involves writing some basic details on Blockchain like UPC, Fisherman's address and Coast location. The status
   of Tuna gets set to 'Caught'
2. Fisherman then records the following details on TunaFish onto Blockchain - Price and Notes by passing the UPC of TunaFish entered in step #1. The status
   of Tuna gets changed to 'Recorded'
3. A Regulator can audit TunaFish details and record the audit details on Blockchain - Auditor's address and Audit Status (Pass/Fail). The status
   of Tuna gets changed to 'Audited'
4. A Restaurant can Query TunaFish details from Blockchain by passing the UPC
5. Restaurant can then decide to buy TunaFish by passing UPC and Price. The status of Tuna gets changed to 'Bought' and also OwnerID address will be 
   set Restaurant's address

##Testing instructions

Fisherman actions: 
1. In the DApp user interface, select the Metamask account for Fisherman Role
2. Enter UPC and Coast Location and click on 'Catch' button
3. The 'Caught' event should be visible in 'Transaction History' section
4. Enter TunaFish details - Price and Notes for the UPC
5. Click on 'Record' button
6. The entered details get stored on Blockchain
7. The 'Recorded' event should be generated and visible in 'Transaction History' section
8. Enter UPC and click on 'Query' button
9. The TunaFish details for that UPC should get displayed

Regulator actions: 
1. Select the Metamask account for Regulator
2. Enter UPC and audit status
3. Click on 'Audit' button
4. The audit status and Regulator's Ethereum address gets updated on Blockchain for that TunaFish
5. The 'Audited' event should be generated and visible in 'Transaction History' section
6. To confirm if the Audit details are updated correctly, enter that UPC and click on 'Query' button
7. The TunaFish details added by Fisherman plus Regulator address and audit status should get displayed

Restaurant actions:
1. Select the Metamask account for Restaurant
2. Enter UPC and click on 'Query' button
3. TunnaFish details should get displayed for that UPC
4. Review the details, enter UPC and Price and then click on 'Buy' button
5. TunaFish owner address should get changed to Restaurant's address
6. The 'Bought' event should be generated and visible in 'Transaction History' section

## External Libraries
1. 'truffle-hdwallet-provider' library has been used to deploy the SmartContract to Rinkeby network
2. IPFS has not been used in this project

## Contract details on Rinkeby network
Contract Address: 0x86DBBFaA23c81756C8a6d6116C55bA3DCC9C9939
Transaction Hash: 0xfd93037882536d53fe33f0498080569de0177bca637596937065416c0803b1b8

##Acknowledgments

Solidity
Ganache-cli
Truffle
Udacity
Rinkeby