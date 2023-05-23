//
//  ActivityView.swift
//  HealthKitTester
//
//  Created by Kevin Bryan on 19/05/23.
//

import SwiftUI

struct ActivityView: View {
  @ObservedObject var userViewController: UserViewController
  @ObservedObject var healthKitManager: HealthKitManager
  @ObservedObject var activityViewController: ActivityViewController

  var body: some View {
    VStack {
      HStack {
        Text("Hey \(userViewController.user?.name ?? "Your Name")!")
          .font(.system(size: 36))
          .fontWeight(.semibold)
        Spacer()
      }.padding(.horizontal).padding(.top, 12).padding(.bottom, 2)
      ScrollView {
        VStack {
          // MARK: DAILY STEP COUNTER

          DailyStepCardView(userViewController: userViewController, healthKitManager: healthKitManager, activityViewController: activityViewController)
            .onAppear {
//              healthKitManager.fetchAllDatas()
              activityViewController.updateStepPercentage(
                steps: healthKitManager.stepCountToday,
                goal: userViewController.getUserGoal()
              )
              activityViewController.updateProgressWidth()
            }

          // MARK: WEEKLY STEP TRACKER

          HStack {
            Text("Weekly Challenge")
              .font(.title3)
              .fontWeight(.semibold)
            Spacer()
          }.padding(.horizontal).padding(.top, 12).padding(.bottom, 2)

          WeeklyChallengeCard(
            userViewController: userViewController,
            healthKitManager: healthKitManager,
            activityViewController: activityViewController
          )
          .onAppear {
            activityViewController.updateWeeklyCardDatas()
          }

          Spacer()
        }
      }
    }.padding(.top, 16)
  }
}

struct ActivityView_Previews: PreviewProvider {
  static var previews: some View {
    ActivityView(
      userViewController: UserViewController(),
      healthKitManager: HealthKitManager(),
      activityViewController: ActivityViewController()
    )
  }
}
