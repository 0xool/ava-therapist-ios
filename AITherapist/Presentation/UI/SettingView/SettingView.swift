//
//  SettingView.swift
//  AITherapist
//
//  Created by cyrus refahi on 1/30/24.
//

import SwiftUI

struct SettingView: View {
    
    @ObservedObject private(set) var viewModel: ViewModel
    private var formSize: (width: CGFloat, height: CGFloat) {
        get{
            return (viewSize.width, viewSize.height * 0.7)
        }
    }
    private var viewSize: (width: CGFloat, height: CGFloat) {
        get{
            return (CGFloat(UIViewController().view.bounds.width), CGFloat(UIViewController().view.bounds.height))
        }
    }
    
    var body: some View {
        settingView
            .onTapGesture {
                self.hideKeyboard()
            }
    }
}

extension SettingView {
    @ViewBuilder var mainView: some View {
        VStack{
            HStack{
                Text("AI Personality")
                    .font(Font.custom("SF Pro Text", size: 17))
                    .bold()
                    .multilineTextAlignment(.center)
                    .foregroundColor(ColorPallet.SolidDarkGreen)
                Spacer()
                                
                Picker(selection: $viewModel.personality, label: Text("AI Personality")) {
                    ForEach(viewModel.personas.value!, id:\.id) {
                        Text($0.personaName)
                            .tag($0.id)
                    }
                }
            }
            .padding()
            
            Divider()
            
            HStack{
                Text("Notification")
                    .font(Font.custom("SF Pro Text", size: 17))
                    .bold()
                    .multilineTextAlignment(.center)
                    .foregroundColor(ColorPallet.SolidDarkGreen)
                
                Spacer()
                
                Toggle("", isOn: $viewModel.showNotification)
            }
            .padding()
            
            Button(action: {
                self.hideKeyboard()
                self.viewModel.updateSetting()
            }, label: {
                Text("Submit")
                    .font(.callout)
                    .foregroundStyle(ColorPallet.Celeste)
            })
            .frame(maxWidth: .infinity, minHeight: 40, maxHeight: 40, alignment: .center)
            .background(ColorPallet.DeepAquaBlue)
            .cornerRadius(50)
            .padding(.bottom, 16)
            .padding([.leading, .trailing], 16)
        }
        .frame(maxWidth: .infinity)
        .background(.white)
        .cornerRadius(25)
        .shadow(color: .black.opacity(0.25), radius: 3.5, x: 4, y: 6)
        .padding()
    }
}

extension SettingView {
    func failedView(error: Error) -> some View {
        ErrorView(error: error) {
            self.viewModel.loadPersonas()
        }
    }
    
    func loadingView() -> some View {
        // show logged in successfully
        VStack{
            CircleLoading()
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            Text("Logged in succesfully")
        }
    }
}

extension SettingView {
    @ViewBuilder var settingView: some View {
        ZStack{
            switch(self.viewModel.personas) {
            case .notRequested: // if we haven't started requesting the data yet
                Text("")
            case .isLoading(_, _): // if we're waiting for the data to come back
                loadingView()
            case .loaded(_): // if we've got the data back
                mainView
                    .onBecomingVisible {
                        self.viewModel.setSetting()
                    }
            case let .failed(error): // if the request failed
                failedView(error: error)
            case .partialLoaded(_):
                Text("Not requested")
            }
        }
    }
}

extension SettingView{
    class ViewModel: ObservableObject {
        @Published var setting: Loadable<Setting>
        @Published var personas: Loadable<[Persona]>
        @Published var personality: Int = 1
        
        @Published var showNotification: Bool = false
        let container: DIContainer
        private var cancelBag = CancelBag()
        
        init(container: DIContainer, personas: Loadable<[Persona]> = .notRequested) {
            self.container = container
            self.personas = personas
            self.setting = .notRequested
            
            $setting
                .debounce(for: .seconds(0), scheduler: DispatchQueue.main)
                .sink { [weak self] setting in
                    self?.personality = setting.value?.personaID ?? 1
                    self?.showNotification = (setting.value?.isNotificationEnabled ?? false)
                }
                .store(in: cancelBag)
            
            self.loadPersonas()
        }
        
        func loadPersonas(){
            self.container.services.settingService.getAllPersona(personas: loadableSubject(\.personas))
        }
        
        func setSetting() {
            if let setting = self.container.appState[\.userData.setting].value {
                self.setting = .loaded(setting)
                
            }else{
                // load setting
            }
        }
        
        func updateSetting(){
            guard let setting = self.setting.value else {
                return
            }
            
            self.setting = .loaded(.init(id: setting.id, personaID: self.personality, isNotificationEnabled: self.showNotification))
                        
            self.container.services.settingService.updateSetting(setting: loadableSubject(\.setting))
        }
    }
}

#if DEBUG
#Preview {
    SettingView(viewModel: .init(container: .preview))
}
#endif
