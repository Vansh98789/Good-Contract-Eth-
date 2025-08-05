// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
/*
    we can also write logic of->
    initial coin offering
    airdrop
    fair launch
    token vesting/token unlocking
*/
contract Token {
    string public name = "KiratCoin";
    uint public supply = 0;
    address public owner;
    mapping(address => uint) public balances;
    uint decimals=18;
    string public coinName="vanshCoin";
    string public  symbol="Vc";
    constructor() {
        owner = msg.sender;
    }

    function mintTo(address to, uint amount) public {
        require(msg.sender == owner);
        balances[to] += amount;
        supply += amount;
    }

   
    function burn(uint amount) public {
        uint balance=balances[msg.sender];
        require(balance>=amount,"You do not have enough balace");
        balances[msg.sender]-=amount;
        supply-=amount;

    }
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);

     function transfer(address to, uint amount) public {
        uint balance = balances[msg.sender];
        require(balance >= amount, "You don't have enough balance");
        balances[msg.sender] -= amount;
        balances[to] += amount;
        emit Transfer(msg.sender, to, amount);
    }

    mapping (address =>mapping (address =>uint)) public allowances;
    function approve(address to,uint amount) public {
        allowances[msg.sender][to]=amount;
        emit Approval(msg.sender,to , amount);
    }
   

    function allowance(address from,address to ,uint amount) public{
            require(balances[from]>=amount);
            uint currectAllowance=allowances[from][to];
            require(currectAllowance>=amount);
            balances[to]+=amount;
            balances[from]-=amount;
            allowances[from][to]-=amount;
    }
}
