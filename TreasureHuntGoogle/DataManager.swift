//
//  DataManager.swift
//  TresureHuntGoogle
//
//  Created by Vincenzo Favara on 15/02/15.
//  Copyright (c) 2015 Vincenzo Favara (VinSoft). All rights reserved.
//

import UIKit

let namePlistHuntZip = "/huntzip.plist"
let namePlistHunt = "/hunt.plist"
let namePlistUser = "/user.plist"
//let urlPath = "http://162.248.167.159:8080/zip/hunt.zip"
let urlPath = "192.168.1.4:8080/hunt.zip" //per provare attivare il servizio web da Server
let nameHuntZip = "hunt.zip"
let nameJSON = "sampleHunt.json"

class DataManager: NSObject {
    
    // MARK: - Singleton
    //***** CODICE SPECIALE CHE TRASFORMA QUESTA CLASSE IN UN SINGLETON (snippet sw_sgt)*****\\
    class var sharedInstance:DataManager {
        get {
            struct Static {
                static var instance : DataManager? = nil
                static var token : dispatch_once_t = 0
            }
            
            dispatch_once(&Static.token) { Static.instance = DataManager() }
            
            return Static.instance!
        }
    }
    //***** FINE CODICE SPECIALE *****\\

    
    // MARK: - variabili globali
    var huntZips : [HuntZip] = []
    var huntZip : HuntZip?
    var hunt :Hunt?
    var user : User?
    
    //var mainController : MasterViewController!
    
    var docPath : String!
    
    // MARK: - Menager methods
    func startDataManager() {
        docPath = NSFileManager.applicationDocumentsDirectory().path
        //var filePath = docPath! + namePlist

        connectParse()
        
        if NSFileManager.defaultManager().fileExistsAtPath(docPath! + namePlistUser) {
            user = NSKeyedUnarchiver.unarchiveObjectWithFile(docPath! + namePlistUser) as? User
            salvaUser()
        }
    }
    
    func salvaUser() {
        NSKeyedArchiver.archiveRootObject(user!, toFile: docPath! + namePlistUser)
    }
    
    //SANDBOX
    //restituisce il percorso della cartella documents della sandbox dell'App
    func documentsFolderPath() -> String {
//        var paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
//        return paths[0] as String
        return NSFileManager.applicationDocumentsDirectory().path!
    }
    
    func saveFile(dataFile:NSData, name:String) -> Bool{
        return NSFileManager.saveDataToDocumentsDirectory(dataFile, path: name, subdirectory: nil)
    }
    
    func unzipHuntFile(name:String, destinationInDocumentFolder:String) -> Bool{
        let zipPath = documentsFolderPath() + name
        let destinatioFolder = documentsFolderPath() + destinationInDocumentFolder
        
        NSFileManager.deleteSubDirectoryFromDocumentsDirectory(destinatioFolder)
        
        var isUnzip = SSZipArchive.unzipFileAtPath(zipPath, toDestination: destinatioFolder)
        return isUnzip
    }
    
    // MARK: - Parse
    
    func loadParseData(){
        user = getCurrentUser()
        huntZips = getListHunt()
    }
    
    func loadCurrentUser(){
        user = getCurrentUser()
    }
    
    func loadHuntZips(){
        huntZips = getListHunt()
    }
    
    // MARK: - Hunt methods
    
    func downloadHuntZip() -> Bool{
        var dataFile : NSData? = getHuntZipFileById(huntZip!.huntId)
        if(dataFile == nil){
            println("No zip downloaded")
            return false
        }
        let isSave = saveFile(dataFile!, name: nameHuntZip)
        if(!isSave){
            println("No zip saved")
            return false
        }
        let isUnzipped = unzipHuntFile(nameHuntZip, destinationInDocumentFolder: nameHuntZip.stringByDeletingPathExtension)
        if(!isUnzipped){
            println("No zip unzipped")
            return false
        }
        return true
    }
    
    func createHunt(){
        
    }
}

