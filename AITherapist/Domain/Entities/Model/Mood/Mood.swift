//
//  Mood.swift
//  AITherapist
//
//  Created by cyrus refahi on 9/24/23.
//

import RealmSwift
import Foundation
import Charts

class Mood: EmbeddedObject, Decodable {
    @Persisted var moodType: MoodType? = .EmotionNotDetected
    @Persisted var dateCreated: Date?
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
    
    convenience init(mood: MoodType, dateCreated: Date?, moodString: String) {
        self.init()
        self.moodType = mood
        self.dateCreated = dateCreated
        self.moodString = moodString
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
    
    var moodIntValue : Int {
        switch self {
        case .Happy:
            return 1
        case .Sad:
            return 2
        case .Angry:
            return 3
        case .Anxious:
            return 4
        case .Depressed:
            return 5
        case .Excited:
            return 6
        case .Frustrated:
            return 7
        case .Guilty:
            return 8
        case .Lonely:
            return 9
        case .Nervous:
            return 10
        case .Tired:
            return 11
        case .Worried:
            return 12
        case .Stressed:
            return 13
        case .EmotionNotDetected:
            return 14
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

extension MoodType: Plottable{
    private var primitivePlottable: Int {
        moodIntValue
    }
}
