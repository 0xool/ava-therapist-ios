//
//  ActivityDBRepository.swift
//  AITherapist
//
//  Created by cyrus refahi on 2/29/24.
//

import Foundation
import Combine

protocol ActivityDBRepository {
    func store(userActivity: UserActivity) -> AnyPublisher<Void, Error>
    func get() -> AnyPublisher<UserActivity, Error>
    func setTaskDone(activity: UserActivity) -> AnyPublisher<Void, Error>
    func setExerciseDone(activity: UserActivity) -> AnyPublisher<Void, Error>
}

struct MainActivityDBRepository: ActivityDBRepository {
    let persistentStore: DataBase
    
    init(persistentStore: DataBase = DataBaseManager.Instance) {
        self.persistentStore = persistentStore
    }

    func store(userActivity: UserActivity) -> AnyPublisher<Void, Error> {
        saveActivity(userActivity)
    }

    func get() -> AnyPublisher<UserActivity, Error> {
        getActivity()
    }
    
    func setTaskDone(activity: UserActivity) -> AnyPublisher<Void, Error>{
        self.persistentStore.Update {
            activity.dailyTask?.isDone = true
        }
    }
    
    func setExerciseDone(activity: UserActivity) -> AnyPublisher<Void, Error>{
        self.persistentStore.Update {
            activity.dailyExercise?.isDone = true
        }
    }
}

extension MainActivityDBRepository{
    private func saveActivity(_ userActivity: UserActivity) -> AnyPublisher<Void, Error> {
        Just<Void>
            .withErrorType(Error.self)
            .flatMap{ _ in
                self.persistentStore.DeleteAll(ofType: UserActivity.self)
            }
           .flatMap { _ in
                self.persistentStore.Write(writeData: userActivity)
               
            }
            .eraseToAnyPublisher()
    }

    private func getActivity() -> AnyPublisher<UserActivity, Error> {
        guard let userActivity = persistentStore.GetLast(ofType: UserActivity.self) else {
            return Fail(error: DataBaseError.NotFound).eraseToAnyPublisher()
        }

        return Just(userActivity)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
