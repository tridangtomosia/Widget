import SwiftUI
import WidgetKit


extension DateFormatter {
    static var month: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        return formatter
    }

    static var monthAndYear: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }

    static var year: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        return formatter
    }
}

extension Calendar {
    func generateDates(
        inside interval: DateInterval,
        matching components: DateComponents
    ) -> [Date] {
        var dates: [Date] = []
        dates.append(interval.start)

        enumerateDates(
            startingAfter: interval.start,
            matching: components,
            matchingPolicy: .nextTime
        ) { date, _, stop in
            if let date = date {
                if date < interval.end {
                    dates.append(date)
                } else {
                    stop = true
                }
            }
        }

        return dates
    }
}

struct CalendarMonthView: View {
    @Environment(\.calendar) var calendar
    @Binding var currentDate: Date
    @Binding var colorCalendar: Color
    @State var isPresentPickerColorView: Bool = false
    var colorBattery: Color = .green
    private var year: DateInterval {
        calendar.dateInterval(of: .year, for: Date())!
    }

    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button {
                    isPresentPickerColorView.toggle()
                } label: {
                    Text(Image(systemName: "pencil").renderingMode(.original)).font(.system(size: 25)) + Text("Setting Color").font(.system(size: 20))
                }
                .overlay(RoundedRectangle(cornerRadius: 3).stroke(Color.blue, lineWidth: 2))
                Spacer()
                    .frame(width: 20)
            }
            CalendarView(interval: year, color: colorCalendar, content: { date in
                Text("30")
                    .hidden()
                    .overlay(
                        Text(String(self.calendar.component(.day, from: date))).font(.system(size: 10))
                    )

            }, currentDate: $currentDate)
                .background(Color("NavigationBarColor"))
        }
        .sheet(isPresented: $isPresentPickerColorView) {
            PickerColorView(isDismis: $isPresentPickerColorView, color: colorCalendar, colorCalendar: $colorCalendar) {
                WidgetGroup.save(WidgetShared(name: "", desCription: "", colorCalendar: TypeColor.convertTo(color: colorCalendar), colorBattery: TypeColor.convertTo(color: colorBattery)))
            }
        }
    }
}

struct WeekView<DateView>: View where DateView: View {
    @Environment(\.calendar) var calendar

    let week: Date
    let content: (Date) -> DateView
    let size: CGSize
    let color: Color

    init(week: Date, size: CGSize, color: Color, @ViewBuilder content: @escaping (Date) -> DateView) {
        self.week = week
        self.content = content
        self.size = size
        self.color = color
    }

    private var days: [Date] {
        guard
            let weekInterval = calendar.dateInterval(of: .weekOfYear, for: week)
        else { return [] }
        return calendar.generateDates(
            inside: weekInterval,
            matching: DateComponents(hour: 0, minute: 0, second: 0)
        )
    }

    func dateInWeekened(date: Date) -> Bool {
        var bool = false
        if Calendar.current.isDateInWeekend(date) {
            bool = true
        }
        return bool
    }

    var body: some View {
        HStack(spacing: 0.0) {
            ForEach(days, id: \.self) { date in
                HStack(alignment: .top, spacing: 0.0) {
                    VStack(alignment: .trailing, spacing: 0.0) {
                        if self.calendar.isDate(self.week, equalTo: date, toGranularity: .month) {
                            HStack {
                                Spacer()
                                self.content(date)
                                    .foregroundColor(checkingCurrentDay(date: date) ? .red : dateInWeekened(date: date) == true ? .secondary : .primary)
                            }
                            .background(checkingCurrentDay(date: date) ? Color.white: color)

                        } else {
                            HStack {
                                Spacer()
                                self.content(date)
                                    .hidden()
                            }
                            .background(Color.clear)
                        }
                        Spacer()
                    }
                }
                .frame(width: size.width / 7, height: size.height / 7)
//                .background(dateInWeekened(date: date) == true ? Color.gray : Color(.systemBackground))
            }
        }
    }
}

struct MonthView<DateView>: View where DateView: View {
    @Environment(\.calendar) var calendar

    let month: Date
    let showHeader: Bool
    let content: (Date) -> DateView
    let size: CGSize
    let color: Color

