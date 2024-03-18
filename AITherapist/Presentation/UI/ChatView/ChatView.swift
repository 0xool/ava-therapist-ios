//
//  ChatView.swift
//  AITherapist
//
//  Created by Cyrus Refahi on 3/3/23.
//

import SwiftUI
import AVFoundation
import Speech

import Combine
import Foundation


struct ChatView: View {
    @ObservedObject private(set) var viewModel: ViewModel
    @ObservedObject var micManager: MicManager = MicManager(numberOfSample: 30)
    @State private var isUsingMic = false
    
    @State private var isRecording = false
    @State private var setPlaceHolder = false
    let isNewChat: Bool
    
    let withBackButton: Bool
    @Binding var showSheet: Bool
    private let MessageViewLineLimitMax = 6
    
    init(viewModel: ViewModel, isNewChat: Bool = false, withBackButton: Bool = false, showSheet: Binding<Bool> = .constant(false)) {
        self.viewModel = viewModel
        self.withBackButton = withBackButton
        self._showSheet = showSheet
        
        self.isNewChat = isNewChat
    }
    
    var body: some View {
        ZStack{
            mainChatView(chats: self.viewModel.getChats())
                .onAppear{
                    self.viewModel.loadConversationChat()
                }
            
            switch self.viewModel.chats {
            case .notRequested:
                notRequestedView
            case .isLoading(last: _, cancelBag: _):
                loadingView()
            case .loaded:
                EmptyView()
            case let .failed(error):
                failedView(error)
            case .partialLoaded(_):
                notRequestedView
            }
            
        }
    }
    
    private func sendMessage() {
        let message = self.viewModel.userMessage
        viewModel.sendMessage(message)
    }
    
    private func speechBtnView(isHidden: Bool = false) -> some View {
        Button {
            withAnimation {
                isRecording.toggle()
            }
            
            if isRecording {
                micManager.startMonitoring()
                viewModel.speechRecognizer.reset()
                viewModel.speechRecognizer.transcribe()
            }else{
                viewModel.speechRecognizer.stopTranscribing()
                self.viewModel.userMessage = viewModel.speechRecognizer.transcript
            }
        } label: {
            Image(systemName: isRecording ? "stop.fill" : "mic.fill")
                .font(.system(size: 20))
                .cornerRadius(10)
                .foregroundColor(.white)
        }
        .hiddenModifier(isHide: isHidden)
    }
    
    private func sendBtnView(isHidden: Bool) -> some View {
        Button {
            setPlaceHolder = true
            sendMessage()
        } label: {
            Image(systemName: "arrow.up.circle.fill")
                .font(.system(size: 30))
                .foregroundColor(.green)
        }
        .hiddenModifier(isHide: isHidden)
    }
    
    private func speechInputView() -> some View {
        HStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.black.opacity(0.7))
                .padding()
                .overlay {
                    VStack{
                        visualizerView()
                    }
                }
                .opacity(isRecording ? 1 : 0)
            
        }
        .frame(maxHeight: .infinity, alignment: .center)
    }
    
    private func visualizerView() -> some View {
        VStack{
            HStack(spacing: 3){
                ForEach(micManager.soundSample, id: \.self) { level in
                    SpeechVisualBarView(value: self.normalizedSoundeLevel(level: level))
                }
            }
        }
    }
    
    private func normalizedSoundeLevel(level: Float) -> CGFloat {
        let level = max(0.2, CGFloat(level) + 50) / 2
        return CGFloat(level)
    }
}

private extension ChatView {
    private var notRequestedView: some View {
        Text("").onAppear{
        }
    }
    
    func failedView(_ error: Error) -> some View {
        self.viewModel.onBackToPreviousClicked {
            self.showSheet.toggle()
        }
        
        return ErrorView(error: error, retryAction: {
            self.viewModel.loadConversationChat()
        })
    }
    
    private func loadingView() -> some View {
        CircleLoading()
    }
    
