//
//  ContentView.swift
//  HealthKitTester
//
//  Created by Kevin Bryan on 18/05/23.
//

import SwiftUI

struct ContentView: View {
  var healthKitManager = HealthKitManager()
  var coreDataManager = CoreDataManager.shared

  var body: some View {
    TabView {
      ActivityView().onAppear(perform: {
        healthKitManager.requestAuthorization()
      }).tabItem {
        Label("Steps", systemImage: "figure.walk.circle.fill")
      }
      ProfileView().tabItem {
        Label("Profile", systemImage: "person.crop.circle.fill")
      }
    }.accentColor(Theme.primary)
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
