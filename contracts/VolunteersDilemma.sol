pragma solidity ^0.5.4;

import "./Withdrawal.sol";
//write player payouts to pendingWithdrawal mapping
// ex: pendingWithdrawal[address of player] = uint amount of payout

contract VolunteersDilemma is Withdrawal {
    address owner;
    address[3] player_addresses
    uint current_player;
    uint bet;
    uint player_total;
    
    event Results(uint _ignorers, uint _reporters);
    
    constructor() public {
        owner = msg.sender;
        bet = 1000 wei;
        player_total = 3;
        current_player = 0;
    } 
    
    mapping (address => uint8) players_vote;
    

    modifier new_player {
        //make sure the player is new
        require (players_vote[msg.sender]==0);
        _;
    }
    
    modifier enough_money{
        require(msg.value==bet);
        _;
    }
    
    
    function act(uint8 _reported) public payable new_player enough_money{
        players_vote[msg.sender] = _reported; // reported should be 1 or 2
        player_addresses[current_player] = msg.sender
        //check if end of voting period is here
        //currently based on max player reached
        current_player++;
        if (current_player == player_total){
            decide_winner();
        }
    }
    
    function decide_winner() internal {
        //find out at h whppened
        uint reporters;
        uint ignorers;
        uint shared_pot;

        //figure out score
        for (uint i=0; i < player_total; i++){
            if(players_vote[player_addresses[i]].reported){
                reporters++;
            }
            else{
                ignorers++;
            }
        }

        //distribute winnings based on score
        if (reporters == 0){
            //transfer money to the mastercontract/bank;
            reset_game()
        }
        else if (ignorers == 0){
            for (uint i=0; i< player_total; i++){
                if (players_vote[player_addresses[i]].reported){
                    pendingWithdrawal[player_addresses[i]]=bet + (bet/player_total);
                    //figure out withdrawing from the pot
                }
            }
            reset_game()
        }
        else {
            for (uint i=0; i< player_total; i++){
                if (players_vote[player_addresses[i]].reported){
                    pendingWithdrawal[player_addresses[i]]=(bet/player_total);
                }
                else{
                    shared_pot = (bet/player_total)*(player_total*reporters-reporters);
                    pendingWithdrawal[player_addresses[i]]+=bet+(shared_pot/(ignorers+1));
                }
            }
            reset_game()
        }
        //delete players_vote[address]
    }

    function reset_game() {
        current_player = 0;
        for (uint i=0; i < player_total; i++){
            delete players_vote[player_addresses[i]];
        }
    }
}

