//
//  storeItemViewCell.swift
//  Stockly
//
//  Created by Matt Owen on 4/22/21.
//

import SDWebImage
import UIKit
import Firebase
import FirebaseDatabase
import Foundation
protocol CellDelegate: class {
    func CellBtnTapped(tag: Int)
}

class storeItemViewCell: UITableViewCell {

    weak var delegate: CellDelegate?
    @IBOutlet weak var displayImage: UIImageView!
    @IBOutlet weak var nameText: UILabel!
    @IBOutlet weak var priceText: UILabel!
    @IBOutlet weak var sellerNameButton: UIButton!
    
    
    @IBAction func saveItemButton(_ sender: Any) {
    }
    
    
    @IBAction func sellerButton(_ sender: UIButton) {
        delegate?.CellBtnTapped(tag: sender.tag)
    }
    
    
    
    func setItem(item: Item) {
        
        sellerNameButton.setTitle(item.sellerName, for: .normal)
        nameText.text = item.name
        priceText.text = "$".appending(String(item.price))
        
    }
    
}
