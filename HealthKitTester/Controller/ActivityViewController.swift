//
//  ActivityViewController.swift
//  iWalker
//
//  Created by Kevin Bryan on 21/05/23.
//

import Foundation
import SwiftUI

class ActivityViewController: ObservableObject {
  static let shared = ActivityViewController()

  @Published var stepPercentage: Double = 0.0
  @Published var progressWidth: CGFloat = 0.0

  init() {
    updateStepPercentage(
      steps: HealthKitManager.shared.stepCountToday,
      goal: UserViewController.shared.getUserGoal())

    updateProgressWidth()
    updateWeeklyCardDatas()
  }

  let motivationQuotes = ["Let's Start Walking!",
                          "Halway There!",
                          "Almost There!",
                          "Great Job!"]

  @Published var weeklyCardDatas = [
    WeeklyCardData(dayLabel: "SUN", isCompleted: false, isDayPassed: false, isToday: false, steps: 0, weekDay: 1),
    WeeklyCardData(dayLabel: "MON", isCompleted: true, isDayPassed: true, isToday: false, steps: 0, weekDay: 2),
    WeeklyCardData(dayLabel: "TUE", isCompleted: false, isDayPassed: true, isToday: false, steps: 0, weekDay: 3),
    WeeklyCardData(dayLabel: "WED", isCompleted: false, isDayPassed: true, isToday: false, steps: 0, weekDay: 4),
    WeeklyCardData(dayLabel: "THU", isCompleted: false, isDayPassed: true, isToday: false, steps: 0, weekDay: 5),
    WeeklyCardData(dayLabel: "FRI", isCompleted: false, isDayPassed: true, isToday: false, steps: 0, weekDay: 6),
    WeeklyCardData(dayLabel: "SAT", isCompleted: false, isDayPassed: false, isToday: true, steps: 0, weekDay: 7),
  ]

  func updateProgressWidth() {
    let barWidth = CGFloat(240)
    progressWidth = CGFloat(stepPercentage * barWidth)
  }

  func updateStepPercentage(steps: Int, goal: Int) {
//    print("==> Steps: \(steps)")
    if steps > 0 {
      stepPercentage = Double(Double(steps) / Double(goal))
    } else {
      stepPercentage = Double(0.0)
    }

    if stepPercentage >= 1.0 {
      stepPercentage = 1.0
    }
//    print("==> ACV Steps%: \(stepPercentage)")
  }

  func updateWeeklyCardDatas() {
    let goal = UserViewController.shared.getUserGoal()
    let thisWeekSteps = HealthKitManager.shared.thisWeekSteps

    let now = Date()
    let calendar = Calendar.current
    let today = calendar.component(.weekday, from: now)

//    print("()()()()() ATTEMPTING TO UPDATE WEEKLY CARD DATA")

    for (day, steps) in thisWeekSteps {
      let idx = day - 1
      weeklyCardDatas[idx].steps = steps
//      print(">> DAY [\(idx)] steps: \(weeklyCardDatas[idx].steps)")

      // check if goal completed
      if steps >= goal {
        weeklyCardDatas[idx].isCompleted = true
      } else {
        weeklyCardDatas[idx].isCompleted = false
      }

      // check if day is today
      if weeklyCardDatas[idx].weekDay == today {
        weeklyCardDatas[idx].isToday = true
      } else {
        weeklyCardDatas[idx].isToday = false
      }
      // check if day is passed or upcoming
      if weeklyCardDatas[idx].weekDay <= today {
        weeklyCardDatas[idx].isDayPassed = true
      } else {
        weeklyCardDatas[idx].isDayPassed = false
      }
//      print("THIS WEEK's DATA for \(weeklyCardDatas[idx].dayLabel):")
//      print("\(weeklyCardDatas[idx])")
    }
  }

  func getProgressQuote() -> String {
    if stepPercentage >= 1.0 {
      return motivationQuotes[3]
    }
    if stepPercentage >= 0.75 {
      return motivationQuotes[2]
    }
    if stepPercentage >= 0.50 {
      return motivationQuotes[1]
    }
    return motivationQuotes[0]
  }
}
