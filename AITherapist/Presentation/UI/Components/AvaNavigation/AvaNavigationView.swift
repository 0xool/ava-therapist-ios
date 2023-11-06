//
//  AvaNavigationView.swift
//  AITherapist
//
//  Created by cyrus refahi on 11/5/23.
//

import SwiftUI

struct AvaNavigationView<Content: View>: View {
    let content: Content
    
    
    init(content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        NavigationStack{
            AvaNavBarView{
                self.content
            }
        }
    }
}

struct AvaNavigationView_Previews: PreviewProvider {
    static var previews: some View {
        AvaNavigationView{
            Color.blue
        }
    }
}
    
extension UINavigationController{
    open override func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = nil
    }
}
