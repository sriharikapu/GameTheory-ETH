pragma solidity ^0.5.4

contract Withdrawal {
    mapping(address => uint) internal pendingWithdrawal;
    
    function withdraw() public returns(bool) {
        uint amount = pendingWithdrawal[msg.sender];
        if (amount > 0) {
            pendingWithdrawal[msg.sender] = 0;
            msg.sender.transfer(amount);
        }
        return true;
    }

}