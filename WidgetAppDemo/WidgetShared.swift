//
//  WidgetShared.swift
//  WidgetAppDemo
//
//  Created by Tri Dang on 25/05/2021.
//

import Foundation
import SwiftUI
import UIKit
import WidgetKit

struct WidgetGroup {
    static let key = "ProfileWidgetGroup"

    static func save(_ value: WidgetShared) {
        let defaults = UserDefaults(suiteName: "group.tridang.WidgetAppDemo")
        defaults?.set(try? PropertyListEncoder().encode(value), forKey: key)
        defaults?.synchronize()
        WidgetCenter.shared.reloadAllTimelines()
    }
    
//    static func saveBattery(_ value: WidgetSharedBattery) {
//        let defaults = UserDefaults(suiteName: "group.tridang.WidgetAppDemo")
//        defaults?.set(try? PropertyListEncoder().encode(value), forKey: key)
//        defaults?.synchronize()
//        WidgetCenter.shared.reloadAllTimelines()
//    }

    static func get() -> WidgetShared! {
        var userData: WidgetShared
        let defaults = UserDefaults(suiteName: "group.tridang.WidgetAppDemo")
        if let data = defaults?.object(forKey: key) as? Data {
            userData = try! PropertyListDecoder().decode(WidgetShared.self, from: data)
            return userData
        } else {
            return WidgetShared(name: "", desCription: "nothing", colorCalendar: .green, colorBattery: .green)
        }
    }
    
//    static func getBattery() -> WidgetSharedBattery! {
//        var userData: WidgetSharedBattery
//        let defaults = UserDefaults(suiteName: "group.tridang.WidgetAppDemo")
//        if let data = defaults?.object(forKey: key) as? Data {
//            userData = try! PropertyListDecoder().decode(WidgetSharedBattery.self, from: data)
//            return userData
//        } else {
//            return WidgetSharedBattery(colorBattery: .green)
//        }
//    }

    static func remove() {
        UserDefaults(suiteName: "group.tridang.WidgetAppDemo")?.removeObject(forKey: key)
    }
}

struct WidgetShared: Codable {
    var name: String
    var desCription: String
    var colorCalendar: TypeColor
    var colorBattery: TypeColor
}

enum TypeColor: Int, Codable {
    static func convertTo(color: Color) -> TypeColor {
        switch color {
        case .green:
            return .green
        case .gray:
            return .gray
        case .blue:
            return .blue
        case .orange:
            return .orange
        case .red:
            return .red
        default:
            return .green
        }
    }

    func revert() -> Color {
        switch self {
        case .green:
            return .green
        case .gray:
            return .gray
        case .blue:
            return .blue
        case .orange:
            return .orange
        case .red:
            return .red
        }
    }

    case red = 1
    case blue
    case gray
    case orange
    case green
}

enum TypeShow: Int, Codable {
    case battery = 1
    case memory = 2
}
