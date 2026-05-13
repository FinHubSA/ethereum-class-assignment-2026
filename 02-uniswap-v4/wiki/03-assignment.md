# Assignment

This assignment builds on [Automated Market Makers](./01-automated-market-makers.md) and [Uniswap v4](./02-uniswap-v4.md). Complete the wiki reading first, then work in the `02-uniswap-v4` monorepo so contracts compile and tests pass.

## Overview

This assignment highlights the AMM model as an alternative to the order-book model from the previous assignment. In an order book, price is discovered externally by matching buy and sell orders from traders. In an AMM, price is discovered internally from pool state (reserves/liquidity curve) and updates automatically as swaps and liquidity changes happen.

For reward tokens, this gives a different market design: instead of waiting for counterparties to place matching orders, holders trade directly against pooled liquidity. The goal is to understand how `FNBT` and `PNPT` can be priced and exchanged through the pool mechanism itself.

## Part 1: Install Uniswap v4 Core package

Follow the official guide: [Uniswap v4 Core](https://github.com/Uniswap/v4-core).

### Requirements

- [ ] **TODO:** Add the v4 core and v4 periphery dependency to the appropriate workspace package.
- [ ] **TODO:** Install the package using **Yarn**:

```bash
yarn add @uniswap/v4-core
yarn add @uniswap/v4-periphery
```

### Deliverables

- Updated `package.json` / lockfile showing `@uniswap/v4-core` installed via Yarn.

---

## Part 2: Pool creation with `PoolManager`

Implement a **smart contract** (in `02-uniswap-v4/packages/hardhat/contracts/`) that **creates a Uniswap v4 liquidity pool** using the protocol’s **`PoolManager`**.

**Pool parameters (required for this assignment)**

| Parameter        | Value                                                                                                                                                                                                                |
| ---------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Fee tier**     | **0.3%** — use the Uniswap fee encoding your stack expects (commonly **`3000`** in fee units where `3000` denotes a 0.30% swap fee).                                                                                 |
| **Tick spacing** | **`60`** — use tick spacing **60**, which pairs with the usual 0.3% configuration in Uniswap v3-style fee/spacing tables; match your v4 deployment’s allowed `fee` ↔ `tickSpacing` pairs if the chain enforces them. |

Use **`address(0)`** for **hooks**, so the pool key matches a no-hooks pool.

For how Uniswap documents **`PoolKey`** construction (sorted currencies, fee in pips, tick spacing, hooks) and **`IPoolManager.initialize(pool, startingPrice)`** with **`sqrtPriceX96`**, see the official guide: [Create Pool — Uniswap v4](https://developers.uniswap.org/docs/protocols/v4/guides/create-pool).

### Requirements

- [ ] **TODO:** Copy **`FNBToken.sol`** and **`PNPToken.sol`** from [`01-order-book`](../../01-order-book/) into `02-uniswap-v4/packages/hardhat/contracts/`, then use those contracts as the two pool assets for this assignment.
  - **Hint:** In your pool-creation contract, pass the required addresses into the **constructor** (at minimum: `PoolManager`, `PNPToken`, and `FNBToken`) and store them for later pool initialization/mint calls.
- [ ] **TODO:** Initialize or register the pool through the v4 **`PoolManager`** flow with **fee tier 0.3%** (e.g. `3000` where applicable), **tick spacing `60`**, canonical **currency ordering**, and **hooks** as above.
- [ ] **TODO:** Emit a dedicated **`event`** when a pool is successfully created or initialized (name it clearly, e.g. `PoolCreated` / `V4PoolInitialized`), including the fields needed to identify the pool (tokens, fee, tick spacing, hooks address, and any `PoolId` / key material your design uses).
  - **Hint:** Method modifiers (for example access-control modifiers like `onlyOwner`) can be used where appropriate; include comments explaining **why** a modifier was used on a method.
- [ ] **TODO:** Add comments for public/external methods and for non-obvious logic inside functions.

### Deliverables

- Solidity source for the pool-creation contract (and deployment or test setup that exercises it).
- Tests or scripts that assert the **pool-creation** event fires with the expected parameters.

---

## Part 3: Mint a liquidity position (same contract as Part 2)

Extend **the same contract** from Part 2 so it also **mints a concentrated liquidity position** in that pool (add liquidity within a chosen tick range).

### Economic assumptions (for tick math)

Use these **notional ZAR values** when choosing prices and ticks:

- **`FNBToken` (`FNBT`)** represents **eBucks**. The eBucks programme describes rewards as **pegged to the rand**, with a published transparent example that **eB10 is worth R1** (see [eBucks press release — How rich is your reward?](https://www.ebucks.com/web/eBucks/aboutus/pressreleases/2009/0409howrich.jsp)). For this assignment, treat **1 `FNBT` = R0.10** in notional terms (i.e. **10 `FNBT` ≡ R1**), aligned with that **eB10 = R1** line in the article.
- **`PNPToken` (`PNPT`)** represents **Pick n Pay Smart Shopper**–style points with **1 `PNPT` = R0.01** in notional terms.

From those assumptions, the **ZAR-equivalent spot notion** is **1 `FNBT` ≡ 10 `PNPT`** (R0.10 vs R0.01 per unit). Your pool may order tokens as `currency0` / `currency1`; convert that ratio into the correct **Uniswap sqrt price / tick** for your pair orientation.

### Requirements (`mintLiquidity` only)

Each **TODO** title matches a step comment in **`RewardTokensManager.mintLiquidity`** (`1)` … `9)`).

- [ ] **TODO:** Validate user inputs and tick constraints.
  - **Hint:** Check amounts and ticks
- [ ] **TODO:** Ensure the chosen range includes the target tick for the tokens liquidity pool.
  - **Hint:** Derive **`targetTick`** from the **1 FNBT ≡ 10 PNPT** notion (`price = (currency0 / currency1) = 1.0001^tick`)
- [ ] **TODO:** Resolve and verify the liquidity pool.
  - **Hint:** Get the **`poolId`** by first creating the pool key then using `key.toId()` method.
- [ ] **TODO:** Compute liquidity from desired token amounts at the current pool price.
  - **Hint:** Use `LiquidityAmounts.getLiquidityForAmounts` method. sqrtPriceX96 can be obtained from the poolManager using `poolManager.getSlot0(poolId)`
- [ ] **TODO:** Pull desired token amounts from owner into this manager.
  - **Hint:** Use **`IERC20.transferFrom(msg.sender, address(this), amount)`** for **`currency0` / `currency1`** when the corresponding desired amount is non-zero; the caller must **`approve`** your contract on both tokens first.
- [ ] **TODO:** Approve Permit2 so PositionManager can settle pool deltas.
  - **Hint:** Uniswap V4 uses Permit2 contract to settle the currency pairs. You can read more [here](https://github.com/dragonfly-xyz/useful-solidity-patterns/tree/main/patterns/permit2#permit2-model). This won't be examined, you just need to know how to use it for minting.
- [ ] **TODO:** Prepare PositionManager mint actions and execute modifyLiquidities.
  - **Hint:** Look at this [guide](https://developers.uniswap.org/docs/protocols/v4/guides/create-pool#guide-create-a-pool-and-add-liquidity)
- [ ] **TODO:** Verify mint succeeded.
- [ ] **TODO:** Return any unspent token dust and emit assignment event.
  - **Hint:** After mint, **`transfer`** any remaining **`currency0` / `currency1`** balances on your contract to **`msg.sender`**; then **`emit LiquidityMinted(poolId, positionId, msg.sender, tickLower, tickUpper, liquidity)`**.

### Deliverables

- Updated Solidity from Part 2 with minting logic and tests proving pool creation + position mint.
- Tests that assert the **liquidity minting** event fires with the expected parameters.

---

## Running the tests

From the `02-uniswap-v4` folder:

```bash
yarn hardhat:test test/AssignmentSolution.ts
```

Or from `02-uniswap-v4/packages/hardhat`:

```bash
yarn test test/AssignmentSolution.ts
```

## Submission checklist

- Pool uses **0.3%** fee tier and tick spacing **`60`** (and ticks aligned to that spacing).
- Part 2 and Part 3 contracts emit **events for pool creation** and **liquidity minting**, and tests (or documented traces) cover them.
- All contracts compile.
- All tests pass.
- Methods include comments explaining purpose and behavior.
- Complex or non-obvious function logic includes brief explanatory comments.
- Any calculated figures include comments showing the calculation used.
- **Hooks and flash accounting** remain out of scope (see [Uniswap v4 wiki](./02-uniswap-v4.md)).
- Assignment requirements for Parts 1–3 are fully covered.
