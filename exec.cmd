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

rem ---Remappings
forge remappings > remappings.txt