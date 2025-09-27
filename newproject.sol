// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

contract Voting {

    struct Proposal {
        address creator;          // Address who created the proposal
        string description;       // Proposal description
        string[] options;         // List of options to vote for
        mapping(string => uint) votes; // Mapping from option to vote count
        mapping(address => bool) hasVoted; // Track if an address has voted
        uint deadline;            // Timestamp when voting ends
        bool exists;              // Check if proposal exists
    }

    uint public proposalCount;
    mapping(uint => Proposal) public proposals;

    // Event emitted when a new proposal is created
    event ProposalCreated(uint proposalId, address indexed creator, uint deadline, string description);

    // Event emitted when a vote is cast
    event VoteCast(uint proposalId, address indexed voter, string option);

    // Create a proposal with options and duration (in seconds)
    function createProposal(string memory _description, string[] memory _options, uint _duration) external returns(uint) {
        require(_options.length >= 2, "At least 2 options required");
        require(_duration > 0, "Duration must be positive");

        Proposal storage p = proposals[proposalCount];
        p.creator = msg.sender;
        p.description = _description;
        p.deadline = block.timestamp + _duration;
        p.exists = true;

        for(uint i = 0; i < _options.length; i++) {
            p.options.push(_options[i]);
            p.votes[_options[i]] = 0; // initialize vote count
        }

        emit ProposalCreated(proposalCount, msg.sender, p.deadline, _description);
        proposalCount++;
        return proposalCount - 1;
    }

    // Vote for an option in a proposal
    function vote(uint _proposalId, string memory _option) external {
        Proposal storage p = proposals[_proposalId];
        require(p.exists, "Proposal does not exist");
        require(block.timestamp <= p.deadline, "Voting is over");
        require(!p.hasVoted[msg.sender], "Already voted");

        bool validOption = false;
        for(uint i = 0; i < p.options.length; i++) {
            if(keccak256(bytes(p.options[i])) == keccak256(bytes(_option))) {
                validOption = true;
                break;
            }
        }
        require(validOption, "Invalid option");

        p.votes[_option]++;
        p.hasVoted[msg.sender] = true;

        emit VoteCast(_proposalId, msg.sender, _option);
    }

    function getWinners(uint _proposalId) public view returns (string[] memory) {
        Proposal storage p = proposals[_proposalId];
        require(block.timestamp > p.deadline, "Voting is still ongoing");

        uint highestVotes = 0;
        uint tieCount = 0;

        // First, find the highest vote count
        for (uint i = 0; i < p.options.length; i++) {
            if (p.votes[p.options[i]] > highestVotes) {
                highestVotes = p.votes[p.options[i]];
            }
        }

        // Count how many options have the highest votes
        for (uint i = 0; i < p.options.length; i++) {
            if (p.votes[p.options[i]] == highestVotes) {
                tieCount++;
            }
        }

        // Collect all tied winners
        string[] memory winners = new string[](tieCount);
        uint index = 0;
        for (uint i = 0; i < p.options.length; i++) {
            if (p.votes[p.options[i]] == highestVotes) {
                winners[index] = p.options[i];
                index++;
            }
        }

        return winners;
    }


    // Get current votes for all options (even before deadline)
    function getVotes(uint _proposalId) external view returns(string[] memory optionList, uint[] memory voteCounts) {
        Proposal storage p = proposals[_proposalId];
        require(p.exists, "Proposal does not exist");

        uint len = p.options.length;
        uint[] memory counts = new uint[](len);

        for(uint i = 0; i < len; i++) {
            counts[i] = p.votes[p.options[i]];
        }

        return (p.options, counts);
    }

    // Get all options of a proposal
    function getOptions(uint _proposalId) external view returns(string[] memory) {
        Proposal storage p = proposals[_proposalId];
        require(p.exists, "Proposal does not exist");
        return p.options;
    }

    // Function to get current block timestamp
    function getCurrentTimestamp() public view returns (uint) {
        return block.timestamp;
    }
}
