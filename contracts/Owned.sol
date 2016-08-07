contract Owned  {
  address owner;
  address controllerContract;

  function owned() {
    owner = msg.sender;
    controllerContract = msg.sender;
  }
  function changeOwner(address newOwner) onlyOwner {
    owner = newOwner;
  }
  function changeContractController(address _newContract) onlyOwner {
    controllerContract = _newContract;
  }
  modifier onlyOwner() {
    if (msg.sender==owner) _
  }
  modifier onlyController() {
    if ((msg.sender==controllerContract) || (msg.sender==owner)) _
  }
  modifier txOnlyOwner() {
    if (tx.origin==owner) _
  }

  function getOwner() constant returns (address){
    return owner;
  }
  function getController() constant returns (address){
    return controllerContract;
  }
}
