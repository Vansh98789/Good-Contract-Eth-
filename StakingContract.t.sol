// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;
import "forge-std/Test.sol";
import {StakingContract} from "../src/StakingContract.sol";
import {ERC20Mock} from "../src/ERC20Mock.sol";



contract StakingContractTest is Test{
    StakingContract public stakingContract;
    ERC20Mock public eRC20Mock;
    address owner = address(1);
    address user1 = address(2);
    address user2 = address(3);




    function setUp() public {
        token=new ERC20Mock("Vcoin","V");
        stackingContarct=new StakingContract(address(token));
        vm.startPrank(owner);
        token.transfer(user1,1000 ether);
        token.transfer(user2,1000 ether);
        vm.stopPrank();
    }



    function stakeToken()public{
        vm.startPrank(user1);
        token.approve(address(stakingContract),100 ether);
        StakingContract.stake(100 ether);
        vm.stopPrank();

        //checking ->
        (uint amount,)=stakingContract.stakes(user1);
        assertEq(amount, 100 ether);
        assertEq(stakingContract.totalAmount, 100 ether);
    }

    function testCalculateReward() public{
        vm.startPrank(user1);
        token.approve(address(stakingContarct),100 ether);
        StakingContract.stake(100 ether);
        vm.warp(block.timestamp()+ 1 days);
        vm.stopPrank();


        uint stakingReward=StakingContract.calculateReward(user1);
        assertEq(stakingReward, 10 ether);
    }

    function testClaimReward() public{
        vm.startPrank(user1);
        token.approve(address(stakingContract),100 ether);
        StakingContract.stake(100 ether);
        vm.warp(block.timestamp()+1 days);
       
        uint reward=StakingContract.calculateReward(user1);
        stakingContract.claimReward();
        assertEq(token.balanceOf(user1), 110);
        vm.stopPrank();
    }
    

}
