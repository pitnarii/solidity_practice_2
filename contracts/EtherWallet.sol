// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract EtherWallet {

    address public _owner;
    uint public _balance;
    constructor() {
        _owner = payable(msg.sender);
    }
    receive() external payable {}
    // executed on a call to the contract with empty calldata
    // This function cannot have an argument
    
    function Withdraw(uint _amount) external {
        require(msg.sender == _owner, "Only owner can call this function");
        require(_amount <= _balance, "Withdraw amount exceeds limit");
        _balance -= _amount;
    }
}