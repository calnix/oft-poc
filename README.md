## Setup

install LZ:
forge install LayerZero-Labs/LayerZero-v2 --no-commit

need to install missing dependencies: 
 - openzeppelin/contracts

https://book.getfoundry.sh/config/hardhat#instructions

# npm

npm install @layerzerolabs/lz-evm-oapp-v2

create remappings.txt:
- @layerzerolabs/=node_modules/@layerzerolabs


LZ remappings ref:
https://github.com/LayerZero-Labs/LayerZero-v2/blob/main/oapp/foundry.toml


# honestlys,

ignore hh setup, just install npm modules -> should appear under dir: node_modules
edit remapping to reference node_modules


but should make hh compatible - cleaner.

# setTrustedRemotes

## Mumbai <> Goerli

Mumbai: 0xC269ff8C6D002B8Aa011426f0efe98DD8A610C85
Goerli: 

### On Goerli:: setTrustedRemote()

_remoteChainId (uint16): 10109
_path (bytes): 0xbebf0d2998ff913de24dcf9076af7e98fb11ea57bebf0d2998ff913de24dcf9076af7e98fb11ea57

_remoteChainId is the chainID of the remote chain. so mumbai is remote: 10109

_path is concats the remote and the local contract address using abi.encodePacked().
 ethers.utils.solidityPack(['address','address'],[REMOTE_ADDRESS, LOCAL_ADDRESS])


### On Mumbai:: setTrustedRemote()
10121 (goerlie's id)
0xbebf0d2998ff913de24dcf9076af7e98fb11ea57bebf0d2998ff913de24dcf9076af7e98fb11ea57

# set minimum Gas Limit for each chain

- Recommended 200k for all EVM chains except Arbitrum, 2M for Arbitrum 
- Call `setMinDstGas` with the chainId of the other chain, the packet type ("0" meaning send, "1" meaning send and call), and the gas limit amount.

MumbaiChainID: 10109
GoerliChainID: 10121

On polygon, `setMinDstGas`:
- 10121
- 0 
- 200000

On goerli, `setMinDstGas`:
- 10109
- 0 
- 200000

> mumbia is home chain

# Sending txn

sendFrom() mumbai to goerli:

- payableAmount: 0 (msg.value, ether)
- _from: 0x2BF003ec9B7e2a5A8663d6B0475370738FA39825 (my eoa)
- _dstChainId: 10121
- _toAddress: 0xBEBF0d2998fF913De24dCf9076Af7e98Fb11eA57
- _amount: 


# To follow-up on

- NativeOFT can use the token as gas payment? How so?
- 