// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract Vote {

// first entity 
    struct Voter {
        string name;
        uint age;
        uint voterId;
        Gender gender;  //it's an enum
        uint voteCandidateId;  //candidate id to whom the voter has voted
        address voterAddress;  //EOA of voter
    }

// second entity
    struct Candidate {
        string name;
        string party;
        uint age;
        Gender gender;
        uint candidateId;
        address candidateAddress;  //EOA of candidate
        uint votes;  //number of voted
    }

//third entity
    address public electionCommission;

    address public winner;
    uint nextVoterId = 1;
    uint nextCandidateId = 1;

    // voting period
    uint startTime;
    uint endTime;
    bool stopVoting;


    mapping(uint => Voter) voterDetails;
    mapping(uint => Candidate) candidateDetails;


    enum VotingStatus {NotStarted, InProgress, Ended}
    enum Gender {NotSpecified, Male, Female, Other}


    constructor() {
        electionCommission = msg.sender; //msg.sneder is a global variable -- a pesona address who called this function
    }
    /* Confusion Solver functions */
    
    
    function calledByMsgSender() public view returns(address) {
        return msg.sender;
    }
    function blocktimestamp() public view returns (uint) {
        return block.timestamp;
    }
    function arrManipulation(uint[3] memory _arr) external pure returns(uint[3] memory) {
        _arr[0] = 3657;
        return _arr;
    }


    /* Confusion Solver functions */
    modifier isVotingOver() {
        require(block.timestamp >= endTime || stopVoting == true, "Voting time is Over");
      _;
    }


    modifier onlyCommissioner() {
        require(electionCommission == msg.sender, "You Have not the permission to execut this function");
        _;
    }

    modifier requireAgeLimit(uint _requireage) {
        require (_requireage >=18, "You are below 18");
        _;
    }


    function registerCandidate(
        string calldata _name,  //i do not need to make it mutable so using calldata
        string calldata _party,
        uint _age,
        Gender _gender
    ) external requireAgeLimit(_age) {
        // require (_age >=18, "You are below 18");
        require(isCandidateNotRegistered(msg.sender),"You are already registered");
        require(nextCandidateId<3,"Candidate Registration fulled , i.e. 2");
        require(msg.sender!= electionCommission, "Election commision not allowed to register");
       candidateDetails[nextCandidateId] = Candidate(
        {
            name: _name, 
            party : _party,
            age : _age, 
            gender :_gender,
            candidateId : nextCandidateId, 
            candidateAddress :  msg.sender, 
            votes :0
        });
        nextCandidateId++;
    }


    function isCandidateNotRegistered(address _person) internal view returns (bool) {
         for (uint i=1; i< nextCandidateId; i++) {
            if(candidateDetails[i].candidateAddress == _person) {
                return false;
            }
         }
         return true;  
    }

    
    
    function getCandidateList() public view returns (Candidate[] memory) {
        // we can't return while mapping , if array so we can...
        // solution - we will create a array and then return it 


        Candidate[] memory candidateList = new Candidate[](nextCandidateId - 1);   //intitlilize an emplty aray of length
        for(uint i=0; i < candidateList.length; i++) {
            candidateList[i] = candidateDetails[i+1];
        }
        return candidateList;
    }


    //make it private or internal 
    function isVoterNotRegistered(address _person) internal view returns (bool) {
         for (uint i=1; i< nextVoterId; i++) {
            if(voterDetails[i].voterAddress == _person) {
                return false;
            }
         }
         return true;  
    }

    function registerVoter(
        string calldata _name,
        uint _age,
        Gender _gender
    ) external requireAgeLimit(_age) {
        // require (_age >=18, "You are below 18");
        require(isVoterNotRegistered(msg.sender),"You are already registered");
        require(msg.sender!= electionCommission, "Election commision not allowed to register");

        voterDetails[nextVoterId] = Voter(
            {
                name :_name,
                age :_age,
                voterId: nextVoterId,
                gender : _gender,
                voteCandidateId: 0,
                voterAddress : msg.sender
            });
        nextVoterId++;
    }


    function getVoterList() public view returns (Voter[] memory) {
        Voter[] memory voterlist = new Voter[](nextVoterId - 1);   //intitlilize an emplty aray of length
        for(uint i=0; i < voterlist.length; i++) {
            voterlist[i] = voterDetails[i+1];
        }
        return voterlist;
    }


    function castVote(uint _voterId, uint _candidateId) external {
        require(voterDetails[_voterId].voteCandidateId == 0, "You have already voted");
        require(voterDetails[_voterId].voterAddress == msg.sender,"You are not autorizd");
        require(_candidateId > 0 && _candidateId < 3, "Candidate Id is not correct");
        voterDetails[_voterId].voteCandidateId  = _candidateId;  //votingn to candidiate id 
        candidateDetails[_candidateId].votes++;  // incrememnt _candidateId votes
    }


    function setVotingPeriod(uint _startTime, uint _endTime) external onlyCommissioner() {
        // require(_startTime < endTime, "Invalida time period");
        require(_endTime > 3600, "_endtime duration must be greater than 1 hour");
        startTime = block.timestamp+_startTime;  //_startTime = 0, endTime = 3600
        endTime = startTime+_endTime;
    }


    function getVotingStatus() public view returns (VotingStatus) {
        if(startTime == 0) {
            return VotingStatus.NotStarted;
        } else if(endTime > block.timestamp && stopVoting == false) {
            return VotingStatus.InProgress;
        } else {
            return VotingStatus.Ended;
        }
    }


    function announceVotingResult() external onlyCommissioner() {
        uint max =0;
        for(uint i=0; i<nextCandidateId;i++) {
            if(candidateDetails[i].votes > max) {
                max = candidateDetails[i].votes;
                winner = candidateDetails[i].candidateAddress;
            }
        }

    }


    function emergencyStopVoting() public onlyCommissioner() {
       stopVoting = true;
    }
}

/** 
deployed address /. commision adderss - 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4
first candidate - 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2 
second candidate - 0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db 

1st voter - 0xdD870fA1b7C4700F2BD7f44238821C26f7392148
2nd. voter - 0x583031D1113aD414F02576BD6afaBfb302140225
*/









