// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

/// @notice Test double for Permit2 used by v4 PositionManager.
/// @dev PositionManager calls `transferFrom(payer, poolManager, amount, token)` on this contract; `IERC20.transferFrom`
///      then runs with `msg.sender` = address(this), so the payer must have `IERC20.approve(permit2, amount)` on the token.
contract MockPermit2 {
    function transferFrom(address from, address to, uint160 amount, address token) external {
        IERC20 t = IERC20(token);
        require(t.allowance(from, address(this)) >= uint256(amount), "MockPermit2: allowance");
        require(t.transferFrom(from, to, uint256(amount)), "MockPermit2: transfer");
    }
}
