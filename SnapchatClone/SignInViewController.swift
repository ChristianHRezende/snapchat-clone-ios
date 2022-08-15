//
//  SignInViewController.swift
//  SnapchatClone
//
//  Created by Christian Rezende on 10/08/22.
//

import UIKit
import Firebase

class SignInViewController: UIViewController {
    let auth = Auth.auth()

    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func signInButtonClickHandler(_ sender: Any) {
        
        if let email = self.emailTextField.text{
            if let password = self.passwordTextField.text{
                print(email)
                print(password)
                
                auth.signIn(withEmail: email, password: password) { user, error in
                    if error == nil {
                        print("Success on signup")
                        if user == nil {
                            MyAlert(title: "Authenticate error", message: "There was some problem on try authenticate").showTitleMessageAlert(viewController: self)
                        }else {
                            self.performSegue(withIdentifier: "signInSegue", sender: nil)
                            MyAlert(title: "Success", message: "User authenticated").showTitleMessageAlert(viewController: self)
                        }
                    }else{
                        
                        let errorRecovered  = error! as NSError
                        if let errorCode = errorRecovered.userInfo["FIRAuthErrorUserInfoNameKey"] {
                            MyAlert(title: "Incorrect data", message: "Check your the fields").showTitleMessageAlert(viewController: self)
                        }
                    }
                    
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }

}
