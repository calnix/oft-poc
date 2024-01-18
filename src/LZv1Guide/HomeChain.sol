// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "lib/solidity-examples/contracts/token/oft/v2/OFTV2.sol";

contract TestToken is OFTV2 {

    constructor(    
        string memory _name,
        string memory _symbol,
        uint8 _sharedDecimals,
        address _lzEndpoint) OFTV2(_name, _symbol, _sharedDecimals, _lzEndpoint) {}


    function mint(uint256 amount) external {
        _mint(msg.sender, amount);
    }

    function burn(uint256 amount) external {
        _burn(msg.sender, amount);
    }
}
