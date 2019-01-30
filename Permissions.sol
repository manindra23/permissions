pragma solidity^0.5.3;

contract Permissions {
  address owner;
  //Mapping between granter address and receiver map which in turn
  //contains mapping between receiver address and his/her permission
  mapping (address => mapping (address => bool)) public granterReceiverPermissionsMap;
  //Mapping between receiver address and his/her permission
  mapping (address => bool) receiverPermissionsMapGlobal;

  //Entity to be accessed based on permission
  struct MedicalRecord {
    string name;
    address hospitalAddress;
    uint admissionDate;
    uint dischargeDate;
    string visitReason;
  }

  //Mapping between receiverAddress and his/her MedicalRecord
  mapping (address => MedicalRecord) medicalRecordMap;

  constructor() public {
    owner = msg.sender;
  }

  modifier onlyUserWithoutPermission(address receiverAddress) {
    require(
        !receiverPermissionsMapGlobal[receiverAddress],
        "Permission already granted for the user"
    );
    _;
  }

  modifier onlyUserWithPermission(address receiverAddress) {
    require(
        receiverPermissionsMapGlobal[receiverAddress],
        "User does not have permission"
    );
    _;
  }

  event PermissionGranted(address indexed receiverAddress, bool result);
  event PermissionChecked(address indexed granterAddress, bool result);

  function grantPermission(address receiverAddress) public onlyUserWithoutPermission(receiverAddress) returns (bool) {
    bool result = false;
    mapping (address => bool) storage receiverPermissionsMapLocal = granterReceiverPermissionsMap[msg.sender];
    result = true;
    receiverPermissionsMapLocal[receiverAddress] = result;
    receiverPermissionsMapGlobal[receiverAddress] = result;
    emit PermissionGranted(receiverAddress, result);
    return result;
  }

  function hasPermission(address granterAddress) public view returns (bool) {
    mapping (address => bool) storage receiverPermissionsMapLocal = granterReceiverPermissionsMap[granterAddress];
    return receiverPermissionsMapLocal[msg.sender];
  }

  function viewMedicalRecord() public view onlyUserWithPermission(msg.sender) returns (string memory, address, uint, uint, string memory) {
    MedicalRecord memory medicalRecord = medicalRecordMap[msg.sender];
    return (medicalRecord.name, medicalRecord.hospitalAddress, medicalRecord.admissionDate, medicalRecord.dischargeDate, medicalRecord.visitReason);
  }

  function addMedicalRecord(string memory name, address hospitalAddress, uint admissionDate, uint dischargeDate, string memory visitReason) public onlyUserWithPermission(msg.sender) returns (bool) {
      MedicalRecord memory medicalRecord;
      medicalRecord.name = name;
      medicalRecord.hospitalAddress = hospitalAddress;
      medicalRecord.admissionDate = admissionDate;
      medicalRecord.dischargeDate = dischargeDate;
      medicalRecord.visitReason = visitReason;

      medicalRecordMap[msg.sender] = medicalRecord;
      return true;
  }
}
