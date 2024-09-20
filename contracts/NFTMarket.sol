// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;
    import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
    import "@openzeppelin/contracts/access/Ownable.sol";

    contract NFT is ERC721{

                struct NFTs{
                    address owner;
                    uint256 id;
                    string NFTuri;
                    uint price;
                    bool forSale;
                }

            mapping(uint => NFTs)public nftsInfo;//to track all nfts.
            uint public tokenId;

        constructor () ERC721("SampleNFT","SNFT") {}

            //Now the function to mint
        function mintNFT(string calldata _NFTuri,address _owner,uint _tokenId,uint _price) public {
            require(msg.sender != address(0),"Address Zero Detected!");
            require(msg.sender == _owner,"Nawa for you ooo!");
            require(_tokenId != tokenId,"It already exists jare!" );
            //Now the updating starts
            nftsInfo[tokenId].owner = _owner;
            // nftsInfo[tokenId].uri = _NFTuri;
            nftsInfo[tokenId].id = _tokenId;
            nftsInfo[tokenId].price = _price;
            nftsInfo[tokenId].forSale = false;

            tokenId++;
            
            _mint(msg.sender,_tokenId);
        }

        function listNFT(uint tokenId,uint _price) external {
            require(nftsInfo[tokenId].owner == msg.sender,"You are not the owner");
           
            nftsInfo[tokenId].forSale = true;
            nftsInfo[tokenId].price = _price;
        }
        //Users can buy and transfer NFTs
        function buyNFT(uint _tokenId,uint _price) external payable{
            address seller = nftsInfo[_tokenId].owner;
            require(seller != address(0), "Wetin Address zero dey do for here?");
            require(msg.value >= _price,"Nawa for you ooo!");
            require(nftsInfo[tokenId].forSale == true,"Y U wan dey whyne?");

            _transfer(seller,msg.sender,_tokenId);

            nftsInfo[tokenId].owner = msg.sender;
            nftsInfo[tokenId].forSale = false;

              payable(seller).transfer(msg.value);
        }
    }