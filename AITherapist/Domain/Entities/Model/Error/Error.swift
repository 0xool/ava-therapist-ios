//
//  BackendError.swift
//  AITherapist
//
//  Created by Cyrus Refahi on 9/4/23.
//

import Alamofire

struct NetworkError: Error {
  let initialError: AFError
  let backendError: BackendError?
}

struct BackendError: Codable, Error {
    var status: String
    var message: String
}

enum ClientError: Error, Codable {
    case invalidURL
    case invalidCookie
    case httpCode(HTTPCode)
    case unexpectedResponse
    case imageDeserialization
    case serializationError
}

struct ServerError: Error, Codable {
    var message: String?
    var code: Int?
    
    var clientError: ClientError = .unexpectedResponse
    
    enum CodingKeys: String, CodingKey {
        case message = "message"
        case code = "code"
    }

    init(message: String?, code: Int?, clientError: ClientError = .unexpectedResponse) {
        self.message = message
        self.code = code
        self.clientError = clientError
    }
    
    init() {
        
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)        
        self.message = try container.decode(String?.self , forKey: .message)
        self.code = try container.decode(Int?.self , forKey: .code)
        self.clientError = .unexpectedResponse
    }
}
