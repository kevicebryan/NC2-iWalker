//
//  WeeklyChallengeCard.swift
//  iWalker
//
//  Created by Kevin Bryan on 21/05/23.
//

import SwiftUI

struct WeeklyChallengeCard: View {
  @ObservedObject var userViewController: UserViewController
  @ObservedObject var healthKitManager: HealthKitManager
  @ObservedObject var activityViewController: ActivityViewController

  var body: some View {
    VStack(alignment: .leading, spacing: 12) {
      HStack {
        Text("Keep your body fit by completing your step goal daily")
          .font(.caption).foregroundColor(.gray)
      }.padding(.leading, 20)

      HStack(spacing: 2) {
        ForEach(0 ..< activityViewController.weeklyCardDatas.count) {
          idx in WeeklyCircleView(userViewController: userViewController, weeklyCardData: activityViewController.weeklyCardDatas[idx])
        }
      }.padding(.horizontal, 12)

      HStack {
        Spacer()
        VStack(alignment: .trailing) {
          Text("You have completed \(userViewController.user?.weekCompleted ?? -1) weekly challenges")
        }.font(.caption2).foregroundColor(.gray)
      }.frame(width: Theme.cardWidth - 12)

    }.padding(8).padding(.horizontal, 12)
      .frame(width: Theme.cardWidth)
      .overlay(
        RoundedRectangle(cornerRadius: 8).stroke(.gray.opacity(0.5), lineWidth: 1)
      )
  }
}

struct WeeklyChallengeCard_Previews: PreviewProvider {
  static var previews: some View {
    WeeklyChallengeCard(
      userViewController: UserViewController(),
      healthKitManager: HealthKitManager(), activityViewController: ActivityViewController()
    )
  }
}
