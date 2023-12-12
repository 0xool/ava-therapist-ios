//
//  APICall.swift
//  AITherapist
//
//  Created by Cyrus Refahi on 9/3/23.
//

import Foundation
import Alamofire

protocol APICall {
    var url: String { get }
    var method: HTTPMethod { get }
    var headers: HTTPHeaders? { get }
    var encoding: ParameterEncoding { get }
    var parameters: Parameters? { get }
}

enum APIError: Swift.Error {
    case invalidURL
    case httpCode(HTTPCode)
    case unexpectedResponse
    case imageDeserialization
}

extension APIError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURL: return "Invalid URL"
        case let .httpCode(code): return "Unexpected HTTP code: \(code)"
        case .unexpectedResponse: return "Unexpected response from the server"
        case .imageDeserialization: return "Cannot deserialize image from Data"
        }
    }
}

extension APICall {
    func requestURL() throws -> URLRequest {
        guard let url = URL(string: url) else {
            throw APIError.invalidURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers?.dictionary
        return request
    }
}

typealias HTTPCode = Int
typealias HTTPCodes = Range<HTTPCode>

extension HTTPCodes {
    static let success = 200 ..< 300
}

