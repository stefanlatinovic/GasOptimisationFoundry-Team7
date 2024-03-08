Summary
 - [uninitialized-local](#uninitialized-local) (2 results) (Medium)
 - [incorrect-modifier](#incorrect-modifier) (1 results) (Low)
 - [boolean-equal](#boolean-equal) (2 results) (Informational)
 - [dead-code](#dead-code) (1 results) (Informational)
 - [solc-version](#solc-version) (3 results) (Informational)
 - [naming-convention](#naming-convention) (18 results) (Informational)
 - [unused-state](#unused-state) (1 results) (Informational)
 - [cache-array-length](#cache-array-length) (2 results) (Optimization)
 - [constable-states](#constable-states) (6 results) (Optimization)
 - [immutable-states](#immutable-states) (2 results) (Optimization)
## uninitialized-local
Impact: Medium
Confidence: Medium
 - [ ] ID-0
[GasContract.transfer(address,uint256,string).payment](src/Gas.sol#L209) is a local variable never initialized

src/Gas.sol#L209


 - [ ] ID-1
[GasContract.addHistory(address,bool).history](src/Gas.sol#L168) is a local variable never initialized

src/Gas.sol#L168


## incorrect-modifier
Impact: Low
Confidence: High
 - [ ] ID-2
Modifier [GasContract.onlyAdminOrOwner()](src/Gas.sol#L64-L79) does not always execute _; or revert
src/Gas.sol#L64-L79


## boolean-equal
Impact: Informational
Confidence: High
 - [ ] ID-3
[GasContract.addHistory(address,bool)](src/Gas.sol#L164-L178) compares to a boolean constant:
	-[((status[0] == true),_tradeMode)](src/Gas.sol#L177)

src/Gas.sol#L164-L178


 - [ ] ID-4
[GasContract.transfer(address,uint256,string)](src/Gas.sol#L192-L223) compares to a boolean constant:
	-[(status[0] == true)](src/Gas.sol#L222)

src/Gas.sol#L192-L223


## dead-code
Impact: Informational
Confidence: Medium
 - [ ] ID-5
[Context._msgData()](src/Ownable.sol#L19-L21) is never used and should be removed

src/Ownable.sol#L19-L21


## solc-version
Impact: Informational
Confidence: High
 - [ ] ID-6
Pragma version[0.8.0](src/Ownable.sol#L2) allows old versions

src/Ownable.sol#L2


 - [ ] ID-7
Pragma version[0.8.0](src/Gas.sol#L2) allows old versions

src/Gas.sol#L2


 - [ ] ID-8
solc-0.8.0 is not recommended for deployment

## naming-convention
Impact: Informational
Confidence: High
 - [ ] ID-9
Constant [GasContract.defaultPayment](src/Gas.sol#L30) is not in UPPER_CASE_WITH_UNDERSCORES

src/Gas.sol#L30


 - [ ] ID-10
Parameter [GasContract.updatePayment(address,uint256,uint256,GasContract.PaymentType)._type](src/Gas.sol#L229) is not in mixedCase

src/Gas.sol#L229


 - [ ] ID-11
Parameter [GasContract.whiteTransfer(address,uint256)._amount](src/Gas.sol#L298) is not in mixedCase

src/Gas.sol#L298


 - [ ] ID-12
Parameter [GasContract.addToWhitelist(address,uint256)._userAddrs](src/Gas.sol#L264) is not in mixedCase

src/Gas.sol#L264


 - [ ] ID-13
Parameter [GasContract.getPayments(address)._user](src/Gas.sol#L180) is not in mixedCase

src/Gas.sol#L180


 - [ ] ID-14
Parameter [GasContract.updatePayment(address,uint256,uint256,GasContract.PaymentType)._user](src/Gas.sol#L226) is not in mixedCase

src/Gas.sol#L226


 - [ ] ID-15
Parameter [GasContract.transfer(address,uint256,string)._name](src/Gas.sol#L195) is not in mixedCase

src/Gas.sol#L195


 - [ ] ID-16
Parameter [GasContract.transfer(address,uint256,string)._amount](src/Gas.sol#L194) is not in mixedCase

src/Gas.sol#L194


 - [ ] ID-17
Parameter [GasContract.transfer(address,uint256,string)._recipient](src/Gas.sol#L193) is not in mixedCase

src/Gas.sol#L193


 - [ ] ID-18
Parameter [GasContract.addHistory(address,bool)._tradeMode](src/Gas.sol#L164) is not in mixedCase

src/Gas.sol#L164


 - [ ] ID-19
Parameter [GasContract.updatePayment(address,uint256,uint256,GasContract.PaymentType)._ID](src/Gas.sol#L227) is not in mixedCase

src/Gas.sol#L227


 - [ ] ID-20
Parameter [GasContract.whiteTransfer(address,uint256)._recipient](src/Gas.sol#L297) is not in mixedCase

src/Gas.sol#L297


 - [ ] ID-21
Parameter [GasContract.addToWhitelist(address,uint256)._tier](src/Gas.sol#L264) is not in mixedCase

src/Gas.sol#L264


 - [ ] ID-22
Parameter [GasContract.checkForAdmin(address)._user](src/Gas.sol#L138) is not in mixedCase

src/Gas.sol#L138


 - [ ] ID-23
Parameter [GasContract.balanceOf(address)._user](src/Gas.sol#L148) is not in mixedCase

src/Gas.sol#L148


 - [ ] ID-24
Parameter [GasContract.updatePayment(address,uint256,uint256,GasContract.PaymentType)._amount](src/Gas.sol#L228) is not in mixedCase

src/Gas.sol#L228


 - [ ] ID-25
Event [GasContract.supplyChanged(address,uint256)](src/Gas.sol#L99) is not in CapWords

src/Gas.sol#L99


 - [ ] ID-26
Parameter [GasContract.addHistory(address,bool)._updateAddress](src/Gas.sol#L164) is not in mixedCase

src/Gas.sol#L164


## unused-state
Impact: Informational
Confidence: High
 - [ ] ID-27
[GasContract.defaultPayment](src/Gas.sol#L30) is never used in [GasContract](src/Gas.sol#L12-L332)

src/Gas.sol#L30


## cache-array-length
Impact: Optimization
Confidence: High
 - [ ] ID-28
Loop condition [ii < administrators.length](src/Gas.sol#L113) should use cached array length instead of referencing `length` member of the storage array.
 
src/Gas.sol#L113


 - [ ] ID-29
Loop condition [ii < administrators.length](src/Gas.sol#L140) should use cached array length instead of referencing `length` member of the storage array.
 
src/Gas.sol#L140


## constable-states
Impact: Optimization
Confidence: High
 - [ ] ID-30
[GasContract.tradePercent](src/Gas.sol#L16) should be constant 

src/Gas.sol#L16


 - [ ] ID-31
[GasContract.tradeMode](src/Gas.sol#L18) should be constant 

src/Gas.sol#L18


 - [ ] ID-32
[Constants.dividendFlag](src/Gas.sol#L9) should be constant 

src/Gas.sol#L9


 - [ ] ID-33
[GasContract.isReady](src/Gas.sol#L22) should be constant 

src/Gas.sol#L22


 - [ ] ID-34
[Constants.tradeFlag](src/Gas.sol#L7) should be constant 

src/Gas.sol#L7


 - [ ] ID-35
[Constants.basicFlag](src/Gas.sol#L8) should be constant 

src/Gas.sol#L8


## immutable-states
Impact: Optimization
Confidence: High
 - [ ] ID-36
[GasContract.contractOwner](src/Gas.sol#L17) should be immutable 

src/Gas.sol#L17


 - [ ] ID-37
[GasContract.totalSupply](src/Gas.sol#L13) should be immutable 

src/Gas.sol#L13


