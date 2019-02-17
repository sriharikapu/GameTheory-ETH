pragma solidity ^0.5.4;

import "./Withdrawal.sol";
//write player payouts to pendingWithdrawal mapping
// ex: pendingWithdrawal[address of player] = uint amount of payout

contract VolunteersDilemma is Withdrawal {
    address owner;
    address[5] player_addresses;
    uint current_player;
    uint bet;
    uint player_total;
    
    event Results(uint _ignorers, uint _reporters);
    
    constructor() public {
        owner = msg.sender;
        bet = 1000 szabo;
        player_total = 5;
        current_player = 0;
    } 
    
    mapping (address => uint8) players_vote;
    

    modifier owner_only {
        require(msg.sender==owner,"Owner only function.");
        _;
    }
    modifier new_player {
        //make sure the player is new
        require (players_vote[msg.sender]==0, "This player has already casted a vote this round.");
        _;
    }
    
    modifier enough_money{
        require(msg.value==bet, "Not enough ETH sent.");
        _;
    }
    
    function contract_balance() public view owner_only returns(uint){
        return (address(this).balance- payout_owed);
    }
    
    
    function act(uint8 _reported) public payable new_player enough_money{
        players_vote[msg.sender] = _reported; // reported should be 1 or 2
        player_addresses[current_player] = msg.sender;
        //check if end of voting period is here
        //currently based on max player reached
        current_player++;
        if (current_player == player_total){
            decide_winner();
        }
    }
    
    function decide_winner() internal {
        //find out what happened
        uint reporters;
        uint ignorers;
        uint shared_pot;

        //figure out score
        for (uint i=0; i < player_total; i++){
            if(players_vote[player_addresses[i]] == 1) {
                reporters++;
            }
            else{
                ignorers++;
            }
        }

        //distribute winnings based on score
        if (reporters == 0){
            //no value transfer, contract takes all
            reset_game();
        }
        else if (ignorers == 0){
            //team win! payout more than total pay in
            for (uint i=0; i< player_total; i++){
                if (players_vote[player_addresses[i]] == 1){
                    pendingWithdrawal[player_addresses[i]]+= bet + (bet/player_total);
                    payout_owed+=bet+(bet/player_total);
                    //incentive team win more by making the payout proportionate to the contract bank
                }
            }
            reset_game();
        }
        else {
            //booo its a mixed bag
            //iterate through each and assign payouts to ledger
            for (uint i=0; i< player_total; i++){
                if (players_vote[player_addresses[i]] == 1 ){
                    pendingWithdrawal[player_addresses[i]] += (bet/player_total);
                    payout_owed+= (bet/player_total);
                }
                else{
                    shared_pot = (bet/player_total)*(player_total*reporters-reporters);
                    pendingWithdrawal[player_addresses[i]] += bet + (shared_pot/(ignorers + 1));
                    payout_owed+= bet + (shared_pot/(ignorers + 1));
                }
            }
            reset_game();
        }
        emit Results(ignorers, reporters);
    }

    function reset_game() internal {
        current_player = 0;
        for (uint i=0; i < player_total; i++){
            delete players_vote[player_addresses[i]];
        }
    }
    
    
}

