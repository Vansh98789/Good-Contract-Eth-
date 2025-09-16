// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/interfaces/IERC20.sol";

contract simpleAMM{
    IERC20 public Vcoin;
    IERC20 public  Ccoin;
    uint public fees;
    uint public reserveA;
    uint  public reserveB;
    address owner;

    constructor(address _Vcoin,address _Ccoin,uint _fees){
        Vcoin=IERC20(_Vcoin);
        Ccoin=IERC20(_Ccoin);
        fees=_fees;
        owner=msg.sender;
    }
    function addLiquidity(uint _amountA,uint _amountB)public {
        require(_amountA>0 && _amountB>0,"the amount must be greater than 0");
        Vcoin.transferFrom(msg.sender, address(this),_amountA);
        Ccoin.transferFrom(msg.sender, address(this),_amountB);
        reserveA+=_amountA;
        reserveB+=_amountB;
    }
    function getAmountBack(uint amountIn,uint reserveIn,uint reserveOut ) public view  returns (uint ) {
        uint amountInWithFees=amountIn*(1000-fees);
        uint numerator=amountInWithFees*reserveOut;
        uint denominator=reserveIn*1000+amountInWithFees;
        return numerator/denominator;
    }
    function swapAtoB(uint amountAIn) public {
        require(amountAIn>0,"amount must be greater than 0");
        uint amounBOut=getAmountBack(amountAIn, reserveA, reserveB);
        Vcoin.transferFrom(msg.sender, address(this), amountAIn);
        Ccoin.transfer(msg.sender, amounBOut);

        reserveA += amountAIn;
        reserveB -= amounBOut;
    }
    function swapBtoA(uint amountBIn)public {
        require(amountBIn>0,"amount must be greater than 0");
        uint amountAOut=getAmountBack(amountBIn, reserveA, reserveB);

        Ccoin.transferFrom(msg.sender, address(this), amountBIn);
        Vcoin.transfer(msg.sender, amountAOut);
        
        reserveA-=amountAOut;
        reserveB+=amountBIn;
    }

    
}
