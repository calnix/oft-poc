# Deploying new ERC20 as OFT

- When calling `sendFrom` adapterParams value must be > `minDstGas`
- `sendFrom` must have specified msg.value - obtained from `estimateSendFees`

## On adapterParams, minDstGas, estimateSendFees

So the quote returned equals the local gas cost on source + adapterParams. The problem is that nothing enforces the caller to use that quote, so to prevent DoS attacks by spamming the pathway, the `minDstGas` enforces a certain amount of gas (otherwise fail), while `adapterParams` are just the instructions for the Relayer of what to do with the message gas wise on destination.

Otherwise a user could pass a trivial amount of gas (say local cost + 1 gas) to attempt to deny service on the pathway.
It’s really more of a sanity check and ensures that users calling sendFrom are truly paying with an amount that isn’t trivial across all edge cases.

- In the case where I simply would want to bridge tokens across two chains, and nothing more - there is no need for additional instructions to be described with adapterParams.
- Simply pass the default values: defaultAdapterParams = `abi.encodePacked(uint256(1), uint256(2000000));`
- These values do not alter the gas sanity check enforced via setMinDstGas and msg.value.

## NativeOFT vs OFT

- Technically NativeOFT is meant for chains which want to deploy their token as the native gas token. They would deploy on home and remote (i think)NativeOFT -> NativeOFT.
- Otherwise, use OFTV2 to OFTV2 (POC uses this).

## SharedDecimals

- If deploying only on EVM chains and adhering to the 18 dp standard, sharedDecimals = 8.

## On versioning

- Native and OFTV2 are thought of as Endpoint V1 OFT V2
- we also have an Endpoint V1 OFT V1,
- and now also an Endpoint V2 OFT

https://layerzero.gitbook.io/docs/evm-guides/code-examples/oft-overview/v1-oft-vs-v2-oft-which-should-i-use

- docs.layerzero.network are strictly for Endpoint V2
- https://layerzero.gitbook.io/docs/ for Endpoint v1

## Docs

Repo: https://github.com/LayerZero-Labs/solidity-examples/blob/main/contracts/token/oft/v2/OFTV2.sol

## Inheritance and Execution flow

### OFTV2 is BaseOFTV2, ERC20

### BaseOFTV2 is OFTCoreV2, ERC165, IOFTV2
- sendFrom
- sendAndCall
- estimateSendFee
- estimateSendAndCallFee

### OFTCoreV2 
- callOnOFTReceived

### sendAndCall -> _sendAndCall -> _lzSend (LzApp.sol)

- _sendAndCall is defined on OFTCoreV2.sol
- _lzSend is defined on LzApp.sol

### _nonblockingLzReceive -> _sendAck / _sendAndCallAck

## To follow-up on

- NativeOFT can use the token as gas payment? How so?