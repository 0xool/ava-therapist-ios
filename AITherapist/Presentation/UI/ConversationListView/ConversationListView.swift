//
//  ConversationListView.swift
//  AITherapist
//
//  Created by cyrus refahi on 9/17/23.
//

import SwiftUI

struct ConversationListView: View {
    
    @ObservedObject private(set) var viewModel: ViewModel
//    @Namespace var conversationListNamespace
//    @State var show = false
    
    
    var body: some View {
        ZStack{
//            if !show {
//                Text("Hello, World!")
//            }else {
//                Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
//            }
            ScrollView{
                ForEach (viewModel.conversations, id: \.id){ conversation in
                    ConversationCell(conversation: conversation)
                }
            }
            .frame(maxHeight: .infinity, alignment: .top)
        }
    }
}

extension ConversationListView{
    struct ConversationCell: View {
        var conversation: Conversation
        
        var body: some View {
            HStack{
                Text(conversation.conversationName)
                Text(conversation.dateCreated.description)
            }
            .padding([.leading, .trailing], 8)
            .frame(width: UIViewController().screen()?.bounds.width, height: 75)
            .background{
                cellBackround
            }
        }
        
        @ViewBuilder private var cellBackround: some View {
            RoundedRectangle(cornerRadius: 25)
                .foregroundStyle(.gray)
        }
    }
}


extension ConversationListView {
    class ViewModel: ObservableObject {
        let coninater: DIContainer
        var conversations: [Conversation] = [
            Conversation(id: 1, conversationName: "First Conversation", date: .now),
            Conversation(id: 2, conversationName: "Second Conversation", date: .now + 1),
            Conversation(id: 3, conversationName: "Third Conversation", date: .now + 2),
            Conversation(id: 4, conversationName: "Fourth Conversation", date: .now + 3),
            Conversation(id: 5, conversationName: "Fifth Conversation", date: .now + 4)
            ]
            
        
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
