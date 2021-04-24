//
//  PurchaseItem.swift
//  Stockly
//
//  Created by Matt Owen on 4/24/21.
//

import Foundation
import Firebase

class PurchaseItem {
    
    var id: String
    var name: String
    var desc: String
    var price: Int
    var tags: String
    var dateAdded: Timestamp
    var picId: String
    var numPur: Int
    var sellerName: String
    var salePrice: Int
    
    init(id: String
    ,name: String
    ,desc: String
    ,price: Int
    ,tags: String
    ,dateAdded: Timestamp
    ,picId: String
    ,numPur: Int
    ,sellerName: String
    ,salePrice: Int) {
        
        self.id = id
        self.name = name
        self.desc = desc
        self.price = price
        self.tags = tags
        self.dateAdded = dateAdded
        self.picId = picId
        self.numPur = numPur
        self.sellerName = sellerName
        self.salePrice = salePrice
        
    }
    
}
