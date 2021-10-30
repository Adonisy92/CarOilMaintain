//
//  AppDelegate.swift
//  CarOilMaintain
//
//  Created by YOUNG SEN-MING on 2017/6/12.
//  Copyright © 2017年 YOUNG SEN-MING. All rights reserved.
//

import UIKit
import SwiftyDropbox

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool
    {

        
        let colorNormal : UIColor = UIColor.gray
        let colorSelected : UIColor = UIColor.blue
        let titleFontAll : UIFont = UIFont(name: "American Typewriter", size: 12.0)!
        
        let attributesNormal = [
            NSAttributedString.Key.foregroundColor : colorNormal,
            NSAttributedString.Key.font : titleFontAll
        ]
        
        let attributesSelected = [
            NSAttributedString.Key.foregroundColor : colorSelected,
            NSAttributedString.Key.font : titleFontAll
        ]
        
        UITabBarItem.appearance().setTitleTextAttributes(attributesNormal, for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes(attributesSelected, for: .selected)
        
        
        //設定 tabBar 背景為棕色
        //UITabBar.appearance().barTintColor = UIColor(red: 153/255, green: 102/255, blue: 51/255, alpha: 1.0)
        

        
        UITabBar.appearance().barTintColor = UIColor.white
        
        UITabBar.appearance().tintColor = UIColor.blue

        

        DropboxClientsManager.setupWithAppKey("jhm343g7oimwu7r")

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool
    {
        
        
        let oauthCompletion: DropboxOAuthCompletion = {
             if let authResult = $0 {
                 switch authResult {
                 case .success:
                     print("Success! User is logged into DropboxClientsManager.")
                 case .cancel:
                     print("Authorization flow was manually canceled by user!")
                 case .error(_, let description):
                     print("Error: \(String(describing: description))")
                 }
             }
           }
           let canHandleUrl = DropboxClientsManager.handleRedirectURL(url, completion: oauthCompletion)
           return canHandleUrl
        
        
        
    }
    


}

