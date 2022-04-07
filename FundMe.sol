// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract FundMe{
    address public owner;
    string ownerName;
    uint256 totalFunds;
    uint256 public minimumETH = 2; 

    uint256 userCount;
    bool paidUser;
    uint256 fundAmount;

    struct User {
        address userAddress;
        uint256 funds;
    }
    //mapping(address=>uint256) public userToFunds;

    User[] public users;   

    constructor(){
        owner = msg.sender;
        minimumETH = 2; 
    }

    modifier onlyOwner {
        require(msg.sender==owner);
        _;
    }

    modifier onlyPaidUser {
        require(paidUser == true);
        _;
    }

    function fund() public payable {
        payable(owner).transfer(msg.value);
        require(msg.value >= 2 ether);
        users.push(User(msg.sender, msg.value));
        totalFunds += msg.value;
    }

    function seeAllFundsAndFunders() public view returns(User[] memory) {
        return(users);
    }

    function changeMinimumFund(uint256 _minAmount) public onlyOwner{
        minimumETH = _minAmount;
    }

    function withdraw() public onlyOwner{
        (bool sent, bytes memory data) = owner.call{value: fundAmount}("");
        require(sent, "Sorry could not withdraw funds.");
    }

    function currentFunds() public view returns(uint256) {
        return totalFunds;
    }
}
