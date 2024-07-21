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
    func loadInsight() -> AnyPublisher<Insight, ServerError>
}

struct MainInsightWebRepository: InsightWebRepository {
    var AFSession: Session = .default
    var session: URLSession
    var bgQueue: DispatchQueue = Constants.bgQueue
    
    var baseURL: String
    static let InsightAPI = "user"
    
    init(session: URLSession, baseURL: String) {
        self.session = session
        self.baseURL = baseURL
        self.bgQueue = Constants.bgQueue
        self.AFSession = setAFSession(session, queue: bgQueue)
    }
    
    func loadInsight() -> AnyPublisher<Insight, ServerError> {
        let request: AnyPublisher<LoadInsightServerResponse, ServerError> = webRequest(api: API.getInsight)
        
        return request
            .map{
                $0.data
            }
            .eraseToAnyPublisher()
    }
}

extension MainInsightWebRepository {
    
    enum API: APICall {
        case getInsight
        
        var url: String{
            "\(MainInsightWebRepository.InsightAPI)/getUserInsight"
        }
        
        var method: HTTPMethod {
            .get
        }
        
        var headers: HTTPHeaders? {
            nil
        }
        
        var encoding: ParameterEncoding {
            URLEncoding.default
        }
        
        var parameters: Parameters? {
            nil
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
