//
//  HealthKitManager.swift
//  HealthKitTester
//
//  Created by Kevin Bryan on 18/05/23.
//

import Foundation
import HealthKit

class HealthKitManager: ObservableObject {
  var healthStore = HKHealthStore()
  var stepCountToday: Int = 0

  init() {
    requestAuthorization()
  }

  func requestAuthorization() {
    let toReads = Set([
      HKObjectType.quantityType(forIdentifier: .stepCount)!,
      HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
      HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!
    ])
    guard HKHealthStore.isHealthDataAvailable() else {
      print("health data not available!")
      return
    }
    healthStore.requestAuthorization(toShare: nil, read: toReads) {
      success, error in
      if success {
        self.readStepCountToday()
      } else {
        print("\(String(describing: error))")
      }
    }
  }

  func readStepCountToday() {
    guard let stepCountType = HKQuantityType.quantityType(forIdentifier: .stepCount) else {
      return
    }
    let now = Date()
    let startDate = Calendar.current.startOfDay(for: now)
    let predicate = HKQuery.predicateForSamples(withStart: startDate, end: now, options: .strictStartDate)

    let query = HKStatisticsQuery(quantityType: stepCountType, quantitySamplePredicate: predicate, options: .cumulativeSum) {
      _, result, error in
      guard let result = result, let sum = result.sumQuantity() else {
        print("failed to read step count: \(error?.localizedDescription ?? "UNKNOWN ERROR")")
        return
      }

      let steps = Int(sum.doubleValue(for: HKUnit.count()))
      DispatchQueue.main.async {
        print("your steps today: \(steps)")
        self.stepCountToday = steps
      }
    }
    healthStore.execute(query)
  }
}
