# Solidity

Minotaur grammar for Solidity, covering the core language subset.

## Syntax sketch

```
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract Counter {
    uint256 public count;
    event Incremented(uint256 newCount);

    function increment() public {
        count += 1;
        emit Incremented(count);
    }
}
```

## AST validation goals

- pragma solidity present
- emit statements reference declared events
- state variables have explicit visibility

Implements issue #87.
