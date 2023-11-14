//
//  Enums.swift
//  AITherapist
//
//  Created by cyrus refahi on 3/4/23.
//

import Foundation


enum UserFeeling {
    case Sad
    case Happy
}

enum WeekDay: String {
    case Monday = "Mon"
    case Tuesday = "Tue"
    case Wednesday = "Wed"
    case Thursday = "Thu"
    case Friday = "Fri"
    case Saturday = "Sat"
    case Sunday = "Sun"
    
    init?(day: Int) {
        switch day {
        case 0:
            self = .Monday
        case 1:
            self = .Tuesday
        case 2:
            self = .Wednesday
        case 3:
            self = .Thursday
        case 4:
            self = .Friday
        case 5:
            self = .Saturday
        case 6:
            self = .Sunday
        default:
            return nil
        }
    }
}
