//
//  ConversationListView.swift
//  AITherapist
//
//  Created by cyrus refahi on 9/17/23.
//

import SwiftUI
import Combine

struct ConversationListView: View {
    
    @ObservedObject private(set) var viewModel: ViewModel
    
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
            loadedView(conversations)
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
        Text("No Requested")
    }
    
    private func loadingView() -> some View {
        CircleLoading()
    }
    
    func failedView(_ error: Error) -> some View {
        ErrorView(error: error, retryAction: {
            
#warning("Handle Conversation ERROR")
            print("Handle Conversation ERROR")
        })
    }
}

// MARK: Displaying Content
private extension ConversationListView {
    
    func loadedView(_ conversationList: LazyList<Conversation>) -> some View {
        return NavigationStack {
            VStack(spacing: 0){
                ConversationCellHeader()
                ZStack{
                    List{
                        ForEach (conversationList, id: \.id){ conversation in
                            ZStack{
                                ConversationCell(conversation: conversation)
                                //                                    .padding([.leading, .trailing], 16)
                                AvaNavigationLink {
                                    TherapyChatView(viewModel: .init(conversation: conversation, container: self.viewModel.container))
                                        .avaNavigationBarBackButtonHidden(false)
                                        .avaNavigationBarTitle("")
                                } label: {
                                    EmptyView()
                                }
                                .opacity(0)
                            }
                            .listRowSeparator(.hidden)
                            .listRowInsets(.init(top: -25, leading: 10, bottom: 40, trailing: 10))
                        }
                        .onDelete(perform: self.viewModel.deleteConversation)
                    }
                    .scrollContentBackground(.hidden)
                    .background(.white)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                    .listStyle(.grouped)
                    .listRowSpacing(10)
                }
            }
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
                    .foregroundColor(.black)
                    .frame(width: 67)
                
                Divider()
                Spacer()
                
                
                Text("Summary")
                    .font(
                        Font.custom("Inter", size: 12)
                            .weight(.medium)
                    )
                    .foregroundColor(.black)
                    .padding([.trailing], 30)
                
                Spacer()
                Divider()
                
                Text("Mood")
                    .font(
                        Font.custom("Inter", size: 12)
                            .weight(.medium)
                    )
                    .foregroundColor(.black)
            }
            .frame(height: 25)
            .frame(maxWidth: .infinity)
            .padding([.leading, .trailing], 16)
        }
    }
    
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
            
            HStack(alignment: .center, spacing: 0) {
                HStack(alignment: .center, spacing: 10) {
                    Text(getDateString())
                        .font(Font.custom("SF Pro Text", size: 11))
                        .kerning(0.066)
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color(red: 0.36, green: 0.36, blue: 0.36))
                    Divider()
                    Text("We talked about.... dolor sit amet consectetur. Tempus dui vitae vivamus diam habitasse metus aliquet rhoncus. Potenti nulla pulvinar neque tellus lectus sit.vivamus diam habitasse metus aliquet rhonc Llorem ipsum dolor s")
                        .font(Font.custom("SF Pro Text", size: 11))
                        .kerning(0.066)
                        .foregroundColor(Color(red: 0.36, green: 0.36, blue: 0.36))
                    Divider()
                    Image(systemName: "face.smiling.inverse")
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 26)
            .frame(height: 117, alignment: .center)
            .frame(maxWidth: .infinity)
            .background(ColorPallet.SecondaryColorGreen.gradient)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .inset(by: 0.25)
                    .stroke(Color(red: 0.5, green: 0.5, blue: 0.5), lineWidth: 0)
                
            )
            .shadow(color: Color(hex: 0x7F7F7F, alpha: 1), radius: 1, x: 0, y: 1.5)
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
        let container: DIContainer
        let isRunningTests: Bool
        private var cancelBag = CancelBag()
        
        var conversations: Loadable<LazyList<Conversation>>{
            get{
                return self.container.appState[\.conversationData.conversations]
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
            
            loadConversationList()
        }
        
        func loadConversationList() {
            if conversations == .notRequested {
                container.services.conversationService.loadConversationList(conversations: loadableSubject(\.container.appState[\.conversationData.conversations]))
            }
        }
        
        func deleteConversation(at offsets: IndexSet) {
            guard let index = offsets.first?.codingKey.intValue else{
                return
            }
            
            guard let conversation = self.conversations.value?[index] else {
                return
            }
            
            self.container.services.conversationService.deleteConversation(conversationID: conversation.id)
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        self.conversations = .loaded((self.conversations.value?.filter{ $0 != conversation}.lazyList)!)
                    default:
                        break
                    }
                }, receiveValue: {
                    
                })
                .store(in: self.cancelBag)
        }
    }
}

struct ConversationListView_Previews: PreviewProvider {
    static var previews: some View {
        ConversationListView(viewModel: ConversationListView.ViewModel(coninater: .preview))
    }
}
