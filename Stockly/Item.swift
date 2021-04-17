//
//  Item.swift
//  Stockly
//
//  Created by Matt Owen on 4/14/21.
//
import SwiftUI
import Foundation
import UIKit
import Firebase

class Item {
    
    
        var name: String
        var costPer: Int
        var currentStock: Int
        var desc: String
        var initialStock: Int
        var price: Int
        var tags: String
        var dateAdded: Timestamp
        var uid: String
        var id: String
        var picId: String

    
    init(name: String,
         costPer: Int,
         currentStock: Int,
         desc: String,
         initialStock: Int,
         price: Int,
         tags: String,
         dateAdded: Timestamp,
         uid: String,
         id: String,
         picId: String) {
        
        
        self.name = name
        self.costPer = costPer
        self.currentStock = currentStock
        self.desc = desc
        self.initialStock = initialStock
        self.price = price
        self.tags = tags
        self.dateAdded = dateAdded
        self.uid = uid
        self.id = id
        self.picId = picId
    }
    
}



