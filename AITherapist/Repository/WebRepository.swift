//
//  WebRepository.swift
//  AITherapist
//
//  Created by Cyrus Refahi on 9/3/23.
//

import Foundation
import Alamofire
import Combine

protocol WebRepository {
    var baseURL: String { get }
    func WebRequest<D>(pathVariable: String?, params: [String : Any]?, url: String, method: HTTPMethod) -> AnyPublisher<D, Error> where D : ServerResponse
    func SetCookie(cookie: String)
}

extension WebRepository {    
    func WebRequest<D>(pathVariable: String?, params: [String : Any]?, url: String, method: HTTPMethod) -> AnyPublisher<D, Error> where D : ServerResponse {
        
#warning ("REMOVE TESTS")
        generateTestCookie()
        
        return AF.request(url,
                          method: method, parameters: params)
        .validate()
        .publishDecodable(type: D.self)
        .value()
        .map{
            $0.data as! D
        }
        .mapError{
            $0 as Error
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
        
    }
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
}

enum ClientError: Error {
    case invalidURL
    case httpCode(HTTPCode)
    case unexpectedResponse
    case imageDeserialization
}

struct ServerResponseModel<T: Decodable>: ServerResponse {
    var data: T
    var message: String?
    var code: Int?
    
    enum CodingKeys: String, CodingKey {
        case data
        case message
        case code
    }
}

protocol ServerResponse: Decodable {
    associatedtype T: Decodable

    var data: T { get set }
    var message: String? { get set }
    var code: Int? { get set }
}
