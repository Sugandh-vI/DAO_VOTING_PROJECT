# Decentralized Voting System

## Description
A Solidity-based decentralized voting system enabling users to create proposals, vote on multiple options, and determine winners transparently. Votes are securely recorded on-chain, with tie-handling and real-time vote tracking. Built on Remix IDE, demonstrating blockchain governance, immutability, and decentralized decision-making.

## Features
- Create proposals with multiple options
- Secure on-chain voting using Ethereum addresses
- Prevents double voting per proposal
- Tracks votes in real-time
- Handles ties by returning all tied winners
- Get current votes for all options before deadline
- Transparent winner declaration after voting ends

## Functions

### `createProposal(string _description, string[] _options, uint _duration)`
- Creates a new proposal with a description, options, and duration (in seconds)
- Initializes vote counts for all options
- Emits `ProposalCreated` event

### `vote(uint _proposalId, string _option)`
- Cast a vote for a valid option in a proposal
- Ensures one vote per address
- Emits `VoteCast` event

### `getWinners(uint _proposalId) view returns (string[] memory)`
- Returns the winning option(s) after the voting deadline
- Handles ties by returning all options with highest votes

### `getVotes(uint _proposalId) view returns (string[] memory, uint[] memory)`
- Returns current votes for all options, even before the deadline

### `getOptions(uint _proposalId) view returns (string[] memory)`
- Returns all options of a proposal

### `getCurrentTimestamp() view returns (uint)`
- Returns the current blockchain timestamp

## Technologies Used
- **Solidity** for smart contract development
- **Remix IDE** for testing and deployment
- **Ethereum Testnet** (optional) for deployment
- Concepts: Decentralized governance, immutability, transparency

## How It Works
1. Users create a proposal with multiple voting options.
2. Participants vote by selecting an option using their Ethereum address

