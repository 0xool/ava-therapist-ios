//
//  BackendError.swift
//  AITherapist
//
//  Created by cyrus refahi on 9/4/23.
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
