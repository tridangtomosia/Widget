//
//  WidgetDemo.swift
//  WidgetDemo
//
//  Created by Tri Dang on 24/05/2021.
//

import Intents
import SwiftUI
import WidgetKit

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), relevance: nil, dataEntry: DataEntry(dataShared: WidgetGroup.get()))
    }

    func getTypleWidget(for configuration: ConfigurationIntent) -> TypeShow {
        switch configuration.TypeWidget {
        case .battery:
            return TypeShow(rawValue: 1)!
        case .date:
            return TypeShow(rawValue: 2)!
        default:
            return TypeShow(rawValue: 2)!
        }
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        let entry = SimpleEntry(date: Date(), relevance: nil, dataEntry: DataEntry(dataShared: WidgetGroup.get()))
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
//        var entries: [SimpleEntry] = []
//
//        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
//        let currentDate = Date()
//        let relevance = TimelineEntryRelevance(score: Float(DataEntry(dataShared: WidgetGroup.get()).battery))
//        for minuteOfSet in 0 ..< 60 {
//            let entryDate = Calendar.current.date(byAdding: .minute,
//                                                  value: minuteOfSet,
//                                                  to: currentDate)!
//            let entry = SimpleEntry(date: entryDate,
//                                    relevance: relevance,
//                                    dataEntry: DataEntry(typeWidget: getTypleWidget(for: configuration),
//                                                         dataShared: WidgetGroup.get())
//            )
//            entries.append(entry)
//        }
//
//        let timeline = Timeline(entries: entries, policy: .after(<#T##date: Date##Date#>))
//        completion(timeline)
        let relevance = TimelineEntryRelevance(score: Float(DataEntry(dataShared: WidgetGroup.get()).battery))
        let midnight = Calendar.current.startOfDay(for: Date())
        let nextMidnight = Calendar.current.date(byAdding: .second, value: 30, to: midnight)!
        let entries = [SimpleEntry(date: nextMidnight, relevance: relevance,
                                   dataEntry: DataEntry(typeWidget: getTypleWidget(for: configuration),
                                                        dataShared: WidgetGroup.get()))]
        let timeline = Timeline(entries: entries, policy: .after(nextMidnight))

        completion(timeline)
    }
}

struct DataEntry {
    let battery: Float = {
        UIDevice.current.isBatteryMonitoringEnabled = true
        let batteryLvl = UIDevice.current.batteryLevel
        return batteryLvl
    }()

    var memory: Memory = Memory()
    var typeWidget: TypeShow = .battery

    var dataShared: WidgetShared
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let relevance: TimelineEntryRelevance?
    let dataEntry: DataEntry
}

struct ColorView: View {
    @State var colorIndex: Int
    var body: some View {
        switch colorIndex {
        case 1:
            Color.green
        case 2:
            Color.blue
        case 3:
            Color.yellow
        case 4:
            Color.red
        default:
            Color.yellow
        }
    }
}

struct WidgetDemoEntryView: View {
    @Environment(\.widgetFamily) var family: WidgetFamily
    var entry: Provider.Entry

    @ViewBuilder
    var body: some View {
        switch family {
        case .systemSmall: WidgetDemoEntrySmallView(entry: entry)
        case .systemMedium: WidgetDemoEntryMediumView(entry: entry)
        case .systemLarge: WidgetDemoEntryLargeView(entry: entry)
        default: EmptyView()
        }
    }
}

struct WidgetDemoEntrySmallView: View {
    var entry: Provider.Entry
    let date = Date()
    var isShow = false
    var text = ""
    init(entry: Provider.Entry) {
        self.entry = entry
        text = "day là text"
        WidgetCenter.shared.reloadAllTimelines()
//        checkingBattery()
    }

    var body: some View {
        Group {
            VStack(alignment: .center) {
                if entry.dataEntry.typeWidget == .memory {
                    let time = Calendar.current.startOfDay(for: entry.date)
//                    Text(WeakDay.name(day: Calendar.current.component(.weekday, from: Date())))
//                        .foregroundColor(entry.dataEntry.dataShared.colorCalendar.revert())
//                    Text(entry.date, style: .date)
                    Text(time, style: .timer)
                        .frame(width: 74, height: 20)
                    Text(getSecondTime(date: entry.dataEntry.memory.a))
                    if isShow {
                        Text("Text da dc goi sau khi vao background")
                    }
                    Text(text)
                } else {
                    BatteryView(battery: entry.dataEntry.battery * 100, color: entry.dataEntry.dataShared.colorBattery.revert())
                    Text("Battery: ") + Text("\(Int(entry.dataEntry.battery * 100))%").font(.system(size: 20))
                }
            }
        }
        .padding()
    }

