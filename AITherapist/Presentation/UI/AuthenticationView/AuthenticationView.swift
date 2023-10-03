//
//  AuthenticationView.swift
//  AITherapist
//
//  Created by cyrus refahi on 9/7/23.
//

import SwiftUI
import Combine
import Lottie

struct AuthenticationView: View {
    
    @ObservedObject private(set) var viewModel: ViewModel
    @State var email: String = ""
    @State var password: String = ""
    
    @State var show: Bool = false
    @State private var showingAlert = false
    
    var body: some View {
        self.content
            .background(Color(red: 220/255, green: 255/255, blue: 253/255))        
    }
    
    @ViewBuilder private var content: some View {
        
        switch viewModel.container.appState[\.userData.user] {
        case .notRequested:
            SplashScreen()
        case let .isLoading(last, _):
            loadingView(last)
        case let .loaded(user):
            loadedView(user, showLoading: false)
        case let .failed(error):
            failedView(error)
        }
    }
    
    private var permissionsButton: some View {
        Group {
            if viewModel.canRequestPushPermission {
                Button(action: viewModel.requestPushPermission, label: { Text("Allow Push") })
            } else {
                EmptyView()
            }
        }
    }
}

struct AnimatedSplashView: UIViewRepresentable {
    let loopMode: LottieLoopMode
    @Binding var show: Bool
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
    
    func makeUIView(context: Context) -> Lottie.LottieAnimationView {
        let animationView = LottieAnimationView(name: "splashScreen")
        //        (filePath: "AITherapist/Resources/Assets/AfterEffects/splashScreen.json")
        animationView.play{ status in
            if status{
                withAnimation(.interactiveSpring(response: 0.7, dampingFraction: 0.5, blendDuration: 1)){
                    show.toggle()
                }
            }
        }
        animationView.loopMode = loopMode
        animationView.contentMode = .scaleAspectFit
        return animationView
    }
}

extension  AuthenticationView {
    func SplashScreen() -> some View {
        VStack{
            Color(red: 220/255, green: 255/255, blue: 253/255)
                .ignoresSafeArea()
            ZStack{
                VStack{
                    AnimatedSplashView(loopMode: .playOnce, show: $show)
                        .frame(width: UIScreen.main.bounds.width/2 ,height: UIScreen.main.bounds.height/3)
                        .scaleEffect(0.2)
                    VStack{
                        HStack{
                            VStack(alignment: .leading, content: {
                                Text("Login")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                
                                Text("Enter email here")
                                    .foregroundColor(.gray)
                            })
                            
                            Spacer(minLength: 15)
                        }
                        
                        VStack(){
                            HStack(){
                                TextField("Email", text: $email)
                                    .textFieldStyle(.roundedBorder)
                                    .padding()
                            }
                            
                            HStack(){
                                TextField("Passwrod", text: $password)
                                    .textFieldStyle(.roundedBorder)
                                    .padding()
                            }
                            
                            Divider()
                                .background(.white)
                        }
                        .padding(.vertical)
                        
                        Button {
                            self.loginWithCheking()
                        } label: {
                            Text("Login")
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding(.vertical, 10)
                                .frame(width: UIScreen.main.bounds.width - 60)
                                .background(Color(red: 63/255, green: 124/255, blue: 172/255))
                                .clipShape(Capsule())
                        }
                        .alert(viewModel.alertMessage.rawValue, isPresented: $showingAlert) {
                            Button("OK", role: .cancel) { }
                        }
                        
                        HStack{
                            Rectangle()
                                .fill(Color.white.opacity(0.3))
                                .frame(height: 1)
                            Text("OR")
                                .foregroundColor(Color.white.opacity(0.3))
                                .fontWeight(.bold)
                            Rectangle()
                                .fill(Color.white .opacity(0.3))
                                .frame(height: 1)
                        }
                        .padding(.vertical)
                        
                        
                        HStack(spacing: 10) {
                            
                            
                            Button {
                                
                            } label: {
                                HStack{
                                    Image("fb")
                                        .resizable()
                                        .foregroundColor(.white)
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 25, height: 25)
                                    Text("Facebook")
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                }
                                .frame(width: (UIScreen.main.bounds.width - 80) / 2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding(.vertical, 10)
                                .background(.blue)
                                .clipShape(Capsule())
                            }
                            
                            Button {
                                
                            } label: {
                                HStack{
                                    Image("google")
                                        .resizable()
                                        .foregroundColor(.white)
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 25, height: 25)
                                    Text("Google")
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                }
                                .frame(width: (UIScreen.main.bounds.width - 80) / 2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding(.vertical, 10)
                                .background(.red)
                                .clipShape(Capsule())
                            }
                            
                        }
                        
                    }
                    .padding()
                    .background(Color(red: 0/255, green: 59/255, blue: 54/255))
                    
                    .cornerRadius(20)
                    .padding()
                    .frame(height: show ? nil : 0)
                    .opacity(show ? 1 : 0)
                }
            }
        }
    }
    
    private func emailIsValid() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{3}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    private func loginWithCheking(){
        if (email == ""){
            viewModel.alertMessage = .EmailFieldEmpty
            showingAlert = true
        }else if (password == "") {
            viewModel.alertMessage = .PasswordFieldEmpty
            showingAlert = true
        }else if (!emailIsValid()){
            viewModel.alertMessage = .WrongEmailFormat
            showingAlert = true
        }else {
            self.viewModel.login(email: email, password: password)
        }
    }
}

private extension AuthenticationView {
    //    var notRequestedView: some View {
    //        //        Text("").onAppear(perform: self.viewModel.reloadCountries)
    //        AnimatedSpashView(loopMode: .loop)
    //            .scaleEffect(0.4)
    //            .foregroundColor(.red)
    //    }
    
    func loadingView(_ previouslyLoaded: User?) -> some View {
        if let user = previouslyLoaded {
            return AnyView(loadedView(user, showLoading: true))
        } else {
            return AnyView(ActivityIndicatorView().padding())
        }
    }
    
    func loadedView(_ user: User, showLoading: Bool) -> some View {
        VStack {
            if showLoading {
                ActivityIndicatorView().padding()
            }
            Text(user.token)
        }.padding(.bottom, bottomInset)
        
        
    }
    
    func failedView(_ error: Error) -> some View {
        ErrorView(error: error, retryAction: {
            print("Error!!")
            //            self.viewModel.reloadCountries()
            
        })
    }
    
    var bottomInset: CGFloat {
        if #available(iOS 14, *) {
            return 0
        } else {
            //            return self.viewModel.countriesSearch.keyboardHeight
            return 0
        }
    }
}



#if DEBUG
struct AuthenticationView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticationView(viewModel: .init(container: .preview))
    }
}
#endif
