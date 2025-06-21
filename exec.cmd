rem #### Basic
forge completions powershell

forge build
forge clean

forge inspect ERC20Impl bytecode
forge coverage --no-match-coverage script
forge config --basic
forge remappings > remappings.txt
forge tree
forge geiger --check --full

rem #### Chain Clone
forge clone --no-git --chain bsc 0x7862D9B4bE2156B15d54F41ee4EDE2d5b0b455e4 UniswapV3Pool --etherscan-api-key 0000


rem #### Lib Management
forge update
forge remove

rem ####========== Install OpenZeppelin V5
rem https://docs.openzeppelin.com/upgrades-plugins/foundry-upgrades

forge install foundry-rs/forge-std
forge install OpenZeppelin/openzeppelin-foundry-upgrades
forge install OpenZeppelin/openzeppelin-contracts-upgradeable

rem ####========== Install OpenZeppelin V4
rem https://docs.openzeppelin.com/upgrades-plugins/foundry-upgrades
forge install foundry-rs/forge-std
forge install OpenZeppelin/openzeppelin-foundry-upgrades
forge install OpenZeppelin/openzeppelin-contracts@v4.9.6
forge install OpenZeppelin/openzeppelin-contracts-upgradeable@v4.9.6

rem ####========== Exec Test
forge test -vvv --gas-report --match-contract ERC20ImplTest
forge test --list --json --match-contract ERC20ImplTest

rem ####========== Exec Script
set LOCALHOST_RPC_URL=http://127.0.0.1:8545
forge script script/ERC20ImplDeploy.s.sol --broadcast --account index0 --rpc-url %LOCALHOST_RPC_URL%

rem ####========== Exec Deploy
forge create src/ERC20Impl.sol:ERC20Impl --account index0 --rpc-url %LOCALHOST_RPC_URL%
forge create src/ERC20Impl.sol:ERC20Impl --account index0 --broadcast --rpc-url %LOCALHOST_RPC_URL%
rem --constructor-args "My Token" "MT"

rem ####========== Wallet Utils
cast wallet import index0 --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80
cast wallet address --account index0

rem ####========== Cache
forge cache ls
forge cache clean

rem ####========== Cast
cast completions powershell

cast chain-id --rpc-url %LOCALHOST_RPC_URL%
cast chain --rpc-url %LOCALHOST_RPC_URL%

cast client --rpc-url %LOCALHOST_RPC_URL%

cast estimate 0x5FbDB2315678afecb367f032d93F642f64180aa3 --account index0 "transfer(address,uint256)" 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266 2000

cast balance 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266 --rpc-url %LOCALHOST_RPC_URL%
cast nonce 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266 --rpc-url %LOCALHOST_RPC_URL%

cast code 0x5FbDB2315678afecb367f032d93F642f64180aa3 --rpc-url %LOCALHOST_RPC_URL%
cast codesize  0x5FbDB2315678afecb367f032d93F642f64180aa3 --rpc-url %LOCALHOST_RPC_URL%


rem ####========== Anvil
anvil --odyssey --optimism
-b 6
--hardfork cancun
--fork-url url