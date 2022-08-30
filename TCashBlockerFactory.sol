// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;


import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";
import "./LibClone.sol";
import "./ITCashBlocker.sol";

contract TCashBlockerFactory is Ownable {
    using EnumerableSet for EnumerableSet.AddressSet;
    address currentImplementation;

    mapping(address => EnumerableSet.AddressSet) madeBy;

    EnumerableSet.AddressSet banset;

    function clone(address _receiver) public returns (address) {

        address impl = LibClone.clone(currentImplementation);

        ITCashBlocker implStruct = ITCashBlocker(impl);
        implStruct.init(_receiver, banset.values());
        madeBy[msg.sender].add(impl);
        return impl;
    } 

    function setCurrentImplementation(address impl) external onlyOwner {
        currentImplementation = impl;
    }

    function getCurrentBanlist() external view returns (address[] memory) {
        return banset.values();
    }

    function getMadeBy(address _user) external view returns (address[] memory) {
        return madeBy[_user].values();
    }

    function expandBanSet(address[] calldata newBans) external onlyOwner {
        for (uint256 i; i < newBans.length; i++) {
            banset.add(newBans[i]);
        }
    }
    function revokeBans(address[] calldata newBans) external onlyOwner {
        for (uint256 i; i < newBans.length; i++) {
            banset.remove(newBans[i]);
        }
    }
}
