//
//  BackgroundViews.swift
//  AITherapist
//
//  Created by Cyrus Refahi on 11/20/23.
//

import Foundation
import SwiftUI

struct AuthenticationBackgroundView: View {
    var body: some View {
        background
    }
    
    @ViewBuilder var background: some View {
        ZStack{
            Rectangle()
                .foregroundColor(.clear)
                .background(ColorPallet.MediumTurquoiseBlue)
            
            Image("BackgroundImage")
                .opacity(0.9)
                .ignoresSafeArea()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

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


struct DynamicTwoCircleBackgroundView: View {
    @State private var circleAnimationOffsetX: CGFloat = 0
    @State private var circleAnimationOffsetY: CGFloat = 0
    let backgroundColor: Color
    let animate: Bool
    
    init( backgroundColor: Color = ColorPallet.BackgroundColorLight, animate: Bool = true) {
        self.backgroundColor = backgroundColor
        self.animate = animate
    }
    
    private var animationAmount: (CGFloat) -> CGFloat = { size in
        let randomSeed = size / 50
        let randomNumber = randomSeed + CGFloat(arc4random_uniform(UInt32(randomSeed + 1)))
        let signMultiplier = (Int.random(in: 0...1) == 0) ? 1 : -1
        return CGFloat(randomNumber * CGFloat(signMultiplier))
    }
    
    private var backgroundCircleRadius: (CGFloat) -> CGFloat = { height in
        return height / 2
    }
    
    private var topCircleBackgroundOfsett: (CGFloat, CGFloat) -> CGSize = { width, height in
        return .init(width: width / 3, height: -(height / 4) )
    }
    private let bottomCircleBackgroundOfsett: (CGFloat, CGFloat) -> CGSize = { width, height in
        return .init(width: -width / 2 + 45, height: height / 2 - 100)
    }
    
    var body: some View {
        GeometryReader{ geo in
            ZStack{
                backgroundColor
                Circle()
                    .frame(width: backgroundCircleRadius(geo.size.height), height: backgroundCircleRadius(geo.size.height))
                    .foregroundStyle(.green)
                    .offset(topCircleBackgroundOfsett(geo.size.width, geo.size.height))
                    .offset(x: circleAnimationOffsetX, y: circleAnimationOffsetY)
                Circle()
                    .frame(width: backgroundCircleRadius(geo.size.height) * 0.66 , height: backgroundCircleRadius(geo.size.height) * 0.66)
                    .foregroundStyle(.green)
                    .offset(bottomCircleBackgroundOfsett(geo.size.width, geo.size.height))
                    .offset(x: circleAnimationOffsetX, y: circleAnimationOffsetY)
                    .onAppear{
                        withAnimation(.easeOut(duration: 0.65)) {
                            if animate {
                                circleAnimationOffsetX = animationAmount(geo.size.width)
                                circleAnimationOffsetY = animationAmount(geo.size.height)
                            }
                        }
                    }
            }
            .clipped()
            .ignoresSafeArea()
        }
    }
}
