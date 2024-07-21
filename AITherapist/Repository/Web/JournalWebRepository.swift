//
//  JournalRepository.swift
//  AITherapist
//
//  Created by Cyrus Refahi on 11/5/23.
//

import Combine
import Foundation
import Alamofire

protocol JournalWebRepository: WebRepository {
    func loadJournalList() -> AnyPublisher<[Journal], ServerError>
    func addJournal(journal: Journal) -> AnyPublisher<Void, ServerError>
    func deleteJournal(journalID: Int) -> AnyPublisher<Void, ServerError>
    
    func getJournalByDate(date: Date) -> AnyPublisher<Journal?, ServerError>
}

struct MainJournalWebRepository: JournalWebRepository {
    var AFSession: Session
    var session: URLSession
    var baseURL: String
    
    var bgQueue: DispatchQueue = Constants.bgQueue
    static let JournalAPI = "diary"
    
    init(baseURL: String, session: URLSession) {
        self.baseURL = baseURL
        self.session = session
        self.AFSession = setAFSession(session, queue: bgQueue)
    }
    
    func loadJournalList() -> AnyPublisher<[Journal], ServerError> {
        
        let request: AnyPublisher<GetAllJournalResponse, ServerError> = webRequest(api: API.allJournals)
        
        return request
            .map{
                $0.data
            }
            .eraseToAnyPublisher()
    }
    
    func addJournal(journal: Journal) -> AnyPublisher<Void, ServerError> {
        let request: AddJournalRequest = AddJournalRequest(diary: journal)
        
        do {
            let parameters = try JSONEncoder().encode(request)
            let params = try JSONSerialization.jsonObject(with: parameters, options: []) as? [String: Any] ?? [:]
            let request: AnyPublisher<AddJournalResponse, ServerError> = webRequest(api: API.addJournal(params: params))
                        
            return request
                .map{ _ in }
                .eraseToAnyPublisher()
        } catch {
            return Fail(error: ServerError()).eraseToAnyPublisher()
        }
    }
    
    func deleteJournal(journalID: Int) -> AnyPublisher<Void, ServerError>{
        let request: AnyPublisher<DeleteJournalResponse, ServerError> = webRequest(api: API.deleteJournal(journalID: journalID))
        
        return request
            .map{ _ in
                
            }
            .eraseToAnyPublisher()
    }
    
    func getJournalByDate(date: Date) -> AnyPublisher<Journal?, ServerError>{
        let request: AnyPublisher<GetJournalByDateResponse, ServerError> = webRequest(api: API.getDiaryByDate(date: date.description))
        
        return request
            .map{
                $0.data
            }
            .eraseToAnyPublisher()
    }
}

extension MainJournalWebRepository {
    enum API: APICall {
        case allJournals
        case addJournal(params: Parameters?)
        case deleteJournal(journalID: Int)
        case getDiaryByDate(date: String)
        
        var url: String {
            switch self {
            case .allJournals:
                return "\(MainJournalWebRepository.JournalAPI)/getDiaryList"
            case .addJournal:
                return "\(MainJournalWebRepository.JournalAPI)/addDiary"
            case let .deleteJournal(journalID):
                return "\(MainJournalWebRepository.JournalAPI)/deleteDiary/\(journalID)"
            case let .getDiaryByDate(date):
                return "\(MainJournalWebRepository.JournalAPI)/getDiaryByDate/\(date)"
            }
        }
        
        var method: HTTPMethod {
            switch self {
            case .allJournals:
                return .get
            case .addJournal:
                return .post
            case .deleteJournal:
                return .delete
            case .getDiaryByDate:
                return .get
            }
        }
        
        var headers: HTTPHeaders? {
            nil
        }
        
        var encoding: ParameterEncoding {
            switch self {
            case .allJournals:
                return URLEncoding.default
            case .addJournal:
                return JSONEncoding.default
            case .deleteJournal:
                return URLEncoding.default
            case .getDiaryByDate:
                return URLEncoding.default
            }
        }
        
        var parameters: Parameters? {
            switch self {
            case .allJournals:
                return nil
            case let .addJournal(params):
                return params
            case .deleteJournal:
                return nil
            case .getDiaryByDate:
                return nil
            }
        }
    }
}
