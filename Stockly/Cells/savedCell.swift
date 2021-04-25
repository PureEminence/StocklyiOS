//
//  savedCell.swift
//  Stockly
//
//  Created by Matt Owen on 4/23/21.
//

import SDWebImage
import UIKit
import Firebase
import FirebaseDatabase
import Foundation

class savedCell: UITableViewCell {

    
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var priceText: UILabel!
    @IBOutlet weak var nameText: UILabel!
    @IBOutlet weak var sellerButtonOut: UIButton!
    
    var picID: String!
    var itemID: String!
    var sellerName: String!
    let db = Firestore.firestore()
    let uid = Auth.auth().currentUser?.uid.description
    
    func setItem(item: SavedItem) {
    
        picID = item.picId
        itemID = item.id
        nameText.text = item.name
        priceText.text = String(item.price)
        sellerButtonOut.setTitle(item.sellerName, for: .normal)
    }
    
    
    @IBAction func toSellerProfile(_ sender: UIButton) {
        
        
    }
    
}
