//
//  LoadOverlay.swift
//  RentABuddy
//
//  Created by Luis Fernandez on 6/9/16.
//  Copyright © 2016 Luis Fernandez. All rights reserved.
//

import UIKit

enum LoadingOverlayType {
    case entireWindow
    case hasNavigationBar
}

class LoadOverlay: NSObject{
    
    var overlayView: UIView?
    var activityIndicator: UIActivityIndicatorView?
    
    class var shared: LoadOverlay {
        struct Static {
            static let instance: LoadOverlay = LoadOverlay()
        }
        return Static.instance
    }
    
    class func showOverlayOver(forView v: UIView){
        
        var overlayView: UIView?
        var activityIndicator: UIActivityIndicatorView?
        
        overlayView = UIView(frame: v.frame)
        overlayView!.backgroundColor = UIColor.blackColor()
        overlayView!.alpha = 0.55
        
        activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0,0, 100, 100))
        activityIndicator!.center = overlayView!.center
        activityIndicator!.hidesWhenStopped = true
        activityIndicator!.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
        overlayView!.addSubview(activityIndicator!)
        activityIndicator!.startAnimating()
        
        v.addSubview(overlayView!)
        
        let this: String = LoadOverlay().getOverlay()
        
        print(this)
        
    }
    
    private func getOverlay() -> String {
        return ""
    }
    
    func showOverlayOverAppWindow() {
        let currentScreenBounds = UIScreen.mainScreen().bounds
        
        overlayView = UIView(frame: currentScreenBounds)
        overlayView!.backgroundColor = UIColor.blackColor()
        overlayView!.alpha = 0.55
        
        activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0,0, 100, 100))
        activityIndicator!.center = overlayView!.center
        activityIndicator!.hidesWhenStopped = true
        activityIndicator!.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
        overlayView!.addSubview(activityIndicator!)
        activityIndicator!.startAnimating()
        
        UIApplication.sharedApplication().keyWindow?.addSubview(overlayView!)
    }
    
    func endOverlay() {
        activityIndicator?.stopAnimating()
        overlayView?.removeFromSuperview()
    }
}
