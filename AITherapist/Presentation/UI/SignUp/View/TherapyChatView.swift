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

struct TherapyChatView: View{
    var body: some View{
        Text("Ava Chat")
    }
}

//
//struct TherapyChatView: View {
//    //    @EnvironmentObject var chatHelper: ChatHelper
//    @ObservedObject var therapistChatModel: TherapyChatModel
//    @ObservedObject var micManager: MicManager = MicManager(numberOfSample: 30)
//    @State private var isUsingMic = false
//    
//    @State private var isRecording = false
//    @State private var userMessage = ""
//    @State private var setPlaceHolder = false
//        
//    private var keyboardHeightPublisher: AnyPublisher<CGFloat, Never> {
//        Publishers.Merge(
//            NotificationCenter.default
//                .publisher(for: UIResponder.keyboardWillShowNotification)
//                .compactMap { $0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue }
//                .map { $0.cgRectValue.height },
//            NotificationCenter.default
//                .publisher(for: UIResponder.keyboardWillHideNotification)
//                .map { _ in CGFloat(0) }
//        ).eraseToAnyPublisher()
//    }
//    
//    var body: some View {
//        
//        ZStack {
//            GeometryReader { geo in
//                VStack {
//                    if therapistChatModel.getConversation().count > 0{
//                        ScrollViewReader{ proxy in
//                            Button("refresh") {
//                                therapistChatModel.restart()
//                            }
//                            .frame(height: 10)
//                            ScrollView {
//                                ForEach(therapistChatModel.getConversation() , id: \.id) { msg in
//                                    MessageView(currentMessage: msg)
//                                        .listRowSeparator(.hidden)
//                                }.listRowBackground(ColorPallet.greenBackground)
//                            }
//                            .scrollContentBackground(.hidden)
//                            .background(ColorPallet.greenBackground)
//                            .padding([.top], 20)
//                            .padding([.bottom], 15)
//                            .padding([.leading, .trailing], 16)
//                            .onReceive(keyboardHeightPublisher) { _ in
//                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
//                                    withAnimation {
//                                        proxy.scrollTo(therapistChatModel.getConversation()[therapistChatModel.getConversation().count - 1].id)
//                                    }
//                                }
//                            }
//                            .onReceive(therapistChatModel.$isUserTurnToSpeak, perform: { _ in
//                                
//                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
//                                    withAnimation {
//                                        proxy.scrollTo(therapistChatModel.getConversation()[therapistChatModel.getConversation().count - 1].id)
//                                    }
//                                }
//                            })
//                            
//                        }
//                        
//                    }else{
//                        Rectangle()
//                            .foregroundColor(ColorPallet.greenBackground)
//                    }
//                    
//                    
//                    if therapistChatModel.isUserTurnToSpeak {
//                        
//                        VStack{
//                            speechInputView()
//                            
//                            HStack {
//                                TextField("", text: $userMessage, axis: .vertical)
//                                    .textFieldStyle(ChatWithAiTextField())
//                                    .modifier(PlaceholderStyle(showPlaceHolder: userMessage.isEmpty,
//                                                               placeholder: setPlaceHolder ? "" : "What's on your mind today?"))
//                                    .background(.white)
//                                    .frame(height: CGFloat(70))
//                                    .cornerRadius(15)
//                                    .foregroundColor(.black)
//
//                                HStack {
//                                    sendBtnView()
//                                    speechBtnView()
//                                }
//                            }.frame(height: 70, alignment: .bottom)
//                                .padding()
//                                .padding([.top], 0)
////                                .background(ColorPallet.greenBackground)
//                            
//                        }
//                        .frame(height: 70)
//                        .padding([.bottom], isRecording ? 10 : 0)
//                        .offset(y: -10)
//                        
//                        
//                    }else{
//                        CircleLoading()
//                    }
//                }
//            }
//        }
//        .onTapGesture {
//            self.hideKeyboard()
//        }
//        .background(ColorPallet.greenBackground)
//    }
//    
//    func sendMessage() {
//        therapistChatModel.sendMessage(userMessage)
//        therapistChatModel.speechRecognizer.transcript = ""
//        userMessage = ""
//    }
//    
//    func onAiResponse() {
//        
//    }
//    
//    private func speechBtnView() -> some View {
//        Button {
//            isRecording.toggle()
//            
//            if isRecording {
//                micManager.startMonitoring()
//                therapistChatModel.speechRecognizer.reset()
//                therapistChatModel.speechRecognizer.transcribe()
//            }else{
//                therapistChatModel.speechRecognizer.stopTranscribing()
//                userMessage = therapistChatModel.speechRecognizer.transcript
//            }
//        } label: {
//            Image(systemName: isRecording ? "stop.fill" : "mic.fill")
//                .font(.system(size: 20))
//                .padding()
//                .cornerRadius(10)
//                .foregroundColor(ColorPallet.darkColor)
//        }
//    }
//    
//    
//    
//    private func sendBtnView() -> some View {
//        Button {
//            setPlaceHolder = true
//            sendMessage()
//        } label: {
//            Image(systemName: "paperplane.circle.fill")
//                .font(.system(size: 20))
//                .padding()
//                .cornerRadius(10)
//                .foregroundColor(ColorPallet.darkColor)
//        }
//    }
//    
//    private func speechInputView() -> some View {
//        HStack {
//            RoundedRectangle(cornerRadius: 20)
//                .fill(Color.black.opacity(0.7))
//                .padding()
//                .overlay {
//                    VStack{
//                        visualizerView()
//                    }
//                }
//                .opacity(isRecording ? 1 : 0)
//            
//        }.frame(height: isRecording ? CGFloat(50) : CGFloat(0))
//            .padding(isRecording ? CGFloat(10) : CGFloat(0))
//            .background(ColorPallet.greenBackground)
//    }
//    
//    private func visualizerView() -> some View {
//        VStack{
//            HStack(spacing: 3){
//                ForEach(micManager.soundSample, id: \.self) { level in
//                    SpeechVisualBarView(value: self.normalizedSoundeLevel(level: level))
//                }
//            }
//        }
//    }
//    
//    private func normalizedSoundeLevel(level: Float) -> CGFloat {
//        let level = max(0.2, CGFloat(level) + 50) / 2
//        return CGFloat(level)
//    }
//    
//    init(therapistChatModel: TherapyChatModel? = nil) {
//        self.therapistChatModel = therapistChatModel ?? TherapyChatModel()
//        UITableView.appearance().separatorStyle = .none
//        UITableView.appearance().tableFooterView = UIView()
//        UITableViewCell.appearance().backgroundColor = UIColor(ColorPallet.greenBackground) //ColorPallet.greenBackground
//        UITableView.appearance().backgroundColor = UIColor(ColorPallet.greenBackground)
//    }
//}
//
//struct CircleLoading: View {
//    @State private var circleSize: CGFloat = 25
//    @State private var isAtMaxScale = false
//    private let animation = Animation.easeInOut(duration: 0.5).repeatForever(autoreverses: true)
//
//    
//    var body: some View {
//        Circle()
//            .fill(LinearGradient(gradient: Gradient(colors: [ColorPallet.blueUserMessage, ColorPallet.blueUserMessage]), startPoint: .top, endPoint: .bottom))
//            .frame(width: circleSize, height: circleSize)
//            .scaleEffect(isAtMaxScale ? 1 : 0)
//            .offset(y: -25)
//            .onAppear{
//                withAnimation(animation) {
//                    isAtMaxScale.toggle()
//                }
//            }
//    }
//    
//    func changeCircleSize()  {
//        circleSize = (circleSize == 0) ? 25 : 0
//    }
//}
//
//struct ChatWithAiTextField: TextFieldStyle {
//    func _body(configuration: TextField<Self._Label>) -> some View {
//        configuration
//            .frame(height: 70)
//    }
//}
//
//
//extension UIApplication {
//    func endEditing() {
//        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
//    }
//}
//
//
//struct TherapyChatView_Previews: PreviewProvider {
//    static var previews: some View {
//        TherapyChatView()
//    }
//}
//
//
