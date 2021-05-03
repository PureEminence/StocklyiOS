//
//  EditItemViewController.swift
//  Stockly
//
//  Created by Matt Owen on 4/19/21.
//

import UIKit
import Firebase
import FirebaseAuth
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
    @IBOutlet weak var errorMessageText: UILabel!
    
    var itemData: Item!
    var image = UIImage()
    var errorMessage: String!
    var indexPath: IndexPath!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupElements()
        let date = itemData.dateAdded.dateValue().description
        errorMessageText.text = errorMessage
        itemImageView.image = image
        soldNumText.text = "Sold: ".appending(String(itemData.numSold))
        dateAddedText.text = String(date.dropLast(5))
        stockNumText.text = "In stock: ".appending(String(itemData.currentStock))
        updateNameText.text = itemData.name
        updatePriceText.text = String(itemData.price)
        updateDescText.text = itemData.desc
        updateTagsText.text = itemData.tags
        
    }
    
    func setupElements() {//modify element atributes
        errorMessageText.alpha = 0
    }
    
    func validateFields() -> String? { //check if fields are blank
        if soldNumText.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            dateAddedText.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            updateNameText.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            updatePriceText.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            updateDescText.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            updateTagsText.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
            {
                return "Please fill out all fields"
            }
        
        return nil //returns nil if ok.
    }
    
    
    @IBAction func updateButtonPressed(_ sender: Any) {
        let error = validateFields()
        if error != nil {
            showError(error: error!)
        } else {
            //set vals to Text fields when button pressed
            let updateName = updateNameText.text
            let updatePrice = updatePriceText.text
            let updateDesc = updateDescText.text
            let updateTags = updateTagsText.text
            var addStock = addStockText.text
            
            if (addStock == "") {//if string nil set int to 0
                addStock = "0"
            }
            
            let stockNum = Int((stockNumText.text?.dropFirst(10))!)!+Int(addStock!)!
            

            let docData: [String: Any] = [ //create data document to be uploaded
                "name": updateName!,
                "price": Int(updatePrice!)!,
                "desc": updateDesc!,
                "tags": updateTags!,
                "currentStock": stockNum,
            ]
            
            
            if error != nil{ // if no error update items in DB
                self.showError(error: "Error Updating items")
            } else {
                let db = Firestore.firestore()
                
                db.collection("items").document(itemData.id).updateData(docData)
                self.pageNav()
                }
            
            
        }
    }
    
    func showError(error: String) { //show error
        errorMessageText.text = error
        errorMessageText.alpha = 1
    }
    
    func  pageNav() { //back to inv screen thru tabVC
        
        let tabVC = self.storyboard?.instantiateViewController(identifier: "TabViewController") as? TabViewController
        self.view.window?.rootViewController = tabVC
        self.view.window?.makeKeyAndVisible()
        }
        
    
}
