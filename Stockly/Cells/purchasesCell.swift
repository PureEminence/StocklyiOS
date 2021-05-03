//
//  purchasesCell.swift
//  Stockly
//
//  Created by Matt Owen on 4/23/21.
//

import SDWebImage
import UIKit
import Firebase
import FirebaseDatabase
import Foundation

class purchasesCell: UITableViewCell {

    @IBOutlet weak var orderIDText: UILabel!
    @IBOutlet weak var quantityText: UILabel!
    @IBOutlet weak var totalText: UILabel!
    @IBOutlet weak var dateText: UILabel!
    
    func setItem(item: PurItem) {
       
        orderIDText.text = item.id
        quantityText.text = String(item.quantity)
        totalText.text = "$".appending(item.total)
        let date = item.date.dateValue().description
        dateText.text = String(date.dropLast(5))
    }
}
