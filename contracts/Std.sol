contract Std{}
contract abstract{}

contract Owned is abstract {
  address owner;
  function owned() {
    owner = msg.sender;
  }
  function changeOwner(address newOwner) onlyOwner {
    owner = newOwner;
  }
  modifier onlyOwner() {
    if (msg.sender==owner) _
  }
  modifier txOnlyOwner() {
    if (tx.origin==owner) _
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
