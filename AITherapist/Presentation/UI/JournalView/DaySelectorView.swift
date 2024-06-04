//
//  DaySelectorView.swift
//  AITherapist
//
//  Created by Cyrus Refahi on 11/11/23.
//

import SwiftUI

extension JournalView{
    struct DaySelectorView: View {
        @Binding var currentDate: Date
        let viewModel: ViewModel
        
        var body: some View {
            ScrollViewReader { proxy in
                ScrollView(.horizontal) {
                    LazyHStack {
                        ForEach(getDaysOfMonth(for: currentDate), id: \.self) { date in
                            DaySelectorCell(day: date, isSelected: isSelected(date: date), hasEntry:   viewModel.dateHasEntry(date)).id(date)
                                .onTapGesture {
                                    withAnimation{
                                        currentDate = date
                                    }
                                }
                        }
                    }
                }
                .scrollIndicators(.hidden)
                .padding([.leading, .trailing], 8)
                .frame(height: 100)
                .onChange(of: currentDate) { newValue in
                    withAnimation(.easeIn(duration: 5).delay(5)){
                        proxy.scrollTo(getDaysOfMonth(for: currentDate).filter{ $0.get(.day) == currentDate.get(.day) }.first )
                    }
                }
                .onAppear{
                    withAnimation(.easeIn(duration: 5).delay(5)){
                        proxy.scrollTo(getDaysOfMonth(for: currentDate).filter{ $0.get(.day) == currentDate.get(.day) }.first )
                    }
                }
            }
        }
        
        func isSelected(date: Date) -> Bool { date.get(.day) == currentDate.get(.day) }
        
        func getDaysOfMonth(for date: Date) -> [Date] {
            let calendar = Calendar.current
            let range = calendar.range(of: .day, in: .month, for: date)!
            
            let startDateComponents = calendar.dateComponents([.year, .month], from: date)
            guard let startDate = calendar.date(from: startDateComponents) else {
                return []
            }
            
            var daysOfMonth: [Date] = []
            
            for day in range {
                var components = DateComponents()
                components.year = calendar.component(.year, from: startDate)
                components.month = calendar.component(.month, from: startDate)
                components.day = day
                
                if let date = calendar.date(from: components) {
                    daysOfMonth.append(date)
                }
            }
            
            return daysOfMonth
        }
        
        struct DaySelectorCell: View {
            let day: Date
            let isSelected: Bool
            let hasEntry: Bool
            
            var body: some View {
                ZStack {
                    VStack(alignment: .center, spacing: 3) {
                        Text("\(getDayString(from: day))")
                            .font(Font.custom("SF Pro Text", size: 13))
                            .multilineTextAlignment(.center)
                            .foregroundColor(isSelected ? ColorPallet.TertiaryYellow : .black)
                        Text("\(day.get(.day))")
                            .font(Font.custom("SF Pro Text", size: 16))
                            .multilineTextAlignment(.center)
                            .foregroundColor(isSelected ? ColorPallet.TertiaryYellow : .black)
                            .frame(maxWidth: .infinity, minHeight: 18, maxHeight: 18, alignment: .top)
                    }
                    
                }
                .frame(width: 40, height: 51)
                .background(isSelected ? ColorPallet.DiaryDateBlue : ColorPallet.DiaryDateBlue.opacity(0.3))
                .cornerRadius(10)
                .scaleEffect(isSelected ? 1.15 : 1)
                .overlay{
                    if hasEntry {
                        entryIconView
                    }
                }
            }
            
            @ViewBuilder var entryIconView: some View {
                let size: CGFloat = 9
                
                VStack{
                    HStack{
                        Spacer()
                        Image(systemName: "note.text")
                            .font(.system(size: size))
                            .foregroundStyle(ColorPallet.grey300)
                            .background(
                                Circle().fill(ColorPallet.tertiary100).frame(width: size * 1.4, height: size * 1.4)
                            )
                    }
                    Spacer()
                }
                .offset(x: size/2, y: -size/2.5)
            }
            
            private func getDayString(from date: Date) -> String {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "EEE" // "EEEE" represents the full weekday name
                
                return dateFormatter.string(from: date)
            }
        }
    }
}


extension JournalView.ViewModel {
    func dateHasEntry(_ date: Date) -> Bool {
        self.container.services.journalService.hasEntryOnDate(date: date)
    }
}
