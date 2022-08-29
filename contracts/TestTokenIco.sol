// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "./Crowdsale.sol";

contract TestTokenIco is Crowdsale {

    uint256 private preIcoSupply;
    
    constructor(uint256 rate, address payable wallet, IERC20 token, uint256 icoSupply)  Crowdsale(rate, wallet, token) {

        preIcoSupply = icoSupply;
    }

    function _preValidatePurchase(address beneficiary, uint256 weiAmount)
		internal
		view
		override(Crowdsale, TimedCrowdsale)
		onlyWhileOpen
	{
		super._preValidatePurchase(beneficiary, weiAmount);
	}

	/**
	 * @dev Overrides parent behavior by transferring tokens from wallet.
	 * @param beneficiary Token purchaser
	 * @param tokenAmount Amount of tokens purchased
	 */
	function _deliverTokens(address beneficiary, uint256 tokenAmount)
		internal
		override(Crowdsale, AllowanceCrowdsale)
	{
		super._deliverTokens(beneficiary, tokenAmount);
	}
}
}