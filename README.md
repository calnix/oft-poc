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

Home: https://sepolia.etherscan.io/address/0x4a28022ed61910b4dc3dbf0522a0847d5dcc3a58
Away: https://goerli.etherscan.io/address/0x9922e648f1af6b6f6c9e32c896bce8c693747901

1st Txn, TokenId 0: https://testnet.layerzeroscan.com/tx/0x6d121167a86cd5a9a5d53e46b5e5c5a9a14a7feb3267ef94ff7dc897f6170c13
2nd Txn, TokenId 1: https://testnet.layerzeroscan.com/tx/0x8adfe769e6f316e46da20c05f4141c65cd8247e2a6899f4a4c8c9543983d424a

Gas limits set to 200K. Transaction on destination reverts mid-way.
All sending on the source chain is fine. Issue lies with destination.

### Batch #2:

Home: https://sepolia.etherscan.io/address/0x15ae41e237c524c8150134375ede3ccb725dabf8
Away: https://goerli.etherscan.io/address/0x9922e648f1af6b6f6c9e32c896bce8c693747901

1st Txn, TokenId 0: https://testnet.layerzeroscan.com/tx/0x7b0c345c8f52dcfaa5fa3a6a8aa47b91667db90e71aa48d7c2b21118054d4b0c

Using OFTV1 standard on LZ Endpoints V1.
OFTV2 for NFTs are still being worked on.

Gas limits set to 260K. Transaction on destination reverts mid-way.
All sending on the source chain is fine. Issue lies with destination.

## Next steps

- Resolve NFT POC hiccup.
- Testing cross-chain call linkage/chaining. This can be thought of in the case of staking in source, action taken in destination.

## Other notes

- The OFTV2_EndpointV2 dir is following the latest quickstart guide, as illustrated on the website (docs.layerzero.network).
- Advised by Matt to follow internal doc using OFTV2 on Endpoints V1.
- Ignore OFTV2_EndpointV2 for now - may be useful in the future for a more updated POC - particularly with EVM <> Non-EVM communication.