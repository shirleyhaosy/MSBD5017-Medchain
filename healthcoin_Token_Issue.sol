// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Import OpenZeppelin's ERC20 and Ownable contracts
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "hardhat/console.sol";

contract HealthCoin is ERC20, Ownable {
    constructor() ERC20("HealthCoin", "HLTH") Ownable(msg.sender) {
        // Mint 1,000,000 tokens to the deployer's address
        _mint(msg.sender, 1000000 * 10 ** decimals());
        console.log("The amount is:", 1000000 * 10 ** decimals());
    }
    
    /// @notice Mint additional tokens (if needed). Restricted to owner.
    function mint(address to, uint256 amount) external onlyOwner {
        _mint(to, amount);
        console.log("The amount is:", amount);
    }
}