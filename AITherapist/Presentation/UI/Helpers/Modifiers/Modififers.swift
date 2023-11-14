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

extension View{
    func hiddenModifier(isHide: Bool) -> some View{
        return self.modifier(HiddenModifier(isHide: isHide))
        }
}
