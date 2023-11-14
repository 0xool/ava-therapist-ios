//
//  WebRepository.swift
//  AITherapist
//
//  Created by cyrus refahi on 9/3/23.
//

import Foundation
import Alamofire
import Combine

protocol WebRepository {
    var baseURL: String { get }
    func GetRequest<D>(pathVariable: String?, params: [String : Any]?, url: String) -> AnyPublisher<D, Error> where D : Decodable
    func SendRequest<D>(pathVariable: String?, params: [String : Any]?, url: String) -> AnyPublisher<D, Error> where D : Decodable
    func DeleteRequest<D>(pathVariable: String?, params: [String : Any]?, url: String) -> AnyPublisher<D, Error> where D : Decodable
    func SetCookie(cookie: String)
}

extension WebRepository {
    func SetCookie(cookie: String) {
        let cookieProps = [
            HTTPCookiePropertyKey.domain: Constants.BaseUrl,
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
            HTTPCookiePropertyKey.domain: Constants.BaseUrl,
            HTTPCookiePropertyKey.path: "/",
            HTTPCookiePropertyKey.name: "jwt",
            HTTPCookiePropertyKey.value: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwiaWF0IjoxNjk5MjE3NDk0LCJleHAiOjE3MDI4MTc0OTR9.BWtu0Tr6AaUrBBHlHx2IkNX7W3aF2wzbSQT4nRbYqtI"
        ]
        
        if let cookie = HTTPCookie(properties: cookieProps) {
            AF.session.configuration.httpCookieStorage?.setCookie(cookie)
        }
    }
    
    func DeleteRequest<D>(pathVariable: String?, params: [String : Any]?, url: String) -> AnyPublisher<D, Error> where D : Decodable  {
        
#warning ("REMOVE TESTS")
        generateTestCookie()
        
        return AF.request(url,
                          method: .delete, parameters: params)
        .validate()
        .publishDecodable(type: D.self)
        .value()
        .mapError{
            $0 as Error
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
        
    }
    
    func GetRequest<D>(pathVariable: String?, params: [String : Any]?, url: String) -> AnyPublisher<D, Error> where D : Decodable  {
        
#warning ("REMOVE TESTS")
        generateTestCookie()
        
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
        
#warning ("REMOVE TESTS")
        generateTestCookie()
        
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

struct ServerResponse<T: Decodable>: Decodable, ServerResponseData {
    var data: T
    var message: String?
    var code: Int?
    
    enum CodingKeys: String, CodingKey {
        case data
        case message
        case code
    }
}

protocol ServerResponseData {
    var message: String? { get set }
    var code: Int? { get set }
}
