// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console2} from "forge-std/Script.sol";

import {TestNFT} from "../src/OFTV2-EPV1/ERC721/TestNFT.sol"; 

abstract contract LZState {
    uint16 public sepoliaID = 10161;
    address public sepoliaEP = 0xae92d5aD7583AD66E49A0c67BAd18F6ba52dDDc1;

    uint16 public mumbaiID = 10109;
    address public mumbaiEP = 0xf69186dfBa60DdB133E91E9A4B5673624293d8F8;

    uint16 public goerliID = 10121;
    address public goerliEP = 0xbfD2135BFfbb0B5378b56643c2Df8a87552Bfa23;

    uint16 public arbgoerliID = 10143;
    address public arbgoerliEP = 0x6aB5Ae6822647046626e83ee6dB8187151E1d5ab;
}


//Note: Sepolia
contract DeployHome is Script, LZState {
    
    function run() public {

        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        TestNFT testNFTHome = new TestNFT("TestNFT", "TT", 100_000, sepoliaEP);
        vm.stopBroadcast();
    }
}


//    forge script script/DeployNFT.s.sol:DeployHome --rpc-url sepolia --broadcast --verify -vvvv --etherscan-api-key sepolia



//Note: goerli
contract DeployAway is Script, LZState {

    function run() public {

        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        TestNFT testNFTAway = new TestNFT("TestNFT", "TT", 100_000, sepoliaEP);
        vm.stopBroadcast();
    }
}

// forge script script/DeployNFT.s.sol:DeployAway --rpc-url goerli --broadcast --verify -vvvv --etherscan-api-key goerli


//------------------------------ SETUP ------------------------------------

abstract contract State is LZState {

    address payable public homeChainTokenContract = payable(0x15aE41e237c524c8150134375EdE3cCB725DAbF8);    //sepolia
    address public awayChainTokenContract = 0x9922E648F1Af6B6f6c9E32c896Bce8C693747901;                     //goerli

    uint16 public homeChainId = sepoliaID;      //sepolia
    uint16 public awayChainId = goerliID;       //goerli

}


// ------------------------------------------- Trusted Remotes: connect contracts -------------------------
contract SetRemoteOnHome is State, Script {

    function run() public  {

        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        TestNFT testNFT = TestNFT(homeChainTokenContract);

        // bytes path: concats the remote and the local contract address using abi.encodePacked(): [REMOTE_ADDRESS, LOCAL_ADDRESS]
        uint16 remoteChainId = awayChainId;
        address remote = awayChainTokenContract;
        address local = homeChainTokenContract;
        bytes memory path = abi.encodePacked(remote, local);
        
        testNFT.setTrustedRemote(remoteChainId, path); 

        vm.stopBroadcast();
    }
}

// forge script script/DeployNFT.s.sol:SetRemoteOnHome --rpc-url sepolia --broadcast -vvvv

contract SetRemoteOnAway is State, Script {

    function run() public {
        
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        TestNFT testNFT = TestNFT(awayChainTokenContract);

        // path: change the order on remote and local
        uint16 remoteChainId = homeChainId;
        address remote = homeChainTokenContract;
        address local = awayChainTokenContract;
        bytes memory path = abi.encodePacked(remote, local);
        
        testNFT.setTrustedRemote(remoteChainId, path); 

        vm.stopBroadcast();
    }

}

// forge script script/DeployNFT.s.sol:SetRemoteOnAway --rpc-url goerli --broadcast -vvvv


// ------------------------------------------- Gas Limits -------------------------
contract SetGasLimitsHome is State, Script {

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        TestNFT testNFT = TestNFT(homeChainTokenContract);

        //uint16 _dstChainId,
        //uint16 _packetType,
        //uint _minGas
        testNFT.setMinDstGas(awayChainId, 0, 260000);
        testNFT.setMinDstGas(awayChainId, 1, 260000);   //rrequired for mint/burn NFT transfer

        vm.stopBroadcast();
    }
}

