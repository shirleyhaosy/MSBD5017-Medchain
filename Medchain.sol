// SPDX-License-Identifier: MIT
// Functions with a "test_" prefix and the to_String function are used for testing and demonstration of output
// These functions will not occur in the prod version.
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/utils/Strings.sol";
import "hardhat/console.sol";


contract MedChainHealthData {
    struct UserData {
        uint256 dataId;  // ID of this data record
        address userAddress;  // address of the user (data owner)
        uint256 dataPrice;  //varies with data types
        uint256 timestamp;  // time when the data is uploaded
        string healthDataCategory;  // e.g., sleep, blood pressure, etc.
        string dataValue;  // value of the data. Currently use a string for simplicity.
        string demographicInfo;  // e.g., age, weight, etc.
    }
   
    struct BuyerData {
        address buyerAddress;
        uint256[] subscribedData; // modified from subscribedUser to subscribedData.
    }

    mapping(uint256 => UserData) public healthData;  // map data id to user data
    mapping(address => uint256[]) public userOwnedData;  // map users to their own data
    mapping(address => BuyerData) public buyers;  // map address to buyers
    uint256 public totalDataCount;
    uint256 public price_to_user = 50;
    uint256 public price_to_platform = 50;
    uint256 public bonusProportion = 40; // proportion of profit to be distributed as bonus
    uint256 public bonusProportion_platform = 5; // proportion of profit to be distributed to the platform
    
    struct TransactionDetails {
        uint256[] dataIds;  // data id should be array
        address buyer;
        uint256 timestamp;
    }

    struct BonusDetails {
        address userAddress;
        uint256 bonus;
    }

    mapping(uint256 => TransactionDetails) public transactions;  // map data id to transaction details
    mapping(uint256 => BonusDetails[]) public bonuses;  //// map transaction id to to a list of bonus details
    uint256 public totalTransactionCount;

    address public admin;



    // To set user address as testing data of healthData
    address public addr1 = 0xE6c7b098603648F6F817fB3f8A6e09Da7c3Ca250;
    address public addr2 = 0x22Dc5A9Fc2f1B2D03eB83F80c55c053C5d7bd3F7;
    address public addr3 = 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2;  

    event DataUploaded(address indexed user, uint256 dataId, uint256 price);
    event DataPurchased(address indexed buyer, uint256 dataId);
    event ProfitGenerated(uint256 transactionId, uint256 profit);
    event BonusPaid(uint256 transactionId, address indexed user, uint256 bonus);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can perform this action");
        _;
    }

    modifier onlyDataOwner(uint256 dataId) {
        require(healthData[dataId].userAddress == msg.sender, "Only data owner can perform this action");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    function toString(bytes memory data) public pure returns(string memory) {
     // convert address to string for printing. referred from https://ethereum.stackexchange.com/questions/8346/convert-address-to-string
        bytes memory alphabet = "0123456789abcdef";
        bytes memory str = new bytes(2 + data.length * 2);
        str[0] = "0";
        str[1] = "x";
        for (uint i = 0; i < data.length; i++) {
            str[2+i*2] = alphabet[uint(uint8(data[i] >> 4))];
            str[3+i*2] = alphabet[uint(uint8(data[i] & 0x0f))];
        }
        return string(str);
    }
      
    
    function test_setHealthData() public {
        console.log("Set Test Health Data for Testing:");
        for (uint256 i = 0; i < 3; i++) {
            uint256 dataId = totalDataCount;

            if (i==0){
                healthData[dataId] = UserData(dataId, addr1, 2, block.timestamp, "Sleep", "8 hours", string.concat("age: ", Strings.toString(27)));
                userOwnedData[addr1].push(dataId);
            }else if (i==1){
                healthData[dataId] = UserData(dataId, addr2, 2, block.timestamp, "Blood Pressure", "80-120 mm Hg", string.concat("age: ", Strings.toString(40)));
                userOwnedData[addr2].push(dataId);
            }else{
                healthData[dataId] = UserData(dataId, addr3, 2, block.timestamp, "Sleep", "5 hours",string.concat("age: ", Strings.toString(30)));
                userOwnedData[addr2].push(dataId);
            }
            totalDataCount ++;

            console.log("Health Data ", Strings.toString(i+1),": ");
            console.log("dataId: ", Strings.toString(healthData[i].dataId));
            console.log("userAddress: ", toString(abi.encodePacked(healthData[i].userAddress)));
            console.log("dataPrice: ", Strings.toString(healthData[i].dataPrice));
            console.log("healthDataCategory: ", healthData[i].healthDataCategory);
            console.log("dataValue: ", healthData[i].dataValue);
            console.log("demographicInfo: ", healthData[i].demographicInfo);
            console.log("timestamp: ", Strings.toString(healthData[i].timestamp));
            console.log("------------------------------");
        }
    }
    
    function setBuyer() public {
        uint256[] memory subscribed_list;
        buyers[msg.sender] = BuyerData(msg.sender, subscribed_list);
        console.log("Set Buyer Data:");
        console.log("Buyer: ");  // only set test data for 1 buyer
        console.log("buyerAddress: ", toString(abi.encodePacked(buyers[msg.sender].buyerAddress)));
        console.log("subscribedData: ");
        for(uint i =0; i< buyers[msg.sender].subscribedData.length; i++){
            console.log( buyers[msg.sender].subscribedData[i]);
        }
        if ( buyers[msg.sender].subscribedData.length == 0){
            console.log("Currently the buyer has not subscribed to insights of any health data");
        }

    }

    function uploadData(uint256 price, string memory category, string memory data_val, string memory demographic) external {
        totalDataCount++;
        uint256 dataId = totalDataCount;
        healthData[dataId] = UserData(dataId, msg.sender, price, block.timestamp, category, data_val, demographic);
        userOwnedData[msg.sender].push(dataId);
        emit DataUploaded(msg.sender, dataId, price);
        console.log("New user health data uploaded:");
        console.log("dataId: ", Strings.toString(healthData[dataId].dataId));
        console.log("userAddress: ", toString(abi.encodePacked(healthData[dataId].userAddress)));
        console.log("dataPrice: ", Strings.toString(healthData[dataId].dataPrice));
        console.log("healthDataCategory: ", healthData[dataId].healthDataCategory);
        console.log("dataValue: ", healthData[dataId].dataValue);
        console.log("demographicInfo: ", healthData[dataId].demographicInfo);
        console.log("timestamp: ", Strings.toString(healthData[dataId].timestamp));
    }
    

    function purchaseData(uint256[] calldata dataIds) external payable {
        uint256 payment = msg.value;
        console.log("Buyer ", toString(abi.encodePacked(msg.sender)), "starts to purchase data");
        //uint256[] storage prices;
        for(uint i=0; i<dataIds.length; i++){
            uint256 dataId = dataIds[i];
            UserData storage data = healthData[dataId];
            require(payment >= data.dataPrice, "Insufficient payment");
            
            buyers[msg.sender].subscribedData.push(dataId);
            
            console.log("Health data ", Strings.toString(dataId)," has been bought.");

            // Split payment
            uint256 userShare = (data.dataPrice * price_to_user) / 100;
            uint256 platformShare = (data.dataPrice * price_to_platform) / 100;

            payable(data.userAddress).transfer(userShare);
            console.log(string.concat("User ", toString(abi.encodePacked(data.userAddress)), " got payment ", Strings.toString(userShare), "."));
            payable(admin).transfer(platformShare);
            console.log(string.concat("The platform ", toString(abi.encodePacked(admin)), " got payment ", Strings.toString(platformShare), "."));

            emit DataPurchased(msg.sender, dataId);
            payment = payment - data.dataPrice;
            
        }
        transactions[totalTransactionCount] = TransactionDetails(dataIds, msg.sender, block.timestamp);
        console.log("Successfully purchased. ID of the transaction is : ", totalTransactionCount);
        console.log("The dataIds of Buyer ", toString(abi.encodePacked(msg.sender)), "'s all subscribed data: ");
        for(uint j=0; j<buyers[msg.sender].subscribedData.length; j++){
            console.log(buyers[msg.sender].subscribedData[j]);
        }
        totalTransactionCount++;
    }

    function distributeBonus(uint256 transactionId) external payable {
        // transactionId: should be the transaction id of the data purchase
        uint256 profit = msg.value;
        
        emit ProfitGenerated(transactionId, profit);

        TransactionDetails storage transaction = transactions[transactionId];
        require(transaction.timestamp != 0, "Transaction does not exist");

        console.log(string.concat("The total profit generated from transaction ", Strings.toString(transactionId)," is ", Strings.toString(profit),"."));

        console.log("Bonus distribution starts.");
        uint256 bonusAmount = (profit * bonusProportion) / 100;
        console.log(string.concat("Total bonus paid to all related users: ", Strings.toString(bonusAmount)));

        uint256 subscribedDataCount = buyers[transaction.buyer].subscribedData.length;
        require(subscribedDataCount > 0, "No subscribed data");
        uint256 perUserBonus = bonusAmount / subscribedDataCount;

        uint256 platformBonus = (profit * bonusProportion_platform) / 100; 
        
        
        for (uint256 i = 0; i < subscribedDataCount; i++) {
            uint256 userId = buyers[transaction.buyer].subscribedData[i];
            address userAddress = healthData[userId].userAddress;
            bonuses[transactionId].push(BonusDetails(userAddress, perUserBonus));
            // pay part of profit to the user
            payable(userAddress).transfer(perUserBonus);
            emit BonusPaid(transactionId, userAddress, perUserBonus);
            console.log(string.concat("User ", toString(abi.encodePacked(userAddress))," got bonus ", Strings.toString(perUserBonus), "."));
        }
        // pay part of profit to platform
        payable(admin).transfer(platformBonus);
        console.log(string.concat("The platform ", toString(abi.encodePacked(admin))," got bonus ", Strings.toString(platformBonus), "."));
    }

}
