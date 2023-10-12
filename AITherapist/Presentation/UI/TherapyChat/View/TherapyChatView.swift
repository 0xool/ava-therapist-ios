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
    //    @EnvironmentObject var chatHelper: ChatHelper
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
    
    var body: some View {
        
        ZStack {
            GeometryReader { geo in
                VStack {
                    if viewModel.conversation.chats.count > 0 {
                        ScrollViewReader{ proxy in
                            ScrollView {
                                ForEach(viewModel.conversation.chats.map{$0}) { chat in
                                    MessageView(chat: chat)
                                        .listRowSeparator(.hidden)
                                }.listRowBackground(ColorPallet.BackgroundColorLight)
                            }
                            .scrollContentBackground(.hidden)
                            .background(ColorPallet.BackgroundColorLight)
                            .padding([.top], 20)
                            .padding([.bottom], 15)
                            .padding([.leading, .trailing], 16)
                            .onReceive(keyboardHeightPublisher) { _ in
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                                    withAnimation {
                                        proxy.scrollTo(viewModel.conversation.chats.last?.id)
                                    }
                                }
                            }
                            .onReceive(viewModel.$isUserTurnToSpeak, perform: { _ in
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                                    withAnimation {
                                        proxy.scrollTo(viewModel.conversation.chats.last?.id)
                                    }
                                }
                            })
                        }
                    }else{
                        Rectangle()
                            .foregroundColor(ColorPallet.BackgroundColorLight)
                    }
                    
                    if viewModel.isUserTurnToSpeak {
                        VStack{
                            self.isRecording ? speechInputView() : nil
                            HStack {
                                Text(userMessage.count.description)
                                withAnimation {
                                    
                                    TextField("", text: $userMessage, axis: .vertical)
                                        .textFieldStyle(ChatWithAiTextField())
                                        .modifier(PlaceholderStyle(showPlaceHolder: userMessage.isEmpty,
                                                                   placeholder: setPlaceHolder ? "" : "What's on your mind today?", isLargeChatbox: (userMessage.count > MessageViewLineLimitMax)))
                                        .padding(8)
                                        .background(.gray)
                                        .frame(height: (userMessage.count > 30) ? 75 : 35)
                                        .padding([.top], 4)
                                        .cornerRadius(15)
                                        .foregroundColor(.white)
                                }
                                HStack {
                                    sendBtnView()
                                    speechBtnView()
                                }
                            }.frame(height: 70, alignment: .bottom)
                                .padding()
                                .padding([.top], 0)
//                                .background(ColorPallet.greenBackground)
                            
                        }
                        .frame(height: 70)
                        .padding([.bottom], isRecording ? 10 : 0)
                        .offset(y: -10)
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

    func sendMessage() {
        viewModel.sendMessage(userMessage)
        viewModel.speechRecognizer.transcript = ""
        userMessage = ""
    }
    
    func onAiResponse() {
        
    }
    
    private func speechBtnView() -> some View {
        Button {
            isRecording.toggle()
            
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
                .padding()
                .cornerRadius(10)
                .foregroundColor(ColorPallet.darkColor)
        }
    }
    
    
    
    private func sendBtnView() -> some View {
        Button {
            setPlaceHolder = true
            sendMessage()
        } label: {
            Image(systemName: "paperplane.circle.fill")
                .font(.system(size: 20))
                .padding()
                .cornerRadius(10)
                .foregroundColor(ColorPallet.darkColor)
        }
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
            
        }.frame(height: isRecording ? CGFloat(50) : CGFloat(0))
            .padding(isRecording ? CGFloat(10) : CGFloat(0))
            .background(ColorPallet.BackgroundColorLight)
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
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
        UITableView.appearance().separatorStyle = .none
        UITableView.appearance().tableFooterView = UIView()
        UITableViewCell.appearance().backgroundColor = UIColor(ColorPallet.BackgroundColorLight) //ColorPallet.greenBackground
        UITableView.appearance().backgroundColor = UIColor(ColorPallet.BackgroundColorLight)
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
        @Published var conversation: Conversation
        
        @Published var isUserTurnToSpeak: Bool = true
        var speechRecognizer = SpeechManager()
        var didChange = PassthroughSubject<Void, Never>()
        
        private let initialAiMessage = "Hi this is Ava your personal therapist. How do you feel today?"
        
        func sendMessage(_ chatMessage: String){
//            let message = Message(content: chatMessage, isUser: true)
    //        conversation.messages.append(message)
            didChange.send(())
            isUserTurnToSpeak = false
            sendConversation()
        }
    
        func sendConversation() {
//            var conversationList: [String] = []
//            for message in conversation.messages {
//                conversationList.append(message.content)
            }
    
        func setAiMessage(_ msg: String){
            let message = Message(content: msg, isUser: false)
    //        conversation.messages.append(message)
            self.speechRecognizer.readOut(text: message.content)
        }
    
        public func restart() {
            self.conversation = Conversation()
            setAiMessage("Hi i'm Ava the AI Therapist! How do you feel today?")
            isUserTurnToSpeak = true
        }
    
        init(conversation: Conversation, container: DIContainer) {
            self.conversation = conversation
            self.container = container
        }
    }
}
//
//struct TherapyChatView_Previews: PreviewProvider {
//    static var previews: some View {
//        TherapyChatView()
//    }
//}
//


