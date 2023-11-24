//
//  InsightView.swift
//  AITherapist
//
//  Created by cyrus refahi on 9/17/23.
//

import SwiftUI
import Combine

struct InsightView: View {
    @ObservedObject private(set) var viewModel: ViewModel

    @State private var showingModalSheet = false
    @State private var isAnimatingQuote = false
    @State private var isAnimatingMood = false
    
    private let animationTime = 1.25
    
    var body: some View {
        ScrollView{
            VStack{
                WelcomeToHomeTitleView()
                    .opacity(isAnimatingMood ? 1 : 0)
                QuoteView
                VStack{
                    Divider()
                    MoodAnalyticsView()
                        .opacity(isAnimatingMood ? 1 : 0)
                        .offset(x: isAnimatingMood ? 0 : -50, y: 0)
                        .onTapGesture{
                            withAnimation {
                                showingModalSheet.toggle()
                            }
                        }
                        .sheet(isPresented: $showingModalSheet) {
                            MoodAnalyticsView()
                        }
                    
                    Divider()
                    GeneralSummaryView()
                    Divider()
                }
                .opacity(isAnimatingMood ? 1 : 0)
                .offset(x: isAnimatingMood ? 0 : -50, y: 0)
            }
        }
        .frame(width: UIViewController().view.bounds.width)
        .frame(maxHeight: .infinity)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.spring(duration: animationTime)) {
                    isAnimatingQuote.toggle()
                }
                
                withAnimation(.spring.delay(1)) {
                    isAnimatingMood.toggle()
                }
            }
        }
    }
    
    @ViewBuilder var QuoteView: some View {
            ZStack{
                if isAnimatingQuote {
                    AnimatableText(text: "Happiness is not something ready     made. It comes from your own actions")
                        .frame(maxHeight: .infinity, alignment: .center)
                }
        }
        .padding(10)
        .background{
            ZStack {
                GeometryReader { geo in
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.gray)
                    Image(systemName: "quote.opening")
                        .resizable()
                        .frame(width: 33, height: 25, alignment: .center)
                        .scaledToFit()
                        .position(.init(x: 0, y: 0))
                        .offset(x: 15, y: -2)
                    Image(systemName: "quote.closing")
                        .resizable()
                        .frame(width: 33, height: 25, alignment: .center)
                        .scaledToFit()
                        .position(.init(x: geo.size.width, y: geo.size.height))
                        .offset(x: -15, y: 2)
                }
            }
            .opacity(isAnimatingQuote ? 1 : 0)
            .offset(x: isAnimatingQuote ? 0 : 20, y: isAnimatingQuote ? 0 : 20)
        }
        .overlay{
            GeometryReader{ geo in
                if isAnimatingQuote {
                    AnimatingBorder(width: geo.size.width, height: geo.size.height, cornerRadius: 5, lineWidth: 1, fadeAnimationTime: self.animationTime)
                        .offset(x: -6, y: -6)
                }
            }
        }
        .padding(16)
    }
}

struct MoodAnalyticsView: View {
    var body: some View {
        ChartView()
    }
}

struct GeneralSummaryView: View {
    var body: some View {
        VStack{
            Text("General Summary")
                .font(.title3)
            Text("You have been seeing therapist Ava and have shared your emotions and concerns with her. You discussed feeling blessed and the importance of positivity and gratitude. You also talked about having a good day and the positive emotions you experienced. Ava encouraged you to focus on enjoyable activities to manage stress. You read a book suggested by Ava and found it helpful in improving your mood. It made you realize the power you have to change your thoughts and emotions. One quote that resonated with you was Happiness is not something ready made. It comes from your own actions.")
                .font(.caption)
                .padding([.top], 8)
        }
        .padding()
    }
}

struct WelcomeToHomeTitleView: View {
    var name: String = "Cyrus"
    
    var body: some View {
        Text("Welcome to your safe place, \(name)!")
            .font(.title2)
            .lineLimit(1)
            .padding()
    }
}

extension InsightView {
    class ViewModel: ObservableObject {
        let container: DIContainer
        let isRunningTests: Bool
        private var cancelBag: CancelBag = CancelBag()
        
        init(container: DIContainer, isRunningTests: Bool = false, anyCancellable: AnyCancellable? = nil) {
            self.container = container
            self.isRunningTests = isRunningTests
            
            container.appState.value.userData.objectWillChange.sink { (_) in
                self.objectWillChange.send()
            }
            .store(in: cancelBag)            
        }
    }
}

struct InsightView_Previews: PreviewProvider {
    static var previews: some View {
        InsightView(viewModel: .init(container: .preview))
    }
}
