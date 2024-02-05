//
//  ProfileService.swift
//  AITherapist
//
//  Created by Cyrus Refahi on 11/25/23.
//

import Foundation
import Combine
import SwiftUI

protocol ProfileService {
    func saveProfileImage(image: PersistentImageModel)
    func loadProfileImage() -> AnyPublisher<Image?, Error>
    func updateUserInfo(username: String, name: String, lastname: String)
}
 
struct MainProfileService: ProfileService {
    let imagePersistenceRepository: ImagePersistenceRepository
    let userWebRepository: UserWebRepository
    let userDBRepository: UserDBRepository
    
    let appState: Store<AppState>
    private let cancelBag = CancelBag()
    
    func saveProfileImage(image: PersistentImageModel) {
        imagePersistenceRepository.saveImage(image, forKey: .profileImage)
    }

    func loadProfileImage() -> AnyPublisher<Image?, Error>{
        imagePersistenceRepository.loadImage(forKey: .profileImage)
            .map{
                if let image = UIImage(data:$0.imageData){
                    return Image(uiImage: image)
                }else{
                    return nil
                }
            }
            .eraseToAnyPublisher()
    }
    
    func updateUserInfo(username: String, name: String, lastname: String)  {
        
        self.userWebRepository.editUserInfo(username: username, name: name, lastname: lastname)
            .map{
                print($0)
                return $0
            }
            .sink { (completion) in
                switch completion{
                case .failure(let error):
                    print(error)
                case .finished:
                    self.userDBRepository.changeValue {
                        let user: User = self.appState[\.userData].user.value!
                        user.name = name
                        user.lastName = lastname
                        user.userName = username
                    }
                    .sinkEmptyAndStore()
                }
            } receiveValue: { _ in
                


                
//                self.userDBRepository.updateUser(user: user)
//                    .sink { _ in
//
//                    } receiveValue: { _ in
//                        self.appState[\.userData].user = .loaded(user)
//                    }
//                    .store(in: cancelBag)
            }
            .store(in: cancelBag)
    }
}


struct StubProfileService: ProfileService {
    func saveProfileImage(image: PersistentImageModel) {
        
    }
    
    func updateUserInfo(username: String, name: String, lastname: String){
        
    }
    
    func loadProfileImage() -> AnyPublisher<Image?, Error>{
        Just(nil)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
