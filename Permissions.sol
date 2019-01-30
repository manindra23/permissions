pragma solidity^0.5.3;

contract Permissions {
  uint count;
  address owner;
  mapping (address => address[5]) public permissions;

  struct MedicalRecord {
    string name;
    address patient;
    address hospital;
    uint admissionDate;
    uint dischargeDate;
    string visitReason;
  }

  event PermissionGranted(address indexed publicAddress, bool result);
  event PermissionChecked(address indexed publicAddress, bool result);

  constructor() public {
    owner = msg.sender;
  }

  function grantPermission(address publicAddress) public returns (bool) {
    bool result = false;
    address[5] storage addressArray = permissions[msg.sender];
    require(count < 5, "Maximum limit reached for granting permission. Not enough space to store any more addresses.");
    addressArray[count] = publicAddress;
    count = count + 1;
    result = true;
    emit PermissionGranted(publicAddress, result);
    return result;
  }

  function hasPermission(address publicAddress) public view returns (bool) {
    bool result = false;
    address[5] storage addressArray = permissions[publicAddress];
    for(uint i = 0; i < 5; i++) {
      if(addressArray[i] == msg.sender) {
        result = true;
        return result;
      }
    }
    result = false;
    return result;
  }
}
