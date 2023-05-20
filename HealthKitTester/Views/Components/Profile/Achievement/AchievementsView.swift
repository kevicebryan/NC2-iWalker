//
//  AchievementsView.swift
//  HealthKitTester
//
//  Created by Kevin Bryan on 20/05/23.
//

import SwiftUI

struct AchievementsView: View {
  let achievements: [Achievement]

  @State var gridItemLayout = [
    GridItem(.flexible()), GridItem(.flexible()),
    GridItem(.flexible())
  ]

  var body: some View {
    LazyVGrid(columns: gridItemLayout, spacing: 16) {
      ForEach(achievements.indices, id: \.self) {
        idx in
        AchievementBadgeView(achievement: achievements[idx])
      }
    }.padding(.horizontal, 12)
  }
}

struct AchievementsView_Previews: PreviewProvider {
  static var previews: some View {
    ProfileView()
  }
}
