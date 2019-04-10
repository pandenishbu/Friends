//
//  AppDelegate.swift
//  Friends
//
//  Created by Mary Milchenko on 11.02.2019.
//  Copyright © 2019 Pandenishbu. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
   // let log = Log()

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

       // log.AppDLogger(from: "not running", to: "foreground")

        var theme = UIColor.white
        let themeData = UserDefaults.standard.object(forKey: "Theme") as? Data ?? nil
        if themeData != nil {
            do {
                if let color = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(themeData!) as? UIColor {
                    theme = color
                }
            } catch {
                print("Couldn't read file.")
            }
        }

        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().barTintColor = theme

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Use this method to pause ongoing tasks, disable timers, and invalidate
        //graphics rendering callbacks. Games should use this method to pause the game.
        //log.AppDLogger(from: "active state", to: "inactive in foreground")
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // If your application supports background execution, this method is called
        //instead of applicationWillTerminate: when the user quits.

        //log.AppDLogger(from: "inactive state in foreground", to: "background")
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state;
        //here you can undo many of the changes made on entering the background.
        //log.AppDLogger(from: "background", to: "inactive state in foreground")
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the
        //application was inactive. If the application was previously in the
        //background, optionally refresh the user interface.

        //log.AppDLogger(from: "inactive state", to: "active")
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate.
        //Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        //log.AppDLogger(from: "suspended", to: "not running")
    }

    // MARK: - Core Data stack
}
