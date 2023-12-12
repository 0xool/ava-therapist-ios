//
//  PushTokenWebRepository.swift
//  AITherapist
//
//  Created by Cyrus Refahi on 9/5/23.
//

import Combine
import Foundation

protocol PushTokenWebRepository: WebRepository {
    func register(devicePushToken: Data) -> AnyPublisher<Void, Error>
}

struct RealPushTokenWebRepository: PushTokenWebRepository {
    var AFSession: Session
    let session: URLSession
    let baseURL: String
    var bgQueue: DispatchQueue = Constants.bgQueue

    init(session: URLSession, baseURL: String) {
        self.session = session
        self.baseURL = baseURL
        self.AFSession = setAFSession(session, queue: bgQueue)
    }
    
    func register(devicePushToken: Data) -> AnyPublisher<Void, Error> {
        // upload the push token to your server
        return Just<Void>.withErrorType(Error.self)
    }
}