    private func mainChatView(chats: [Chat]) -> some View {
        GeometryReader { geo in
            VStack(spacing: 0){
                ScrollViewReader{ proxy in
                    VStack {
                        backButton
                        ZStack{
                            ScrollView {
                                ForEach(chats, id: \.id) { chat in
                                    MessageView(chat: chat, onResendMessageClicked: self.viewModel.resendMessage)
                                        .padding([.leading, .trailing], 8)
                                        .listRowSeparator(.hidden)
                                }
                            }
                            .safeAreaInset(edge: .top, spacing: 0){
                                Spacer()
                                    .frame(height: 20)
                            }
                            .scrollContentBackground(.hidden)
                            
                            initialChatOptionsView
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .onAppear{
                        if let id = chats.last?.id  {
                            proxy.scrollTo(id)
                        }
                    }
                    .onChange(of: chats){ newValue in
                        if let id = newValue.last?.id  {
                            proxy.scrollTo(id)
                        }
                    }
                }
                
                VStack{
                    if viewModel.isUserTurnToSpeak {
                        HStack(alignment: .center) {
                            if self.isRecording {
                                speechInputView()
                            }else{
                                textInputView()
                            }
                            
                            ZStack{
                                !isRecording ? sendBtnView(isHidden: self.viewModel.userMessage.isEmpty) : nil
                                speechBtnView(isHidden: !self.viewModel.userMessage.isEmpty)
                            }
                        }
                        .padding([.leading, .trailing], 8)
                        .frame(maxHeight: .infinity, alignment: .center)
                        .background(ColorPallet.DarkGreen)
                    }else{
                        CircleLoading()
                    }
                }
                .frame(maxHeight: 75, alignment: .center)
            }
        }
        .onTapGesture {
            self.hideKeyboard()
        }
    }
    
    @ViewBuilder private var initialChatOptionsView: some View {
        if self.viewModel.chats.value?.count ?? 0 <= 1
            && isNewChat {
            VStack{
                Spacer()
                NewChatChoiceView(onBubleClicked: { self.viewModel.sendMessage($0) })
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
        }
        
        
    }
    
    @ViewBuilder private var backButton: some View{
        if self.withBackButton{
            Button {
                self.viewModel.onBackToPreviousClicked {
                    self.showSheet.toggle()
                }
            } label: {
                Image(systemName: "chevron.backward")
                    .font(.subheadline)
                    .foregroundStyle(ColorPallet.DiaryDateBlue)
                    .padding([.leading], 16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .frame(height: 36)
            }
        }
    }
    
    private func textInputView() -> some View{
        TextField("", text: $viewModel.userMessage, axis: .vertical)
            .textFieldStyle(ChatWithAiTextField())
            .modifier(PlaceholderStyle(showPlaceHolder: self.viewModel.userMessage.isEmpty,
                                       placeholder: setPlaceHolder ? "" : "What's on your mind today?", isLargeChatbox: (self.viewModel.userMessage.count > MessageViewLineLimitMax)))
            .frame(height: (self.viewModel.userMessage.count > 45) ? 62 : 35)
            .animation(.easeIn, value: self.viewModel.userMessage)
            .background(ColorPallet.grey100)
            .cornerRadius(15)
        
    }
    
    struct ChatWithAiTextField: TextFieldStyle {
        func _body(configuration: TextField<Self._Label>) -> some View {
            configuration
                .frame(height: 70)
        }
    }
}

extension ChatView {
    class ViewModel: ObservableObject {
        let container: DIContainer
        private var cancelBag = CancelBag()
        
        @Published var chats: Loadable<LazyList<Chat>> {
            willSet{
                guard let chatList = newValue.value else{
                    return
                }
                
                guard let isUserMessage = chatList.last?.isUserMessage else{
                    return
                }
                
                self.isUserTurnToSpeak = !isUserMessage || (chatList.last?.chatState == .ErrorWhileSending)
            }
        }
        @Published var isUserTurnToSpeak: Bool = true
        @Published var userMessage = ""
        
        var speechRecognizer = SpeechManager()
        let conversation: Conversation
        let isRunningTests: Bool
        
        private let initialAiMessage = "Hi this is Ava your personal therapist. How do you feel today?"
        
        init(conversation: Conversation, container: DIContainer, isRunningTests: Bool = ProcessInfo.processInfo.isRunningTests) {
            _chats = .init(initialValue: .partialLoaded(Array(conversation.chats).lazyList))
            self.container = container
            self.isRunningTests = isRunningTests
            self.conversation = conversation
        }
        
        func sendMessage(_ message: String){
            self.userMessage = ""
            self.speechRecognizer.transcript = ""
            
            guard let chats = self.chats.value else{
                return
            }
            
            isUserTurnToSpeak = false
            var newChats: [Chat] = Array(chats)
            newChats.append(.init(message: message, conversationID: self.conversation.id, chatSequence: nil, isUserMessage: true, isSentToserver: .BeingSent))
            self.chats = .loaded(newChats.lazyList)
            
            self.container.services.chatService.sendChatToServer(chats: loadableSubject(\.chats), message: message, conversationID: self.conversation.id, cancelBag: self.cancelBag)
        }
        
        func getChats() -> [Chat] {
            guard let ch = self.chats.value else{
                return []
            }
            
            return Array(ch)
        }
        
        func loadConversationChat() {
            self.container.services.conversationService.loadConversationChat(conversation: loadableSubject(\.chats), conversationID: self.conversation.id)
        }
        
        func resendMessage(chat: Chat) {
            isUserTurnToSpeak = false
            guard let chats = self.chats.value else{
                return
            }
            
            isUserTurnToSpeak = false
            var newChats: [Chat] = Array(chats)
            newChats.removeLast()
            newChats.append(.init(id:chat.id, message: chat.message, conversationID: self.conversation.id, chatSequence: nil, isUserMessage: true, isSentToserver: .BeingSent))
            self.chats = .loaded(newChats.lazyList)
            
            self.container.services.chatService.sendChatToServer(chats: loadableSubject(\.chats), message: chat.message, conversationID: self.conversation.id, cancelBag: self.cancelBag)
        }
        
        func setAiMessage(_ msg: String){
            let message = Message(content: msg, isUser: false)
            self.speechRecognizer.readOut(text: message.content)
        }
        
        // Rule: Remove conversation if no chat initiated
        func onBackToPreviousClicked(_ completion: @escaping () -> ()){
            if let chats = self.chats.value {
                if chats.count <= 1 {
                    self.container.services.conversationService.deleteConversationAndUpdate(conversationID: self.self.conversation.id)
                }else{
                    self.container.services.conversationService.addConversationToDB(conversation: self.conversation)
                }
            }
            
            completion()
        }
        
    }
}


