//
//  ParseUtil.swift
//  TreasureHuntGoogle
//
//  Created by Vincenzo Favara on 20/02/15.
//  Copyright (c) 2015 Vincenzo Favara (VinSoft). All rights reserved.
//

// MARK: Parse

let parseApplicationId = "CnJuStRNWzvkfqJMn5cBwJFNuj7jULRi8epy4GMq"
let parseClientKey = "2DVlKvdYlC7zhRpPld2FG9ondnUH5B6znSjfQHC1"

//let CLASS_NAME_USER = "User"
let CLASS_NAME_HUNT_ZIP = "HuntZip"


func connectParse() {
    Parse.setApplicationId(parseApplicationId, clientKey: parseClientKey)
}

func saveUser(username:String, password:String, email:String){
    var pfUser = PFUser()
    pfUser.username = username
    pfUser.password = password
    pfUser.email = email
    saveObjectInBackground(pfUser)
    //pfUser.saveInBackgroundWithBlock(<#block: PFBooleanResultBlock!##(Bool, NSError!) -> Void#>)
}

func saveObjectInBackground(parseObj:PFObject){
    parseObj.saveInBackgroundWithBlock {
        (success: Bool!, error: NSError!) -> Void in
        if success == true {
            println("Parse Obj created with ID: \(parseObj.objectId)")
        } else {
            println(error)
        }
    }
}

func getCurrentUser() -> User {
    var pfUser = PFUser.currentUser()
    var user = User(myIdName: pfUser.username, myPassword: pfUser.password)
    user.email = pfUser.email
    user.numberHunt = pfUser["numberHunt"] as? Int
    user.finishHuntAt = pfUser["finishHuntAt"] as? NSDate
    return user
}

func getListUsers(numberHunt:Int) -> [User]{
    var users : [User] = []
    var usersQuery = PFUser.query()
    usersQuery.whereKey("numberHunt", equalTo:numberHunt)
    //        query.orderByDescending("createdAt")
    usersQuery.findObjectsInBackgroundWithBlock {
        (results: [AnyObject]!, error: NSError!) -> Void in
        // results will contain users
        for pfUser in results{
            var user = User(myIdName: pfUser.username, myPassword: pfUser.password!!)
            user.numberHunt = pfUser["numberHunt"] as? Int
            user.finishHuntAt = pfUser["finishHuntAt"] as? NSDate
            
            users.append(user)
        }
    }
    return users
}

func getListObjects(myClassName:String) -> [AnyObject]{
    var objects : [AnyObject] = []
    var objQuery = PFQuery(className:myClassName)
    objQuery.findObjectsInBackgroundWithBlock {
        (results: [AnyObject]!, error: NSError!) -> Void in
        // results will contain objects
        objects = results
    }
    return objects
}

func getObjectById(myClassName:String, myId:String) -> AnyObject?{
    var object : PFObject?
    var objQuery = PFQuery(className:myClassName)
    objQuery.getObjectInBackgroundWithId(myId, block: {
        (pfResult:PFObject!, error: NSError!) -> Void in
        object = pfResult
        })
    return object
}

func getListHunt() -> [HuntZip]{
    var hunts : [HuntZip] = []
    var huntObjs = getListObjects(CLASS_NAME_HUNT_ZIP)
    for huntObj in huntObjs{
        var hunt = HuntZip(myHuntId: huntObj.objectId, myHuntNum: huntObj["numberHunt"] as Int)
        hunt.huntDescription = huntObj["huntDescription"] as? String
        hunt.huntDate = huntObj["huntDate"] as? NSDate
        hunts.append(hunt)
    }
    return hunts
}

func getHuntZipFileById(id:String) -> NSData?{
    var dataFile : NSData?
    var obj: AnyObject? = getObjectById(CLASS_NAME_HUNT_ZIP, id)
    if obj != nil{
        var pfFile = obj!["zipHunt"] as PFFile
        pfFile.getDataInBackgroundWithBlock({ (data:NSData!, error:NSError!) -> Void in
            if (error == nil) {
                dataFile = data
            }
            }, progressBlock: { (avanzamento:Int32) -> Void in
                //do something
        })
    }
    return dataFile
}






