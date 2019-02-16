pragma solidity ^0.5.4;

import "./Withdrawal.sol";
//write player payouts to pendingWithdrawal mapping
// ex: pendingWithdrawal[address of player] = uint amount of payout

contract VolunteersDilemma is Withdrawal {
    address owner;
    uint bet = 1000 wei;
    uint player_number = 3;
    uint current_players = 0;
    
    constructor() public {
        owner = msg.sender;
    } 
    
    struct Player {
        bool reported;
        bool voted;
        address addr;
        uint payout;
        bool withdrawn;
    }

    
    mapping (address => Player) players;
    

    modifier new_player {
        //make sure the player is new
        require (players[msg.sender].voted==false);
        _;
    }
    
    function act(bool _reported) public payable new_player {
        players[msg.sender].voted = true;
        players[msg.sender].reported = _reported;
        players[msg.sender].addr = msg.sender;
        
        //check if end of voting period is here
        //currently based on max player reached
        current_players++;
        if (current_players == player_number){
            decide_winner();
        }
    }
    
    function decide_winner() internal {
        //find out what happened
        for (uint i=0; i< player_number; i++){
            
        }
        outcome = {1,2,3}
        
        1:
            everybody wins
        2:
            everybody loses
        3:
            iterate through each user's payout
        
    }
}
pragma solidity ^0.5.4;

import "./Withdrawal.sol";
//write player payouts to pendingWithdrawal mapping
// ex: pendingWithdrawal[address of player] = uint amount of payout

contract VolunteersDilemma is Withdrawal {
    address owner;
    uint bet = 1000 wei;
    uint player_number = 3;
    uint current_players = 0;
    
    constructor public {
        owner = msg.sender;
    } 
    
    struct Player {
        bool reported;
        bool voted;
        address addr;
        uint payout;
        bool withdrawn;
    }

    
    mapping (address => Player) players;
    

    modifier new_player {
        //make sure the player is new
        require (players[msg.sender].voted==false);
        _;
    }
    
    function act(bool _reported) public payable new_player {
        players[msg.sender].voted = true;
        players[msg.sender].reported = _reported;
        players[msg.sender].addr = msg.sender;
        
        //check if end of voting period is here
        //currently based on max player reached
        current_players++;
        if (current_players == player_number){
            decide_winner();
        }
    }
    
    function decide_winner() internal {
        //find out what happened
        for (uint i=0; i< player_number; i++){
            
        }
        outcome = {1,2,3}
        
        1:
            everybody wins
        2:
            everybody loses
        3:
            iterate through each user's payout
        
    }
}
