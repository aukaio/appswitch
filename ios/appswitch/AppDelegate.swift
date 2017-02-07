//
//  AppDelegate.swift
//  appswitch
//
//  Created by Joachim Krüger on 20/11/2016.
//  Copyright © 2016 Joachim Krüger. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        let result:AppSwitchResult = url.absoluteString.contains("success") ? .success
                                                                            : .failure

        NotificationCenter.default.post(name: NSNotification.Name(result.rawValue),
                                        object: nil)

        return true
    }

}
