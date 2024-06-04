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
    @Persisted var moodType: MoodType = .Happy
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
    case Sad
    case Depressed
    case Angry
    case Anxious
    case Lonely
    case Irritated
    case Overwhelmed
    case Nervous
    case Tired
    case Stressed
    case Frustrated
    case Confused
    case Relaxed
    case Satisfied
    case Energetic
    case Motivated
    case Calm
    case Optimistic
    case Excited
    case Hopeful
    case Amused
    case Happy
    
    var mood: String {
        switch self {
        case .Sad:
            return "Sad"
        case .Depressed:
            return "Depressed"
        case .Angry:
            return "Angry"
        case .Anxious:
            return "Anxious"
        case .Lonely:
            return "Lonely"
        case .Irritated:
            return "Irritated"
        case .Overwhelmed:
            return "Overwhelmed"
        case .Nervous:
            return "Nervous"
        case .Tired:
            return "Tired"
        case .Stressed:
            return "Stressed"
        case .Frustrated:
            return "Frustrated"
        case .Confused:
            return "Confused"
        case .Relaxed:
            return "Relaxed"
        case .Satisfied:
            return "Satisfied"
        case .Energetic:
            return "Energetic"
        case .Motivated:
            return "Motivated"
        case .Calm:
            return "Calm"
        case .Optimistic:
            return "Optimistic"
        case .Excited:
            return "Excited"
        case .Hopeful:
            return "Hopeful"
        case .Amused:
            return "Amused"
        case .Happy:
            return "Happy"
        }
    }
    
    var moodIntValue: Int {
        switch self {
        case .Sad:
            return 1
        case .Depressed:
            return 2
        case .Angry:
            return 3
        case .Anxious:
            return 4
        case .Lonely:
            return 5
        case .Irritated:
            return 6
        case .Overwhelmed:
            return 7
        case .Nervous:
            return 8
        case .Tired:
            return 9
        case .Stressed:
            return 10
        case .Frustrated:
            return 11
        case .Confused:
            return 12
        case .Relaxed:
            return 13
        case .Satisfied:
            return 14
        case .Energetic:
            return 15
        case .Motivated:
            return 16
        case .Calm:
            return 17
        case .Optimistic:
            return 18
        case .Excited:
            return 19
        case .Hopeful:
            return 20
        case .Amused:
            return 21
        case .Happy:
            return 22
        }
    }
    
    var emoji: String {
        switch self {
        case .Sad:
            return "😢"
        case .Depressed:
            return "😞"
        case .Angry:
            return "😡"
        case .Anxious:
            return "😰"
        case .Lonely:
            return "😔"
        case .Irritated:
            return "😠"
        case .Overwhelmed:
            return "😩"
        case .Nervous:
            return "😨"
        case .Tired:
            return "😴"
        case .Stressed:
            return "😖"
        case .Frustrated:
            return "😤"
        case .Confused:
            return "😕"
        case .Relaxed:
            return "😌"
        case .Satisfied:
            return "😊"
        case .Energetic:
            return "💪"
        case .Motivated:
            return "🚀"
        case .Calm:
            return "😌"
        case .Optimistic:
            return "😄"
        case .Excited:
            return "😃"
        case .Hopeful:
            return "🤞"
        case .Amused:
            return "😄"
        case .Happy:
            return "😊"
        }
    }
    
    init(rawValue: Int) {
        switch rawValue {
        case 1:
            self = .Sad
        case 2:
            self = .Depressed
        case 3:
            self = .Angry
        case 4:
            self = .Anxious
        case 5:
            self = .Lonely
        case 6:
            self = .Irritated
        case 7:
            self = .Overwhelmed
        case 8:
            self = .Nervous
        case 9:
            self = .Tired
        case 10:
            self = .Stressed
        case 11:
            self = .Frustrated
        case 12:
            self = .Confused
        case 13:
            self = .Relaxed
        case 14:
            self = .Satisfied
        case 15:
            self = .Energetic
        case 16:
            self = .Motivated
        case 17:
            self = .Calm
        case 18:
            self = .Optimistic
        case 19:
            self = .Excited
        case 20:
            self = .Hopeful
        case 21:
            self = .Amused
        case 22:
            self = .Happy
        default:
            self = .Happy
        }
    }
}

func getMoodEmojiFromString(mood: String?) -> String {
    MoodType(primitivePlottable: mood ?? "EmotionNotDetected")?.emoji ?? MoodType.Happy.emoji
}

extension Mood {
    static let previews = [Mood(mood: .Happy, dateCreated: .now, moodString: "Happy"),
                          Mood(mood: .Excited, dateCreated: .now + 1, moodString: "Excited"),
                          Mood(mood: .Anxious, dateCreated: .now + 2, moodString: "Anxious"),
                          Mood(mood: .Anxious, dateCreated: .now - 1, moodString: "Anxious"),
                          Mood(mood: .Happy, dateCreated: .now + 10, moodString: "Happy"),
                        Mood(mood: .Energetic, dateCreated: .now - 10, moodString: "Guilty") ]
    
    static let preview = Mood(mood: .Happy, dateCreated: .now, moodString: "Happy")
}

extension MoodType: Plottable{
    private var primitivePlottable: Int {
        moodIntValue
    }
}
