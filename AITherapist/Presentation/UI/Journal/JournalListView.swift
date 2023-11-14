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
        
    let diaryBook: DiaryBook = .init(journals:  [
        Journal(id: 0, diaryMessage: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.", diaryName: "Entry one", moodID: 1, userID: 1, summary: "", dateCreated: .now),
        
        Journal(id: 1, diaryMessage: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.", diaryName: "Entry one", moodID: 1, userID: 1, summary: "", dateCreated: .now - 2)
    ])
    
    var body: some View {
        ZStack{
            if !self.showJournalEditView{
                journalList
            }else{
                JournalView(namespace: journalNameSpace, journal: selectedJournal, index: selectedIndex, hideDetail: $showJournalEditView, viewModel: .init())
            }
        }
    }
    
    @ViewBuilder var journalList: some View {
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
    
    @ViewBuilder var listCellBackground: some View {
        RoundedRectangle(cornerRadius: 15)
            .fill(ColorPallet.SecondaryColorGreen.gradient)
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
        @Published var diaryBook: DiaryBook
        
        init(diaryBook: DiaryBook) {
            self.diaryBook = diaryBook
        }
        
    }
}

#Preview {
    JournalListView()
}
