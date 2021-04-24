//
//  SalesItem.swift
//  Stockly
//
//  Created by Matt Owen on 4/24/21.
//


import Foundation
import Firebase

class SalesItem {
    
    var id: String
    var buyerName: String
    var itemNumTotal: Int
    var total: String
    var date: Timestamp
    
    init(id: String
    ,buyerName: String
    ,itemNumTotal: Int
    ,total: String
    ,date: Timestamp) {
        
        self.id = id
        self.buyerName = buyerName
        self.itemNumTotal = itemNumTotal
        self.total = total
        self.date = date
    }
}

