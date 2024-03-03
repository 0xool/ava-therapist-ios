//
//  ActivityService.swift
//  AITherapist
//
//  Created by cyrus refahi on 2/29/24.
//

import Foundation
import Combine

protocol ActivityService {
    func getDailyActivity(activity: LoadableSubject<UserActivity>)
    func setDailyTaskDone(activity: UserActivity)
    func setDailyExerciseDone(activity: UserActivity)
}

struct MainActivityService: ActivityService {
    let activityDBRepository: ActivityDBRepository
    let appState: Store<AppState>
    let cancelBag = CancelBag()
    
    func getDailyActivity(activity: LoadableSubject<UserActivity>){
        activity.wrappedValue.setIsLoading(cancelBag: cancelBag)
        
        Just<Void>
            .withErrorType(Error.self)
            .flatMap{ [activityDBRepository] in
                activityDBRepository.get()
            }
            .sink { completion in
                switch (completion){
                case .finished:
                    break
                case .failure(_):
                    let newActivity = UserActivity(dateCreated: .now)
                    self.activityDBRepository.store(userActivity: newActivity)
                        .sinkToLoadable { _ in }
                        .store(in: cancelBag)
                    activity.wrappedValue = .loaded(newActivity)
                    
                    break
                }
            } receiveValue: {
                activity.wrappedValue = .loaded($0)
            }
            .store(in: cancelBag)
    }
    
    func setDailyTaskDone(activity: UserActivity){
        self.activityDBRepository.setTaskDone(activity: activity)
            .sinkToLoadable { _ in
                
            }
            .store(in: cancelBag)
    }
    
    func setDailyExerciseDone(activity: UserActivity){
        self.activityDBRepository.setExerciseDone(activity: activity)
            .sinkToLoadable { _ in
                
            }
            .store(in: cancelBag)
    }
}

struct StubActivityService: ActivityService {
    func getDailyActivity(activity: LoadableSubject<UserActivity>){
        let userActivity = UserActivity(dateCreated: .now)
        activity.wrappedValue = .loaded(userActivity)
    }
    
    func setDailyTaskDone(activity: UserActivity){
        
    }
    
    func setDailyExerciseDone(activity: UserActivity){
        
    }
}
