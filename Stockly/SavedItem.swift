//
//  SavedItem.swift
//  Stockly
//
//  Created by Matt Owen on 4/23/21.
//

import SwiftUI
import Foundation
import UIKit
import Firebase

class SavedItem {
    
    
        var name: String
        var currentStock: String
        var price: String
        var dateAdded: Timestamp
        var id: String
        var picId: String
        var sellerName: String

    
    init(name: String,
         currentStock: String,
         price: String,
         dateAdded: Timestamp,
         id: String,
         picId: String,
         sellerName: String) {
        
        
        self.name = name
        self.currentStock = currentStock
        self.price = price
        self.dateAdded = dateAdded
        self.id = id
        self.picId = picId
        self.sellerName = sellerName
    }
    
}
