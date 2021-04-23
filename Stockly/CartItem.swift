//
//  CartItem.swift
//  Stockly
//
//  Created by Matt Owen on 4/23/21.
//

import SwiftUI
import Foundation
import UIKit
import Firebase

class CartItem {
    
    
        var name: String
        var costPer: Int
        var currentStock: Int
        var desc: String
        var price: Int
        var tags: String
        var dateAdded: Timestamp
        var uid: String
        var id: String
        var picId: String
        var sellerName: String
        var quantity: Int

    
    init(name: String,
         costPer: Int,
         currentStock: Int,
         desc: String,
         price: Int,
         tags: String,
         dateAdded: Timestamp,
         uid: String,
         id: String,
         picId: String,
         sellerName: String,
         quantity: Int ) {
        
        
        self.name = name
        self.costPer = costPer
        self.currentStock = currentStock
        self.desc = desc
        self.price = price
        self.tags = tags
        self.dateAdded = dateAdded
        self.uid = uid
        self.id = id
        self.picId = picId
        self.sellerName = sellerName
        self.quantity = quantity
    }
    
}
