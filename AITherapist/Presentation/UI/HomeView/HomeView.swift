//
//  InsightView.swift
//  AITherapist
//
//  Created by Cyrus Refahi on 9/17/23.
//

import SwiftUI
import Combine

struct InsightView: View {
    @ObservedObject private(set) var viewModel: ViewModel
    
    @State private var showingModalSheet = false
    @State private var isAnimatingMood = false
    @Binding private var showNewConversationChatView: Bool
    
    @State var chartXPosAnchor: Double
    @State var chartType: ChartView.ChartType = .line
    
    @Namespace private var insightNamespace
    private let moods: [Mood]
    
    init(viewModel: ViewModel, showingModalSheet: Bool = false, isAnimatingMood: Bool = false, moods: [Mood] = [], showNewConversationChatView: Binding<Bool>) {
        self.viewModel = viewModel
        self.showingModalSheet = showingModalSheet
        self.isAnimatingMood = isAnimatingMood
        
        self.moods = viewModel.insight.value?.getDailyMoodsArray() ?? moods
        self._showNewConversationChatView = showNewConversationChatView
        self.chartXPosAnchor = Double(Date.now.timeIntervalSince1970)
    }
    
    var body: some View {
        MoodAnalyticsView(namespace: insightNamespace, isSource: showingModalSheet, showBackButton: true, withOptions: true, shown: $showingModalSheet, chartType: $chartType, chartXPosAnchor: $chartXPosAnchor, moods: self.moods)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .opacity(showingModalSheet ? 1 : 0)
        
        ScrollView{
            LazyVStack{
                WelcomeToHomeTitleView(name: self.viewModel.name)
                    .opacity(isAnimatingMood ? 1 : 0)
                QuoteView(quote: self.viewModel.quote)
                
                if (self.viewModel.userInsightEmptyValues()) {
                    createNewConversationButton
                }else{
                    LazyVStack{
                        Divider()
                        MoodAnalyticsView(namespace: insightNamespace, isSource: !showingModalSheet, showBackButton: false, withOptions: false, shown: $showingModalSheet, chartType: $chartType, chartXPosAnchor: $chartXPosAnchor, moods: self.moods)
                            .opacity(isAnimatingMood ? 1 : 0)
                            .offset(x: isAnimatingMood ? 0 : -50, y: 0)
                            .onTapGesture{
                                withAnimation {
                                    showingModalSheet.toggle()
                                }
                            }
                        Divider()
                        
                        GeneralSummaryView(generalSummaryText: self.viewModel.generalSummary)
                        
                        Divider()
                        
                        activityView
                            .padding(.bottom, 16)
                        
                        Divider()
                    }
                    .opacity(isAnimatingMood ? 1 : 0)
                    .offset(x: isAnimatingMood ? 0 : -50, y: 0)
                }
            }
        }
        .opacity(showingModalSheet ? 0 : 1)
        .frame(width: UIViewController().view.bounds.width)
        .frame(maxHeight: .infinity)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.spring.delay(1)) {
                    self.isAnimatingMood = true
                }
            }
        }
    }
    
    @ViewBuilder var activityView: some View{
        ActivityView(viewModel: .init(container: self.viewModel.container))
    }
    
    @ViewBuilder var createNewConversationButton: some View{
        Button {
            self.showNewConversationChatView = true
        } label: {
            Text("Create a new Conversation")
                .padding(.horizontal, 30)
                .padding(.vertical, 5)
                .frame(height: 54, alignment: .center)
                .background(ColorPallet.SolidDarkGreen)
                .foregroundStyle(ColorPallet.Celeste)
                .cornerRadius(50)
                .opacity(isAnimatingMood ? 1 : 0)
                .offset(x: isAnimatingMood ? 0 : -50, y: 0)
                .padding(.top, 50)
        }
    }
    
    @ViewBuilder var background: some View {
        ZStack{
            Rectangle()
                .fill(ColorPallet.HomePageGradientBackground)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            Image("EarBG")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .matchedGeometryEffect(id: "MainBackground", in: insightNamespace)
        .ignoresSafeArea()
    }
}

extension InsightView {
    struct QuoteView: View {
        let quote: String
        @State private var isAnimatingQuote = false
        private let animationTime = 1.25
        
