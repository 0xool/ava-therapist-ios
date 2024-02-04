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
        VStack{
            HStack{
                Text("AI Personality")
                
                Spacer()
               
                Picker(selection: $viewModel.personality, label: Text("AI Personality")) {
                    
                }
            }
            .padding()
            
            Divider()
            
            HStack{
                Text("Notification")
                
                Spacer()
                
                Toggle("", isOn: $viewModel.showNotification)
            }
            .padding()
            
            Button(action: {
                
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
        .onTapGesture {
            self.hideKeyboard()
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
            self.setting = setting
            self.personas = personas
            
            $setting
                .debounce(for: .seconds(0), scheduler: DispatchQueue.main)
                .sink { [weak self] setting in
                    self?.personality = setting.value?.personaID ?? 1
                    self?.showNotification = (setting.value?.isNotificationEnabled ?? false)
                }
                .store(in: cancelBag)
            

            if let setting = self.container.appState[\.userData.setting].value {
                self.setting = .loaded(setting)
            }else{
                // load setting
            }
            

            
            
        }
        
        private func loadInitialPersona(){
            self.container.services.
        }
        
    }
}


#Preview {
    SettingView(viewModel: .init(container: .preview, setting: .loaded(.init(id: 1, personaID: 1, isNotificationEnabled: false))))
}
