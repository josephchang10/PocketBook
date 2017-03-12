//
//  AppDelegate.swift
//  PocketBook
//
//  Created by 张嘉夫 on 2017/3/4.
//  Copyright © 2017年 张嘉夫. All rights reserved.
//

import UIKit
import RealmSwift

let initialDataVersion = 1

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let config = Realm.Configuration(
            // Set the new schema version. This must be greater than the previously used
            // version (if you've never set a schema version before, the version is 0).
            schemaVersion: 2,
            
            // Set the block which will be called automatically when opening a Realm with
            // a schema version lower than the one set above
            migrationBlock: { migration, oldSchemaVersion in
                // We haven’t migrated anything yet, so oldSchemaVersion == 0
                if (oldSchemaVersion < 1) {
                    // Nothing to do!
                    // Realm will automatically detect new properties and removed properties
                    // And will update the schema on disk automatically
                }
        })
        
        // Tell Realm to use this new configuration object for the default Realm
        Realm.Configuration.defaultConfiguration = config
        
        let serverURL = URL(string: "http://123.206.230.33:9080")!
        let cloudKitCredentials = SyncCredentials.cloudKit(token: "39fa626f1f20b0da16ea2b4a1a4e1fbe4a5e18bd97010cc7885c7033acf294b5")
        SyncUser.logIn(with: cloudKitCredentials,
                       server: serverURL) { user, error in
                        if let user = user {
                            // can now open a synchronized Realm with this user
                            print(user)
                        } else if let error = error {
                            // handle error
                            print(error)
                        }
        }
        
        if UserDefaults.standard.integer(forKey: "InitialDataVersion") != initialDataVersion {
            //import initial data, and set the user defaults
            let realm = try! Realm()
            let categorys = ["食物","杂货","化妆","健康","衣服","交通","娱乐","App"]
            for content in categorys {
                let category = Category()
                category.content = content
                try! realm.write {
                    realm.add(category)
                    print("category \(content) is imported")
                }
            }
            UserDefaults.standard.set(initialDataVersion, forKey: "InitialDataVersion")
        }
        
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
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DidBecomeActive"), object: nil)
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

