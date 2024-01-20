//SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;
import "@openzeppelin/contracts/utils/Strings.sol";

contract marketplace{

    // using Strings for uint256;

    constructor() payable {
        
    }

    struct Products{
        uint256 ProductID;
        string name;
        uint256 price;
        address seller;
    }

    

    Products[] public product;

    uint256 private ProductCount = 0;

    address private seller = msg.sender; 

    modifier onlySeller(){
        require(seller == msg.sender,"You need to be the seller!");
        _;
    }


    event ProductAdded(string name,uint256 price,address seller );
    event ProductDeleted(uint256 ProductID,string name);

    function addProduct(string memory _name,uint256 _price,address _seller) public {
        ProductCount++;
        product.push(Products(ProductCount,_name,_price,_seller));
        emit ProductAdded(_name, _price, _seller);

    }

    function searchProduct(uint256 _ProductID) public view returns(Products memory){
        require(_ProductID<=product.length,"Product is not found sorry!");
        require(_ProductID != 0,"Not a valid ID");
        for (uint256 i =0;i<product.length;i++){
            if(_ProductID == product[i].ProductID){ 
            return product[i];
        }
        }

         revert("Product not found");


    }
    
    function buyProduct(string memory _productName,address payable buyer) external payable {

        for(uint256 i=0;i<product.length;i++){
            if(Strings.equal(_productName,product[i].name)){

                buyer.transfer(product[i].price);

            }

            else{
                revert("Sorry no product found!");
            }
           
        }

    }

    function deleteProduct (string memory Product_Name) public onlySeller{
        for(uint256 i=0;i<product.length;i++){
            if(Strings.equal(product[i].name , Product_Name)){
                    delete product[i];
                    emit ProductDeleted(product[i].ProductID,product[i].name);
            }
        }

    }

  

    
    
}