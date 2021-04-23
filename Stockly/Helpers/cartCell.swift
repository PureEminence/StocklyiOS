//
//  cartCell.swift
//  Stockly
//
//  Created by Matt Owen on 4/22/21.
//

import UIKit

class cartCell: UITableViewCell {

    @IBOutlet weak var imageC: UIImageView!
    @IBOutlet weak var quantityText: UILabel!
    @IBOutlet weak var priceText: UILabel!
    @IBOutlet weak var nameText: UILabel!
    
    
    @IBAction func SavedButton(_ sender: UIButton) {
        
    }
    
    @IBAction func RemoveButton(_ sender: UIButton) {
        
    }
    
    
    func setItem(item: CartItem) {
        

        nameText.text = item.name
        priceText.text = String(item.price)
        quantityText.text = String(item.quantity)
    }
    
}
