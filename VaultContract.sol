// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract VaultContract{
    uint public totalBalance;
    mapping (address=>uint) shares;
    uint totalProfit=10000; // lets assume

    function deposite()public  payable {
        require(msg.value>0,"you must deposite some amount");
        totalBalance+=msg.value;
        uint totalShare=(msg.value)/totalBalance;
        shares[msg.sender]=totalShare;
    }
    function withdraw(uint _amount)public {
        require(shares[msg.sender]>0,"you do not have any money deposited");
        require(_amount>0,"you must withdraw some amount");
        require(_amount<=shares[msg.sender]*totalBalance,"you do not have that much money");

        uint moneyWithdraw=_amount+totalProfit*shares[msg.sender];
        shares[msg.sender]=(shares[msg.sender]-_amount)/totalBalance;
        payable(msg.sender).transfer(moneyWithdraw);
        totalBalance-=_amount;
    }
    function getMyshare()public view  returns (uint ){
        return shares[msg.sender]*100;
    }
}
