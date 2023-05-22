//
//  AchievementBadgeView.swift
//  HealthKitTester
//
//  Created by Kevin Bryan on 20/05/23.
//

import SwiftUI

struct AchievementBadgeView: View {
  let achievement: Achievement

  var body: some View {
    VStack {
      if achievement.earned {
        ZStack {
          Circle()
            .fill(RadialGradient(colors: [.pink, .white], center: .center, startRadius: 0, endRadius: 32))
            .frame(width: 60, height: 60)
          Circle()
            .fill(RadialGradient(colors: [.green, .white], center: .center, startRadius: 0, endRadius: 32))
            .frame(width: 30, height: 30)
        }
      }
      else {
        ZStack {
          Circle().stroke(.gray.opacity(0.6), lineWidth: 1)
            .frame(width: 59, height: 59)
          Circle()
            .fill(.gray.opacity(0.5))
            .frame(width: 60, height: 60)
        }
      }

      Text(achievement.name!)
        .font(.system(size: 8))
        .foregroundColor(achievement.earned ? Color.primary : .gray)
        .fontWeight(.bold)

      Text(
        "\(achievement.earned ? achievement.earnedDate!.formatted(.dateTime.day().month().year()) : " ")").font(.system(size: 6))
        .foregroundColor(achievement.earned ? Color.primary : .gray)
        .fontWeight(.medium)

    }.frame(width: 90, height: 90)
  }
}

struct AchievementBadgeView_Previews: PreviewProvider {
  static var previews: some View {
    ProfileView(userViewController: UserViewController())
  }
}
