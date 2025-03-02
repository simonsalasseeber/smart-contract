// SPDX-License-Identifier: MIT

// Version of Solidity compiler this program was written for
pragma solidity ^0.8.0;

contract Faucet {
    event Withdrawal(address indexed to, uint256 amount);
    event Deposit(address indexed from, uint256 amount);
    event CustomMessageSent(address indexed from, string message);
    
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    // Accept any incoming amount
    receive() external payable {
        emit Deposit(msg.sender, msg.value);
    }

    // Be prepared for receiving any type of invocation
    fallback() external payable {
        // Opcionalmente emitir un evento de depósito también aquí
        if (msg.value > 0) {
            emit Deposit(msg.sender, msg.value);
        }
    }

    // Give out ether to anyone who asks
    function withdraw(uint256 _amount) public onlyOwner returns (bool) {
        // 1. Verificaciones (Checks)
        require(_amount > 0, "Amount must be greater than 0");
        require(address(this).balance >= _amount, "Insufficient balance in faucet");
        
        string memory customMessage = "this was made by Simon";
        require(bytes(customMessage).length > 0, "Custom message is required");
        
        // 2. Efectos (Effects)
        // No hay cambios de estado interno que registrar antes de la transferencia
        
        // 3. Interacciones (Interactions)
        (bool success, ) = msg.sender.call{value: _amount}("");
        require(success, "Transfer failed");
        
        // 4. Eventos (después de confirmar el éxito)
        emit Withdrawal(msg.sender, _amount);
        emit CustomMessageSent(msg.sender, customMessage);
        
        return true;
    }


    // Declarar modificadores que se aplican a cada función que lo requiera
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }
}