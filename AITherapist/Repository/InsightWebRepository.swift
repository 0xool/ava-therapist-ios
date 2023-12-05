//
//  InsightRepository.swift
//  AITherapist
//
//  Created by Cyrus Refahi on 9/24/23.
//

import Foundation
import Alamofire
import Combine

protocol InsightWebRepository: WebRepository {
    func loadInsight() -> AnyPublisher<Insight, Error>
}

struct MainInsightWebRepository: InsightWebRepository {
    
    var baseURL: String
    let InsightAPI = "user"

    init(baseURL: String) {
        self.baseURL = baseURL
    }
    
    func loadInsight() -> AnyPublisher<Insight, Error> {
        let request: AnyPublisher<LoadInsightServerResponse, Error> = WebRequest(pathVariable: nil, params: nil, url: getPath(api: .getInsight), method: .get)
        
        return request
            .map{ $0.data }
            .eraseToAnyPublisher()
    }
}

extension MainInsightWebRepository {
    
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


extension MainInsightWebRepository {
    struct LoadInsightServerResponse: ServerResponse {
        var data: Insight
        var message: String?
        var code: Int?
    }
}
