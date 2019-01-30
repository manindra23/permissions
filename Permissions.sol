pragma solidity^0.5.3;

contract Permissions {
  address owner;
  mapping (address => address[5]) public permissions;
  uint8 count;

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

  function grantPermission(address publicAddress) public returns (bool) {
    address[5] storage addressArray = permissions[msg.sender];
    if(count < 5) {
        addressArray[count] = publicAddress;
    }
    count = count + 1;
    return true;
  }

  function hasPermission(address publicAddress) public view returns (bool) {
    address[5] memory addressArray = permissions[publicAddress];
    for(uint i = 0; i < 5; i++) {
      if(addressArray[i] == msg.sender) {
        return true;
      }
    }
    return false;
  }
}
