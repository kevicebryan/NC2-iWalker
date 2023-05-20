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

class AchievementsViewConteroller: ObservableObject {
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
}
