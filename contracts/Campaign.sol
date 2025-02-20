// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract Campaign {

   struct Request {
      string description;
      uint value;
      address payable receiver;
      bool closed;
      string outcome;
   }
   uint32 public approversCount = 0;
   uint256 public version=0;//map versions
   mapping(uint256 =>mapping(address=>uint32)) public approvers;
   mapping(uint256 =>mapping(address=>uint32)) public approvals;
   address public manager;
   Request[] public requests;
   uint32 public approvedCount; 



   constructor (){
      manager=msg.sender;
   }

   function donate() external payable{
      require(msg.value > 0.0009 ether,"You need to send atleast 0.001 ether");
      approversCount = approversCount+1;
      approvers[version][msg.sender]=approversCount;
   }

   function requestSpending (string memory description, uint value, address payable receiver) external restrictManagers {
      Request memory newRequest = Request({
         description:description,
         value:value,
         receiver:receiver,
         closed:false,
         outcome:"pending"
      });

      requests.push(newRequest);
   }

   function approveSpending(bool approve) external restrictApprovers {
      approvals[version][msg.sender]=approvers[version][msg.sender];
      if(approve){
         approvedCount+=1;
      }
   }

   function closeCampaign() external {
      require(manager==msg.sender, "You are not the manager. Only the manager can trigger this method");

      string memory outcome = approvedCount>approversCount/2?"Approved":"Rejected";

      Request memory currentReq = requests[requests.length-1];

      if(keccak256(abi.encodePacked(outcome)) == keccak256(abi.encodePacked("Approved"))){
         currentReq.receiver.transfer(currentReq.value);
      }

      requests[requests.length-1].outcome = outcome;

      requests[requests.length-1].closed = true;

      version+=1;
      approversCount=0;
      approvedCount=0;
   }

   modifier restrictManagers(){
      require(manager==msg.sender, "You are not the manager. Only the manager can trigger this method");
      require(requests.length<1||requests[requests.length-1].closed, "Please close the prev request.");
      _;
   }

   modifier restrictApprovers(){
      bool isApprover = approvers[version][msg.sender]!=0;
      bool canVote = false;

      require(isApprover, "You are not an approver. Only the approvers can trigger this method");
      canVote = requests.length>0 && !requests[requests.length-1].closed;
      require(canVote,"There is no request open for approval.");
      canVote = approvals[version][msg.sender]==0;
      require(canVote, "You have already voted");
      _;
   }
}