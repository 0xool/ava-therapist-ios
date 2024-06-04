//
//  AvaNavigationBarRefrenceKeys.swift
//  AITherapist
//
//  Created by Cyrus Refahi on 11/5/23.
//

import Foundation
import SwiftUI

struct AvaNavigationBarTopLeftButtonRefrenceKeys: PreferenceKey{
    static var defaultValue: TopLeftButtonType = .nothing
    
    static func reduce(value: inout TopLeftButtonType, nextValue: () -> TopLeftButtonType) {
        value = nextValue()
    }
}

struct AvaNavigationBarBackButtonHiddenRefrenceKeys: PreferenceKey{
    static var defaultValue: Bool = false
    
    static func reduce(value: inout Bool, nextValue: () -> Bool) {
        value = nextValue()
    }
}

struct AvaNavigationBarShowBackgroundRefrenceKeys: PreferenceKey{
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

struct AvaNavigationBarColorRefrenceKeys: PreferenceKey{
    static var defaultValue: Bool = false
    
    static func reduce(value: inout Bool, nextValue: () -> Bool) {
        value = nextValue()
    }
}

struct AvaNavigationLogoutClickedRefrenceKeys: PreferenceKey{
    static var defaultValue: () -> () = {}
    
    static func reduce(value: inout () -> (), nextValue: () -> () -> ()) {
        value = nextValue()
    }
}

extension View {
    func avaNavigationBarTopLeftButton(_ topLeftButtonType: TopLeftButtonType) -> some View{
        preference(key: AvaNavigationBarTopLeftButtonRefrenceKeys.self, value: topLeftButtonType)
    }
    
    func avaNavigationSetLogoutClicked(_ onLogout: @escaping () -> ()) -> some View{
        preference(key: AvaNavigationLogoutClickedRefrenceKeys.self, value: onLogout)
    }
    
    func avaNavigationBarTitle(_ title: String) -> some View{
        preference(key: AvaNavigationBarTitleRefrenceKeys.self, value: title)
    }
    
    func avaNavigationBarBackground(_ show: Bool) -> some View{
        preference(key: AvaNavigationBarShowBackgroundRefrenceKeys.self, value: show)
    }
    
    func avaNavigationBarColor(isChat: Bool) -> some View {
        preference(key: AvaNavigationBarColorRefrenceKeys.self, value: isChat)
    }
}
