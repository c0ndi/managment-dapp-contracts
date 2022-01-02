// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract ManagmentDappContract {
    event personAdded(
        uint256 _id,
        uint256 _age,
        uint256 _level,
        address _address,
        string _fullName,
        string _gender,
        string _role,
        bool _isWorker,
        bool _isRegistered
    );
    event workerHired(uint256 _id);
    event workedFired(uint256 _id);
    event workerChangedRole(uint256 _id);
    event workerPromoted(uint256 _id);

    struct Person {
        uint256 id;
        uint256 age;
        uint256 level;
        address addr;
        string fullName;
        string gender;
        string role;
        bool isWorker;
        bool isRegistered;
    }

    address owner;
    uint256 public personCount = 0;
    uint256 public pendingWorkersCount = 0;
    uint256 public workersCount = 0;

    constructor() {
        owner = msg.sender;
    }

    modifier _onlyOwner() {
        require(owner == msg.sender);
        _;
    }

    mapping(uint256 => Person) public persons;
    mapping(address => uint256) public addressToId; 
    mapping(uint256 => Person) public pendingWorkers;

    function register(
        uint256 _age,
        string memory _fullName,
        string memory _gender,
        string memory _role

    ) public {
        require(
            !(pendingWorkers[addressToId[msg.sender]].addr == msg.sender), 
            "User already registered"
            );

        pendingWorkers[personCount] = Person(
            personCount,
            _age,
            1,
            msg.sender,
            _fullName,
            _gender,
            _role,
            false,
            true
        );

        emit personAdded(
            personCount,
            _age,
            0,
            msg.sender,
            _fullName,
            _gender,
            _role,
            false,
            true
        );

        addressToId[msg.sender] = personCount;
        personCount++;
        pendingWorkersCount++;
    }

    function hireWorker(uint256 _id) public _onlyOwner {
        pendingWorkers[_id].isWorker = true;
        persons[_id] = pendingWorkers[_id];
        delete pendingWorkers[_id];
        pendingWorkersCount--;
        workersCount++;
    }

    function firedWorker(uint256 _id) public _onlyOwner {
        delete persons[_id];
        workersCount--;
    }

    function changeRoleOfWorker(uint256 _id, string memory _newRole)
        public
        _onlyOwner
    {
        persons[_id].role = _newRole;
    }

    function promoteWorker(uint256 _id) public _onlyOwner {
        if (persons[_id].level < 2) {
            persons[_id].level = persons[_id].level + 1;
        }
    }
    
    function getIsRegistered() public view returns(bool){
        if(pendingWorkers[addressToId[msg.sender]].addr == msg.sender) {
            return pendingWorkers[addressToId[msg.sender]].isRegistered;
        }
        return false;
    }

    function getAddressToId() public view returns(uint) {
        return addressToId[msg.sender];
    }

    function getPendingWorkersCount() public view returns(uint) {
        return pendingWorkersCount;
    }

    function getWorkersCount() public view returns(uint) {
        return workersCount;
    }
}
