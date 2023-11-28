//
//  ProfileService.swift
//  AITherapist
//
//  Created by cyrus refahi on 11/25/23.
//

import Foundation
import Combine
import SwiftUI

protocol ProfileService {
    func saveProfileImage(image: PersistentImageModel)
    func loadProfileImage() -> AnyPublisher<Image?, Error>
}


struct MainProfileService: ProfileService {
    let imagePersistenceRepository: ImagePersistenceRepository
    let appState: Store<AppState>
    
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
}


struct StubProfileService: ProfileService {
    func saveProfileImage(image: PersistentImageModel) {
        
    }
    
    func loadProfileImage() -> AnyPublisher<Image?, Error>{
        return Just(nil)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
