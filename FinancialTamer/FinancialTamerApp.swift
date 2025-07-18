//
//  FinancialTamerApp.swift
//  FinancialTamer
//
//  Created by Артем Табенский on 08.06.2025.
//

import SwiftUI

@main
struct FinancialTamerApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            MainTabView()
        }
    }
}

// В App и AppDelegate
extension Notification.Name {
    static let dataLoaded = Notification.Name("dataLoaded")
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        Task {
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: .dataLoaded, object: nil)
            }
        }
        return true
    }
}
