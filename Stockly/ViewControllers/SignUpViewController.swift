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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
     setupElements()
        
    }
    
    func setupElements() {
        errorMessage.alpha = 0
    }
    
    //check if fields are filled in and password is valid
    func validateFields() -> String? {
        if fNameText.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            lastNameText.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailText.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordText.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
            {
                return "Please fill out all fields"
            }
        

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
        }
        else {
            //clean inputs
            let firstName = fNameText.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastName = lastNameText.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailText.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let pass = passwordText.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            //Create account if no errors arise
            Auth.auth().createUser(withEmail: email, password: pass) { (result, error) in
                //get id and setup data for db
                let uid = Auth.auth().currentUser?.uid.description
                let docData: [String: Any] = [
                    "firstName": firstName,
                    "lastName": lastName,
                    "email": email,
                    "created": Date()]
                
                if error != nil{
                    self.displayError(error: "Error creating account.")
                }
                else {
                    //connect and create account
                    let db = Firestore.firestore()
                    //store user in db
                    db.collection("users").document(uid!).setData(docData) { (error) in
                        
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
