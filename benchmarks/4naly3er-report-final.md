# Report


## Gas Optimizations


| |Issue|Instances|
|-|:-|:-:|
| [GAS-1](#GAS-1) | Don't use `_msgSender()` if not supporting EIP-2771 | 3 |
| [GAS-2](#GAS-2) | `a = a + b` is more gas effective than `a += b` for state variables (excluding arrays and mappings) | 1 |
| [GAS-3](#GAS-3) | Use assembly to check for `address(0)` | 2 |
| [GAS-4](#GAS-4) | For Operations that will not overflow, you could use unchecked | 7 |
| [GAS-5](#GAS-5) | Use Custom Errors instead of Revert Strings to save Gas | 1 |
| [GAS-6](#GAS-6) | Stack variable used as a cheaper cache for a state variable is only used once | 1 |
| [GAS-7](#GAS-7) | State variables only set in the constructor should be declared `immutable` | 2 |
| [GAS-8](#GAS-8) | Functions guaranteed to revert when called by normal users can be marked `payable` | 2 |
| [GAS-9](#GAS-9) | Increments/decrements can be unchecked in for-loops | 2 |
### <a name="GAS-1"></a>[GAS-1] Don't use `_msgSender()` if not supporting EIP-2771
Use `msg.sender` if the code does not implement [EIP-2771 trusted forwarder](https://eips.ethereum.org/EIPS/eip-2771) support

*Instances (3)*:
```solidity
File: Ownable.sol

15:     function _msgSender() internal view virtual returns (address) {

48:         _transferOwnership(_msgSender());

70:         require(owner() == _msgSender(), "Ownable: caller is not the owner");

```

### <a name="GAS-2"></a>[GAS-2] `a = a + b` is more gas effective than `a += b` for state variables (excluding arrays and mappings)
This saves **16 gas per instance.**

*Instances (1)*:
```solidity
File: Gas.sol

61:         balances[_recipient] += _amount;

```

### <a name="GAS-3"></a>[GAS-3] Use assembly to check for `address(0)`
*Saves 6 gas per instance*

*Instances (2)*:
```solidity
File: Gas.sol

31:                 if (_admins[i] != address(0)) {

```

```solidity
File: Ownable.sol

90:             newOwner != address(0),

```

### <a name="GAS-4"></a>[GAS-4] For Operations that will not overflow, you could use unchecked

*Instances (7)*:
```solidity
File: Gas.sol

5:     uint256 private immutable totalSupply; // cannot be updated

30:             for (uint256 i = 0; i < 5; ++i) {

43:             for (uint256 i = 0; i < 5; ++i) {

60:         balances[msg.sender] -= _amount;

61:         balances[_recipient] += _amount;

87:         balances[msg.sender] = balances[msg.sender] - _amount + senderTier;

88:         balances[_recipient] = balances[_recipient] + _amount - senderTier;

```

### <a name="GAS-5"></a>[GAS-5] Use Custom Errors instead of Revert Strings to save Gas
Custom errors are available from solidity version 0.8.4. Custom errors save [**~50 gas**](https://gist.github.com/IllIllI000/ad1bd0d29a0101b25e57c293b4b0c746) each time they're hit by [avoiding having to allocate and store the revert string](https://blog.soliditylang.org/2021/04/21/custom-errors/#errors-in-depth). Not defining the strings also save deployment gas

Additionally, custom errors can be used inside and outside of contracts (including interfaces and libraries).

Source: <https://blog.soliditylang.org/2021/04/21/custom-errors/>:

> Starting from [Solidity v0.8.4](https://github.com/ethereum/solidity/releases/tag/v0.8.4), there is a convenient and gas-efficient way to explain to users why an operation failed through the use of custom errors. Until now, you could already use strings to give more information about failures (e.g., `revert("Insufficient funds.");`), but they are rather expensive, especially when it comes to deploy cost, and it is difficult to use dynamic information in them.

Consider replacing **all revert strings** with custom errors in the solution, and particularly those that have multiple occurrences:

*Instances (1)*:
```solidity
File: Ownable.sol

70:         require(owner() == _msgSender(), "Ownable: caller is not the owner");

```

### <a name="GAS-6"></a>[GAS-6] Stack variable used as a cheaper cache for a state variable is only used once
If the variable is only accessed once, it's cheaper to use the state variable directly that one time, and save the **3 gas** the extra stack assignment would spend

*Instances (1)*:
```solidity
File: Ownable.sol

101:         address oldOwner = _owner;

```

### <a name="GAS-7"></a>[GAS-7] State variables only set in the constructor should be declared `immutable`
Variables only set in the constructor and never edited afterwards should be marked as immutable, as it would avoid the expensive storage-writing operation in the constructor (around **20 000 gas** per variable) and replace the expensive storage-reading operations (around **2100 gas** per reading) to a less expensive value reading (**3 gas**)

*Instances (2)*:
```solidity
File: Gas.sol

26:         contractOwner = msg.sender;

27:         totalSupply = _totalSupply;

```

### <a name="GAS-8"></a>[GAS-8] Functions guaranteed to revert when called by normal users can be marked `payable`
If a function modifier such as `onlyOwner` is used, the function will revert if a normal user tries to pay the function. Marking the function as `payable` will lower the gas cost for legitimate callers because the compiler will not include checks for whether a payment was provided.

*Instances (2)*:
```solidity
File: Ownable.sol

80:     function renounceOwnership() public virtual onlyOwner {

88:     function transferOwnership(address newOwner) public virtual onlyOwner {

```

### <a name="GAS-9"></a>[GAS-9] Increments/decrements can be unchecked in for-loops
In Solidity 0.8+, there's a default overflow check on unsigned integers. It's possible to uncheck this in for-loops and save some gas at each iteration, but at the cost of some code readability, as this uncheck cannot be made inline.

[ethereum/solidity#10695](https://github.com/ethereum/solidity/issues/10695)

The change would be:

```diff
- for (uint256 i; i < numIterations; i++) {
+ for (uint256 i; i < numIterations;) {
 // ...  
+   unchecked { ++i; }
}  
```

These save around **25 gas saved** per instance.

The same can be applied with decrements (which should use `break` when `i == 0`).

The risk of overflow is non-existent for `uint256`.

*Instances (2)*:
```solidity
File: Gas.sol

30:             for (uint256 i = 0; i < 5; ++i) {

43:             for (uint256 i = 0; i < 5; ++i) {

```


## Non Critical Issues


| |Issue|Instances|
|-|:-|:-:|
| [NC-1](#NC-1) | Missing checks for `address(0)` when assigning values to address state variables | 1 |
| [NC-2](#NC-2) | `constant`s should be defined rather than using magic numbers | 5 |
| [NC-3](#NC-3) | Event missing indexed field | 1 |
| [NC-4](#NC-4) | Function ordering does not follow the Solidity style guide | 1 |
| [NC-5](#NC-5) | Functions should not be longer than 50 lines | 10 |
| [NC-6](#NC-6) | NatSpec is completely non-existent on functions that should have them | 3 |
| [NC-7](#NC-7) | Use a `modifier` instead of a `require/if` statement for a special `msg.sender` actor | 2 |
| [NC-8](#NC-8) | Consider using named mappings | 3 |
| [NC-9](#NC-9) | Take advantage of Custom Error's return value property | 2 |
| [NC-10](#NC-10) | Avoid the use of sensitive terms | 12 |
| [NC-11](#NC-11) | Contract does not follow the Solidity style guide's suggested layout ordering | 2 |
| [NC-12](#NC-12) | Internal and private variables and functions names should begin with an underscore | 1 |
| [NC-13](#NC-13) | Event is missing `indexed` fields | 1 |
| [NC-14](#NC-14) | `public` functions not called by the contract should be declared `external` instead | 5 |
| [NC-15](#NC-15) | Variables need not be initialized to zero | 2 |
### <a name="NC-1"></a>[NC-1] Missing checks for `address(0)` when assigning values to address state variables

*Instances (1)*:
```solidity
File: Ownable.sol

102:         _owner = newOwner;

```

### <a name="NC-2"></a>[NC-2] `constant`s should be defined rather than using magic numbers
Even [assembly](https://github.com/code-423n4/2022-05-opensea-seaport/blob/9d7ce4d08bf3c3010304a0476a785c70c0e90ae7/contracts/lib/TokenTransferrer.sol#L35-L39) can benefit from using readable constants instead of hex/numeric literals

*Instances (5)*:
```solidity
File: Gas.sol

30:             for (uint256 i = 0; i < 5; ++i) {

43:             for (uint256 i = 0; i < 5; ++i) {

69:         if (_tier > 255) {

72:         if (_tier > 3) {

73:             whitelist[_userAddrs] = 3;

```

### <a name="NC-3"></a>[NC-3] Event missing indexed field
Index event fields make the field more quickly accessible [to off-chain tools](https://ethereum.stackexchange.com/questions/40396/can-somebody-please-explain-the-concept-of-event-indexing) that parse events. This is especially useful when it comes to filtering based on an address. However, note that each index field costs extra gas during emission, so it's not necessarily best to index the maximum allowed per event (three fields). Where applicable, each `event` should use three `indexed` fields if there are three or more fields, and gas usage is not particularly of concern for the events in question. If there are fewer than three applicable fields, all of the applicable fields should be indexed.

*Instances (1)*:
```solidity
File: Gas.sol

13:     event AddedToWhitelist(address userAddress, uint256 tier);

```

### <a name="NC-4"></a>[NC-4] Function ordering does not follow the Solidity style guide
According to the [Solidity style guide](https://docs.soliditylang.org/en/v0.8.17/style-guide.html#order-of-functions), functions should be laid out in the following order :`constructor()`, `receive()`, `fallback()`, `external`, `public`, `internal`, `private`, but the cases below do not follow this pattern

*Instances (1)*:
```solidity
File: Ownable.sol

1: 
   Current order:
   internal _msgSender
   internal _msgData
   public owner
   internal _checkOwner
   public renounceOwnership
   public transferOwnership
   internal _transferOwnership
   
   Suggested order:
   public owner
   public renounceOwnership
   public transferOwnership
   internal _msgSender
   internal _msgData
   internal _checkOwner
   internal _transferOwnership

```

### <a name="NC-5"></a>[NC-5] Functions should not be longer than 50 lines
Overly complex code can make understanding functionality more difficult, try to further modularize your code to ensure readability 

*Instances (10)*:
```solidity
File: Gas.sol

41:     function checkForAdmin(address _user) public view returns (bool admin_) {

51:     function balanceOf(address _user) public view returns (uint256) {

65:     function addToWhitelist(address _userAddrs, uint256 _tier)

93:     function getPaymentStatus(address sender) public view returns (bool, uint256) {

```

```solidity
File: Ownable.sol

15:     function _msgSender() internal view virtual returns (address) {

19:     function _msgData() internal view virtual returns (bytes calldata) {

62:     function owner() public view virtual returns (address) {

80:     function renounceOwnership() public virtual onlyOwner {

88:     function transferOwnership(address newOwner) public virtual onlyOwner {

100:     function _transferOwnership(address newOwner) internal virtual {

```

### <a name="NC-6"></a>[NC-6] NatSpec is completely non-existent on functions that should have them
Public and external functions that aren't view or pure should have NatSpec comments

*Instances (3)*:
```solidity
File: Gas.sol

55:     function transfer(

65:     function addToWhitelist(address _userAddrs, uint256 _tier)

80:     function whiteTransfer(

```

### <a name="NC-7"></a>[NC-7] Use a `modifier` instead of a `require/if` statement for a special `msg.sender` actor
If a function is supposed to be access-controlled, a `modifier` should be used instead of a `require/if` statement for more readability.

*Instances (2)*:
```solidity
File: Gas.sol

17:         if (!checkForAdmin(msg.sender) && msg.sender != contractOwner) {

33:                     if (_admins[i] == msg.sender) {

```

### <a name="NC-8"></a>[NC-8] Consider using named mappings
Consider moving to solidity version 0.8.18 or later, and using [named mappings](https://ethereum.stackexchange.com/questions/51629/how-to-name-the-arguments-in-mapping/145555#145555) to make it easier to understand the purpose of each mapping

*Instances (3)*:
```solidity
File: Gas.sol

6:     mapping(address => uint256) public balances;

8:     mapping(address => uint256) public whitelist;

11:     mapping(address => uint256) private whiteListStruct;

```

### <a name="NC-9"></a>[NC-9] Take advantage of Custom Error's return value property
An important feature of Custom Error is that values such as address, tokenID, msg.value can be written inside the () sign, this kind of approach provides a serious advantage in debugging and examining the revert details of dapps such as tenderly.

*Instances (2)*:
```solidity
File: Gas.sol

18:             revert NotAdminOrOwner();

70:             revert InvalidTierLevel();

```

### <a name="NC-10"></a>[NC-10] Avoid the use of sensitive terms
Use [alternative variants](https://www.zdnet.com/article/mysql-drops-master-slave-and-blacklist-whitelist-terminology/), e.g. allowlist/denylist instead of whitelist/blacklist

*Instances (12)*:
```solidity
File: Gas.sol

8:     mapping(address => uint256) public whitelist;

11:     mapping(address => uint256) private whiteListStruct;

13:     event AddedToWhitelist(address userAddress, uint256 tier);

23:     event WhiteListTransfer(address indexed);

65:     function addToWhitelist(address _userAddrs, uint256 _tier)

73:             whitelist[_userAddrs] = 3;

75:             whitelist[_userAddrs] = _tier;

77:         emit AddedToWhitelist(_userAddrs, _tier);

84:         whiteListStruct[msg.sender] = _amount;

86:         uint256 senderTier = whitelist[msg.sender];

90:         emit WhiteListTransfer(_recipient);

94:         return (true, whiteListStruct[sender]);

```

### <a name="NC-11"></a>[NC-11] Contract does not follow the Solidity style guide's suggested layout ordering
The [style guide](https://docs.soliditylang.org/en/v0.8.16/style-guide.html#order-of-layout) says that, within a contract, the ordering should be:

1) Type declarations
2) State variables
3) Events
4) Modifiers
5) Functions

However, the contract(s) below do not follow this ordering

*Instances (2)*:
```solidity
File: Gas.sol

1: 
   Current order:
   VariableDeclaration.totalSupply
   VariableDeclaration.balances
   VariableDeclaration.contractOwner
   VariableDeclaration.whitelist
   VariableDeclaration.administrators
   VariableDeclaration.whiteListStruct
   EventDefinition.AddedToWhitelist
   ErrorDefinition.NotAdminOrOwner
   ModifierDefinition.onlyAdminOrOwner
   EventDefinition.WhiteListTransfer
   FunctionDefinition.constructor
   FunctionDefinition.checkForAdmin
   FunctionDefinition.balanceOf
   FunctionDefinition.transfer
   ErrorDefinition.InvalidTierLevel
   FunctionDefinition.addToWhitelist
   FunctionDefinition.whiteTransfer
   FunctionDefinition.getPaymentStatus
   
   Suggested order:
   VariableDeclaration.totalSupply
   VariableDeclaration.balances
   VariableDeclaration.contractOwner
   VariableDeclaration.whitelist
   VariableDeclaration.administrators
   VariableDeclaration.whiteListStruct
   ErrorDefinition.NotAdminOrOwner
   ErrorDefinition.InvalidTierLevel
   EventDefinition.AddedToWhitelist
   EventDefinition.WhiteListTransfer
   ModifierDefinition.onlyAdminOrOwner
   FunctionDefinition.constructor
   FunctionDefinition.checkForAdmin
   FunctionDefinition.balanceOf
   FunctionDefinition.transfer
   FunctionDefinition.addToWhitelist
   FunctionDefinition.whiteTransfer
   FunctionDefinition.getPaymentStatus

```

```solidity
File: Ownable.sol

1: 
   Current order:
   FunctionDefinition._msgSender
   FunctionDefinition._msgData
   VariableDeclaration._owner
   EventDefinition.OwnershipTransferred
   FunctionDefinition.constructor
   ModifierDefinition.onlyOwner
   FunctionDefinition.owner
   FunctionDefinition._checkOwner
   FunctionDefinition.renounceOwnership
   FunctionDefinition.transferOwnership
   FunctionDefinition._transferOwnership
   
   Suggested order:
   VariableDeclaration._owner
   EventDefinition.OwnershipTransferred
   ModifierDefinition.onlyOwner
   FunctionDefinition._msgSender
   FunctionDefinition._msgData
   FunctionDefinition.constructor
   FunctionDefinition.owner
   FunctionDefinition._checkOwner
   FunctionDefinition.renounceOwnership
   FunctionDefinition.transferOwnership
   FunctionDefinition._transferOwnership

```

### <a name="NC-12"></a>[NC-12] Internal and private variables and functions names should begin with an underscore
According to the Solidity Style Guide, Non-`external` variable and function names should begin with an [underscore](https://docs.soliditylang.org/en/latest/style-guide.html#underscore-prefix-for-non-external-functions-and-variables)

*Instances (1)*:
```solidity
File: Gas.sol

11:     mapping(address => uint256) private whiteListStruct;

```

### <a name="NC-13"></a>[NC-13] Event is missing `indexed` fields
Index event fields make the field more quickly accessible to off-chain tools that parse events. However, note that each index field costs extra gas during emission, so it's not necessarily best to index the maximum allowed per event (three fields). Each event should use three indexed fields if there are three or more fields, and gas usage is not particularly of concern for the events in question. If there are fewer than three fields, all of the fields should be indexed.

*Instances (1)*:
```solidity
File: Gas.sol

13:     event AddedToWhitelist(address userAddress, uint256 tier);

```

### <a name="NC-14"></a>[NC-14] `public` functions not called by the contract should be declared `external` instead

*Instances (5)*:
```solidity
File: Gas.sol

51:     function balanceOf(address _user) public view returns (uint256) {

55:     function transfer(

65:     function addToWhitelist(address _userAddrs, uint256 _tier)

80:     function whiteTransfer(

93:     function getPaymentStatus(address sender) public view returns (bool, uint256) {

```

### <a name="NC-15"></a>[NC-15] Variables need not be initialized to zero
The default value for variables is zero, so initializing them to zero is superfluous.

*Instances (2)*:
```solidity
File: Gas.sol

30:             for (uint256 i = 0; i < 5; ++i) {

43:             for (uint256 i = 0; i < 5; ++i) {

```


## Low Issues


| |Issue|Instances|
|-|:-|:-:|
| [L-1](#L-1) | Missing checks for `address(0)` when assigning values to address state variables | 1 |
| [L-2](#L-2) | Solidity version 0.8.20+ may not work on other chains due to `PUSH0` | 1 |
| [L-3](#L-3) | Use `Ownable2Step.transferOwnership` instead of `Ownable.transferOwnership` | 5 |
### <a name="L-1"></a>[L-1] Missing checks for `address(0)` when assigning values to address state variables

*Instances (1)*:
```solidity
File: Ownable.sol

102:         _owner = newOwner;

```

### <a name="L-2"></a>[L-2] Solidity version 0.8.20+ may not work on other chains due to `PUSH0`
The compiler for Solidity 0.8.20 switches the default target EVM version to [Shanghai](https://blog.soliditylang.org/2023/05/10/solidity-0.8.20-release-announcement/#important-note), which includes the new `PUSH0` op code. This op code may not yet be implemented on all L2s, so deployment on these chains will fail. To work around this issue, use an earlier [EVM](https://docs.soliditylang.org/en/v0.8.20/using-the-compiler.html?ref=zaryabs.com#setting-the-evm-version-to-target) [version](https://book.getfoundry.sh/reference/config/solidity-compiler#evm_version). While the project itself may or may not compile with 0.8.20, other projects with which it integrates, or which extend this project may, and those projects will have problems deploying these contracts/libraries.

*Instances (1)*:
```solidity
File: Gas.sol

2: pragma solidity ^0.8.22;

```

### <a name="L-3"></a>[L-3] Use `Ownable2Step.transferOwnership` instead of `Ownable.transferOwnership`
Use [Ownable2Step.transferOwnership](https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable2Step.sol) which is safer. Use it as it is more secure due to 2-stage ownership transfer.

**Recommended Mitigation Steps**

Use <a href="https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable2Step.sol">Ownable2Step.sol</a>
  
  ```solidity
      function acceptOwnership() external {
          address sender = _msgSender();
          require(pendingOwner() == sender, "Ownable2Step: caller is not the new owner");
          _transferOwnership(sender);
      }
```

*Instances (5)*:
```solidity
File: Ownable.sol

48:         _transferOwnership(_msgSender());

81:         _transferOwnership(address(0));

88:     function transferOwnership(address newOwner) public virtual onlyOwner {

93:         _transferOwnership(newOwner);

100:     function _transferOwnership(address newOwner) internal virtual {

```


## Medium Issues


| |Issue|Instances|
|-|:-|:-:|
| [M-1](#M-1) | Centralization Risk for trusted owners | 3 |
### <a name="M-1"></a>[M-1] Centralization Risk for trusted owners

#### Impact:
Contracts have owners with privileged rights to perform admin tasks and need to be trusted to not perform malicious updates or drain funds.

*Instances (3)*:
```solidity
File: Ownable.sol

36: abstract contract Ownable is Context {

80:     function renounceOwnership() public virtual onlyOwner {

88:     function transferOwnership(address newOwner) public virtual onlyOwner {

```

