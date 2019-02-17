pragma solidity ^0.5.4;

contract Withdrawal {
    mapping(address => uint) internal pendingWithdrawal;
    uint payout_owed;
    
    function withdraw() public returns(bool) {
        uint amount = pendingWithdrawal[msg.sender];
        if (amount > 0) {
            pendingWithdrawal[msg.sender] = 0;
            payout_owed-=amount;
            msg.sender.transfer(amount);
        }
        return true;
    }
    
    function check_balance() public view returns(uint){
        return pendingWithdrawal[msg.sender];
    }

}