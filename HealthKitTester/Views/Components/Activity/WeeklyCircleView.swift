//
//  WeeklyCircleView.swift
//  iWalker
//
//  Created by Kevin Bryan on 21/05/23.
//

import SwiftUI

struct WeeklyCircleView: View {
  @ObservedObject var userViewController: UserViewController
  let weeklyCardData: WeeklyCardData

  @State var progress = 0.0

  var body: some View {
    VStack {
      // MARK: TODAY

      if weeklyCardData.isToday {
        Text(weeklyCardData.dayLabel)
          .foregroundColor(.primary)

        ZStack {
          Circle().stroke(Theme.primary.opacity(0.4), lineWidth: 5)
            .frame(width: 25, height: 25)

          Circle()
            .trim(from: 0, to: progress)
            .stroke(
              progress == 1.0
                ? .green : Theme.primary,
              style: StrokeStyle(
                lineWidth: 5,
                lineCap: .round))
            .frame(width: 25, height: 25)

        }.frame(width: 30, height: 30)
          .onAppear {
            if weeklyCardData.steps > 0 {
              progress = Double(
                Double(weeklyCardData.steps) /
                  Double(userViewController.user?.goal ?? 10_000))
            }

            if progress >= 1.0 {
              progress = 1.0
            }
          }

        Text("\(weeklyCardData.steps)")
          .foregroundColor(.primary)

      } else {
        // MARK: NOT TODAY

        Text(weeklyCardData.dayLabel)
          .foregroundColor(.gray)

        // MARK: DAY AHEAD

        if !weeklyCardData.isDayPassed {
          Circle().frame(width: 30, height: 30)
            .foregroundColor(.gray.opacity(0.5))
        } else {
          // MARK: DAY PASSED

          Circle().frame(width: 30, height: 30)
            .foregroundColor(weeklyCardData.isCompleted ? .green : .secondary)
        }

        Text("\(weeklyCardData.steps)")
          .foregroundColor(.gray)
      }
    }.frame(width: 48).fontWeight(.medium).font(.caption)
  }
}

struct WeeklyCircleView_Previews: PreviewProvider {
  static var previews: some View {
    WeeklyCircleView(userViewController: UserViewController(),
                     weeklyCardData: WeeklyCardData(dayLabel: "MON", isCompleted: false, isDayPassed: false, isToday: true, steps: 7_000, weekDay: 1))
  }
}
