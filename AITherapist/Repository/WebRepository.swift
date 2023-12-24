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
    typealias Session = Alamofire.Session
    var baseURL: String { get }
    var session: URLSession { get }
    
    var bgQueue: DispatchQueue { get }
    var AFSession: Session { get }
}

// MARK: General Request
extension WebRepository {
    func webRequest<D: ServerResponse>(url: String, method: HTTPMethod, parameters: Parameters? = nil, encoding: ParameterEncoding = URLEncoding.default, headers: HTTPHeaders? = nil) -> AnyPublisher<D, Error> {
        webRequest(webApi: WebAPI.init(url: url, method: method, headers: headers, encoding: encoding, parameters: parameters, baseURL: self.baseURL))
    }
    
    func webRequest<D: ServerResponse>(api: APICall) -> AnyPublisher<D, Error> {
        webRequest(webApi: WebAPI.init(url: api.url, method: api.method, headers: api.headers, encoding: api.encoding, parameters: api.parameters, baseURL: self.baseURL))
    }
    
    func webRequest<D: ServerResponse>(webApi: APICall) -> AnyPublisher<D, Error> {
        
#warning ("REMOVE TESTS")
        generateTestCookie()
        
        return Future<D, Error> { promise in
            AFSession.request(webApi.url, method: webApi.method, parameters: webApi.parameters, encoding: webApi.encoding, headers: webApi.headers)
                .validate()
                .responseDecodable(of: D.self) { response in
                    switch response.result {
                    case .success(let data):
                        promise(.success(data))
                    case .failure(let error):
                        promise(.failure(error))
                    }
                }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    
    
}

func setAFSession(_ session: URLSession, queue: DispatchQueue) -> Session {
        let delegateQueue = OperationQueue()
        delegateQueue.underlyingQueue = queue

        return Session(
            configuration: session.configuration,
            delegate: SessionDelegate(),
            rootQueue: queue,
            startRequestsImmediately: true,
            requestQueue: nil,
            serializationQueue: nil,
            interceptor: nil,
            serverTrustManager: nil,
            redirectHandler: nil,
            cachedResponseHandler: nil,
            eventMonitors: []
        )
}



// MARK: COOKIE
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
}

// MARK: TEST
extension WebRepository {
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

extension WebRepository {
    
}

// MARK: Model
enum ClientError: Error {
    case invalidURL
    case httpCode(HTTPCode)
    case unexpectedResponse
    case imageDeserialization
}

struct ServerResponseModel<T: Codable>: ServerResponse {
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


struct WebAPI: APICall {
    var url: String
    var method: HTTPMethod
    var headers: HTTPHeaders? = nil
    var encoding: ParameterEncoding = URLEncoding.default
    var parameters: Parameters? = nil
    
    init(url: String, method: HTTPMethod, headers: HTTPHeaders? = nil, encoding: ParameterEncoding, parameters: Parameters? = nil, baseURL: String) {
        self.url = "\(baseURL)\(url)"
        self.method = method
        self.headers = headers
        self.encoding = encoding
        self.parameters = parameters
    }
}

extension Publisher where Output == URLSession.DataTaskPublisher.Output {
    func requestData(httpCodes: HTTPCodes = .success) -> AnyPublisher<Data, Error> {
        return tryMap {
                assert(!Thread.isMainThread)
                guard let code = ($0.1 as? HTTPURLResponse)?.statusCode else {
                    throw APIError.unexpectedResponse
                }
                guard httpCodes.contains(code) else {
                    throw APIError.httpCode(code)
                }
                return $0.0
            }
            .extractUnderlyingError()
            .eraseToAnyPublisher()
    }
}

private extension Publisher where Output == URLSession.DataTaskPublisher.Output {
    func requestJSON<Value>(httpCodes: HTTPCodes) -> AnyPublisher<Value, Error> where Value: Decodable {
        return requestData(httpCodes: httpCodes)
            .decode(type: Value.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
