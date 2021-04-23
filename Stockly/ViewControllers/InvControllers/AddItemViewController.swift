//
//  AddItemViewController.swift
//  Stockly
//
//  Created by Matt Owen on 4/12/21.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseStorage

class AddItemViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var itemNameText: UITextField!
    @IBOutlet weak var priceText: UITextField!
    @IBOutlet weak var initialStockText: UITextField!
    @IBOutlet weak var costPerText: UITextField!
    @IBOutlet weak var descText: UITextField!
    @IBOutlet weak var tagsText: UITextField!
    @IBOutlet weak var errorMessage: UILabel!
    @IBOutlet weak var uploadPicBtn: UIButton!
    
    private let storage = Storage.storage().reference()
    var urlString = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    setupElements()
    }
    
    @IBAction func uploadPicBtn(_ sender: Any) { //upload image button
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        picker.allowsEditing = true
        present(picker,animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        //get image from users photo library
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else { return }
        guard let imageData = image.pngData() else { return }
        
        var ranNum = String(Int.random(in: 0..<1000000)) //Randomly Generate Image File location
        var picStore = Auth.auth().currentUser?.uid.description.appending(ranNum) //Uses uid as a prefix
        
        storage.child("images/items/file\(picStore!).png") //store item in database
            .putData(imageData, metadata: nil, completion: { _, error in
                guard error == nil else {
                    print("Upload Failed")
                    return
                }
                
                self.storage.child("images/items/file\(picStore!).png").downloadURL { url, error in
                    guard let url = url, error == nil else {
                        return
                    }
                    self.urlString = url.absoluteString
                }
        })
    }
    

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {//image picker cancel
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    func setupElements() { //error message opacity
        errorMessage.alpha = 0
    }
    
    
    func validateFields() -> String? { //check if fields are empty then check ints
        if itemNameText.text?.trimmingCharacters(in:
                .whitespacesAndNewlines) == "" ||
            priceText.text?.trimmingCharacters(in:
                .whitespacesAndNewlines) == "" ||
            initialStockText.text?.trimmingCharacters(in:
                .whitespacesAndNewlines) == "" ||
            costPerText.text?.trimmingCharacters(in:
                .whitespacesAndNewlines) == "" ||
            descText.text?.trimmingCharacters(in:
                .whitespacesAndNewlines) == "" ||
            tagsText.text?.trimmingCharacters(in:
                .whitespacesAndNewlines) == ""
            {
                return "Please fill out all fields"
    
        } //Validate ints
        else if isInputInt(textfield: priceText) == false {
            return "price must be an interger"
        }
        else if isInputInt(textfield: initialStockText) == false {
            return "Initial stock must be an interger"
        }
        else if isInputInt(textfield: costPerText) == false {
            return "Cost per must be an interger"
        }
                
        
        return nil //returns if ok.
    }
    
    func isInputInt(textfield: UITextField) -> Bool { //validate input ints
        return Int(textfield.text!) != nil
    }
    
    
    @IBAction func addItemBtn(_ sender: Any) { //Sends content to database
        //error checking
        let error = validateFields()
        
        if error != nil {
            displayError(error: error!)
        }
        else {
            //get text from fields
            let itemName = itemNameText.text
            let price = Int(priceText.text!)
            let initStock = Int(initialStockText.text!)
            let costPer = Int(costPerText.text!)
            let desc = descText.text
            let tags = tagsText.text
            
            let imageURL = urlString
            print("printing\(urlString)")
            let uid = Auth.auth().currentUser?.uid.description
            let sold:Int = 0
            let db = Firestore.firestore()
            
            
            let docRef = db.collection("account").document(uid!)
                docRef.getDocument { (document, error) in
                       if let document = document, document.exists {
                        let dataDescription:[String: Any] = document.data()!
                        //get store name and unwrap
                        let storeName = dataDescription["storeName"].map(String.init(describing:)) ?? "nil"
                        
                        //save to database
                        db.collection("items").addDocument(data: ["sellerName" : storeName,"name": itemName!, "price": price!, "costPer": costPer!, "desc": desc!, "tags": tags!, "currentStock": initStock!,"dateAdded": Date(),"uid":uid!,"numSold":sold, "image": imageURL])
                       } else {
                           print("Document does not exist")
                       }
                   }
            self.toInv()
        }
        
    }//end add item to database
    
    func toInv() { //returns to inv page
        let tabVC = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.tabViewController) as? TabViewController
        self.view.window?.rootViewController = tabVC
        self.view.window?.makeKeyAndVisible()
    }
    
    func displayError(error:String) { //error message opacity
        errorMessage.text = error
        errorMessage.alpha = 1
    }
}
