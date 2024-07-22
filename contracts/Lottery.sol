// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

library CustomMath {
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        require(a + b >= a, "Addition overflow");
        return a + b;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(a >= b, "Subtraction underflow");
        return a - b;
    }

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }
        require((a * b) / a == b, "Multiplication overflow");
        return a * b;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b > 0, "Division by zero");
        return a / b;
    }
}

contract Lottery {
    using CustomMath for uint256;

    address public manager;
    address payable public feeRecipient;

    struct Player {
        address player;
        uint256 round;
    }

    struct History {
        address winner;
        uint256 round;
        uint256 prizePool;
    }

    enum LotteryStatus {
        NotRunning,
        Running
    }

    LotteryStatus public status;
    Player[] public players;
    uint256 public currentRound;
    uint256 public prizePool;
    History[] public history;

    uint256 public constant TICKET_PRICE = 0.005 ether;
    uint256 public constant FEE_PERCENTAGE = 5;

    event RoundStarted(uint256 round);
    event RoundEnded(uint256 round);
    event PlayerEntered(address indexed player, uint256 round);
    event WinnerPicked(
        address indexed winner,
        uint256 round,
        uint256 prizePool
    );

    constructor() {
        manager = msg.sender;
        feeRecipient = payable(manager);
        status = LotteryStatus.NotRunning;
        currentRound = 1;
    }

    function startRound() public restricted {
        require(
            status == LotteryStatus.NotRunning,
            "Lottery is already running"
        );
        status = LotteryStatus.Running;
        emit RoundStarted(currentRound);
    }

    function endRound() public restricted {
        require(status == LotteryStatus.Running, "Lottery is not running");
        status = LotteryStatus.NotRunning;
        emit RoundEnded(currentRound);
    }

    function enter() public payable {
        require(status == LotteryStatus.Running, "Lottery is not running");
        require(msg.value == TICKET_PRICE, "Ticket fee should be 0.005 ether");

        uint256 fee = msg.value.mul(FEE_PERCENTAGE).div(100);
        uint256 amountAfterFee = msg.value.sub(fee);

        feeRecipient.transfer(fee);

        players.push(Player({player: msg.sender, round: currentRound}));

        prizePool = prizePool.add(amountAfterFee);
        emit PlayerEntered(msg.sender, currentRound);
    }

    function random() private view returns (uint) {
        return
            uint(
                keccak256(
                    abi.encodePacked(block.timestamp, msg.sender, block.number)
                )
            );
    }

    function pickWinner() public restricted {
        require(status == LotteryStatus.Running, "Lottery is not running");
        require(players.length > 0, "No players to choose from");

        uint index = random() % players.length;
        address winner = players[index].player;

        payable(winner).transfer(prizePool);

        history.push(
            History({winner: winner, round: currentRound, prizePool: prizePool})
        );

        emit WinnerPicked(winner, currentRound, prizePool);

        delete players;
        prizePool = 0;
        currentRound = currentRound.add(1);
        status = LotteryStatus.NotRunning;
    }

    modifier restricted() {
        require(msg.sender == manager, "Only the manager can call this");
        _;
    }

    function getPlayers() public view returns (Player[] memory) {
        return players;
    }

    function getPrizePool() public view returns (uint256) {
        return prizePool;
    }

    function getCurrentRound() public view returns (uint256) {
        return currentRound;
    }

    function getHistory() public view returns (History[] memory) {
        return history;
    }

    function setFeeRecipient(address payable _feeRecipient) public restricted {
        feeRecipient = _feeRecipient;
    }

    function isManager(address _address) public view returns (bool) {
        return _address == manager;
    }
}
