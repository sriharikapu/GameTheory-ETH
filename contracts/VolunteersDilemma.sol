pragma solidity ^0.5.4;

import "./Withdrawal.sol";
//write player payouts to pendingWithdrawal mapping
// ex: pendingWithdrawal[address of player] = uint amount of payout

contract VolunteersDilemma is Withdrawal {
    address owner;
    address[] player_addresses;
    uint current_players;
    uint bet;
    uint player_number;
    
    event Results(uint _ignorers, uint _reporters);
    
    constructor() public {
        owner = msg.sender;
        bet = 1000 wei;
        player_number = 3;
        
    } 
    
    struct Player {
        bool reported;
        bool voted;
        address addr;
    }

    
    mapping (address => Player) players;
    

    modifier new_player {
        //make sure the player is new
        require (players[msg.sender].voted==false);
        _;
    }
    
    modifier enough_money{
        require(msg.value==bet);
        _;
    }
    
    
    function act(bool _reported) public payable new_player enough_money{
        player_addresses.push(msg.sender);
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
        //find out at h whppened
        uint reporters;
        uint ignorers;
        uint shared_pot;
        for (uint i=0; i< player_number; i++){
            if(players[player_addresses[i]].reported){
                reporters++;
            }
            else{
                ignorers++;
            }
        }
        if (reporters == 0){
            //transfer money to the mastercontract/bank;
        }
        else if (ignorers == 0){
            for (uint i=0; i< player_number; i++){
                if (players[player_addresses[i]].reported){
                    pendingWithdrawal[player_addresses[i]]=bet + (bet/player_number);
                    //figure out withdrawing from the pot
                }
            }
        }
        else {
            for (uint i=0; i< player_number; i++){
                if (players[player_addresses[i]].reported){
                    pendingWithdrawal[player_addresses[i]]=(bet/player_number);
                }
                else{
                    shared_pot = (bet/player_number)*(player_number*reporters-reporters);
                    pendingWithdrawal[player_addresses[i]]+=bet+(shared_pot/(ignorers+1));
                }
            }
        }
    }
}

