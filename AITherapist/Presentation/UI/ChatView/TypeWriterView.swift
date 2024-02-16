//
//  TypeWriterView.swift
//  AITherapist
//
//  Created by cyrus refahi on 2/15/24.
//

import SwiftUI

struct TypeWriterView: View {
    
    // MARK: - Properties
    
    private let text:String
    private let speed:TimeInterval
    @State var isStarted: Bool
    @State private var textArray:String = ""
    
    init(_ text: String, speed: TimeInterval = 0.1, isStarted: Bool = false) {
        self.text = text
        self.speed = speed
        self.isStarted = isStarted
    }
    
    // MARK: - Body
    var body: some View {
        Text(textArray)
            .onAppear{
                startAnimate()
            }
    }
}

// MARK: - TypeWriterView

extension TypeWriterView{
    
    // TODO: - startAnimate
    
    private func startAnimate(){
        DispatchQueue.global().async {
            let _ = text.map {
                Thread.sleep(forTimeInterval: speed)
                textArray += $0.description
            }
        }
    }
}
