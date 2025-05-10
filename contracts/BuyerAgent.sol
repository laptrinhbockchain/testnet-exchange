// SPDX-License-Identifier: NONE
pragma solidity >=0.8.0;

// IERC20 interface
interface IERC20 {
    function transfer(address to, uint256 value) external returns (bool);
}

// Bot contract
contract BotContract {
	address public owner;
    mapping(address => bool) public bots;

    modifier onlyOwner() {
	    require(msg.sender == owner, "IO");             // Invalid owner
	    _;
	}

    modifier onlyBot() {
	    require(bots[msg.sender] == true, "IB");       // Invalid bot
	    _;
	}

    constructor() {
        owner = msg.sender;
        bots[owner] = true;
    }

	function changeOwner(address _owner) public onlyOwner {
        owner = _owner;
    }

    function setBot(address _bot, bool enabled) public onlyOwner {
        bots[_bot] = enabled;
    }
}

// BuyerAgent: Process to receive ETH on Mainnet
contract BuyerAgent is BotContract {
    uint256 public constant RATE_DENOMINATOR = 1000;
    uint256 public constant BLOCK_HEIGHT = 43200;
    uint256 public constant ETH_MIN = 100_000000_000000;
    uint256 public constant ETH_MAX = 10000_000000_000000;

    enum OrderStatus{Pending, Filled, Cancelled}

    struct OrderInfo {
        address sender;
        uint256 block;
        uint256 buyRate;
        uint256 ethAmount;
        uint256 tokenAmount;
        address recipient;
        OrderStatus status;
        
    }
    event OrderBought(address buyer, uint256 orderId);
    event OrderCanceled(address buyer, uint256 orderId);
    event OrderFilled(address buyer, uint256 orderId);
    event OrderDeleted(address buyer, uint256 orderId);
    event RateChanged(uint256 oldRate, uint256 newRate);
    
    
    uint256 public maxOrderId = 0;
    uint256 public buyRate;                                 // Number of token for each ETH
    uint256 public pendingEth;
    mapping(uint256 => OrderInfo) public orders;

    // Receive ETH
    receive() external payable {
        buy(msg.sender);
    }

    function withdrawETH(address _addr) public onlyOwner {
        uint256 balance = address(this).balance;
        require(balance>pendingEth, "Not enough ETH for withdraw!");
        payable(_addr).transfer(balance - pendingEth);
    }

    function withdrawToken(address _tokenAddr, address _addr, uint _amount) public onlyOwner {
        IERC20(_tokenAddr).transfer(_addr, _amount);
    }

    function setBuyRate(uint256 _buyRate) external onlyBot {
        uint256 oldRate = buyRate;
        buyRate = _buyRate;
        emit RateChanged(oldRate, buyRate);
    }

    function buy(address recipient) public payable returns(uint256 orderId) {
        // Check value
        require(msg.value>=ETH_MIN, "ETH is too small!");
        require(msg.value<=ETH_MAX, "ETH is too big!");

        // Generate order
        OrderInfo memory order;
        order.sender = msg.sender;
        order.block = block.number;
        order.buyRate = buyRate;
        order.ethAmount = msg.value;
        order.tokenAmount = buyRate*msg.value/RATE_DENOMINATOR;
        order.recipient = recipient;
        order.status = OrderStatus.Pending;

        // Process to buy
        orderId = maxOrderId;
        maxOrderId++;
        pendingEth += msg.value;
        orders[orderId] = order;
        emit OrderBought(msg.sender, orderId);
    }

    function cancel(uint256 orderId) external {
        // Check order id
        require(orderId<maxOrderId, "OrderId is too large!");

        // Check order
        OrderInfo storage order = orders[orderId];
        require(order.sender!=address(0), "Invalid order!");
        require(order.sender==msg.sender, "Not own order!");
        require(order.status==OrderStatus.Pending, "Not pending order!");
        require(order.ethAmount<=pendingEth, "Not enough ETH!");

        // Check block
        uint256 blockDiff = block.number - order.block;
        require(blockDiff>=BLOCK_HEIGHT, "Wait more time for cancel order!");

        // Process to cancel
        order.status = OrderStatus.Cancelled;
        pendingEth -= order.ethAmount;
        payable(msg.sender).transfer(order.ethAmount);
        emit OrderCanceled(msg.sender, orderId);
    }

    function fill(uint256 orderId) external onlyBot {
        // Check order id
        require(orderId<maxOrderId, "OrderId is too large!");

        // Check order
        OrderInfo storage order = orders[orderId];
        require(order.sender!=address(0), "Invalid order!");
        require(order.status==OrderStatus.Pending, "Not pending order!");

        // Process to fill
        order.status = OrderStatus.Filled;
        pendingEth -= order.ethAmount;
        emit OrderFilled(msg.sender, orderId);
    }

    function clear(uint256[] calldata orderIds) external onlyBot {
        for (uint idx=0; idx<orderIds.length; idx++) {
            uint256 orderId = orderIds[idx];
            OrderInfo storage order = orders[orderId];
            if (order.sender!=address(0) && order.status!=OrderStatus.Pending) {
                delete orders[orderId];
                emit OrderDeleted(order.sender, orderId);
            }
        }
    }
}