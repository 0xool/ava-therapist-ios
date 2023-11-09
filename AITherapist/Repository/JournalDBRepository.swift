//
//  JournalDBRepository.swift
//  AITherapist
//
//  Created by cyrus refahi on 11/7/23.
//

import Foundation
import RealmSwift
import Combine

protocol JournalDBRepository {
    func store(journal: Journal) -> AnyPublisher<Void, Error>
    func loadJournals() -> AnyPublisher<LazyList<Journal>, Error>
    func deleteJournal(journalID: Int)
}

struct MainJournalDBRepository: JournalDBRepository {
    func store(journal: Journal) -> AnyPublisher<Void, Error> {
        writeJournalData(journal: journal)
    }
    
    func loadJournals() -> AnyPublisher<LazyList<Journal>, Error> {
        readAllJournals()
    }
    
    func deleteJournal(journalID: Int) {
        deleteJournalData(journalID: journalID)
    }
}


extension MainJournalDBRepository {
    private func writeJournalData(journal: Journal) -> AnyPublisher<Void, Error> {
        return DataBaseManager.Instance.Write(writeData: journal)
    }
    
    private func deleteJournalData(journalID: Int) {
        DataBaseManager.Instance.DeleteByID(ofType: Journal.self, id: journalID)
    }
    
    private func readAllJournals() -> AnyPublisher<LazyList<Journal>, Error> {
        let journals: LazyList<Journal> = DataBaseManager.Instance.GetAll().lazyList
        
        return Just(journals)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}

