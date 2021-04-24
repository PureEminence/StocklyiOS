//
//  OrderPlacedViewController.swift
//  Stockly
//
//  Created by Matt Owen on 4/19/21.
//

import UIKit

class OrderPlacedViewController: UIViewController {

    
    @IBOutlet weak var orderIDText: UILabel!
    @IBOutlet weak var dateText: UILabel!
    @IBOutlet weak var shipNameText: UILabel!
    @IBOutlet weak var addLine1Text: UILabel!
    @IBOutlet weak var addLine2Text: UILabel!
    @IBOutlet weak var stateText: UILabel!
    @IBOutlet weak var cityText: UILabel!
    @IBOutlet weak var zipText: UILabel!
    @IBOutlet weak var cardNameText: UILabel!
    @IBOutlet weak var cardLast4Text: UILabel!
    @IBOutlet weak var cardExpText: UILabel!
    @IBOutlet weak var shipCost: UILabel!
    @IBOutlet weak var taxCost: UILabel!
    @IBOutlet weak var totalCost: UILabel!
    
    var orderID: String!
    var date: String!
    var shipName: String!
    var addLine1: String!
    var addLine2: String!
    var state: String!
    var city: String!
    var zip: String!
    var cardName: String!
    var cardLast4: String!
    var cardExp: String!
    var shippingCost: String!
    var tax: String!
    var total: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        orderIDText.text = orderID
        dateText.text = date
        shipNameText.text = shipName
        addLine1Text.text = addLine1
        addLine2Text.text = addLine2
        stateText.text = state
        cityText.text = city
        zipText.text = zip
        cardNameText.text = cardName
        cardLast4Text.text = cardLast4
        cardExpText.text = cardExp
        shipCost.text = shippingCost
        taxCost.text = tax
        totalCost.text = total
        
    }
    
    
    @IBAction func backToStore(_ sender: Any) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "StoreViewController") as? StoreViewController {
            self.navigationController?.pushViewController(vc, animated: true)
            }
    }
}
