// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;
import "forge-std/Test.sol";
import {MarketPlaceContract} from "../src/MarketPlaceContract.sol";


contract MarketPlaceContractTest is Test{
    MarketPlaceContract public mkPlace;
    address owner = vm.addr(1);
    address seller = vm.addr(2);
    address buyer = vm.addr(3);

    function setUp() public{
        vm.deal(owner, 10 ether);
        vm.deal(seller, 10 ether);
        vm.deal(buyer, 10 ether);
        vm.startPrank(owner);
        mkPlace=new MarketPlaceContract();
        vm.stopPrank();

    }
    function testListItem()public{
        vm.startPrank(seller);
        mkPlace.listItem("iphone", 100000,"this is good phone");
        vm.stopPrank();
        (uint id,address sellerr,string memory name,uint price,string memory description,bool isSold)=mkPlace.items(1);
        assertEq(id, 1);
        assertEq(sellerr, seller);
        assertEq(name, "iPhone");
        assertEq(price, 1 ether);
        assertEq(description, "this is good phone");
        assertEq(isSold, false);
    }
    function testBuyItem()public{
        vm.startPrank(seller);
        mkPlace.listItem("Laptop", 2 ether, "Gaming laptop");
        vm.stopPrank();

        uint sellerBalanceBefore = seller.balance;
        uint ownerBalanceBefore = owner.balance;

        // Buyer buys
        vm.startPrank(buyer);
        mkPlace.buyItem{value: 2 ether}(1);
        vm.stopPrank();

        // Check balances after commission (2%)
        uint commission = (2 ether * 2) / 100; // 0.04 ether
        uint sellerAmount = 2 ether - commission;

        assertEq(seller.balance, sellerBalanceBefore + sellerAmount);
        assertEq(owner.balance, ownerBalanceBefore + commission);

        // Check item marked sold
        (, , , , , bool isSold) = mkPlace.items(1);
        assertTrue(isSold);

    }
    function testCancelItem()public{
vm.startPrank(seller);
        mkPlace.listItem("Book", 0.5 ether, "Novel");
        mkPlace.cancelItem(1);
        vm.stopPrank();

        (uint id, , , , , ) = mkPlace.items(1);

        assertEq(id, 0);
    }
}
