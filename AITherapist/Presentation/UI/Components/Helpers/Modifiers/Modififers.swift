//
//  Modififers.swift
//  AITherapist
//
//  Created by cyrus refahi on 11/5/23.
//

import Foundation
import SwiftUI


struct HiddenModifier: ViewModifier{
    var isHide: Bool
    
    func body(content: Content) -> some View {
        if isHide{
            content
                .frame(height: 0)
                .hidden()
        }
        else{
            content
        }
    }
}

struct PresentingTextOpacityModifer: Animatable, ViewModifier {
    private var percentage: CGFloat
    private let fraction: CGFloat
    private let order: CGFloat
    
    private var opacity: CGFloat{
        ((percentage - fraction * order) * (1 / fraction))
    }
    
    var animatableData: CGFloat{
        set { percentage = newValue}
        get { percentage }
    }
    
    init(isAnimating: Bool, fraction: CGFloat, order: Int) {
        self.percentage = isAnimating ? 1 : 0
        self.fraction = fraction
        self.order = CGFloat(order)
    }
    
    func body(content: Content) -> some View {
        content
            .opacity(opacity)
    }
}


struct PresentingTextModifer: GeometryEffect {
    private var percentage: CGFloat
    private let fraction: CGFloat
    private let order: CGFloat
    
    var animatableData: CGFloat{
        set { percentage = newValue}
        get { percentage }
    }
    
    init(isAnimating: Bool, fraction: CGFloat, order: Int) {
        self.percentage = isAnimating ? 1 : 0
        self.fraction = fraction
        self.order = CGFloat(order)
    }
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        // animate if from maxOffset
        let maxOffset: CGFloat = 20
        // For each fraction chunk we animate that part if is inRange
        let isInRange = percentage >= order * fraction && percentage <= order * fraction + fraction
        let offset: CGFloat
        
        if percentage == 0 {
            offset = maxOffset
        } else {
            offset = isInRange ? maxOffset * (1 - ((percentage - fraction * order) * (1 / fraction))) :
            percentage >= order * fraction + fraction ? 0.0 : maxOffset
        }
        
        let movementTransform = CGAffineTransform(translationX: 0, y: offset)
        
        return .init(movementTransform)
    }
}

struct ButtonPress: ViewModifier {
    var onPress: () -> Void
    var onRelease: () -> Void
    
    func body(content: Content) -> some View {
        content
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged({ _ in
                        onPress()
                    })
                    .onEnded({ _ in
                        onRelease()
                    })
            )
    }
}

extension View {
    func pressEvents(onPress: @escaping (() -> Void), onRelease: @escaping (() -> Void)) -> some View {
        modifier(ButtonPress(onPress: {
            onPress()
        }, onRelease: {
            onRelease()
        }))
    }
    
    func hiddenModifier(isHide: Bool) -> some View{
        modifier(HiddenModifier(isHide: isHide))
    }
}
