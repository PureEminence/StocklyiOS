//
//  purchaseCell.swift
//  Stockly
//
//  Created by Matt Owen on 4/24/21.
//

import UIKit

class purchaseCell: UITableViewCell {

    @IBOutlet weak var itemNameText: UILabel!
    @IBOutlet weak var quantityText: UILabel!
    @IBOutlet weak var priceText: UILabel!
    @IBOutlet weak var itemTotalText: UILabel!
    @IBOutlet weak var sellerNameText: UIButton!
    @IBOutlet weak var itemImage: UIImageView!
    
    func setItem(item: PurchaseItem) {
       
        
        itemNameText.text = item.name
        quantityText.text = String(item.numPur)
        priceText.text = String(item.price)
        itemTotalText.text = "$".appending(String(item.salePrice))
        sellerNameText.setTitle(item.sellerName, for: .normal)
        
    }
}
