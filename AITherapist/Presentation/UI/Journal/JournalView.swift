//
//  JournalView.swift
//  AITherapist
//
//  Created by cyrus refahi on 11/5/23.
//

import Foundation
import SwiftUI

struct JournalView: View {
    let namespace: Namespace.ID
    let journal: Journal
    let index: Int
    
    @State private var journalEntryText: String = "Today was..."
    @Binding var hideDetail: Bool
    @ObservedObject private(set) var viewModel: ViewModel
    
    @State private var showAnimation: Bool = true

    init(namespace: Namespace.ID, journal: Journal, index: Int, hideDetail: Binding<Bool>, viewModel: ViewModel) {
        self.namespace = namespace
        self.journal = journal
        self.index = index
        self._hideDetail = hideDetail
        self.viewModel = viewModel
        
        self.journalEntryText = journal.diaryMessage
    }
    
    var body: some View {
        VStack{
            Button {
                withAnimation {
                    showAnimation.toggle()
                    hideDetail.toggle()
                }
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.largeTitle)
                    .foregroundStyle(.red)
                    .opacity(showAnimation ? 0 : 1 )
            }
            .frame(maxWidth: .infinity, alignment: .topLeading)
            
            DaySelectorView()
                .opacity(showAnimation ? 0 : 1 )
            
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
                .font(.footnote)
                .matchedGeometryEffect(id: "journalTitle\(index)", in: namespace)
            
            JournalEntryView(namespace: namespace, journalEntryText: $journalEntryText, index: index)
            
            Spacer()
                .frame(height: 25)
            
            JournalTagView()
            
            Spacer()
            
            sendButton
        }
        .matchedGeometryEffect(id: "journalDetailView\(index)", in: namespace)
        .frame(maxWidth: .infinity)
        .padding([.bottom], 35)
        .onAppear(perform: {
            self.journalEntryText = journal.diaryMessage
            withAnimation(.easeIn(duration: 0.3).delay(0.2)) {
                self.showAnimation.toggle()
            }
        })
    }
    
    
    @ViewBuilder var sendButton: some View{
        
        Button {
            self.viewModel.saveJournalEntry(journalEntry: self.journalEntryText)
        } label: {
            ZStack{
                RoundedRectangle(cornerRadius: 50)
                    .inset(by: 0.5)
                    .stroke(Color(red: 0.66, green: 0.66, blue: 0.66), lineWidth: 1)
                    .background(RoundedRectangle(cornerRadius: 50).foregroundStyle(ColorPallet.SecondaryColorGreen))
                
                Text("Save Journal Entry")
                    .font(
                        Font.custom("SF Pro Text", size: 16)
                            .weight(.bold)
                    )
                    .multilineTextAlignment(.center)
                    .foregroundColor(.black)
            }
        }
        .padding(.horizontal, 30)
        .padding(.vertical, 5)
        .frame(height: 50, alignment: .center)
        .frame(maxWidth: .infinity)
        .matchedGeometryEffect(id: "journalButton\(index)", in: namespace)
    }
}

extension JournalView{
    struct JournalTagView: View {
        var body: some View {
            TagView()
        }
        
        struct TagView: View {
            var body: some View {
                VStack{
                    Text("Choose a tag for today’s journal!")
                        .font(
                            Font.custom("SF Pro Text", size: 15)
                                .weight(.semibold)
                        )
                        .foregroundColor(.black)
                        .frame(width: 225, height: 21, alignment: .topLeading)
                    LazyVStack{
                        LazyHStack{
                            Tag(tagName: "Personal")
                            Tag(tagName: "Personal")
                            Tag(tagName: "Personal")
                            Tag(tagName: "Personal")
                            Tag(tagName: "Personal")
                        }
                        LazyHStack{
                            Tag(tagName: "Personal")
                            Tag(tagName: "Personal")
                            Tag(tagName: "Personal")
                        }
                    }
                    .lineLimit(2)
                }
            }
        }
        
        struct Tag: View {
            let tagName: String
            @State var selected = false
            @State var tagOffset: Double = -30
            @State var tagOpacity: Double = 0
            
