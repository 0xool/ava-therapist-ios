//
//  MainContentView.swift
//  AITherapist
//
//  Created by cyrus refahi on 9/3/23.
//

import SwiftUI
import Combine
import EnvironmentOverrides

// MARK: - View
struct MainContentView: View {
    
    @ObservedObject private(set) var viewModel: ViewModel
    
    var body: some View {
        Group {
            if viewModel.isRunningTests {
                Text("Running unit tests")
            }else if (PersistentManager.UserHasFinishedOnboarding()){
                Text("OnboardingView")
            }else{
                if viewModel.container.appState[\.userData.user].value == nil
                { LoginView } else { MainAppView }
            }
        }
        .background(Color(red: 220/255, green: 255/255, blue: 253/255))
        .animation(.easeIn, value: viewModel.container.appState[\.userData.user])
    }
    
    @ViewBuilder var LoginView: some View {
        AuthenticationView(viewModel: .init(container: viewModel.container))
            .attachEnvironmentOverrides(onChange: viewModel.onChangeHandler)
            .modifier(RootViewAppearance(viewModel: .init(container: viewModel.container)))
    }
    
    @ViewBuilder var MainAppView: some View {
        switch(viewModel.container.appState[\.userData.insight]) {
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
            Text(error.localizedDescription)
        }
    }
}

// MARK: - ViewModel

extension MainContentView {
    class ViewModel: ObservableObject {
        
        let container: DIContainer
        let isRunningTests: Bool
        var anyCancellable: AnyCancellable? = nil
        
        init(container: DIContainer, isRunningTests: Bool = ProcessInfo.processInfo.isRunningTests){
            self.container = container
            self.isRunningTests = isRunningTests
            self.container.services.authenticationService.checkUserLoggedStatus()
            self.container.services.insightService.checkInsight()
            
            anyCancellable = container.appState.value.userData.objectWillChange.sink { (_) in
                self.objectWillChange.send()
            }
        }
        
        var onChangeHandler: (EnvironmentValues.Diff) -> Void {
            return { diff in
                if !diff.isDisjoint(with: [.locale, .sizeCategory]) {
                    self.container.appState[\.routing] = AppState.ViewRouting()
                }
            }
        }
        
        //        func loadCountries() {
        //            self.container.services.conversationService.loadConversationList(conversations: loadableSubject(\.conversations))
        //        }
    }
}

// MARK: - Preview

#if DEBUG
struct MainContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainContentView(viewModel: MainContentView.ViewModel(container: .preview))
    }
}
#endif
