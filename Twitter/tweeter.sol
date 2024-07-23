// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract TrweeterContract {

    struct Tweet {
        uint id;
        address author;
        string content;
        uint createdAt;
    }

    struct TweetMessage {
        uint id;
        string content;
        address from;
        address to;
        uint createdAt;
    }

    mapping( uint => Tweet) public tweets;
    mapping( address => uint[]) public tweetsOf; 
    mapping( address => TweetMessage[]) public conversations;
    mapping( address => mapping(address => bool) ) public operators;
    mapping( address => address[]) public following;

    uint nextId;
    uint nextMessageId;

    function _tweet(address _from, string memory _content) internal {
        require(_from == msg.sender || operators[_from][msg.sender], "You do not have access.");
        tweets[nextId] = Tweet( nextId, _from, _content, block.timestamp);
        tweetsOf[_from].push(nextId);
        nextId = nextId+1;
    }
    function tweet(string memory _content) public { // only owner can call this function 
        _tweet(msg.sender, _content);
    }

    function tweet(address _from, string memory _content) public {// owner -> address access
        _tweet(_from, _content);
    }

    function _sendMesage(address _from, address _to, string memory _content) internal {
        require(_from == msg.sender || operators[_from][msg.sender], " You do not have access.");
        conversations[_from].push(TweetMessage(nextMessageId,_content, _from, _to, block.timestamp));
        nextMessageId++;
    }
    function sendMessage(address _to, string memory _content) public {
        _sendMesage(msg.sender, _to, _content);
    }

    function sendMessage(address _from, address _to, string memory _content) public {
        _sendMesage(_from, _to, _content);
    }

    function follow(address _followed) public {
        following[msg.sender].push(_followed);
    }

    function allow(address _operator) public {
        operators[msg.sender][_operator] = true;
    }

    function disallow(address _operator) public {
        operators[msg.sender][_operator] = false;
    }
    function getLatestTweets(uint count) public view returns(Tweet[] memory) {
        require(count > 0 && count <= nextId, "Count is not proper");
        Tweet[] memory _tweets = new Tweet[](count);
        uint j;

        for (uint i = nextId - count; i < nextId; i++) {
            Tweet storage _structure = tweets[i];
            _tweets[j] = Tweet(
                _structure.id,
                _structure.author,
                _structure.content,
                _structure.createdAt
            );
            j = j + 1;
        }

        return _tweets;
    }

}