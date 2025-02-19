//
//  AuthenticationViewModel.swift
//  AITherapist
//
//  Created by Cyrus Refahi on 9/7/23.
//

import SwiftUI
import Combine

// MARK: - Routing

extension AuthenticationView {
//    struct Routing: Equatable {
//        var countryDetails: Country.Code?
//    }
}

// MARK: - ViewModel

extension AuthenticationView {
    class ViewModel: ObservableObject {
        
        @Published var canRequestPushPermission: Bool = false
        var alertMessage: AlertMessage = .None
        
        // Misc
        let container: DIContainer
        private var cancelBag = CancelBag()
        private var currentNonce: String? = ""
        var user: Loadable<User>{
            get{
                self.container.appState[\.userData.user]
            }set{
                self.container.appState[\.userData.user] = newValue
            }
        }
        
        init(container: DIContainer) {
            self.container = container
        }
        
        func retry(){
            self.container.appState[\.userData].logout()
        }
        
        func requestPushPermission() {
            container.services.userPermissionsService
                .request(permission: .pushNotifications)
        }
        
        func login(email: String, password: String){
            container.services.authenticationService.loginUser(email: email, password: password)
        }
        
        func register(name: String, email: String, password: String, mobileNumber: String) {
            container.services.authenticationService.registerUser(name: name, email: email, password: password, mobileNumber: mobileNumber)
        }
    }
}

// MARK: - Locale Reader

extension AuthenticationView {
//    struct LocaleReader: EnvironmentalModifier {
//
//        let viewModel: ViewModel
//
//        func resolve(in environment: EnvironmentValues) -> some ViewModifier {
//            viewModel.countriesSearch.locale = environment.locale
//            return DummyViewModifier()
//        }
//
//        private struct DummyViewModifier: ViewModifier {
//            func body(content: Content) -> some View {
//                // Cannot return just `content` because SwiftUI
//                // flattens modifiers that do nothing to the `content`
//                content.onAppear()
//            }
//        }
//    }
}

extension AuthenticationView {
    enum AlertMessage: String {
        case None = ""
        case WrongEmailFormat = "Email is not in correct format"
        case MobileFieldEmpty = "mobile field is empty"
        case EmailFieldEmpty = "Email field is empty"
        case NameFieldEmpty = "Name field is empty"
        case PasswordFieldEmpty = "Password field is empty"
        case PasswordRepetitionDoesNotMatch = "Password and repeated password does not match"
    }
}

