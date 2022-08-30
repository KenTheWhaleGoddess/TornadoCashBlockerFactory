pragma solidity 0.8.7;

interface ITCashBlocker {
    function init(address _receiver, address factory, address[] calldata banlist) external;
    function setReceiver(address _newReceiver) external;
    function setFactory(address _newFactory) external;
}
