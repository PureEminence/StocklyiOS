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

    @IBOutlet weak var profilePicOut: UIButton!
    @IBOutlet weak var firstNameText: UITextField!
    @IBOutlet weak var lastNameText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var taglineText: UITextField!
    @IBOutlet weak var bioText: UITextField!
    
    var profileInfo: Profile!
    override func viewDidLoad() {
        super.viewDidLoad()

        firstNameText.text = profileInfo.firstName
        lastNameText.text = profileInfo.lastName
        emailText.text = profileInfo.email
        taglineText.text = profileInfo.tagline
        bioText.text = profileInfo.bioMessage
    }
    

    @IBAction func saveProfileBtn(_ sender: Any) {
    // set to textfields
        let profilePic = profilePicOut.image(for: .normal)
        let firstName = firstNameText.text
        let lastName = lastNameText.text
        let email = emailText.text
        let tagline = taglineText.text
        let bio = bioText.text
        //send to db
        let db = Firestore.firestore()
        //get uid
        let uid = Auth.auth().currentUser?.uid.description
        //add data to profile db
        db.collection("account").document(uid!)
            .setData(["profilePic": profilePic!, "firstName": firstName!, "lastName": lastName!, "email": email!, "tagline": tagline!, "bio": bio!])
        
    }
    

    @IBAction func addProfilePicBtn(_ sender: Any) {
        
        
    }
}
