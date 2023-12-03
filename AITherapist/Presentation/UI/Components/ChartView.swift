//
//  ChartView.swift
//  AITherapist
//
//  Created by Cyrus Refahi on 10/1/23.
//

import Foundation
import SwiftUI
import Charts

struct ChartView: View {
    @State var chartType: ChartType = .pie
    let isSource: Bool
    let chartNamespace: Namespace.ID
    let withChartOption: Bool
    
    var moods = [Mood(mood: .Happy, dateCreated: .now, moodString: "Happy"),
                 Mood(mood: .Excited, dateCreated: .now + 1, moodString: "Happy"),
                 Mood(mood: .Anxious, dateCreated: .now + 2, moodString: "Happy"),
                 Mood(mood: .Anxious, dateCreated: .now - 1, moodString: "Happy"),
                 Mood(mood: .Happy, dateCreated: .now + 10, moodString: "Happy"),
                 Mood(mood: .Guilty, dateCreated: .now - 10, moodString: "Happy") ]
    
    var body: some View {
        VStack{
            withAnimation {
                Picker("", selection: $chartType){
                    ForEach(ChartType.allCases, id: \.rawValue) { type in
                        Text(type.rawValue)
                            .tag(type)
                    }
                }
                .pickerStyle(.segmented)
                .labelsHidden()
            }
            .hiddenModifier(isHide: !withChartOption)
            
            MoodQuantityChart(chartNamespace: chartNamespace, moodChartDatas: convertMoodToMoodQuantityChartData(moods: moods), chartType: chartType, isSource: isSource)
            Spacer(minLength: 0)
//            WeeklyMoodChart(moodChartDatas: moods, chartType: .bar)
        }
        .padding(4)
    }
    
}

extension ChartView {
    struct WeeklyMoodChart: View {
        var moodChartDatas: [Mood] = []
        var chartType: ChartType = .pie
        
        var body: some View {
            if #available(iOS 17.0, *) {
                Chart{
                    ForEach( moodChartDatas, id: \.moodType) { moodChartData in
                        if chartType == .bar {
                            /// Bar Chart
                            BarMark(
                                x: .value("Mood", moodChartData.moodType!.mood),
                                y: .value("Date", moodChartData.dateCreated!)
                            )
                            .cornerRadius(8)
                            .foregroundStyle(by: .value("Mood", moodChartData.moodType!.mood))
                        }else{
                            SectorMark(angle: .value(moodChartData.moodType!.mood,
                                                     moodChartData.dateCreated!),
                                       innerRadius: .ratio(chartType == .donut ? 0.61 : 0),
                                       angularInset: chartType == .donut ? 6 : 1)
                            
                            .cornerRadius(8)
                            .foregroundStyle(by: .value("Mood", moodChartData.moodType!.mood))
                        }
                    }
                }
                .frame(height: 300)
                .padding(.top, 16)
                
                
            }else{
                Text("Pending Implementation")
            }
        }
    }
}

extension ChartView {
    struct MoodQuantityChart: View {
        let chartNamespace: Namespace.ID
        var moodChartDatas: [QuantityMoodChartData] = []
        var chartType: ChartType = .pie
        
        let isSource: Bool
        
        var body: some View {
            if #available(iOS 17.0, *) {
                Chart{
                    ForEach( moodChartDatas, id: \.moodType) { moodChartData in
                        if chartType == .bar {
                            /// Bar Chart
                            BarMark(
                                x: .value("Mood", moodChartData.moodType.mood),
                                y: .value("Number", moodChartData.moodType.moodIntValue)
                            )
                            .cornerRadius(8)
                            .foregroundStyle(by: .value("Mood", moodChartData.moodType.mood))
                        }else{
                            SectorMark(angle: .value(moodChartData.moodType.mood,
                                                     moodChartData.moodType.moodIntValue),
                                       innerRadius: .ratio(chartType == .donut ? 0.61 : 0),
                                       angularInset: chartType == .donut ? 6 : 1)
                            
                            .cornerRadius(8)
                            .foregroundStyle(by: .value("Mood", moodChartData.moodType.mood))
                        }
                    }
                }
                .matchedGeometryEffect(id: "chart", in: self.chartNamespace, isSource: isSource)
                .frame(height: 300)
                .padding(.top, 16)
                
                
            }else{
                Text("Pending Implementation")
            }
        }
    }
}

struct QuantityMoodChartData {
    var moodType: MoodType
    var count: Int
}

func convertMoodToMoodQuantityChartData(moods: [Mood]) -> [QuantityMoodChartData]{
    // Create a dictionary to count the occurrences of each mood
    var moodCounts = [MoodType: Int]()
    
    // Iterate through the testMood array and count the occurrences
    for mood in moods {
        moodCounts[mood.moodType!] = (moodCounts[mood.moodType!] ?? 0) + 1
    }
    
    // Create an array of MoodChartData by iterating through the dictionary
    var moodChartData = [QuantityMoodChartData]()
    for (mood, count) in moodCounts {
        moodChartData.append(QuantityMoodChartData(moodType: mood, count: count))
    }
    
    return moodChartData
}


struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        let namespace = Namespace().wrappedValue
        ChartView(isSource: true, chartNamespace: namespace, withChartOption: true)
    }
}

extension ChartView {
    enum ChartType: String, CaseIterable {
        case pie = "Pie Chart"
        case bar = "Bar Chart"
        case donut = "Donut Chart"
    }
}
