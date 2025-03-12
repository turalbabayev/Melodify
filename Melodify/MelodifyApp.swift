//
//  MelodifyApp.swift
//  Melodify
//
//  Created by Tural Babayev on 20.02.2025.
//

import SwiftUI

@main
struct MelodifyApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            //MainView()
            LaunchScreen()
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        // Core Data'yı başlat
        _ = CoreDataManager.shared
        return true
    }
}
