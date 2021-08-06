// SPDX-License-Identifier: MIT 
// Solidity_Assignment#2, submitted by PIAIC114977 

pragma solidity ^0.8.0;

contract Bank {
    
    address public owner;
    
    
    modifier onlyOwner(){
        require(owner == msg.sender,"You are not owner");
        _;
    }
    
    
    modifier hasFunds(uint _ether){
        require(_ether <= accHandling[msg.sender].accBalanceOf,"Account has sufficient balance");
        require(_ether > 0 && msg.sender != address(0) && msg.sender != owner,"Ether should not be equal to zero or invalid address"); 
        _;
    }


struct Accounts{
    uint bankBalanceOf;
    uint accBalanceOf;
    bool accNew;
}

address[] custAccts;


// Step# 1 & 4:

mapping (address => Accounts) private accHandling;

constructor () payable{
    owner = msg.sender;
    require(msg.value >= 5 ether,"Ether value is less than 5");
}


// Step#2:

function bank_Close() public onlyOwner payable{
    selfdestruct(payable(owner));
}


// Step# 3 & 7:
function acct_open_bonus() public payable returns(uint){
    
    require(accHandling[msg.sender].accBalanceOf == 0,"Account already open");
    require(msg.sender != owner && msg.value > 0 ether && msg.sender != address(0), "Owner disallowed to open account && new Account can be open with at least 1 ether");
      
    if (custAccts.length <= 2){
    accHandling[msg.sender].accBalanceOf = msg.value + 1 ether;
    payable(msg.sender).transfer(1 ether);
    custAccts.push(msg.sender);
    } else {
        accHandling[msg.sender].accBalanceOf += msg.value;
    }

    Accounts memory account = accHandling[msg.sender];
    return account.accBalanceOf;
}


// Step#5:

function amount_deposit() public payable returns(uint){
    
    require(msg.sender != owner && msg.value >= 1 ether, "Owner disallowed to desposit ether && Deposit amount should be at least 1 ether");
    require(accHandling[msg.sender].accBalanceOf >= 0,"You don't have account");
    accHandling[msg.sender].accBalanceOf += msg.value;
    Accounts memory account = accHandling[msg.sender];
    accHandling[msg.sender].accNew=true;
    return account.accBalanceOf;
}



// Step#6

function withdraw(uint _ether) hasFunds(_ether) public payable returns(uint){
    
    payable(msg.sender).transfer(_ether);
    accHandling[msg.sender].accBalanceOf -= _ether;
    Accounts memory account = accHandling[msg.sender];
    return account.accBalanceOf;
}



// Step#8:

function acc_BalanceOf(address _address) public view returns(uint){
    Accounts memory account = accHandling[_address];
    return account.accBalanceOf;
} 



function bank_BalanceOf() public view returns(uint){
    return address(this).balance;
} 


// Step#9:

function acc_Close() public {
    require(accHandling[msg.sender].accBalanceOf > 0 && msg.sender != address(0),"Ether should not be equal to zero or invalid address");
    payable(msg.sender).transfer(accHandling[msg.sender].accBalanceOf);
    
}

}
