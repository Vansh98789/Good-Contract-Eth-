// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import {GovernanceContract} from "../src/GovernmentContract.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

// simple token for testing
contract Vcoin is ERC20 {
    constructor() ERC20("VoteCoin", "VCN") {
        _mint(msg.sender, 1000 ether);
    }
    function mint(address to, uint amount) external {
        _mint(to, amount);
    }
}

contract GovernanceContractTest is Test {
    GovernanceContract public gc;
    Vcoin public token;

    address user1 = address(1);
    address user2 = address(2);

    function setUp() public {
        token = new Vcoin();
        gc = new GovernanceContract(address(token));

        token.mint(user1, 1000 ether);
        token.mint(user2, 1000 ether);
    }

    function testCreateProposal() public {
        vm.startPrank(user1);
        gc.createProposel("increase food supply", 5 days);
        vm.stopPrank();

        // verify using a custom getter
        (, string memory desc, , , uint endTime, , ) = gc.getProposal(1);

        assertEq(desc, "increase food supply");
        assertGt(endTime, block.timestamp);
    }

    function testVoteForProposal() public {
        vm.startPrank(user1);
        gc.createProposel("increase food supply", 5 days);
        vm.stopPrank();

        vm.startPrank(user2);
        gc.vote(1, true);
        vm.stopPrank();

        (, , uint voteFor, , , , ) = gc.getProposal(1);
        assertEq(voteFor, 1000 ether); // user2 had 1000 tokens
    }

    function testExecuteProposalPasses() public {
        vm.startPrank(user1);
        gc.createProposel("Deploy new system", 1 days);
        gc.vote(1, true); // user1 votes for with 1000 tokens
        vm.warp(block.timestamp + 2 days); // move time forward
        gc.executeProposel(1);
        vm.stopPrank();

        (, , , , , bool executed) = gc.getProposal(1);
        assertTrue(executed);
    }
}
