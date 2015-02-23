//
//  FileSave.swift
//  TreasureHuntGoogle
//
//  Created by Vincenzo Favara on 22/02/15.
//  Copyright (c) 2015 Vincenzo Favara (VinSoft). All rights reserved.
//

import Foundation

//Crea una data direttamente dai valori passati
extension NSDate {
    
    func customDate(year ye:Int, month mo:Int, day da:Int, hour ho:Int, minute mi:Int, second se:Int) -> NSDate {
        var comps = NSDateComponents()
        comps.year = ye
        comps.month = mo
        comps.day = da
        comps.hour = ho
        comps.minute = mi
        comps.second = se
        var date = NSCalendar.currentCalendar().dateFromComponents(comps)
        return date!
    }
}

extension NSFileManager {
    //pragma mark - strip slashes
    
    class func stripSlashIfNeeded(stringWithPossibleSlash:String) -> String {
        var stringWithoutSlash:String = stringWithPossibleSlash
        // If the file name contains a slash at the beginning then we remove so that we don't end up with two
        if stringWithPossibleSlash.hasPrefix("/") {
            stringWithoutSlash = stringWithPossibleSlash.substringFromIndex(advance(stringWithoutSlash.startIndex,1))
        }
        // Return the string with no slash at the beginning
        return stringWithoutSlash
    }
    
    class func saveDataToDocumentsDirectory(fileData:NSData, path:String, subdirectory:String?) -> Bool
    {
        // Remove unnecessary slash if need
        var newPath = self.stripSlashIfNeeded(path)
        var newSubdirectory:String?
        if (subdirectory != nil) {
            newSubdirectory = self.stripSlashIfNeeded(subdirectory!)
        }
        // Create generic beginning to file save path
        var savePath = self.applicationDocumentsDirectory().path!+"/"
        
        if (newSubdirectory != nil) {
            savePath += newSubdirectory!
            self.createSubDirectory(savePath)
            savePath += "/"
        }
        
        // Add requested save path
        savePath += newPath
        
        println(savePath)
        // Save the file and see if it was successful
        var ok:Bool = NSFileManager.defaultManager().createFileAtPath(savePath,contents:fileData, attributes:nil)
        
        // Return status of file save
        return ok;
        
    }
    
    class func applicationDocumentsDirectory() -> NSURL {
        var documentsDirectory:String?
        var paths:[AnyObject] = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true);
        if paths.count > 0 {
            if let pathString = paths[0] as? NSString {
                documentsDirectory = pathString
            }
        }
        return NSURL(fileURLWithPath: documentsDirectory!)!
    }
    
    class func applicationLibraryDirectory() -> NSURL {
        var libraryDirectory:String?
        var paths:[AnyObject] = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.LibraryDirectory, NSSearchPathDomainMask.UserDomainMask, true);
        if paths.count > 0 {
            if let pathString = paths[0] as? NSString {
                libraryDirectory = pathString
            }
        }
        return NSURL(fileURLWithPath: libraryDirectory!)!
    }
    
    class func applicationSupportDirectory() -> NSURL {
        var applicationSupportDirectory:String?
        var paths:[AnyObject] = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.ApplicationSupportDirectory, NSSearchPathDomainMask.UserDomainMask, true);
        if paths.count > 0 {
            if let pathString = paths[0] as? NSString {
                applicationSupportDirectory = pathString
            }
        }
        return NSURL(fileURLWithPath: applicationSupportDirectory!)!
    }
    
    class func applicationTemporaryDirectory() -> NSURL {
        var temporaryDirectory:String? = NSTemporaryDirectory();
        return NSURL(fileURLWithPath: temporaryDirectory!)!
    }
    
    class func applicationCachesDirectory() -> NSURL {
        
        var cachesDirectory:String?
        
        var paths = NSSearchPathForDirectoriesInDomains(.ApplicationSupportDirectory,.UserDomainMask, true);
        
        if paths.count > 0 {
            if let pathString = paths[0] as? NSString {
                cachesDirectory = pathString
            }
        }
        return NSURL(fileURLWithPath: cachesDirectory!)!;
    }
    
    class func createSubDirectory(subdirectoryPath:NSString) -> Bool {
        var error:NSError?
        var isDir:ObjCBool=false;
        var exists:Bool = NSFileManager.defaultManager().fileExistsAtPath(subdirectoryPath, isDirectory:&isDir)
        if (exists) {
            /* a file of the same name exists, we don't care about this so won't do anything */
            if isDir {
                /* subdirectory already exists, don't create it again */
                return true;
            }
        }
        var success:Bool = NSFileManager.defaultManager().createDirectoryAtPath(subdirectoryPath, withIntermediateDirectories:true, attributes:nil, error:&error)
        
        if (error != nil) { println(error) }
        
        return success;
    }
    
    class func deleteFromDocumentsDirectory(subdirectoryOrFileName:String) -> Bool{
        // Remove unnecessary slash if need
        var newSubdirectory:String? = self.stripSlashIfNeeded(subdirectoryOrFileName)
        
        // Create generic beginning to file delete path
        var deletePath = self.applicationDocumentsDirectory().path!+"/"
        
        if (newSubdirectory != nil) {
            deletePath += newSubdirectory!
            var dir:ObjCBool=true
            if !NSFileManager.defaultManager().fileExistsAtPath(deletePath) {
                return false
            }
        }
        // Delete the file and see if it was successful
        var error:NSError?
        var isDelete : Bool = NSFileManager.defaultManager().removeItemAtPath(deletePath, error: &error)
        if (error != nil) {
            println(error)
        }
        return isDelete
    }
}

