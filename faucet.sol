// SPDX-License-Identifier: CC-BY-SA-4.0

// Version of Solidity compiler this program was written for
pragma solidity ^0.8.0;

contract Faucet {
    event Withdrawal(address indexed to, uint256 amount);
    event Deposit(address indexed from, uint256 amount);
    event CustomMessageSent(address indexed from, string message);
    address owner;

    constructor() {
        owner = msg.sender;
    }

    // Accept any incoming amount
    receive() external payable {
        emit Deposit(msg.sender, msg.value);
    }

    // be prepared for receiving any type of invocation
    fallback() external payable {}

    // Give out ether to anyone who asks
    function withdraw(uint256 _amount) public onlyOwner returns (bool success) {
        string memory customMessage = "this was made by Simon";
        
        // Ensure the custom message is not empty
        require(bytes(customMessage).length > 0, "custom message is required");
                
        // Send the amount to the owner with the custom data
        (bool sent, ) = msg.sender.call{value: _amount}("");
        
        if (sent) {
            emit Withdrawal(msg.sender, _amount);
            // Log the transaction data (this ensures txdata is used)
            emit CustomMessageSent(msg.sender, customMessage);
        }
        
        return sent;
    }

    // declare modifiers that apply to every function I want
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }
}