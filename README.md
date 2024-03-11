# Benchmark results

| Measurement      | Initial           | Final             | Difference        |
| ---------------- | ----------------- | ----------------- | ----------------- |
| Deployment Cost  | 2790345           | 527889            | -2262456 (-81.081%)
| Deployment Size  | 12630             | 2361              | -10269 (-81.306%)

#### The following optimization-related changes are made:
- unused contract fields, struct fields, and enum values have been removed
- unused name returns have been removed
- unnecessary inheritance has been removed
- unnecessary initializations to default values have been removed
- local variables that are used to store the `msg.sender` have been removed
- unnecessary input validations have been removed
- the `receive` function has been removed
- storage variables are replaced with constants and immutables
- the visibility of storage variables has been changed from `public` to `private`
- the state mutability of functions has been changed from `view` to `pure` and from `payable` to `view`
- struct packing has been applied
- `unchecked` math has been applied
- shorter error messages are now used in `require` and `revert` statements
- storage variables that are frequently accessed have been cached for quicker retrieval
- the counter in for loops has been pre-incremented instead of post-incremented
- early returns have been executed in loops when a match has been found
- named returns have been used
- `require` statements have been replaced with `assert` statements
- "dead code" has been removed

# GAS OPTIMSATION 

- Your task is to edit and optimise the Gas.sol contract. 
- You cannot edit the tests & 
- All the tests must pass.
- You can change the functionality of the contract as long as the tests pass. 
- Try to get the gas usage as low as possible. 



## To run tests & gas report with verbatim trace 
Run: `forge test --gas-report -vvvv`

## To run tests & gas report
Run: `forge test --gas-report`

## To run a specific test
RUN:`forge test --match-test {TESTNAME} -vvvv`
EG: `forge test --match-test test_onlyOwner -vvvv`