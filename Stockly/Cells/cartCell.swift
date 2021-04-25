//
//  cartCell.swift
//  Stockly
//
//  Created by Matt Owen on 4/22/21.
//

import SDWebImage
import UIKit
import Firebase
import FirebaseDatabase
import Foundation

class cartCell: UITableViewCell {

    @IBOutlet weak var imageC: UIImageView!
    @IBOutlet weak var quantityText: UILabel!
    @IBOutlet weak var priceText: UILabel!
    @IBOutlet weak var nameText: UILabel!
    @IBOutlet weak var savedText: UILabel!
    
    var picID: String!
    var itemID: String!
    var sellerName: String!
    let db = Firestore.firestore()
    let uid = Auth.auth().currentUser?.uid.description
    
    @IBAction func SavedButton(_ sender: UIButton) {
        
        let insertData:[String: Any] = [
            "name": nameText.text!,
            "price": priceText.text!,
            "seller": sellerName!,
            "numStock": quantityText.text!,
            "dateAdded": Date(),
            "picID": picID!
        ]
        
        db.collection("account").document(uid!)
            .collection("saved").document(itemID)
            .setData(insertData)
        
        savedText.alpha = 1
    }
    
    
    func setItem(item: CartItem) {
    
        picID = item.picId
        itemID = item.id
        nameText.text = item.name
        priceText.text = String(item.price)
        quantityText.text = String(item.quantity)
        sellerName = item.sellerName
    }
    
}
