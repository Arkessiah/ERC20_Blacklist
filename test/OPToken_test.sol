// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

import "remix_tests.sol"; 
import "../contracts/OPToken.sol"; 

contract OPTokenTest {
    OPToken optoken;
    address owner;

   
    function beforeEach() public {
        optoken = new OPToken();
        owner = msg.sender;
    }

    // Test to verify correct initial token supply
    function testInitialSupply() public {
        uint256 supply = optoken.totalSupply();
        Assert.equal(supply, 1000000000 * 10**18, "Initial supply should be 1,000,000,000,000 tokens");
    }

    // Test to verify the mint function
    function testMintFunction() public {
        uint256 amountToMint = 1000 * 10**18;
        uint256 initialBalance = optoken.balanceOf(owner);
        optoken.mint(owner, amountToMint);
        uint256 expectedBalance = initialBalance + amountToMint;
        uint256 actualBalance = optoken.balanceOf(owner);
        Assert.equal(actualBalance, expectedBalance, "Mint function failed: the balances do not match");
    }

    // Test to verify transfer prohibition to blacklisted accounts
    function testBlacklistTransfer() public {
        address account = address(1); // Dirección de ejemplo
        optoken.addToBlacklist(account, "Test reason");

        // Mint tokens to ensure the account has enough balance for the transfer
        optoken.mint(account, 1000 * 10**18);

        bool success = true;
        try optoken.transfer(account, 100 * 10**18) {
            success = false; // Si la transferencia tiene éxito, establece success a false
        } catch {
            // La transacción debería fallar, por lo que este es el comportamiento esperado
        }

        Assert.ok(success, "Transfer should fail for blacklisted account");
    }

    // Test to verify ownership transfer
    function testOwnershipTransfer() public {
        address newOwner = address(2); // Example address
        optoken.transferOwnership(newOwner);
        Assert.equal(optoken.owner(), newOwner, "Ownership transfer failed");
    }

    // Test to add an address to the blacklist
    function testAddToBlacklist() public {
        address testAddress = address(1); // Example address
        optoken.addToBlacklist(testAddress, "Blacklisted for testing");

        // Fetching the blacklist entry for the testAddress
        (bool isBlacklisted, ) = optoken.blacklist(testAddress);
         Assert.equal(isBlacklisted, true, "Address should be blacklisted");
    }

    // Test to remove an address from the blacklist
    function testRemoveFromBlacklist() public {
        address testAddress = address(1); // Example address
        optoken.addToBlacklist(testAddress, "Blacklisted for testing");
        optoken.removeFromBlacklist(testAddress);

        // Fetching the blacklist entry for the testAddress
        (bool isBlacklisted, ) = optoken.blacklist(testAddress);
        Assert.equal(isBlacklisted, false, "Address should not be blacklisted anymore");
    }

    // Test to add multiple addresses to the blacklist
    function testAddMultipleToBlacklist() public {
        address[] memory testAddresses = new address[](2);
        testAddresses[0] = address(3); // Example address
        testAddresses[1] = address(4); // Example address

        optoken.addMultipleToBlacklist(testAddresses, "Bulk blacklisted for testing");

        // Verifying each address in the blacklist
        for (uint i = 0; i < testAddresses.length; i++) {
            (bool isBlacklisted, ) = optoken.blacklist(testAddresses[i]);
            Assert.equal(isBlacklisted, true, "Address should be blacklisted in bulk");
        }
    }

}