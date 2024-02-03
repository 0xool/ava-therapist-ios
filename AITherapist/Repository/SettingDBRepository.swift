//
//  SettingDBRepository.swift
//  AITherapist
//
//  Created by cyrus refahi on 2/2/24.
//

import Foundation
import Combine

protocol SettingDBRepository {
    func store(setting: Setting) -> AnyPublisher<Void, Error>
    func updateSetting(setting: Setting) -> AnyPublisher<Void, Error>
    
    func loadSetting() -> AnyPublisher<Setting, Error>
    func deleteSetting() -> AnyPublisher<Void, Error>
}

struct MainSettingDBRepository: SettingDBRepository {
    let persistentStore: DataBase
    
    init(persistentStore: DataBase = DataBaseManager.Instance) {
        self.persistentStore = persistentStore
    }
    
    func store(setting: Setting) -> AnyPublisher<Void, Error> {
        self.storeSettingToDB(setting: setting)
    }
    
    func updateSetting(setting: Setting) -> AnyPublisher<Void, Error>{
        self.updateSettingInDB(setting: setting)
    }
    
    func loadSetting() -> AnyPublisher<Setting, Error> {
        self.loadSettingFromDB()
    }
    
    func deleteSetting() -> AnyPublisher<Void, Error> {
        self.deleteSettingFromDB()
    }
}

extension MainSettingDBRepository {
    private func deleteSettingFromDB() -> AnyPublisher<Void, Error> {
        persistentStore.DeleteLast(ofType: Setting.self)
    }
    
    private func updateSettingInDB(setting: Setting) -> AnyPublisher<Void, Error>{
        persistentStore.Update(value: setting)
    }
    
    private func loadSettingFromDB() -> AnyPublisher<Setting, Error>{
        guard let setting = persistentStore.GetLast(ofType: Setting.self) else{
            return Fail(error: DataBaseError.NotFound)
                .eraseToAnyPublisher()
        }
        
        return Just(setting)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    private func storeSettingToDB(setting: Setting) -> AnyPublisher<Void, Error>{
        _ = persistentStore.DeleteLast(ofType: Setting.self)
        return persistentStore.Write(writeData: setting)
    }
}
