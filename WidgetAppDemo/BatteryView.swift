//
//  BatteryView.swift
//  WidgetAppDemo
//
//  Created by Tri Dang on 27/05/2021.
//

import SwiftUI

struct BatteryView: View {
    var battery: Float
    let color: Color
    init(battery: Float, color: Color = .green) {
        self.battery = battery
        self.color = color
    }
    
    var body: some View {
        VStack {
            HStack(spacing: 2) {
                let data = Int(battery / 20)
                if battery < 10 {
                    Rectangle()
                        .frame(width: 10, height: 35)
                        .foregroundColor(Color.red)
                } else {
                    ForEach(0 ... data, id: \.self) { _ in
                        Rectangle()
                            .frame(width: 10, height: 35)
                            .foregroundColor(color)
                    }
                }
                if data != 5 {
                    Spacer()
                }
            }
            .frame(width: 76, height: 15)
            .overlay(Image("battery"))
            
        }.frame(width: 100, height: 100)
            .overlay(Circle().stroke(color, lineWidth: 5))
    }
}

struct BatteryOptionView: View {
    @State var isPresentPickerColorView: Bool = false
    var colorCalendar: Color = .green
    @Binding var color: Color
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    isPresentPickerColorView.toggle()
                }, label: {
                    Text(Image(systemName: "pencil").renderingMode(.original))
                        .font(.system(size: 30)) +
                        Text("Setting Color")
                })
                    .overlay(RoundedRectangle(cornerRadius: 3).stroke(Color.blue, lineWidth: 2))
                Spacer().frame(width: 20)
            }
            Spacer()
            BatteryView(battery: Self.battery, color: color)
            Spacer()
        }
        .sheet(isPresented: $isPresentPickerColorView) {
            PickerColorView(isDismis: $isPresentPickerColorView, color: color, colorCalendar: $color) {
                WidgetGroup.save(WidgetShared(name: "", desCription: "", colorCalendar: TypeColor.convertTo(color: colorCalendar), colorBattery: TypeColor.convertTo(color: color)))
            }
        }
    }
    
    static let battery: Float = {
        UIDevice.current.isBatteryMonitoringEnabled = true
        let batteryLvl = UIDevice.current.batteryLevel
        return batteryLvl
    }()
}

struct BatteryView_Previews: PreviewProvider {
    static var previews: some View {
        BatteryOptionView( color: .constant(.green))
    }
}
