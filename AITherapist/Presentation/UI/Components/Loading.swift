//
//  Loading.swift
//  AITherapist
//
//  Created by Cyrus Refahi on 10/11/23.
//

import Foundation
import SwiftUI

struct CircleLoading: View {
    @State private var circleSize: CGFloat = 25
    @State private var isAtMaxScale = false
    private let animation = Animation.easeInOut(duration: 0.5).repeatForever(autoreverses: true)
    
    var body: some View {
        Circle()
            .fill(LinearGradient(gradient: Gradient(colors: [ColorPallet.DarkGreen, ColorPallet.DarkGreen]), startPoint: .top, endPoint: .bottom))
            .frame(width: circleSize, height: circleSize)
            .scaleEffect(isAtMaxScale ? 1 : 0)
            .offset(y: -25)
            .onAppear{
                withAnimation(animation) {
                    isAtMaxScale.toggle()
                }
            }
    }
    
    func changeCircleSize()  {
        circleSize = (circleSize == 0) ? 25 : 0
    }
}
