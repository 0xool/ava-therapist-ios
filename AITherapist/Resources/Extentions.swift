//
//  Extentions.swift
//  AITherapist
//
//  Created by Cyrus Refahi on 3/11/23.
//

import Foundation
import SwiftUI
import Combine

#if canImport(UIKit)
extension View {
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    public func flip() -> some View {
        return self
            .rotationEffect(.radians(.pi))
            .scaleEffect(x: -1, y: 1, anchor: .center)
    }
}
#endif

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {

        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}

public struct PlaceholderStyle: ViewModifier {
    var showPlaceHolder: Bool
    var placeholder: String
    var isLargeChatbox = false

    public func body(content: Content) -> some View {
        ZStack(alignment: isLargeChatbox ? .topLeading : .leading) {
            if showPlaceHolder {
                Text(placeholder)
                    .foregroundColor(.gray)
                    .font(.system(size: 15))
                    .padding(.horizontal, isLargeChatbox ? 15 : 8)
                .offset(y: isLargeChatbox ? 15 : 0)
            }
            content
            .foregroundColor(Color.black)
            .padding(5.0)
        }
    }
}
