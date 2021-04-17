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
    
    func setupElements() {
        errorMessage.alpha = 0 
    }

    

    @IBAction func loginBtnClicked(_ sender: Any) {
        //clean
        let email = emailText.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordText.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        //Sign in
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if error != nil {
                self.errorMessage.text = "Error logging in"
                self.errorMessage.alpha = 1
                
            }
            else {
                UserDefaults.standard.setValue(email, forKey: "email")
                
                let tabViewController = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.tabViewController) as? TabViewController
                //display
                self.view.window?.rootViewController = tabViewController
                self.view.window?.makeKeyAndVisible()
            }
        }
    }
}
