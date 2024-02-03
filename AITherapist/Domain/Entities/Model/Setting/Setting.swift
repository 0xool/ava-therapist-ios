//
//  Setting.swift
//  AITherapist
//
//  Created by cyrus refahi on 2/2/24.
//

import Foundation
import RealmSwift

class Setting: Object, Codable{
    @Persisted(primaryKey: true) var id: Int
    @Persisted var personaID: Int
    @Persisted var isNotificationEnabled: Bool
    
    enum CodingKeys: String, CodingKey {
        case id = "settingID"
        case personaID = "personaID"
        case isNotificationEnabled = "isNotificationEnabled"
    }
    
    override init() {
        super.init()
    }
    
    convenience init(id: Int, personaID: Int, isNotificationEnabled: Bool) {
        self.init()
        
        self.id = id
        self.personaID = personaID
        self.isNotificationEnabled = isNotificationEnabled
    }

    required init(from decoder: Decoder) throws {
        super.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.personaID = try container.decode(Int.self, forKey: .personaID)
        self.isNotificationEnabled = try container.decode(Bool.self, forKey: .isNotificationEnabled)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(personaID, forKey: .personaID)
        try container.encode(isNotificationEnabled, forKey: .isNotificationEnabled)
    }
}

struct UpdateSettingRequest: Encodable{
    var setting: Setting
}

struct UpdateSettingResponse: ServerResponse{
    var message: String?
    var code: Int?
    var data: Setting
}
