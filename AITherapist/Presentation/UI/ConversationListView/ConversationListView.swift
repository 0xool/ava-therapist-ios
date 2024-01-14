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
    @State private var searchText: String = ""
    
    var body: some View {
        mainContent
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    @ViewBuilder var mainContent: some View {
        switch self.viewModel.conversations {
        case .notRequested:
            notRequestedView
        case .isLoading(last: _, cancelBag: _):
            loadingView()
        case let .loaded(conversations):
            loadedView(conversations/*.sorted(by: { $0.dateCreated > $1.dateCreated }).lazyList*/)
        case let .failed(error):
            failedView(error)
        case .partialLoaded(_):
            notRequestedView
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
    func loadedView(_ conversationList: LazyList<Conversation>) -> some View {
        let filteredConversationList = conversationList.filter({
            if searchText.count == 0 { return true }
            guard let summary = $0.summary else{
                return false
            }
            
            return summary.contains(self.searchText)
            
        })
        
        return NavigationStack {
            VStack(spacing: 0){
                SearchableCustom(searchtxt: $searchText)
                    .padding(.bottom, 8)
                
                ConversationCellHeader()
                    .frame(height: 25)
                    .zIndex(5)
                ZStack{
                    List{
                        ForEach (filteredConversationList, id: \.id){ conversation in
                            ZStack{
                                ConversationCell(conversation: conversation)
                                    .background(.clear)
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    
                                AvaNavigationLink {
                                    TherapyChatView(viewModel: .init(conversation: conversation, container: self.viewModel.container))
                                        .avaNavigationBarTopLeftButton(.back)
                                        .avaNavigationBarTitle("")
                                } label: {
                                    EmptyView()
                                }
                                .listRowBackground(Color.red)
                                .opacity(0)
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
                    

                }
            }
        }
    }
}

extension ConversationListView{
struct SearchableCustom: View {
    
    @Binding var searchtxt: String
    @FocusState private var isSearchFocused: Bool // Track focus state
    
    var body: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
                TextField("Search keywords", text: $searchtxt)
                    .focused($isSearchFocused) // Track focus state
                    .padding(.horizontal, 10)
                    .padding(.vertical, 8)
            }
            .padding(.horizontal)
            .background(Color(.secondarySystemBackground))
            .cornerRadius(10)
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
            
            if isSearchFocused {
                Button("Cancel") {
                    searchtxt = ""
                    withAnimation(.spring()) {
                        isSearchFocused = false
                    }
                }
                .transition(.move(edge: .trailing)) // Add animation for cancel button
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
                        Font.custom("Inter", size: 12)
                            .weight(.medium)
                    )
                    .foregroundColor(ColorPallet.DarkBlue)
                    .frame(width: 60)
                
                ConversationCustomDivider()
                
                HStack{
                    Spacer()
                    Text("Summary")
                        .font(
                            Font.custom("Inter", size: 12)
                                .weight(.medium)
                        )
                        .foregroundColor(ColorPallet.DarkBlue)
                    Spacer()
                }
                
                ConversationCustomDivider()
                
                Text("Mood")
                    .font(
                        Font.custom("Inter", size: 12)
                            .weight(.medium)
                    )
                    .foregroundColor(ColorPallet.DarkBlue)
                    .frame(width: 70)
            }
            .frame(height: 15)
            .frame(maxWidth: .infinity)
            .padding([.leading, .trailing], 16)
        }
    }
    
    struct ConversationCell: View {
        var conversation: Conversation
        let imageName: String = "ImagePlaceholder"
        
        var body: some View {
            cellView
        }
        
        @ViewBuilder private var cellView: some View {
            VStack(alignment: .center, spacing: 0) {
                HStack(alignment: .center, spacing: 10) {
                    Text(getDateString())
                        .font(Font.custom("SF Pro Text", size: 11))
                        .kerning(0.066)
                        .multilineTextAlignment(.center)
                        .foregroundColor(ColorPallet.DarkBlue)
                        .frame(width: 60)
                    
                    ConversationCustomDivider()
                    
                    HStack{
                        Spacer()
                        Text(self.conversation.summary ?? "No Summary")
                            .font(Font.custom("SF Pro Text", size: 11))
                            .kerning(0.066)
                            .foregroundColor((self.conversation.summary != nil) ? ColorPallet.DarkBlue : ColorPallet.TertiaryYellow)
                        Spacer()
                    }
                    
                    ConversationCustomDivider()
                    
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 70, height: 70)
                        .background(
                            Image(self.imageName)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 70, height: 70)
                                .clipped()
                        )
                        .cornerRadius(15)
                }
                .frame(height: 70)
                .frame(maxWidth: .infinity)
                .padding(16)
                
                Spacer()
                
                Rectangle()
                    .fill(ColorPallet.MediumTurquoiseBlue)
                    .frame(width: UIViewController().view.bounds.width, height: 1)
            }
            .padding(.horizontal, 16)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .cornerRadius(10)
        }
        
        private func getDateString() -> String {
            let components = conversation.dateCreated.get(.month, .day, .year)
            if let day = components.day, let month = components.month, let year = components.year {
                return "\(day)/\(month)/\(year)"
            }
            
            return ""
        }
    }
}

extension ConversationListView{
    struct ConversationCustomDivider: View {
        let color: Color = ColorPallet.DarkBlue
        let width: CGFloat = 1
        var body: some View {
            Rectangle()
                .fill(color)
                .frame(width: width)
                .edgesIgnoringSafeArea(.horizontal)
        }
    }
}

extension ConversationListView {
    class ViewModel: ObservableObject {
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
        
        var conversationsList: LazyList<Conversation> {
            get{
                conversations.value?.sorted(by: { $0.dateCreated > $1.dateCreated }).lazyList ?? [].lazyList
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
                self.container.services.conversationService.loadConversationList(conversations: self.loadableSubject(\.conversations))
            }
        }
        
        func loadConversationList() {
            self.container.services.conversationService.loadConversationList(conversations: self.loadableSubject(\.conversations))
        }
        
        func loadConversationListOnRetry(){
            loadConversationList()
        }
        
        func deleteConversation(at offsets: IndexSet) {
            guard let index = offsets.first?.codingKey.intValue else{
                return
            }
            
            guard let conversationID = self.conversations.value?[index].id else {
                return
            }

            self.conversations = .loaded(self.conversations.value?.filter({ $0.id != conversationID
            }) .lazyList ?? [].lazyList)
            self.container.services.conversationService.deleteConversation(conversationID: conversationID)
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure:
                        self.loadConversationList()
                    }
                }, receiveValue: {
                    
                })
                .store(in: self.cancelBag)
        }
    }
}

#if DEBUG
struct ConversationListView_Previews: PreviewProvider {
    static var previews: some View {
        ConversationListView(viewModel: ConversationListView.ViewModel(coninater: .preview))
    }
}
#endif
