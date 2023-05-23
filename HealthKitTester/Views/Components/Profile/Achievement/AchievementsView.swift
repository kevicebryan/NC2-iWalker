//
//  AchievementsView.swift
//  HealthKitTester
//
//  Created by Kevin Bryan on 20/05/23.
//

import SwiftUI

struct AchievementsView: View {
  let achievements: [Achievement]

  @State var gridItemLayout = [
    GridItem(.flexible()), GridItem(.flexible()),
    GridItem(.flexible())
  ]

  @State var isShowingDetail = false
  @State var animatingModal = false
  @State var currentIdx = 0

  var body: some View {
    ZStack {
      LazyVGrid(columns: gridItemLayout, spacing: 16) {
        ForEach(achievements.indices, id: \.self) {
          idx in
          Button {
            currentIdx = idx
            if isShowingDetail {
              // to close the previous other achievement if other achievement is showing
              isShowingDetail = false
            }
            isShowingDetail.toggle()
          } label: {
            AchievementBadgeView(achievement: achievements[idx])
          }
        }.opacity(isShowingDetail ? 0.5 : 1)
          .animation(.easeIn(duration: 0.5), value: isShowingDetail)
      }

      if isShowingDetail {
        VStack {
          HStack {
            Button {
              animatingModal.toggle()
              isShowingDetail.toggle()
            } label: {
              Image(systemName: "xmark")
                .foregroundColor(.gray)
                .font(.body)
                .frame(width: 30, height: 30)
            }
            Spacer()
          }.padding(.top, 12).padding(.horizontal, 12)
          AchievementBadgeView(achievement: achievements[currentIdx])
            .scaleEffect(1.5)
            .padding()
            .padding(.top, -8)
          Text(achievements[currentIdx].caption ?? " ")
            .multilineTextAlignment(.center)
            .font(.caption).italic()
            .padding(.top, -4).padding(.bottom, 8)
            .padding(.horizontal, 20)
            .foregroundColor(.gray.opacity(0.5))
        }
        .background(.ultraThinMaterial)
        .cornerRadius(12)
        .padding(20)
        .padding(.top, -112)
        .frame(width: 250)
        .zIndex(10)
        .scaleEffect(animatingModal ? 1 : 0)
        .rotation3DEffect(.degrees(animatingModal ? 0 : 360), axis: (x: 0, y: 1, z: 0))
        .animation(.easeInOut(duration: 1), value: animatingModal)
        .onAppear {
          animatingModal.toggle()
        }
      }
    }.padding(.horizontal, 12).onAppear {
      isShowingDetail = false
    }
  }
}

struct AchievementsView_Previews: PreviewProvider {
  static var previews: some View {
    ProfileView(userViewController: UserViewController.shared, healthKitManager: HealthKitManager.shared)
  }
}
