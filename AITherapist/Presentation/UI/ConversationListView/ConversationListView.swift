//
//  ConversationListView.swift
//  AITherapist
//
//  Created by cyrus refahi on 9/17/23.
//

import SwiftUI

struct ConversationListView: View {
    
    @ObservedObject private(set) var viewModel: ViewModel
    @Namespace var namespace
    @State var show = false
    
    
    var body: some View {
        ZStack{
            if !show {
                Text("Hello, World!")
            }else {
                Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            }
        }
    }
}


extension ConversationListView {
    class ViewModel: ObservableObject {
        let coninater: DIContainer
        
        
        init(coninater: DIContainer) {
            self.coninater = coninater
        }
    }
}

struct ConversationListView_Previews: PreviewProvider {
    static var previews: some View {
        ConversationListView(viewModel: ConversationListView.ViewModel(coninater: .preview))
    }
}
