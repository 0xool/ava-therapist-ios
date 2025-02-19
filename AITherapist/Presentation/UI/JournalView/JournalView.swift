//
//  JournalView.swift
//  AITherapist
//
//  Created by Cyrus Refahi on 11/5/23.
//

import Foundation
import SwiftUI
import Combine

struct JournalView: View {
    @ObservedObject private(set) var viewModel: ViewModel
    @State var showAllJournals: Bool = false
    
    init( viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        if self.showAllJournals{
            JournalListView(showAllJournalsView: $showAllJournals, selectedDate: $viewModel.selectedDate, viewModel: .init(container: self.viewModel.container))
        }else{
            diaryEntryView
        }
    }
}

extension JournalView {
    @ViewBuilder var diaryEntryView: some View {
        VStack{
            DatePicker("Select Date", selection: $viewModel.selectedDate, displayedComponents: [.date])
                .padding(.horizontal)
                .id(viewModel.selectedDate)
            
            VStack{
                DaySelectorView(currentDate: $viewModel.selectedDate, viewModel: self.viewModel)
                
                JournalEntryView(journalEntryText: $viewModel.journalEntryText)
                
                JournalTagView(viewModel: viewModel)
                
                Spacer()
                
                sendButton
            }
            .onTapGesture {
                self.hideKeyboard()
            }
        }
        .sheet(isPresented: self.$viewModel.showSuccesfullSave, content: {
            JournalSavedView(show: self.$viewModel.showSuccesfullSave, onChatClicked: {
                
            }, onAllJournalsClicked: {
                
            })
        })
        .frame(maxWidth: .infinity)
        .padding([.bottom], 35)
    }
    
    @ViewBuilder var sendButton: some View{
        VStack(spacing: 10) {
            Button {
                self.viewModel.saveJournalEntry()
            } label: {
                ZStack{
                    RoundedRectangle(cornerRadius: 50)
                        .inset(by: 0.5)
                        .stroke(Color(red: 0.66, green: 0.66, blue: 0.66), lineWidth: 1)
                        .background(RoundedRectangle(cornerRadius: 50).foregroundStyle(ColorPallet.DiarySaveButtonBlue))
                    
                    Text("Save")
                        .font(
                        Font.custom("SF Pro Text", size: 13)
                        .weight(.bold)
                        )
                        .multilineTextAlignment(.center)
                        .foregroundColor(self.viewModel.textFilled ? ColorPallet.Celeste : ColorPallet.DiaryIconBlue)
                    
                }
            }
            .padding(.horizontal, 30)
            .padding(.vertical, 5)
            .frame(height: 50, alignment: .center)
            .frame(maxWidth: .infinity)
            
            Button {
                self.showAllJournals = true
            } label: {
                Text("All Journals")
                    .font(
                    Font.custom("SF Pro Text", size: 13)
                    .weight(.bold)
                    )
                    .underline()
                    .multilineTextAlignment(.center)
                    .foregroundColor(ColorPallet.DiaryDateBlue)
            }
            .padding(.horizontal, 30)
            .frame(maxWidth: .infinity)
        }
        .padding(.bottom, 32)
    }
}

extension JournalView{
    struct JournalTagView: View {
        let viewModel: ViewModel
        
        var body: some View {
            TagView()
        }
        
        func TagView() -> some View {
            return VStack{
                HStack{
                    Text("Selected Tag:")
                        .frame(height: 21, alignment: .topLeading)
                    Spacer()
                    LazyHStack{
                        ForEach(viewModel.journal.tags, id: \.self) { tag in
                            Tag(tag: tag)
                                .onTapGesture {
                                    withAnimation{
                                        unSelectTag(tag)
                                    }
                                }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                .frame(height: 50)
                .padding([.leading, .trailing], 16)
                .hiddenModifier(isHide: viewModel.journal.tags.isEmpty)
                
                VStack{
                    Text("Choose a tag for today’s journal!")
                        .font(
                        Font.custom("SF Pro Text", size: 15)
                        .weight(.semibold)
                        )
                        .foregroundColor(ColorPallet.DiaryDateBlue)
                        .frame(height: 21, alignment: .center)
                    LazyVStack{
                        ScrollView(.horizontal) {
                            LazyHStack{
                                ForEach(viewModel.tags, id: \.self) { tag in
                                    Tag(tag: tag)
                                        .onTapGesture {
                                            withAnimation{
                                                selectTag(tag)
                                            }
                                        }
                                }
                            }
                            .padding(8)
                        }
                        .scrollIndicators(.hidden)
                    }
                    .lineLimit(2)
                }
                .hiddenModifier(isHide: viewModel.tags.isEmpty)
            }
        }
        
        func selectTag(_ tag: JournalTagType){
            if !viewModel.tags.contains(where: { $0 == tag }) {return}
            viewModel.tags.removeAll { $0 == tag }
            viewModel.journal.tags.append(tag)
        }
        
        func unSelectTag(_ tag: JournalTagType){
            if !viewModel.journal.tags.contains(where: { $0 == tag }) {return}
            viewModel.journal.tags.removeAll { $0 == tag }
            self.viewModel.tags.append(tag)
        }
        
        struct Tag: View {
            let tag: JournalTagType
            @State var selected = false
            @State var tagOffset: Double = -30
            @State var tagOpacity: Double = 0
            
            var body: some View {
                HStack(alignment: .center, spacing: 10) {
                    Text(tag.tag)
                        .font(Font.custom("SF Pro Text", size: 12))
                        .foregroundColor(ColorPallet.DarkBlue)
                }
                .padding(.horizontal, 5)
                .padding(.vertical, 3)
                .cornerRadius(5)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .inset(by: -0.5)
                        .stroke(ColorPallet.DiaryTagBorder, lineWidth: 1)
                )
                .opacity(tagOpacity)
                .offset(x: tagOffset, y: 0)
                .onAppear(perform: {
                    withAnimation(.easeIn(duration: 0.6)) {
                        tagOpacity = 1
                        tagOffset = 0
                    }
                })
                .frame(maxWidth: 75)
            }
        }
    }
}

extension JournalView{
    struct JournalEntryView: View {
        @Binding var journalEntryText: String
        
