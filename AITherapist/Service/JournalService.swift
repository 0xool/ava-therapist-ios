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
                    _ = journalDBRepository.store(journal: journal)
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
                var newJournals = journals.wrappedValue.value?.journals.filter{$0.id != journalID}
                journals.wrappedValue = .loaded(DiaryBook(journals: newJournals!))
            }
            .store(in: cancelBag)
    }
}

struct StubJournalService: JournalService {
    func deleteJournal(journalID: Int, journals: LoadableSubject<DiaryBook>) {
        
    }
    
    func saveJournal(journal: Journal, journals: LoadableSubject<DiaryBook>) {
        
    }
    
    func loadJournalList(journals: LoadableSubject<DiaryBook>) {
    }
}

