pragma solidity ^0.8;

contract SmartVoting {

// 1.voter with bool voted, uint weight(for auth purpose), uint voteindex(whom he voted)
// 2.candidate with id, and votecount(no of votes it got)
// 3.one owner to authorize the voter
// 4.a constructer/function to fix the owner, put the candidates, fix the timeDuration of election, name of election,
// 5. a function where owner auth voters
// 6.a func where voting is being given
// 7.a func to declare the winner as the election gets over
// 8.once ended . its ended

    struct Voter{
        bool voted;
        uint votedTo;
        uint weight;
    }
    struct candidate {
        uint id;
        uint voteCount;
    }
    address public owner;
    string Ename;
    uint auctionEnd;
    mapping( address=> Voter) voters;
    candidate[] candidates; 
    uint[] winner;
    bool electionEnded;

    constructor(string memory Ename_, uint noOfcandidate, uint Etime_) public {
        Ename = Ename_;
        owner = (msg.sender);
        auctionEnd = block.timestamp + (Etime_ * 1 minutes);
        for( uint i=0; i<noOfcandidate; i++){
            candidates.push(candidate(i,0));
        }
    }
        
    function authorize(address voter_) public {
        require((msg.sender) == owner);
        voters[voter_].weight = 1;
    }

    function vote(uint cid) public {
        require(voters[msg.sender].voted==false);
        require(voters[msg.sender].weight == 1);
        
        candidates[cid].voteCount += voters[msg.sender].weight;
        voters[msg.sender].voted = true;
        voters[msg.sender].votedTo = cid;
    }

    function electionEnd() public returns(uint[] memory ) {
        require((msg.sender) == owner);
        require(block.timestamp >= auctionEnd);
        require(electionEnded == false);

        uint maxVotes = candidates[0].voteCount;
        
        for(uint i=0; i<candidates.length; i++){
            if(candidates[i].voteCount > maxVotes){
                maxVotes = candidates[i].voteCount;
            }
        }
        for(uint i=0; i<candidates.length; i++){//another loop in case more than one winner
            if(candidates[i].voteCount == maxVotes){
                winner.push(candidates[i].id);
            }
        }  
        electionEnded = true;  
        return winner;
    }
   
}
