// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Project {
    struct Candidate {
        string name;
        uint256 voteCount;
    }

    address public owner;
    bool public votingOpen;
    Candidate[] public candidates;
    mapping(address => bool) public hasVoted;

    // Events
    event VoteCast(address voter, uint256 candidateIndex);
    event VotingStatusChanged(bool isOpen);

    constructor() {
        owner = msg.sender;
        votingOpen = true;

        // Hardcoded candidates (no external input)
        candidates.push(Candidate("Alice", 0));
        candidates.push(Candidate("Bob", 0));
        candidates.push(Candidate("Charlie", 0));
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not contract owner");
        _;
    }

    modifier whenVotingOpen() {
        require(votingOpen, "Voting is closed");
        _;
    }

    // Vote for a candidate by index (0,1,2)
    function vote(uint256 _candidateIndex) external whenVotingOpen {
        require(!hasVoted[msg.sender], "Already voted");
        require(_candidateIndex < candidates.length, "Invalid candidate");

        hasVoted[msg.sender] = true;
        candidates[_candidateIndex].voteCount += 1;

        emit VoteCast(msg.sender, _candidateIndex);
    }

    // Owner can open or close voting
    function setVotingOpen(bool _isOpen) external onlyOwner {
        votingOpen = _isOpen;
        emit VotingStatusChanged(_isOpen);
    }

    // Returns the index of the candidate with the highest votes
    function getWinningCandidate() external view returns (uint256 winnerIndex) {
        uint256 highestVotes = 0;
        uint256 winningIdx = 0;

        for (uint256 i = 0; i < candidates.length; i++) {
            if (candidates[i].voteCount > highestVotes) {
                highestVotes = candidates[i].voteCount;
                winningIdx = i;
            }
        }

        return winningIdx;
    }

    // Helper to get number of candidates
    function getCandidatesCount() external view returns (uint256) {
        return candidates.length;
    }
}

