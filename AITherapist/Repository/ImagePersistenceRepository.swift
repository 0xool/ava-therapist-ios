//
//  ImageRepository.swift
//  AITherapist
//
//  Created by Cyrus Refahi on 11/25/23.
//

import Foundation
import SwiftUI
import Combine

protocol ImagePersistenceRepository {
    func saveImage(_ image: PersistentImageModel, forKey key: MainImagePersistenceRepository.ImageKey)
    func loadImage(forKey key: MainImagePersistenceRepository.ImageKey) -> AnyPublisher<PersistentImageModel, Error>
}

class MainImagePersistenceRepository: ImagePersistenceRepository {
    func saveImage(_ image: PersistentImageModel, forKey key: ImageKey) {
        if let encodedData = try? JSONEncoder().encode(image) {
            UserDefaults.standard.set(encodedData, forKey: key.stringValue)
        }
    }
    
    func loadImage(forKey key: MainImagePersistenceRepository.ImageKey) -> AnyPublisher<PersistentImageModel, Error>
    {
        Future<PersistentImageModel, Error> { promise in
            if let imageData = UserDefaults.standard.data(forKey: key.rawValue) {
                if let image = try? JSONDecoder().decode(PersistentImageModel.self, from: imageData) {
                    promise(.success(image))
                }else{
                    promise(.failure(NSError(domain: "Image could not be decoded", code: 0, userInfo: nil)))
                }
            }else{
                promise(.failure(NSError(domain: "Image could not be found", code: 0, userInfo: nil)))
            }
        }
        .eraseToAnyPublisher()
    }
}

// MARK: Key Enum
extension MainImagePersistenceRepository {
    enum ImageKey: String {
        case profileImage = "profileImage"

        var stringValue: String {
            return self.rawValue
        }
    }
}

// MARK: Image Model
struct PersistentImageModel: Identifiable, Codable {
    var id = UUID()
    var imageData: Data
}