    func getSecondTime(date: Date) -> String {
        let h = Calendar.current.component(.hour, from: date)
        let m = Calendar.current.component(.minute, from: date)
        let s = Calendar.current.component(.second, from: date)
        return "\(h): \(m): \(s)"
    }
    
//    func checkingBattery() {
//        if Calendar.current.component(.minute, from: date) != Calendar.current.component(.minute, from: entry.date) {
////            if UIDevice.current.batteryLevel != entry.dataEntry.battery {
//            isShow = true
////                WidgetCenter.shared.reloadAllTimelines()
////            }
//        } else if Calendar.current.component(.hour, from: date) != Calendar.current.component(.hour, from: entry.date) {
////            if UIDevice.current.batteryLevel != entry.dataEntry.battery {
////                WidgetCenter.shared.reloadAllTimelines()
////            }
//        }
//    }

    let battery: Float = {
        UIDevice.current.isBatteryMonitoringEnabled = true
        let batteryLvl = UIDevice.current.batteryLevel
        return batteryLvl
    }()
}

struct WidgetDemoEntryMediumView: View {
    @Environment(\.calendar) var calendar
    var entry: Provider.Entry

    var body: some View {
        VStack {
            if entry.dataEntry.typeWidget == .battery {
                Text("memoryFree:\(entry.dataEntry.memory.freeDiskSpaceInBytes) MB")
                Text("memoryTotal:\(entry.dataEntry.memory.totalDiskSpaceInBytes) MB")
                Text("memoryUsed:\(entry.dataEntry.memory.usedDiskSpaceInBytes) MB")
            } else {
                HStack {
                    VStack {
                        let time = Calendar.current.startOfDay(for: entry.date)
                        Text(DateFormatter.month.string(from: Date()))
                            .foregroundColor(entry.dataEntry.dataShared.colorCalendar.revert())
                            .font(.system(size: 14))
                        Text(WeakDay.name(day: Calendar.current.component(.weekday, from: Date())))
                            .foregroundColor(entry.dataEntry.dataShared.colorCalendar.revert())
//                        Text(entry.date, style: .date)
                        Text(time, style: .timer)
                            .frame(width: 74, height: 20)
                    }
                    .frame(width: 100, height: 100)
                    .overlay(Circle()
                        .stroke(entry.dataEntry.dataShared.colorCalendar.revert(), lineWidth: 2)
                    )
                    Rectangle().frame(width: 1, height: 200, alignment: .center)
                    Spacer().frame(width: 10)
                    VStack {
                        MonthView(month: Date(),
                                  showHeader: false,
                                  color: entry.dataEntry.dataShared.colorCalendar.revert(),
                                  content: { date in
                                      Text("30")
                                          .hidden()
                                          .overlay(
                                              Text(String(self.calendar.component(.day, from: date)))
                                                  .font(.system(size: 10)))

                                  })
                    }
                }
                .edgesIgnoringSafeArea(.all)
            }
        }
//        .background(ColorView(colorIndex: entry.dataEntry.typeWidget.rawValue))
    }

    func getSecondTime(date: Date) -> String {
        let h = Calendar.current.component(.hour, from: date)

        let m = Calendar.current.component(.minute, from: date)

        let s = Calendar.current.component(.second, from: date)
        return "\(h): \(m): \(s)"
    }

    static let battery: Float = {
        UIDevice.current.isBatteryMonitoringEnabled = true
        let batteryLvl = UIDevice.current.batteryLevel
        return batteryLvl
    }()
}

struct WidgetDemoEntryLargeView: View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            Text(entry.date, style: .date)
            Text(entry.date, style: .time)

            Text("\(Int(Self.battery * 100))")
                .font(.largeTitle)
        }
        .background(ColorView(colorIndex: getindex()))
    }

    func getindex() -> Int {
        return Int(arc4random() % 5)
    }

    static let battery: Float = {
        UIDevice.current.isBatteryMonitoringEnabled = true
        let batteryLvl = UIDevice.current.batteryLevel
        return batteryLvl
    }()
}

@main
struct WidgetDemo: Widget {
    let kind: String = "WidgetDemo"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind,
                            intent: ConfigurationIntent.self,
                            provider: Provider()) { entry in
            WidgetDemoEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
        .supportedFamilies([.systemMedium, .systemSmall, .systemLarge])
    }
}

struct WidgetDemo1: Widget {
    let kind: String = "WidgetDemo1"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind,
                            intent: ConfigurationIntent.self,
                            provider: Provider()) { entry in
            WidgetDemoEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget 1")
        .description("This is an example widget. 1")
        .supportedFamilies([.systemMedium, .systemSmall, .systemLarge])
    }
}


struct widgetBuilder: WidgetBundle {
    @WidgetBundleBuilder
    var body: some Widget {
        WidgetDemo()
        WidgetDemo1()
    }
}

struct WidgetDemo_Previews: PreviewProvider {
    static var previews: some View {
        WidgetDemoEntryView(entry: SimpleEntry(date: Date(), relevance: nil,
                                               dataEntry: DataEntry(memory: Memory(),
                                                                    dataShared: WidgetGroup.get())))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
