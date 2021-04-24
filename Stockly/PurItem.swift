//
//  PurItem.swift
//  Stockly
//
//  Created by Matt Owen on 4/23/21.
//

import Foundation
import Firebase

class PurItem {
    
    var id: String
    var total: String
    var date: Timestamp
    var quantity: Int
    
    init(id: String,
         total: String,
         date: Timestamp,
         quantity: Int) {
        
        self.id = id
        self.total = total
        self.date = date
        self.quantity = quantity
    }
}
