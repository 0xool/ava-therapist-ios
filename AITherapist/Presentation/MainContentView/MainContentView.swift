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
            }else{
                Text("WOOOOHOOOOO!!!!")
            }
            
            
//            } else {
//                CountriesList(viewModel: .init(container: viewModel.container))
//                    .attachEnvironmentOverrides(onChange: viewModel.onChangeHandler)
//                    .modifier(RootViewAppearance(viewModel: .init(container: viewModel.container)))
//            }
        }
    }
}

// MARK: - ViewModel

extension MainContentView {
    class ViewModel: ObservableObject {
        
        let container: DIContainer
        let isRunningTests: Bool
        
        init(container: DIContainer, isRunningTests: Bool = ProcessInfo.processInfo.isRunningTests) {
            self.container = container
            self.isRunningTests = isRunningTests
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
        MainContentView(viewModel: MainContentView.ViewModel(container: .preview))
    }
}
#endif