            var body: some View {
                HStack(alignment: .center, spacing: 10) {
                    Text(tagName)
                        .font(Font.custom("SF Pro Text", size: 12))
                        .foregroundColor(.black)
                }
                .padding(.horizontal, 5)
                .padding(.vertical, 3)
                .cornerRadius(5)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .inset(by: -0.5)
                        .stroke(Color(red: 0.5, green: 0.5, blue: 0.5), lineWidth: 1)
                )
                .opacity(tagOpacity)
                .offset(x: tagOffset, y: 0)
                .onAppear(perform: {
                    withAnimation(.easeIn(duration: 0.6)) {
                        tagOpacity = 1
                        tagOffset = 0
                    }
                })
            }
        }
    }
    
    
}

extension JournalView{
    struct JournalEntryView: View {
        var namespace: Namespace.ID
        @Binding var journalEntryText: String
        let index: Int
        var body: some View {
            
            ZStack {
                GeometryReader{ geo in
                    TextEditor(text: $journalEntryText)
                        .font(Font.custom("SF Pro Text", size: 12))
                        .foregroundColor(Color(red: 0.5, green: 0.5, blue: 0.5))
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                        .matchedGeometryEffect(id: "journalContent\(index)", in: namespace)
                    VStack{
                        Image(systemName: "paperclip")
                            .frame(width: 25, height: 25)
                        Image(systemName: "mic")
                            .frame(width: 25, height: 25)
                    }
                    .offset(x: geo.size.width - 20, y: geo.size.height - 60)
                }
                .padding([.leading, .trailing], 24)
                .padding([.top, .bottom], 8)
            }
            .frame(minHeight: 200, maxHeight: 400)
            .background(.white)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .inset(by: 0.5)
                    .stroke(Color(red: 0.75, green: 0.75, blue: 0.75), lineWidth: 1)
                    .padding([.leading, .trailing], 16)
                    .matchedGeometryEffect(id: "journalContetnBackground\(index)", in: namespace)
            )
        }
    }
}

extension JournalView {
    struct DaySelectorView: View {
        var body: some View {
            ScrollView(.horizontal) {
                LazyHStack {
                    ForEach(0...30, id: \.self) { index in
                        DaySelectorCell(day: index, weekDay: .init(day: index % 7)!)
                    }
                }
            }
            .padding([.leading, .trailing], 8)
            .frame(height: 100)
        }
        
        struct DaySelectorCell: View {
            let day: Int
            let weekDay: WeekDay
            
            var body: some View {
                ZStack {
                    VStack(alignment: .center, spacing: 3) {
                        Text("\(weekDay.rawValue)")
                            .font(Font.custom("SF Pro Text", size: 13))
                            .multilineTextAlignment(.center)
                            .foregroundColor(.black)
                        Text("\(day)")
                            .font(Font.custom("SF Pro Text", size: 16))
                            .multilineTextAlignment(.center)
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity, minHeight: 18, maxHeight: 18, alignment: .top)
                    }
                    
                }
                .frame(width: 40, height: 51)
                .background(Color(red: 0.75, green: 0.75, blue: 0.75).opacity(0.4))
                .cornerRadius(10)
            }
        }
    }
}

extension JournalView {
    class ViewModel: ObservableObject {
        //        let container: DIContainer
        //
        //        init(container: DIContainer) {
        //            self.container = container
        //        }
        
        
        func saveJournalEntry(journalEntry: String){
            if !onSaveEnterInputCorrect(journalEntry){return}
            
            print(journalEntry)
        }
        
        func onSaveEnterInputCorrect(_ journalEntry: String) -> Bool {
            journalEntry.count > 0
        }
    }
}

struct JournalView_Preview: PreviewProvider {
    @Namespace static var namespace
    
    static var previews: some View{
        JournalView(namespace: namespace, journal: Journal(id: 1, diaryMessage: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.", diaryName: "Entry one", moodID: 1, summary: "", dateCreated: .now - 2), index: 1, hideDetail: .constant(false), viewModel: .init())
    }
}

