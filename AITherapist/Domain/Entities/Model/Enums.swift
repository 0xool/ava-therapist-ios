//
//  Enums.swift
//  AITherapist
//
//  Created by Cyrus Refahi on 3/4/23.
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
    
    init(day: Int) {
        let day = day % 7
        switch day {
        case 2:
            self = .Monday
        case 3:
            self = .Tuesday
        case 4:
            self = .Wednesday
        case 5:
            self = .Thursday
        case 6:
            self = .Friday
        case 0:
            self = .Saturday
        case 1:
            self = .Sunday
        default:
            self = .Monday
        }
    }
}
