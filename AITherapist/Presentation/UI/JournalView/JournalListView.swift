//
//  JournalListView.swift
//  AITherapist
//
//  Created by Cyrus Refahi on 11/12/23.
//

import SwiftUI

struct JournalListView: View {
    @State var showJournalEditView = false
    @State var selectedIndex = 0
    @State var selectedJournal: Journal = .init()
    
    @Binding var showAllJournalsView: Bool
    @Binding var selectedDate: Date
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        mainContent
    }
    
    @ViewBuilder var mainContent: some View {
        switch self.viewModel.journals {
        case .notRequested:
            notRequestedView
        case .isLoading(last: _, cancelBag: _):
            loadingView()
        case let .loaded(diaryBook):
            loadedView(diaryBook)
        case let .failed(error):
            failedView(error)
        case .partialLoaded(_, _):
            notRequestedView
        }
    }
}

// MARK: Loading Content
private extension JournalListView {
    private var notRequestedView: some View {
        Text("")
    }
    
    private func loadingView() -> some View {
        CircleLoading()
    }
    
    func failedView(_ error: Error) -> some View {
        ErrorView(error: error, retryAction: {
            self.showAllJournalsView = false
        })
    }
}

// MARK: Displaying Content
private extension JournalListView{
    func loadedView(_ diaryBook: [Journal]) -> some View {
        let diaryBook = diaryBook.sorted{ $0.dateCreated > $1.dateCreated }
        return journalList(diaryBook: diaryBook)
    }
    
    func journalList(diaryBook: [Journal]) -> some View {
        @ViewBuilder var journalListView: some View {
            ScrollView{
                VStack{
                    ForEach(Array(diaryBook.enumerated()), id: \.offset){ index, journal in
                        Button(action: {
                            self.selectedDate = journal.dateCreated
                            self.showAllJournalsView = false
                        }, label: {
                            ListContent(journal: journal)
                        })
                    }
                }
            }
        }
        
        return VStack{
            if diaryBook.isEmpty {
                Spacer()
                VStack(spacing: 8){
                    Text("No Journal Entry")
                        .font(Font.custom("SF Pro Text", size: 12))
                        .bold()
                        .foregroundColor(ColorPallet.DiaryDateBlue)
                        .frame(height: 21, alignment: .center)
                    createNewJournalButton
                }
                Spacer()
            }else{
                SearchableCustom(searchtxt: $viewModel.searchText)
                    .padding(.bottom, 8)
                journalListView
            }
        }
    }
    
    @ViewBuilder var createNewJournalButton: some View{
        Button {
            self.showAllJournalsView = false
        } label: {
            Text("Add Journal Entry")
                .padding(.horizontal, 20)
                .padding(.vertical, 5)
                .frame(height: 40, alignment: .center)
                .background(ColorPallet.SolidDarkGreen)
                .foregroundStyle(ColorPallet.Celeste)
                .cornerRadius(40)
        }
    }

}

extension JournalListView{
    struct SearchableCustom: View {
        @Binding var searchtxt: String
        @FocusState private var isSearchFocused: Bool
        
        var body: some View {
            HStack {
                HStack {
                    Image(systemName: "magnifyingglass")
                    TextField("Search keywords", text: $searchtxt)
                        .font(Font.custom("SF Pro Text", size: 16))
                        .focused($isSearchFocused)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 8)
                }
                .padding(.horizontal)
                .background(RoundedRectangle(cornerRadius: 25).fill(ColorPallet.LighterCeleste))
                if isSearchFocused {
                    Button("Cancel") {
                        searchtxt = ""
                        withAnimation(.spring()) {
                            isSearchFocused = false
                        }
                    }
                    .transition(.move(edge: .trailing))
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal)
        }
    }
}

extension JournalListView{
    struct ListContent: View {
        let journal: Journal
                
        var body: some View {
            
            VStack(alignment: .leading, spacing: 0) {
                HStack{
                    cellTitleTextView
                    Spacer()
                    Image(systemName: "chevron.right")
                    
                }
                .frame(height: 50)
                .padding(.horizontal, 20)
                
                Rectangle()
                    .fill(ColorPallet.MediumTurquoiseBlue)
                    .frame(maxWidth: .infinity)
                    .frame(height: 1)
            }
            .padding(.vertical, 0)
            .frame(maxWidth: .infinity)
            
        }
        
        @ViewBuilder var cellTitleTextView: some View {
            VStack(alignment: .leading){
                Text(Date.getJournalDateWithMonthDayYearFormat(date: journal.dateCreated))
                    .font(
                        Font.custom("SF Pro Text", size: 15)
                            .weight(.semibold)
                    )
                    .multilineTextAlignment(.leading)
                    .foregroundColor(ColorPallet.DarkGreenText)
                 
                    Text(journal.diaryMessage)
                        .font(Font.custom("SF Pro Text", size: 15))
                        .multilineTextAlignment(.leading)
                        .lineLimit(1)
                        .foregroundColor(ColorPallet.grey400)
//                        .frame(width: 114, alignment: .leading)
            }
            
        }
    }
}

extension JournalListView{
    class ViewModel: ObservableObject {
        @Published var searchText: String = ""
        let container: DIContainer
        let isRunningTests: Bool
        private var cancelBag = CancelBag()
        
        @Published var journals: Loadable<[Journal]>
        
        init(container: DIContainer, isRunningTests: Bool = false, cancelBag: CancelBag = CancelBag(), journals: Loadable<[Journal]> = .notRequested) {
            self.container = container
            self.isRunningTests = isRunningTests
            self.cancelBag = cancelBag
            self.journals = journals
            
            loadJournals()
        }
        
        func loadJournals(){
            self.container.services.journalService.loadJournalList(journals: loadableSubject(\.journals))
        }
    }
}

#if DEBUG
#Preview {
    JournalListView(showAllJournalsView: .constant(false), selectedDate: .constant(.now), viewModel: .init(container: .init(appState: .previews, services: .stub), journals: .loaded(Journal.journals)))
}
#endif
