//
//  NotificationController.swift
//  iWalker
//
//  Created by Kevin Bryan on 23/05/23.
//

import Foundation
import UserNotifications

class NotificationController: ObservableObject {
  static let shared = NotificationController()

  init() {
    askUserPermission()
    sendReminderNotification(hour: 6)
    sendReminderNotification(hour: 10)
    sendReminderNotification(hour: 14)
    sendReminderNotification(hour: 18)
  }

  func askUserPermission() {
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) {
      success, error in
      if success {
//        print("Notification all set!")
      } else {
        if let error = error {
          print("\(error.localizedDescription)")
        }
      }
    }
  }

  func sendReminderNotification(hour: Int) {
    let content = UNMutableNotificationContent()

    let stepPercentage = ActivityViewController.shared.stepPercentage

    if stepPercentage < 1 {
      content.title = "Keep on Walking"
      content.subtitle = "\(Int(ActivityViewController.shared.stepPercentage * 100.0))% towards reaching your goal!"
      content.sound = UNNotificationSound.default

      var datComp = DateComponents()
      datComp.hour = hour
      datComp.minute = 0

      let trigger = UNCalendarNotificationTrigger(dateMatching: datComp, repeats: true)
      let request = UNNotificationRequest(identifier: "\(hour)_NOTIF_ID", content: content, trigger: trigger)
      UNUserNotificationCenter.current().add(request) {
        error in
        if let error = error {
          print("\(error.localizedDescription)")
        } else {
//          print("------------------> success set reminder for every { \(hour) } daily")
        }
      }

    } else {}
  }
}
