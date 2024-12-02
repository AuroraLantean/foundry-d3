-include .env

.PHONY: all test clean deploy-anvil
#all targets in your Makefile which do not produce an output file with the same name as the target name should be PHONY.

all: clean remove install update build

# Clean the repo
clean  :; forge clean

# Remove modules
remove :; rm -rf .gitmodules && rm -rf .git/modules/* && rm -rf lib && touch .gitmodules && forge install foundry-rs/forge-std
#&& git add . && git commit -m "modules"

#install :;	forge install OpenZeppelin/openzeppelin-contracts

# Update Dependencies, DO NOT USE as this will use Openzeppelin's master branch, which is for development!!!
#update:; forge update

build:; forge build

test :; forge test -vvv
test_xyz :; forge test -vvv --match-path test/Xyz.t.sol
live :; forge test --rpc-url http://127.0.0.1:8545/ --match-path test/XyzLive.t.sol -vvv

ethereum_sepolia :; forge script script/Xyz.s.sol:XyzScript --rpc-url ${ETHEREUM_SEPOLIA_RPC} --broadcast --verify -vvvv --account wallet1
#--sender WALLET1_ADDRESS

flatten_token :; forge flatten src/ERC20Token.sol -o flat.sol

erc20_abi :; forge inspect src/ERC20Token.sol:ERC20Token abi > abi/erc20_abi.json

xyz_abi :; forge inspect src/Xyz.sol:Xyz abi > abi/xyz_abi.json

env :; source .env
show_vault :; echo $VAULT

snapshot :; forge snapshot

slither :; slither ./src 

anvil :; anvil -m 'test test test test test test test test test test test junk'

anvilf :; anvil --fork-url YOUR_ETHEREUM_ENDPOINT_URL --fork-block-number 20627519