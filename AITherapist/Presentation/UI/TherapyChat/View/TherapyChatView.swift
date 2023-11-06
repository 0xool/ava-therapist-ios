//
//  TherapyChatView.swift
//  AITherapist
//
//  Created by cyrus refahi on 3/3/23.
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
    
    private let MessageViewLineLimitMax = 6
    private var keyboardHeightPublisher: AnyPublisher<CGFloat, Never> {
        Publishers.Merge(
            NotificationCenter.default
                .publisher(for: UIResponder.keyboardWillShowNotification)
                .compactMap { $0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue }
                .map { $0.cgRectValue.height },
            NotificationCenter.default
                .publisher(for: UIResponder.keyboardWillHideNotification)
                .map { _ in CGFloat(0) }
        ).eraseToAnyPublisher()
    }
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
        UITableView.appearance().separatorStyle = .none
        UITableView.appearance().tableFooterView = UIView()
        UITableViewCell.appearance().backgroundColor = UIColor(ColorPallet.BackgroundColorLight) //ColorPallet.greenBackground
        UITableView.appearance().backgroundColor = UIColor(ColorPallet.BackgroundColorLight)
    }
    
    var body: some View {
        switch self.viewModel.conversation {
        case .notRequested:
            notRequestedView
        case .isLoading(last: _, cancelBag: _):
            loadingView()
        case let .loaded(conversation):
            mainChatView(conversation: conversation)
        case let .failed(error):
            failedView(error)
        case .partialLoaded(_):
            notRequestedView
        }
    }
    
    func sendMessage() {
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
                .font(.system(size: 20))
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
        ErrorView(error: error, retryAction: {
            //            self.viewModel.loadConversationList()
#warning("Handle Conversation ERROR")
            print("Handle Conversation ERROR")
            
        })
    }
    
    private func loadingView() -> some View {
        CircleLoading()
    }
    
    private func mainChatView(conversation: Conversation) -> some View {
        ZStack {
            GeometryReader { geo in
                ScrollViewReader{ proxy in
                    VStack {
                        ScrollView {
                            ForEach(conversation.chats.lazyList, id: \.id) { chat in
                                MessageView(chat: chat, onResendMessageClicked: self.viewModel.resendMessage)
                                    .listRowSeparator(.hidden)
                            }.listRowBackground(ColorPallet.BackgroundColorLight)
                        }
                        .scrollContentBackground(.hidden)
                        .background(ColorPallet.BackgroundColorLight)
                        .padding([.leading, .trailing], 8)
                        
                    }
                    .onAppear{
                        proxy.scrollTo(conversation.chats.last , anchor: .bottom)
                    }
                    
                    if viewModel.isUserTurnToSpeak {
                        VStack{
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
                            }.frame(maxHeight: 75, alignment: .center)                       
                                .padding(8)
                        }
                        .frame(maxHeight: 70, alignment: .center)
                        .background(ColorPallet.greenBackground)
                    }else{
                        CircleLoading()
                    }
                }
            }
        }
        .onTapGesture {
            self.hideKeyboard()
        }
        .background(ColorPallet.BackgroundColorLight)
    }
    
    private func textInputView() -> some View{
        TextField("", text: $userMessage, axis: .vertical)
            .textFieldStyle(ChatWithAiTextField())
            .modifier(PlaceholderStyle(showPlaceHolder: userMessage.isEmpty,
                                       placeholder: setPlaceHolder ? "" : "What's on your mind today?", isLargeChatbox: (userMessage.count > MessageViewLineLimitMax)))
            .padding(8)
            .background(.white)
            .frame(height: (userMessage.count > 40) ? 62 : 35)
            .animation(.easeIn, value: userMessage)
            .padding([.top], 4)
            .cornerRadius(15)
    }
}

extension TherapyChatView {
    struct ChatWithAiTextField: TextFieldStyle {
        func _body(configuration: TextField<Self._Label>) -> some View {
            configuration
                .frame(height: 70)
        }
    }
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

extension TherapyChatView {
    class ViewModel: ObservableObject {
        let container: DIContainer
        private var cancelBag = CancelBag()
        @Published var conversation: Loadable<Conversation>
        
        @Published var isUserTurnToSpeak: Bool = true
        var speechRecognizer = SpeechManager()
        //        var didChange = PassthroughSubject<Void, Never>()
        
        let isRunningTests: Bool
        private let initialAiMessage = "Hi this is Ava your personal therapist. How do you feel today?"
        
        func sendMessage(_ chatMessage: String){
            //            didChange.send(())
            isUserTurnToSpeak = false
            
            self.container.services.chatService.sendChatToServer(message: chatMessage, conversation: self.conversation.value!)
                .sink { [weak self] error in
                    self!.isUserTurnToSpeak = true
#warning("Handel error message")
                    // Set Last chat as Error proned ( Server had error)
                    print("Error while sending message \(error)")
                } receiveValue: { chat in
                    self.loadConversationChat()
                }
                .store(in: self.cancelBag)
        }
        
        func loadConversationChat() {
            self.container.services.conversationService.loadConversationChat(conversation: loadableSubject(\.conversation))
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
            _conversation = .init(initialValue: .partialLoaded(conversation))
            self.container = container
            self.isRunningTests = isRunningTests
            
            loadConversationChat()
        }
    }
}


