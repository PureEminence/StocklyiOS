//
//  SignUpViewController.swift
//  Stockly
//
//  Created by Matt Owen on 4/11/21.
//

import UIKit
import FirebaseAuth
import Firebase

class SignUpViewController: UIViewController {

    @IBOutlet weak var fNameText: UITextField!
    @IBOutlet weak var lastNameText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var errorMessage: UILabel!
    @IBOutlet weak var storeNameText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupElements()
    }
    
    func setupElements() { //hide error message until needed
        errorMessage.alpha = 0
    }
    
    //check if fields are filled in and password is valid
    func validateFields() -> String? {
        if fNameText.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            lastNameText.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailText.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordText.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            storeNameText.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
            {
                return "Please fill out all fields"
            }
        
        //Secure password check
        let cleanPass = passwordText.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if Utilities.isPasswordValid(cleanPass) == false {
            return "Password must include at least 8 characters, a number, and a special character."
        }
        
        return nil //returns nil if ok.
    }
    
    
    @IBAction func SignUpClicked(_ sender: Any) {
        //checking for errors
       let error = validateFields()
        
        if error != nil {
            displayError(error: error!)
        } else {
            //clean inputs
            let firstName = fNameText.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastName = lastNameText.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let storeName = storeNameText.text!.trimmingCharacters(in: .newlines)
            let email = emailText.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let pass = passwordText.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            
            //Create account if no errors arise
            Auth.auth().createUser(withEmail: email, password: pass) { (result, error) in
                //get id and setup data for db
                let uid = Auth.auth().currentUser?.uid.description
                let docData: [String: Any] = [
                    "firstName": firstName,
                    "lastName": lastName,
                    "storeName": storeName,
                    "email": email,
                    "created": Date()]
                
                //add the store name to auth.currentUser
                let user = Auth.auth().currentUser
                if let user = user {
                    let changeRequest = user.createProfileChangeRequest()
                    changeRequest.displayName = storeName
                    changeRequest.commitChanges { error in
                        if let error = error {
                            print(error)
                        } else {
                            //profile updated
                        }
                    }
                }
                
                if error != nil{
                    self.displayError(error: "Error creating account.")
                }
                else {
                    //connect and create account
                    let db = Firestore.firestore()
                    //store user in db
                    db.collection("account").document(uid!).setData(docData) { (error) in
                        
                        if error != nil {
                            self.displayError(error: "Failed to save user data.")
                        }
                    }
                    //to home screen
                    self.toHomeScreen()
                }
            }
        }
    }
    
    func toHomeScreen() {
        
        let tabViewController = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.tabViewController) as? TabViewController
        //display
        self.view.window?.rootViewController = tabViewController
        self.view.window?.makeKeyAndVisible()
    }
    
    //error message
    func displayError(error:String) {
        errorMessage.text = error
        errorMessage.alpha = 1
    }

}
