// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;


//CA - 0x2F3b05feF6265F8574CbC9900A8c581c993fEae6


/**
Transaction hisrioty 
 -- from, to, timing, amount 
 1. event, 2, struct  3. array of struct 4. mapping 
*/

contract SimpleWallet {
   
    address public owner;
    string public str;
    bool public stop;

    struct Transaction {
        address from;
        address to;
        uint timestamp;
        uint amount;
    }
    Transaction[] public transactionHistory;


    event Transfer(address reciever, uint amount);
    event Recieve(address reciever, uint amount);
    event recivefromuser(address sender, address reciever, uint amount);

    constructor(){
        owner=msg.sender;  //a person who deployed the smart contract 
    }


    modifier onlyOwner() {
        require(msg.sender == owner,"You don't have access");
        _;
    }

    function changeOwner(address newOwner) public onlyOwner{
        owner = newOwner;
    }
    function togleEmergency() external {
        stop=!stop;
    }

    modifier isEmergencyDeclared() {
        require(stop==false, "Emergency Declared");
        _;
    }
   
    /**Contract related functions
    ---only works after - 28 July  10:12 PM 
    **/
    function transferToContract() external payable  {
        require(block.timestamp > 1721490966, "send after 10:30 PM");
        transactionHistory.push(Transaction({
            from:msg.sender,
            to:address(this),
            timestamp:block.timestamp,
            amount:msg.value
        }));
    }




    function transferToUserViaContract(address payable _to, uint _weiAmount) external onlyOwner {
        require(address(this).balance>=_weiAmount,"Insufficient Balance");
        require(_to != address(0), "Address fomrat is not good");
        _to.transfer(_weiAmount);


        transactionHistory.push(Transaction({
            from:msg.sender,
            to:_to,
            timestamp:block.timestamp,
            amount:_weiAmount
        }));

        
        emit Transfer( _to,_weiAmount);
    }




    function withdrawFromContract(uint _weiAmount) external onlyOwner {
       require(address(this).balance >= _weiAmount, "Insuffficient balance");

        transactionHistory.push(Transaction({
            from:address(this),
            to:owner,
            timestamp:block.timestamp,
            amount:_weiAmount
        }));

        
       payable(owner).transfer(_weiAmount);
    }




    function getContractBalanceInWei() external view returns (uint) {
         return address(this).balance;
    }
   
     /**User related functions**/
    function transferToUserViaMsgValue(address _to) external payable {
       require(address(this).balance>=msg.value,"Insufficient Balance");

        transactionHistory.push(Transaction({
            from:address(this),
            to:_to,
            timestamp:block.timestamp,
            amount:msg.value
        }));
       payable (_to).transfer(msg.value);
    }




    function receiveFromUser() external payable {
       require( msg.value > 0, "Wei value must be greate than 0");
       payable (owner).transfer(msg.value);

       transactionHistory.push(Transaction({
            from:msg.sender,
            to:address(this),
            timestamp:block.timestamp,
            amount:msg.value
        }));
       emit recivefromuser(msg.sender, owner, msg.value);

    }




    function getOwnerBalanceInWei() external view returns(uint){
       return owner.balance * 10e18;
    }




    receive() external payable {
        transactionHistory.push(Transaction({
            from:msg.sender,
            to:address(this),
            timestamp:block.timestamp,
            amount:msg.value
        }));
       emit Recieve(msg.sender, msg.value);
    }




    fallback() external  {
      str = "fallback function is called";  
    }

    function getTransactionHistory() external view returns(Transaction[] memory) {
        return transactionHistory;
    }

    function emergencyWithdrawl() external {
        require(stop == true, "Emergency not declared");
        payable (owner).transfer(address(this).balance); // trnsafer all money from contract 
    }




}


//Add the following features
//1.List of receivers with amount
//2.List of transfers with amount















