//
//  ContentView.swift
//  WidgetAppDemo
//
//  Created by Tri Dang on 24/05/2021.
//

import SwiftUI
import WidgetKit

struct ContentView: View {
    @Environment(\.calendar) var calendar
    @State var description: String = ""
    @State var name: String = ""
    @State var isSwich: Bool = true
    @State var date: Date = Date()
    @State var isOpenCalendar: Bool = false
    @State var isOpenBattery: Bool = false
    @State var colorCalendar: Color = .green
    @State var colorBattery: Color = .green

    var body: some View {
        NavigationView {
            VStack {
                Button(action: {
                    isOpenCalendar.toggle()
                }, label: {
                    Text("Setting Calendar 1")
                })
                
                Button(action: {
                    isOpenBattery.toggle()
                }, label: {
                    Text("Setting Battery")
                })
                
                NavigationLink(destination: CalendarMonthView(currentDate: $date, colorCalendar: $colorCalendar, colorBattery: colorBattery), isActive: $isOpenCalendar) {
                    EmptyView()
                }
                NavigationLink(destination: BatteryOptionView(colorCalendar: colorCalendar, color: $colorBattery), isActive: $isOpenBattery) {
                    EmptyView()
                }
            }
        }
//        VStack {
//            TextField("DesCription", text: $description).onChange(of: "Value", perform: { _ in
//                isSwich = true
//            })
//            TextField("Your Name", text: $name).onChange(of: "Value", perform: { _ in
//                isSwich = true
//            })
//            Button(action: {
//                if isSwich {
//                    WidgetGroup.save(WidgetShared(name: name, desCription: description))
//                    isSwich = false
//                } else {
//                    WidgetGroup.save(WidgetShared(name: "", desCription: ""))
//                    isSwich = true
//                }
//            }, label: {
//                if isSwich {
//                    Text("Update Satus")
//                } else {
//                    Text("Remove Status")
//                }
//            })
//        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
