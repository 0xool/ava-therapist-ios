//
//  JournalListView.swift
//  AITherapist
//
//  Created by cyrus refahi on 11/12/23.
//

import SwiftUI

struct JournalListView: View {
    @Namespace var journalNameSpace
    @State var showJournalEditView = false
    @State var selectedIndex = 0
    @State var selectedJournal: Journal = .init()
    
    @ObservedObject var viewModel: ViewModel
            
    var body: some View {
        mainContent
    }
    
    @ViewBuilder var mainContent: some View {
        switch self.viewModel.diaryBook {
        case .notRequested:
            notRequestedView
        case .isLoading(last: _, cancelBag: _):
            loadingView()
        case let .loaded(diaryBook):
            loadedView(diaryBook)
        case let .failed(error):
            failedView(error)
        case .partialLoaded(_):
            notRequestedView
        }
    }
    
//    @ViewBuilder var listCellBackground: some View {
//        RoundedRectangle(cornerRadius: 15)
//            .fill(ColorPallet.SecondaryColorGreen.gradient)
//    }
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

#warning("Handle Journal ERROR")
            print("Handle Journal ERROR")
        })
    }
}

// MARK: Displaying Content
private extension JournalListView{
    func loadedView(_ diaryBook: DiaryBook) -> some View {
        ZStack{
            if !self.showJournalEditView{
                journalList(diaryBook: diaryBook)
            }else{
                JournalView(namespace: journalNameSpace, journal: selectedJournal, index: selectedIndex, hideDetail: $showJournalEditView, viewModel: .init())
            }
        }
    }
    
    func journalList(diaryBook: DiaryBook) -> some View {
        ScrollView{
            VStack{
                ForEach(Array(diaryBook.journals.enumerated()), id: \.offset){ index, journal in
                    ListContent(namespace: journalNameSpace, journal: journal, index: index,  showDetail: $showJournalEditView){
                            self.selectedIndex = $0
                            self.selectedJournal = $1
                        }
                        .frame(maxWidth: .infinity, minHeight: 80)
                        .padding(16)
                        .shadow(color: .gray, radius: 1, x: 2, y: 2)
                    
                    Divider()
                }
            }
        }
    }
}

extension JournalListView{
    struct ListContent: View {
        var namespace: Namespace.ID
        let journal: Journal
        let index: Int
        
        @State var showInnerContent: Bool = false
        @Binding var showDetail: Bool
        let onClickJournal: (_ index: Int, _ journal: Journal) -> ()
        
        var body: some View {
            VStack{
                ZStack{
                    VStack{
                        Text(journal.dateCreated!.description)
                            .font(
                                Font.custom("SF Pro Text", size: 25)
                                    .weight(.bold)
                            )
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color(red: 0.15, green: 0.15, blue: 0.15))
                            .padding([.top], 8)
                            .matchedGeometryEffect(id: "journalDate\(index)", in: namespace)
                        
                        Text(journal.diaryName)
                            .matchedGeometryEffect(id: "journalTitle\(index)", in: namespace)
                        
                        if showInnerContent {
                            Text(journal.diaryMessage)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(ColorPallet.creameColor.gradient.opacity(0.7))
                                        .blur(radius: 30)
                                        .padding(-8)
                                        .hiddenModifier(isHide: !showInnerContent)
                                        .matchedGeometryEffect(id: "journalContetnBackground\(index)", in: namespace)
                                    
                                )
                                .padding([.top], showInnerContent ? 8 : 0)
                                .padding([.bottom], showInnerContent ? 16 : 0)
                                .padding([.leading, .trailing], showInnerContent ? 32 : 0)
                                .matchedGeometryEffect(id: "journalContent\(index)", in: namespace)
                        }
                    }

                    Button {
                        withAnimation{
                            onClickJournal(index, journal)
                            showDetail.toggle()
                        }
                    } label: {
                        Rectangle().fill(.clear)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                
                Spacer()
                expandButton
                
            }
            .background(ColorPallet.LightGreen.gradient)
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .matchedGeometryEffect(id: "journalDetailView\(index)", in: namespace)
        }
        
        @ViewBuilder var expandButton: some View{
            Button {
                withAnimation {
                    showInnerContent.toggle()
                }
            } label: {
                Image(systemName: showInnerContent ? "arrowtriangle.up.fill" : "arrowtriangle.down.fill")
                    .foregroundColor(.green)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            }
            .frame(height: 30)
            .frame(maxWidth: .infinity)
            .background(.ultraThinMaterial)
            .clipShape(.rect(
                topLeadingRadius: 0,
                bottomLeadingRadius: 15,
                bottomTrailingRadius: 15,
                topTrailingRadius: 0
            ))
            .matchedGeometryEffect(id: "journalButton\(index)", in: namespace)
            
        }
    }
}

extension JournalListView{
    class ViewModel: ObservableObject {
        let container: DIContainer
        let isRunningTests: Bool
        private var cancelBag = CancelBag()
        
        @Published var diaryBook: Loadable<DiaryBook>
        
        init(container: DIContainer, isRunningTests: Bool = false, cancelBag: CancelBag = CancelBag(), diaryBook: Loadable<DiaryBook> = .notRequested) {
            self.container = container
            self.isRunningTests = isRunningTests
            self.cancelBag = cancelBag
            self.diaryBook = diaryBook

            loadJournals()
        }
        
        func loadJournals(){
            self.container.services.journalService.loadJournalList(journals: loadableSubject(\.diaryBook))
        }
        
    }
}

#Preview {
    JournalListView(viewModel: .init(container: .init(appState: .preview, services: .stub)))
}
