//
//  AnimatingBorder.swift
//  AITherapist
//
//  Created by cyrus refahi on 11/21/23.
//

import SwiftUI

struct AnimatingBorder: View {
    @State private var dashPhase: CGFloat = -55
    @State private var fadeInAnimation: Bool = false
    
    let width: CGFloat
    let height: CGFloat
    let cornerRadius: CGFloat
    
    let lineWidth: CGFloat
    let fadeAnimationTime: Double
    
    private var dashLineSize: CGFloat {
        (Circumference / 2) - dashSize
    }
    
    private var dashSize: CGFloat {
        40
    }
    
    private var Circumference: CGFloat {
        let straightSegments = 2 * (width - 2 * cornerRadius) + 2 * (height - 2 * cornerRadius)
        let quarterCircles = 4 * (Double.pi * cornerRadius / 2.0)
        
        let circumference = straightSegments + quarterCircles
        
        return circumference
    }
    
    var body: some View {
        VStack{
            
        }
        .frame(width: self.width, height: self.height, alignment: .center)
        .background(.black)
        .mask{
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(style: .init(lineWidth: lineWidth, lineCap: .round, lineJoin: .round,  dash: [dashLineSize, dashSize, dashLineSize, dashSize], dashPhase: dashPhase))
        }
        .opacity(fadeInAnimation ? 1 : 0)
        .onAppear{
            withAnimation(.linear(duration: 150).repeatForever(autoreverses: false)){
                dashPhase = (self.width + self.height + 35) * -1
            }
            
            withAnimation(.linear(duration: fadeAnimationTime).delay(1)) {
                fadeInAnimation = true
            }
        }
    }
}

#Preview {
    AnimatingBorder(width: 340, height: 100, cornerRadius: 25, lineWidth: 1, fadeAnimationTime: 2)
}
