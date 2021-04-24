//
//  SaleItem.swift
//  Stockly
//
//  Created by Matt Owen on 4/24/21.
//

import Foundation
import Firebase

class SaleItem {
    
    var id: String
    var name: String
    var quantity: Int
    var price: Int
    var total: Int
    
    init(id: String
         ,name: String
         ,quantity: Int
         ,price: Int
         ,total: Int) {
        
        self.id = id
        self.name = name
        self.quantity = quantity
        self.price = price
        self.total = total
    }
}
