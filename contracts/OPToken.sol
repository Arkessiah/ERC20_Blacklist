// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract OPToken is ERC20, Ownable {

    struct BlacklistEntry {
        bool isBlacklisted;
        string reason;
    }

    mapping(address => BlacklistEntry) public blacklist;

    event AddedToBlacklist(address indexed account, string reason);
    event RemovedFromBlacklist(address indexed account);
    event Minted(address indexed to, uint256 amount);
    event Burned(address indexed from, uint256 amount);
    event AddedGroupToBlacklist(address indexed account, string reason);

    
    constructor() ERC20("OPToken", "OP") Ownable(msg.sender) {
        _mint(msg.sender, 1000000000 * 10**18); // We initialize with 1,000,000,000,000 tokens
    }

    function mint(address to, uint256 amount) external onlyOwner {
        _mint(to, amount);
        emit Minted(to, amount);
    }

    function burn(uint256 amount) external {
        _burn(msg.sender, amount);
        emit Burned(msg.sender, amount);
    }

    function addToBlacklist(address account, string memory reason) external onlyOwner {
        blacklist[account] = BlacklistEntry(true, reason);
        emit AddedToBlacklist(account, reason);
    }

    function removeFromBlacklist(address account) external onlyOwner {
        delete blacklist[account];
        emit RemovedFromBlacklist(account);
    }

    function addMultipleToBlacklist(address[] memory accounts, string memory reason) public onlyOwner {
        for (uint i = 0; i < accounts.length; i++) {
            blacklist[accounts[i]] = BlacklistEntry(true, reason);
            emit AddedGroupToBlacklist(accounts[i], reason);
        }
    }   

    function transfer(address recipient, uint256 amount) public override returns (bool) {
        require(!blacklist[msg.sender].isBlacklisted, "Sender is blacklisted");
        require(!blacklist[recipient].isBlacklisted, "Recipient is blacklisted");
        return super.transfer(recipient, amount);
    }

    function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
        require(!blacklist[sender].isBlacklisted, "Sender is blacklisted");
        require(!blacklist[recipient].isBlacklisted, "Recipient is blacklisted");
        return super.transferFrom(sender, recipient, amount);
    }

    function transferOwnership(address newOwner) public override onlyOwner {
        require(newOwner != address(0), "New owner cannot be the zero address");
        _transferOwnership(newOwner);
    }
}