//
//  MainView.swift
//  AITherapist
//
//  Created by cyrus refahi on 9/17/23.
//

import SwiftUI

enum MainViewState {
    case Home
    case ChatHistory
    case Journal
    case Profile
}

struct MainView: View {
    @ObservedObject private(set) var viewModel: ViewModel
    @State var mainViewState: MainViewState = .Home
    @State var showNewChat: Bool = false
    
    @State private var isAnimatingTabBar: Bool = false
    @State var navigationTitle: String = ""
    @State var showNavigationBackground: Bool = false
    
    @Namespace var tabTopViewNameSpace
#warning("Handel this namespace accordingly")
    @Namespace var journalViewNameSpace
    
    @ViewBuilder var homeTabIcon: some View {
        TabIcon(imageName: "house", title: "Home", isSelected: self.mainViewState == .Home, tabTopViewNameSpace: tabTopViewNameSpace) {
            self.mainViewState = .Home
            self.navigationTitle = ""
            self.showNavigationBackground = false
        }
    }
    
    @ViewBuilder var chatHistoryTabIcon: some View {
        TabIcon(imageName: "bubble.left.and.bubble.right", title: "Conversations", isSelected: self.mainViewState == .ChatHistory, tabTopViewNameSpace: tabTopViewNameSpace) {
            self.mainViewState = .ChatHistory
            self.navigationTitle = "Conversation"
            self.showNavigationBackground = false
        }
    }
    
    @ViewBuilder var journalTabIcon: some View {
        TabIcon(imageName: "magazine.fill", title: "Journal", isSelected: self.mainViewState == .Journal, tabTopViewNameSpace: tabTopViewNameSpace) {
            self.mainViewState = .Journal
            self.navigationTitle = "Journal"
            self.showNavigationBackground = true
        }
    }
    
    @ViewBuilder var profileTabIcon: some View {
        TabIcon(imageName: "person.crop.circle", title: "Profile", isSelected: self.mainViewState == .Profile, tabTopViewNameSpace: tabTopViewNameSpace) {
            self.mainViewState = .Profile
            self.navigationTitle = ""
            self.showNavigationBackground = false
        }
    }
    
    @ViewBuilder var mainContentView: some View {
        switch self.mainViewState {
        case .Home:
            InsightView()
        case .ChatHistory:
            ConversationListView(viewModel: .init(coninater: viewModel.container))
        case .Journal:
            JournalView(namespace: journalViewNameSpace, viewModel: .init(container: self.viewModel.container))
        case .Profile:
            BreathingView()
        }
    }
    
    var body: some View {
        AvaNavigationView{
            VStack(spacing: 0){
                Spacer()
                mainContentView
                    .frame(width: UIViewController().view.bounds.width)
                VStack{
                    HStack{
                        self.homeTabIcon
                            .navigationTitle("")
                        self.chatHistoryTabIcon
                        NewChatTabIconMenu()
                            .onTapGesture {
                                withAnimation{
                                    showNewChat.toggle()
                                }
                            }
                        self.journalTabIcon
                            .navigationTitle("Journal")
                        self.profileTabIcon
                    }
                    .frame(height: 75)
                    .frame(maxWidth: .infinity)
                    .background(Color(.systemGray5))
                }
                .offset(x: 0, y: isAnimatingTabBar ? 0 : 200)

            }
            .avaNavigationBarBackButtonHidden(true)
            .avaNavigationBarTitle(self.navigationTitle)
            .avaNavigationBarBackground(self.showNavigationBackground)
            .fullScreenCover(isPresented: $showNewChat, content: {
                NewChatView(viewModel: .init(coninater: self.viewModel.container), show: $showNewChat)
            })
        }
        .onAppear{
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.linear(duration: 0.75)) {
                    isAnimatingTabBar.toggle()
                }
            }
        }
    }
}

extension MainView {
    class ViewModel: ObservableObject {
        let container: DIContainer
        
        init(container: DIContainer) {
            self.container = container
        }
    }
}

extension MainView {
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
                Text("New chat")
                    .font(
                        Font.custom("SF Pro Text", size: 10)
                            .weight(.medium)
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

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(viewModel: MainView.ViewModel(container: .preview ))
    }
}
