// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

//listing items
//buying items
//escrow mechanism (optional)
// commision fees

contract MarketPlaceContract {
    uint public itemCount;
    address public owner;
    uint public commissionPercent = 2; // 2% marketplace fee

    struct Item {
        uint id;
        address payable seller;
        string name;
        uint price;
        string description;
        bool isSold;
    }

    mapping(uint => Item) public items;

    event ItemListed(uint id, address seller, uint price, string name);
    event ItemBought(uint id, address buyer, uint price);
    event ItemCancelled(uint id);

    constructor() {
        owner = msg.sender;
        itemCount = 0;
    }

    function listItem(string memory _name, uint _price, string memory _description) public {
        require(_price > 0, "Price must be greater than zero");

        itemCount++;
        items[itemCount] = Item(
            itemCount,
            payable(msg.sender),
            _name,
            _price,
            _description,
            false
        );

        emit ItemListed(itemCount, msg.sender, _price, _name);
    }

    function buyItem(uint id) public payable {
        require(id > 0 && id <= itemCount, "Invalid item ID");
        Item storage item = items[id];
        require(!item.isSold, "Item already sold");
        require(msg.value == item.price, "Incorrect price");

        // Calculate commission
        uint commission = (msg.value * commissionPercent) / 100;
        uint sellerAmount = msg.value - commission;

        // Mark item as sold before transferring funds (reentrancy protection)
        item.isSold = true;

        // Transfer funds
        item.seller.transfer(sellerAmount);
        payable(owner).transfer(commission);

        emit ItemBought(id, msg.sender, msg.value);
    }

    function cancelItem(uint id) public {
        require(id > 0 && id <= itemCount, "Invalid item ID");
        Item storage item = items[id];
        require(!item.isSold, "Item already sold");
        require(msg.sender == item.seller, "Only seller can cancel");

        delete items[id];

        emit ItemCancelled(id);
    }
}
