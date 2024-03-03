//
//  ActivityView.swift
//  AITherapist
//
//  Created by cyrus refahi on 2/26/24.
//

import SwiftUI

struct ActivityView: View {
    @ObservedObject private(set) var viewModel: ViewModel
    
    var body: some View {
        mainContent
            .onChange(of: self.viewModel.exerciseDone, perform: { value in
                self.viewModel.updateExerciseStatus()
            })
            .onChange(of: self.viewModel.taskDone, perform: { value in
                self.viewModel.updateTaskStatus()
            })
    }
    
    @ViewBuilder var mainContent: some View {
        switch self.viewModel.userActivity {
        case .notRequested:
            EmptyView()
        case .isLoading(last: _, cancelBag: _):
            EmptyView()
        case let .loaded(activity):
            loadedView(activity)
        case .failed(_):
            EmptyView()
        case .partialLoaded(_):
            EmptyView()
        }
    }
}

private extension ActivityView {
    func loadedView(_ activity: UserActivity) -> some View {
        VStack{
            TodaysFactView(dailyFact: activity.dailyFacts!)
            DailtExerciseView(dailyExercise: activity.dailyExercise!, exerciseDone: $viewModel.exerciseDone)
            DailyTaskView(dailyTask: activity.dailyTask!, taskDone: $viewModel.taskDone)
        }
        .padding()
    }
}

struct TodaysFactView: View {
    let dailyFact: DailyFact
    @State var animate: Bool = false
    
    var body: some View {
        VStack(spacing: 0){
            Text("Todays Fact")
                .font(.title2)
                .foregroundStyle(ColorPallet.DarkBlueText)
                .multilineTextAlignment(.center)
                .padding(.bottom)
                .bold()
                
            
//            Text(dailyFact.title)
//                .font(.title2)
//                .foregroundStyle(ColorPallet.DarkBlueText)
//                .bold()
//                .multilineTextAlignment(.center)
            
            Text(dailyFact.content)
                .font(.caption)
                .foregroundStyle(ColorPallet.DarkBlueText)
                .lineLimit(4)
                .multilineTextAlignment(.center)
        }
        .padding()
        .background{
            RoundedRectangle(cornerRadius: 20)
                .fill(ColorPallet.Celeste)
                .shadow(radius: 10)
        }
        .frame(maxWidth: .infinity)
        .offset(x: animate ? 0 : -20)
        .opacity(animate ? 1 : 0)
        .onBecomingVisible{
            withAnimation(.easeIn.delay(0)) {
                self.animate = true
            }
        }
        
    }
}

struct DailtExerciseView: View {
    let dailyExercise: DailyExercise
    @Binding var exerciseDone: Bool
    @State var animate: Bool = false
    
    var body: some View {
        VStack(alignment: .center, spacing: 3){
                Text("Daily Exercise")
                    .font(.title2)
                    .foregroundStyle(ColorPallet.DarkBlueText)
                    .multilineTextAlignment(.center)
                    .padding(.bottom)
                    .bold()
                
                HStack{
                    VStack{
                        Text(dailyExercise.title)
                            .font(.title3)
                            .foregroundStyle(ColorPallet.DarkBlueText)
                            .multilineTextAlignment(.center)
                        
                        Text(dailyExercise.content)
                            .font(.caption)
                            .foregroundStyle(ColorPallet.DarkBlueText)
                            .lineLimit(4)
                            .multilineTextAlignment(.center)
                    }
                    
                    Toggle("", isOn: $exerciseDone)
                            .toggleStyle(SwitchToggleStyle(tint: .accentColor))
                            .disabled(exerciseDone)
                            .frame(width: 50, height: 50)
            }

        }
        .padding()
        .background{
            RoundedRectangle(cornerRadius: 20)
                .fill(ColorPallet.Celeste)
                .shadow(radius: 10)
            
        }
        .frame(maxWidth: .infinity)
        .offset(x: animate ? 0 : -20)
        .opacity(animate ? 1 : 0)
        .onBecomingVisible {
            withAnimation(.easeIn.delay(0.25)) {
                self.animate = true
            }
        }
    }
}

struct DailyTaskView: View {
    let dailyTask: DailyTask
    @Binding var taskDone: Bool
    @State var animate: Bool = false
    
    var body: some View {
        VStack(alignment: .center, spacing: 0){
                Text("Daily Task")
                    .font(.title2)
                    .foregroundStyle(ColorPallet.DarkBlueText)
                    .multilineTextAlignment(.center)
                    .padding(.bottom)
                    .bold()
                
                HStack{
                    VStack{
                        Text(dailyTask.content)
                            .font(.caption)
                            .foregroundStyle(ColorPallet.DarkBlueText)
                            .lineLimit(4)
                            .multilineTextAlignment(.center)
                    }
                    
                    Toggle("", isOn: $taskDone)
                            .toggleStyle(SwitchToggleStyle(tint: .accentColor))
                            .onChange(of: taskDone, perform: { value in
                                
                            })
                            .disabled(taskDone)
                            .frame(width: 50, height: 50)
            }

        }
        .padding()
        .background{
            RoundedRectangle(cornerRadius: 20)
                .fill(ColorPallet.Celeste)
                .shadow(radius: 10)
            
        }
        .frame(maxWidth: .infinity)
        .offset(x: animate ? 0 : -20)
        .opacity(animate ? 1 : 0)
        .onBecomingVisible{
            withAnimation(.easeIn.delay(0.75)) {
                self.animate = true
            }
        }
    }
}

extension ActivityView {
    class ViewModel: ObservableObject {
        @Published var userActivity: Loadable<UserActivity> {
            willSet{
                self.taskDone = newValue.value?.dailyTask?.isDone ?? false
                self.exerciseDone = newValue.value?.dailyExercise?.isDone ?? false
            }
        }
        @Published var taskDone: Bool = false
        @Published var exerciseDone: Bool = false
        
        let container: DIContainer
        let isRunningTests: Bool
        private var cancelBag: CancelBag = CancelBag()
        
        init(container: DIContainer, isRunningTests: Bool = false, userActivity: Loadable<UserActivity> = .notRequested) {
            self.container = container
            self.isRunningTests = isRunningTests
            self.userActivity = userActivity
            
            loadUserActivities()
        }
        
        private func loadUserActivities() {
            self.container.services.activityService.getDailyActivity(activity: self.loadableSubject(\.userActivity))
        }
        
        func updateExerciseStatus() {
            guard let activity = self.userActivity.value else {
                return
            }
            
            self.container.services.activityService.setDailyExerciseDone(activity: activity)
        }
        
        func updateTaskStatus() {
            guard let activity = self.userActivity.value else {
                return
            }
            
            self.container.services.activityService.setDailyTaskDone(activity: activity)
        }
    }
}

#Preview {
    ActivityView(viewModel: .init(container: .previews))
}
