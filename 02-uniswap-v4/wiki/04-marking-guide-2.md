# Marking Guide 2

## Assignment 2 (Uniswap v4)

- Assignment 2 is marked out of **40.0**.
- Any valid technical approach can receive full marks when requirements are satisfied.

## Part 1 (5.5 marks)

Part 1 is **dependency installation only**, as in [Assignment — Part 1](03-assignment.md): add **`@uniswap/v4-core`** and **`@uniswap/v4-periphery`** with **Yarn** to the **appropriate workspace package** (typically the Hardhat/contracts package), following the [Uniswap v4 Core](https://github.com/Uniswap/v4-core) setup guidance.

### Dependency installation (4.0)

- **[2.0]** `@uniswap/v4-core` appears as a dependency in that package’s `package.json` and is recorded in the Yarn lockfile (install via `yarn add` as required).
- **[2.0]** `@uniswap/v4-periphery` is installed the same way in the **same** workspace package, with lockfile entries consistent with a normal Yarn install.

### Correct package target (0.5)

- **[0.5]** Dependencies are attached to the **intended** package.

### Verification (1.0)

- **[1.0]** After install, the workspace still resolves dependencies and the project **compiles** (or the course’s Part 1 checks pass), indicating the libraries are usable where Part 2 onward expects them.

## Part 2 + Part 3 (34.5 marks)

### Functional outcomes (25.0)

- **[25.0]** Required Part 2 and Part 3 functionality is implemented correctly and consistently.

### Correctness and integrity (2.0)

- **[2.0]** State changes and required outputs are coherent and reliable.

### Code clarity and documentation (6.5)

- **[6.5]** Code is organized and maintainable, with clear comments where needed.

### Verification (1.0)

- **[1.0]** Part 2 and Part 3 tests/checks pass.

## Overall correctness

- **[0.5]** Overall submission coherence and completeness.
- **Subtotal: 0.5 marks**

## Totals Check

- Part 1 total: `5.5`
- Part 2 total: `34.5`
- Overall correctness: `0.5`
- **Grand total: `5.5 + 34.5 + 0.5 = 40.0`**
