// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.22;

contract GasContract {
    uint256 private immutable totalSupply; // cannot be updated
    mapping(address => uint256) public balances;
    address private immutable contractOwner;
    mapping(address => uint256) public whitelist;
    address[5] public administrators;

    mapping(address => uint256) private whiteListStruct;

    event AddedToWhitelist(address userAddress, uint256 tier);

    error NotAdminOrOwner();
    modifier onlyAdminOrOwner() {
        if (!checkForAdmin(msg.sender) && msg.sender != contractOwner) {
            revert NotAdminOrOwner();
        }
        _;
    }

    event WhiteListTransfer(address indexed);

    constructor(address[] memory _admins, uint256 _totalSupply) {
        contractOwner = msg.sender;
        totalSupply = _totalSupply;

        unchecked {
            for (uint256 i = 0; i < 5; ++i) {
                if (_admins[i] != address(0)) {
                    administrators[i] = _admins[i];
                    if (_admins[i] == msg.sender) {
                        balances[msg.sender] = _totalSupply;
                    }
                }
            }
        }
    }

    function checkForAdmin(address _user) public view returns (bool admin_) {
        unchecked {
            for (uint256 i = 0; i < 5; ++i) {
                if (administrators[i] == _user) {
                    admin_ = true;
                }
            }
        }
    }

    function balanceOf(address _user) public view returns (uint256) {
        return balances[_user];
    }

    function transfer(
        address _recipient,
        uint256 _amount,
        string calldata _name
    ) public {
        balances[msg.sender] -= _amount;
        balances[_recipient] += _amount;
    }

    error InvalidTierLevel();
    function addToWhitelist(address _userAddrs, uint256 _tier)
        public
        onlyAdminOrOwner
    {
        if (_tier > 255) {
            revert InvalidTierLevel();
        }
        if (_tier > 3) {
            whitelist[_userAddrs] = 3;
        } else {
            whitelist[_userAddrs] = _tier;
        }
        emit AddedToWhitelist(_userAddrs, _tier);
    }

    function whiteTransfer(
        address _recipient,
        uint256 _amount
    ) public {
        whiteListStruct[msg.sender] = _amount;
        
        uint256 senderTier = whitelist[msg.sender];
        balances[msg.sender] = balances[msg.sender] - _amount + senderTier;
        balances[_recipient] = balances[_recipient] + _amount - senderTier;
        
        emit WhiteListTransfer(_recipient);
    }

    function getPaymentStatus(address sender) public view returns (bool, uint256) {
        return (true, whiteListStruct[sender]);
    }
}