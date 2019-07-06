pragma solidity ^0.4.25;

contract lizardSpock{

    //mapping player1 and player 2 choices to integer that points at winner
    mapping (string => mapping(string=>int)) evaluate;

    int winner = 0;

    //player variables
    address player1 = 0;
    address player2 = 0;

    //State variables for player choices
    string internal player1Choice;
    string internal player2Choice;
    string playerOne = "You are player 1";
    string playerTwo = "You are player 2";

    //Constructor
    constructor() public {
        evaluate["rock"]["rock"] = 0;
        evaluate["rock"]["paper"] = 2;
        evaluate["rock"]["scissors"] = 1;
        evaluate["rock"]["lizard"] = 1;
        evaluate["rock"]["spock"] = 2;
        evaluate["paper"]["paper"] = 0;
        evaluate["paper"]["rock"] = 1;
        evaluate["paper"]["scissors"] = 2;
        evaluate["paper"]["lizard"] = 2;
        evaluate["paper"]["spock"] = 1;
        evaluate["scissors"]["rock"] = 2;
        evaluate["scissors"]["paper"] = 1;
        evaluate["scissors"]["scissors"] = 0;
        evaluate["scissors"]["lizard"] = 1;
        evaluate["scissors"]["spock"] = 2;
        evaluate["lizard"]["rock"] = 2;
        evaluate["lizard"]["paper"] = 1;
        evaluate["lizard"]["scissors"] = 2;
        evaluate["lizard"]["lizard"] = 0;
        evaluate["lizard"]["spock"] = 1;
        evaluate["spock"]["rock"] = 1;
        evaluate["spock"]["paper"] = 2;
        evaluate["spock"]["scissors"] = 1;
        evaluate["spock"]["lizard"] = 2;
        evaluate["spock"]["spock"] = 0;
      }

    //registration is made payable
    function register() public
    registrationStatus()
    checkPayment(2 ether)
    payable {
        if (player1 == 0)
            player1 = msg.sender;
        else if (player2 == 0)
            player2 = msg.sender;
    }

    modifier registrationStatus() {
        //prevent 3rd player from registering
        if (player1 !=0 && player2 !=0){
            revert("Player 1 and player 2 are already registered and playing...");
        }
        //prevent a player from registering twice
        else {
            if (msg.sender == player1 || msg.sender == player2)
                revert("You are already registered for the game");
            else
            _;
        }
    }

    //a function that prevent external parties from resetting contract values
    modifier verifyRegistration() {
        if(msg.sender == player1 || msg.sender == player2)
            _;
        else
            revert("Unable to modify the contract state. You are not registered");
    }

    //setting the transaction amount payable to be that specified - 2 ether
    modifier checkPayment(uint amount) {
        if (msg.value != amount)
            revert("Amount payable is exactly 2 ether");
        else
            _;
    }

    function commitHand(string choice) public verifyRegistration() {

        if (msg.sender == player1)
            player1Choice = choice;
        else if (msg.sender == player2)
            player2Choice = choice;

        //check that both players have made a choice before evaluation
        if (bytes(player1Choice).length !=0 && bytes(player2Choice).length !=0) {
            evaluateWinner();
        }
    }

    function evaluateWinner() public {
        winner = evaluate[player1Choice][player2Choice];
        if (winner == 1) {
            player1.transfer(address(this).balance);
        }
        else if (winner == 2) {
            player2.transfer(address(this).balance);
        }
        else {
            player1.transfer((address(this).balance)/2);
            player2.transfer(address(this).balance);
        }
    }

    //getter functions
    function Player1OrPlayer2() public verifyRegistration() view returns(string) {
        if(msg.sender == player1)
            return playerOne;
        else if(msg.sender == player2)
            return playerTwo;
    }

    //amount of ether stored in the contract
    function getBalance() public constant returns(uint amount) {
        return address(this).balance;
    }

    function whoWon() public constant returns(int w) {
        return winner;
    }

    //clear values for next round
    //function that will clear all variables after some given time - this fn will be in the constructor
    function resetValues() public verifyRegistration() {
        player1Choice = "";
        player2Choice = "";
        player1 = 0;
        player2 = 0;
        winner = 0;
    }
}
