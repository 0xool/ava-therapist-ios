//
//  InsightView.swift
//  AITherapist
//
//  Created by cyrus refahi on 9/17/23.
//

import SwiftUI
import Combine

struct InsightView: View {
    var body: some View {
        
        Text("InsightView")
    }
}

extension InsightView {
    class ViewModel: ObservableObject {
        let container: DIContainer
        let isRunningTests: Bool
        var anyCancellable: AnyCancellable? = nil
        
        init(container: DIContainer, isRunningTests: Bool, anyCancellable: AnyCancellable? = nil) {
            self.container = container
            self.isRunningTests = isRunningTests
            
            self.anyCancellable = container.appState.value.userData.objectWillChange.sink { (_) in
                self.objectWillChange.send()
            }
        }
    }
}

struct InsightView_Previews: PreviewProvider {
    static var previews: some View {
        InsightView()
    }
}
