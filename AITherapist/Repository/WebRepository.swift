//
//  WebRepository.swift
//  AITherapist
//
//  Created by cyrus refahi on 9/3/23.
//

import Foundation
import Alamofire
import Combine

//Protocol WebRepository {
//    var baseURL: String { get }
//    var networkManager: NetworkManager
//}
//
//extension WebRepository {
//
//    func Test() {
//
//    }
//
//}

protocol WebRepository {
    var baseURL: String { get }
    func GetRequest<D>(pathVariable: String?, params: [String : Any]?, url: String) -> AnyPublisher<D, Error> where D : Decodable
    func SendRequest<D>(pathVariable: String?, params: [String : Any]?, url: String) -> AnyPublisher<D, Error> where D : Decodable
    func SetCookie(cookie: String)
}


extension WebRepository {
    
    func SetCookie(cookie: String) {
        let cookieProps = [
            HTTPCookiePropertyKey.domain: "aitherapist.online",
            HTTPCookiePropertyKey.path: "/",
            HTTPCookiePropertyKey.name: "jwt",
            HTTPCookiePropertyKey.value: cookie
        ]
        
        if let cookie = HTTPCookie(properties: cookieProps) {
            AF.session.configuration.httpCookieStorage?.setCookie(cookie)
        }
    }
    
    private func generateTestCookie() {
        let cookieProps = [
            HTTPCookiePropertyKey.domain: "aitherapist.online",
            HTTPCookiePropertyKey.path: "/",
            HTTPCookiePropertyKey.name: "jwt",
            HTTPCookiePropertyKey.value: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NywiaWF0IjoxNjk0MDQzODUyLCJleHAiOjE2OTc2NDM4NTJ9.XZ5eG2Hgu6ecm_QFts0rKuoALyOK1BYYssqIUjkDfhA"
        ]
        
        if let cookie = HTTPCookie(properties: cookieProps) {
            AF.session.configuration.httpCookieStorage?.setCookie(cookie)
        }
        
    }
    
    func GetRequest<D>(pathVariable: String?, params: [String : Any]?, url: String) -> AnyPublisher<D, Error> where D : Decodable  {
        
        return AF.request(url,
                          method: .get, parameters: params)
        .validate()
        .publishDecodable(type: D.self)
        .value()
        .mapError{
            $0 as Error
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    
    func SendRequest<D>(pathVariable: String?, params: [String : Any]?, url: String) -> AnyPublisher<D, Error> where D : Decodable  {
        return AF.request(url,
                          method: .post, parameters: params, encoding: Alamofire.JSONEncoding.default)
        .validate()
        .publishDecodable(type: D.self)
        .value()
        .mapError{
            $0 as Error
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    
}


enum ClientError: Error {
    case invalidURL
    case httpCode(HTTPCode)
    case unexpectedResponse
    case imageDeserialization
}

struct ServerResponse<T: Decodable>: Decodable {
    var data: T
    var message: String?
    var code: Int?
    
    enum CodingKeys: String, CodingKey {
        case data
        case message
        case code
    }
}


//
//protocol WebRepository {
//    var session: URLSession { get }
//    var baseURL: String { get }
//    var bgQueue: DispatchQueue { get }
//}
//
//extension WebRepository {
//    func call<Value>(endpoint: APICall, httpCodes: HTTPCodes = .success) -> AnyPublisher<Value, Error>
//        where Value: Decodable {
//        do {
//            let request = try endpoint.urlRequest(baseURL: baseURL)
//            return session
//                .dataTaskPublisher(for: request)
//                .requestJSON(httpCodes: httpCodes)
//        } catch let error {
//            return Fail<Value, Error>(error: error).eraseToAnyPublisher()
//        }
//    }
//}
//
//// MARK: - Helpers
//
//extension Publisher where Output == URLSession.DataTaskPublisher.Output {
//    func requestData(httpCodes: HTTPCodes = .success) -> AnyPublisher<Data, Error> {
//        return tryMap {
//                assert(!Thread.isMainThread)
//                guard let code = ($0.1 as? HTTPURLResponse)?.statusCode else {
//                    throw APIError.unexpectedResponse
//                }
//                guard httpCodes.contains(code) else {
//                    throw APIError.httpCode(code)
//                }
//                return $0.0
//            }
//            .extractUnderlyingError()
//            .eraseToAnyPublisher()
//    }
//}
//
//private extension Publisher where Output == URLSession.DataTaskPublisher.Output {
//    func requestJSON<Value>(httpCodes: HTTPCodes) -> AnyPublisher<Value, Error> where Value: Decodable {
//        return requestData(httpCodes: httpCodes)
//            .decode(type: Value.self, decoder: JSONDecoder())
//            .receive(on: DispatchQueue.main)
//            .eraseToAnyPublisher()
//    }
//}
