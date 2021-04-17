//
//  ProfileEditViewController.swift
//  Stockly
//
//  Created by Matt Owen on 4/13/21.
//

import UIKit
import FirebaseAuth
import Firebase


class ProfileEditViewController: UIViewController {

    
    @IBOutlet weak var shopNameText: UITextField!
    @IBOutlet weak var bioText: UITextField!
    @IBOutlet weak var taglineText: UITextField!
    @IBOutlet weak var locationText: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func saveProfileBtn(_ sender: Any) {
    // set to textfields
        let shopName = shopNameText.text
        let bio = bioText.text
        let tagline = taglineText.text
        let location = locationText.text
        //send to db
        let db = Firestore.firestore()
        //get uid
        let userId = Auth.auth().currentUser?.uid.description
        //add data to profile db
        db.collection("profile").addDocument(data: ["shopName": shopName, "bio": bio, "tagline": tagline, "location": location, "uid": userId])
    }
    

    @IBAction func addProfilePicBtn(_ sender: Any) {
        
        
    }
}
