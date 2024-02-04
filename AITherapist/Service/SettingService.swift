//
//  SettingService.swift
//  AITherapist
//
//  Created by cyrus refahi on 2/3/24.
//

import Foundation
import Combine

protocol SettingService {
    func getAllPersona(personas: LoadableSubject<[Persona]>)
    func updateSetting(setting: LoadableSubject<Setting>)
    //    func saveProfileImage(image: PersistentImageModel)
    //    func loadProfileImage() -> AnyPublisher<Image?, Error>
    //    func updateUserInfo(username: String, name: String, lastName: String, userID: Int)
}

struct MainSettingService: SettingService {
    let settingRepository: SettingWebRepository
    let settingDBRepository: SettingDBRepository
    let appState: Store<AppState>
    
    init(settingRepository: SettingWebRepository, settingDBRepository: SettingDBRepository, appState: Store<AppState>) {
        self.settingRepository = settingRepository
        self.settingDBRepository = settingDBRepository
        self.appState = appState
    }
    func getAllPersona(personas: LoadableSubject<[Persona]>) {
        let cancelBag = CancelBag()
        personas.wrappedValue.setIsLoading(cancelBag: cancelBag)
        
        self.settingRepository.getAllPersona()
            .sinkToLoadable({ personas.wrappedValue = .loaded($0.value ?? []) })
            .store(in: cancelBag)
    }
    
    func updateSetting(setting: LoadableSubject<Setting>){
        let cancelBag = CancelBag()
        setting.wrappedValue.setIsLoading(cancelBag: cancelBag)
        let settingVal =  setting.wrappedValue.value!
        
        self.settingRepository.editSettingInfo(setting: settingVal)
            .sinkToLoadable { _ in
                _ = settingDBRepository.store(setting: settingVal)
                self.appState[\.userData.setting] = .loaded(settingVal)
                setting.wrappedValue.cancelLoading()
            }
            .store(in: cancelBag)
    }

}

struct StubSettingService: SettingService {
    func updateSetting(setting: LoadableSubject<Setting>) {
        
    }
    
    func getAllPersona(personas: LoadableSubject<[Persona]>) {

    }
}
