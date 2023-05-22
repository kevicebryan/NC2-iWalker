//
//  OnboardingView.swift
//  HealthKitTester
//
//  Created by Kevin Bryan on 20/05/23.
//

import SwiftUI

struct OnboardingView: View {
  @StateObject var userViewController = UserViewController()
  @StateObject var healthKitManager = HealthKitManager()
  @State var name: String = ""
  @State var stepGoal: Int = 10000

  var body: some View {
    NavigationView {
      VStack {
        // Title
        Text("Welcome to").font(.body)
        Text("iWalker").font(.largeTitle)
        // Logo
        LinearGradient(colors: [Theme.primary, Theme.secondary], startPoint: .topTrailing, endPoint: .bottomLeading).mask {
          Image(systemName: "figure.walk").font(.system(size: 200))
        }.frame(width: 200, height: 240)

        // Input Name
        HStack {
          Text("Name").font(.body)
          Spacer()
        }.frame(width: 300).padding(.top, 20)

        TextField("Your Name", text: $name).frame(width: 300).textFieldStyle(.roundedBorder)

        // Input Step Goal
        HStack(alignment: .bottom) {
          Text("Daily Step Goal")
            .font(.body)
          Spacer()
          Text("Recommended: 10,000")
            .font(.caption2)
            .foregroundColor(Theme.primary)
            .fontWeight(.light)
        }.frame(width: 300).padding(.top, 12)

        TextField("10,000 steps",
                  value: $stepGoal,
                  format: .number)
          .frame(width: 300).textFieldStyle(.roundedBorder).keyboardType(.numberPad)
          .padding(.bottom, 32)

        // Next Button

        if userViewController.validateName(name: name) && userViewController.validateStepGoal(stepGoal: stepGoal) {
          NavigationLink(destination: ContentView(healthKitManager: healthKitManager)) {
            VStack {
              Text("Start Walking")
                .padding(.vertical, 10)
                .padding(.horizontal, 20)
                .foregroundColor(.white)
            }.background(Theme.primary).cornerRadius(12)
          }.simultaneousGesture(TapGesture().onEnded { _ in
            userViewController.createNewUser(name: name, goal: stepGoal)
          })

        } else {
          VStack {
            Text("Start Walking")
              .padding(.vertical, 10)
              .padding(.horizontal, 20)
              .foregroundColor(.white.opacity(0.8))
          }.background(Color.gray.opacity(0.5)).cornerRadius(12)
        }
      }
    }
  }
}

struct OnboardingView_Previews: PreviewProvider {
  static var previews: some View {
    OnboardingView()
  }
}
