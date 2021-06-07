//
//  CircleView.swift
//  WidgetAppDemo
//
//  Created by Tri Dang on 28/05/2021.
//

import SwiftUI

struct CircleView: Shape {
    @State var battery: Double = 100
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addArc(center: CGPoint(x: rect.size.width / 2, y: rect.size.width / 2),
                    radius: rect.size.width / 2,
                    startAngle: Angle(degrees: 360),
                    endAngle: Angle(degrees: 360 - battery),
                    clockwise: true)
        return path
    }
}
