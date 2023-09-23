//
//  MainView.swift
//  AITherapist
//
//  Created by cyrus refahi on 9/17/23.
//

import SwiftUI

struct MainView: View {
    
    @ObservedObject private(set) var viewModel: ViewModel
    
    var body: some View {
        TabView{
            InsightView()
                .tabItem {
                    Label("Insight", systemImage: "figure.mind.and.body")
                }
            TherapyChatView()
                .tabItem {
                    ZStack {
                        Label("Chat", systemImage: "bubble.middle.bottom.fill")
                            .overlay {
                                Circle()
                                    .frame(width: 50, height: 50)
                                    .background(.green)
                            }
                        
                    }
                }
            BreathingView()
                .tabItem{
                    Label("Meditation", systemImage: "camera.macro")
                }
        }
        
        .background(Color(red: 180/255, green: 255/255, blue: 150/255))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
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

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(viewModel: MainView.ViewModel(container: .preview ))
    }
}
