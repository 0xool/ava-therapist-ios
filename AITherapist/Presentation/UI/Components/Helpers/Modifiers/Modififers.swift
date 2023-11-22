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
