//
//  AppDelegate.swift
//  TreasureHuntGoogle
//
//  Created by Vincenzo Favara on 15/02/15.
//  Copyright (c) 2015 Vincenzo Favara (VinSoft). All rights reserved.
//

import UIKit

let goToGoogleSignInViewControllerSegue = "goToGoogleSignInViewControllerSegue"
let goToConnectUserControllerSegue = "goToConnectUserControllerSegue"
let goToClueControllerSegue = "goToClueControllerSegue"
let goToListHuntZipsControllerSegue = "goToListHuntZipsControllerSegue"
let goToListCluesControllerSegue = "goToListCluesControllerSegue"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    //for google+ auth to call finishedWithAuth after autentication
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String, annotation: AnyObject?) -> Bool {
        return GPPURLHandler.handleURL(url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        DataManager.sharedInstance.startDataManager()
        
        let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let navigationController:UINavigationController = storyboard.instantiateInitialViewController() as UINavigationController
        
        //
        let huntZipsViewController:UIViewController = storyboard.instantiateViewControllerWithIdentifier("VC") as UIViewController
        
        //
        let ConnectViewController:UIViewController = storyboard.instantiateViewControllerWithIdentifier("ConnectUserViewController") as UIViewController
        
        
//        navigationController.viewControllers = [rootViewController]
//        self.window?.rootViewController = navigationController
//        
//        self.window?.rootViewController.presentViewController(, animated: true, completion: nil)       
        
            
        if DataManager.sharedInstance.user != nil{
            //call connectUserController
        } else {
            //call navigationControllerController
        }
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

