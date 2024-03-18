//
//  Mood.swift
//  AITherapist
//
//  Created by Cyrus Refahi on 9/24/23.
//

import RealmSwift
import Foundation
import Charts

class Mood: Object, Codable, Identifiable {
    var id: UUID = UUID()
    @Persisted var moodType: MoodType = .EmotionNotDetected
    @Persisted var dateCreated: Date
    @Persisted var moodString: String
    
    enum CodingKeys: String, CodingKey {
        case mood = "MoodID"
        case dateCreated = "DateCreated"
        case moodString = "Mood"
    }
    
    required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let moodID = try container.decode(Int.self, forKey: .mood)
        
        let mood = MoodType(rawValue: moodID)
        let dateCreated = Date.convertStringToDate(try container.decode(String.self, forKey: .dateCreated))
        
        let moodString = try container.decode(String.self, forKey: .moodString)
        self.init(mood: mood, dateCreated: dateCreated, moodString: moodString)
    }
    
    convenience init(mood: MoodType, dateCreated: Date, moodString: String) {
        self.init()
        self.moodType = mood
        self.dateCreated = dateCreated
        self.moodString = moodString
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(moodType.rawValue, forKey: .mood)
        try container.encode(dateCreated.description, forKey: .dateCreated)
        try container.encode(moodString, forKey: .moodString)
    }
}

enum MoodType: String, PersistableEnum {
    case Happy
    case Sad
    case Angry
    case Anxious
    case Depressed
    case Excited
    case Frustrated
    case Guilty
    case Lonely
    case Nervous
    case Tired
    case Worried
    case Stressed
    case EmotionNotDetected
    
    var mood : String {
        switch self {
        case .Happy:
            "Happy"
        case .Sad:
            "Sad"
        case .Angry:
            "Angry"
        case .Anxious:
            "Anxious"
        case .Depressed:
            "Depressed"
        case .Excited:
            "Excited"
        case .Frustrated:
            "Frustrated"
        case .Guilty:
            "Guilty"
        case .Lonely:
            "Lonely"
        case .Nervous:
            "Nervous"
        case .Tired:
            "Tired"
        case .Worried:
            "Worried"
        case .Stressed:
            "Stressed"
        case .EmotionNotDetected:
            "EmotionNotDetected"
        }
    }
    
    var moodIntValue : Int {
        switch self {
        case .Happy:
            1
        case .Sad:
            2
        case .Angry:
            3
        case .Anxious:
            4
        case .Depressed:
            5
        case .Excited:
            6
        case .Frustrated:
            7
        case .Guilty:
            8
        case .Lonely:
            9
        case .Nervous:
            10
        case .Tired:
            11
        case .Worried:
            12
        case .Stressed:
            13
        case .EmotionNotDetected:
            14
        }
    }
    
    var emoji : String {
        switch self {
        case .Happy:
            "😊"
        case .Sad:
            "😢"
        case .Angry:
            "😡"
        case .Anxious:
            "😰"
        case .Depressed:
            "😞"
        case .Excited:
            "😃"
        case .Frustrated:
            "😤"
        case .Guilty:
            "😔"
        case .Lonely:
            "😔"
        case .Nervous:
            "😨"
        case .Tired:
            "😴"
        case .Worried:
            "😟"
        case .Stressed:
            "😖"
        case .EmotionNotDetected:
            "😶"
        }
    }

    init(rawValue: Int) {
        switch rawValue {
        case 1:
            self = .Happy
        case 2:
            self = .Sad
        case 3:
            self = .Angry
        case 4:
            self = .Anxious
        case 5:
            self = .Depressed
        case 6:
            self = .Excited
        case 7:
            self = .Frustrated
        case 8:
            self = .Guilty
        case 9:
            self = .Lonely
        case 10:
            self = .Nervous
        case 11:
            self = .Tired
        case 12:
            self = .Worried
        case 13:
            self = .Stressed
        default:
            self = .EmotionNotDetected
        }
        
    }
}

func getMoodEmojiFromString(mood: String?) -> String {
    MoodType(primitivePlottable: mood ?? "EmotionNotDetected")?.emoji ?? MoodType.EmotionNotDetected.emoji
}

extension Mood {
    static let previews = [Mood(mood: .Happy, dateCreated: .now, moodString: "Happy"),
                          Mood(mood: .Excited, dateCreated: .now + 1, moodString: "Excited"),
                          Mood(mood: .Anxious, dateCreated: .now + 2, moodString: "Anxious"),
                          Mood(mood: .Anxious, dateCreated: .now - 1, moodString: "Anxious"),
                          Mood(mood: .Happy, dateCreated: .now + 10, moodString: "Happy"),
                        Mood(mood: .Guilty, dateCreated: .now - 10, moodString: "Guilty") ]
    
    static let preview = Mood(mood: .Happy, dateCreated: .now, moodString: "Happy")
}

extension MoodType: Plottable{
    private var primitivePlottable: Int {
        moodIntValue
    }
}
