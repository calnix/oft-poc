// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

import "@layerzerolabs/lz-evm-oapp-v2/contracts/oft/OFT.sol";

contract SLVRToken is OFT {
    constructor(string memory _name, string memory _symbol, 
        address _lzEndpoint, // LayerZero Endpoint address
        address _owner // token owner
    ) OFT(_name, _symbol, _lzEndpoint, _owner) {
        // your contract logic here
        _mint(_msgSender(), 100 * 10 * decimals()); // mints 100 tokens to the deployer
    }

    //send function in OFTCore.sol

}











/**

On decimals
 By default, the OFT follows ERC20 convention and uses a value of 18 for decimals. 
 To use a different value, you will need to override the decimals() function in your contract.

On shared decimals
 EVM chains support uint256 for token balances, many non-EVM environments use uint64.
 Because of this, the default OFT Standard has a max token supply 2^64 - 1, or 1,844,674,407,370,955.1615. 
 This ensures that token transfers won't fail due to a loss of precision or unexpected balance conversions.
 By default, an OFT has 6 sharedDecimals, which is optimal for most ERC20 use cases that use 18 decimals.


Sending Logic
 
 send function on OFTCore.sol
 when send() is called, _debit() is invovked, triggering the ERC20 token on the source chain to be burned
 can override _debit() with any additional logic you want to execute, before the message is sent out via LZ, 
  for example, taking custom fees.
 
 _debit() provides two different methods you can also override for burning the source token depending on your application's use case:
 1. _debitSender()
 2. _debitThis()
 
 _debitSender(): burns the specific amount of source tokens from the msg.sender, initializing the cross-chain mint.
    ` _burn(msg.sender, amountDebitedLD);`
 
 _debitThis(): allows the sender to deposit source tokens into the OFT contract to be burnt, initiating the cross-chain mint.
    `_burn(address(this), amountDebitedLD);`

 Fundamentally, _debitThis() burns some tokens that were already deposited into the OFT contract. 
  someone else could have deposited earlier, while another person inits the LZ txn and burning.

 Both _debitSender() and _debitThis() use _debitView() to handle how many tokens should be debited on the source chain, versus credited on the destination.
  _debitSender(): '(amountDebitedLD, amountToCreditLD) = _debitView(_amountToSendLD, _minAmountToReceiveLD, _dstEid);'
  _debitThis(): '(amountDebitedLD, amountToCreditLD) = _debitView(balanceOf(address(this)), _minAmountToReceiveLD, _dstEid);'

  

 */