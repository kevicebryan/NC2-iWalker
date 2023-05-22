//
//  AchievementController.swift
//  HealthKitTester
//
//  Created by Kevin Bryan on 19/05/23.
//

import CoreData
import Foundation

class AchievementCoreDataManager {
  let coreDataManager = CoreDataManager.shared
  let viewContext = CoreDataManager.shared.viewContext

  func earnAchievement(achievementName: String) {
    let request: NSFetchRequest<Achievement>
    request = Achievement.fetchRequest()
    request.predicate = NSPredicate(format: "name LIKE %@", achievementName)

    var achievement: Achievement

    do {
      achievement = try viewContext.fetch(request).first!

      if !achievement.earned {
        achievement.earned = true
        achievement.earnedDate = Date()
        coreDataManager.save()
        print("success update achievement!")
      } else {
        print("Achievement: \(achievementName) have been earned before")
      }
    } catch {
      print("failed to fetch achievement: \(achievementName)")
      return
    }
  }

  func getAllAchievements() -> [Achievement] {
    let request: NSFetchRequest<Achievement> = Achievement.fetchRequest()
    do {
      return try coreDataManager.viewContext.fetch(request)
    } catch {
      print("failed to get all achievements")
    }
    return []
  }

  func seedAchievements() {
    guard let achievmentEntity = NSEntityDescription.entity(forEntityName: "Achievement", in: viewContext) else {
      return
    }
    let ach0 = Achievement(entity: achievmentEntity, insertInto: viewContext)
    ach0.name = "The Beginning"
    ach0.order = Int32(0)
    ach0.caption = "There are plenty more to come!"
    ach0.earned = true
    ach0.earnedDate = Date()

    let ach1 = Achievement(entity: achievmentEntity, insertInto: viewContext)
    ach1.name = "A Fresh Start"
    ach1.order = Int32(1)
    ach1.caption = "Nice job on completing your first daily challenge!"
    ach1.earned = false

    let ach2 = Achievement(entity: achievmentEntity, insertInto: viewContext)
    ach2.name = "A Great Start"
    ach2.order = Int32(2)
    ach2.caption = "This is your start towards a better and healthy lifestyle."
    ach2.earned = false

    let ach3 = Achievement(entity: achievmentEntity, insertInto: viewContext)
    ach3.name = "Weekly Flash"
    ach3.order = Int32(3)
    ach3.caption = "You have completed the weekly challenge!"
    ach3.earned = false

    let ach4 = Achievement(entity: achievmentEntity, insertInto: viewContext)
    ach4.name = "100k Walker"
    ach4.order = Int32(4)
    ach4.caption = "You have surpassed 100,000 steps."
    ach4.earned = false

    let ach5 = Achievement(entity: achievmentEntity, insertInto: viewContext)
    ach5.name = "Consisteny"
    ach5.order = Int32(5)
    ach5.caption = "You have completed 10 weekly challenges, thats nuts!"
    ach5.earned = false

    let ach6 = Achievement(entity: achievmentEntity, insertInto: viewContext)
    ach6.name = "Olympiade"
    ach6.order = Int32(6)
    ach6.caption = "Walked over 1,000,000 steps."
    ach6.earned = false

    coreDataManager.save()
  }
}
