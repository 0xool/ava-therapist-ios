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
    func addJournal(journal: Journal) -> AnyPublisher<Void, Error>
    func deleteJournal(journalID: Int) -> AnyPublisher<Void, Error>
    
    func getJournalByDate(date: Date) -> AnyPublisher<Journal, Error>
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
                DiaryBook(journals: $0.data)
            }
            .eraseToAnyPublisher()
    }
    
    func addJournal(journal: Journal) -> AnyPublisher<Void, Error> {
        let request: AddJournalRequest = AddJournalRequest(diary: journal)
        
        let url = getPath(api: .addJournal)
        do {
            let parameters = try JSONEncoder().encode(request)
            let params = try JSONSerialization.jsonObject(with: parameters, options: []) as? [String: Any] ?? [:]
            let request: AnyPublisher<AddJournalResponse, Error> = SendRequest(pathVariable: nil, params: params, url: url)
            
            return request
                .map{ _ in }
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
    
    func getJournalByDate(date: Date) -> AnyPublisher<Journal, Error>{
        let url = getPath(api: .getDiaryByDate, date: date.description)
        
            let request: AnyPublisher<GetJournalByDateResponse, Error> =  GetRequest(pathVariable: nil, params: nil, url: url)
            
            return request
                .map{
                    $0.data
                }
                .eraseToAnyPublisher()
    }
}

extension MainJournalRepository {
    
    enum API: String {
        case allJournals = "getDiaryList"
        case addJournal = "addDiary"
        case deleteJournal = "deleteDiary"
        case getDiaryByDate = "getDiaryByDate"
    }
    
    func getPath(api: API, journalID: Int? = nil, date: String? = nil) -> String {
        let mainUrl = "\(baseURL)\(JournalAPI)/\(api.rawValue)"
        switch api {
        case .addJournal:
            return mainUrl
        case .allJournals:
            return mainUrl
        case .getDiaryByDate:
            guard let date = date else {
                return mainUrl
            }
            
            return "\(mainUrl)/\(date)"
        case .deleteJournal:
            guard let id = journalID else {
                return mainUrl
            }
            
            return "\(mainUrl)/\(id)"
        }
    }
}
