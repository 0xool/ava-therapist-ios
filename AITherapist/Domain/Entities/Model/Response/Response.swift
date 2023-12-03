//
//  Response.swift
//  AITherapist
//
//  Created by Cyrus Refahi on 9/6/23.
//

import Foundation

protocol ServerSuccessResponse: Decodable {
    var message: String { get }
    var code: String { get }
}


