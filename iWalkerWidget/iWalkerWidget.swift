//
//  iWalkerWidget.swift
//  iWalkerWidget
//
//  Created by Kevin Bryan on 24/05/23.
//

import SwiftUI
import WidgetKit

struct Provider: TimelineProvider {
  func placeholder(in context: Context) -> StepEntry {
    StepEntry(date: Date(), steps: 3007)
  }

  func getSnapshot(in context: Context, completion: @escaping (StepEntry) -> ()) {
    let entry = StepEntry(date: Date(), steps: 3007)
    completion(entry)
  }

  func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
    var entries: [StepEntry] = []

    let sharedDefaults = UserDefaults(suiteName: "group.iWalker")
    let currentStep = sharedDefaults?.integer(forKey: "widgetStep") ?? 0

    // Generate a timeline consisting of five entries an hour apart, starting from the current date.
    let currentDate = Date()
    for hourOffset in 0 ..< 1 {
      let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!

      let entry = StepEntry(date: entryDate, steps: currentStep)

      entries.append(entry)
    }

    let timeline = Timeline(entries: entries, policy: .atEnd)
    completion(timeline)
  }
}

struct StepEntry: TimelineEntry {
  let date: Date
  let steps: Int
}

struct iWalkerWidgetEntryView: View {
  var entry: StepEntry
  var currentStep = UserDefaults(suiteName: "group.iWalker")?.integer(forKey: "widgetStep")

  var body: some View {
    ZStack {
      ContainerRelativeShape()
        .fill(
          LinearGradient(colors: [.primary.opacity(0.8),
                                  .primary,
                                  .primary,
                                  .primary.opacity(0.8)], startPoint: .topLeading, endPoint: .bottom)
        )

      VStack(spacing: 6) {
        Text("Steps Today")
          .font(.caption)
          .fontWeight(.light)
          .colorInvert()
          .opacity(0.8)

        HStack {
          if currentStep ?? 0 > 0 {
            Text("\(currentStep ?? 0)")
              .font(.title)
              .fontWeight(.semibold)
              .colorInvert()
          } else {
            Text("Let's start walking")
              .font(.title)
              .fontWeight(.semibold)
              .colorInvert()
              .multilineTextAlignment(.center)
          }
        }

        Image(systemName: "shoeprints.fill")
          .font(.system(size: 8))
          .colorInvert()
          .opacity(0.8)
      }.rotation3DEffect(Angle(degrees: 8), axis: (x: 1, y: 0, z: 0))

    }.background(.thinMaterial).colorInvert()
  }
}

struct iWalkerWidget: Widget {
  let kind: String = "iWalkerWidget"

  var body: some WidgetConfiguration {
    StaticConfiguration(kind: kind, provider: Provider()) { entry in
      iWalkerWidgetEntryView(entry: entry)
    }
    .configurationDisplayName("iWalker")
    .description("Keep track of your daily step count.")
  }
}

struct iWalkerWidget_Previews: PreviewProvider {
  static var previews: some View {
    iWalkerWidgetEntryView(entry: StepEntry(date: Date(), steps: 10000))
      .previewContext(WidgetPreviewContext(family: .systemSmall))
  }
}
