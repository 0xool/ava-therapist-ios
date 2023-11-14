//
//  AvaNavigationBarRefrenceKeys.swift
//  AITherapist
//
//  Created by cyrus refahi on 11/5/23.
//

import Foundation
import SwiftUI


struct AvaNavigationBarBackButtonHiddenRefrenceKeys: PreferenceKey{
    static var defaultValue: Bool = false
    
    static func reduce(value: inout Bool, nextValue: () -> Bool) {
        value = nextValue()
    }
}

struct AvaNavigationBarTitleRefrenceKeys: PreferenceKey{
    static var defaultValue: String = ""
    
    static func reduce(value: inout String, nextValue: () -> String) {
        value = nextValue()
    }
}


extension View {
    func avaNavigationBarBackButtonHidden(_ hidden: Bool) -> some View{
        preference(key: AvaNavigationBarBackButtonHiddenRefrenceKeys.self, value: hidden)
    }
    
    func avaNavigationBarTitle(_ title: String) -> some View{
        preference(key: AvaNavigationBarTitleRefrenceKeys.self, value: title)
    }
}
