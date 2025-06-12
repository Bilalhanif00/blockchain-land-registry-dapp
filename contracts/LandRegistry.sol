// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract LandRegistry {

    address public admin; // Admin address set at deployment

    constructor() {
        admin = msg.sender;
    }

    // Structure to represent each land record
    struct Land {
        uint id;               // Unique land ID
        string location;       // Physical address or location description
        uint area;             // Area in square feet or meters
        address owner;         // Current owner's wallet address
        address[] history;     // List of all previous owners
    }

    // Public mapping from land ID to the Land struct
    mapping(uint => Land) public lands;

    // Track the number of lands registered
    uint public landCount = 0;

    // Events for the frontend to listen to
    event LandRegistered(uint indexed landId, address indexed owner);
    event OwnershipTransferred(uint indexed landId, address indexed from, address indexed to);

    // Modifier: Only admin can perform certain actions
    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can register land");
        _;
    }

    // Register new land — only admin can call this function
    function registerLand(string memory _location, uint _area, address _landOwner) public onlyAdmin {
        landCount++;  // Increment land ID

        Land storage newLand = lands[landCount];
        newLand.id = landCount;
        newLand.location = _location;
        newLand.area = _area;
        newLand.owner = _landOwner;
        newLand.history.push(_landOwner);  // First owner

        emit LandRegistered(landCount, _landOwner);
    }

    // Transfer ownership to another wallet address
    function transferOwnership(uint _landId, address _newOwner) public {
        require(_landId > 0 && _landId <= landCount, "Invalid land ID");
        Land storage land = lands[_landId];
        require(msg.sender == land.owner, "Only owner can transfer");

        address previousOwner = land.owner;
        land.owner = _newOwner;
        land.history.push(_newOwner);

        emit OwnershipTransferred(_landId, previousOwner, _newOwner);
    }

    // View ownership history of a land
    function getHistory(uint _landId) public view returns (address[] memory) {
        require(_landId > 0 && _landId <= landCount, "Invalid land ID");
        return lands[_landId].history;
    }

    // Get the current owner of the land
    function getOwner(uint _landId) public view returns (address) {
        require(_landId > 0 && _landId <= landCount, "Invalid land ID");
        return lands[_landId].owner;
    }
}