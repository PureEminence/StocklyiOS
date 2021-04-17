//
//  itemCell.swift
//  Stockly
//
//  Created by Matt Owen on 4/14/21.
//

import UIKit
import FirebaseStorage
import SDWebImage

class itemCell: UITableViewCell {

    @IBOutlet weak var imageC: UIImageView!
    @IBOutlet weak var nameC: UILabel!
    @IBOutlet weak var priceC: UILabel!
    @IBOutlet weak var stockC: UILabel!
    @IBOutlet weak var iStockC: UILabel!
    @IBOutlet weak var tagsC: UILabel!
    
    
    
    func setItem(item: Item) {
        
//        let picURL = URL(string: item.picId)
//        let picView: UIImageView = self.imageView!
//        let tempImg = UIImage(named: "tempImage.jpg")
//        picView.sd_setImage(with: picURL, placeholderImage: tempImg)
        
        nameC.text = item.name
        priceC.text = "$".appending(String(item.price))
        stockC.text = "Stock: ".appending(String(item.currentStock))
        iStockC.text = "Initial Stock: ".appending(String(item.currentStock))
        tagsC.text = "Tags: ".appending(String(item.tags))
    }
}
