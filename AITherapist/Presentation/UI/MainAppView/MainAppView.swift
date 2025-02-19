//
//  MainContentView.swift
//  AITherapist
//
//  Created by Cyrus Refahi on 9/3/23.
//

import SwiftUI
import Combine
import EnvironmentOverrides

// MARK: - View
struct MainAppView: View {
    @ObservedObject private(set) var viewModel: ViewModel
    @Namespace var mainViewNameSpace
    
    @State private var showBG: Bool = true
    
    var body: some View {
        Group {
            if viewModel.isRunningTests {
                Text("Running unit tests")
            }else if (PersistentManager.instance.userHasFinishedOnboarding()){
                Text("OnboardingView")
            }else{
                if self.viewModel.initalLoading {
                    splashView
                }else{
                    if self.viewModel.user.value == nil
                    {
                        loginView
                    } else {
                        if self.viewModel.hasSeenNotification
                        {
                            mainAppView
                        } else{
                            notificationView
                        }
                    }
                }
            }
        }
    }
    
    @ViewBuilder var loginView: some View {
        AuthenticationView(viewModel: .init(container: viewModel.container))
            .environmentObject(NamespaceWrapper(self.mainViewNameSpace))
            .attachEnvironmentOverrides(onChange: viewModel.onChangeHandler)
            .modifier(RootViewAppearance(viewModel: .init(container: viewModel.container)))
    }
    
    @ViewBuilder var splashView: some View {
        loadingView()
            .matchedGeometryEffect(id: "MainBackground", in: mainViewNameSpace, isSource: showBG)
    }
    
    @ViewBuilder var notificationView: some View{
        NotificationView(viewModel: .init(notificationViewSeen: self.$viewModel.hasSeenNotification))
    }
    
    @ViewBuilder var mainAppView: some View {
        ZStack{
            switch(self.viewModel.insight) {
            case .notRequested: // if we haven't started requesting the data yet
                Text("Not requested")
                    .onAppear(){
                        self.viewModel.getUserInsight()
                    }
            case .isLoading(_, _): // if we're waiting for the data to come back
                loadingView()
            case .loaded(_): // if we've got the data back
                MainView(viewModel: .init(container: viewModel.container))
                    .onAppear{
                        withAnimation{
                            showBG = false
                        }
                    }
            case let .failed(error): // if the request failed
                failedView(error: error)
            case .partialLoaded(_, _):
                Text("Not requested")
            }
        }.background(
            splashView
                .hiddenModifier(isHide: !showBG)
        )
    }
}

extension MainAppView {
    func failedView(error: Error) -> some View {
        ErrorView(error: error) {
            self.viewModel.getUserInsight()
        }
    }
    
    func loadingView() -> some View {
        // show logged in successfully
        ZStack{
            TabViewBackground()
            CircleLoading()
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        }
    }
}

// MARK: - ViewModel

extension MainAppView {
    class ViewModel: ObservableObject {
        let container: DIContainer
        let isRunningTests: Bool
        var anyCancellable: AnyCancellable? = nil
        
        @Published var initalLoading: Bool = true
        @Published var hasSeenNotification: Bool
        
        var user: Loadable<User>{
            get{
                self.container.appState[\.userData.user]
            }set{
                self.container.appState[\.userData.user] = newValue
            }
        }
        
        var insight: Loadable<Insight>{
            get{
                self.container.appState[\.userData.insight]
            }set{
                self.container.appState[\.userData.insight] = newValue
            }
        }
        
        init(container: DIContainer, isRunningTests: Bool = ProcessInfo.processInfo.isRunningTests){
            self.container = container
            self.isRunningTests = isRunningTests
            self.hasSeenNotification = PersistentManager.instance.getNotificationSeen()

            self.container.services.authenticationService.checkUserStatus(loading: self.bindingSubject(\.initalLoading))
            
            
            
            anyCancellable = container.appState.value.userData.objectWillChange.sink { (_) in
                self.objectWillChange.send()
            }
        }
        
        func getUserInsight() {
            self.container.services.insightService.loadInsight()
        }
        
        var onChangeHandler: (EnvironmentValues.Diff) -> Void {
            return { diff in
                if !diff.isDisjoint(with: [.locale, .sizeCategory]) {
                    self.container.appState[\.routing] = AppState.ViewRouting()
                }
            }
        }
    }
}
// MARK: - Preview
#if DEBUG
struct MainContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainAppView(viewModel: MainAppView.ViewModel(container: .previews))
    }
}
#endif
