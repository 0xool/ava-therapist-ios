//
//  SpeechManager.swift
//  AITherapist
//
//  Created by cyrus refahi on 3/3/23.
//

import Foundation
import AVFoundation

class SpeakManager {
    
    static let instance: SpeakManager = SpeakManager()
    
    func readOut(text: String) {
        let synth = AVSpeechSynthesizer()

        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        
        synth.speak(utterance)
    }
    
    
}
