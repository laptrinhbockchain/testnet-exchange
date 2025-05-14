# Testnet Exchange
[Testnet Exchange](https://exchange.laptrinhblockchain.net): Buy tokens for testnet simply and easily
- Buy MON for Monad Testnet: https://exchange.laptrinhblockchain.net/monad.html
- Buy ETH for Sepolia: https://exchange.laptrinhblockchain.net/sepolia.html
Please see detail from link: https://laptrinhblockchain.net/testnet-exchange-mua-token-mon-eth-tham-gia-testnet-tren-monad-va-sepolia-don-gian-de-dang-voi-ti-gia-tot-nhat/

## Build contracts
At the first time, install libraries:
```
npm install
```
And then, run below command to compile:
```
npx hardhat compile
```

## How to deploy contracts
Create .env file and update 
```
DEPLOYER_PK = <PrivateKey with prefix 0x>
```
And then run one of below commands to deploy contract:
```
npx hardhat run scripts/deploy_buyer_agent.js --network base
npx hardhat run scripts/deploy_seller_agent.js --network sepolia
npx hardhat run scripts/deploy_seller_agent.js --network monad_testnet
```

## Testnet Exchange for Sepolia
Buy ETH for Sepolia simply and easily: https://exchange.laptrinhblockchain.net/sepolia.html
The contract information:
1. BuyerAgent on Base: [0x0c37Df6F4552A4D8b7A916931ba11B596F7e7d4F](https://basescan.org/address/0x0c37Df6F4552A4D8b7A916931ba11B596F7e7d4F#code)
2. SellerAgent on Sepolia: [0x062363a03F95b8d44E39813d5603b363A33Cd9C5](https://sepolia.etherscan.io/address/0x062363a03f95b8d44e39813d5603b363a33cd9c5#code)

## Testnet Exchange for Monad
Buy MON for Monad Testnet simply and easily: https://exchange.laptrinhblockchain.net/monad.html
The contract information:
1. Contract on Base: [0xfb9c8ecb62766a489daaf677dac4ff7301134063](https://basescan.org/address/0xfb9c8ecb62766a489daaf677dac4ff7301134063#code)
2. Contract on Monad Testnet: [0xfB9C8eCB62766A489daAF677DAc4Ff7301134063](https://testnet.monadexplorer.com/address/0xfB9C8eCB62766A489daAF677DAc4Ff7301134063?tab=Contract)

