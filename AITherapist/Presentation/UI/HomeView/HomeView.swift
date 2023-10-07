//
//  InsightView.swift
//  AITherapist
//
//  Created by cyrus refahi on 9/17/23.
//

import SwiftUI
import Combine

struct InsightView: View {
    @State private var showingModalSheet = false
    
    var body: some View {
        ScrollView{
            WelcomeToHomeTitleView()
            QuoteView
            Divider()
            MoodAnalyticsView()
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
        .padding([.top], 75)        
        .frame(width: UIViewController().view.bounds.width)
        .frame(maxHeight: .infinity)
        .overlay{
            NavBarView()
        }
    }
    
    @ViewBuilder var QuoteView: some View {
        ZStack{
            Text("Lorem ipsum dolor sit amet consectetur. Lorem ipsum dolor sit amet consectetur. Lorem ipsum dolor sit amet consectetur.")
                .foregroundStyle(.white)
                .font(.title3)
                .frame(maxHeight: .infinity, alignment: .center)
        }
        .frame(height: 125)
        .padding([.trailing, .leading], 10)
        .background{
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundStyle(.gray)
                RoundedRectangle(cornerRadius: 10)
                    .stroke(.black, lineWidth: 2)
                    .offset(x: -10, y: -10)
                    
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
            Text("Last time we talk, you were sad about Llorem ipsum dolor sit amet consectetur. Tempus dui vitae vivamus diam habitasse metus aliquet rhoncus. Potenti nulla pulvinar neque tellus lectus sit.")
                .font(.caption)
                .padding([.top], 8)
        }
        .padding()
        
    }
}

struct WelcomeToHomeTitleView: View {
    var name: String = "Nick"
    
    var body: some View {
        Text("Welcome to your safe place, \(name)!")
            .font(.title2)
            .lineLimit(1)
            .padding()
    }
}

struct NavBarView: View {
    
    var body: some View {
        Content
    }
    
    @ViewBuilder var HelpLineView: some View {
        ZStack{

            Text("Helplines")
                .foregroundStyle(.black)
                .font(helpLineFont)
                .padding(8)
        }
        .background{
            RoundedRectangle(cornerSize: CGSize(width: 50, height: 50))
                .foregroundStyle(.green)
                
        }
        .padding(8)

    }
    
    @ViewBuilder var Content: some View {
        ZStack {
            HStack(alignment: .center){
                Button {
                    // Open
                } label: {
                    Image(systemName: "gearshape.fill")
                        .font(.largeTitle)
                        .foregroundStyle(.gray)
                        .padding([.leading], 8)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                LogoIcon()
                    .frame(maxWidth: .infinity, alignment: .center)
                
                HelpLineView
                    .frame(maxWidth: .infinity, alignment: .trailing)
                
            }
            
        }
        .frame(width: UIScreen.main.bounds.width, height: 70)
        .frame(maxHeight: .infinity, alignment: .top)
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
