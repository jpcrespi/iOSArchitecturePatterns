//
//  AppDelegate.swift
//  iOSArchitectureVIPER
//
//  Created by Juan Pablo on 25/11/2020.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow()
        window?.rootViewController = HomeRouter.createModule()
        window?.makeKeyAndVisible()
        
        return true
    }
}

