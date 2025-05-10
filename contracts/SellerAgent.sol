// SPDX-License-Identifier: NONE
pragma solidity >=0.8.0;

// IERC20 interface
interface IERC20 {
    function transfer(address to, uint256 value) external returns (bool);
}

contract BotContract {
    uint public constant MAX_LIMIT = type(uint).max;
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

// SellerAgent: Process to send ETH on Testnet
contract SellerAgent is BotContract {
    struct OrderInfo {
        uint256 tokenAmount;
        address recipient;
    }

    event OrderFilled(uint256 orderId, address recipient, uint256 amount);
    event Contributed(address contributor, uint256 amount);

    mapping(uint256 => OrderInfo) public orders;
    mapping(address => uint256) public contributors;

    receive() external payable {
        contribute();
    }

    function withdrawETH(address _addr, uint _amount) public onlyOwner {
        payable(_addr).transfer(_amount);
    }

    function withdrawToken(address _tokenAddr, address _addr, uint _amount) public onlyOwner {
        IERC20(_tokenAddr).transfer(_addr, _amount);
    }

    function contribute() public payable {
        contributors[msg.sender] += msg.value;
        emit Contributed(msg.sender, msg.value);
    }

    function fillOrder(uint256 orderId, uint256 amount, address payable recipient) external onlyBot {
        // Check balance
        uint256 balance = address(this).balance;
        require(balance >= amount, "Not enough ETH!");

        // Check recipient
        require(recipient != address(0), "Invalid recipient!");

        // Check order
        require(orders[orderId].recipient==address(0), "Order has filled!");

        // Update order
        OrderInfo storage order = orders[orderId];
        order.tokenAmount = amount;
        order.recipient = recipient;

        // Transfer ETH on Testnet
        recipient.transfer(amount);

        emit OrderFilled(orderId, recipient, amount);
    }
}