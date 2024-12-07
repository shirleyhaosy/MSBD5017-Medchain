# MSBD5017-Medchain
This repo serves for MSBD5017 Group Project: Medchain: Blockchain-based Health Data System for Care Coordination. There are 2 smart contracts and a <a href= "Medchain.fig">UI prototype</a>.<br><br>
To test the smart contracts, please upload the smart contracts to the "contracts" directory on Remix IDE. Simply compile and deploy with the test accounts. Hardhat console.log has been added to show the output of some key functions. <br><br>
To test <a href = "Medchain.sol">Medchain.sol</a>, you may call test_setHealthData and setBuyer functions first to initialize some testing data. HealthData can also be initialized via uploadData function. In addition, please note that you may need to switch test accounts for different roles, such as admin and buyer. For sample outputs of functions, you may check our reports for reference.</br>
References:
* AI chatbot answer
* https://hardhat.org/tutorial/debugging-with-hardhat-network
* https://metaschool.so/articles/how-to-concatenate-the-strings-in-solidity
* https://ethereum.stackexchange.com/questions/58058/access-all-the-values-tuples-stored-in-mappings-of-solidity-smart-contract-usi
* https://dev.to/monierate/how-to-get-array-length-in-solidity-335a
* https://ethereum.stackexchange.com/questions/8346/convert-address-to-string
* https://ethereum.stackexchange.com/questions/144080/how-can-i-do-console-logging-of-an-array-or-struct-using-hardhat-console-sol
* https://docs.msbd5017.com/
