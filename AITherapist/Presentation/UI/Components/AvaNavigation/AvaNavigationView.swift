//
//  AvaNavigationView.swift
//  AITherapist
//
//  Created by Cyrus Refahi on 11/5/23.
//

import SwiftUI

struct AvaNavigationView<Content: View, Background: View>: View {
    let content: Content
    let background: Background
    
    init(content: () -> Content, background: () -> Background) {
        self.content = content()
        self.background = background()
    }
    
    var body: some View {
        NavigationStack{
            AvaNavBarView{
                self.content
            } background: {
                self.background
            }
        }
    }
}

struct AvaNavigationView_Previews: PreviewProvider {
    static var previews: some View {
        AvaNavigationView {
            Color.blue
        } background: {
            EmptyView()
        }
    }
}
    
extension UINavigationController{
    open override func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = nil
    }
}
