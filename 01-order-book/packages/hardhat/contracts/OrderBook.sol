import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract OrderBook {
    constructor(address _tokenA, address _tokenB) {}
    function placeBuyOrder(uint256 amount, uint256 price) external returns (uint256 orderId) {}
    function placeSellOrder(uint256 amount, uint256 price) external returns (uint256 orderId) {}
    function matchOrders(uint256 buyOrderId, uint256 sellOrderId) external {}
    function cancelOrder(uint256 orderId) external {}
    function remaining(uint256 orderId) external view returns (uint256) {}
}
