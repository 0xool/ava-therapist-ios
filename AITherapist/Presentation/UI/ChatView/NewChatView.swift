//
//  NewChatView.swift
//  AITherapist
//
//  Created by Cyrus Refahi on 11/7/23.
//

import SwiftUI

struct NewChatView: View {
    @ObservedObject private(set) var viewModel: ViewModel
    @Binding var show: Bool
    
    var body: some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(ChatEarBackgroundView())
    }
    
    @ViewBuilder private var content: some View {
        switch self.viewModel.conversation {
        case .notRequested:
            notRequestedView
        case .isLoading(last: _, cancelBag: _):
            loadingView()
        case let .loaded(conversation):
            loadedView(conversation)
        case let .failed(error):
            failedView(error)
                .onAppear{
                    show.toggle()
                }
        case .partialLoaded(_):
            notRequestedView
        }
    }
}

// MARK: Loading Content
private extension NewChatView {
    private func loadedView(_ conversation: Conversation) -> some View{
        ChatView(viewModel: .init(conversation: conversation, container: self.viewModel.container), withBackButton: true, showSheet: $show)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var notRequestedView: some View {
        Text("").onAppear{
            self.viewModel.createNewConversation()
        }
    }
    
    private func loadingView() -> some View {
        CircleLoading()
    }
    
    func failedView(_ error: Error) -> some View {
        ErrorView(error: error, retryAction: {
            print("Handle Conversation ERROR")
        })
    }
}

// MARK: View Model
extension NewChatView{
    class ViewModel: ObservableObject {
        let container: DIContainer
        let isRunningTests: Bool
        
        @Published var conversation: Loadable<Conversation>
        private var cancelBag = CancelBag()
        
        init(coninater: DIContainer, isRunningTests: Bool = ProcessInfo.processInfo.isRunningTests, conversation: Loadable<Conversation> = .notRequested) {
            self.container = coninater
            self.isRunningTests = isRunningTests
            _conversation = .init(initialValue: conversation)
        }
        
        func createNewConversation() {
            self.container.services.conversationService.createNewConversation(conversation: loadableSubject(\.conversation), conversationName: "New Conversation")
        }
    }
}

//#Preview {
//    NewChatView()
//}
