//
//  JournalDBRepositoryTests.swift
//  AITherapistTests
//
//  Created by cyrus refahi on 12/11/23.
//

import Foundation
import XCTest
@testable import AITherapist

class JournalDBRepositoryTests: XCTestCase {
    var mockedStore: MockedPersistentStore!
    var sut: MainJournalDBRepository!
    var cancelBag = CancelBag()
}
