// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract ManagmentDappContract {
    event personAdded(
        uint256 _id,
        uint256 _age,
        uint256 _level,
        string _fullName,
        string _gender,
        string _role,
        bool _isWorker
    );
    event workerHired(uint256 _id);
    event workedFired(uint256 _id);
    event workerChangedRole(uint256 _id);
    event workerPromoted(uint256 _id);

    struct Person {
        uint256 id;
        uint256 age;
        uint256 level;
        string fullName;
        string gender;
        string role;
        bool isWorker;
    }

    address owner;
    uint256 public personCount = 0;

    constructor() {
        owner = msg.sender;
    }

    modifier _onlyOwner() {
        require(owner == msg.sender);
        _;
    }

    mapping(uint256 => Person) public persons;
    mapping(uint256 => Person) public pendingWorkers;

    function register(
        uint256 _age,
        string memory _fullName,
        string memory _gender,
        string memory _role,
        bool _isWorker // isworker po frontendzie
    ) public {
        pendingWorkers[personCount] = Person(
            personCount,
            _age,
            1,
            _fullName,
            _gender,
            _role,
            _isWorker
        );

        emit personAdded(
            personCount,
            _age,
            0,
            _fullName,
            _gender,
            _role,
            _isWorker
        );

        personCount++;
    }

    function hireWorker(uint256 _id) public _onlyOwner {
        pendingWorkers[_id].isWorker = true;
        persons[_id] = pendingWorkers[_id];
        delete pendingWorkers[_id];
    }

    function firedWorker(uint256 _id) public _onlyOwner {
        delete persons[_id];
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
}
