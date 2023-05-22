//
//  UserCardView.swift
//  HealthKitTester
//
//  Created by Kevin Bryan on 19/05/23.
//

import SwiftUI

struct UserCardView: View {
  @ObservedObject var userViewController: UserViewController
  @State var rotateIn3D = false

  let user: User?

  init(userViewController: UserViewController) {
    self.userViewController = userViewController
    self.user = userViewController.user
  }

  var body: some View {
    HStack {
      VStack(alignment: .leading) {
        Text("Rank")
          .foregroundColor(.gray)
          .fontWeight(.medium)
        Text("\(user?.rank?.name ?? "Rankless")")
          .foregroundColor(Color(hex: "\(user?.rank?.color ?? "3434D7")"))
          .fontWeight(.bold)
          .font(.system(size: 48))
        Text("Walk \(userViewController.remainingSteps) more steps to rank up!").font(.caption).foregroundColor(.gray)
        Spacer()
      }.padding(.leading, 12).padding(.vertical, 20)

      Spacer()

      VStack(alignment: .trailing) {
        Circle().fill(Color(hex: "3434D7")).frame(width: 40, height: 40)
        Spacer()
        Text("\(user?.name ?? "User Name")").font(.system(size: 18)).foregroundColor(.gray)
        HStack(alignment: .bottom) {
          Text("\(user?.goal ?? 1337)")
            .foregroundColor(Theme.primary).font(.caption).padding(.bottom, -1)
          Text("steps").font(.system(size: 8)).padding(.leading, -7).foregroundColor(Theme.primary)
          Text("/day").font(.system(size: 8)).padding(.leading, -7).foregroundColor(.gray)
        }
      }.padding(.trailing, 12).padding(.vertical, 20)
        .fontWeight(.semibold)
        .backgroundStyle(.thinMaterial)
    }.frame(width: Theme.cardWidth, height: 261).overlay(
      RoundedRectangle(cornerRadius: 8).stroke(.gray.opacity(0.5), lineWidth: 1)
    )

    // MARK: 3D Rotation

    .rotation3DEffect(.degrees(rotateIn3D ? 378 : 0),
                      axis: (x: 0,
                             y: 1,
                             z: 0))
    .scaleEffect(rotateIn3D ? 0.7 : 1)
    .animation(.easeInOut(duration: 2.8)
      .repeatCount(1, autoreverses: true),
      value: rotateIn3D)
    .onTapGesture {
      rotateIn3D.toggle()
    }
  }
}

struct UserCard_Previews: PreviewProvider {
  static var previews: some View {
    ProfileView(userViewController: UserViewController())
  }
}
