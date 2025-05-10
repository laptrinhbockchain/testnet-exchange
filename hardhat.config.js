require("dotenv").config();

module.exports = {
    defaultNetwork: "sepolia",
    
    networks: {
        sepolia: {
            url: "https://eth-sepolia.public.blastapi.io",
            accounts: [ process.env.DEPLOYER_PK ]
        },
        monad_testnet: {
            url: "https://testnet-rpc.monad.xyz",
            accounts: [ process.env.DEPLOYER_PK ]
        },
        base: {
            url: "https://mainnet.base.org",
            accounts: [ process.env.DEPLOYER_PK ]
        }
    },
    solidity: {
        version: "0.8.6",
        settings: {
            optimizer: {
                enabled: false,
                runs: 200
            },
            evmVersion: "istanbul"
        }
    },
    mocha: {
        timeout: 40000
    }
};
