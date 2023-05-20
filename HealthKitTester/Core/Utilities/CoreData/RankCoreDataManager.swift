//
//  RankCoreDataManager.swift
//  HealthKitTester
//
//  Created by Kevin Bryan on 19/05/23.
//

import CoreData
import Foundation

class RankCoreDataManager {
  let coreDataManager = CoreDataManager.shared
  let viewContext = CoreDataManager.shared.viewContext

  func getAllRanks() -> [Rank] {
    let request: NSFetchRequest<Rank> = Rank.fetchRequest()
    do {
      return try coreDataManager.viewContext.fetch(request)
    } catch { print("failed to get all Ranks") }
    return []
  }

  func seedRanks() {
    guard let seedEntity = NSEntityDescription.entity(forEntityName: "Rank", in: viewContext) else {
      return
    }
    let rank1 = Rank(entity: seedEntity, insertInto: viewContext)
    rank1.name = "Rookie"
    rank1.color = "3434D7"

    let rank2 = Rank(entity: seedEntity, insertInto: viewContext)
    rank2.name = "Swifty"
    rank2.color = "887C31"

    let rank3 = Rank(entity: seedEntity, insertInto: viewContext)
    rank3.name = "The Flash"
    rank3.color = "A51818"

    let rank4 = Rank(entity: seedEntity, insertInto: viewContext)
    rank4.name = "God Walker"
    rank4.color = "D4AF37"

    coreDataManager.save()
  }
}
