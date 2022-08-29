// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "./TestToken.sol";

error TokenICO__InvestmentFailed();

contract TokenICO is Token {
    address public owner;
    address payable public depositAddress;
    uint256 tokenPrice = 0.0001 ether;
    uint256 hardCap = 50 ether;
    uint256 public raisedAmount;

    // ICO Start/End
    uint256 public saleStart = block.timestamp;
    uint256 public saleEnd = block.timestamp + 604800; // Sale ends one week after starting.

    //ICO Trading
    uint256 public tradingStart = saleEnd + 86400; // One day after sale ends.

    // Event to track investors
    event Invest(address investor, uint value, uint tokens);

    enum State {
        beforeSale,
        duringSale,
        afterSale,
        halted
    } // Creates sale states.
    State public icoState;

    constructor(address payable _depositAddress) {
        _depositAddress = depositAddress;
        owner = msg.sender;
        icoState = State.beforeSale;
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    function changeDepositAddress(address payable newDepositAddress)
        public
        onlyOwner
    {
        depositAddress = newDepositAddress;
    }

    function getCurrentState() public view returns (State) {
        if (icoState == State.halted) {
            return State.halted;
        } else if (block.timestamp < saleStart) {
            return State.beforeSale;
        } else if (block.timestamp >= saleStart && block.timestamp <= saleEnd) {
            return State.duringSale;
        } else {
            return State.afterSale;
        }
    }

    function invest(uint256 amount) public payable returns (bool) {
        amount = msg.value;
        icoState = getCurrentState();
        require(icoState == State.duringSale);

        uint tokens = amount / tokenPrice;

        // adding tokens to the inverstor's balance from the founder's balance
        balances[msg.sender] += tokens;
        balances[founder] -= tokens;
        (bool success, ) = depositAddress.call{value: msg.value}("");
        if (!success) {
            revert TokenICO__InvestmentFailed();
        }

        emit Invest(msg.sender, amount, tokens);

        return true;
    }

    function transfer(address to, uint tokens)
        public
        override
        returns (bool success)
    {
        require(block.timestamp > tradingStart); // the token will be transferable only after tokenTradeStart

        // calling the transfer function of the base contract
        super.transfer(to, tokens); // same as Cryptos.transfer(to, tokens);
        return true;
    }

    function transferFrom(
        address from,
        address to,
        uint tokens
    ) public override returns (bool success) {
        require(block.timestamp > tradingStart); // the token will be transferable only after tokenTradeStart

        Token.transferFrom(from, to, tokens); // same as super.transferFrom(to, tokens);
        return true;
    }
}