        var body: some View {
            ZStack {
                GeometryReader{ geo in
                    TextEditor(text: $journalEntryText)
                        .font(Font.custom("SF Pro Text", size: 12))
                        .foregroundColor(ColorPallet.grey400)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                        .scrollContentBackground(.hidden)
                        .background(.clear)
                    
                    VStack{
                        Image(systemName: "paperclip")
                            .frame(width: 25, height: 25)
                            .foregroundStyle(ColorPallet.DiaryIconBlue)
                        Image(systemName: "mic")
                            .frame(width: 25, height: 25)
                            .foregroundStyle(ColorPallet.DiaryIconBlue)
                    }
                    .offset(x: geo.size.width - 20, y: geo.size.height - 60)
                }
                .background(.clear)
                .padding([.leading, .trailing], 24)
                .padding([.top, .bottom], 8)
            }
            .frame(minHeight: 200, maxHeight: 400)
            .cornerRadius(10)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(ColorPallet.LightCeleste)
                    .background{
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.black, lineWidth: 1)
                    }
                    .padding([.leading, .trailing], 16)
            )
        }
    }
}



extension JournalView {
    class ViewModel: ObservableObject {
        @Published var selectedDate: Date = .now
        @Published var journalLodable: Loadable<Journal>
        @Published var journalEntryText: String = MAIN_JOURNAL_TEXT
        
        @Published var tags = JournalTagType.allTypes
        @Published var showSuccesfullSave: Bool = false
        var textFilled: Bool {
            get{
                !self.journalEntryText.isEmpty
            }
        }
        
        var journal: Journal = Journal()
        static let MAIN_JOURNAL_TEXT = "How is your day? What are you grateful for today?"
        
        let container: DIContainer
        private var cancelBag = CancelBag()
        
        init(journal: Loadable<Journal> = .notRequested, container: DIContainer) {
            self.container = container
            self.journalLodable = .loaded(Journal())
            
            $selectedDate
                .debounce(for: .seconds(0), scheduler: DispatchQueue.main)
                .sink { [weak self] date in
                    self?.getJournal(date: date)
                }
                .store(in: cancelBag)
            
            $journalLodable
                .debounce(for: .seconds(0.1), scheduler: DispatchQueue.main)
                .sink{ [self] data in
                    
                    if let newJournal = data.value {
                        self.journal = Journal(id: newJournal.id, diaryMessage: newJournal.diaryMessage, diaryName: newJournal.diaryName, moodID: newJournal.moodID, summary: newJournal.summary, dateCreated: newJournal.dateCreated, tags: newJournal.tags)
                    }else{
                        self.journal = Journal()
                    }
                    
                    self.tags = JournalTagType.allTypes.filter{ !self.journal.tags.contains($0) }.sorted()
                    self.journalEntryText = self.journal.diaryMessage                                        
                }
                .store(in: cancelBag)
        }
        
        private func getJournal(date: Date){
            self.container.services.journalService.getJournal(byDate: date, journal: loadableSubject(\.journalLodable))
        }
        
        func saveJournalEntry(){
            if !onSaveEnterInputCorrect(journalEntryText){ return }
            
            self.journal.dateCreated = self.selectedDate
            self.journal.diaryName = "Diary Name: \(selectedDate)"
            
            self.journal.diaryMessage = journalEntryText
            self.journalLodable = .loaded(journal)
            self.container.services.journalService.saveJournal(journal: loadableSubject(\.journalLodable)) {
                self.showSuccesfullSave = true
            }
            self.showSuccesfullSave = true
        }
        
        func onSaveEnterInputCorrect(_ journalEntry: String) -> Bool {
            journalEntry.count > 0
        }
    }
}

#if DEBUG
struct JournalView_Preview: PreviewProvider {
    @Namespace static var namespace
    
    static var previews: some View{
        JournalView(viewModel: .init(container: .previews))
    }
}
#endif
