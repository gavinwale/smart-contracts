//SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";
import "@openzeppelin/contracts/utils/Context.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";


interface IUniswapV2Factory {
    event PairCreated(address indexed token0, address indexed token1, address pair, uint);

    function feeTo() external view returns (address);
    function feeToSetter() external view returns (address);

    function getPair(address tokenA, address tokenB) external view returns (address pair);
    function allPairs(uint) external view returns (address pair);
    function allPairsLength() external view returns (uint);

    function createPair(address tokenA, address tokenB) external returns (address pair);

    function setFeeTo(address) external;
    function setFeeToSetter(address) external;
}

interface IUniswapV2Pair {
    event Approval(address indexed owner, address indexed spender, uint value);
    event Transfer(address indexed from, address indexed to, uint value);

    function name() external pure returns (string memory);
    function symbol() external pure returns (string memory);
    function decimals() external pure returns (uint8);
    function totalSupply() external view returns (uint);
    function balanceOf(address owner) external view returns (uint);
    function allowance(address owner, address spender) external view returns (uint);

    function approve(address spender, uint value) external returns (bool);
    function transfer(address to, uint value) external returns (bool);
    function transferFrom(address from, address to, uint value) external returns (bool);

    function DOMAIN_SEPARATOR() external view returns (bytes32);
    function PERMIT_TYPEHASH() external pure returns (bytes32);
    function nonces(address owner) external view returns (uint);

    function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;

    event Mint(address indexed sender, uint amount0, uint amount1);
    event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
    event Swap(
        address indexed sender,
        uint amount0In,
        uint amount1In,
        uint amount0Out,
        uint amount1Out,
        address indexed to
    );
    event Sync(uint112 reserve0, uint112 reserve1);

    function MINIMUM_LIQUIDITY() external pure returns (uint);
    function factory() external view returns (address);
    function token0() external view returns (address);
    function token1() external view returns (address);
    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
    function price0CumulativeLast() external view returns (uint);
    function price1CumulativeLast() external view returns (uint);
    function kLast() external view returns (uint);

    function mint(address to) external returns (uint liquidity);
    function burn(address to) external returns (uint amount0, uint amount1);
    function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
    function skim(address to) external;
    function sync() external;

    function initialize(address, address) external;
}

interface IUniswapV2Router01 {
    function factory() external pure returns (address);
    function WETH() external pure returns (address);

