//
//  Persona.swift
//  AITherapist
//
//  Created by cyrus refahi on 2/3/24.
//

import Foundation
import RealmSwift


class Persona: Object, Codable {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var personaName: String
    
    enum CodingKeys: String, CodingKey {
        case id = "personaID"
        case personaName = "personaName"
    }
}

struct GetAllPersonaResponse: ServerResponse{
    var message: String?
    var code: Int?
    var data: [Persona]
}
