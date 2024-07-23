// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;


//CA - 0x2F3b05feF6265F8574CbC9900A8c581c993fEae6




contract SimpleWallet {
   
    address public owner;
    string public str;

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
   
    /**Contract related functions**/
    function transferToContract() external payable  {
        //reciving eth from address to smart contract -  Contract Account
        str = "Amount Transferred to the contracts";
    }




    function transferToUserViaContract(address payable _to, uint _weiAmount) external onlyOwner {
        require(address(this).balance>=_weiAmount,"Insufficient Balance");
        _to.transfer(_weiAmount);
        emit Transfer( _to,_weiAmount);
    }




    function withdrawFromContract(uint _weiAmount) external onlyOwner {
       require(address(this).balance >= _weiAmount, "Insuffficient balance");
       payable(owner).transfer(_weiAmount);
    }




    function getContractBalanceInWei() external view returns (uint) {
         return address(this).balance;
    }
   
     /**User related functions**/
    function transferToUserViaMsgValue(address _to) external payable {
       require(address(this).balance>=msg.value,"Insufficient Balance");
       payable (_to).transfer(msg.value);
    }




    function receiveFromUser() external payable {
       require( msg.value > 0, "Wei value must be greate than 0");
       payable (owner).transfer(msg.value);
       emit recivefromuser(msg.sender, owner, msg.value);

    }




    function getOwnerBalanceInWei() external view returns(uint){
       return owner.balance * 10e18;
    }




    receive() external payable {
       emit Recieve(msg.sender, msg.value);
    }




    fallback() external  {
      str = "fallback function is called";  
    }




}


//Add the following features
//1.List of receivers with amount
//2.List of transfers with amount















