//
//  SalesCell.swift
//  Stockly
//
//  Created by Matt Owen on 4/24/21.
//

import UIKit

class SalesCell: UITableViewCell {

    @IBOutlet weak var buyerNameText: UILabel!
    @IBOutlet weak var orderIDText: UILabel!
    @IBOutlet weak var quantityText: UILabel!
    @IBOutlet weak var totalText: UILabel!
    @IBOutlet weak var dateText: UILabel!
    
    
    func setItem(item: SalesItem) {
        
        buyerNameText.text = item.buyerName
        orderIDText.text = item.id
        quantityText.text = String(item.itemNumTotal)
        totalText.text = "$".appending(String(item.total))
        
        let date = item.date.dateValue().description
        dateText.text = String(date.dropLast(5))
    }
    
}
