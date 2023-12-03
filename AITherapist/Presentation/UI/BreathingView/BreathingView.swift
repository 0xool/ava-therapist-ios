//
//  SwiftUIView.swift
//  AITherapist
//
//  Created by Cyrus Refahi on 9/17/23.
//

import SwiftUI

struct BreathingView: View {
    @State private var grow = false // Scale the middle from 0.5 to 1
    @State private var rotateFarRight = false
    @State private var rotateFarLeft = false
    @State private var rotateMiddleLeft = false
    @State private var rotateMiddleRight = false
    @State private var showShadow = false
    @State private var showRightStroke = false
    @State private var showLeftStroke = false
    @State private var changeColor = false
    
    var body: some View {
        VStack {
            Spacer()
            
            // Pull content from DetailsViwl.swift
            JustBreatheDetailsView()
            
            Spacer()
            ZStack {
                
                Image("Flower") // Middle
                    .scaleEffect(grow ? 1 : 0.5, anchor: .bottom)
                    .animation(.easeInOut(duration: 2).delay(2).repeatForever(autoreverses: true), value: grow)
                    
                
                Image("Flower")  // Middle left
                    .rotationEffect(.degrees( rotateMiddleLeft ? -25 : -5), anchor: .bottom)
                    .animation(.easeInOut(duration: 2).delay(2).repeatForever(autoreverses: true), value: rotateMiddleLeft)
                    .onAppear {
                        rotateMiddleLeft.toggle()
                    }
                
                Image("Flower")  // Middle right
                    .rotationEffect(.degrees( rotateMiddleRight ? 25 : 5), anchor: .bottom)
                    .animation(.easeInOut(duration: 2).delay(2).repeatForever(autoreverses: true), value: rotateMiddleRight)
                
                
                Image("Flower")  // Left
                    .rotationEffect(.degrees( rotateFarLeft ? -50 : -10), anchor: .bottom)
                    .animation(.easeInOut(duration: 2).delay(2).repeatForever(autoreverses: true), value: rotateFarLeft)
                
                Image("Flower")  // Right
                    .rotationEffect(.degrees( rotateFarRight ? 50 : 10), anchor: .bottom)
                    .animation(.easeInOut(duration: 2).delay(2).repeatForever(autoreverses: true), value: rotateFarRight)
                
                Circle()  // Quarter dotted circle left
                    .trim(from: showLeftStroke ? 0 : 1/4, to: 1/4)
                    .stroke(style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round, dash: [1, 14]))
                    .frame(width: 215, height: 215, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .foregroundColor(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)))
                    .rotationEffect(.degrees(-180), anchor: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .offset(x: 0, y: -25)
                    .animation(.easeInOut(duration: 2).delay(2).repeatForever(autoreverses: true), value: showLeftStroke)
                
                Circle()  // Quarter dotted circle right
                    .trim(from: 0, to: showRightStroke ? 1/4 : 0)
                    .stroke(style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round, dash: [1, 14]))
                    .frame(width: 215, height: 215, alignment: .center)
                    .foregroundColor(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)))
                    .rotationEffect(.degrees(-90), anchor: .center)
                    .offset(x: 0, y: -25)
                    .animation(.easeInOut(duration: 2).delay(2).repeatForever(autoreverses: true), value: showRightStroke)
                
            } // Container for flower
            .shadow(radius: showShadow ? 20 : 0) // Switching from flat to elevation
            .hueRotation(Angle(degrees: changeColor ? -235 : 45)) // Animating Chroma
            .animation(.easeInOut(duration: 2).delay(2).repeatForever(autoreverses: true), value: changeColor)
            .frame(width: UIScreen.main.bounds.width)
            
            Spacer()
            
        } // Container for all views
        .background(Color(red: 180/255, green: 255/255, blue: 150/255))
        .frame(width: UIScreen.main.bounds.width)
        .onAppear {
            changeColor.toggle()
            showShadow.toggle()
            showRightStroke.toggle()
            showLeftStroke.toggle()
            rotateFarRight.toggle()
            rotateFarLeft.toggle()
            rotateMiddleRight.toggle()
            grow.toggle()
        }
        
    }
}

struct BreathingView_Previews: PreviewProvider {
    static var previews: some View {
        BreathingView()
    }
}

extension BreathingView {
    enum BreathingState {
        case inhale, exhale
    }

    struct JustBreatheDetailsView: View {
        
        @State private var breatheIn = true
        @State private var breatheOut = false
        
        var body: some View{
            
            VStack{
                Text("Just Breathe")
                    .font(.largeTitle)
                
                Text("Conquer the anxiety of life")
                    .font(.title)
                
                Text("Live in the moment")
                    .font(.title2)
                
                ZStack {
                    Text("Breathe Out")
                        .opacity(breatheOut ? 0 : 1) // Opacity animation
                        .animation(.easeInOut(duration: 2).delay(2).repeatForever(autoreverses: true), value: breatheOut)
                    
                    Text("Breathe In")
                        .opacity(breatheIn ? 0 : 1)
                        .scaleEffect(breatheIn ? 0 : 1, anchor: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        .animation(.easeInOut(duration: 2).delay(2).repeatForever(autoreverses: true), value: breatheIn)
                    
                }
                
                .onAppear() {
                    breatheOut.toggle()
                    breatheIn.toggle()
                }
                .padding(.top, 50)
                
            }
        }
    }
}
