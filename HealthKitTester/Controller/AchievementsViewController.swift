//
//  AchievementsViewController.swift
//  HealthKitTester
//
//  Created by Kevin Bryan on 20/05/23.
//

import CoreData
import Foundation
import HealthKit
import SwiftUI

class AchievementsViewController: ObservableObject {
  let achievementCoreDataManager = AchievementCoreDataManager()

  @Published var achievements: [Achievement]

  init() {
    achievements = achievementCoreDataManager.getAllAchievements()
      .sorted {
        $0.order < $1.order
      }
  }

  func earnedAchievements() -> Int {
    return achievements.filter { $0.earned == true }.count
  }

  func checkUserAchievements() {
    let user = UserViewController().user

    if user != nil {
      // TODO: Add the IFs for requirement to achieve the user's goal
      if user!.steps >= Int32(100_000) {
        AchievementCoreDataManager().earnAchievement(achievementName: "100k Walker")
      }
      if user!.steps >= Int32(1_000_000) {
        AchievementCoreDataManager().earnAchievement(achievementName: "Olympiade")
      }
      if user!.weekCompleted >= Int32(32) {
        AchievementCoreDataManager().earnAchievement(achievementName: "Consistency")
      }
      if user!.weekCompleted >= Int32(1) {
        AchievementCoreDataManager().earnAchievement(achievementName: "Weekly Flash")
      }
      if user!.completions >= Int32(1) {
        AchievementCoreDataManager().earnAchievement(achievementName: "A Fresh Start")
      }
      if user!.completions >= Int32(10) {
        AchievementCoreDataManager().earnAchievement(achievementName: "A Great Start")
      }
    }
  }
}
