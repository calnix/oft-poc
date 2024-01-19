# General steps

## OFTV2 on Endpoint V1

1. Deploy your OFT contract, and specify the shared decimals (ie. where your ERC-20 decimals > shared-decimals).
2. Deploy your OFT contract on the other connected chain(s) and specify the shared decimals in relation to your other OFT.
3. Set your contracts to trust one another by calling on both contracts setTrustedRemoteAddress. Pair them to one another's chain and address.
4. Set the minimum Gas Limit for each chain. (Recommended 200k for all EVM chains except Arbitrum, 2M for Arbitrum). Call setMinDstGas with the chainId of the other chain, the packet type ("0" meaning send, "1" meaning send and call), and the gas limit amount.
5. Approvals must be granted to the home chain token contract, for it to take possession of the NFT from the user during x-chain transmission. 

> https://docs.google.com/document/d/1Qsu5idleVxjbGFfT_kma7-qH42d4HH3rzfGJmJefyvk/edit?pli=1

(Make sure that your AdapterParams gas limit > setMinDstGas)

## OFTV1 on Endpoint V1: ERC721

1. Deploy your OFT contract. NFTs do not have decimal places, so there is no concern of shared decimals.
2. Deploy your OFT contract on the other connected chain(s).
3. Set your contracts to trust one another by calling on both contracts setTrustedRemoteAddress. Pair them to one another's chain and address.
4. Next, we're going to set our minimum Gas Limit for each chain. (Recommended 260K for all EVM chains except Arbitrum, 2M for Arbitrum). Call setMinDstGas with the chainId of the other chain, the packet type ("0" meaning send, "1" meaning send and call), and the gas limit amount.
5. ERC721 transmission requires that minimum gas limits be set for both packet types. If packet type "1" was not set, transaction will revert. 
6. Approvals must be granted to the home chain token contract, for it to take possession of the NFT from the user during x-chain transmission. 

> If deploying NFT adjust minGas to 260K.
> https://layerzero.gitbook.io/docs/evm-guides/code-examples/onft-overview/deployment-guide

## Links and Misc

- Testnet Endpoints: https://layerzero.gitbook.io/docs/technical-reference/testnet/testnet-addresses#
- Repo: https://github.com/LayerZero-Labs/solidity-examples/blob/main/contracts/token/onft721/ONFT721.sol
- Native OFTv2 Contract <> Native OFTv2 Contract: when you want to pay gas fees in the issued token.
- OFTv2 <> OFTv2: when you have not yet deployed a token.
- ProxyOFTv2 <> OFTv2: when token is already deployed.

## Testnet Faucts

- Alchemy, Infura, Quicknode
- If usual faucets are down, blocked or on cooldown: https://sepolia-faucet.pk910.de/
- Run on desktop and max the runners, give or take a few hours.