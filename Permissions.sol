pragma solidity^0.5.3;

contract Permissions {
  address owner;
  mapping (address => mapping (address => bool)) public permissions;
  mapping (address => bool) receiverPermissionsGlobal;

  struct MedicalRecord {
    string name;
    address hospitalAddress;
    uint admissionDate;
    uint dischargeDate;
    string visitReason;
  }

  mapping (address => MedicalRecord) medicalRecordMap;

  constructor() public {
    owner = msg.sender;
  }

  modifier onlyUserWithoutPermission(address receiverAddress) {
    require(
        !permissionExists(receiverAddress),
        "Permission already granted for the user"
    );
    _;
  }

  modifier onlyUserWithPermission(address receiverAddress) {
    require(
        permissionExists(receiverAddress),
        "User does not have permission"
    );
    _;
  }

  event PermissionGranted(address indexed receiverAddress, bool result);
  event PermissionChecked(address indexed granterAddress, bool result);

  function grantPermission(address receiverAddress) public onlyUserWithoutPermission(receiverAddress) returns (bool) {
    bool result = false;
    mapping (address => bool) storage receiverPermissionsLocal = permissions[msg.sender];
    result = true;
    receiverPermissionsLocal[receiverAddress] = result;
    receiverPermissionsGlobal[receiverAddress] = result;
    emit PermissionGranted(receiverAddress, result);
    return result;
  }

  function hasPermission(address granterAddress) public view returns (bool) {
    mapping (address => bool) storage receiverPermissionsLocal = permissions[granterAddress];
    return receiverPermissionsLocal[msg.sender];
  }

  function permissionExists(address receiverAddress) internal view returns (bool) {
    return receiverPermissionsGlobal[receiverAddress];
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
