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
    @Binding var chartType: ChartType
    @Binding var chartPosXCordinator: Double
    let isSource: Bool
    
    let chartNamespace: Namespace.ID
    let withChartOption: Bool
    let moods: [Mood]
    
    init(chartType: Binding<ChartType>, chartPosXCordinator: Binding<Double> = Binding.constant(0), isSource: Bool, chartNamespace: Namespace.ID, withChartOption: Bool, moods: [Mood] = Mood.previews) {
        self._chartType = chartType
        self._chartPosXCordinator = chartPosXCordinator
        self.isSource = isSource
        
        self.chartNamespace = chartNamespace
        self.withChartOption = withChartOption
        self.moods = moods
    }
    
    var body: some View {
        VStack{
            chartView
                .frame(minHeight: 300)
            chartPickerButtons
            Spacer()
        }
        .padding(4)
    }
    
    @ViewBuilder var chartView: some View {
        if moods.count == 0 {
            
        }else{
            switch chartType {
            case .line:
                MoodTimeChart(chartNamespace: chartNamespace, isSource: isSource, moodChartData: moods, chartPosXCordinator: $chartPosXCordinator)
            case .pie, .bar, .donut:
                MoodQuantityChart(chartNamespace: chartNamespace, moodChartDatas: convertMoodToMoodQuantityChartData(moods: moods), chartType: chartType, isSource: isSource)
            }
        }
    }
    
    @ViewBuilder var chartPickerButtons: some View {
        withAnimation{
            HStack(spacing: 10){
                Button {
                    self.chartType = .line
                } label: {
                    Image(systemName: "chart.xyaxis.line")
                        .font(.largeTitle)
                        .foregroundStyle(self.chartType == .line ? ColorPallet.DarkBlueText : ColorPallet.grey200)
                }
                
                Button {
                    self.chartType = .pie
                } label: {
                    Image(systemName: "chart.pie")
                        .font(.largeTitle)
                        .foregroundStyle(self.chartType == .pie ? ColorPallet.DarkBlueText : ColorPallet.grey200)
                }
                
                Button {
                    self.chartType = .bar
                } label: {
                    Image(systemName: "chart.bar.xaxis")
                        .font(.largeTitle)
                        .foregroundStyle(self.chartType == .bar ? ColorPallet.DarkBlueText : ColorPallet.grey200)
                }
                
                Button {
                    self.chartType = .donut
                } label: {
                    Image(systemName: "circle.circle")
                        .font(.largeTitle)
                        .foregroundStyle(self.chartType == .donut ? ColorPallet.DarkBlueText : ColorPallet.grey200 )
                }
            }
        }
        .hiddenModifier(isHide: !withChartOption)
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
                                x: .value("Mood", moodChartData.moodType.mood),
                                y: .value("Date", moodChartData.dateCreated)
                            )
                            .cornerRadius(8)
                            .foregroundStyle(by: .value("Mood", moodChartData.moodType.mood))
                        }else{
                            SectorMark(angle: .value(moodChartData.moodType.mood,
                                                     moodChartData.dateCreated),
                                       innerRadius: .ratio(chartType == .donut ? 0.61 : 0),
                                       angularInset: chartType == .donut ? 6 : 1)
                            
                            .cornerRadius(8)
                            .foregroundStyle(by: .value("Mood", moodChartData.moodType.mood))
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
    struct MoodTimeChart: View {
        let chartNamespace: Namespace.ID
        let isSource: Bool
        var moodChartData: [Mood]
        
        let firstDate: Date
        let lastDate: Date
        
        let yMin: Int
        let yMax: Int
        @Binding var chartPosX: Double
        
        init(chartNamespace: Namespace.ID, isSource: Bool, moodChartData: [Mood], chartPosXCordinator: Binding<Double> = Binding.constant(0) ) {
            self.chartNamespace = chartNamespace
            self.isSource = isSource
            self.moodChartData = moodChartData.sorted{ $0.dateCreated < $1.dateCreated }
            
            let deltaDate = ((self.moodChartData.last?.dateCreated.timeIntervalSince1970)! - (self.moodChartData.first?.dateCreated.timeIntervalSince1970)!) * 0.05
            
            self.firstDate = (self.moodChartData.first?.dateCreated)! - deltaDate
            self.lastDate = (self.moodChartData.last?.dateCreated)! + deltaDate
            
            self.yMin = moodChartData.map{ $0.moodType.moodIntValue }.min()! - 5
            self.yMax = moodChartData.map{ $0.moodType.moodIntValue }.max()! + 3
            
            self._chartPosX = chartPosXCordinator
        }
        
        var body: some View {
            if self.moodChartData.count < 2 {
                EmptyView()
            }else{
                if #available(iOS 17.0, *) {
                    Chart(moodChartData) { data in
                        LineMark(x: .value("Month", data.dateCreated), y: .value("Mood", data.moodType.moodIntValue))
                            .foregroundStyle(ColorPallet.DeepAquaBlue)
                            .interpolationMethod(.monotone)
                            
                            .symbol {
                                VStack(spacing: 0){
                                    ZStack{
                                        Circle()
                                            .fill(ColorPallet.SkyBlue)
                                            .frame(width: 32, height: 32)
                                            .shadow(radius: 3)
                                        Text(data.moodType.emoji)
                                            .font(.title)
                                    }
                                    
                                    VStack{
                                        Text(data.moodType.mood)
                                            .font(
                                                Font.custom("SF Pro Text", size: 8)
                                                    .weight(.bold)
                                            )
                                            .foregroundStyle(.black)
                                        
                                        Text(data.dateCreated, style: .date)
                                            .font(
                                                Font.custom("SF Pro Text", size: 4)
                                            )
                                            .foregroundStyle(.black)
                                    }
                                }
                                
                                .offset(y: 12)
                            }
                            .zIndex(2)
                        
                        RuleMark(x: .value("Month", data.dateCreated))
                            .foregroundStyle(Color.gray)
                            .lineStyle(.init(lineWidth: 1, dash: [5,7]))
                            .opacity(0.3)
                            .zIndex(-1)
                    }
                    .chartYScale(domain: yMin...yMax)
                    .chartXScale(domain: firstDate...lastDate)
                    .frame(width: UIViewController().view.bounds.width)
                    .frame(height: 250)
                    .chartScrollPosition(x: $chartPosX)
                    .chartScrollableAxes(.horizontal)
                    .chartYAxis(.visible)
                    .chartXAxis(content: {
                        AxisMarks {
                            AxisValueLabel().foregroundStyle(.gray)
                        }
                    })
                    .chartYAxis{
                        AxisMarks(values: .stride(by: 1)) {
                            let _ = $0.as(Int.self)!
                                AxisGridLine()
                                .foregroundStyle(.gray.opacity(0.3))
                                
                                AxisTick()
                                .foregroundStyle(.black)
                        }
                    }
                    .foregroundColor(.black)
                    .aspectRatio(1, contentMode: .fit)
                    .matchedGeometryEffect(id: "chart", in: self.chartNamespace, isSource: isSource)
                }else{
                    Text("Must be iOS 17.0")
                }
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
        
        init(chartNamespace: Namespace.ID, moodChartDatas: [QuantityMoodChartData], chartType: ChartType, isSource: Bool) {
            self.chartNamespace = chartNamespace
            self.moodChartDatas = moodChartDatas.sorted{ $0.moodType.moodIntValue > $1.moodType.moodIntValue}
            self.chartType = chartType
            self.isSource = isSource
        }
        
        // an algorithm to get the most repetition element in an array
        var calculateMostFeltMood: QuantityMoodChartData{
            var mostFeltMood = moodChartDatas[0].moodType
            for mood in moodChartDatas {
                if mood.count > mostFeltMood.moodIntValue {
                    mostFeltMood = mood.moodType
                }
            }
            
            return QuantityMoodChartData(moodType: mostFeltMood, count: 0)
        }
        
        var body: some View {
            if #available(iOS 17.0, *) {
                ZStack{
                    VStack(spacing: 0){
                        Text(self.calculateMostFeltMood.moodType.emoji)
                            .font(.system(size: 50))
                        
                        Text(self.calculateMostFeltMood.moodType.mood)
                            .font(.caption)
                            .foregroundStyle(ColorPallet.DarkBlueText)
                            .scaledToFit()
                    }
                    .hiddenModifier(isHide: (chartType != .donut))
                    .matchedGeometryEffect(id: "chartContent", in: self.chartNamespace, isSource: isSource)
                
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

                }
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
        moodCounts[mood.moodType] = (moodCounts[mood.moodType] ?? 0) + 1
    }
    
    // Create an array of MoodChartData by iterating through the dictionary
    var moodChartData = [QuantityMoodChartData]()
    for (mood, count) in moodCounts {
        moodChartData.append(QuantityMoodChartData(moodType: mood, count: count))
    }
    
    return moodChartData
}

extension ChartView {
    enum ChartType: String, CaseIterable {
        case line = "Line Chart"
        case pie = "Pie Chart"
        case bar = "Bar Chart"
        case donut = "Donut Chart"
    }
}

#if DEBUG
#Preview {
    let namespace = Namespace().wrappedValue
    //    return ChartView(isSource: true, chartNamespace: namespace, withChartOption: true)
    return ChartView(chartType: Binding.constant(.line), chartPosXCordinator: Binding.constant(0), isSource: true, chartNamespace: namespace, withChartOption: true, moods: [Mood(mood: .Angry, dateCreated: .now, moodString: ""), Mood(mood: .Happy, dateCreated: .now + 10, moodString: "")])
}
#endif
