//
//  AppDelegate.swift
//  iOSArchitecturePatterns
//
//  Created by Juan Pablo on 25/11/2020.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        //TODO: to test
        let request = PopularMoviesRequest()
        request.performRequest {
            request.performResponse { response in
                print(response.results?.count ?? 0 > 0 ? "success" : "error")
            }
        }
        
        return true
    }
}

