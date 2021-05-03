//
//  LoginViewController.swift
//  Stockly
//
//  Created by Matt Owen on 4/11/21.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var errorMessage: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupElements()
    }
    
    func setupElements() { //hides error msg until needed
        errorMessage.alpha = 0 
    }

    

    @IBAction func loginBtnClicked(_ sender: Any) {
        //clean
        let email = emailText.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordText.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        //Sign in
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if error != nil { //if there is an error display error
                self.errorMessage.text = "Error logging in"
                self.errorMessage.alpha = 1
                
            }
            else { //get current VC and display new
                let tabViewController = self.storyboard?.instantiateViewController(identifier: "TabViewController") as? TabViewController
                //display
                self.view.window?.rootViewController = tabViewController
                self.view.window?.makeKeyAndVisible()
            }
        }
    }
}
