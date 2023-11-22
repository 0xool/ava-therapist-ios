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
    func store(journal: Journal, fromServer: Bool) -> AnyPublisher<Void, Error>
    func loadJournals() -> AnyPublisher<LazyList<Journal>, Error>
    func deleteJournal(journalID: Int)
    func getJournal(byDate: Date) -> AnyPublisher<Journal, Error>
}

struct MainJournalDBRepository: JournalDBRepository {
    func getJournal(byDate: Date) -> AnyPublisher<Journal, Error> {
        getJournalByDate(date: byDate)
    }
    
    func store(journal: Journal, fromServer: Bool) -> AnyPublisher<Void, Error> {
        writeJournalData(journal: journal, fromServer: fromServer)
    }
    
    func loadJournals() -> AnyPublisher<LazyList<Journal>, Error> {
        readAllJournals()
    }
    
    func deleteJournal(journalID: Int) {
        deleteJournalData(journalID: journalID)
    }
}


extension MainJournalDBRepository {
    private func writeJournalData(journal: Journal, fromServer: Bool = false) -> AnyPublisher<Void, Error> {
        var journal = journal
        print(journal.tags)
        return Just<Void>
            .withErrorType(Error.self)
            .flatMap { _ in
                self.deleteJournalIfExistsByDate(journal: &journal, fromServer: fromServer)
            }
            .flatMap{ _ in
                return DataBaseManager.Instance.Write(writeData: journal)
            }
            .eraseToAnyPublisher()
    }
    
    private func deleteJournalIfExistsByDate(journal: inout Journal,fromServer: Bool = false) -> AnyPublisher<Void, Error>{
        let dateString = journal.dateCreated.description.prefix(10).description
        return DataBaseManager.Instance.GetByQuery(ofType: Journal.self) {
            $0.dateCreatedString == dateString
        }
            .map{ [journal] in
                guard let journalDB = $0.first else{
                    return
                }

                // Due to not storing this data in the storage
                #warning("instead of delete update the values!!")
                if fromServer {
                    journal.tags = journalDB.tags
                }
                
                _ = DataBaseManager.Instance.DeleteByID(ofType: Journal.self, id: journalDB.id )
            }
            .eraseToAnyPublisher()
    }
    
    private func getJournalByDate(date: Date) -> AnyPublisher<Journal, Error>{
        let dateString = date.description.prefix(10).description
        return DataBaseManager.Instance.GetByQuery(ofType: Journal.self) {
            $0.dateCreatedString == dateString
        }
            .map{
                $0.first ?? Journal()
            }
            .eraseToAnyPublisher()
    }
    
    private func isSameDay(firstDate: Date, secondDate: Date) -> Bool{
        firstDate.get(.day, .month, .year) == secondDate.get(.day, .month, .year)
    }
    
    private func deleteJournalData(journalID: Int) {
        _ = DataBaseManager.Instance.DeleteByID(ofType: Journal.self, id: journalID)
    }
    
    private func readAllJournals() -> AnyPublisher<LazyList<Journal>, Error> {
        let journals: LazyList<Journal> = DataBaseManager.Instance.GetAll().lazyList
        
        return Just(journals)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}

