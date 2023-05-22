//
//  UserViewController.swift
//  HealthKitTester
//
//  Created by Kevin Bryan on 20/05/23.
//

import CoreData
import Foundation
import HealthKit
import SwiftUI

class UserViewController: ObservableObject {
  init() {
    if userExist() {
      user = userCoreDataManager.getUser() ?? nil
      calcRemainingStepsToRankUp()
    }
  }

  let coreDataManager = CoreDataManager.shared
  let userCoreDataManager = UserCoreDataManager()
  let rankCoreDataManager = RankCoreDataManager()

  @Published var user: User? = nil
  @Published var remainingSteps: Int = 0

  func refetchUserData() {
    user = userCoreDataManager.getUser()
  }

  func getUserStepCount() -> Int {
    return Int(user?.steps ?? 0)
  }

  func getUserGoal() -> Int {
    return Int(user?.goal ?? 0)
  }

  func createNewUser(name: String, goal: Int) {
    CoreDataManager.shared.freshRestart()
    userCoreDataManager.createUser(name: name, goal: goal)
    print("Successfully added new user!")
  }

  // TODO: this function will run daily at 23.59 and add the steps to user steps in coreData
  func appendUserSteps(steps: Int) {
    user?.steps += Int32(steps)

    checkUserRankUp()
    AchievementsViewController().checkUserAchievements()

    coreDataManager.save()
    refetchUserData()
  }

  // TODO: this function runs Sunday 23:59, see if user completed the weekly challenge
  func updateCompletedWeeks() {
    var isCompleteWeek = false

    if isCompleteWeek {
      user!.weekCompleted += Int32(1)
      coreDataManager.save()
      remainingSteps = remainingSteps - 1
    }
  }

  private func calcRemainingStepsToRankUp() {
    if user!.steps < 100_000 {
      remainingSteps = Int(100_000 - user!.steps)
    }

    if user!.steps >= 100_000 && user!.steps < 1_000_000 {
      remainingSteps = Int(1_000_000 - user!.steps)
    }

    if user!.steps >= 1_000_000 && user!.steps < 10_000_000 {
      remainingSteps = Int(10_000_000 - user!.steps)
    }

    if user!.steps >= 10_000_000 {
      remainingSteps = 0
    }
  }

  private func checkUserRankUp() {
    let ranks = rankCoreDataManager.getAllRanks()

    if ranks.count != 0 {
      if user!.steps >= 100_000 && user!.steps < 1_000_000 {
        let rankFiltered = ranks.filter { $0.name == "Swifty" }
        user?.rank = rankFiltered.first
      }

      if user!.steps >= 1_000_000 && user!.steps < 10_000_000 {
        let rankFiltered = ranks.filter { $0.name == "The Flash" }
        user?.rank = rankFiltered.first
      }

      if user!.steps >= 10_000_000 {
        let rankFiltered = ranks.filter { $0.name == "God Walker" }
        user?.rank = rankFiltered.first
      }
      coreDataManager.save()
      refetchUserData()
    }
  }

  func updateStepGoal(stepGoal: Int) {
    user?.goal = Int32(stepGoal)
    coreDataManager.save()
    refetchUserData()
  }

  func userExist() -> Bool {
    let users = userCoreDataManager.getAllUser()
    if users.count == 0 {
      return false
    }
    return true
  }

  func validateName(name: String) -> Bool {
    if name.count < 1 { return false }
    return true
  }

  func validateStepGoal(stepGoal: Int) -> Bool {
    print("validating step goal...")
    if stepGoal < 1_000 {
      print("invalid step goal!")
      return false
    }
    print("VALID step goal!")
    return true
  }
}
