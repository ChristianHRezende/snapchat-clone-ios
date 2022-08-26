//
//  Snap.swift
//  SnapchatClone
//
//  Created by Christian Rezende on 24/08/22.
//

import Foundation

class Snap {
    var idendifier = ""
    var name = ""
    var from = ""
    var description = ""
    var urlImage = ""
    var idImage = ""
    
    init( identifier:String, name:String, from:String , description: String ,  urlImage:String, idImage:String) {
        self.idendifier = identifier
        self.name = name
        self.from = from
        self.description = description
        self.urlImage = urlImage
        self.idImage = idImage
    }
    
}
