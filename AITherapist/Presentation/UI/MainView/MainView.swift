//
//  MainView.swift
//  AITherapist
//
//  Created by Cyrus Refahi on 9/17/23.
//

import SwiftUI
import Combine

struct MainView: View {
    @ObservedObject private(set) var viewModel: ViewModel
    
    var body: some View {
        ZStack{
            AvaNavigationView{
                VStack(spacing: 0){
                    MainTabContentView()
                        .padding([.leading, .trailing], 16)
                        .environmentObject(viewModel)
                    TabView(userName: self.viewModel.getUsername())
                        .environmentObject(viewModel)
                }
                .fullScreenCover(isPresented: $viewModel.showNewChat, content: {
                    NewChatView(viewModel: .init(coninater: self.viewModel.container), show: $viewModel.showNewChat)
                        
                })
                .ignoresSafeArea()
            } background: {
                background
            }
        }
    }
}

extension MainView{
    enum MainViewState {
        case Home
        case ChatHistory
        case Journal
        case Profile
    }
}

extension MainView {
    struct TabView: View {
        @EnvironmentObject var viewModel: ViewModel
        @State private var mainViewState: MainViewState = .Home
        @State private var isAnimatingTabBar: Bool = false
        
        private let tabBarSize: CGFloat = 105
        let userName: String
        @Namespace var tabTopViewNameSpace
        
        var body: some View {
            ZStack{
                Rectangle()
                    .fill(ColorPallet.Celeste)
                    .frame(height: tabBarSize)
                    .frame(maxWidth: .infinity)
                    .shadow(color: ColorPallet.DarkGreen, radius: 4, x: 0, y: -1)
                    .mask(Rectangle().padding(.top, -10))
                    .ignoresSafeArea()
        
                HStack{
                    self.homeTabIcon
                        .navigationTitle("")
                    self.chatHistoryTabIcon
                    NewChatTabIconMenu()
                        .onTapGesture {
                            withAnimation{
                                viewModel.showNewChat.toggle()
                            }
                        }
                    self.journalTabIcon
                        .navigationTitle("Journal")
                    self.profileTabIcon
                }
                .frame(height: tabBarSize)
                .frame(maxWidth: .infinity)
                .offset(y: -16)
                .avaNavigationBarTitle(self.viewModel.navigationTitle)
                .avaNavigationBarBackground(self.viewModel.showNavigationBackground)
                .avaNavigationBarTopLeftButton(self.mainViewState == .Profile ? .logOut : .nothing)
            }
            .offset(x: 0, y: isAnimatingTabBar ? 0 : 200)
            .padding([.trailing, .leading], 16)
            .onAppear{
                if !isAnimatingTabBar {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        withAnimation(.linear(duration: 0.75)) {
                            isAnimatingTabBar.toggle()
                        }
                    }
                }
            }
        }
        
        @ViewBuilder var homeTabIcon: some View {
            TabIcon(imageName: "house", filledImageName: "house.fill", title: "Home", isSelected: self.mainViewState == .Home, tabTopViewNameSpace: tabTopViewNameSpace) {
                if self.mainViewState == .Home { return }
                self.viewModel.mainViewState.send(.Home)
                self.mainViewState = .Home
                self.viewModel.navigationTitle = ""
                self.viewModel.showNavigationBackground = false
            }
        }
        
        @ViewBuilder var chatHistoryTabIcon: some View {
            TabIcon(imageName: "bubble.left.and.bubble.right", filledImageName: "bubble.left.and.bubble.right.fill", title: "Conversations", isSelected: self.mainViewState == .ChatHistory, tabTopViewNameSpace: tabTopViewNameSpace) {
                if self.mainViewState == .ChatHistory { return }
                self.viewModel.mainViewState.send(.ChatHistory)
                self.mainViewState = .ChatHistory
                self.viewModel.navigationTitle = "Conversation"
                self.viewModel.showNavigationBackground = false
            }
        }
        
        @ViewBuilder var journalTabIcon: some View {
            TabIcon(imageName: "magazine", filledImageName: "magazine.fill", title: "Journal", isSelected: self.mainViewState == .Journal, tabTopViewNameSpace: tabTopViewNameSpace) {
                if self.mainViewState == .Journal { return }
                self.viewModel.mainViewState.send(.Journal)
                self.mainViewState = .Journal
                self.viewModel.navigationTitle = "Journal"
                self.viewModel.showNavigationBackground = true
            }
        }
        
        @ViewBuilder var profileTabIcon: some View {
            TabIcon(imageName: "person", filledImageName: "person.fill", title: "\(userName)", isSelected: self.mainViewState == .Profile, tabTopViewNameSpace: tabTopViewNameSpace) {
                if self.mainViewState == .Profile { return }
                self.viewModel.mainViewState.send(.Profile)
                self.mainViewState = .Profile
                self.viewModel.navigationTitle = ""
                self.viewModel.showNavigationBackground = false
            }
        }
        
        struct TabIcon: View {
            var imageName: String = ""
            var filledImageName: String = ""
            var title: String = ""
            
            var isSelected: Bool = false
            let tabTopViewNameSpace: Namespace.ID
            var onTabClick: () -> ()
            
            var body: some View {                
                Button {
                    onTabClick()
                } label: {
                    VStack(spacing: 5){
                        Rectangle().fill(ColorPallet.DarkGreen).frame(height: 5).offset(x: 0, y: -8)
                            .matchedGeometryEffect(id: "TabIconEffect", in: tabTopViewNameSpace, isSource: isSelected)
                            .animation(.bouncy, value: isSelected)
                        Image(systemName: isSelected ? self.filledImageName : self.imageName)
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 32, height: 32)
                        Text(self.title)
                          .font(
                            Font.custom("SF Pro Text", size: 10)
                              .weight(.medium)
                          )
                          .multilineTextAlignment(.center)
                    }
                    .foregroundStyle(isSelected ? ColorPallet.DarkGreen : .gray)
                    .frame(maxWidth: .infinity)
                }
            }
        }
    }
}

