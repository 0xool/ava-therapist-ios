//
//  InsightService.swift
//  AITherapist
//
//  Created by cyrus refahi on 9/25/23.
//

import Combine
import Foundation
import SwiftUI

protocol InsightService {
    func loadInsight(insight: LoadableSubject<Insight>)
//    func loadConversationChat(message: LoadableSubject<LazyList<Message>>)
}

struct MainInsightService: InsightService {
    
    let insightRepository: InsightRepository
    let insightDBRepository: InsightDBRepository
    let appState: Store<AppState>
    
    init(insightRepository: InsightRepository, appState: Store<AppState>, conversationDBRepository: InsightDBRepository) {
        self.insightRepository = insightRepository
        self.insightDBRepository = conversationDBRepository
        self.appState = appState
    }
    
    func loadInsight(insight: LoadableSubject<Insight>) {
        
        let cancelBag = CancelBag()
        insight.wrappedValue.setIsLoading(cancelBag: cancelBag)
        
        Just<Void>
            .withErrorType(Error.self)
            .flatMap { [insightDBRepository] _ -> AnyPublisher<Bool, Error> in
                insightDBRepository.hasLoadedInsight()
            }
            .flatMap { hasLoaded -> AnyPublisher<Void, Error> in
                if hasLoaded {
                    return Just<Void>.withErrorType(Error.self)
                } else {
                    return self.refreshConversationList()
                }
            }
            .flatMap({ [insightDBRepository] in
                insightDBRepository.loadInsight()
            })
            .sinkToLoadable { insight.wrappedValue = $0 }
            .store(in: cancelBag)
    }
    
    func refreshConversationList() -> AnyPublisher<Void, Error> {
        return insightRepository
            .loadInsight()
            .ensureTimeSpan(requestHoldBackTimeInterval)
            .map { [insightDBRepository] in
                _ = insightDBRepository.store(insight: $0)
            }
            .eraseToAnyPublisher()
    }
    
    private var requestHoldBackTimeInterval: TimeInterval {
        return ProcessInfo.processInfo.isRunningTests ? 0 : 0.5
    }
}

struct StubInsightService: InsightService {
    func loadInsight(insight: LoadableSubject<Insight>) {
    }
 }




