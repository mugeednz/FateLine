//
//  AppDelegate.swift
//  fateline
//
//  Created by Müge Deniz on 6.10.2025.
//

import UIKit
//import FirebaseCore
import IQKeyboardManagerSwift
import FacebookCore
import Purchases
@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        Purchases.configure(withAPIKey: "your_revenuecat_api_key")
//        FirebaseApp.configure()
        IQKeyboardManager.shared.isEnabled = true
        IQKeyboardManager.shared.enableAutoToolbar = false
        IQKeyboardManager.shared.resignOnTouchOutside = true
        // MARK: FacebookSDK Codes - with error handling
        do {
            ApplicationDelegate.shared.application(
                application,
                didFinishLaunchingWithOptions: launchOptions
            )
            print("✅ Facebook SDK initialized successfully")
        } catch {
            print("❌ Facebook SDK initialization failed: \(error)")
        }
        // -----------------
        return true
    }
    
    // MARK: FacebookSDK Codes
    func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey : Any] = [:]
    ) -> Bool {
        do {
            return ApplicationDelegate.shared.application(app, open: url, options: options)
        } catch {
            print("❌ Facebook URL handling failed: \(error)")
            return false
        }
    }
    // -----------------
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

