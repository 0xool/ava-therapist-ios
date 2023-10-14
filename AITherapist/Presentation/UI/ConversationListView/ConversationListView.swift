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
        mainContent
    }
    
    @ViewBuilder var mainContent: some View {
        switch self.viewModel.conversations {
        case .notRequested:
            notRequestedView
        case .isLoading(last: _, cancelBag: _):
            loadingView()
        case let .loaded(conversations):
            loadedView(conversations)
        case let .failed(error):
            failedView(error)
        case .PartialLoaded(_):
            notRequestedView
        }
    }
}

// MARK: Loading Content
private extension ConversationListView {
    var notRequestedView: some View {
        Text("").onAppear(perform: self.viewModel.loadConversationList)
    }
    
    private func loadingView() -> some View {
        CircleLoading()
    }
    
    func failedView(_ error: Error) -> some View {
        ErrorView(error: error, retryAction: {
//            self.viewModel.loadConversationList()
            #warning("Handle Conversation ERROR")
            print("Handle Conversation ERROR")
            
        })
    }
}

// MARK: Displaying Content
private extension ConversationListView {
    func loadedView(_ conversationList: LazyList<Conversation>) -> some View {
        NavigationStack {
            ZStack{
                List{
                    ForEach (conversationList, id: \.id){ conversation in
                        NavigationLink {
                            TherapyChatView(viewModel: .init(conversation: conversation, container: self.viewModel.coninater))
                        } label: {
                            ConversationCell(conversation: conversation)
                        }
                        .onAppear {
                            self.viewModel.loadMore()
                        }
                    }
                }
                .frame(maxHeight: .infinity, alignment: .top)
                .frame(width: UIViewController().view.bounds.width)
            }
        }

    }
}

extension ConversationListView{
    struct ConversationCell: View {
        var conversation: Conversation
        
        var body: some View {
            cellView
        }
        
        @ViewBuilder private var cellContent: some View{
            VStack{
                Text(conversation.conversationName)
                    .font(.title2)
                    .padding([.leading], 8)
                    .lineLimit(1)
                Text(getDateString())
                    .font(.subheadline)
                    .padding([.trailing], 8)
            }
        }
        
        @ViewBuilder private var cellView: some View {
            ZStack{
                RoundedRectangle(cornerRadius: 25)
                    .padding([.leading, .trailing], 16)
                    .frame(height: 250)
                    .foregroundStyle(ColorPallet.SecondaryColorGreen)
                cellContent
                    .frame(maxHeight: .infinity, alignment: .top)
                    .padding([.leading, .trailing], 16)
                    .padding([.top], 16)
            }
        }
        
        private func getDateString() -> String {
            let components = conversation.dateCreated.get(.month, .day, .year)
            if let day = components.day, let month = components.month, let year = components.year {
                return "\(day)-\(month)-\(year)"
            }
            
            return ""
        }
    }
}

extension ConversationListView {
    class ViewModel: ObservableObject {
        let coninater: DIContainer
        let isRunningTests: Bool
        @Published var conversations: Loadable<LazyList<Conversation>>
//        [
//            Conversation(id: 1, conversationName: "First Conversation", date: .now),
//            Conversation(id: 2, conversationName: "Second Conversation", date: .now + 1),
//            Conversation(id: 3, conversationName: "Third Conversation", date: .now + 2),
//            Conversation(id: 4, conversationName: "Fourth Conversation", date: .now + 3),
//            Conversation(id: 5, conversationName: "Fifth Conversation", date: .now + 4),
//            Conversation(id: 6, conversationName: "Six Conversation", date: .now + 5),
//            Conversation(id: 7, conversationName: "Seventh Conversation", date: .now + 6),
//            Conversation(id: 8, conversationName: "Eighth Conversation", date: .now + 7),
//        ]
        
        @Published var conversationList: [Conversation] = []
        
        private var listIndex = 0
        
        init(coninater: DIContainer, isRunningTests: Bool = ProcessInfo.processInfo.isRunningTests, conversations: Loadable<LazyList<Conversation>> = .notRequested) {
            self.coninater = coninater
            self.isRunningTests = isRunningTests
            _conversations = .init(initialValue: conversations)
//            conversationList.append(conversations[0])
        }
        
        func loadConversationList() {
            coninater.services.conversationService.loadConversationList(conversations: loadableSubject(\.conversations))
        }
        
        func loadMore() {
            guard let convos = conversations.value else {
                return
            }
            listIndex += 1
        
            if listIndex >= convos.count { return }
            conversationList.append(convos[self.listIndex])
        }
    }
}

struct ConversationListView_Previews: PreviewProvider {
    static var previews: some View {
        ConversationListView(viewModel: ConversationListView.ViewModel(coninater: .preview))
    }
}
