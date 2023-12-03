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
