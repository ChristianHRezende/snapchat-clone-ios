//
//  SignUpViewController.swift
//  SnapchatClone
//
//  Created by Christian Rezende on 10/08/22.
//

import UIKit
import Firebase
class SignUpViewController: UIViewController {
    
    let auth = Auth.auth()
    let database = Database.database()
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var completeNameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    @IBAction func signUp(_ sender: Any) {
        if let email = self.emailTextField.text{
            if let completeName = self.completeNameTextField.text {
                if let password = self.passwordTextField.text{
                    if let confirmPassword = self.confirmPasswordTextField.text{
                        print(email)
                        print(password)
                        // passwords
                        if password == confirmPassword {
                            if !completeName.isEmpty{
                                
                                auth.createUser(withEmail: email, password: password) { authData, error in
                                    if error == nil {
                                        print("Success on signup")
                                        if authData == nil {
                                            self.showAlert(title: "Authenticate error", message: "Some problem on try authenticate")
                                            
                                        }else {
                                            //new user
                                            let userData:Dictionary<String,String> = ["name":completeName,"email":email]
                                            print(userData)
                                            
                                            let userRefDatabase = self.database.reference().child("users").child(authData!.user.uid)
                                            userRefDatabase.setValue(userData)
                                            
                                            //redirect
                                            self.performSegue(withIdentifier: "signUpSegue", sender: nil)
                                        }
                                    }else{
                                        
                                        let errorRecovered  = error! as NSError
                                        if let errorCode = errorRecovered.userInfo["FIRAuthErrorUserInfoNameKey"] {
                                            var msgError = ""
                                            let textError = errorCode as! String
                                            
                                            switch textError {
                                                
                                            case "ERROR_INVALID_EMAIL":
                                                msgError = "Ïnvalid e-mail, type a valid e-mail"
                                                break
                                            case "ERROR_WEAK_PASSWORD" :
                                                msgError = "Your passwords need to have more than 5 chars, with letters and numbers"
                                                break
                                                
                                            case "ERROR_EMAIL_ALREADY_IN_USE" :
                                                msgError = "Email already in user"
                                                break
                                                
                                            default:
                                                msgError = "Something's wrong"
                                                
                                            }
                                            
                                            self.showAlert(title: "Incorrect data", message: msgError)
                                        }
                                    }
                                }
                            }else{
                                self.showAlert(title: "Incorrect data", message: "The complete name field mustn't be empty")
                                
                            }
                        }else {
                            self.showAlert(title: "Incorrect data", message: "The passwords are different")
                        }
                    }
                }}
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    func showAlert(title:String,message:String){
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let actionController = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(actionController)
        present(alertController, animated: true, completion: nil)
        
    }
    
}
