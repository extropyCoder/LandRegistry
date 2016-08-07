import "Owned.sol";

contract NameRegistryDB is Owned{

  mapping (string=>address) registry;


  modifier onlyOwner() {
    if (tx.origin==owner) _
  }

  function NameRegistryDB(){
     owner = msg.sender;
  }


    function addMapping(string _name,address _address) onlyOwner {
        registry[_name]=_address;
    }

    function getMapping(string _name) constant returns (address){
        return registry[_name];
    }
}
