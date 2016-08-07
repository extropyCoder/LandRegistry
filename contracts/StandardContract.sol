import "Owned.sol";
import "Mortal.sol";
import "NameRegistryDB.sol";

contract StandardContract is Owned,Mortal{
    NameRegistryDB registry;
    bool active;

    modifier isActive(){if (active==true || msg.sender==owner)  _}

    function setActive(bool _active) onlyOwner{
      active = _active;
    }

    function activateContract(NameRegistryDB _registry){
        registry = _registry;
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
