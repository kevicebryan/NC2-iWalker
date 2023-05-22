//
//  UserCoreDataManager.swift
//  HealthKitTester
//
//  Created by Kevin Bryan on 19/05/23.
//

import CoreData
import Foundation

class UserCoreDataManager {
  let coreDataManager = CoreDataManager.shared
  let viewContext = CoreDataManager.shared.viewContext

  func createUser(name: String, goal: Int) {
    guard let userEntity = NSEntityDescription.entity(forEntityName: "User", in: viewContext) else {
      return
    }
    let user = User(entity: userEntity, insertInto: viewContext)
    user.name = name
    user.goal = Int32(goal)
    user.steps = Int32(0)
    user.weekCompleted = Int32(0)
    setUserRank(user: user, rankName: "Rookie")
    coreDataManager.save()
  }

  func setUserRank(user: User, rankName: String) {
    let request: NSFetchRequest<Rank>
    request = Rank.fetchRequest()
    request.predicate = NSPredicate(format: "name LIKE %@", rankName)
    var rank: Rank
    do {
      rank = try viewContext.fetch(request).first!
      user.rank = rank
      coreDataManager.save()
      print("success update user rank to \(rank.name ?? " ")!")
    } catch {
      print("failed to fetch rank: \(rankName)")
      return
    }
  }

  func getAllUser() -> [User] {
    let request: NSFetchRequest<User> = User.fetchRequest()
    do {
      return try coreDataManager.viewContext.fetch(request)
    } catch {
      print("failed to fetch users")
    }
    return []
  }

  func getUser() -> User? {
    let request: NSFetchRequest<User> = User.fetchRequest()
    var user: User
    do {
      try user = coreDataManager.viewContext.fetch(request).first!
      return user
    } catch {
      print("failed to fetch user")
    }
    return nil
  }
}
