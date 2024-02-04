//
//  TherapyChatView.swift
//  AITherapist
//
//  Created by Cyrus Refahi on 3/3/23.
//

import SwiftUI
import AVFoundation
import Speech

import Combine
import Foundation

struct TherapyChatView: View {
    @ObservedObject private(set) var viewModel: ViewModel
    @ObservedObject var micManager: MicManager = MicManager(numberOfSample: 30)
    @State private var isUsingMic = false
    
    @State private var isRecording = false
    @State private var userMessage = ""
    @State private var setPlaceHolder = false
    
    let withBackButton: Bool
    @Binding var showSheet: Bool
    
    private let MessageViewLineLimitMax = 6
    
    init(viewModel: ViewModel, withBackButton: Bool = false, showSheet: Binding<Bool> = .constant(false)) {
        self.viewModel = viewModel
        self.withBackButton = withBackButton
        self._showSheet = showSheet
    }
    
    var body: some View {
        ZStack{
            mainChatView(chats: self.viewModel.chats.value ?? [])
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
        viewModel.sendMessage(userMessage)
        viewModel.speechRecognizer.transcript = ""
        userMessage = ""
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
                userMessage = viewModel.speechRecognizer.transcript
            }
        } label: {
            Image(systemName: isRecording ? "stop.fill" : "mic.fill")
                .font(.system(size: 20))
                .cornerRadius(10)
                .foregroundColor(ColorPallet.darkColor)
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

private extension TherapyChatView {
    private var notRequestedView: some View {
        Text("").onAppear{
            //            self.viewModel.loadConversationChat
        }
    }
    
    func failedView(_ error: Error) -> some View {
        self.showSheet.toggle()
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
                                !isRecording ? sendBtnView(isHidden: userMessage.isEmpty) : nil
                                speechBtnView(isHidden: !userMessage.isEmpty)
                            }
                        }
                        .padding([.leading, .trailing], 8)
                        .frame(maxHeight: .infinity, alignment: .center)
                        .background(ColorPallet.DarkGreen.opacity(0.6))
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
    
    @ViewBuilder private var backButton: some View{
        if self.withBackButton{
            Button {
                self.showSheet.toggle()
            } label: {
                Image(systemName: "chevron.backward")
                    .font(.subheadline)
                    .foregroundStyle(.green)
                    .padding([.leading], 16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .frame(height: 36)
            }
        }
    }
    
    private func textInputView() -> some View{
        TextField("", text: $userMessage, axis: .vertical)
            .textFieldStyle(ChatWithAiTextField())
            .modifier(PlaceholderStyle(showPlaceHolder: userMessage.isEmpty,
                                       placeholder: setPlaceHolder ? "" : "What's on your mind today?", isLargeChatbox: (userMessage.count > MessageViewLineLimitMax)))
            .background(.white)
            .frame(height: (userMessage.count > 35) ? 62 : 35)
            .animation(.easeIn, value: userMessage)
            .padding([.top], 4)
            .cornerRadius(15)
    }
    
    struct ChatWithAiTextField: TextFieldStyle {
        func _body(configuration: TextField<Self._Label>) -> some View {
            configuration
                .frame(height: 70)
        }
    }
}

extension TherapyChatView {
    class ViewModel: ObservableObject {
        let container: DIContainer
        private var cancelBag = CancelBag()
        
        @Published var chats: Loadable<[Chat]>
        @Published var isUserTurnToSpeak: Bool = true
        
        var speechRecognizer = SpeechManager()
        let conversationID: Int
        //        var didChange = PassthroughSubject<Void, Never>()
        
        let isRunningTests: Bool
        private let initialAiMessage = "Hi this is Ava your personal therapist. How do you feel today?"
        
        func sendMessage(_ chatMessage: String){
            isUserTurnToSpeak = false
            
            self.container.services.chatService.sendChatToServer(message: chatMessage, conversationID: conversationID)
                .sink { [weak self] error in
                    self!.isUserTurnToSpeak = true
#warning("Handel error message")
                    // Set Last chat as Error proned ( Server had error)
                    print("Error while sending message \(error)")
                } receiveValue: {
                    var newChats = self.chats.value ?? []
                    newChats.append($0)
                    newChats.append($1)
                    self.chats = .loaded(newChats)
                }
                .store(in: self.cancelBag)
        }
        
        func addChatToConversation() {
            
        }
        
        func loadConversationChat() {
            self.container.services.conversationService.loadConversationChat(conversation: loadableSubject(\.chats), conversationID: self.conversationID)
        }
        
        private func addElement<T>(_ element: T, to array: [T]) -> [T] {
            return array + [element]
        }
        
        
        func resendMessage(chat: Chat) {
            self.container.services.chatService.deletePreviousUserMessage()
            sendMessage(chat.message)
        }
        
        func setAiMessage(_ msg: String){
            let message = Message(content: msg, isUser: false)
            //        conversation.messages.append(message)
            self.speechRecognizer.readOut(text: message.content)
        }
        
        public func restart() {
            setAiMessage("Hi i'm Ava the AI Therapist! How do you feel today?")
            isUserTurnToSpeak = true
        }
        
        init(conversation: Conversation, container: DIContainer, isRunningTests: Bool = ProcessInfo.processInfo.isRunningTests) {
            _chats = .init(initialValue: .partialLoaded(Array(conversation.chats)))
            self.container = container
            self.isRunningTests = isRunningTests
            self.conversationID = conversation.id
        }
    }
}


