// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract GovernanceContract {
    IERC20 public govToken;
    uint public proposalCount;

    struct Proposal {
        uint id;
        string description;
        uint voteFor;
        uint voteAgainst;
        uint endTime;
        bool executed;
        mapping(address => bool) hasVoted;
    }

    mapping(uint => Proposal) public proposals;

    event ProposalCreated(uint id, string description, uint endTime);
    event Voted(uint id, address voter, bool support, uint weight);
    event ProposalExecuted(uint id, bool passed);

    constructor(address _token) {
        govToken = IERC20(_token);
    }

    function createProposal(string memory _description, uint _duration) public {
        proposalCount++;
        Proposal storage p = proposals[proposalCount];
        p.id = proposalCount;
        p.description = _description;
        p.endTime = block.timestamp + _duration;

        emit ProposalCreated(proposalCount, _description, p.endTime);
    }

    function vote(uint _id, bool _support) public {
        Proposal storage p = proposals[_id];
        require(block.timestamp < p.endTime, "Voting period has ended");
        require(!p.hasVoted[msg.sender], "You already voted");

        uint weight = govToken.balanceOf(msg.sender);
        require(weight > 0, "No voting power");

        if (_support) {
            p.voteFor += weight;
        } else {
            p.voteAgainst += weight;
        }

        p.hasVoted[msg.sender] = true;
        emit Voted(_id, msg.sender, _support, weight);
    }

    function executeProposal(uint _id) public {
        Proposal storage p = proposals[_id];
        require(block.timestamp >= p.endTime, "Voting still ongoing");
        require(!p.executed, "Proposal already executed");

        bool passed = p.voteFor > p.voteAgainst;
        p.executed = true;

        emit ProposalExecuted(_id, passed);
    }
}
