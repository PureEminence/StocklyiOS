//
//  recentCell.swift
//  Stockly
//
//  Created by Matt Owen on 4/23/21.
//

import SDWebImage
import UIKit
import Firebase
import FirebaseDatabase
import Foundation

class recentCell: UITableViewCell {


    @IBOutlet weak var nameText: UILabel!
    @IBOutlet weak var priceText: UILabel!
    @IBOutlet weak var sellerNameText: UIButton!
    @IBOutlet weak var itemImage: UIImageView!
    
    var picID: String!
    var itemID: String!
    var sellerName: String!
    let db = Firestore.firestore()
    let uid = Auth.auth().currentUser?.uid.description

    func setItem(item: Item) {
    
        picID = item.picId
        itemID = item.id
        nameText.text = item.name
        priceText.text = String(item.price)
        sellerNameText.setTitle(item.sellerName, for: .normal)
    }
}
