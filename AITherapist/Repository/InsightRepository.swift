//
//  InsightRepository.swift
//  AITherapist
//
//  Created by cyrus refahi on 9/24/23.
//

import Foundation
import Alamofire
import Combine

protocol InsightRepository: WebRepository {
    func loadInsight() -> AnyPublisher<Insight, Error>
//    func loadConversationChat(conversation: Conversation) -> AnyPublisher<[Message], Error>
}

struct MainIsightRepository: InsightRepository {
    
    var baseURL: String
    let InsightAPI = "user"

    init(baseURL: String) {
        self.baseURL = baseURL
    }
    
    func loadInsight() -> AnyPublisher<Insight, Error> {
        print(AF.session.configuration.httpCookieStorage as Any)
        
        
        let request: AnyPublisher<ServerResponse<Insight>, Error> = GetRequest(pathVariable: nil, params: nil, url: getPath(api: .getInsight))
        
        return request
            .map{ $0.data }
            .eraseToAnyPublisher()
    }
}

extension MainIsightRepository {
    
    enum API: String {
        case getInsight = "getUserInsight"
    }
    
    func getPath(api: API) -> String {
        switch api {
        case .getInsight:
            return "\(baseURL)\(InsightAPI)/\(api.rawValue)"
        }
    }
}

