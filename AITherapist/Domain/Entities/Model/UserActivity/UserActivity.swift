//
//  UserActivity.swift
//  AITherapist
//
//  Created by cyrus refahi on 2/28/24.
//

import Foundation
import RealmSwift

final class UserActivity: Object {
    @Persisted(primaryKey: true) var id: String = UUID().uuidString
    @Persisted var dailyFacts: DailyFact?
    @Persisted var dailyTask: DailyTask?
    
    @Persisted var dailyExercise: DailyExercise?
    @Persisted var dateCreated: Date
    
    convenience init(dateCreated: Date) {
        self.init()
        
        self.dailyFacts = DailyFact()
        self.dailyTask = DailyTask()
        
        self.dailyExercise = DailyExercise()
        self.dateCreated = dateCreated
    }
}

class DailyFact: Object {
    @Persisted var title: String
    @Persisted var content: String
    
    override init() {
        
        let todaysFacts = Constants.todaysFacts.randomElement()
        self.title = todaysFacts?.key.rawValue ?? ""
        self.content = todaysFacts?.value.randomElement() ?? ""
    }
}

class DailyExercise: Object {
    @Persisted var title: String
    @Persisted var content: String
    @Persisted var isDone: Bool = false
    
    override init() {
        let randomNum = Int.random(in: 0...2)
        switch randomNum {
        case 0:
            let breathingExercise = Constants.breathingExercises.randomElement()
            self.title = breathingExercise?.key ?? ""
            self.content = (breathingExercise?.value.randomElement())!
        case 1:
            let mindfullnessExercise = Constants.mindfullnessExercise.randomElement()
            self.title = (mindfullnessExercise?.key)!
            self.content = (mindfullnessExercise?.value)!
        case 2:
            let multyFunctionMindfullnessExercises = Constants.multyFunctionMindfullnessExercises.randomElement()
            self.title = (multyFunctionMindfullnessExercises?.key)!
            self.content = (multyFunctionMindfullnessExercises?.value.randomElement())!
        default:
            self.title = ""
            self.content = ""
        }
    }
}

class DailyTask: Object {
    @Persisted var content: String
    @Persisted var isDone: Bool = false
    
    override init() {
        let randomDailyTask = Constants.dailyTasks.randomElement()
        self.content = randomDailyTask!
    }
}

