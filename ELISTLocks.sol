// SPDX-License-Identifier: MIT
pragma solidity >=0.8.9;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

library SafeMath {
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    function sub(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    function div(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        // Solidity only automatically asserts when dividing by 0
        require(b > 0, errorMessage);
        uint256 c = a / b;

        return c;
    }
}

contract ELISTLocks {
    uint256 public ecosystemLockTime = 1652565600; //Sun May 15 2022 00:00:00 GMT+0200 (Central Europe)
    uint256 public ecosystemLockedAmount = SafeMath.mul(250000000, 10**(18));
    
    uint256 public teamLockTime = 1678834800; //Wed Mar 15 2023 00:00:00 GMT+0100 (Central Europe)
    uint256 public teamLockedAmount = SafeMath.mul(80000000, 10**(18));

    uint256 public advisorsLockTime = 1655244000; //Wed Jun 15 2022 00:00:00 GMT+0200 (Central Europe)
    uint256 public advisorsLockedAmount = SafeMath.mul(60000000, 10**(18));
    
    uint256 public reserveLockTime = 1678834800; //Wed Mar 15 2023 00:00:00 GMT+0100 (Central Europe)
    uint256 public reserveLockedAmount = SafeMath.mul(60000000, 10**(18));
    
    uint256 public liquidityMiningLockTime1 = 1649973600; //Fri Apr 15 2022 00:00:00 GMT+0200 (Central Europe)
    uint256 public liquidityMiningLockedAmount1 = SafeMath.mul(25000000, 10**(18));
    
    uint256 public liquidityMiningLockTime2 = 1655244000; //Wed Jun 15 2022 00:00:00 GMT+0200 (Central Europe)
    uint256 public liquidityMiningLockedAmount2 = SafeMath.mul(30000000, 10**(18));
    
    uint256 public liquidityMiningLockTime3 = 1663192800; //Thu Sep 15 2022 00:00:00 GMT+0200 (Central Europe)
    uint256 public liquidityMiningLockedAmount3 = SafeMath.mul(45000000, 10**(18));

    IERC20 public token;

    address payable public governance;

    constructor(
        address payable _governance, 
        IERC20 _token
        ){
        governance = _governance;
        token = _token;        
    }

     receive() external payable {
        governance.transfer(msg.value);
    }

    function withdrawEcosystemTokens () public {
        require(msg.sender == governance, "Not allowed");
        require(block.timestamp >= ecosystemLockTime, "ELIST tokens still Locked");
        require(ecosystemLockedAmount > 0, "No more ELIST tokens to withdraw");

        require(token.transfer(governance, ecosystemLockedAmount), "Transfer not successful");
        ecosystemLockedAmount = 0;
    }
    
    function withdrawTeamTokens () public {
        require(msg.sender == governance, "Not allowed");
        require(block.timestamp >= teamLockTime, "ELIST tokens still Locked");
        require(teamLockedAmount > 0, "No more ELIST tokens to withdraw");

        token.transfer(governance, teamLockedAmount);
        teamLockedAmount = 0;
    }
    
    function withdrawAdvisorsTokens () public {
        require(msg.sender == governance, "Not allowed");
        require(block.timestamp >= advisorsLockTime, "ELIST tokens still Locked");
        require(advisorsLockedAmount > 0, "No more ELIST tokens to withdraw");

        token.transfer(governance, advisorsLockedAmount);
        advisorsLockedAmount = 0;
    }
  
    function withdrawReserveTokens () public {
        require(msg.sender == governance, "Not allowed");
        require(block.timestamp >= reserveLockTime, "ELIST tokens still Locked");
        require(reserveLockedAmount > 0, "No more ELIST tokens to withdraw");

        token.transfer(governance, reserveLockedAmount);
        reserveLockedAmount = 0;
    }
    
    function withdrawLiquidityMining1Tokens () public {
        require(msg.sender == governance, "Not allowed");
        require(block.timestamp >= liquidityMiningLockTime1, "ELIST tokens still Locked");
        require(liquidityMiningLockedAmount1 > 0, "No more ELIST tokens to withdraw");

        token.transfer(governance, liquidityMiningLockedAmount1);
        liquidityMiningLockedAmount1 = 0;
    }
    
    function withdrawLiquidityMining2Tokens () public {
        require(msg.sender == governance, "Not allowed");
        require(block.timestamp >= liquidityMiningLockTime2, "ELIST tokens still Locked");
        require(liquidityMiningLockedAmount2 > 0, "No more ELIST tokens to withdraw");

        token.transfer(governance, liquidityMiningLockedAmount2);
        liquidityMiningLockedAmount2 = 0;
    }
    
    function withdrawLiquidityMining3Tokens () public {
        require(msg.sender == governance, "Not allowed");
        require(block.timestamp >= liquidityMiningLockTime3, "ELIST tokens still Locked");
        require(liquidityMiningLockedAmount3 > 0, "No more ELIST tokens to withdraw");

        token.transfer(governance, liquidityMiningLockedAmount3);
        liquidityMiningLockedAmount3 = 0;
    }

    function emergencyTokenWithdraw(uint256 _weiAmount) public {
        require(msg.sender == governance, "Not Allowed");
        token.transfer(governance, _weiAmount);
    }
    
}
