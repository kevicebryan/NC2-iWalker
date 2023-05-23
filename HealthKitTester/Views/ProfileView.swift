//
//  ProfileView.swift
//  HealthKitTester
//
//  Created by Kevin Bryan on 19/05/23.
//

import SwiftUI

struct ProfileView: View {
  @StateObject var achievementViewController = AchievementsViewController()
  @ObservedObject var userViewController: UserViewController
  @ObservedObject var healthKitManager: HealthKitManager

  @State var isEditing = false
  @State var stepGoal: Int = 0
//  @State var validStepGoal = false

  var body: some View {
    VStack {
      // Profile Card
      HStack {
        Text("Profile").font(.title2).fontWeight(.semibold)
        Spacer()
      }.padding(.horizontal).padding(.top, 12).padding(.bottom, 2)

      UserCardView(userViewController: userViewController, healthKitManager: healthKitManager)
      ScrollView(showsIndicators: false) {
        VStack {
          // Edit Step Goal
          HStack(alignment: .bottom) {
            VStack(alignment: .leading) {
              Text("Daily Step Goal")
                .font(.system(size: 8))
                .fontWeight(.semibold)
                .foregroundColor(.gray)

              if isEditing {
                TextField("Daily Step Goal",
                          value: $stepGoal,
                          format: .number)
                  .keyboardType(.numberPad)
                  .font(.system(size: 40))
                  .fontWeight(.regular)
                  .padding(.top, -2)
                  .foregroundColor(.primary.opacity(0.5))

              } else {
                Text("\(userViewController.user?.goal ?? 0)")
                  .font(.system(size: 40))
                  .fontWeight(.semibold)
                  .padding(.top, -1)
              }
            }.padding(.leading, 12).padding(.vertical, 8)
            Spacer()

            VStack {
              if !isEditing {
                Button {
                  stepGoal = Int(userViewController.user?.goal ?? 0)
                  isEditing.toggle()
                } label: {
                  Text("Edit").padding(.bottom, 2)
                }
              } else {
                if userViewController.validateStepGoal(stepGoal: stepGoal) {
                  // Done button enabled
                  Button {
                    isEditing.toggle()
                    userViewController.updateStepGoal(stepGoal: stepGoal)
                  } label: {
                    Text("Done").padding(.bottom, 2)
                  }
                } else {
                  // Done button disabled
                  Button {} label: {
                    Text("Done").padding(.bottom, 2)
                  }.disabled(true)
                }
              }
            }.padding(.trailing, 12).padding(.vertical, 8).padding(.bottom, 2)
          }
          .overlay(
            RoundedRectangle(cornerRadius: 8).stroke(.gray.opacity(0.5), lineWidth: 1)
          )
          .padding(.horizontal)
          .padding(.vertical, 12)

          // Your Achievements
          HStack {
            VStack(alignment: .leading) {
              Text("Your Achievements").font(.title2).fontWeight(.semibold)
              HStack {
                Text("\(achievementViewController.earnedAchievements())/\(achievementViewController.achievements.count)")
                  .foregroundColor(Theme.primary)
                Text("achievements unlocked").foregroundColor(.gray).padding(.leading, -4)
              }.font(.caption)
            }
            Spacer()
          }.padding(.horizontal)

          AchievementsView(achievements: achievementViewController.achievements)
            .frame(width: .infinity)
            .padding(.horizontal)

          Spacer()
        }
      }
    }.padding(.top, 16)
  }
}

struct ProfileView_Previews: PreviewProvider {
  static var previews: some View {
    ProfileView(userViewController: UserViewController(), healthKitManager: HealthKitManager())
  }
}
