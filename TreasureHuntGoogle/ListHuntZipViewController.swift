//
//  ListHuntZipViewController.swift
//  TreasureHuntGoogle
//
//  Created by Vincenzo Favara on 21/02/15.
//  Copyright (c) 2015 Vincenzo Favara (VinSoft). All rights reserved.
//

import UIKit
import Foundation

class ListHuntZipViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    let tableViewTitle = "Hunts"
    
    var segue = false
    var isDownloaded = true
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    var huntZips: [HuntZip] = DataManager.sharedInstance.huntZips
    var huntZip : HuntZip?
    
    override func viewDidLoad() {
        //        super.viewDidLoad()
        if huntZips.isEmpty {
            DataManager.sharedInstance.loadHuntZips()
            huntZips = DataManager.sharedInstance.huntZips
        }
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    func displayAlert(title:String, error:String) {
        var alert = UIAlertController(title: title, message: error, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { action in
            self.dismissViewControllerAnimated(true, completion: nil)
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return huntZips.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        huntZip = huntZips[indexPath.row]
        var color:UIColor = UIColor.redColor()
        
        var cell = UITableViewCell()
        cell.textLabel!.text = "\(huntZip!.huntNum) " + huntZip!.huntDescription!
        cell.backgroundColor = color
        return cell
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return tableViewTitle
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.huntZip = self.huntZips[indexPath.row]
        
        activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 50, 50))
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        
        if DataManager.sharedInstance.downloadHuntZip() == true {
            self.activityIndicator.stopAnimating()
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
            self.performSegueWithIdentifier(goToClueControllerSegue, sender: self)
        } else {
            self.activityIndicator.stopAnimating()
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
            
            self.displayAlert("Download failed", error: "Please try again later")
        }
    }
    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        var detailViewController = segue.destinationViewController as ClueViewController
//        //detailViewController.clue = self.clue
//    }
    
}