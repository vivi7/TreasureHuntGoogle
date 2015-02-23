//
//  HuntZip.swift
//  TreasureHuntGoogle
//
//  Created by Vincenzo Favara on 18/02/15.
//  Copyright (c) 2015 Vincenzo Favara (VinSoft). All rights reserved.
//

import Foundation

class HuntZip : NSObject {
    
    var huntId : String!
    var huntNum : Int!
    var huntZip : NSData?
    var active : Boolean?
    var huntDate : NSDate?
    var winner : String?
    var huntDescription : String?
    var theme : NSData?

    init(myHuntId:String, myHuntNum:Int) {
        huntId = myHuntId
        huntNum = myHuntNum
    }
}