Summary
 - [dead-code](#dead-code) (1 results) (Informational)
 - [solc-version](#solc-version) (4 results) (Informational)
 - [naming-convention](#naming-convention) (8 results) (Informational)
## dead-code
Impact: Informational
Confidence: Medium
 - [ ] ID-0
[Context._msgData()](src/Ownable.sol#L19-L21) is never used and should be removed

src/Ownable.sol#L19-L21


## solc-version
Impact: Informational
Confidence: High
 - [ ] ID-1
Pragma version[0.8.0](src/Ownable.sol#L2) allows old versions

src/Ownable.sol#L2


 - [ ] ID-2
solc-0.8.0 is not recommended for deployment

 - [ ] ID-3
Pragma version[^0.8.22](src/Gas.sol#L2) necessitates a version too recent to be trusted. Consider deploying with 0.8.18.

src/Gas.sol#L2


 - [ ] ID-4
solc-0.8.24 is not recommended for deployment

## naming-convention
Impact: Informational
Confidence: High
 - [ ] ID-5
Parameter [GasContract.whiteTransfer(address,uint256)._amount](src/Gas.sol#L82) is not in mixedCase

src/Gas.sol#L82


 - [ ] ID-6
Parameter [GasContract.addToWhitelist(address,uint256)._userAddrs](src/Gas.sol#L65) is not in mixedCase

src/Gas.sol#L65


 - [ ] ID-7
Parameter [GasContract.transfer(address,uint256,string)._amount](src/Gas.sol#L57) is not in mixedCase

src/Gas.sol#L57


 - [ ] ID-8
Parameter [GasContract.transfer(address,uint256,string)._recipient](src/Gas.sol#L56) is not in mixedCase

src/Gas.sol#L56


 - [ ] ID-9
Parameter [GasContract.whiteTransfer(address,uint256)._recipient](src/Gas.sol#L81) is not in mixedCase

src/Gas.sol#L81


 - [ ] ID-10
Parameter [GasContract.addToWhitelist(address,uint256)._tier](src/Gas.sol#L65) is not in mixedCase

src/Gas.sol#L65


 - [ ] ID-11
Parameter [GasContract.checkForAdmin(address)._user](src/Gas.sol#L41) is not in mixedCase

src/Gas.sol#L41


 - [ ] ID-12
Parameter [GasContract.balanceOf(address)._user](src/Gas.sol#L51) is not in mixedCase

src/Gas.sol#L51