extension MainView {
    struct NewChatTabIconMenu: View {
        var body: some View {
            ZStack{
                Circle()
                    .frame(width: 80, height: 80)
                    .foregroundColor(ColorPallet.Celeste)
                    .shadow(color: ColorPallet.DarkGreen, radius: 0.5, x: 0, y: 1)
                Circle()
                    .frame(width: 75, height: 75)
                    .foregroundColor(ColorPallet.MediumTurquoiseBlue)
                Image(systemName: "plus.message")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50, height: 50)
                    .foregroundStyle(ColorPallet.DarkGreen)
                Text("New Chat")
                    .font(
                        Font.custom("SF Pro Text", size: 10)
                            .weight(.medium)
                    )
                    .multilineTextAlignment(.center)
                    .font(.caption)
                    .foregroundColor(ColorPallet.DarkGreen)
                    .offset(y: 60.2)
            }
            .offset(y: -36)
            .zIndex(20)
        }
    }
}

extension MainView {
    struct MainTabContentView: View {
        @EnvironmentObject var viewModel: ViewModel
        @State var viewState: MainViewState = .Home
        @State fileprivate var insightView: LoadableTabView<InsightView> = .notLoaded
        
        var body: some View {
            mainContentView
                .onReceive(viewModel.mainViewState) { value in
                    self.viewState = value
                }
        }
        
        @ViewBuilder var mainContentView: some View {
            
            ZStack{
                LodableTabView(viewState: .Home, initialDelay: 0){
                    InsightView(viewModel: .init(container: self.viewModel.container), showNewConversationChatView: $viewModel.showNewChat)
                }
                .opacity(self.viewState == .Home ? 1 : 0)
                
                LodableTabView(viewState: .ChatHistory){
                    ConversationListView(viewModel: .init(coninater: self.viewModel.container))
                }
                .opacity(self.viewState == .ChatHistory ? 1 : 0)
                
                LodableTabView(viewState: .Journal){
                    JournalView(viewModel: .init(container: self.viewModel.container))
                }
                .opacity(self.viewState == .Journal ? 1 : 0)
                
                LodableTabView(viewState: .Profile, initialDelay: 0){
                    ProfileView(viewModel: .init(container: self.viewModel.container))
                }
                .opacity(self.viewState == .Profile ? 1 : 0)
            }
            //            .avaNavigationLogOutBackButtonHidden(s true)
            .environmentObject(viewModel)
        }
    }
}

extension MainView {
    enum MainViewBackground {
        case blueGradientBackground
        case cicleBackground
        case defaultBackground
    }
    
    @ViewBuilder private var  cicleBackgroundView: some View {
        TwoCircleBackgroundView(backgroundColor: .white, animate: true)
            .opacity(0.3)
            .ignoresSafeArea()
    }
    
    @ViewBuilder private var background: some View {
        switch self.viewModel.mainViewBackground {
        case .blueGradientBackground:
            TabViewBackground()
        case .cicleBackground:
            cicleBackgroundView
        case .defaultBackground:
            EmptyView()
        }
    }
}

extension MainView {
    enum LoadableTabView<T> {
        case notLoaded
        case loaded(T)
        
        var value: T? {
            switch self {
            case let .loaded(value): return value
            default: return nil
            }
        }
    }
    
    struct LodableTabView<Content>: View where Content: View{
        @EnvironmentObject var viewModel: ViewModel
        @State var lodableView: LoadableTabView<Content> = .notLoaded
        
        var content: Content
        var viewState: MainViewState
        let initialDelay: Double
        
        init(viewState: MainViewState, initialDelay: Double = 0.05, @ViewBuilder content: () -> Content) {
            self.viewState = viewState
            self.content = content()
            self.initialDelay = initialDelay
        }
        
        var body: some View {
            lodableView.value
                .id(viewState)
                .onReceive(viewModel.mainViewState) { value in
                    if value == viewState {
                        if self.initialDelay == 0 {
                            lodableView = .loaded(content)
                        }else{
                            DispatchQueue.main.asyncAfter(deadline: .now() + self.initialDelay) {
                                lodableView = .loaded(content)
                            }
                        }
                    }
                }
        }
    }
}

extension MainView {
    class ViewModel: ObservableObject {
        var mainViewState: CurrentValueSubject<MainViewState, Never> = .init(.Home)
        var showNewChat: Bool{
            get{
                self.container.appState[\.application.showNewChat]
            }set{
                self.container.appState[\.application.showNewChat] = newValue
            }
        }
        
        @Published var navigationTitle: String = ""
        @Published var showNavigationBackground: Bool = false
        @Published var mainViewBackground: MainViewBackground = .blueGradientBackground
        
        let container: DIContainer
        private var anyCancellable: AnyCancellable? = nil
        
        init(container: DIContainer) {
            self.container = container
            
            anyCancellable = container.appState.value.application.objectWillChange.sink { (_) in
                self.objectWillChange.send()
            }
        }
        
        func getUsername() -> String {
            self.container.appState[\.userData.user].value?.userName.capitalizingFirstLetter() ?? "Profile"
        }
    }
}

#if DEBUG
#Preview{
    MainView(viewModel: MainView.ViewModel(container: .previews ))
}
#endif
