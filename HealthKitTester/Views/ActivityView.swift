//
//  ActivityView.swift
//  HealthKitTester
//
//  Created by Kevin Bryan on 19/05/23.
//

import SwiftUI

struct ActivityView: View {
  @StateObject var healthKitManager = HealthKitManager()
  @StateObject var userViewController = UserViewController()

  var body: some View {
    VStack {
      Text("\(userViewController.user?.name ?? "Your Name")")
      Text("\(healthKitManager.stepCountToday)")
    }
  }
}

struct ActivityView_Previews: PreviewProvider {
  static var previews: some View {
    ActivityView()
  }
}
