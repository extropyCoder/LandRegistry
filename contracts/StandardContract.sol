contract Owned  {
  address owner;
  modifier onlyOwner() {
    if (msg.sender==owner) _
  }
  function owned() {
    owner = msg.sender;
  }
  function changeOwner(address newOwner) onlyOwner {
    owner = newOwner;
  }

  function getOwner() constant returns (address){
    return owner;
  }
}

contract Mortal is Owned {
  function kill() {
    if (msg.sender == owner) suicide(owner);
  }
}

contract Active is Owned{
  bool active;

  modifier isActive(){if (active==true || msg.sender==owner)  _}

  function setActive(bool _active) onlyOwner {
    active = _active;
  }

}

contract Permissionable  {
    PermissionsDB permissionsDB;

    modifier hasAdminRights(address _contract,address _user){if(permissionsDB.hasAdminRights(_user)==true) _}
    modifier hasWriteRights(address _contract,address _user){if(permissionsDB.hasWriteRights(_contract,_user)==true) _}
    modifier hasReadRights (address _contract,address _user){if(permissionsDB.hasReadRights (_contract,_user)==true) _}

    function setPermissionsDB(PermissionsDB _permissionsDB){
      permissionsDB  = _permissionsDB;
    }

}

contract StandardContract is Owned,Mortal,Active,Permissionable{
    NameRegistry registry;
    string SECURITY_NAME = "s43agdius";
    string LOGGER_NAME = "g73kdjh856";

    Logger logger;


    function StandardContract(){
      owned();
    }


    function activateContract(NameRegistry _registry) onlyOwner{
        registry = _registry;
        PermissionsDB permissionsDB = PermissionsDB (registry.getMapping(SECURITY_NAME));
        setPermissionsDB(permissionsDB);
        logger = Logger (registry.getMapping(LOGGER_NAME));
        setActive(true);
    }



}

contract NameRegistry is Owned,Mortal{

  mapping (string=>address) registry;

  function NameRegistry(){
     owned();
  }

  function addMapping(string _name,address _address) onlyOwner {
        registry[_name]=_address;
  }

  function getMapping(string _name) constant returns (address){
        return registry[_name];
  }
}


contract Logger{

    enum LogLevel{
        DEBUG,NORMAL
    }

    LogLevel logLevel;

    event LogNormalEvent(address indexed sender, bytes32 msg);
    event LogDebugEvent(address indexed sender, bytes32 msg);

    modifier isDebug(){if(logLevel==LogLevel.DEBUG) _ }

    function setLevel(LogLevel _logLevel) external {
        logLevel = _logLevel;
    }


    function getLevel() constant external returns (LogLevel){
      return logLevel;
    }


    function logDebug(address _sender,bytes32 _msg) external isDebug {
       LogDebugEvent(_sender,_msg);
    }


    function logNormal(address _sender,bytes32 _msg) external {
        LogNormalEvent(_sender,_msg);
    }

}

contract PermissionsDB is Owned,Mortal {

    modifier onlyControllerOrOwner() {
      if (msg.sender== controller || msg.sender==owner ) _
    }

    mapping(address =>mapping(address=>uint8)) contractPermissions;
    address controller;



    function PermissionsDB(){
        owned();
    }

    function setController(PermissionController _controller) onlyOwner {
      controller = _controller;
    }

    function setUserWrite(address _contract,address _user) onlyControllerOrOwner external  {
        mapping(address=>uint8) contractRights = contractPermissions[_contract];
        contractRights[_user] = contractRights[_user] | 2 ;
    }

    function setUserRead(address _contract,address _user) onlyControllerOrOwner external {
        mapping(address=>uint8) contractRights = contractPermissions[_contract];
        contractRights[_user] = contractRights[_user] | 1 ;
    }

    function getPermissionForUser(address _contract,address _user)  constant  returns (uint8){
        mapping(address=>uint8) contractRights = contractPermissions[_contract];
        return contractRights[_user];
    }

    function hasAdminRights(address _user) constant external returns (bool){
        return (_user==owner);
    }

    function hasWriteRights(address _contract,address _user) constant external returns (bool){
        uint8 rights = getPermissionForUser(_contract,_user);
        if ((rights&2)==2) {
            return true;
        }
        else{
            return false;
        }
    }

    function hasReadRights(address _contract,address _user)constant external returns (bool){
        uint8 rights = getPermissionForUser(_contract,_user);
         if ((rights&1)==1) {
            return true;
        }
        else{
            return false;
        }
    }
}

contract PermissionController is Owned,Mortal{

    PermissionsDB permissionsDB;

    function PermissionController(PermissionsDB _permissionsDB ){
        permissionsDB = _permissionsDB;
    }

    function setUserWrite(address _contract,address _user) external onlyOwner {
        permissionsDB.setUserWrite(_contract,_user);
    }
    function setUserRead(address _contract,address _user) external onlyOwner  {
        permissionsDB.setUserRead(_contract,_user);
    }

}
