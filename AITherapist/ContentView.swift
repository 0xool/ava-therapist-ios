//
//  ContentView.swift
//  AITherapist
//
//  Created by cyrus refahi on 3/2/23.
//

import SwiftUI

struct ContentView: View {
    
    @State private var breatheIn: Bool = false
    @State private var animationTime: Double = 3
    @State private var instructionText: String = "Breath In"
    @State private var showText: Bool = true
    
    @State private var minScale: Double = 1
    @State private var circleSize: CGFloat  = 60
    
    var body: some View {
            ZStack{
                LinearGradient(colors: [.blue, .blue], startPoint: .topLeading, endPoint: .bottomTrailing)
                VStack{
                    Text(instructionText)
                        .opacity(showText ? 1 : 0)
                        .offset(y:-100)
                        
                    Circle()
                        .fill(LinearGradient(gradient: Gradient(colors: [ColorPallet.greenBackground, ColorPallet.greenBackground]), startPoint: .top, endPoint: .bottom))
                        .frame(width: circleSize, height: circleSize)
                        .scaleEffect(breatheIn ? 3 : minScale)
                        
                }
            }
            .edgesIgnoringSafeArea(.all)
            .onAppear{
                withAnimation(.easeIn(duration: animationTime)) {
                    breatheIn.toggle()
                    showText.toggle()
                    StartBreathingAnimationProcess()
                }
            }
    }
    
    func StartBreathingAnimationProcess() {

        DispatchQueue.main.asyncAfter(deadline: .now() + animationTime) {
            instructionText = "Hold For 2 Seconds"
            showText = true
            withAnimation(.easeIn(duration: 5)) {
                showText.toggle()
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                animationTime = 5
                instructionText = "Now Breath Out"
                showText = true
                minScale = 0

                withAnimation(.easeIn(duration: animationTime)) {
                    showText.toggle()
                    breatheIn.toggle()
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
                    withAnimation(.linear(duration: 1)) {
                        minScale = 1
                        circleSize = 1000
                    }
                }
            }
        }
    }
    
    func BreathOutStart() {
        
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
