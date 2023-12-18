//
//  JournalService.swift
//  AITherapist
//
//  Created by Cyrus Refahi on 11/15/23.
//


import Combine
import Foundation
import SwiftUI

protocol JournalService {
    func loadJournalList(journals: LoadableSubject<[Journal]>)
    func deleteJournal(journalID: Int, journals: LoadableSubject<[Journal]>)
    func saveJournal(journal: Journal, journals: LoadableSubject<[Journal]>)
    
    func saveJournal(journal: LoadableSubject<Journal>)
    func getJournal(byDate: Date, journal: LoadableSubject<Journal>)
}

struct MainJournalService: JournalService {
    let journalRepository: JournalWebRepository
    let journalDBRepository: JournalDBRepository
    let appState: Store<AppState>
    
    init(journalRepository: JournalWebRepository, journalDBRepository: JournalDBRepository, appState: Store<AppState>) {
        self.journalRepository = journalRepository
        self.journalDBRepository = journalDBRepository
        self.appState = appState
    }
    
    func saveJournal(journal: LoadableSubject<Journal>){
        let cancelBag = CancelBag()
        journal.wrappedValue.setIsLoading(cancelBag: cancelBag)

        if let journalValue = journal.wrappedValue.value {
            journalDBRepository.store(journal: journalValue, fromServer: false)
                .sinkToResult({ _ in })
                .store(in: CancelBag())
        }
        
        Just<Void>
            .withErrorType(Error.self)
            .flatMap{
                journalRepository
                    .addJournal(journal: journal.wrappedValue.value!)
            }
            .sink { completion in
                switch completion {
                case .finished:
                    print("Finished")
                case .failure(let error):
//                    journal.wrappedValue = .failed(error)
                    print(error)
                }
            } receiveValue: {
                
            }
            .store(in: cancelBag)
    }
    
    func saveJournal(journal: Journal, journals: LoadableSubject<[Journal]>){
        let cancelBag = CancelBag()
        journals.wrappedValue.setIsLoading(cancelBag: cancelBag)
        
        journalRepository
            .addJournal(journal: journal)
            .sink { completion in
                switch completion {
                case .finished:
                    print("finished")
                case .failure(let error):
                    print(error)
                }
            } receiveValue: { 
                var newJournals = journals.wrappedValue.value
                newJournals?.append(journal)
                journals.wrappedValue = .loaded(newJournals!)
            }
            .store(in: cancelBag)
    }
    
    func loadJournalList(journals: LoadableSubject<[Journal]>) {
        
        let cancelBag = CancelBag()
        journals.wrappedValue.setIsLoading(cancelBag: cancelBag)
        
        journalRepository
            .loadJournalList()
            .map{ [journalDBRepository] in
                if let journals = journals.wrappedValue.value{
                    for journal in journals {
                        _ = journalDBRepository.store(journal: journal, fromServer: true)
                    }
                }

                
                return $0
            }
            .sinkToLoadable { journals.wrappedValue = $0 }
            .store(in: cancelBag)
    }
    
    func deleteJournal(journalID: Int, journals: LoadableSubject<[Journal]>){
        let cancelBag = CancelBag()
        journals.wrappedValue.setIsLoading(cancelBag: cancelBag)
        
        journalRepository
            .deleteJournal(journalID: journalID)
            .map{ [journalDBRepository] in
                _ = journalDBRepository.deleteJournal(journalID: journalID)
                return $0
            }
            .sinkToLoadable { _ in
                let newJournals = journals.wrappedValue.value?.filter{$0.id != journalID}
                journals.wrappedValue = .loaded(newJournals!)
            }
            .store(in: cancelBag)
    }
    
    func getJournal(byDate: Date, journal: LoadableSubject<Journal>){
        let cancelBag = CancelBag()
        journal.wrappedValue.setIsPartialyLoaded(val: Journal(), cancelBag: cancelBag)
        
        Just<Void>
            .withErrorType(Error.self)
            .flatMap { _ -> AnyPublisher<Void, Error> in
                self.refreshJournal(byDate: byDate)
                    .sinkEmptyAndStore()
                
                return Just<Void>
                    .withErrorType(Error.self)
            }
            .flatMap { _ -> AnyPublisher<Journal, Error> in
                journalDBRepository.getJournal(byDate: byDate)
            }
            .sinkToLoadable { journal.wrappedValue = $0 }
            .store(in: cancelBag)
    }
    
    func refreshJournal(byDate: Date) -> AnyPublisher<Void, Error>{
        journalRepository
            .getJournalByDate(date: byDate)
            .ensureTimeSpan(requestHoldBackTimeInterval)
            .map { [journalDBRepository] in
                journalDBRepository.store(journal: $0, fromServer: true)
                    .sinkEmptyAndStore()
            }
            .eraseToAnyPublisher()
    }
    
    private var requestHoldBackTimeInterval: TimeInterval {
        return ProcessInfo.processInfo.isRunningTests ? 0 : 0.0
    }
}

struct StubJournalService: JournalService {
    func saveJournal(journal: LoadableSubject<Journal>){
        
    }
    
    func deleteJournal(journalID: Int, journals: LoadableSubject<[Journal]>) {
        
    }
    
    func saveJournal(journal: Journal, journals: LoadableSubject<[Journal]>) {
        
    }
    
    func loadJournalList(journals: LoadableSubject<[Journal]>) {
    }
    
    func getJournal(byDate: Date, journal: LoadableSubject<Journal>){
        journal.wrappedValue = .loaded(.init(id: 0, diaryMessage: "This Diary was writtne a while ago", diaryName: "jounal name", moodID: nil, summary: nil, dateCreated: .now, tags: [.Happy]))
    }
}

