// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/math/SafeMath.sol";


contract StakeContract{

    struct staker{
        uint256 stakeAt;
        uint256 totalStaked;
        uint256 totalClaimed;
        uint256 lastClaimed;
    }
    using SafeMath for uint256;
    mapping(address => staker) public _staked;
    uint256 public totalAmount = 0;
    uint256 public poolAmount;
    uint256 public totalActiveStakers;
    uint256 public apyPercentage;
    address private owner;

    IERC20 public TokenAddress;

    constructor(address _tokenAddress, uint256 _apyPercentage){
        owner = msg.sender;
        TokenAddress = IERC20(_tokenAddress);
        apyPercentage = _apyPercentage; //100 => 1% , 10 => 0.1%, 1 => 0.01%;
    }
    modifier onlyOwner(){
        require(msg.sender == owner, "Not an Owner");
        _;
    }

    function stake(uint256 _amount) external{
        require(_amount >= 500, "Amount Must Be Greater Then 500");
        require(TokenAddress.balanceOf(msg.sender) >= _amount, "Not Enough Balance");
        require(_staked[msg.sender].totalStaked == 0, "Already a Staker");
        selectPackage(_amount);
        TokenAddress.transferFrom(msg.sender, address(this), _amount);
        _staked[msg.sender].totalStaked += _amount;
        _staked[msg.sender].stakeAt = block.timestamp;
        totalAmount += _amount;
        totalActiveStakers++;
    }

    function unStake() external{
        require(_staked[msg.sender].totalStaked > 0, "You're Not a Staker");
        TokenAddress.transfer(msg.sender, _staked[msg.sender].totalStaked);
        claim();
        totalAmount -= _staked[msg.sender].totalStaked;
        _staked[msg.sender].totalStaked = 0;
        totalActiveStakers--;
    }

    function emergencyUnstake() external {
        require(_staked[msg.sender].totalStaked > 0, "You're Not a Staker");
        TokenAddress.transfer(msg.sender, _staked[msg.sender].totalStaked);
        totalAmount -= _staked[msg.sender].totalStaked;
        _staked[msg.sender].totalStaked = 0;
        totalActiveStakers--;
    }

    function selectPackage(uint256 _amount) internal{
        if(_amount <= 1000){
            updateAPY(250); // Pkg 1 => 2.5% // update APY Sy Pury Contract Ki APY Change Hogi JbkY hMYN Sirf Ek Bndy Ki Krni
        }else if(_amount > 1000 && _amount <= 2000){
            updateAPY(500); // Pkg 2 => 5%
        }else if(_amount > 2000){
            updateAPY(1000); // Pkg 3 => 10%
        }else{
            updateAPY(100); // 1%
        }
    }

    function updateAPY(uint256 _newAPY) internal onlyOwner{
        apyPercentage = _newAPY;
    }

    function withdrawRewardPool(uint256 amount) external onlyOwner{
        require(rewardPool() > amount, "Insufficient Rewards To Withdraw");
        TokenAddress.transfer(msg.sender, amount);
    }

    function rewardPool() public view returns(uint256){
        return TokenAddress.balanceOf(address(this)) - totalAmount;
    }

    function claimable(address _stakee) view public returns(uint256, uint256){
        require(_staked[_stakee].totalStaked != 0, "Not a Staker");
        uint256 claimableDays;
        if(_staked[_stakee].lastClaimed == 0){
            claimableDays = (block.timestamp - _staked[_stakee].stakeAt).div(1 days);
        }else{
            claimableDays = (block.timestamp - _staked[_stakee].lastClaimed).div(1 days);
        }

        uint256 perDayReward = apyPercentage.mul(_staked[_stakee].totalStaked).div(apyPercentage.mul(100)).div(365);
        return (claimableDays , perDayReward.mul(claimableDays));
    }

    function claim() public {
        require(_staked[msg.sender].totalStaked != 0, "Not a Staker");
        (uint256 claimableDays, uint256 claimableAmount) = claimable(msg.sender);
        require(claimableAmount != 0, "Zero Claimable");
        require(rewardPool() > claimableAmount, "Currently Reward Pool Is Empty Try Again Later"); //Or We Can Also Use Error Ids And Show Relative Msg On The FrontEnd Later Based On Id.

        TokenAddress.transfer(msg.sender, claimableAmount);

        if(_staked[msg.sender].lastClaimed == 0){
            _staked[msg.sender].lastClaimed = _staked[msg.sender].stakeAt + claimableDays.mul(1 days);
        }else{
            _staked[msg.sender].lastClaimed = claimableDays.mul(1 days);
        }
        _staked[msg.sender].totalClaimed += claimableAmount;
    }

    function test(address _user, uint256 _rewardDays) public {
        _staked[_user].lastClaimed = block.timestamp - _rewardDays.mul(1 days);
    }
}