// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.0;

contract GasContract {
    uint256 private immutable totalSupply; // cannot be updated
    uint256 private paymentCounter;
    mapping(address => uint256) public balances;
    address private immutable contractOwner;
    mapping(address => Payment[]) private payments;
    mapping(address => uint256) public whitelist;
    address[5] public administrators;
    enum PaymentType {
        Unknown,
        BasicPayment,
        Refund,
        Dividend,
        GroupPayment
    }

    History[] private paymentHistory; // when a payment was updated

    struct Payment {
        uint256 paymentID;
        uint256 amount;
        string recipientName; // max 8 characters
        address admin; // administrators address
        PaymentType paymentType;
        bool adminUpdated;
        address recipient;
    }

    struct History {
        uint256 lastUpdate;
        uint256 blockNumber;
        address updatedBy;
    }
    uint256 private wasLastOdd = 1;
    mapping(address => uint256) private isOddWhitelistUser;
    
    struct ImportantStruct {
        uint256 amount;
        bool paymentStatus;
    }
    mapping(address => ImportantStruct) private whiteListStruct;

    event AddedToWhitelist(address userAddress, uint256 tier);

    modifier onlyAdminOrOwner() {
        require(checkForAdmin(msg.sender) || msg.sender == contractOwner, "Not admin or owner");
        _;
    }

    modifier checkIfWhiteListed(address sender) {
        require(
            msg.sender == sender,
            "Originator is not the sender"
        );
        uint256 usersTier = whitelist[msg.sender];
        require(
            usersTier > 0,
            "User is not whitelisted"
        );
        require(
            usersTier < 4,
            "User's tier is incorrect"
        );
        _;
    }

    event supplyChanged(address indexed, uint256 indexed);
    event Transfer(address recipient, uint256 amount);
    event PaymentUpdated(
        address admin,
        uint256 ID,
        uint256 amount,
        string recipient
    );
    event WhiteListTransfer(address indexed);

    constructor(address[] memory _admins, uint256 _totalSupply) {
        contractOwner = msg.sender;
        totalSupply = _totalSupply;

        uint256 length = administrators.length;

        unchecked {
            for (uint256 i = 0; i < length; ++i) {
                if (_admins[i] != address(0)) {
                    administrators[i] = _admins[i];
                    if (_admins[i] == msg.sender) {
                        balances[msg.sender] = _totalSupply;
                        emit supplyChanged(msg.sender, _totalSupply);
                    } else {
                        emit supplyChanged(_admins[i], 0);
                    }
                }
            }
        }
    }

    function getPaymentHistory()
        public
        view
        returns (History[] memory)
    {
        return paymentHistory;
    }

    function checkForAdmin(address _user) public view returns (bool) {
        uint256 length = administrators.length;
        unchecked {
            for (uint256 i = 0; i < length; ++i) {
                if (administrators[i] == _user) {
                    return true;
                }
            }
        }
        return false;
    }

    function balanceOf(address _user) public view returns (uint256) {
        return balances[_user];
    }


    function addHistory(address _updateAddress, bool _tradeMode)
        public
        returns (bool, bool)
    {
        History memory history;
        history.blockNumber = block.number;
        history.lastUpdate = block.timestamp;
        history.updatedBy = _updateAddress;
        paymentHistory.push(history);
        return (true, _tradeMode);
    }

    function getPayments(address _user)
        public
        view
        returns (Payment[] memory)
    {
        return payments[_user];
    }

    function transfer(
        address _recipient,
        uint256 _amount,
        string calldata _name
    ) public returns (bool) {
        require(
            bytes(_name).length < 9,
            "Recipient name too long, max length is 8 characters"
        );
        require(
            balances[msg.sender] >= _amount,
            "Sender has insufficient Balance"
        );
        balances[msg.sender] -= _amount;
        balances[_recipient] += _amount;
        emit Transfer(_recipient, _amount);
        Payment memory payment;
        payment.paymentType = PaymentType.BasicPayment;
        payment.recipient = _recipient;
        payment.amount = _amount;
        payment.recipientName = _name;
        unchecked {
            payment.paymentID = ++paymentCounter;
        }
        payments[msg.sender].push(payment);
        return true;
    }

    function updatePayment(
        address _user,
        uint256 _ID,
        uint256 _amount,
        PaymentType _type
    ) public onlyAdminOrOwner {
        require(
            _ID > 0,
            "ID must be greater than 0"
        );
        require(
            _amount > 0,
            "Amount must be greater than 0"
        );
        require(
            _user != address(0),
            "Administrator must have a valid non zero address"
        );

        Payment[] storage userPayments = payments[_user];

        unchecked {
            for (uint256 i = 0; i < userPayments.length; ++i) {
                if (userPayments[i].paymentID == _ID) {
                    userPayments[i].adminUpdated = true;
                    userPayments[i].admin = _user;
                    userPayments[i].paymentType = _type;
                    userPayments[i].amount = _amount;
                    addHistory(_user, true);
                    emit PaymentUpdated(
                        msg.sender,
                        _ID,
                        _amount,
                        userPayments[i].recipientName
                    );
                    break;
                }
            }
        }
    }

    function addToWhitelist(address _userAddrs, uint256 _tier)
        public
        onlyAdminOrOwner
    {
        require(
            _tier < 255,
            "Tier level should not be greater than 255"
        );
        uint256 userTier = _tier;
        if (_tier > 3) {
            userTier = 3;
        } else if (_tier == 1) {
            userTier = 1;
        } else if (_tier > 0 && _tier < 3) {
            userTier = 2;
        }
        whitelist[_userAddrs] = userTier;
        uint256 wasLastAddedOdd = wasLastOdd;
        if (wasLastAddedOdd == 1) {
            wasLastOdd = 0;
        } else if (wasLastAddedOdd == 0) {
            wasLastOdd = 1;
        } else {
            revert("Contract hacked, imposible, call help");
        }
        isOddWhitelistUser[_userAddrs] = wasLastAddedOdd;
        emit AddedToWhitelist(_userAddrs, _tier);
    }

    function whiteTransfer(
        address _recipient,
        uint256 _amount
    ) public checkIfWhiteListed(msg.sender) {
        require(
            _amount > 3,
            "Amount to send have to be bigger than 3"
        );
        uint256 currentSenderBalance = balances[msg.sender];
        require(
            currentSenderBalance >= _amount,
            "Sender has insufficient Balance"
        );

        whiteListStruct[msg.sender] = ImportantStruct(_amount, true);
        
        uint256 senderTier = whitelist[msg.sender];
        balances[msg.sender] = currentSenderBalance - _amount + senderTier;
        balances[_recipient] = balances[_recipient] + _amount - senderTier;
        
        emit WhiteListTransfer(_recipient);
    }

    function getPaymentStatus(address sender) public view returns (bool, uint256) {
        ImportantStruct storage whiteList_ = whiteListStruct[sender];
        return (whiteList_.paymentStatus, whiteList_.amount);
    }



    fallback() external payable {
         payable(msg.sender).transfer(msg.value);
    }
}