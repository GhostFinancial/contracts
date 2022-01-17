// SPDX-License-Identifier: MIT

pragma solidity 0.6.12;

import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract TaxOracle is Ownable {
    using SafeMath for uint256;

    IERC20 public ghost;
    IERC20 public mim;
    address public pair;

    constructor(
        address _ghost,
        address _mim,
        address _pair
    ) public {
        require(_ghost != address(0), "ghost address cannot be 0");
        require(_mim != address(0), "mim address cannot be 0");
        require(_pair != address(0), "pair address cannot be 0");
        ghost = IERC20(_ghost);
        mim = IERC20(_mim);
        pair = _pair;
    }

    function consult(address _token, uint256 _amountIn) external view returns (uint144 amountOut) {
        require(_token == address(ghost), "token needs to be ghost");
        uint256 ghostBalance = ghost.balanceOf(pair);
        uint256 mimBalance = mim.balanceOf(pair);
        return uint144(ghostBalance.mul(_amountIn).div(mimBalance));
    }

    function getGhostBalance() external view returns (uint256) {
	return ghost.balanceOf(pair);
    }

    function getMimBalance() external view returns (uint256) {
	return mim.balanceOf(pair);
    }

    function getPrice() external view returns (uint256) {
        uint256 ghostBalance = ghost.balanceOf(pair);
        uint256 mimBalance = mim.balanceOf(pair);
        return ghostBalance.mul(1e18).div(mimBalance);
    }


    function setGhost(address _ghost) external onlyOwner {
        require(_ghost != address(0), "ghost address cannot be 0");
        ghost = IERC20(_ghost);
    }

    function setMim(address _mim) external onlyOwner {
        require(_mim != address(0), "mim address cannot be 0");
        mim = IERC20(_mim);
    }

    function setPair(address _pair) external onlyOwner {
        require(_pair != address(0), "pair address cannot be 0");
        pair = _pair;
    }



}