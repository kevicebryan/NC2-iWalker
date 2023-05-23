//
//  HealthKitTesterApp.swift
//  HealthKitTester
//
//  Created by Kevin Bryan on 18/05/23.
//

import Foundation
import SwiftUI
import UIKit

@main
struct HealthKitTesterApp: App {
  @StateObject var coreDataManager = CoreDataManager.shared
  @StateObject var userViewController = UserViewController.shared
  @StateObject var healthKitManager = HealthKitManager.shared

  var body: some Scene {
    WindowGroup {
      if userViewController.userExist() {
        ContentView(healthKitManager: healthKitManager, userViewController: userViewController)
          .onAppear {
            healthKitManager.requestAuthorization()
            userViewController.updateStatsToCoreData()

            // MARK: if you need to reboot the app (delete everything and re-seed)

//            coreDataManager.freshRestart()
          }

      } else {
        OnboardingView(userViewController: userViewController, healthKitManager: healthKitManager)
          .onAppear {
            coreDataManager.freshRestart()
          }
      }
    }
  }
}
