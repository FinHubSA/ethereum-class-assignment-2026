// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import { ERC20 } from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface IWETH9 is IERC20 {
    function deposit() external payable;
    function withdraw(uint256 amount) external;
}

/// @notice Minimal wrapped native token for deploying v4 PositionManager in tests.
contract MockWETH9 is ERC20, IWETH9 {
    constructor() ERC20("Mock WETH", "WETH") {}

    function deposit() external payable {
        _mint(msg.sender, msg.value);
    }

    function withdraw(uint256 amount) external {
        _burn(msg.sender, amount);
        (bool ok,) = msg.sender.call{ value: amount }("");
        require(ok, "MockWETH9: withdraw");
    }

    receive() external payable {
        _mint(msg.sender, msg.value);
    }
}