    function addLiquidity(
        address tokenA,
        address tokenB,
        uint amountADesired,
        uint amountBDesired,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB, uint liquidity);
    function addLiquidityETH(
        address token,
        uint amountTokenDesired,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
    function removeLiquidity(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB);
    function removeLiquidityETH(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountToken, uint amountETH);
    function removeLiquidityWithPermit(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountA, uint amountB);
    function removeLiquidityETHWithPermit(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountToken, uint amountETH);
    function swapExactTokensForTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    function swapTokensForExactTokens(
        uint amountOut,
        uint amountInMax,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
        external
        payable
        returns (uint[] memory amounts);
    function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
        external
        returns (uint[] memory amounts);
    function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
        external
        returns (uint[] memory amounts);
    function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
        external
        payable
        returns (uint[] memory amounts);

    function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
    function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
    function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
}

interface IUniswapV2Router02 is IUniswapV2Router01 {
    function removeLiquidityETHSupportingFeeOnTransferTokens(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountETH);
    function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountETH);

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
    function swapExactETHForTokensSupportingFeeOnTransferTokens(
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external payable;
    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
}

contract LuckyBunnyCoin is ERC20Burnable, Ownable {

    // How much $LBC an address holds
    mapping (address => uint256) private _lbcOwned;
    // How much $LBC an address may spend
    mapping (address => mapping (address => uint256)) private _allowances;
    // To tell if an address is excluded from fee or not
    mapping (address => bool) private _isExcludedFromFee;
    // To tell if an address is excluded from max tx or not
    mapping (address => bool) private _isExcludedFromMaxTx;
    // To tell if an address is excluded from max wallet or not
    mapping (address => bool) private _isExcludedFromMaxWallet;

    // Pretty eventful
    event excludedFromFee(address account);
    event excludedFromMaxTransaction(address account);
    event excludedFromMaxWallet(address account);
    event includedInFee(address account);
    event includedInMaxTransaction(address account);
    event includedInMaxWallet(address account);
    event marketingWalletUpdated(address marketingWallet);
    event devWalletUpdated(address devWallet);
    event minerWalletUpdated(address minerWallet);
    event maxWalletSizeUpdated(uint256 maxWalletSize);
    event maxTransactionSizeUpdated(uint256 maxTransactionSize);
    event goldenHourActivated(uint256 timeStarted);
    event goldenHourEnded(uint256 timeEnded);

    // Enum to make it easy to tell what kind of fees to apply
    enum FeeType {
        None,
        Buy,
        Sell
    }

    // Buying fees
    struct BuyFee {
        uint256 liquidity;
        uint256 marketing;
        uint256 dev;
        uint256 miner;
    }

    // Selling fees
    struct SellFee {
        uint256 liquidity;
        uint256 marketing;
        uint256 dev;
        uint256 miner;
    }


    BuyFee public buyFee;
    SellFee public sellFee;

    uint256 goldenHourStart;
    uint256 goldenHourEnd;

    uint constant FEE_DIVISOR = 100; // Smallest fee unit is 1%

    // Total supply is 100,000,000
    uint256 private constant _totalSupply = 100000000 * 10**18;
    // Max transaction is 10,000 (1% of 1,000,000 added to initial liquidity)
    uint256 public _maxTransaction = 10000 * 10**18;

    // Hot wallets for different fees
    address payable public marketingWallet; // used for marketing fees
    address payable public devWallet; // to feed my village
    address payable public minerWallet; // to buy back into miner TVL
    address public deadWallet; // nobody owns this one!

    // LBC Metadata
    string private constant _name = "LuckyBunnyCoin";
    string private constant _symbol = "$LBC";
    uint8 private constant _decimals = 18;

    IUniswapV2Router02 public immutable uniswapV2Router;
    address public immutable uniswapV2Pair;

    constructor(string memory name__,
                string memory symbol__,
                address marketing,
                address dev,
                address miner
            ) ERC20(name__, symbol__) {
        setSellFee(2, 2, 1, 5); // LP, marketing, dev, miner
        activateGoldenhour(); // No buy fees for the first hour

        require(marketing != address(0), "Marketing wallet cannot be 0x0");
        require(dev != address(0), "Dev wallet cannot be 0x0");
        require(miner != address(0), "Miner wallet cannot be 0x0");

        marketingWallet = payable(marketing);
        devWallet = payable(dev);
        minerWallet = payable(miner);


        // Deployer wallet owns the total supply of $LBC
        _lbcOwned[msg.sender] = _totalSupply;
        // Router here is BSC Testnet PCS
        IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0xD99D1c33F9fC3444f8101754aBC46c52416550D1); // I think this is testnet PCS lol
        // Creates a pair for the token
        uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
        // Sets the rest of the contract variables
        uniswapV2Router = _uniswapV2Router;

        // Minting the supply (100,000,000)
        _mint(msg.sender, _totalSupply);

        // Excluding owner, address, and hot wallets from fees, max tx, and max wallet
        _isExcludedFromFee[owner()] = true;
        _isExcludedFromFee[address(this)] = true;
        _isExcludedFromFee[marketingWallet];
        _isExcludedFromFee[devWallet];
        _isExcludedFromFee[minerWallet];
        _isExcludedFromMaxTx[owner()] = true;
        _isExcludedFromMaxTx[address(this)] = true;
        _isExcludedFromMaxTx[marketingWallet] = true;
        _isExcludedFromMaxTx[devWallet] = true;
        _isExcludedFromMaxTx[minerWallet] = true;
        _isExcludedFromMaxWallet[owner()] = true;
        _isExcludedFromMaxWallet[address(this)] = true;
        _isExcludedFromMaxWallet[marketingWallet] = true;
        _isExcludedFromMaxWallet[devWallet] = true;
        _isExcludedFromMaxWallet[minerWallet] = true;

        // Dead sending me all them tokens
        emit Transfer(address(0), _msgSender(), _totalSupply);
    }

    // function name() public view virtual override returns (string memory) {
    //     return _name;
    // }

    // function symbol() public view virtual override returns (string memory) {
    //     return _symbol;
    // }

    // function decimals() public view virtual override returns (uint8) {
    //     return _decimals;
    // }

    function totalSupply() public view virtual override returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) public view override returns (uint256) {
        return _lbcOwned[account];
    }

    function transfer(address recipient, uint256 amount) public override returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    function allowance(address owner, address spender) public view virtual override returns (uint256) {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount) public override returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(sender, _msgSender(), _allowances[sender][_msgSender()] - amount);
        return true;
    }

    function increaseAllowance(address spender, uint256 addedValue) public override returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue) public override returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender] - subtractedValue);
        return true;
    }

    function setSellFee(uint16 liquidity, uint16 marketing, uint16 dev, uint16 miner) public onlyOwner {
        require(liquidity + marketing + dev + miner < FEE_DIVISOR, "Invalid entry: Fees must be less than 100");
        sellFee.liquidity = liquidity;
        sellFee.marketing = marketing;
        sellFee.dev = dev;
        sellFee.miner = miner;
    }

    function setBuyFee(uint16 liquidity, uint16 marketing, uint16 dev, uint16 miner) public onlyOwner {
        require(liquidity + marketing + dev + miner < FEE_DIVISOR, "Invalid entry: Fees must be less than 100");
        buyFee.liquidity = liquidity;
        buyFee.marketing = marketing;
        buyFee.dev = dev;
        buyFee.miner = miner;
    }

    // Generates # of hours until next golden hour
    function rAnDoMgoldenHourGeneration() internal view returns(uint) {
        uint256 hoursToGoldenHour = uint256(keccak256(abi.encodePacked(block.timestamp, block.difficulty, msg.sender))) % 24;
        return goldenHourEnd + (hoursToGoldenHour * 3600);
    }

    // Activates golden hour
    function activateGoldenhour() internal {
        setBuyFee(0, 0, 0, 0); // Buy fees set to 0
        goldenHourStart = block.timestamp; // Start time is current time
        goldenHourEnd = block.timestamp + 3600; // End time is current time + 1 hour
        emit goldenHourActivated(block.timestamp);
    }

    // Turns off golden hour
    function noMoreGoldenHour() internal {
        setBuyFee(uint16(buyFee.liquidity), uint16(buyFee.marketing), uint16(buyFee.dev), uint16(buyFee.miner));
        // shit i forgot what i was doing hold on
        emit goldenHourEnded(block.timestamp);
    }

    // no errors LFG

    // im thinking have it check after every contract interaction if golden hour is over or not? not sure
    // going to do some reading brb
    // ^^ i think this is the only way




}