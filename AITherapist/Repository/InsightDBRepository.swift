//
//  InsightDBRepository.swift
//  AITherapist
//
//  Created by Cyrus Refahi on 9/25/23.
//

import Foundation
import Combine

protocol InsightDBRepository {
    func hasLoadedInsight() -> AnyPublisher<Bool, Error>
    func store(insight: Insight) -> AnyPublisher<Void, Error>
    func loadInsight() -> AnyPublisher<Insight, Error>
}

struct MainInsightDBRepository: InsightDBRepository {
    
    let persistentStore: DataBase
    
    init(persistentStore: DataBase = DataBaseManager.Instance) {
        self.persistentStore = persistentStore
    }
    
    func hasLoadedInsight() -> AnyPublisher<Bool, Error> {
        return hasInsight()
    }
    
    func store(insight: Insight) -> AnyPublisher<Void, Error> {
        writeInsightData(insight: insight)
    }
    
    func loadInsight() -> AnyPublisher<Insight, Error> {
        readInsight()
    }
}

extension MainInsightDBRepository {
    private func writeInsightData(insight: Insight) -> AnyPublisher<Void, Error> {
        persistentStore.DeleteLast(ofType: Insight.self)
        return persistentStore.Write(writeData: insight)
    }
    
    private func readInsight() -> AnyPublisher<Insight, Error> {
        guard let insight = persistentStore.GetLast(ofType: Insight.self) else{
            return Fail(error: DataBaseError.UserIsNil)
                .eraseToAnyPublisher()
        }
        
        return Just(insight)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    private func hasInsight() -> AnyPublisher<Bool, Error> {
        let insightCount = persistentStore.GetCount(value: Insight.self)
        
        return Just(insightCount > 0)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
