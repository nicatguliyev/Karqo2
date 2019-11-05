//
//  AppDelegate.swift
//  Kargo
//
//  Created by Nicat Guliyev on 7/2/19.
//  Copyright © 2019 Nicat Guliyev. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import OneSignal


class Global {
    var user: LoginDataModel?
    var isExit: Bool?
    var isNotf: Bool?
    var notfsenderId: Int?
}


var vars = Global()

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
   
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.keyboardDistanceFromTextField = 0
        UIView.appearance().isExclusiveTouch = true
        
        let handleNotification: OSHandleNotificationReceivedBlock = { notification in
        }
        
        let actionBlocak: OSHandleNotificationActionBlock = { result in
            
            let payload: OSNotificationPayload = result!.notification.payload
            let additionalData = payload.additionalData
            vars.notfsenderId = (additionalData!["sender_id"] as! Int)
            vars.isNotf = true
            
            self.window = UIWindow(frame: UIScreen.main.bounds)
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            var initialViewController = UIViewController()
            
            
            initialViewController = storyboard.instantiateViewController(withIdentifier: "SplashVC")
        
            if(UserDefaults.standard.string(forKey: "USERROLE") == "4"){
                self.window?.rootViewController = initialViewController
                           self.window?.makeKeyAndVisible()
            }
           
         }
        
        let onesignalInitSettings = [kOSSettingsKeyAutoPrompt: false, kOSSettingsKeyInAppLaunchURL: true]
        
        OneSignal.initWithLaunchOptions(launchOptions,
                                        appId: "62545622-542a-4615-ad03-489cf22a5b7a",
                                        handleNotificationReceived: handleNotification,
                                        handleNotificationAction: actionBlocak,
                                        settings: onesignalInitSettings)
        
        OneSignal.inFocusDisplayType = OSNotificationDisplayType.notification;
        
        OneSignal.promptForPushNotifications(userResponse: { accepted in
            print("User accepted notifications: \(accepted)")
        })
        
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


}

