//
//  JournalRepository.swift
//  AITherapist
//
//  Created by Cyrus Refahi on 11/5/23.
//

import Combine
import Foundation

protocol JournalWebRepository: WebRepository {
    func loadJournalList() -> AnyPublisher<DiaryBook, Error>
    func addJournal(journal: Journal) -> AnyPublisher<Void, Error>
    func deleteJournal(journalID: Int) -> AnyPublisher<Void, Error>
    
    func getJournalByDate(date: Date) -> AnyPublisher<Journal, Error>
}

struct MainJournalWebRepository: JournalWebRepository {
    var AFSession: Session
    var session: URLSession
    var baseURL: String
    
    var bgQueue: DispatchQueue = Constants.bgQueue
    let JournalAPI = "diary"
    
    init(baseURL: String, session: URLSession) {
        self.baseURL = baseURL
        self.session = session
        self.AFSession = setAFSession(session, queue: bgQueue)
    }
    
    func loadJournalList() -> AnyPublisher<DiaryBook, Error> {
        
        let request: AnyPublisher<GetAllJournalResponse, Error> = webRequest(url: getPath(api: .allJournals), method: .get, parameters: nil, headers: nil)
        
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
            let request: AnyPublisher<AddJournalResponse, Error> =
            webRequest(url: url, method: .post, parameters: params, headers: nil)
            
            return request
                .map{ _ in }
                .eraseToAnyPublisher()
        } catch {
            return Fail(error: error).eraseToAnyPublisher()
        }
    }
    
    func deleteJournal(journalID: Int) -> AnyPublisher<Void, Error>{
        let url = getPath(api: .deleteJournal, journalID: journalID)
        
        let request: AnyPublisher<DeleteJournalResponse, Error> = webRequest(url: url, method: .delete, parameters: nil, headers: nil)
        
        return request
            .map{ _ in
                
            }
            .eraseToAnyPublisher()
    }
    
    func getJournalByDate(date: Date) -> AnyPublisher<Journal, Error>{
        let url = getPath(api: .getDiaryByDate, date: date.description)
        
        let request: AnyPublisher<GetJournalByDateResponse, Error> = webRequest(url: url, method: .get, parameters: nil)
        
        return request
            .map{
                $0.data
            }
            .eraseToAnyPublisher()
    }
}

extension MainJournalWebRepository {
    
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