// forge script script/DeployNFT.s.sol:SetGasLimitsHome --rpc-url sepolia --broadcast -vvvv


contract SetGasLimitsAway is State, Script {

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);
        
        TestNFT testNFT = TestNFT(awayChainTokenContract);

        //uint16 _dstChainId,
        //uint16 _packetType,
        //uint _minGas
        testNFT.setMinDstGas(homeChainId, 0, 260000);
        testNFT.setMinDstGas(homeChainId, 1, 260000);

        vm.stopBroadcast();
    }
}

// forge script script/DeployNFT.s.sol:SetGasLimitsAway --rpc-url goerli --broadcast -vvvv



// ------------------------------------------- Send sum tokens  -------------------------

import "lib/solidity-examples/contracts/token/oft/v2/interfaces/ICommonOFT.sol";

//Note: Minting on Home:Sepolia
contract MintApprove is State, Script {
    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        TestNFT testNFT = TestNFT(homeChainTokenContract);

        //uint256 tokenID used: 0
        uint256 tokenID = 0;
        testNFT.mint(tokenID);
        testNFT.approve(homeChainTokenContract, tokenID); //owner must give approval to homeChainTokenContract; not lzEndpoint

        vm.stopBroadcast();    
    }
}

// forge script script/DeployNFT.s.sol:MintApprove --rpc-url sepolia --broadcast -vvvv


//Note: sepolia -> goerli
contract SendTokensToAway is State, Script {

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        TestNFT testNFT = TestNFT(homeChainTokenContract);

        // defaultAdapterParams: min/max gas?
        bytes memory defaultAdapterParams = abi.encodePacked(uint16(1), uint256(260000));
        
        uint256 _tokenId = 0;
        bytes32 toAddressBytes32 = bytes32(uint256(uint160(0x2BF003ec9B7e2a5A8663d6B0475370738FA39825)));
        bytes memory toAddress = bytes.concat(toAddressBytes32);
        
        /**
        -- estimateSendFee porams --
        uint16 _dstChainId,
        bytes memory _toAddress,
        uint _tokenId,
        bool _useZro,
        bytes memory _adapterParams

        */

        (uint256 nativeFee, ) = testNFT.estimateSendFee(goerliID, toAddress, _tokenId, false, defaultAdapterParams);

        /**
        * @dev send `_amount` amount of token to (`_dstChainId`, `_toAddress`) from `_from`
        * `_from` the owner of token
        * `_dstChainId` the destination chain identifier
        * `_toAddress` can be any size depending on the `dstChainId`.
        * `_amount` the quantity of tokens in wei
        * `_refundAddress` the address LayerZero refunds if too much message fee is sent
        * `_zroPaymentAddress` set to address(0x0) if not paying in ZRO (LayerZero Token)
        * `_adapterParams` is a flexible bytes array to indicate messaging adapter services
        */ 

        // sender sends tokens to himself on the remote chain
        
        address from = 0x2BF003ec9B7e2a5A8663d6B0475370738FA39825;
        uint16 dstChainId = goerliID;
        
        //ICommonOFT.LzCallParams memory _callParams;
        //_callParams = ICommonOFT.LzCallParams({refundAddress: payable(0x2BF003ec9B7e2a5A8663d6B0475370738FA39825), zroPaymentAddress: address(0), adapterParams: defaultAdapterParams});

        testNFT.sendFrom{value: nativeFee}(from, dstChainId, toAddress, _tokenId, payable(0x2BF003ec9B7e2a5A8663d6B0475370738FA39825), address(0), defaultAdapterParams);
        
        /**
        --- sendFrom params ---
            address _from,
            uint16 _dstChainId,
            bytes memory _toAddress,
            uint _tokenId,
            address payable _refundAddress,
            address _zroPaymentAddress,
            bytes memory _adapterParams
        */

        vm.stopBroadcast();
    }
}

//  forge script script/DeployNFT.s.sol:SendTokensToAway --rpc-url sepolia --broadcast -vvvv
//  https://testnet.layerzeroscan.com/