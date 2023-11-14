//
//  JournalRepository.swift
//  AITherapist
//
//  Created by cyrus refahi on 11/5/23.
//

import Combine
import Foundation

protocol JournalRepository: WebRepository {
    func loadJournalList() -> AnyPublisher<DiaryBook, Error>
//    func addJournal(data: AddJournalRequest) -> AnyPublisher<Void, Error>
    func deleteJournal(journalID: Int) -> AnyPublisher<Void, Error>
}

struct MainJournalRepository: JournalRepository {
    
    var baseURL: String
    let JournalAPI = "diary"

    init(baseURL: String) {
        self.baseURL = baseURL
    }
    
    func loadJournalList() -> AnyPublisher<DiaryBook, Error> {
        
        let request: AnyPublisher<GetAllJournalResponse, Error> = GetRequest(pathVariable: nil, params: nil, url: getPath(api: .allJournals))
        
        return request
            .map{
                return $0.data
            }
            .eraseToAnyPublisher()
    }
    
    func addJournal(data: AddJournalRequset) -> AnyPublisher<Void, Error> {
        let url = getPath(api: .addJournal)
        do {
            let parameters = try JSONEncoder().encode(data)
            let params = try JSONSerialization.jsonObject(with: parameters, options: []) as? [String: Any] ?? [:]
            let request: AnyPublisher<AddJournalResponse, Error> = SendRequest(pathVariable: nil, params: params, url: url)
            return request
                .map{ _ in
                    
                }
                .eraseToAnyPublisher()
        } catch {
            return Fail(error: error).eraseToAnyPublisher()
        }
    }
    
    func deleteJournal(journalID: Int) -> AnyPublisher<Void, Error>{
        let url = getPath(api: .deleteJournal, journalID: journalID)
        
        let request: AnyPublisher<DeleteJournalResponse, Error> = DeleteRequest(pathVariable: nil, params: nil, url: url)
            
        return request
            .map{ _ in
                
            }
            .eraseToAnyPublisher()
    }
}

extension MainJournalRepository {
    
    enum API: String {
        case allJournals = "getDiaryList"
        case addJournal = "addDiary"
        case deleteJournal = "deleteDiary"
    }
    
    func getPath(api: API, journalID: Int? = nil) -> String {
        let mainUrl = "\(baseURL)\(JournalAPI)/\(api.rawValue)"
        switch api {
        case .addJournal:
            return mainUrl
        case .allJournals:
            return mainUrl
        case .deleteJournal:
            guard let id = journalID else {
                return mainUrl
            }
            
            return "\(mainUrl)/\(id)"
        }
    }
}
