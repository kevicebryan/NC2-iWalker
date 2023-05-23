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
//    ach0.colorA = "7EE8FA"
//    ach0.colorB = "EEC0C6"
//    ach0.colorC = "E0D2C7"
//    ach0.colorD = "44B09E"

    let ach1 = Achievement(entity: achievmentEntity, insertInto: viewContext)
    ach1.name = "A Fresh Start"
    ach1.order = Int32(1)
    ach1.caption = "Nice job on completing your first daily challenge!"
    ach1.earned = false
//    ach1.colorA = "DEE4EA"
//    ach1.colorB = "F9FCFF"
//    ach1.colorC = "8693AB"
//    ach1.colorD = "BDD4E7"

    let ach2 = Achievement(entity: achievmentEntity, insertInto: viewContext)
    ach2.name = "A Great Start"
    ach2.order = Int32(2)
    ach2.caption = "This is your start towards a better and healthy lifestyle."
    ach2.earned = false
//    ach2.colorA = "FF928B"
//    ach2.colorB = "FFAC81"
//    ach2.colorC = "FF7878"
//    ach2.colorD = "FFFFFF"

    let ach3 = Achievement(entity: achievmentEntity, insertInto: viewContext)
    ach3.name = "Weekly Flash"
    ach3.order = Int32(3)
    ach3.caption = "You have completed the weekly challenge!"
    ach3.earned = false
//    ach3.colorA = "FBB034"
//    ach3.colorB = "FFDD00"
//    ach3.colorC = "A71D31"
//    ach3.colorD = "3F0D12"

    let ach4 = Achievement(entity: achievmentEntity, insertInto: viewContext)
    ach4.name = "100k Walker"
    ach4.order = Int32(4)
    ach4.caption = "You have surpassed 100,000 steps."
    ach4.earned = false
//    ach4.colorA = "0D324D"
//    ach4.colorB = "7F5A83"
//    ach4.colorC = "28313B"
//    ach4.colorD = "485461"

    let ach5 = Achievement(entity: achievmentEntity, insertInto: viewContext)
    ach5.name = "Consisteny"
    ach5.order = Int32(5)
    ach5.caption = "You have completed 10 weekly challenges, thats nuts!"
    ach5.earned = false
//    ach5.colorA = "A88BEB"
//    ach5.colorB = "F8CEEC"
//    ach5.colorC = "5899E2"
//    ach5.colorD = "FFFFFF"

    let ach6 = Achievement(entity: achievmentEntity, insertInto: viewContext)
    ach6.name = "Olympiade"
    ach6.order = Int32(6)
    ach6.caption = "Walked over 1,000,000 steps."
    ach6.earned = false
//    ach6.colorA = "FBD72B"
//    ach6.colorB = "F9484A"
//    ach6.colorC = "233329"
//    ach6.colorD = "63D471"

    coreDataManager.save()
  }
}
