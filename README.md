# Setup

## Installation

Run both commands:

- `forge install`
- `npm install`

### Probably

Reference: https://book.getfoundry.sh/config/hardhat#instructions

Can ignore hh setup, just install npm modules -> should appear under dir: node_modules
edit remapping to reference node_modules

but should make hh compatible - cleaner.

## ERC20 Deployment

Home: https://sepolia.etherscan.io/address/0x0959c593bB41A340Dcd9CA6c090c2F919000B28d
Away: https://goerli.etherscan.io/address/0x0adafb8574b3a59cf3176e1bd278c951c445d94d
https://testnet.layerzeroscan.com/tx/0x7b0c345c8f52dcfaa5fa3a6a8aa47b91667db90e71aa48d7c2b21118054d4b0c

Using OFTV2 standard on LZ Endpoints V1.

When sending tokens form source to destination, supply is burnt on the source.

- 10 tokens minted on source
- 1 token sent to destination
- 9 tokens on source, 1 token on destination

This is clearly reflected by the total supply on each token contract across all chains.
This allows us to maintain a fixed supply of tokens, spread across multiple chains.

## ERC721 Deployment

### Batch #1:


- Home: https://sepolia.etherscan.io/address/0x21bb6bde0ba97c4a595d660df852c0579f14bac9
- Away: https://goerli.etherscan.io/address/0x9ba3a554ea4ab7a72b83f5d5ae5be7b9138de2a3

- 1st Txn, TokenId 2: https://testnet.layerzeroscan.com/tx/0x8bf2d488d477e3b94703f0111dff7f639e944d637f8c1d17cf7cb1fc79210b94                (Sepolia → Goerli)
- 2nd Txn, TokenId 2: https://testnet.layerzeroscan.com/address/0x04704588b0949986b5da983e3e8b032f7a12357f75b5e2771af10d5584db4ed9           (Goerli → Sepolia)

Using OFTV1 standard on LZ Endpoints V1.
OFTV2 for NFTs are still being worked on.

Gas limits set to 260K. Transaction on destination reverts mid-way.
All sending on the source chain is fine. Issue lies with destination.

## Next steps

- Testing cross-chain call linkage/chaining. This can be thought of in the case of staking in source, action taken in destination.

## Other notes

- The OFTV2_EndpointV2 dir is following the latest quickstart guide, as illustrated on the website (docs.layerzero.network).
- Advised by Matt to follow internal doc using OFTV2 on Endpoints V1.
- Ignore OFTV2_EndpointV2 for now - may be useful in the future for a more updated POC - particularly with EVM <> Non-EVM communication.

## On Execution flow

srcChain::MyContract -> srcChain::LzEndpoint =====> dstChainL::LzEndPoint ---> dstChain::MyContract

dstChain::MyContract must implement ILayerZeroReceiver interface and override the lzReceive() function.

- inherit LzApp to implement ILayerZeroReceiver interface [?]
- ensure lzReceive() is overridden to handle receiving messages
--> lzReceive() handles the incoming x-chain msg; used by endpoints.
--> Dapp will be relayed msg from endpoint; so should overwrite the default logic with what should be done with incoming payload

Note: If your contract derives from LzApp, do not call lzEndpoint.send directly, use _lzSend.

There are two ways to implement lzReceive within a specific LzApp implementation.

### What is the difference btw _blockingLzReceive and _nonBlockingLzReceive?

- _blockingLzReceive ensures that messages are processed in the order they were sent from a source User Application (srcUA) to all destination User Applications (dstUA) on the same chain.
-  _nonBlockingLzReceive function is used in user applications to handle incoming messages in a way that avoids blocking the message queue. It does this by catching errors or exceptions locally, allowing for future retries without disrupting the flow of messages at the destination LayerZero Endpoint

blocking is essentially FIFO. nonblocking might have random order.

## adapterParams

A bytes array that contains custom instructions for how a LZ Relayer should transmit the transaction. Custom instructions include:

1. The upper limit on how much destination gas to spend
2. Instructing the relayer to airdrop native currency to a specified wallet address