//
//  BackgroundViews.swift
//  AITherapist
//
//  Created by cyrus refahi on 11/20/23.
//

import Foundation
import SwiftUI

struct TwoCircleBackgroundView: View {
    @State private var circleAnimationOffsetX: CGFloat = 0
    @State private var circleAnimationOffsetY: CGFloat = 0
    let backgroundColor: Color
    let animate: Bool
    
    init( backgroundColor: Color = ColorPallet.BackgroundColorLight, animate: Bool = true) {
        self.backgroundColor = backgroundColor
        self.animate = animate
    }
    
    private var animationAmount: CGFloat {
        let randomNumber = 36 + Int(arc4random_uniform(UInt32(72 - 36 + 1)))
        let signMultiplier = (Int.random(in: 0...1) == 0) ? 1 : -1
        return CGFloat(randomNumber * signMultiplier)
    }
    
    private let backgroundCircleRadius = UIViewController().view.bounds.height / 2
    private let topCircleBackgroundOfsett: CGSize = .init(width: UIViewController().view.bounds.width / 3, height: -UIViewController().view.bounds.height / 4)
    private let bottomCircleBackgroundOfsett: CGSize = .init(width: -UIViewController().view.bounds.width / 2 + 45, height: UIViewController().view.bounds.height / 2 - 100)
    
    var body: some View {
        ZStack{
            backgroundColor
            Circle()
                .frame(width: backgroundCircleRadius, height: backgroundCircleRadius)
                .foregroundStyle(.green)
                .offset(topCircleBackgroundOfsett)
                .offset(x: circleAnimationOffsetX, y: circleAnimationOffsetY)
            Circle()
                .frame(width: backgroundCircleRadius * 0.66 , height: backgroundCircleRadius * 0.66)
                .foregroundStyle(.green)
                .offset(bottomCircleBackgroundOfsett)
                .offset(x: circleAnimationOffsetX, y: circleAnimationOffsetY)
                .onAppear{
                    withAnimation(.easeOut(duration: 0.65)) {
                        if animate {
                            circleAnimationOffsetX = animationAmount
                            circleAnimationOffsetY = animationAmount
                        }
                    }
                }
        }
        .clipped()
        .ignoresSafeArea()
    }
}
