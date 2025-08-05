// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Inheritance{
    address owner;
    address payable  recipient;
    uint totalMoney=0;
    uint lastInteraction;
    uint maxWaitTime;
    modifier OnlyOwner(){
        require(owner==msg.sender,"you are not the owner");
        _;
    }
    constructor(address payable  _recipient,uint _maxWaitTime){
        owner=msg.sender;
        recipient=_recipient;
        lastInteraction=block.timestamp;
        maxWaitTime=_maxWaitTime;
    }
    function deposit()public OnlyOwner payable {
        totalMoney+=msg.value;
    }
    function checkIn() public OnlyOwner{
        lastInteraction=block.timestamp;
    }
    function check_balance() public  view  returns(uint){
        return totalMoney;
    }
    function selfWithdraw() public OnlyOwner{
        payable(msg.sender).transfer(totalMoney);
        totalMoney=0;
    }
    function changeRecipient(address payable  new_rec) public OnlyOwner{
        recipient=new_rec;
    }
    function transferFunds()public {
        require(msg.sender==recipient,"Not the recepient");
        require(lastInteraction+maxWaitTime<block.timestamp,"Person is not yet dead");
        payable (recipient).transfer(totalMoney);
        totalMoney=0;
    }


}