# Deploying new ERC20 as OFT

- When calling `sendFrom` adapterParams value must be > minDstGas
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

## General steps

1. Deploy your OFT contract, and specify the shared decimals (ie. where your ERC-20 decimals > shared-decimals).
2. Deploy your OFT contract on the other connected chain(s) and specify the shared decimals in relation to your other OFT.
3. Set your contracts to trust one another by calling on both contracts setTrustedRemoteAddress. Pair them to one another's chain and address.
4. Next, we're going to set our minimum Gas Limit for each chain. (Recommended 200k for all EVM chains except Arbitrum, 2M for Arbitrum). Call setMinDstGas with the chainId of the other chain, the packet type ("0" meaning send, "1" meaning send and call), and the gas limit amount.

(Make sure that your AdapterParams gas limit > setMinDstGas)
- OFTV2 on Endpoint V1
- https://docs.google.com/document/d/1Qsu5idleVxjbGFfT_kma7-qH42d4HH3rzfGJmJefyvk/edit?pli=1

# Deployment

Home: https://sepolia.etherscan.io/address/0x0959c593bB41A340Dcd9CA6c090c2F919000B28d#readContract
Away: https://goerli.etherscan.io/address/0x0adafb8574b3a59cf3176e1bd278c951c445d94d/advanced#readContract

## Docs

Repo: https://github.com/LayerZero-Labs/solidity-examples/blob/main/contracts/token/oft/v2/OFTV2.sol