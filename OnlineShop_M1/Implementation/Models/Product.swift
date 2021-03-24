//
//  Item.swift
//  OnlineShop_M1
//
//  Created by edgar kosyan on 02.03.21.
//

import Foundation
class Product: IProduct  {
    
    var id: String!
    var categoryId: String!
    var name: String!
    var description: String!
    var shortDescription: String!
    var price: Double!
    var imageLinks: [String]!
    
    init(){
    }
    
    init(dictionary: NSDictionary){
        id = dictionary["objectId"] as? String
        categoryId = dictionary["categoryId"] as? String
        name = dictionary["name"] as? String
        description = dictionary["description"] as? String
        shortDescription = dictionary["shortDescription"] as? String
        price = dictionary["price"] as? Double
        imageLinks = dictionary["imageLinks"] as? [String]
    }
}



