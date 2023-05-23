//
//  ContentView.swift
//  HealthKitTester
//
//  Created by Kevin Bryan on 18/05/23.
//

import SwiftUI
import UserNotifications

struct ContentView: View {
  @ObservedObject var healthKitManager: HealthKitManager
  @ObservedObject var userViewController: UserViewController

  @StateObject var coreDataManager = CoreDataManager.shared
  @StateObject var activityViewController = ActivityViewController.shared
  @StateObject var notificationController = NotificationController.shared

  var body: some View {
    TabView {
      ActivityView(
        userViewController: userViewController,
        healthKitManager: healthKitManager,
        activityViewController: activityViewController
      )
      .onAppear {
        healthKitManager.requestAuthorization()
      }
      .tabItem {
        Label("Steps", systemImage: "figure.walk.circle.fill")
      }
      ProfileView(userViewController: userViewController, healthKitManager: healthKitManager)
        .tabItem {
          Label("Profile", systemImage: "person.crop.circle.fill")
        }
    }.accentColor(Theme.primary).onAppear {
      notificationController.askUserPermission()
      UIApplication.shared.applicationIconBadgeNumber = 0
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView(healthKitManager: HealthKitManager.shared, userViewController: UserViewController.shared)
  }
}
