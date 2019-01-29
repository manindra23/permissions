pragma solidity ^0.5.3;

contract Permissions {
  address owner;
  mapping (address => address[]) public permissions;

  struct MedicalRecord {
    string name;
    address patient;
    address hospital;
    uint256 admissionDate;
    uint256 dischargeDate;
    uint256 visitReason;
  }

  constructor() public {
    owner = msg.sender;
  }
}