        var body: some View {
            ZStack{
                if isAnimatingQuote {
                    AnimatableText(text: quote)
                        .font(
                            Font.custom("SF Pro Text", size: 15)
                                .weight(.semibold)
                        )
                        .frame(maxHeight: .infinity, alignment: .center)
                }
            }
            .padding(10)
            .background{
                ZStack {
                    GeometryReader { geo in
                        Image(systemName: "quote.opening")
                            .resizable()
                            .frame(width: 20, height: 16.67364, alignment: .center)
                            .scaledToFit()
                            .position(.init(x: 0, y: 0))
                            .offset(x: 5, y: 5)
                            .foregroundStyle(ColorPallet.DarkBlue)
                        Image(systemName: "quote.closing")
                            .resizable()
                            .frame(width: 20, height: 16.67364, alignment: .center)                            .scaledToFit()
                            .position(.init(x: geo.size.width, y: geo.size.height))
                            .offset(x: -5, y: -5)
                            .foregroundStyle(ColorPallet.DarkBlue)
                    }
                }
                .opacity(isAnimatingQuote ? 1 : 0)
                .offset(x: isAnimatingQuote ? 0 : 20, y: isAnimatingQuote ? 0 : 20)
            }
            .overlay{
                GeometryReader{ geo in
                    if isAnimatingQuote {
                        AnimatingBorder(width: geo.size.width + 24, height: geo.size.height + 24, cornerRadius: 5, lineWidth: 5, fadeAnimationTime: self.animationTime)
                            .offset(x: -11, y: -11)
                    }
                }
            }
            .padding(16)
            .padding([.leading, .trailing], 32)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    withAnimation(.spring(duration: animationTime)) {
                        self.isAnimatingQuote = true
                    }
                }
            }
        }
    }
}

struct MoodAnalyticsView: View {
    var namespace: Namespace.ID
    let isSource: Bool
    let showBackButton: Bool
    
    let withOptions: Bool
    @Binding var shown: Bool
    
    @Binding var chartType: ChartView.ChartType
    @Binding var chartXPosAnchor: Double
    let moods: [Mood]
    
    var body: some View {
        VStack{
            
            exitButton
            
            titleText
            
            Spacer()
            
            ChartView(chartType: $chartType, chartPosXCordinator: $chartXPosAnchor, isSource: isSource, chartNamespace: self.namespace, withChartOption: withOptions, moods: self.moods)
                .frame(maxHeight: 300)
                .frame(width: UIViewController().view.bounds.width)
            
            Spacer()
        }
    }
    
    @ViewBuilder var exitButton: some View{
        Button {
            withAnimation(Animation.spring) {
                shown.toggle()
            }
        } label: {
            Image(systemName: "x.circle.fill")
                .resizable()
                .frame(width: 25, height: 25)
                .padding([.leading], 8)
        }
        .foregroundStyle(.red)
        .frame(maxWidth: .infinity, alignment: .leading)
        .hiddenModifier(isHide: !showBackButton)
    }
    
    @ViewBuilder var titleText: some View {
        Text("Track your mood to discover personal patterns and gain self-insight.")
            .multilineTextAlignment(.center)
            .foregroundColor(ColorPallet.DarkBlueText)
            .frame(width: 293, height: 46, alignment: .top)
            .hiddenModifier(isHide: !showBackButton)
    }
}

struct GeneralSummaryView: View {
    let generalSummaryText: String
    
    var body: some View {
        VStack{
            Text("General Summary")
                .font(
                Font.custom("SF Pro Text", size: 17)
                    .weight(.bold)
            )
            .foregroundStyle(ColorPallet.DarkBlueText)
            Text(generalSummaryText)
                .font(Font.custom("SF Pro Text", size: 15))
                .multilineTextAlignment(.center)
                .padding([.top], 8)
            
                .foregroundStyle(ColorPallet.DarkBlueText)
        }
        .padding()
    }
}

struct WelcomeToHomeTitleView: View {
    var name: String = "John"
    
    var body: some View {
        Text("Welcome \(name)")
            .font(
                Font.custom("SF Pro Text", size: 17)
                    .weight(.bold)
            )
            .foregroundStyle(ColorPallet.DarkBlue)
            .lineLimit(1)
            .padding()
    }
}

extension InsightView {
    class ViewModel: ObservableObject {
        let container: DIContainer
        let isRunningTests: Bool
        private var cancelBag: CancelBag = CancelBag()
        
        var insight: Loadable<Insight>{
            get{
                return self.container.appState[\.userData.insight]
            }set{
                self.container.appState[\.userData.insight] = newValue
            }
        }
        
        var name: String {
            get{
                self.container.appState[\.userData.user].value?.name ?? ""
            }
        }
        
        var quote: String{
            get{
                self.insight.value?.quote ?? "Happiness is not something ready made. It comes from your own actions"
            }
        }
        
        var generalSummary: String{
            get{
                self.insight.value?.generalSummary ?? "No General Summary"
            }
        }
        
        init(container: DIContainer, isRunningTests: Bool = false, anyCancellable: AnyCancellable? = nil) {
            self.container = container
            self.isRunningTests = isRunningTests
            
            container.appState.value.userData.objectWillChange.sink { (_) in
                self.objectWillChange.send()
            }
            .store(in: cancelBag)
        }
        
        func userInsightEmptyValues() -> Bool {
            self.insight.value?.generalSummary == nil || self.insight.value?.dailyMoods.count == 0
        }
    }
}

#if DEBUG
struct InsightView_Previews: PreviewProvider {
    static var previews: some View {
        InsightView(viewModel: .init(container: .previews), showNewConversationChatView: Binding.constant(false))
    }
}
#endif
