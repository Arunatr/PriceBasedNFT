pragma solidity ^0.6.0;
import "./provableAPI_0.6.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract priceBasedNft is ERC721, usingProvable {

    uint256 public WBTCBTC; // To store the WBTC Price in BTC
    address public owner;   // To store owner of the Contract

    constructor(string memory _name,string memory _symbol) public
    ERC721(_name,_symbol){
    owner = msg.sender;
    updatePrice();         // First check at contract creation.
    }
     
    //  
    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
    _;
    }

    modifier onlyProvable() {
    require(msg.sender == provable_cbAddress(), "The sender is not Provable's server.");
    _;
    }
     
    // To mint the NFT721 token if WBTCBTC price is above 100000
    // else it reverts

    function mintNft(address _to,uint256 _id,string memory _uri) external onlyOwner
    {
       //updatePrice();
       require(WBTCBTC >= 100000, "WBTC price is low - You are unable to mint");
       require(_to != address(0), "Not valid address");
       _safeMint(_to,_id);
       _setTokenURI(_id,_uri);

    }
     

   event LogPriceUpdated(string price);
   event LogNewProvableQuery(string description);
  
    // It recevies the result from provable server.
   function __callback(bytes32 myid, string memory result) virtual override public onlyProvable {
      WBTCBTC = parseInt(result,5);       // converting the string into unit with five decimal adjusment
      //updatePrice();
      emit LogPriceUpdated(result);
   }


   // ProvableQuery reterives the price infomation WBTCBTC from coinbase's endpoint API
   // It uses data source type as URL
   function updatePrice() payable public {
       if (provable_getPrice("URL") > address(this).balance) {
           emit LogNewProvableQuery("Provable query was NOT sent, please add some ETH to cover for the query fee");
       } else {
           emit LogNewProvableQuery("Provable query was sent, standing by for the answer..");
           provable_query("URL", "json(https://api.pro.coinbase.com/products/WBTC-BTC/ticker).price");
       }
   }
}