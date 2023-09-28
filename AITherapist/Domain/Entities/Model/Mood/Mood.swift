//
//  Mood.swift
//  AITherapist
//
//  Created by cyrus refahi on 9/24/23.
//

import RealmSwift
import Foundation

class Mood: EmbeddedObject, Decodable {
    @Persisted var mood: MoodType? = .EmotionNotDetected
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
        let dateCreated = try container.decode(Date.self, forKey: .dateCreated)
        let moodString = try container.decode(String.self, forKey: .moodString)        
        self.init(mood: mood, dateCreated: dateCreated, moodString: moodString)
    }

    convenience init(mood: MoodType, dateCreated: Date, moodString: String) {
        self.init()
        self.mood = mood
        self.dateCreated = dateCreated
        self.moodString = moodString
    }
}

class DailyMoods: EmbeddedObject, Decodable {
    @Persisted var moods: List<Mood>

    enum CodingKeys: String, CodingKey {
        case moods = "dailyUserMoods"
    }

    convenience required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let moods = try container.decode(List<Mood>.self, forKey: .moods)
        self.init(moods: moods)
    }

    convenience init(moods: List<Mood>) {
        self.init()
        self.moods = moods
    }
}

extension Mood {

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
                return "Happy"
            case .Sad:
                return "Sad"
            case .Angry:
                return "Angry"
            case .Anxious:
                return "Anxious"
            case .Depressed:
                return "Depressed"
            case .Excited:
                return "Excited"
            case .Frustrated:
                return "Frustrated"
            case .Guilty:
                return "Guilty"
            case .Lonely:
                return "Lonely"
            case .Nervous:
                return "Nervous"
            case .Tired:
                return "Tired"
            case .Worried:
                return "Worried"
            case .Stressed:
                return "Stressed"
            case .EmotionNotDetected:
                return "EmotionNotDetected"
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
}
