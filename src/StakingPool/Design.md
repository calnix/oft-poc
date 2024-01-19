PoolManager -----> PoolA
            -----> PoolB
            -----> PoolC -----> VaultA
                         -----> VaultB

# PoolManager

- addPool()
- updatePool()
- massUpdatePools()

Pools can be added (or deployed from) PoolManager.
Reward distribution to Pools handled via allocation points or by a figure specified upon adding the pool.

Example of allocation points:

- PoolA added, allocPoints: 100
- PoolB added, allocPoints: 200

Rewards split by proportion of pool's allocPoints. PoolA would get 1/3 of the rewards per block.
- PoolManager emits 9 rewardsTokens per block
- PoolA would get 3 rewardsTokens per block: 100/300 * 9 = 3 rewards

This way new pools can be added ad-hoc, and the rewards would be proportionally diluted across more active pools accordingly.

However, we may want more granular control over staking and pools
- pools have different start and end times (deployed in advance but not reflexively)
- pools have different emissions independent of each other
- we don't want to have to recalc. allocPoints each time a new pool is added and do balancing.

## how does boosting work in the context of rewards?

- Each pool as a predetermined amount of rewards allocated to it.
- Each pool supports multiple user created vaults
- Some vaults have NFTs locked and therefore enjoy boosted APY

- basically, the rewards stream of the pool is redistributed amongst the vaults proportionally 
- in the event, there is no boost, everyone gets more. If 1 vault has boost, it gets more than the rest.

Better to redistribute than preallocate rewards buffer just to cater to boosted scenarios -> capital inefficiency. 

## problem #1 - Async pools

- what if pools start and end at diff times
- becomes troublesome balancing active pools against incoming pools with diff. expected sizing

### Solution

- instead of allocPoints strictly define rewards allocation per pool when adding
- addPool() must check if the rewards for itself have been added/topped-up, so rewards meant for other pools in not encroached upon
- need to intro some state vars to track global rewards stored, global rewards allocated; delta will be checked on adding a new pool.

## problem #2 - reusing pools

- What happens when pools finish? reuse or discard?
- cannot resuse easily -> everyone must have claimed their rewards and exited the pool
- otherwise cannot reset the mapping(address => UserInfo)

no reuse!

### Solution

PoolManager needs to lose the deadweight of inactive pools.

- on final claim of rewards from PoolManager, pool must be set to inactive by PoolManager and its allocation updated as exhausted.
- state variables pertaining to allocation updated on PoolManager

This brings us to tracking active, inactive pools at any given time and perhaps in totality since inception.
Minimally,
- need to know how many presently active, and corresponding data 
- incoming pools (deployed but emitted at a future start date)

Use iterable mapping: PID => poolStruct{...}
- view fns with loops

## Pausing pools

Is this needed?

If needed:
- inherit pausable
- fn to pause + update endingBlock/time, to extend on resumption.
- or recalc. rewards emissions due to lost time, honouring end time. 

Also: pause + terminate?
- a forever pause is the same as terminate
- however, you need to claw back allocated rewards on termination for realloc.
- need terminate fn()

## How many pools might we manage concurrently at any point in time?

- need bitmaps, etc?
- if very long list looping through it might be a problem

## Staked assets

Can keep staked coins and NFTs on the respective pool contracts.
Sure, there is asset fragmentation. But it should not matter unless you want external project to integrate and use the staked MOCA to generate yield?

- no need to co-mingle and move them into the same contract.
- what if you wanna know total staked tokens + no. of NFTs locked
-- view fn on PoolManager, that loops through active pools and returns counts of both

## Lockup period

Do we want to have a flexible or fixed staking schedule?
- flexible: can stake/unstake anytime
- fixed: to stake, 7 days cooldown/lockup then can unstake.

## Design consideration: 4626 pools

- Unipool is not 4626; just plain jane staking. Emits rewards linearly
- 4626 accounting based on shares and interest yield approach. Auto-compounding.

4626 would be useful if we want yield generators to integrate on-top of staking pools to run some strategy.
This means you cannot have asset fragmentation across pools - aggregate tokens into a single join contract.

Would suggest going with 4626. the mechanism is elegant and from a product/marketing perspective autocompounding could have value.

### note:

- Rewards must be issued periodically to the pool - this will alter the IR rate btw shares and assets.
- pool check's balance via this.balanceOf on rewards
- unless you create an update reward state fn tt poolManager calls on the pool

X-ref with inflationary attacks. 


## NFT staking

- NFT staking operates on nft ids
- Have a NFT join contract to hold all the staked NFTs? Possibly
- Shares will not be issued to NFTS. Just apply a boost factor

Lock nft to apply boost onto vault? If boost; staking goes from flexible to fixed?

> Each ERC4626 contract only supports one asset. You cannot deposit multiple kinds of ERC20 tokens into the contract and get shares back.

# Vaults and Vault Manager

Pool contracts have vault management related functions. Vault creators have to create a vault based off a specific pool.

- createVault(): initiator
- disbandVault(): initiator
- joinVault()
- leaveVault()
- boost/lockNFT

Vaults are indexed by vaultIds.
There are private and public vaults.
- private: creator wants to solo-stake
- public: others can join.

## Vault creation

- are realm points burnt in the creation of staking party? or returned when the vault is disbanded?

## Vaults lifecycle

- what happens when a vault ends or gets disbanded?

Vaults can be created by certain individuals with necessary realm points.
Have to be created off the back of a specific pool contract.

- party staking: who inits staking, calc boost

## Vault size and other limits

For public vaults, do we want to limit by headcount or stake amount?
Any other limits?

Do private vaults have staking limits?

## Fees

Vault creator can charge 20% or up to 20% mgmt fee?

## Boosting

Everyone enjoys boost if NFT is locked.
But is there an extra kickback to the user that locked the NFT to begin with?

## Calculating shares to a vault

- based on realm points or staking amount?
- there is some interplay with reputation

# Others

AccessControl on priviledged functions:
- RBAC: some addresses can add, some addresses can transfer tokens
- ownable2step: just 1 main address from which everything is key-ed to.