//Aggiunge l' effetto parallasse
extension UIView {
    
    func addParallax(X horizontal:Float, Y vertical:Float) {
        
        var parallaxOnX = UIInterpolatingMotionEffect(keyPath: "center.x", type: UIInterpolatingMotionEffectType.TiltAlongHorizontalAxis)
        parallaxOnX.minimumRelativeValue = -horizontal
        parallaxOnX.maximumRelativeValue = horizontal
        
        var parallaxOnY = UIInterpolatingMotionEffect(keyPath: "center.y", type: UIInterpolatingMotionEffectType.TiltAlongVerticalAxis)
        parallaxOnY.minimumRelativeValue = -vertical
        parallaxOnY.maximumRelativeValue = vertical
        
        var group = UIMotionEffectGroup()
        group.motionEffects = [parallaxOnX, parallaxOnY]
        self.addMotionEffect(group)
    }
    
    func blurMyBackgroundDark(adjust b:Bool, white v:CGFloat, alpha a:CGFloat) {
        
        for v in self.subviews {
            if v is UIVisualEffectView {
                v.removeFromSuperview()
            }
        }
        
        var blur = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        var fxView = UIVisualEffectView(effect: blur)
        
        if b {
            fxView.contentView.backgroundColor = UIColor(white:v, alpha:a)
        }
        
        fxView.frame = self.bounds
        
        self.addSubview(fxView)
        self.sendSubviewToBack(fxView)
    }
    
    func blurMyBackgroundLight() {
        
        for v in self.subviews {
            if v is UIVisualEffectView {
                v.removeFromSuperview()
            }
        }
        
        var blur = UIBlurEffect(style: UIBlurEffectStyle.Light)
        var fxView = UIVisualEffectView(effect: blur)
        
        var rect = self.bounds
        rect.size.width = CGFloat(2500)
        
        fxView.frame = rect
        
        self.addSubview(fxView)
        
        //        let viewsDictionary = ["view1":self,"view2":fxView]
        //        let view_constraint_H:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:|-[view2]-|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDictionary)
        //        let view_constraint_V:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("V:|-[view2]-|", options: NSLayoutFormatOptions.AlignAllLeading, metrics: nil, views: viewsDictionary)
        //
        //        self.addConstraints(view_constraint_H)
        //        self.addConstraints(view_constraint_V)
        
        self.sendSubviewToBack(fxView)
    }
}

//Applicare blur (solo iOS 8) ad una TextView
extension UITextView {
    
    func blurMyBackground() {
        var blur = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        var fxView = UIVisualEffectView(effect: blur)
        fxView.contentView.backgroundColor = UIColor(white:0.7, alpha:0.3)
        fxView.frame = self.frame
        self.addSubview(fxView)
    }
    
}

extension UIImage {
    
    func fromLandscapeToPortrait(rotate: Bool!) -> UIImage {
        var container : UIImageView = UIImageView(frame: CGRectMake(0, 0, 320, 568))
        container.contentMode = UIViewContentMode.ScaleAspectFill
        container.clipsToBounds = true
        container.image = self
        
        UIGraphicsBeginImageContextWithOptions(container.bounds.size, true, 0);
        container.drawViewHierarchyInRect(container.bounds, afterScreenUpdates: true)
        var normalizedImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        if !rotate {
            return normalizedImage
        } else {
            var rotatedImage = UIImage(CGImage: normalizedImage.CGImage, scale: 1.0, orientation: UIImageOrientation.Left)
            
            UIGraphicsBeginImageContextWithOptions(rotatedImage!.size, true, 1);
            rotatedImage!.drawInRect(CGRectMake(0, 0, rotatedImage!.size.width, rotatedImage!.size.height))
            var normalizedImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            return normalizedImage
        }
    }
}

extension String {
    func isValidEmail() -> Bool {
        let regex = NSRegularExpression(pattern: "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,4}$", options: .CaseInsensitive, error: nil)
        return regex?.firstMatchInString(self, options: nil, range: NSMakeRange(0, countElements(self))) != nil
    }
}
