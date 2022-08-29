// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Token is IERC20 {
    string public name = "Token";
    string public symbol = "TKN";
    uint public override totalSupply;

    address public founder;
    mapping(address => uint) public balances;
    // balances[0x1111...] = 100;

    mapping(address => mapping(address => uint)) allowed;

    // allowed[0x111][0x222] = 100;

    constructor() {
        totalSupply = 681000000000000000000000000000;
        founder = msg.sender;
        balances[founder] = totalSupply;
    }

    function balanceOf(address tokenOwner)
        public
        view
        override
        returns (uint balance)
    {
        return balances[tokenOwner];
    }

    function transfer(address to, uint tokens)
        public
        virtual
        override
        returns (bool success)
    {
        require(balances[msg.sender] >= tokens);

        balances[to] += tokens;
        balances[msg.sender] -= tokens;
        emit Transfer(msg.sender, to, tokens);

        return true;
    }

    function allowance(address tokenOwner, address spender)
        public
        view
        override
        returns (uint)
    {
        return allowed[tokenOwner][spender];
    }

    function approve(address spender, uint tokens)
        public
        override
        returns (bool success)
    {
        require(balances[msg.sender] >= tokens);
        require(tokens > 0);

        allowed[msg.sender][spender] = tokens;

        emit Approval(msg.sender, spender, tokens);
        return true;
    }

    function transferFrom(
        address from,
        address to,
        uint tokens
    ) public virtual override returns (bool success) {
        require(allowed[from][to] >= tokens);
        require(balances[from] >= tokens);

        balances[from] -= tokens;
        balances[to] += tokens;
        allowed[from][to] -= tokens;

        return true;
    }
}
