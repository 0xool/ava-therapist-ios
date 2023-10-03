//
//  Logo.swift
//  AITherapist
//
//  Created by cyrus refahi on 10/1/23.
//

import SwiftUI

struct LogoIcon: View {
    var body: some View {
        Logo()
            .frame(width: 42.97, height: 24.25)
            .foregroundStyle(.green)
    }
}

struct Logo: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height
        path.move(to: CGPoint(x: 0.30657*width, y: 0.03*height))
        path.addCurve(to: CGPoint(x: 0.32626*width, y: 0.03*height), control1: CGPoint(x: 0.31095*width, y: 0.01667*height), control2: CGPoint(x: 0.32188*width, y: 0.01667*height))
        path.addLine(to: CGPoint(x: 0.59862*width, y: 0.86027*height))
        path.addCurve(to: CGPoint(x: 0.58217*width, y: 0.88655*height), control1: CGPoint(x: 0.60473*width, y: 0.8789*height), control2: CGPoint(x: 0.59212*width, y: 0.89904*height))
        path.addLine(to: CGPoint(x: 0.36909*width, y: 0.61878*height))
        path.addCurve(to: CGPoint(x: 0.33206*width, y: 0.61583*height), control1: CGPoint(x: 0.35816*width, y: 0.60504*height), control2: CGPoint(x: 0.34365*width, y: 0.60388*height))
        path.addLine(to: CGPoint(x: 0.04032*width, y: 0.9164*height))
        path.addCurve(to: CGPoint(x: 0.02474*width, y: 0.88914*height), control1: CGPoint(x: 0.03026*width, y: 0.92678*height), control2: CGPoint(x: 0.01891*width, y: 0.90692*height))
        path.addLine(to: CGPoint(x: 0.30657*width, y: 0.03*height))
        path.closeSubpath()
        path.move(to: CGPoint(x: 0.72752*width, y: 0.94*height))
        path.addCurve(to: CGPoint(x: 0.70783*width, y: 0.94*height), control1: CGPoint(x: 0.72314*width, y: 0.95333*height), control2: CGPoint(x: 0.71221*width, y: 0.95333*height))
        path.addLine(to: CGPoint(x: 0.4602*width, y: 0.1851*height))
        path.addCurve(to: CGPoint(x: 0.47782*width, y: 0.16053*height), control1: CGPoint(x: 0.45366*width, y: 0.16516*height), control2: CGPoint(x: 0.46829*width, y: 0.14476*height))
        path.addLine(to: CGPoint(x: 0.69432*width, y: 0.51881*height))
        path.addCurve(to: CGPoint(x: 0.74103*width, y: 0.51881*height), control1: CGPoint(x: 0.70745*width, y: 0.54052*height), control2: CGPoint(x: 0.7279*width, y: 0.54052*height))
        path.addLine(to: CGPoint(x: 0.95753*width, y: 0.16053*height))
        path.addCurve(to: CGPoint(x: 0.97515*width, y: 0.1851*height), control1: CGPoint(x: 0.96706*width, y: 0.14476*height), control2: CGPoint(x: 0.9817*width, y: 0.16516*height))
        path.addLine(to: CGPoint(x: 0.72752*width, y: 0.94*height))
        path.closeSubpath()
        return path
    }
}
