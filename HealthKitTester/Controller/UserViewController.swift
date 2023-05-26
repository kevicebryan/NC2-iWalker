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

  static let shared = UserViewController()

  let coreDataManager = CoreDataManager.shared
  let userCoreDataManager = UserCoreDataManager()
  let rankCoreDataManager = RankCoreDataManager()

  @Published var user: User? = nil
  @Published var remainingSteps: Int = 0
  let userDefault = UserDefaults.standard

  func createNewUser(name: String, goal: Int) {
    CoreDataManager.shared.freshRestart()
    userCoreDataManager.createUser(name: name, goal: goal)

    userDefault.set(0, forKey: "recordedDate")
    userDefault.set(false, forKey: "weekUpdated")
    userDefault.synchronize()

    print("Successfully added new user!")
    refetchUserData()
  }

  func updateStatsToCoreData() {
    print("\n***********************************************")

    let today = dateToInteger(date: Date())
    let recordedDate = userDefault.integer(forKey: "recordedDate")

    print("today: \(today)")
    print("recordedDate: \(recordedDate)")

    var lastRecordedSteps = 0

    // MARK: update Lifetime Steps

    if today != recordedDate {
      // FETCH recordedDate steps

      if recordedDate == 0 {
        userDefault.set(today, forKey: "recordedDate")
        return
      }

      lastRecordedSteps = HealthKitManager.shared.stepCountYesterday

      print("LAST RECORDED STEPS: \(lastRecordedSteps)")



      // MARK: update Daily Completions

      if lastRecordedSteps >= user?.goal ?? 10_000 {
        user?.completions += 1
        print("COMPLEITONS +1 = \(user?.completions ?? 0)")
      }
      
      // Push to Core Data
      appendUserSteps(steps: lastRecordedSteps)

      coreDataManager.save()

      // Update recoredDate in UserDefault
      userDefault.set(today, forKey: "recordedDate")
      userDefault.synchronize()
//      print("set recordedDate to \(today)")
//      print("LIFETIME STEPS: \(user?.steps ?? 0)")
      refetchUserData()
    }

    // MARK: update Weekly Challenge Completed

    let todaysWeekDay = Calendar.current.component(.weekday, from: Date())
    let weekUpdated = userDefault.bool(forKey: "weekUpdated")

    // if today is Sunday
    if todaysWeekDay == 1 && weekUpdated {
      userDefault.set(false, forKey: "weekUpdated")
    }

    // if today is Saturday
    if todaysWeekDay == 7 && !weekUpdated {
      // Check apakah di Week ini semua daily udh mencapai Goal, kalau udh maka kita increment user's week Completed

      let isWeekCompleted = checkIfWeekCompleted()

      if isWeekCompleted {
        user?.weekCompleted += 1
        coreDataManager.save()
        refetchUserData()

        print("USER's Weekly Challenge Completions:  to \(user?.weekCompleted ?? 0)")
      }

      // set weekUpdate ke true
      userDefault.set(true, forKey: "weekUpdated")
    }

    print("***********************************************\n")
  }

  func refetchUserData() {
    user = userCoreDataManager.getUser()
    calcRemainingStepsToRankUp()
  }

  func getUserStepCount() -> Int {
    return Int(user?.steps ?? 0)
  }

  func getUserGoal() -> Int {
    return Int(user?.goal ?? 0)
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
    if stepGoal < 5_000 {
      print("invalid step goal!")
      return false
    }
    print("VALID step goal!")
    return true
  }

  private func checkIfWeekCompleted() -> Bool {
    let thisWeeksDatas = ActivityViewController.shared.weeklyCardDatas
    for dailyData in thisWeeksDatas {
      if !dailyData.isCompleted {
        // kalo ada 1 tanggal yg g complete maka return false
        return false
      }
    }
    return true
  }

  private func appendUserSteps(steps: Int) {
    user?.steps += Int32(steps)

    checkUserRankUp()
    AchievementsViewController().checkUserAchievements()

    coreDataManager.save()
    refetchUserData()
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
}
