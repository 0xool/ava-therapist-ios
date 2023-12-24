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
    
    var body: some View {
        Group {
            if viewModel.isRunningTests {
                Text("Running unit tests")
            }else if (PersistentManager.UserHasFinishedOnboarding()){
                Text("OnboardingView")
            }else{
                if self.viewModel.user.value == nil
                { LoginView } else { MainAppView }
            }
        }
        .background(Color(red: 220/255, green: 255/255, blue: 253/255))
        .animation(.easeIn, value: self.viewModel.user)
    }
    
    @ViewBuilder var LoginView: some View {
        AuthenticationView(viewModel: .init(container: viewModel.container))
            .attachEnvironmentOverrides(onChange: viewModel.onChangeHandler)
            .modifier(RootViewAppearance(viewModel: .init(container: viewModel.container)))
    }
    
    @ViewBuilder var splashView: some View {
        AuthenticationBackgroundView()
    }
    
    @ViewBuilder var MainAppView: some View {
        ZStack{
            splashView
            switch(self.viewModel.insight) {
            case .notRequested: // if we haven't started requesting the data yet
                Text("Not requested")
                    .onAppear(){
                        self.viewModel.container.services.insightService.loadInsight()
                    }
            case .isLoading(_, _): // if we're waiting for the data to come back
                Text("Loading")
            case .loaded(_): // if we've got the data back
                MainView(viewModel: .init(container: viewModel.container))
            case let .failed(error): // if the request failed
                failedView(error: error)
            case .partialLoaded(_):
                Text("Not requested")
            }
        }
    }
}

extension MainAppView {
    func failedView(error: Error) -> some View {
        ErrorView(error: error) {
            self.viewModel.getUserInsight( )
        }
    }
}

// MARK: - ViewModel

extension MainAppView {
    class ViewModel: ObservableObject {
        
        let container: DIContainer
        let isRunningTests: Bool
        var anyCancellable: AnyCancellable? = nil
        
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
            self.container.services.authenticationService.checkUserLoggedStatus()
            
            getUserInsight()
            
            anyCancellable = container.appState.value.userData.objectWillChange.sink { (_) in
                self.objectWillChange.send()
            }
        }
        
        func getUserInsight() {
            insight = .notRequested
            self.container.services.insightService.checkInsight()
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
        MainAppView(viewModel: MainAppView.ViewModel(container: .preview))
    }
}
#endif
