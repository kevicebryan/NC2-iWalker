//
//  HealthKitTesterApp.swift
//  HealthKitTester
//
//  Created by Kevin Bryan on 18/05/23.
//

import SwiftUI

@main
struct HealthKitTesterApp: App {
  @StateObject var coreDataManager = CoreDataManager.shared
  @StateObject var userViewController = UserViewController()

  var body: some Scene {
    WindowGroup {
      if userViewController.userExist() {
        ContentView()

        // MARK: if you need to reboot the app (delete everything and re-seed)

//          .onAppear {
//            coreDataManager.freshRestart()
//          }

      } else {
        OnboardingView().onAppear {
          coreDataManager.freshRestart()
        }
      }
    }
  }
}
