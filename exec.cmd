rem #### Basic
forge completions powershell

forge build
forge clean

rem #### Profiling
set FOUNDRY_PROFILE=default
set FOUNDRY_PROFILE=optimize
set FOUNDRY_PROFILE=monad

rem #### Docs
forge doc --serve --port 4000
forge doc --build --out ./documentation

rem #### Testing
forge inspect ERC20Impl bytecode
forge coverage --no-match-coverage script

rem #### Check / Setup
forge config --basic
forge remappings > remappings.txt
forge tree
forge geiger --check --full

rem #### Chain Clone
forge clone --no-git --chain base 0x9b9efa5Efa731EA9Bbb0369E91fA17Abf249CFD4 DexRouter
forge clone  --no-git --chain monad-testnet 0xCF3b79e1e4BA557621Ffd0aBd5f84469Ff144508  CampusCoin

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
forge test -vvv --gas-report --match-contract ERC20ImplTest --match-test test_selector
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
cast wallet remove --name monad-wallet
cast wallet list
cast wallet address --account index0
cast wallet sign --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80 "hello"
cast wallet verify --address 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266 "hello" 0xf16ea9a3478698f695fd1401bfe27e9e4a7e8e3da94aa72b021125e31fa899cc573c48ea3fe1d4ab61a9db10c19032026e3ed2dbccba5a178235ac27f94504311c

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

cast abi-encode "transfer(address,uint256)" 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266 2000
cast decode-abi --input "transfer(address,uint256)" 0x000000000000000000000000f39fd6e51aad88f6f4ce6ab8827279cfffb9226600000000000000000000000000000000000000000000000000000000000007d0

cast calldata "transfer(address,uint256)" 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266 2000
cast decode-calldata "transfer(address,uint256)" 0xa9059cbb000000000000000000000000f39fd6e51aad88f6f4ce6ab8827279cfffb9226600000000000000000000000000000000000000000000000000000000000007d0
cast pretty-calldata 0xa9059cbb000000000000000000000000f39fd6e51aad88f6f4ce6ab8827279cfffb9226600000000000000000000000000000000000000000000000000000000000007d0

for /f "delims=" %i in ('cast code 0x166dFF769A460f7730762F32A4DA3FEeB3Bc35B8') do echo %i

rem ####========== Verify Guide
forge verify-contract 0x166dFF769A460f7730762F32A4DA3FEeB3Bc35B8 ERC20Impl --verifier sourcify --verifier-url https://sourcify-api-monad.blockvision.org --rpc-url %MONAD_RPC_URL%
forge verify-contract 0x195B9401D1BF64D4D4FFbEecD 10aE8c41bEBA453 src/Counter.sol:Counter --verifier sourcify --verifier-url https://sourcify-api-monad.blockvision.org

rem ####========== Anvil
anvil --odyssey --optimism
-b 6
--hardfork cancun
--fork-url url

rem ####========== blockdev-6 | Deploy and Verify

rem Set Profile First in .env to monad (see toml file).

forge create src/blockdev-6/CampusCoin.sol:CampusCoin --account monad-blockdevid --broadcast
forge create src/blockdev-6/MockUSDC.sol:MockUSDC --account monad-blockdevid --broadcast
forge create src/blockdev-6/SimpleDEX.sol:SimpleDEX --account monad-blockdevid --broadcast --constructor-args 0x19DeEb2c7Ff873Fbd9aD0E381A8c7EACFFBcd5b1 0x6A723613B07Ccb9BB0Dc7f1f708493B2e7155A40

rem set sourcify
set SOURCIFY_URL=http://sourcify-api-monad.blockvision.org
echo %SOURCIFY_URL%

rem rem ========= Run Verify
forge verify-contract 0x19DeEb2c7Ff873Fbd9aD0E381A8c7EACFFBcd5b1 CampusCoin --verifier sourcify --verifier-url %SOURCIFY_URL%
forge verify-contract 0x6A723613B07Ccb9BB0Dc7f1f708493B2e7155A40 MockUSDC --verifier sourcify --verifier-url %SOURCIFY_URL%
cast abi-encode "constructor(address _tokenA, address _tokenB)" 0x19DeEb2c7Ff873Fbd9aD0E381A8c7EACFFBcd5b1 0x6A723613B07Ccb9BB0Dc7f1f708493B2e7155A40
forge verify-contract 0xE7BE5FbF73696327d4c7C7Dd41B975060310027F SimpleDEX  --verifier sourcify --verifier-url%SOURCIFY_URL% --constructor-args 0x00000000000000000000000019deeb2c7ff873fbd9ad0e381a8c7eacffbcd5b10000000000000000000000006a723613b07ccb9bb0dc7f1f708493b2e7155a40

rem ========= Run Script
forge script script/SetupDEX.s.sol
forge script script/WeCan.s.sol -vvv --account index0 --rpc-url http://127.0.0.1:8545 --broadcast

cast call 0x5FbDB2315678afecb367f032d93F642f64180aa3 "getDonationsAddressLength()"

cast send 0x5FbDB2315678afecb367f032d93F642f64180aa3 --account index0 "transfer(address,uint256)" "0xa16E02E87b7454126E5E10d957A927A7F5B5d2be" "10"
cast block-number
cast block-number --rpc-url %TENDERLY_RPC_URL%
cast block-number --rpc-url %MONAD_RPC_URL%

rem ======== ZK Section
forge script script/ZK.s.sol -vvv --account monad-blockdevid --rpc-url %MONAD_RPC_URL% --broadcast
cast balance 0xDB01dbB625e36405dBf2890204CCc3411b5B3281 --rpc-url %MONAD_RPC_URL%
cast balance 0xDB01dbB625e36405dBf2890204CCc3411b5B3281 --rpc-url %TENDERLY_RPC_URL%

rem AgeVerifier 0xc6fde9210e669e0695dc2078b516e88f296cd209
rem Groth16Verifier 0x9104f05008be2a6334e79defd3254f4e2ddd8017

forge verify-contract 0x9104f05008be2a6334e79defd3254f4e2ddd8017 Groth16Verifier  --verifier sourcify --verifier-url %SOURCIFY_URL%
cast abi-encode "constructor(address)" 0x9104f05008be2a6334e79defd3254f4e2ddd8017
forge verify-contract 0xc6fde9210e669e0695dc2078b516e88f296cd209 AgeVerifier --verifier sourcify --verifier-url %SOURCIFY_URL% --constructor-args 0x0000000000000000000000009104f05008be2a6334e79defd3254f4e2ddd8017

rem ======== Let's Commit
cast block-number --rpc-url http://blockdev.aone.my.id:8545
set LOCALHOST_RPC_URL=http://localhost:8545
forge create src/blockdev-last/LetsCommit.sol:LetsCommit --account index0 --rpc-url %LOCALHOST_RPC_URL% --broadcast
cast send 0x5FbDB2315678afecb367f032d93F642f64180aa3 --account index0 "createEvent()" --rpc-url %LOCALHOST_RPC_URL%
cast send 0x5FbDB2315678afecb367f032d93F642f64180aa3 --account index0 "claim()" --rpc-url %LOCALHOST_RPC_URL%
cast send 0x5FbDB2315678afecb367f032d93F642f64180aa3 --account index0 "enrollAndAttend()" --rpc-url %LOCALHOST_RPC_URL%
forge script script/IEventSetupTest.s.sol --account index0 --broadcast --rpc-url %LOCALHOST_RPC_URL%
