//
//  MainView.swift
//  AITherapist
//
//  Created by cyrus refahi on 9/17/23.
//

import SwiftUI
import Combine

struct MainView: View {
    @ObservedObject private(set) var viewModel: ViewModel
    
    var body: some View {
        AvaNavigationView{
            VStack(spacing: 0){
                MainTabContentView()
                    .padding([.leading, .trailing], 16)
                    .environmentObject(viewModel)
                
                TabView()
                    .environmentObject(viewModel)
            }
            .fullScreenCover(isPresented: $viewModel.showNewChat, content: {
                NewChatView(viewModel: .init(coninater: self.viewModel.container), show: $viewModel.showNewChat)
            })
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
        @Namespace var tabTopViewNameSpace
        
        var body: some View {
            VStack{
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
                .frame(height: 75)
                .frame(maxWidth: .infinity)
                .background(Color(.systemGray5))
                .avaNavigationBarBackButtonHidden(true)
                .avaNavigationBarTitle(self.viewModel.navigationTitle)
                .avaNavigationBarBackground(self.viewModel.showNavigationBackground)
                .avaNavigationLogOutBackButtonHidden(self.mainViewState != .Profile)
            }
            .offset(x: 0, y: isAnimatingTabBar ? 0 : 200)
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
            TabIcon(imageName: "house", title: "Home", isSelected: self.mainViewState == .Home, tabTopViewNameSpace: tabTopViewNameSpace) {
                if self.mainViewState == .Home { return }
                self.viewModel.mainViewState.send(.Home)
                self.mainViewState = .Home
                self.viewModel.navigationTitle = ""
                self.viewModel.showNavigationBackground = false
            }
        }
        
        @ViewBuilder var chatHistoryTabIcon: some View {
            TabIcon(imageName: "bubble.left.and.bubble.right", title: "Conversations", isSelected: self.mainViewState == .ChatHistory, tabTopViewNameSpace: tabTopViewNameSpace) {
                if self.mainViewState == .ChatHistory { return }
                self.viewModel.mainViewState.send(.ChatHistory)
                self.mainViewState = .ChatHistory
                self.viewModel.navigationTitle = "Conversation"
                self.viewModel.showNavigationBackground = false
            }
        }
        
        @ViewBuilder var journalTabIcon: some View {
            TabIcon(imageName: "magazine.fill", title: "Journal", isSelected: self.mainViewState == .Journal, tabTopViewNameSpace: tabTopViewNameSpace) {
                if self.mainViewState == .Journal { return }
                self.viewModel.mainViewState.send(.Journal)
                self.mainViewState = .Journal
                self.viewModel.navigationTitle = "Journal"
                self.viewModel.showNavigationBackground = true
            }
        }
        
        @ViewBuilder var profileTabIcon: some View {
            TabIcon(imageName: "person.crop.circle", title: "Profile", isSelected: self.mainViewState == .Profile, tabTopViewNameSpace: tabTopViewNameSpace) {
                if self.mainViewState == .Profile { return }
                self.viewModel.mainViewState.send(.Profile)
                self.mainViewState = .Profile
                self.viewModel.navigationTitle = ""
                self.viewModel.showNavigationBackground = false
            }
        }
        
        struct TabIcon: View {
            var imageName: String = ""
            var title: String = ""
            var isSelected: Bool = false
            
            let tabTopViewNameSpace: Namespace.ID
            var onTabClick: () -> ()
            var body: some View {
                
                Button {
                    onTabClick()
                } label: {
                    VStack(spacing: 5){
                        Rectangle().fill(ColorPallet.SecondaryColorGreen).frame(height: 5).offset(x: 0, y: -8)
                            .matchedGeometryEffect(id: "TabIconEffect", in: tabTopViewNameSpace, isSource: isSelected)
                            .animation(.bouncy, value: isSelected)
                        Image(systemName: self.imageName)
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 32, height: 32)
                        Text(self.title)
                            .font(
                                Font.custom("SF Pro Text", size: 10)
                                    .weight(.medium)
                            )
                            .multilineTextAlignment(.center)
                        
                            .font(.caption)
                    }
                    .foregroundStyle(isSelected ? ColorPallet.SecondaryColorGreen : .gray)
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
                    .foregroundColor(Color(.systemGray5))
                    .shadow(color: .black, radius: 0.5, x: 0, y: 1)
                Circle()
                    .frame(width: 75, height: 75)
                    .foregroundColor(ColorPallet.SecondaryColorGreen)
                Image(systemName: "plus.message")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50, height: 50)
                    .foregroundStyle(.white)
                Text("New Conversation")
                    .font(
                        Font.custom("SF Pro Text", size: 7)
                            .weight(.bold)
                            .bold()
                    )
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color(red: 0.55, green: 0.55, blue: 0.55))
                    .offset(y: 54.5)
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
        @State fileprivate var insightView: LoadableTabViw<InsightView> = .notLoaded
        
        var body: some View {
            mainContentView
                .onReceive(viewModel.mainViewState) { value in
                    self.viewState = value
                }
        }
        
        @ViewBuilder var mainContentView: some View {
            
            ZStack{
                LodableTabView(viewState: .Home, initialDelay: 0){
                    InsightView(viewModel: .init(container: self.viewModel.container))
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
    class ViewModel: ObservableObject {
        var mainViewState: CurrentValueSubject<MainViewState, Never> = .init(.Home)
        @Published var showNewChat: Bool = false
        
        @Published var navigationTitle: String = ""
        @Published var showNavigationBackground: Bool = false
        
        let container: DIContainer
        
        init(container: DIContainer) {
            self.container = container
        }
    }
}

private extension MainView {
    enum LoadableTabViw<T> {
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
        @State var lodableView: LoadableTabViw<Content> = .notLoaded
        
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

#Preview{
    MainView(viewModel: MainView.ViewModel(container: .preview ))
}
