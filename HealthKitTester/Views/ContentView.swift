//
//  ContentView.swift
//  HealthKitTester
//
//  Created by Kevin Bryan on 18/05/23.
//

import SwiftUI

struct ContentView: View {
  @StateObject var coreDataManager = CoreDataManager.shared
  @ObservedObject var healthKitManager: HealthKitManager
  @StateObject var userViewController = UserViewController()
  @StateObject var activityViewController = ActivityViewController()

  var body: some View {
    TabView {
      ActivityView(
        userViewController: userViewController,
        healthKitManager: healthKitManager,
        activityViewController: activityViewController)
        .onAppear {
          healthKitManager.requestAuthorization()
        }
        .tabItem {
          Label("Steps", systemImage: "figure.walk.circle.fill")
        }
      ProfileView(userViewController: userViewController)
        .tabItem {
          Label("Profile", systemImage: "person.crop.circle.fill")
        }
    }.accentColor(Theme.primary)
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView(healthKitManager: HealthKitManager())
  }
}
