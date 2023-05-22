//
//  DailyStepCardView.swift
//  HealthKitTester
//
//  Created by Kevin Bryan on 21/05/23.
//

import SwiftUI

struct DailyStepCardView: View {
  let barWidth = CGFloat(240)

  @ObservedObject var userViewController: UserViewController
  @ObservedObject var healthKitManager: HealthKitManager
  @ObservedObject var activityViewController: ActivityViewController

//  @State var stepPercentage: Double = 0.0
//  @State var progressWidth: CGFloat

  init(userViewController: UserViewController, healthKitManager: HealthKitManager, activityViewController: ActivityViewController) {
    self.userViewController = userViewController
    self.healthKitManager = healthKitManager
    self.activityViewController = activityViewController
//    self.progressWidth = CGFloat(activityViewController.stepPercentage * barWidth)
  }

  var body: some View {
    VStack {
      // MARK: STEPS TODAY

      Text("Steps today").fontWeight(.medium).foregroundColor(.gray)
      VStack {
        HStack(alignment: .bottom, spacing: 0) {
          Text("\(healthKitManager.stepCountToday)").font(.system(size: 72, weight: .bold)).padding(.leading, 20)
          Image(systemName: "shoeprints.fill").padding(.bottom, 14).padding(.leading, -2)
        }.padding(.bottom, -16)
        HStack(spacing: 0) {
          Text("out of")
          Text(" \(userViewController.user?.goal ?? 10000)")
        }.foregroundColor(.gray).fontWeight(.medium).multilineTextAlignment(.trailing)
          .padding(.leading, 140)
      }

      // MARK: PROGRESS BAR + CALORIE

      ZStack {
        // Background
        RoundedRectangle(cornerRadius: 8)
          .fill(Color(hex: "F6F6F6"))
          .frame(width: barWidth)
        HStack {
          // Progress
          RoundedRectangle(cornerRadius: 8)
            .fill(
              LinearGradient(colors: [Theme.secondary, Theme.primary], startPoint: .bottomLeading, endPoint: .topTrailing)
            )
            .frame(width: CGFloat(activityViewController.progressWidth))
            .foregroundColor(.pink)
            .animation(.spring(), value: activityViewController.progressWidth)

          if !(activityViewController.progressWidth == barWidth) {
            Spacer()
          }
        }
        // Calorie // TODO: Fix Calorie Value
        HStack(alignment: .bottom, spacing: 0) {
          Text("\(healthKitManager.caloriesBurnedToday)")
            .padding(.leading, 12)
            .foregroundColor(
              .black.opacity(0.6)
            )
          Text("kCal").font(.caption2)
          Spacer()
        }.foregroundColor(
          .black.opacity(0.6)
        )
        .fontWeight(.semibold)

      }.frame(width: barWidth, height: 36)
        .onAppear {
          // MARK: Calculate from step to percentage to width

          activityViewController.updateProgressWidth()
        }

      // MARK: PROGRESS DESCRIPTION

      VStack {
        HStack {
          Text(activityViewController.getProgressQuote())
            .foregroundColor(.gray)
            .font(.caption).italic().fontWeight(.light)
          Spacer()
          Text("\(Int(activityViewController.stepPercentage * 100.0))%")
            .foregroundColor(Theme.primary)
            .fontWeight(.bold)
            .font(.title3)
            .onAppear {
              print("----> Step Percentage: \(activityViewController.stepPercentage)")
            }
        }
        HStack {
          Spacer()
          Text("towards completing your goal").font(.caption2).foregroundColor(.gray)
        }
      }.frame(width: barWidth)

    }.frame(width: Theme.cardWidth, height: 360)
      .overlay(
        RoundedRectangle(cornerRadius: 8).stroke(.gray.opacity(0.5), lineWidth: 1)
      )
  }
}

struct DailyStepCardView_Previews: PreviewProvider {
  static var previews: some View {
    DailyStepCardView(userViewController: UserViewController(), healthKitManager: HealthKitManager(), activityViewController: ActivityViewController())
  }
}
