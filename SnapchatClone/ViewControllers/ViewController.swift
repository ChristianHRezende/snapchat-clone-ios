//
//  ViewController.swift
//  SnapchatClone
//
//  Created by Christian Rezende on 10/08/22.
//

import UIKit
import Firebase
class ViewController: UIViewController {
    let auth = Auth.auth()
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        do {
//            try auth.signOut()
//        } catch let error {
//            print("Faild on try signout")
//        }
//        
        auth.addStateDidChangeListener { auth, user in
            if let userAuthenticated = user {
                self.performSegue(withIdentifier: "automaticSignIn", sender: nil)
            }
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        //
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }

}

