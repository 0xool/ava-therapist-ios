//
//  InsightDBRepository.swift
//  AITherapist
//
//  Created by cyrus refahi on 9/25/23.
//

import Foundation
import Combine

protocol InsightDBRepository {
    func hasLoadedInsight() -> AnyPublisher<Bool, Error>
    func store(insight: Insight) -> AnyPublisher<Void, Error>
    func loadInsight() -> AnyPublisher<Insight, Error>
}

struct MainInsightDBRepository: InsightDBRepository {
    
    let db = DataBaseManager.Instance.getDB()
    
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
        return Future<Void, Error> { promise in
               if self.insightExist(id: insight.id)  {
                   do {
                       try self.db.write {
                           self.db.add(insight)
                       }
                       promise(.success(()))
                   } catch {
                       promise(.failure(error))
                   }
               } else {
                   do {
                       try self.db.write {
                           self.db.delete(insight)
                           self.db.add(insight)
                       }
                       promise(.success(()))
                   } catch {
                       promise(.failure(error))
                   }
               }
           }
           .eraseToAnyPublisher()
    }
    
    private func readInsight() -> AnyPublisher<Insight, Error> {
        let insight = Array(db.objects(Insight.self))
        
        if insight.count == 0 {
            return Fail(error: DataBaseError.UserIsNil)
                .eraseToAnyPublisher()
        }
        
        return Just(insight.first!)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    private func hasInsight() -> AnyPublisher<Bool, Error> {
        let insightCount = db.objects(Insight.self).count
        return Just(insightCount > 0)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    private func insightExist(id: Int) -> Bool {
        return db.object(ofType: Insight.self, forPrimaryKey: id) != nil
    }
}
