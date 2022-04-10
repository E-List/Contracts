pragma solidity 0.6.12;

interface ERC20 {
    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address recipient, uint256 amount)
        external
        returns (bool);

    function allowance(address owner, address spender)
        external
        view
        returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
}

contract ELISTPurchase {
    ERC20 public token;

    uint256 public total_sold;

    uint256 public rate;

    bool public state;

    address payable public governance;

    event Purchase(address indexed user, uint256 amount);
    event StateChange(address indexed user, bool state);

    constructor(address payable _governance, ERC20 _token) public {
        governance = _governance;
        token = _token;
        total_sold = 0;
        rate = 17; 
        state = true;
    }

    receive() external payable {
        purchase();
    }

    function purchase() public payable {
        require(state == true, "Service is not Available");

        uint256 weiAmount = msg.value;

        require(token.balanceOf(address(this)) > 0, "There are no more ELIST");

        uint256 tokens = 0;

        tokens = weiAmount * rate;
        require(
            token.balanceOf(address(this)) - tokens >= 0,
            "There are no more ELIST"
        );

        governance.transfer(weiAmount);
        require(token.transfer(msg.sender, tokens), "ELIST Transfer not successful");

        emit Purchase(msg.sender, weiAmount);
    }

    function changeState() public {
        require(msg.sender == governance, "Not Allowed");
        state = !state;

        emit StateChange(msg.sender, state);
    }

    function withdrawUnsoldTokens(uint256 _tokens)
        public
        returns (bool success)
    {
        require(msg.sender == governance, "!governance");

        require(token.transfer(governance, _tokens), "Transfer not successful");

        return true;
    }
}
