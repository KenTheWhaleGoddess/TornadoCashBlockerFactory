// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

/**
 * @title Owner
 * @dev Set & change owner
 */
contract TCashBlocker {

    bool wasInit;
    address receiver;

    mapping(address => bool) banned;

    function init(address _receiver, address[] calldata banlist) external {
        require(!wasInit, "init function");
        wasInit = true;
        receiver = _receiver;

        for(uint i = 0; i < banlist.length; i++) {
            banned[banlist[i]] = true;
        }
    }

    receive() external payable {
        require(receiver != address(0), "stahp");
        require(!banned[msg.sender], "this wallet/contract is banned");
        (bool s, ) = payable(receiver).call{value: msg.value}('');
        require(s, "unsuccessful payment");
    }

} 
