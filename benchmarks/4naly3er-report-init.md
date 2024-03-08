# Report


## Gas Optimizations


| |Issue|Instances|
|-|:-|:-:|
| [GAS-1](#GAS-1) | Don't use `_msgSender()` if not supporting EIP-2771 | 3 |
| [GAS-2](#GAS-2) | `a = a + b` is more gas effective than `a += b` for state variables (excluding arrays and mappings) | 3 |
| [GAS-3](#GAS-3) | Use assembly to check for `address(0)` | 4 |
| [GAS-4](#GAS-4) | Comparing to a Boolean constant | 2 |
| [GAS-5](#GAS-5) | Using bools for storage incurs overhead | 1 |
| [GAS-6](#GAS-6) | Cache array length outside of loop | 3 |
| [GAS-7](#GAS-7) | State variables should be cached in stack variables rather than re-reading them from storage | 1 |
| [GAS-8](#GAS-8) | For Operations that will not overflow, you could use unchecked | 33 |
| [GAS-9](#GAS-9) | Use Custom Errors instead of Revert Strings to save Gas | 2 |
| [GAS-10](#GAS-10) | Stack variable used as a cheaper cache for a state variable is only used once | 1 |
| [GAS-11](#GAS-11) | State variables only set in the constructor should be declared `immutable` | 2 |
| [GAS-12](#GAS-12) | Functions guaranteed to revert when called by normal users can be marked `payable` | 2 |
| [GAS-13](#GAS-13) | `++i` costs less gas compared to `i++` or `i += 1` (same for `--i` vs `i--` or `i -= 1`) | 4 |
| [GAS-14](#GAS-14) | Increments/decrements can be unchecked in for-loops | 5 |
| [GAS-15](#GAS-15) | Use != 0 instead of > 0 for unsigned integer comparison | 4 |
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

*Instances (3)*:
```solidity
File: Gas.sol

207:         balances[_recipient] += _amount;

312:         balances[_recipient] += _amount;

313:         balances[senderOfTx] += whitelist[senderOfTx];

```

### <a name="GAS-3"></a>[GAS-3] Use assembly to check for `address(0)`
*Saves 6 gas per instance*

*Instances (4)*:
```solidity
File: Gas.sol

114:             if (_admins[ii] != address(0)) {

186:             _user != address(0),

240:             _user != address(0),

```

```solidity
File: Ownable.sol

90:             newOwner != address(0),

```

### <a name="GAS-4"></a>[GAS-4] Comparing to a Boolean constant
Comparing to a constant (`true` or `false`) is a bit more expensive than directly checking the returned boolean value.

Consider using `if(directValue)` instead of `if(directValue == true)` and `if(!directValue)` instead of `if(directValue == false)`

*Instances (2)*:
```solidity
File: Gas.sol

177:         return ((status[0] == true), _tradeMode);

222:         return (status[0] == true);

```

### <a name="GAS-5"></a>[GAS-5] Using bools for storage incurs overhead
Use uint256(1) and uint256(2) for true/false to avoid a Gwarmaccess (100 gas), and to avoid Gsset (20000 gas) when changing from ‘false’ to ‘true’, after having been ‘true’ in the past. See [source](https://github.com/OpenZeppelin/openzeppelin-contracts/blob/58f635312aa21f947cae5f8578638a85aa2519f5/contracts/security/ReentrancyGuard.sol#L23-L27).

*Instances (1)*:
```solidity
File: Gas.sol

22:     bool public isReady = false;

```

### <a name="GAS-6"></a>[GAS-6] Cache array length outside of loop
If not cached, the solidity compiler will always read the length of the array during each iteration. That is, if it is a storage array, this is an extra sload operation (100 additional extra gas for each iteration except for the first) and if it is a memory array, this is an extra mload operation (3 additional gas for each iteration except for the first).

*Instances (3)*:
```solidity
File: Gas.sol

113:         for (uint256 ii = 0; ii < administrators.length; ii++) {

140:         for (uint256 ii = 0; ii < administrators.length; ii++) {

246:         for (uint256 ii = 0; ii < payments[_user].length; ii++) {

```

### <a name="GAS-7"></a>[GAS-7] State variables should be cached in stack variables rather than re-reading them from storage
The instances below point to the second+ access of a state variable within a function. Caching of a state variable replaces each Gwarmaccess (100 gas) with a much cheaper stack read. Other less obvious fixes/optimizations include having local memory caches of state variable structs, or having local caches of state variable contracts/addresses.

*Saves 100 gas per instance*

*Instances (1)*:
```solidity
File: Gas.sol

122:                     emit supplyChanged(_admins[ii], totalSupply);

```

### <a name="GAS-8"></a>[GAS-8] For Operations that will not overflow, you could use unchecked

*Instances (33)*:
```solidity
File: Gas.sol

4: import "./Ownable.sol";

13:     uint256 public totalSupply = 0; // cannot be updated

32:     History[] public paymentHistory; // when a payment was updated

38:         string recipientName; // max 8 characters

40:         address admin; // administrators address

54:         uint256 valueA; // max 3 digits

56:         uint256 valueB; // max 3 digits

69:                 "Gas Contract Only Admin Check-  Caller not admin"

76:                 "Error in Gas contract - onlyAdminOrOwner modifier : revert happened because the originator of the transaction was not the admin, and furthermore he wasn't the owner of the contract, so he cannot run this function"

113:         for (uint256 ii = 0; ii < administrators.length; ii++) {

140:         for (uint256 ii = 0; ii < administrators.length; ii++) {

174:         for (uint256 i = 0; i < tradePercent; i++) {

187:             "Gas Contract - getPayments function - User must have a valid non zero address"

200:             "Gas Contract - Transfer function - Sender has insufficient Balance"

204:             "Gas Contract - Transfer function -  The recipient name is too long, there is a max length of 8 characters"

206:         balances[senderOfTx] -= _amount;

207:         balances[_recipient] += _amount;

216:         payment.paymentID = ++paymentCounter;

219:         for (uint256 i = 0; i < tradePercent; i++) {

233:             "Gas Contract - Update Payment function - ID must be greater than 0"

237:             "Gas Contract - Update Payment function - Amount must be greater than 0"

241:             "Gas Contract - Update Payment function - Administrator must have a valid non zero address"

246:         for (uint256 ii = 0; ii < payments[_user].length; ii++) {

270:             "Gas Contract - addToWhitelist function -  tier level should not be greater than 255"

274:             whitelist[_userAddrs] -= _tier;

277:             whitelist[_userAddrs] -= _tier;

280:             whitelist[_userAddrs] -= _tier;

305:             "Gas Contract - whiteTransfers function - Sender has insufficient Balance"

309:             "Gas Contract - whiteTransfers function - amount to send have to be bigger than 3"

311:         balances[senderOfTx] -= _amount;

312:         balances[_recipient] += _amount;

313:         balances[senderOfTx] += whitelist[senderOfTx];

314:         balances[_recipient] -= whitelist[senderOfTx];

```

### <a name="GAS-9"></a>[GAS-9] Use Custom Errors instead of Revert Strings to save Gas
Custom errors are available from solidity version 0.8.4. Custom errors save [**~50 gas**](https://gist.github.com/IllIllI000/ad1bd0d29a0101b25e57c293b4b0c746) each time they're hit by [avoiding having to allocate and store the revert string](https://blog.soliditylang.org/2021/04/21/custom-errors/#errors-in-depth). Not defining the strings also save deployment gas

Additionally, custom errors can be used inside and outside of contracts (including interfaces and libraries).

Source: <https://blog.soliditylang.org/2021/04/21/custom-errors/>:

> Starting from [Solidity v0.8.4](https://github.com/ethereum/solidity/releases/tag/v0.8.4), there is a convenient and gas-efficient way to explain to users why an operation failed through the use of custom errors. Until now, you could already use strings to give more information about failures (e.g., `revert("Insufficient funds.");`), but they are rather expensive, especially when it comes to deploy cost, and it is difficult to use dynamic information in them.

Consider replacing **all revert strings** with custom errors in the solution, and particularly those that have multiple occurrences:

*Instances (2)*:
```solidity
File: Gas.sol

291:             revert("Contract hacked, imposible, call help");

```

```solidity
File: Ownable.sol

70:         require(owner() == _msgSender(), "Ownable: caller is not the owner");

```

### <a name="GAS-10"></a>[GAS-10] Stack variable used as a cheaper cache for a state variable is only used once
If the variable is only accessed once, it's cheaper to use the state variable directly that one time, and save the **3 gas** the extra stack assignment would spend

*Instances (1)*:
```solidity
File: Ownable.sol

101:         address oldOwner = _owner;

```

### <a name="GAS-11"></a>[GAS-11] State variables only set in the constructor should be declared `immutable`
Variables only set in the constructor and never edited afterwards should be marked as immutable, as it would avoid the expensive storage-writing operation in the constructor (around **20 000 gas** per variable) and replace the expensive storage-reading operations (around **2100 gas** per reading) to a less expensive value reading (**3 gas**)

*Instances (2)*:
```solidity
File: Gas.sol

110:         contractOwner = msg.sender;

111:         totalSupply = _totalSupply;

```

### <a name="GAS-12"></a>[GAS-12] Functions guaranteed to revert when called by normal users can be marked `payable`
If a function modifier such as `onlyOwner` is used, the function will revert if a normal user tries to pay the function. Marking the function as `payable` will lower the gas cost for legitimate callers because the compiler will not include checks for whether a payment was provided.

*Instances (2)*:
```solidity
File: Ownable.sol

80:     function renounceOwnership() public virtual onlyOwner {

88:     function transferOwnership(address newOwner) public virtual onlyOwner {

```

### <a name="GAS-13"></a>[GAS-13] `++i` costs less gas compared to `i++` or `i += 1` (same for `--i` vs `i--` or `i -= 1`)
Pre-increments and pre-decrements are cheaper.

For a `uint256 i` variable, the following is true with the Optimizer enabled at 10k:

**Increment:**

- `i += 1` is the most expensive form
- `i++` costs 6 gas less than `i += 1`
- `++i` costs 5 gas less than `i++` (11 gas less than `i += 1`)

**Decrement:**

- `i -= 1` is the most expensive form
- `i--` costs 11 gas less than `i -= 1`
- `--i` costs 5 gas less than `i--` (16 gas less than `i -= 1`)

Note that post-increments (or post-decrements) return the old value before incrementing or decrementing, hence the name *post-increment*:

```solidity
uint i = 1;  
uint j = 2;
require(j == i++, "This will be false as i is incremented after the comparison");
```
  
However, pre-increments (or pre-decrements) return the new value:
  
```solidity
uint i = 1;  
uint j = 2;
require(j == ++i, "This will be true as i is incremented before the comparison");
```

In the pre-increment case, the compiler has to create a temporary variable (when used) for returning `1` instead of `2`.

Consider using pre-increments and pre-decrements where they are relevant (meaning: not where post-increments/decrements logic are relevant).

*Saves 5 gas per instance*

*Instances (4)*:
```solidity
File: Gas.sol

113:         for (uint256 ii = 0; ii < administrators.length; ii++) {

140:         for (uint256 ii = 0; ii < administrators.length; ii++) {

174:         for (uint256 i = 0; i < tradePercent; i++) {

219:         for (uint256 i = 0; i < tradePercent; i++) {

```

### <a name="GAS-14"></a>[GAS-14] Increments/decrements can be unchecked in for-loops
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

*Instances (5)*:
```solidity
File: Gas.sol

113:         for (uint256 ii = 0; ii < administrators.length; ii++) {

140:         for (uint256 ii = 0; ii < administrators.length; ii++) {

174:         for (uint256 i = 0; i < tradePercent; i++) {

219:         for (uint256 i = 0; i < tradePercent; i++) {

246:         for (uint256 ii = 0; ii < payments[_user].length; ii++) {

```

### <a name="GAS-15"></a>[GAS-15] Use != 0 instead of > 0 for unsigned integer comparison

*Instances (4)*:
```solidity
File: Gas.sol

89:             usersTier > 0,

232:             _ID > 0,

236:             _amount > 0,

279:         } else if (_tier > 0 && _tier < 3) {

```


## Non Critical Issues


| |Issue|Instances|
|-|:-|:-:|
| [NC-1](#NC-1) | Missing checks for `address(0)` when assigning values to address state variables | 1 |
| [NC-2](#NC-2) | Array indices should be referenced via `enum`s rather than via numeric literals | 2 |
| [NC-3](#NC-3) | Constants should be in CONSTANT_CASE | 1 |
| [NC-4](#NC-4) | `constant`s should be defined rather than using magic numbers | 13 |
| [NC-5](#NC-5) | Control structures do not follow the Solidity Style Guide | 4 |
| [NC-6](#NC-6) | Default Visibility for constants | 1 |
| [NC-7](#NC-7) | Consider disabling `renounceOwnership()` | 1 |
| [NC-8](#NC-8) | Event missing indexed field | 3 |
| [NC-9](#NC-9) | Events that mark critical parameter changes should contain both the old and the new value | 1 |
| [NC-10](#NC-10) | Function ordering does not follow the Solidity style guide | 1 |
| [NC-11](#NC-11) | Functions should not be longer than 50 lines | 17 |
| [NC-12](#NC-12) | Lines are too long | 2 |
| [NC-13](#NC-13) | NatSpec is completely non-existent on functions that should have them | 12 |
| [NC-14](#NC-14) | Use a `modifier` instead of a `require/if` statement for a special `msg.sender` actor | 1 |
| [NC-15](#NC-15) | Consider using named mappings | 5 |
| [NC-16](#NC-16) | Adding a `return` statement when the function defines a named return variable, is redundant | 7 |
| [NC-17](#NC-17) | Avoid the use of sensitive terms | 28 |
| [NC-18](#NC-18) | Contract does not follow the Solidity style guide's suggested layout ordering | 2 |
| [NC-19](#NC-19) | Internal and private variables and functions names should begin with an underscore | 1 |
| [NC-20](#NC-20) | Event is missing `indexed` fields | 3 |
| [NC-21](#NC-21) | `public` functions not called by the contract should be declared `external` instead | 8 |
| [NC-22](#NC-22) | Variables need not be initialized to zero | 9 |
### <a name="NC-1"></a>[NC-1] Missing checks for `address(0)` when assigning values to address state variables

*Instances (1)*:
```solidity
File: Ownable.sol

102:         _owner = newOwner;

```

### <a name="NC-2"></a>[NC-2] Array indices should be referenced via `enum`s rather than via numeric literals

*Instances (2)*:
```solidity
File: Gas.sol

177:         return ((status[0] == true), _tradeMode);

222:         return (status[0] == true);

```

### <a name="NC-3"></a>[NC-3] Constants should be in CONSTANT_CASE
For `constant` variable names, each word should use all capital letters, with underscores separating each word (CONSTANT_CASE)

*Instances (1)*:
```solidity
File: Gas.sol

30:     PaymentType constant defaultPayment = PaymentType.Unknown;

```

### <a name="NC-4"></a>[NC-4] `constant`s should be defined rather than using magic numbers
Even [assembly](https://github.com/code-423n4/2022-05-opensea-seaport/blob/9d7ce4d08bf3c3010304a0476a785c70c0e90ae7/contracts/lib/TokenTransferrer.sol#L35-L39) can benefit from using readable constants instead of hex/numeric literals

*Instances (13)*:
```solidity
File: Gas.sol

16:     uint256 public tradePercent = 12;

93:             usersTier < 4,

94:             "Gas Contract CheckIfWhiteListed modifier : revert happened because the user's tier is incorrect, it cannot be over 4 as the only tier we have are: 1, 2, 3; therfore 4 is an invalid tier for the whitlist of this contract. make sure whitlist tiers were set correctly"

203:             bytes(_name).length < 9,

204:             "Gas Contract - Transfer function -  The recipient name is too long, there is a max length of 8 characters"

269:             _tier < 255,

270:             "Gas Contract - addToWhitelist function -  tier level should not be greater than 255"

273:         if (_tier > 3) {

275:             whitelist[_userAddrs] = 3;

279:         } else if (_tier > 0 && _tier < 3) {

281:             whitelist[_userAddrs] = 2;

308:             _amount > 3,

309:             "Gas Contract - whiteTransfers function - amount to send have to be bigger than 3"

```

### <a name="NC-5"></a>[NC-5] Control structures do not follow the Solidity Style Guide
See the [control structures](https://docs.soliditylang.org/en/latest/style-guide.html#control-structures) section of the Solidity Style Guide

*Instances (4)*:
```solidity
File: Gas.sol

76:                 "Error in Gas contract - onlyAdminOrOwner modifier : revert happened because the originator of the transaction was not the admin, and furthermore he wasn't the owner of the contract, so he cannot run this function"

85:             "Gas Contract CheckIfWhiteListed modifier : revert happened because the originator of the transaction was not the sender"

90:             "Gas Contract CheckIfWhiteListed modifier : revert happened because the user is not whitelisted"

94:             "Gas Contract CheckIfWhiteListed modifier : revert happened because the user's tier is incorrect, it cannot be over 4 as the only tier we have are: 1, 2, 3; therfore 4 is an invalid tier for the whitlist of this contract. make sure whitlist tiers were set correctly"

```

### <a name="NC-6"></a>[NC-6] Default Visibility for constants
Some constants are using the default visibility. For readability, consider explicitly declaring them as `internal`.

*Instances (1)*:
```solidity
File: Gas.sol

30:     PaymentType constant defaultPayment = PaymentType.Unknown;

```

### <a name="NC-7"></a>[NC-7] Consider disabling `renounceOwnership()`
If the plan for your project does not include eventually giving up all ownership control, consider overwriting OpenZeppelin's `Ownable`'s `renounceOwnership()` function in order to disable it.

*Instances (1)*:
```solidity
File: Gas.sol

12: contract GasContract is Ownable, Constants {

```

### <a name="NC-8"></a>[NC-8] Event missing indexed field
Index event fields make the field more quickly accessible [to off-chain tools](https://ethereum.stackexchange.com/questions/40396/can-somebody-please-explain-the-concept-of-event-indexing) that parse events. This is especially useful when it comes to filtering based on an address. However, note that each index field costs extra gas during emission, so it's not necessarily best to index the maximum allowed per event (three fields). Where applicable, each `event` should use three `indexed` fields if there are three or more fields, and gas usage is not particularly of concern for the events in question. If there are fewer than three applicable fields, all of the applicable fields should be indexed.

*Instances (3)*:
```solidity
File: Gas.sol

62:     event AddedToWhitelist(address userAddress, uint256 tier);

100:     event Transfer(address recipient, uint256 amount);

101:     event PaymentUpdated(

```

### <a name="NC-9"></a>[NC-9] Events that mark critical parameter changes should contain both the old and the new value
This should especially be done if the new value is not required to be different from the old value

*Instances (1)*:
```solidity
File: Gas.sol

225:     function updatePayment(
             address _user,
             uint256 _ID,
             uint256 _amount,
             PaymentType _type
         ) public onlyAdminOrOwner {
             require(
                 _ID > 0,
                 "Gas Contract - Update Payment function - ID must be greater than 0"
             );
             require(
                 _amount > 0,
                 "Gas Contract - Update Payment function - Amount must be greater than 0"
             );
             require(
                 _user != address(0),
                 "Gas Contract - Update Payment function - Administrator must have a valid non zero address"
             );
     
             address senderOfTx = msg.sender;
     
             for (uint256 ii = 0; ii < payments[_user].length; ii++) {
                 if (payments[_user][ii].paymentID == _ID) {
                     payments[_user][ii].adminUpdated = true;
                     payments[_user][ii].admin = _user;
                     payments[_user][ii].paymentType = _type;
                     payments[_user][ii].amount = _amount;
                     bool tradingMode = getTradingMode();
                     addHistory(_user, tradingMode);
                     emit PaymentUpdated(

```

### <a name="NC-10"></a>[NC-10] Function ordering does not follow the Solidity style guide
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

### <a name="NC-11"></a>[NC-11] Functions should not be longer than 50 lines
Overly complex code can make understanding functionality more difficult, try to further modularize your code to ensure readability 

*Instances (17)*:
```solidity
File: Gas.sol

138:     function checkForAdmin(address _user) public view returns (bool admin_) {

148:     function balanceOf(address _user) public view returns (uint256 balance_) {

153:     function getTradingMode() public view returns (bool mode_) {

164:     function addHistory(address _updateAddress, bool _tradeMode)

187:             "Gas Contract - getPayments function - User must have a valid non zero address"

204:             "Gas Contract - Transfer function -  The recipient name is too long, there is a max length of 8 characters"

241:             "Gas Contract - Update Payment function - Administrator must have a valid non zero address"

264:     function addToWhitelist(address _userAddrs, uint256 _tier)

270:             "Gas Contract - addToWhitelist function -  tier level should not be greater than 255"

309:             "Gas Contract - whiteTransfers function - amount to send have to be bigger than 3"

319:     function getPaymentStatus(address sender) public view returns (bool, uint256) {

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

### <a name="NC-12"></a>[NC-12] Lines are too long
Usually lines in source code are limited to [80](https://softwareengineering.stackexchange.com/questions/148677/why-is-80-characters-the-standard-limit-for-code-width) characters. Today's screens are much larger so it's reasonable to stretch this in some cases. Since the files will most likely reside in GitHub, and GitHub starts using a scroll bar in all cases when the length is over [164](https://github.com/aizatto/character-length) characters, the lines below should be split when they reach that length

*Instances (2)*:
```solidity
File: Gas.sol

76:                 "Error in Gas contract - onlyAdminOrOwner modifier : revert happened because the originator of the transaction was not the admin, and furthermore he wasn't the owner of the contract, so he cannot run this function"

94:             "Gas Contract CheckIfWhiteListed modifier : revert happened because the user's tier is incorrect, it cannot be over 4 as the only tier we have are: 1, 2, 3; therfore 4 is an invalid tier for the whitlist of this contract. make sure whitlist tiers were set correctly"

```

### <a name="NC-13"></a>[NC-13] NatSpec is completely non-existent on functions that should have them
Public and external functions that aren't view or pure should have NatSpec comments

*Instances (12)*:
```solidity
File: Gas.sol

130:     function getPaymentHistory()

130:     function getPaymentHistory()

164:     function addHistory(address _updateAddress, bool _tradeMode)

164:     function addHistory(address _updateAddress, bool _tradeMode)

192:     function transfer(

192:     function transfer(

225:     function updatePayment(

225:     function updatePayment(

264:     function addToWhitelist(address _userAddrs, uint256 _tier)

264:     function addToWhitelist(address _userAddrs, uint256 _tier)

296:     function whiteTransfer(

296:     function whiteTransfer(

```

### <a name="NC-14"></a>[NC-14] Use a `modifier` instead of a `require/if` statement for a special `msg.sender` actor
If a function is supposed to be access-controlled, a `modifier` should be used instead of a `require/if` statement for more readability.

*Instances (1)*:
```solidity
File: Gas.sol

299:     ) public checkIfWhiteListed(msg.sender) {

```

### <a name="NC-15"></a>[NC-15] Consider using named mappings
Consider moving to solidity version 0.8.18 or later, and using [named mappings](https://ethereum.stackexchange.com/questions/51629/how-to-name-the-arguments-in-mapping/145555#145555) to make it easier to understand the purpose of each mapping

*Instances (5)*:
```solidity
File: Gas.sol

15:     mapping(address => uint256) public balances;

19:     mapping(address => Payment[]) public payments;

20:     mapping(address => uint256) public whitelist;

50:     mapping(address => uint256) public isOddWhitelistUser;

60:     mapping(address => ImportantStruct) public whiteListStruct;

```

### <a name="NC-16"></a>[NC-16] Adding a `return` statement when the function defines a named return variable, is redundant

*Instances (7)*:
```solidity
File: Gas.sol

130:     function getPaymentHistory()
             public
             payable
             returns (History[] memory paymentHistory_)
         {
             return paymentHistory;

138:     function checkForAdmin(address _user) public view returns (bool admin_) {
             bool admin = false;
             for (uint256 ii = 0; ii < administrators.length; ii++) {
                 if (administrators[ii] == _user) {
                     admin = true;
                 }
             }
             return admin;

148:     function balanceOf(address _user) public view returns (uint256 balance_) {
             uint256 balance = balances[_user];
             return balance;

153:     function getTradingMode() public view returns (bool mode_) {
             bool mode = false;
             if (tradeFlag == 1 || dividendFlag == 1) {
                 mode = true;
             } else {
                 mode = false;
             }
             return mode;

164:     function addHistory(address _updateAddress, bool _tradeMode)
             public
             returns (bool status_, bool tradeMode_)
         {
             History memory history;
             history.blockNumber = block.number;
             history.lastUpdate = block.timestamp;
             history.updatedBy = _updateAddress;
             paymentHistory.push(history);
             bool[] memory status = new bool[](tradePercent);
             for (uint256 i = 0; i < tradePercent; i++) {
                 status[i] = true;
             }
             return ((status[0] == true), _tradeMode);

180:     function getPayments(address _user)
             public
             view
             returns (Payment[] memory payments_)
         {
             require(
                 _user != address(0),
                 "Gas Contract - getPayments function - User must have a valid non zero address"
             );
             return payments[_user];

192:     function transfer(
             address _recipient,
             uint256 _amount,
             string calldata _name
         ) public returns (bool status_) {
             address senderOfTx = msg.sender;
             require(
                 balances[senderOfTx] >= _amount,
                 "Gas Contract - Transfer function - Sender has insufficient Balance"
             );
             require(
                 bytes(_name).length < 9,
                 "Gas Contract - Transfer function -  The recipient name is too long, there is a max length of 8 characters"
             );
             balances[senderOfTx] -= _amount;
             balances[_recipient] += _amount;
             emit Transfer(_recipient, _amount);
             Payment memory payment;
             payment.admin = address(0);
             payment.adminUpdated = false;
             payment.paymentType = PaymentType.BasicPayment;
             payment.recipient = _recipient;
             payment.amount = _amount;
             payment.recipientName = _name;
             payment.paymentID = ++paymentCounter;
             payments[senderOfTx].push(payment);
             bool[] memory status = new bool[](tradePercent);
             for (uint256 i = 0; i < tradePercent; i++) {
                 status[i] = true;
             }
             return (status[0] == true);

```

### <a name="NC-17"></a>[NC-17] Avoid the use of sensitive terms
Use [alternative variants](https://www.zdnet.com/article/mysql-drops-master-slave-and-blacklist-whitelist-terminology/), e.g. allowlist/denylist instead of whitelist/blacklist

*Instances (28)*:
```solidity
File: Gas.sol

20:     mapping(address => uint256) public whitelist;

50:     mapping(address => uint256) public isOddWhitelistUser;

60:     mapping(address => ImportantStruct) public whiteListStruct;

62:     event AddedToWhitelist(address userAddress, uint256 tier);

81:     modifier checkIfWhiteListed(address sender) {

85:             "Gas Contract CheckIfWhiteListed modifier : revert happened because the originator of the transaction was not the sender"

87:         uint256 usersTier = whitelist[senderOfTx];

90:             "Gas Contract CheckIfWhiteListed modifier : revert happened because the user is not whitelisted"

94:             "Gas Contract CheckIfWhiteListed modifier : revert happened because the user's tier is incorrect, it cannot be over 4 as the only tier we have are: 1, 2, 3; therfore 4 is an invalid tier for the whitlist of this contract. make sure whitlist tiers were set correctly"

107:     event WhiteListTransfer(address indexed);

264:     function addToWhitelist(address _userAddrs, uint256 _tier)

270:             "Gas Contract - addToWhitelist function -  tier level should not be greater than 255"

272:         whitelist[_userAddrs] = _tier;

274:             whitelist[_userAddrs] -= _tier;

275:             whitelist[_userAddrs] = 3;

277:             whitelist[_userAddrs] -= _tier;

278:             whitelist[_userAddrs] = 1;

280:             whitelist[_userAddrs] -= _tier;

281:             whitelist[_userAddrs] = 2;

286:             isOddWhitelistUser[_userAddrs] = wasLastAddedOdd;

289:             isOddWhitelistUser[_userAddrs] = wasLastAddedOdd;

293:         emit AddedToWhitelist(_userAddrs, _tier);

299:     ) public checkIfWhiteListed(msg.sender) {

301:         whiteListStruct[senderOfTx] = ImportantStruct(_amount, 0, 0, 0, true, msg.sender);

313:         balances[senderOfTx] += whitelist[senderOfTx];

314:         balances[_recipient] -= whitelist[senderOfTx];

316:         emit WhiteListTransfer(_recipient);

320:         return (whiteListStruct[sender].paymentStatus, whiteListStruct[sender].amount);

```

### <a name="NC-18"></a>[NC-18] Contract does not follow the Solidity style guide's suggested layout ordering
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
   VariableDeclaration.tradeFlag
   VariableDeclaration.basicFlag
   VariableDeclaration.dividendFlag
   VariableDeclaration.totalSupply
   VariableDeclaration.paymentCounter
   VariableDeclaration.balances
   VariableDeclaration.tradePercent
   VariableDeclaration.contractOwner
   VariableDeclaration.tradeMode
   VariableDeclaration.payments
   VariableDeclaration.whitelist
   VariableDeclaration.administrators
   VariableDeclaration.isReady
   EnumDefinition.PaymentType
   VariableDeclaration.defaultPayment
   VariableDeclaration.paymentHistory
   StructDefinition.Payment
   StructDefinition.History
   VariableDeclaration.wasLastOdd
   VariableDeclaration.isOddWhitelistUser
   StructDefinition.ImportantStruct
   VariableDeclaration.whiteListStruct
   EventDefinition.AddedToWhitelist
   ModifierDefinition.onlyAdminOrOwner
   ModifierDefinition.checkIfWhiteListed
   EventDefinition.supplyChanged
   EventDefinition.Transfer
   EventDefinition.PaymentUpdated
   EventDefinition.WhiteListTransfer
   FunctionDefinition.constructor
   FunctionDefinition.getPaymentHistory
   FunctionDefinition.checkForAdmin
   FunctionDefinition.balanceOf
   FunctionDefinition.getTradingMode
   FunctionDefinition.addHistory
   FunctionDefinition.getPayments
   FunctionDefinition.transfer
   FunctionDefinition.updatePayment
   FunctionDefinition.addToWhitelist
   FunctionDefinition.whiteTransfer
   FunctionDefinition.getPaymentStatus
   FunctionDefinition.receive
   FunctionDefinition.fallback
   
   Suggested order:
   VariableDeclaration.tradeFlag
   VariableDeclaration.basicFlag
   VariableDeclaration.dividendFlag
   VariableDeclaration.totalSupply
   VariableDeclaration.paymentCounter
   VariableDeclaration.balances
   VariableDeclaration.tradePercent
   VariableDeclaration.contractOwner
   VariableDeclaration.tradeMode
   VariableDeclaration.payments
   VariableDeclaration.whitelist
   VariableDeclaration.administrators
   VariableDeclaration.isReady
   VariableDeclaration.defaultPayment
   VariableDeclaration.paymentHistory
   VariableDeclaration.wasLastOdd
   VariableDeclaration.isOddWhitelistUser
   VariableDeclaration.whiteListStruct
   EnumDefinition.PaymentType
   StructDefinition.Payment
   StructDefinition.History
   StructDefinition.ImportantStruct
   EventDefinition.AddedToWhitelist
   EventDefinition.supplyChanged
   EventDefinition.Transfer
   EventDefinition.PaymentUpdated
   EventDefinition.WhiteListTransfer
   ModifierDefinition.onlyAdminOrOwner
   ModifierDefinition.checkIfWhiteListed
   FunctionDefinition.constructor
   FunctionDefinition.getPaymentHistory
   FunctionDefinition.checkForAdmin
   FunctionDefinition.balanceOf
   FunctionDefinition.getTradingMode
   FunctionDefinition.addHistory
   FunctionDefinition.getPayments
   FunctionDefinition.transfer
   FunctionDefinition.updatePayment
   FunctionDefinition.addToWhitelist
   FunctionDefinition.whiteTransfer
   FunctionDefinition.getPaymentStatus
   FunctionDefinition.receive
   FunctionDefinition.fallback

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

### <a name="NC-19"></a>[NC-19] Internal and private variables and functions names should begin with an underscore
According to the Solidity Style Guide, Non-`external` variable and function names should begin with an [underscore](https://docs.soliditylang.org/en/latest/style-guide.html#underscore-prefix-for-non-external-functions-and-variables)

*Instances (1)*:
```solidity
File: Gas.sol

49:     uint256 wasLastOdd = 1;

```

### <a name="NC-20"></a>[NC-20] Event is missing `indexed` fields
Index event fields make the field more quickly accessible to off-chain tools that parse events. However, note that each index field costs extra gas during emission, so it's not necessarily best to index the maximum allowed per event (three fields). Each event should use three indexed fields if there are three or more fields, and gas usage is not particularly of concern for the events in question. If there are fewer than three fields, all of the fields should be indexed.

*Instances (3)*:
```solidity
File: Gas.sol

62:     event AddedToWhitelist(address userAddress, uint256 tier);

100:     event Transfer(address recipient, uint256 amount);

101:     event PaymentUpdated(

```

### <a name="NC-21"></a>[NC-21] `public` functions not called by the contract should be declared `external` instead

*Instances (8)*:
```solidity
File: Gas.sol

130:     function getPaymentHistory()

148:     function balanceOf(address _user) public view returns (uint256 balance_) {

180:     function getPayments(address _user)

192:     function transfer(

225:     function updatePayment(

264:     function addToWhitelist(address _userAddrs, uint256 _tier)

296:     function whiteTransfer(

319:     function getPaymentStatus(address sender) public view returns (bool, uint256) {

```

### <a name="NC-22"></a>[NC-22] Variables need not be initialized to zero
The default value for variables is zero, so initializing them to zero is superfluous.

*Instances (9)*:
```solidity
File: Gas.sol

8:     uint256 public basicFlag = 0;

13:     uint256 public totalSupply = 0; // cannot be updated

14:     uint256 public paymentCounter = 0;

18:     uint256 public tradeMode = 0;

113:         for (uint256 ii = 0; ii < administrators.length; ii++) {

140:         for (uint256 ii = 0; ii < administrators.length; ii++) {

174:         for (uint256 i = 0; i < tradePercent; i++) {

219:         for (uint256 i = 0; i < tradePercent; i++) {

246:         for (uint256 ii = 0; ii < payments[_user].length; ii++) {

```


## Low Issues


| |Issue|Instances|
|-|:-|:-:|
| [L-1](#L-1) | Use a 2-step ownership transfer pattern | 1 |
| [L-2](#L-2) | Missing checks for `address(0)` when assigning values to address state variables | 1 |
| [L-3](#L-3) | Solidity version 0.8.20+ may not work on other chains due to `PUSH0` | 1 |
| [L-4](#L-4) | Use `Ownable2Step.transferOwnership` instead of `Ownable.transferOwnership` | 6 |
| [L-5](#L-5) | File allows a version of solidity that is susceptible to an assembly optimizer bug | 1 |
| [L-6](#L-6) | Unsafe ERC20 operation(s) | 2 |
### <a name="L-1"></a>[L-1] Use a 2-step ownership transfer pattern
Recommend considering implementing a two step process where the owner or admin nominates an account and the nominated account needs to call an `acceptOwnership()` function for the transfer of ownership to fully succeed. This ensures the nominated EOA account is a valid and active account. Lack of two-step procedure for critical operations leaves them error-prone. Consider adding two step procedure on the critical functions.

*Instances (1)*:
```solidity
File: Gas.sol

12: contract GasContract is Ownable, Constants {

```

### <a name="L-2"></a>[L-2] Missing checks for `address(0)` when assigning values to address state variables

*Instances (1)*:
```solidity
File: Ownable.sol

102:         _owner = newOwner;

```

### <a name="L-3"></a>[L-3] Solidity version 0.8.20+ may not work on other chains due to `PUSH0`
The compiler for Solidity 0.8.20 switches the default target EVM version to [Shanghai](https://blog.soliditylang.org/2023/05/10/solidity-0.8.20-release-announcement/#important-note), which includes the new `PUSH0` op code. This op code may not yet be implemented on all L2s, so deployment on these chains will fail. To work around this issue, use an earlier [EVM](https://docs.soliditylang.org/en/v0.8.20/using-the-compiler.html?ref=zaryabs.com#setting-the-evm-version-to-target) [version](https://book.getfoundry.sh/reference/config/solidity-compiler#evm_version). While the project itself may or may not compile with 0.8.20, other projects with which it integrates, or which extend this project may, and those projects will have problems deploying these contracts/libraries.

*Instances (1)*:
```solidity
File: Gas.sol

2: pragma solidity 0.8.0;

```

### <a name="L-4"></a>[L-4] Use `Ownable2Step.transferOwnership` instead of `Ownable.transferOwnership`
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

*Instances (6)*:
```solidity
File: Gas.sol

4: import "./Ownable.sol";

```

```solidity
File: Ownable.sol

48:         _transferOwnership(_msgSender());

81:         _transferOwnership(address(0));

88:     function transferOwnership(address newOwner) public virtual onlyOwner {

93:         _transferOwnership(newOwner);

100:     function _transferOwnership(address newOwner) internal virtual {

```

### <a name="L-5"></a>[L-5] File allows a version of solidity that is susceptible to an assembly optimizer bug
In solidity versions 0.8.13 and 0.8.14, there is an [optimizer bug](https://github.com/ethereum/solidity-blog/blob/499ab8abc19391be7b7b34f88953a067029a5b45/_posts/2022-06-15-inline-assembly-memory-side-effects-bug.md) where, if the use of a variable is in a separate `assembly` block from the block in which it was stored, the `mstore` operation is optimized out, leading to uninitialized memory. The code currently does not have such a pattern of execution, but it does use `mstore`s in `assembly` blocks, so it is a risk for future changes. The affected solidity versions should be avoided if at all possible.

*Instances (1)*:
```solidity
File: Gas.sol

2: pragma solidity 0.8.0;

```

### <a name="L-6"></a>[L-6] Unsafe ERC20 operation(s)

*Instances (2)*:
```solidity
File: Gas.sol

324:         payable(msg.sender).transfer(msg.value);

329:          payable(msg.sender).transfer(msg.value);

```


## Medium Issues


| |Issue|Instances|
|-|:-|:-:|
| [M-1](#M-1) | `block.number` means different things on different L2s | 1 |
| [M-2](#M-2) | Centralization Risk for trusted owners | 4 |
| [M-3](#M-3) | `call()` should be used instead of `transfer()` on an `address payable` | 2 |
### <a name="M-1"></a>[M-1] `block.number` means different things on different L2s
On Optimism, `block.number` is the L2 block number, but on Arbitrum, it's the L1 block number, and `ArbSys(address(100)).arbBlockNumber()` must be used. Furthermore, L2 block numbers often occur much more frequently than L1 block numbers (any may even occur on a per-transaction basis), so using block numbers for timing results in inconsistencies, especially when voting is involved across multiple chains. As of version 4.9, OpenZeppelin has [modified](https://blog.openzeppelin.com/introducing-openzeppelin-contracts-v4.9#governor) their governor code to use a clock rather than block numbers, to avoid these sorts of issues, but this still requires that the project [implement](https://docs.openzeppelin.com/contracts/4.x/governance#token_2) a [clock](https://eips.ethereum.org/EIPS/eip-6372) for each L2.

*Instances (1)*:
```solidity
File: Gas.sol

169:         history.blockNumber = block.number;

```

### <a name="M-2"></a>[M-2] Centralization Risk for trusted owners

#### Impact:
Contracts have owners with privileged rights to perform admin tasks and need to be trusted to not perform malicious updates or drain funds.

*Instances (4)*:
```solidity
File: Gas.sol

12: contract GasContract is Ownable, Constants {

```

```solidity
File: Ownable.sol

36: abstract contract Ownable is Context {

80:     function renounceOwnership() public virtual onlyOwner {

88:     function transferOwnership(address newOwner) public virtual onlyOwner {

```

### <a name="M-3"></a>[M-3] `call()` should be used instead of `transfer()` on an `address payable`
The use of the deprecated `transfer()` function for an address may make the transaction fail due to the 2300 gas stipend

*Instances (2)*:
```solidity
File: Gas.sol

324:         payable(msg.sender).transfer(msg.value);

329:          payable(msg.sender).transfer(msg.value);

```

