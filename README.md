# MintCats

MintCats is a Solidity-based NFT project that allows users to mint cat-themed NFTs. The project includes a dynamic NFT contract (`MoodNft`) that changes its metadata based on user interactions and a standard ERC721 contract (`BasicNft`).

## Features

- **Basic NFT Minting**: Users can mint NFTs with unique image URIs.
- **Mood-based NFTs**: The `MoodNft` contract allows flipping the NFT mood between happy and sad.
- **Fully On-Chain Metadata**: `MoodNft` stores metadata directly on-chain using Base64 encoding.
- **Deploy and Interact Scripts**: Foundry-based deployment and interaction scripts for automation.

## Contracts

### 1. BasicNft

- Implements a simple ERC721 NFT.
- Allows minting NFTs with IPFS-stored metadata.

### 2. MoodNft

- Implements an ERC721 NFT that can flip moods.
- Metadata is stored entirely on-chain.

## Installation & Setup

### Prerequisites

Ensure you have the following installed:

- [Foundry](https://book.getfoundry.sh/)
- [Node.js](https://nodejs.org/)

### Clone the Repository

```sh
git clone https://github.com/Arbiter09/MintCats.git
cd MintCats
```

### Install Dependencies

```sh
forge install
```

## Deployment

### Deploy Basic NFT

```sh
forge script script/DeployBasicNft.s.sol:DeployBasicNft --rpc-url <YOUR_RPC_URL> --broadcast
```

### Deploy Mood NFT

```sh
forge script script/DeployMoodNft.s.sol:DeployMoodNft --rpc-url <YOUR_RPC_URL> --broadcast
```

## Interaction

### Mint a Basic NFT

```sh
forge script script/Interactions.s.sol:MintBasicNft --rpc-url <YOUR_RPC_URL> --broadcast
```

### Flip Mood of Mood NFT

Call `flipMood(tokenId)` on the deployed MoodNft contract using a Web3 interface like Foundry or Ethers.js.

## License

This project is licensed under the MIT License.
