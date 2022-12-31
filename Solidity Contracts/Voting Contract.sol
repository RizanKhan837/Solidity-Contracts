// SPDX-License-Identifier: UNLICENSED

pragma solidity >=0.4.22 <0.9.0;

contract VotingApp{
    mapping (string => string) voters;
    mapping (string => uint) status;
    address owner = msg.sender;
    string[] voterName;

    modifier onlyOwner{
        require(owner == msg.sender, "You're Not An Owner");
        _;
    }
    // function to determine if there is any duplicate voter
    modifier checkDuplicates(string memory _voterName){
        for (uint i=0; i< voterName.length; i++){
            require(keccak256(abi.encodePacked(_voterName)) != keccak256(abi.encodePacked(voterName[i])), "You've Already Voted...");
        }
        _;
    }

    struct Votes{
        string name;
        string party;
        uint age;
    }

    Votes[] public totalVotes;

    // function to vote for a party 
    function Vote(string memory _name, string memory _party, uint _age) public checkDuplicates(_name) returns(string memory){
        require(_age >= 18, "You Can't Vote...");
        require(keccak256(abi.encodePacked(_party)) == keccak256(abi.encodePacked("MQM")) || 
                keccak256(abi.encodePacked(_party)) == keccak256(abi.encodePacked("PPP")) || 
                keccak256(abi.encodePacked(_party)) == keccak256(abi.encodePacked("PMLN")) , "Party Not IN The List...");
        totalVotes.push(Votes(_name, _party, _age));
        voterName.push(_name);
        voters[_name] = _party;
        status[_party]++;
        return "Your Vote Has Been Submitted";
    }
    // function to show the total votes
    function showStatus(string memory _party) public view onlyOwner returns(uint){
        return status[_party];
    }
}