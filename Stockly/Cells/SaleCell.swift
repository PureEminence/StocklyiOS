//
//  SaleCell.swift
//  Stockly
//
//  Created by Matt Owen on 4/24/21.
//

import UIKit

class SaleCell: UITableViewCell {

   
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var itemNameText: UILabel!
    @IBOutlet weak var quantityText: UILabel!
    @IBOutlet weak var priceText: UILabel!
    @IBOutlet weak var totalText: UILabel!
    
    func setItem(item:SaleItem) {
        itemNameText.text = item.name
        quantityText.text = String(item.quantity)
        priceText.text = String(item.price)
        totalText.text = String(item.total)
    }
}
