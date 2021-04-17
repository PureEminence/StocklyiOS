//
//  ProfileViewController.swift
//  Stockly
//
//  Created by Matt Owen on 4/13/21.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func LogoutBtn(_ sender: Any) {
        
        
        do {
            try Auth.auth().signOut()
        } catch let logError {
            print(logError)
        }
        
        self.toLoginScreen()
        
    }
    
    func toLoginScreen(){
        let navVC = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.viewController) as? ViewController
        self.view.window?.rootViewController = navVC
        self.view.window?.makeKeyAndVisible()
    }
}
