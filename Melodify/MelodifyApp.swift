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
    @State private var showPaywall = false
    
    private let userService = UserService.shared

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
            LaunchScreen()
                .sheet(isPresented: $showPaywall) {
                    PaywallView()
                }
                .onAppear {
                    // LaunchScreen kapandıktan sonra Paywall'ı göster
                    NotificationCenter.default.addObserver(
                        forName: .launchScreenDidFinish,
                        object: nil,
                        queue: .main
                    ) { _ in
                        if userService.currentUser?.subscription == .free {
                            showPaywall = true
                        }
                    }
                }
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
