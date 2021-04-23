//
//  storeItemViewCell.swift
//  Stockly
//
//  Created by Matt Owen on 4/22/21.
//

import UIKit
import FirebaseStorage
import SDWebImage

class storeItemViewCell: UITableViewCell {

    @IBOutlet weak var displayImage: UIImageView!
    @IBOutlet weak var nameText: UILabel!
    @IBOutlet weak var priceText: UILabel!
    
    
    @IBAction func saveItemButton(_ sender: Any) {
        
    }
    
    func setItem(item: Item) {
        
        
        nameText.text = item.name
        priceText.text = String(item.price)
        
    }
    
}
