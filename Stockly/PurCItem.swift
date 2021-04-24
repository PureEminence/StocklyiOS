//
//  PurCItem.swift
//  Stockly
//
//  Created by Matt Owen on 4/24/21.
//

import Foundation
import Firebase

class PurCItem {
    
    var id: String
    var name: String
    var quantity: Int
    var salePrice: Int
    var date: Timestamp
    var sellerName: String
    
    init(id: String,
         name: String,
         quantity: Int,
         salePrice: Int,
         date: Timestamp,
         sellerName: String) {
        
        self.id = id
        self.name = name
        self.quantity = quantity
        self.salePrice = salePrice
        self.date = date
        self.sellerName = sellerName
        
    }
    
}
