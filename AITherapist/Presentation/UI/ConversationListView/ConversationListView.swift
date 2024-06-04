//
//  ConversationListView.swift
//  AITherapist
//
//  Created by Cyrus Refahi on 9/17/23.
//

import SwiftUI
import Combine

struct ConversationListView: View {
    @ObservedObject private(set) var viewModel: ViewModel
    @Binding var showNewConversationChatView: Bool

    
    var body: some View {
        mainContent
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea(.keyboard)
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
        case let .partialLoaded(conversations, _):
            loadedView(conversations)
        }
    }
}

// MARK: Loading Content
private extension ConversationListView {
    private var notRequestedView: some View {
        CircleLoading()
    }
    
    private func loadingView() -> some View {
        CircleLoading()
    }
    
    func failedView(_ error: Error) -> some View {
        ErrorView(error: error, retryAction: {
            self.viewModel.loadConversationListOnRetry()
        })
    }
}

// MARK: Displaying Content
private extension ConversationListView {
    
    @ViewBuilder func loadedView(_ conversationList: LazyList<Conversation>) -> some View {
        if conversationList.isEmpty {
            VStack{
                Spacer()
                VStack(spacing: 8){
                    Text("No Journal Entry")
                        .font(Font.custom("SF Pro Text", size: 12))
                        .bold()
                        .foregroundColor(ColorPallet.DiaryDateBlue)
                        .frame(height: 21, alignment: .center)
                    createNewConversationButton
                }
                Spacer()
            }
        }else{
            NavigationStack() {
                VStack(spacing: 0){
                    SearchableCustom(searchtxt: $viewModel.searchText)
                        .padding(.bottom, 8)
                    
                    ConversationCellHeader()
                        .frame(height: 25)
                        .zIndex(5)
                    ZStack{
                        List{
                            ForEach (self.viewModel.getFilteredConversationList()
                                     , id: \.id){ conversation in
                                ZStack{
                                    ConversationCellView(conversation: conversation){
                                        NavigationChatView(conversation: conversation, container: self.viewModel.container)
                                    }
                                    .background(.clear)
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                }
                                .padding([.top, .bottom], 0)
                                .listRowSeparator(.hidden)
                                .listRowBackground(Color.clear)
                                .listRowSpacing(5)
                                .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                                .frame(maxHeight: .infinity)
                            }
                                     .onDelete(perform: self.viewModel.deleteConversation)
                        }
                        .padding(0)
                        .background(.clear)
                        .scrollContentBackground(.hidden)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                        .listStyle(.plain)
                        .refreshable {
                            self.viewModel.container.services.conversationService.loadConversationList()
                        }
                    }
                }
            }
        }
    }
    
    @ViewBuilder var createNewConversationButton: some View{
        Button {
            self.showNewConversationChatView = true
        } label: {
            Text("Create new Conversation")
                .padding(.horizontal, 30)
                .padding(.vertical, 5)
                .frame(height: 54, alignment: .center)
                .background(ColorPallet.SolidDarkGreen)
                .foregroundStyle(ColorPallet.Celeste)
                .cornerRadius(50)
        }
    }
}

extension ConversationListView{
    struct SearchableCustom: View {
        @Binding var searchtxt: String
        @FocusState private var isSearchFocused: Bool
        
        var body: some View {
            HStack {
                HStack {
                    Image(systemName: "magnifyingglass")
                    TextField("Search keywords", text: $searchtxt)
                        .font(Font.custom("SF Pro Text", size: 16))
                        .focused($isSearchFocused)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 8)
                }
                .padding(.horizontal)
                .background(RoundedRectangle(cornerRadius: 25).fill(ColorPallet.LighterCeleste))                
                if isSearchFocused {
                    Button("Cancel") {
                        searchtxt = ""
                        withAnimation(.spring()) {
                            isSearchFocused = false
                        }
                    }
                    .transition(.move(edge: .trailing))
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal)
        }
    }
}

extension ConversationListView{
    struct ConversationCellHeader: View {
        var body: some View {
            header
        }
        
        @ViewBuilder private var header: some View {
            HStack(alignment: .center, spacing: 10) {
                Text("Date")
                    .font(
                        Font.custom("SF Pro Text", size: 13)
                            .weight(.semibold)
                    )
                    .foregroundColor(ColorPallet.DarkGreenText)
                    .frame(width: 60)
                
                HStack{
                    Spacer()
                    
                    Text("Summary")
                        .font(
                            Font.custom("SF Pro Text", size: 13)
                                .weight(.semibold)
                        )
                        .foregroundColor(ColorPallet.DarkGreenText)
                    Spacer()
                }
                
                Text("Mood")
                    .font(
                        Font.custom("SF Pro Text", size: 13)
                            .weight(.semibold)
                    )
                    .foregroundColor(ColorPallet.DarkGreenText)
                    .frame(width: 70)
            }
            .frame(height: 15)
            .frame(maxWidth: .infinity)
            .padding([.leading, .trailing], 16)
        }
    }
}

extension ConversationListView {
    class ViewModel: ObservableObject {
        @Published var searchText: String = ""
        let container: DIContainer
        let isRunningTests: Bool
        private var cancelBag = CancelBag()
        
        var conversations: Loadable<LazyList<Conversation>>{
            get{
                self.container.appState[\.conversationData.conversations]
            }set{
                self.container.appState[\.conversationData.conversations] = newValue
            }
        }
        
        init(coninater: DIContainer, isRunningTests: Bool = ProcessInfo.processInfo.isRunningTests, conversations: Loadable<LazyList<Conversation>> = .notRequested) {
            self.container = coninater
            self.isRunningTests = isRunningTests
            
            container.appState.value.conversationData.objectWillChange.sink { value in
                self.objectWillChange.send()
            }
            .store(in: self.cancelBag)
            
            loadConversationListIfNotRequested()
        }
        
        private func loadConversationListIfNotRequested() {
            if (conversations == .notRequested) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.container.services.conversationService.loadConversationList(conversations: self.loadableSubject(\.conversations))
                }
            }
        }
        
        func loadConversationList() {
            self.container.services.conversationService.loadConversationList()
        }
        
        func loadConversationListOnRetry(){
            loadConversationList()
        }
        
        func getFilteredConversationList() -> LazyList<Conversation>{
            guard let conversationsList = self.conversations.value else{
                return [].lazyList
            }
            
            return conversationsList.filter({
                if searchText.count == 0 { return true }
                guard let summary = $0.summary else{
                    return false
                }
                
                return summary.contains(self.searchText)
                
            }).sorted { $0.dateCreated > $1.dateCreated }.lazyList
        }
        
        func deleteConversation(at offsets: IndexSet) {
            guard let index = offsets.first?.codingKey.intValue else{
                return
            }
            
            let conversationID = getFilteredConversationList()[index].id
            self.container.services.conversationService.deleteConversation(conversationID: conversationID)
            
        }
    }
}

#if DEBUG
struct ConversationListView_Previews: PreviewProvider {
    static var previews: some View {
        ConversationListView(viewModel: ConversationListView.ViewModel(coninater: .previews), showNewConversationChatView: .constant(false))
    }
}
#endif