    init(
        month: Date,
        showHeader: Bool = true,
        size: CGSize = CGSize(width: 180, height: 120),
        color: Color = .green,
        @ViewBuilder content: @escaping (Date) -> DateView
    ) {
        self.month = month
        self.content = content
        self.showHeader = showHeader
        self.size = size
        self.color = color
    }

    private var weeks: [Date] {
        guard
            let monthInterval = calendar.dateInterval(of: .month, for: month)
        else { return [] }
        return calendar.generateDates(
            inside: monthInterval,
            matching: DateComponents(hour: 0, minute: 0, second: 0, weekday: calendar.firstWeekday)
        )
    }

    private var header: some View {
        let formatter = DateFormatter.month
        return
            HStack { Text(formatter.string(from: month))
                    .font(.title)
                    .padding()
                    Spacer()
                }.padding(.leading)
    }

    var body: some View {
        VStack(spacing: 0.0) {
            if showHeader {
                let component = calendar.component(.month, from: month)
                if component == 1 {
                    Text(DateFormatter.year.string(from: Date()))
                        .font(.largeTitle)
                }
                header
            }
            ForEach(weeks, id: \.self) { week in
                WeekView(week: week, size: size, color: color, content: self.content)
            }
        }
    }
}

struct CalendarView<DateView>: View where DateView: View {
    @Environment(\.calendar) var calendar
    let interval: DateInterval
    let color: Color
    let content: (Date) -> DateView

    @Binding var curentDate: Date
    @State var position = 0

    init(interval: DateInterval,
         color: Color = .green,
         @ViewBuilder content: @escaping (Date) -> DateView, currentDate: Binding<Date>) {
        self.interval = interval
        self.color = color
        self.content = content
        _curentDate = currentDate
    }

    private var months: [Date] {
        calendar.generateDates(
            inside: interval,
            matching: DateComponents(day: 1, hour: 0, minute: 0, second: 0)
        )
    }

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack(spacing: 0.0) {
                ForEach(months, id: \.self) { month in
                    MonthView(month: month,
                              showHeader: true,
                              size: CGSize(width: UIScreen.main.bounds.width - 120, height: 200),
                              color: color, content: self.content)
                        .onAppear {
                            let formatter = DateFormatter.month
                            print("Current Month is \(formatter.string(from: month))")
                        }
                        .padding()
                }
            }
            .padding()
        }
    }
}

struct PickerColorView: View {
    @Binding var isDismis: Bool
    @State var color: Color
    @Binding var colorCalendar: Color
    var completed: (()->())?
    var colors: [Color] = [.red, .blue, .gray, .orange, .green]

    var body: some View {
        VStack {
            HStack {
                Button {
                    isDismis = false
                    colorCalendar = color
                    completed?()
                } label: {
                    Text("Done")
                }
                .padding(.all, 10)
                Spacer()
                Button {
                    isDismis = false
                } label: {
                    Text("Cancel")
                }
                .padding(.all, 10)
            }
            Spacer()
            VStack(alignment: HorizontalAlignment.leading) {
                Picker(selection: $color, label: Text("Setting Color")) {
                    ForEach(colors, id: \.self) { i in
                        HStack {
                            i.frame(width: 150, height: 30)
                            Spacer()
                            Text("\(i.description)")
                            Spacer()
                        }
                    }
                }
                .frame(width: 200, height: 30)
            }
            Spacer()
        }
    }
}



func checkingCurrentDay(date: Date) -> Bool {
    return Calendar.current.component(.month, from: date) == Calendar.current.component(.month, from: Date()) && Calendar.current.component(.day, from: Date()) == Calendar.current.component(.day, from: date)
}

enum WeakDay: String {
    static func name(day: Int) -> String {
        switch day {
        case 1:
            return SunDay.rawValue
        case 2:
            return Monday.rawValue
        case 3:
            return TuesDay.rawValue
        case 4:
            return Wednesday.rawValue
        case 5:
            return ThusDay.rawValue
        case 6:
            return FriDay.rawValue
        case 7:
            return SatuDay.rawValue
        default:
            return ""
        }
    }

    case SunDay
    case Monday
    case TuesDay
    case Wednesday
    case ThusDay
    case FriDay
    case SatuDay
}
