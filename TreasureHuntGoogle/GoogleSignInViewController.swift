//
//  GoogleSignInViewController.swift
//  TresureHuntGoogle
//
//  Created by Vincenzo Favara on 15/02/15.
//  Copyright (c) 2015 Vincenzo Favara (VinSoft). All rights reserved.
//

//Google Plus(Google+,G+)

import UIKit

import AddressBook
import MediaPlayer
import AssetsLibrary
import CoreLocation
import CoreMotion

class GoogleSignInViewController: UIViewController, GPPSignInDelegate {
    
    let clientId = "654730014935-lck2a273nl897lh580smlsr0oc1gkict.apps.googleusercontent.com"
    let kSecretId = "HMVuL2tuQOlMtYedOmJqYM4-"

    @IBOutlet weak var btnGPlus: GPPSignInButton!
    @IBOutlet weak var label: UILabel!
    
    var signIn:GPPSignIn?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        signIn = GPPSignIn.sharedInstance()
        
        btnGPlus.style = kGPPSignInButtonStyleWide
        btnGPlus.colorScheme = kGPPSignInButtonColorSchemeDark
        
        
        signIn?.shouldFetchGooglePlusUser = true
        signIn?.shouldFetchGoogleUserID = true
        signIn?.shouldFetchGoogleUserEmail = true
        
        // You previously set kClientId in the "Initialize the Google+ client" step
        signIn?.clientID = clientId
        
        
        // Uncomment one of these two statements for the scope you chose in the previous step
        signIn?.scopes = [ kGTLAuthScopePlusLogin ];  // "https://www.googleapis.com/auth/plus.login" scope
        //signIn.scopes = @[ @"profile" ];            // "profile" scope
        
        // Optional: declare signIn.actions, see "app activities"
        signIn?.delegate = self;
        // Do any additional setup after loading the view, typically from a nib.
        signIn?.trySilentAuthentication()
        //signIn.authenticate()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signinButton(sender: GPPSignInButton) {
        
    }
    
    func finishedWithAuth(auth: GTMOAuth2Authentication!, error: NSError!) {
        if error != nil {
            label.text = auth.userEmail
            print("login success \(auth.userEmail) \n")
            println("\(signIn?.googlePlusUser.displayName) \n")
            var cc = signIn?.googlePlusUser.name.familyName
            println("\(cc) \n")
        } else {
            print("error")
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
    }
   
    func didFinishSelector(){
        print("didFinishSelector")
    }
    
    func googlePlusContactsCallback(ticket: GTLServiceTicket!, returnObject: AnyObject?, error: NSError!) {
        print("googlePlusContactsCallback")
        if(error != nil){
            print("\(error)")
            return
        }
        //let res  = object as GTLSwiftsampleapiPostRes
        //print("\(res.message) \(res.identifier) \(res.registeredAt) \(res.email)")
    }
    
    func didDisconnectWithError(error: NSError!) {
        println("connect fail")
    }



}

