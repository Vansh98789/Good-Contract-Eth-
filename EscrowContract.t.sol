// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import {EscrowContract} from "../src/EscrowContract.sol" ;

contract EscrowContractTest  is Test{
    EscrowContract public escrowContract;
    address user1;
    address user2;
    function setUp()public{
        user1 = vm.addr(1);
        user2 = vm.addr(2);
        vm.deal(user1,10 ether);
        vm.deal(user2,10 ether);
        vm.startPrank(user1);
        escrowContract=new EscrowContract(user2);
        vm.stopPrank();
    }
    function testDeposite()public{
        vm.startPrank(user1);
        escrowContract.deposit{value:1 ether}();
        vm.stopPrank();

        assertEq(address(escrowContract).balance, 1 ether);
    }

    function testrefund() public{
        vm.startPrank(user1);
        escrowContract.deposit{value:1 ether}();
        escrowContract.refund();
        vm.stopPrank();
        assertEq(address(user1).balance, 10 ether);
    }
    function testRelease() public{
        vm.startPrank(user1);
        escrowContract.deposit{value:1 ether}();
        escrowContract.release();
        vm.stopPrank();
        assertEq(address(user2).balance, 11 ether);
    }
}
