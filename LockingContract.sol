// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;
import {IERC20} from "node_modules/@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract LockContract {
    uint public amount; 
    address public owner;
    uint public lastInteraction;
    address public tokenAddress;
    uint public time;

    modifier onlyOwner() {
        require(owner == msg.sender, "you are not the owner");
        _;
    }

    event locked(uint amount, uint time);
    event unLocked(uint amount);

    constructor(address _tokenAddress) {
        owner = msg.sender;
        tokenAddress = _tokenAddress;
        amount = 0;
    }
    function lockERC20(uint _time, uint _amount) public onlyOwner {
        require(_amount > 0, "You must send tokens to lock");
        IERC20(tokenAddress).transferFrom(msg.sender, address(this), _amount);
        amount += _amount;
        time = _time;
        lastInteraction = block.timestamp;
        emit locked(amount, time);
    }
    function unLockERC20() public onlyOwner {
        require(lastInteraction + time <= block.timestamp, "You need to wait some more time to get your tokens");
        IERC20(tokenAddress).transfer(msg.sender, amount);
        emit unLocked(amount);
        amount = 0;
    }
}
