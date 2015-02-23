//
//  Users.swift
//  TresureHuntGoogle
//
//  Created by Vincenzo Favara on 15/02/15.
//  Copyright (c) 2015 Vincenzo Favara (VinSoft). All rights reserved.
//

import Foundation

class User : NSObject, NSCoding {

    var username : String!
    var password : String!
    var email : String?
    
    var numberHunt : Int?
    var finishHuntAt :NSDate?
    
    
    init(myIdName:String, myPassword:String) {
        self.username = myIdName
        self.password = myPassword
    }
    
    internal required init(coder aDecoder: NSCoder) {
        self.username = aDecoder.decodeObjectForKey("kUsername") as String
        self.password = aDecoder.decodeObjectForKey("kPassword") as String
        self.email = aDecoder.decodeObjectForKey("kEmail") as? String
    }
    
    func encodeWithCoder(encoder: NSCoder) {
        encoder.encodeObject(self.username, forKey: "kUsername")
        encoder.encodeObject(self.password, forKey: "kPassword")
        encoder.encodeObject(self.email, forKey: "kEmail")
    }
}
