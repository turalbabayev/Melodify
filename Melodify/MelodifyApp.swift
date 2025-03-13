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

    init() {
        UserDefaults.setupInitialCredits()
        UserService.shared.checkAndUpdateMonthlyCredits()
        
        // Kaydedilmiş dili yükle
        if let languageCode = UserDefaults.standard.string(forKey: "app_language") {
            Bundle.setLanguage(languageCode)
        } else {
            // Varsayılan dil
            Bundle.setLanguage("en")
            UserDefaults.standard.set("en", forKey: "app_language")
        }
    }

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
