//
//  User.swift
//  SnapchatClone
//
//  Created by Christian Rezende on 16/08/22.
//

import Foundation

class User {
    var email:String
    var name:String
    var uid:String
    
    
    init(email:String,name:String,uid:String) {
        self.email = email
        self.name = name
        self.uid = uid
    }
  
}
