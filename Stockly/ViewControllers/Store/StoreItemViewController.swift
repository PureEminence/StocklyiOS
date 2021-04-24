//
//  StoreItemViewController.swift
//  Stockly
//
//  Created by Matt Owen on 4/19/21.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseStorage

class StoreItemViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{
   
    
    
    @IBOutlet weak var itemNameText: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var inStockText: UILabel!
    @IBOutlet weak var priceText: UILabel!
    @IBOutlet weak var descText: UILabel!
    @IBOutlet weak var tagsText: UILabel!
    @IBOutlet weak var addedtoCartText: UILabel!
    
    @IBOutlet weak var sellerNameText: UILabel!//must convert UID to name
    
    @IBOutlet weak var numItemsScrollPicker: UIPickerView!
    
    
    var itemData: Item!
    var itemImage = UIImage()
    var pickNum: Int!
    var pickerNumbers = [Int]()
    var pickerNum: Int!
    var itemID: String!
    
    override func viewDidLoad() {
        addedtoCartText.alpha = 0 //hide till needed
        super.viewDidLoad()
        //gets vars from itemData and sets to view texts
        itemID = itemData.id
        itemNameText.text = itemData.name
        priceText.text = String(itemData.price)
        inStockText.text = String(itemData.currentStock)
        descText.text = itemData.desc
        tagsText.text = itemData.tags
        pickNum = itemData.currentStock
        imageView.image = itemImage
        //number picker setup
        for i in 1...pickNum {
            pickerNumbers.append(i)
        }
        self.numItemsScrollPicker.delegate = self
        self.numItemsScrollPicker.dataSource = self
        
    }
    
    @IBAction func addCartBtn(_ sender: Any) {
        let db = Firestore.firestore()
        
        
        let numItems:Int = pickerNum
        let uid = Auth.auth().currentUser?.uid.description
        let price = numItems * itemData.price
        let insertData:[String: Any] = [
            "name": itemData.name,
            "price": itemData.price,
            "currentStock":itemData.currentStock,
            "dateAdded":itemData.dateAdded,
            "desc":itemData.desc,
            "image":itemData.picId,
            "tags":itemData.tags,
            "uid":itemData.uid,
            "numInCart": numItems,
            "salePrice": price,
            "sellerName": itemData.sellerName
        ]
        
        
        
        db.collection("account").document(uid!)
            .collection("cart").document("CartID").setData(["modifiedAt": Date()])
            
            
        db.collection("account").document(uid!)
            .collection("cart").document("CartID")
            .collection("cart_items").document(itemID)
            .setData(insertData)
        
        addedtoCartText.text = "Added \(numItems) items to the cart"
        addedtoCartText.alpha = 1
        
    }
    
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        pickerNumbers.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        pickerNum = pickerNumbers[row]
        return String(pickerNumbers[row])
    }
}
