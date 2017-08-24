//
//  User.swift
//  DrMouse
//
//  Created by Mickael Fonck on 09/08/2016.
//  Copyright © 2016 Mickael Fonck. All rights reserved.
//

import UIKit

class User: NSObject {
    var username: String
    var email : String
    
    init(username: String, email: String) {
        self.username = username
        self.email = email
    }
    
    convenience override init() {
        self.init(username:  "", email: "")
    }
}