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
    func loadInsight()
    func checkInsight()
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
    
    func checkInsight() {
        let cancelBag = CancelBag()
        
        Just<Void>
            .withErrorType(Error.self)
            .flatMap({ [insightDBRepository] in
                insightDBRepository.loadInsight()
            })
            .sink{ subscriptionCompletion in
                if let _ = subscriptionCompletion.error {
                }
            } receiveValue: { insight in
                self.appState[\.userData.insight] = .loaded(insight)
            }
            .store(in: cancelBag)
    }
    
    func loadInsight() {
        let cancelBag = CancelBag()
        self.appState[\.userData.insight].setIsLoading(cancelBag: cancelBag)
        
        Just<Void>
            .withErrorType(Error.self)
            .flatMap { [insightDBRepository] _ -> AnyPublisher<Bool, Error> in
                insightDBRepository.hasLoadedInsight()
            }
            .flatMap { hasLoaded -> AnyPublisher<Void, Error> in
                if hasLoaded {
                    return Just<Void>.withErrorType(Error.self)
                } else {
                    return self.loadInsightFromServer()
                }
            }
            .flatMap({ [insightDBRepository] in
                insightDBRepository.loadInsight()
            })
            .sinkToLoadable {
                self.appState[\.userData.insight] = $0
            }
            .store(in: cancelBag)
    }
    
    func loadInsightFromServer() -> AnyPublisher<Void, Error> {
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
    func loadInsight() {
    }
    
    func checkInsight() {
        
    }
 }




