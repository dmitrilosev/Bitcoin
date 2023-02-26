//
//  AppDelegate.swift
//  Bitcoin
//
//  Created by Dmitri Losev on 24.02.2023.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window : UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
       
        self.window = UIWindow()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let initialViewController = storyboard.instantiateInitialViewController()
          
        self.window?.rootViewController = initialViewController
        self.window?.makeKeyAndVisible()
                                
        return true
    }
}
