//
//  EditItemViewController.swift
//  Stockly
//
//  Created by Matt Owen on 4/19/21.
//

import UIKit
import Firebase

class EditItemViewController: UIViewController {

    @IBOutlet weak var soldNumText: UILabel!
    @IBOutlet weak var dateAddedText: UILabel!
    @IBOutlet weak var stockNumText: UILabel!
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var updateNameText: UITextField!
    @IBOutlet weak var updatePriceText: UITextField!
    @IBOutlet weak var addStockText: UITextField!
    @IBOutlet weak var updateDescText: UITextField!
    @IBOutlet weak var updateTagsText: UITextField!
    
    
    var itemData: Item!
    var image = UIImage()
    var soldNum: String?
    var stockNum: String!
    var dateAdded: Timestamp!
    var updateName: String!
    var updatePrice: String!
    var updateDesc: String!
    var updateTags: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //convert firebase timestamp to date time
        let dateVal = itemData.dateAdded.dateValue()
        let dF = DateFormatter()
        dF.dateFormat = "MM/DD/YY, hh:mm"
        
        itemImageView.image = image
        soldNumText.text = String(itemData.numSold)
        dateAddedText.text = dF.string(from: dateVal)
        stockNumText.text = String(itemData.currentStock)
        updateNameText.text = itemData.name
        updatePriceText.text = String(itemData.price)
        updateDescText.text = itemData.desc
        updateTagsText.text = itemData.tags
    }
}
