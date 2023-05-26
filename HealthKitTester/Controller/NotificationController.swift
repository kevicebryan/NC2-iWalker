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
      if hour == 6 {
        content.title = "Get your morning walk started"
        content.subtitle = "Morning walks are a good way to get your dayt started!"
      }
      if hour == 10 {
        content.title = "Get your daily steps up"
        content.subtitle = "You got this, we believe you can reach your daily step goal ."

      }
      if hour == 14 {
        content.title = "Afternoon walk time"
        content.subtitle = "Go out there and get your steps up!"

      }
      if hour == 18 {
        content.title = "Time for a night walk"
        content.subtitle = "There is no wrong with completing your daily step goal at night."

      }

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
