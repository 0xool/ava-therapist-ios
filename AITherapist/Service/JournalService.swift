//
//  JournalService.swift
//  AITherapist
//
//  Created by cyrus refahi on 11/15/23.
//


import Combine
import Foundation
import SwiftUI

protocol JournalService {
    func loadJournalList(journals: LoadableSubject<DiaryBook>)
    func deleteJournal(journalID: Int, journals: LoadableSubject<DiaryBook>)
    func saveJournal(journal: Journal, journals: LoadableSubject<DiaryBook>)
    
    func saveJournal(journal: LoadableSubject<Journal>)
    func getJournal(byDate: Date, journal: LoadableSubject<Journal>)
}

struct MainJournalService: JournalService {
    let journalRepository: JournalRepository
    let journalDBRepository: JournalDBRepository
    let appState: Store<AppState>
    
    init(journalRepository: JournalRepository, journalDBRepository: JournalDBRepository, appState: Store<AppState>) {
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
                    journal.wrappedValue = .failed(error)
                    print(error)
                }
            } receiveValue: {
                
            }
            .store(in: cancelBag)
    }
    
    func saveJournal(journal: Journal, journals: LoadableSubject<DiaryBook>){
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
                var newJournals = journals.wrappedValue.value?.journals
                newJournals?.append(journal)
                journals.wrappedValue = .loaded(DiaryBook(journals: newJournals!))
            }
            .store(in: cancelBag)
    }
    
    func loadJournalList(journals: LoadableSubject<DiaryBook>) {
        
        let cancelBag = CancelBag()
        journals.wrappedValue.setIsLoading(cancelBag: cancelBag)
        
        journalRepository
            .loadJournalList()
            .map{ [journalDBRepository] in
                for journal in $0.journals {
                    _ = journalDBRepository.store(journal: journal, fromServer: true)
                }
                
                return $0
            }
            .sinkToLoadable { journals.wrappedValue = $0 }
            .store(in: cancelBag)
    }
    
    func deleteJournal(journalID: Int, journals: LoadableSubject<DiaryBook>){
        let cancelBag = CancelBag()
        journals.wrappedValue.setIsLoading(cancelBag: cancelBag)
        
        journalRepository
            .deleteJournal(journalID: journalID)
            .map{ [journalDBRepository] in
                journalDBRepository.deleteJournal(journalID: journalID)
                return $0
            }
            .sinkToLoadable { _ in
                let newJournals = journals.wrappedValue.value?.journals.filter{$0.id != journalID}
                journals.wrappedValue = .loaded(DiaryBook(journals: newJournals!))
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
            }
            .flatMap({ [journalDBRepository] in
                journalDBRepository.getJournal(byDate: byDate)
            })
            .sinkToLoadable { journal.wrappedValue = $0 }
            .store(in: cancelBag)
    }
    
    func refreshJournal(byDate: Date) -> AnyPublisher<Void, Error>{
        journalRepository
            .getJournalByDate(date: byDate)
            .ensureTimeSpan(requestHoldBackTimeInterval)
            .map { [journalDBRepository] in
                journalDBRepository.store(journal: $0, fromServer: true)
                    .sink { _ in
                        
                    } receiveValue: { _ in
                        
                    }
                    .store(in: CancelBag())
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
    
    func deleteJournal(journalID: Int, journals: LoadableSubject<DiaryBook>) {
        
    }
    
    func saveJournal(journal: Journal, journals: LoadableSubject<DiaryBook>) {
        
    }
    
    func loadJournalList(journals: LoadableSubject<DiaryBook>) {
    }
    
    func getJournal(byDate: Date, journal: LoadableSubject<Journal>){
        journal.wrappedValue = .loaded(.init(id: 0, diaryMessage: "This Diary was writtne a while ago", diaryName: "jounal name", moodID: nil, summary: nil, dateCreated: .now, tags: [.Happy]))
    }
}

