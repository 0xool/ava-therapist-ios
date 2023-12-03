//
//  ProfileView.swift
//  AITherapist
//
//  Created by Cyrus Refahi on 11/13/23.
//

import SwiftUI

struct ProfileView: View {
    
    private static let HEADER_HEIGHT_RATIO = 0.4
    private let profileHeaderHeight: (GeometryProxy) -> CGFloat = { geo in
        return geo.size.height * CGFloat(HEADER_HEIGHT_RATIO)
    }
    private let profileSettingHeight: (GeometryProxy) -> CGFloat = { geo in
        return geo.size.height * CGFloat(1 - HEADER_HEIGHT_RATIO)
    }
    
    @ObservedObject private(set) var viewModel: ViewModel
    @State var showImagePicker: Bool = false

    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        GeometryReader{ geo in
            VStack(spacing: 0){
                    profileHeaderView(profileImage: $viewModel.profileImage, showImagePicker: $showImagePicker)
                        .frame(height: profileHeaderHeight(geo))
                        .frame(maxWidth: .infinity)
                    ProfileSettingView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity + 35)
                        .ignoresSafeArea()
                        .background(.white)
                        .clipShape(
                            .rect(
                                topLeadingRadius: 20,
                                bottomLeadingRadius: 0,
                                bottomTrailingRadius: 0,
                                topTrailingRadius: 20
                            )
                        )
                        .offset(x: 0, y: -35)
                        .padding([.bottom], -200)
                    
                }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea()
            .background(.gray)
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(image: $viewModel.profileImage)
                    .environmentObject(self.viewModel)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            self.viewModel.loadProfileImage()
        }
    }
}

extension ProfileView{
    struct ImagePicker: UIViewControllerRepresentable {
        
        @Environment(\.presentationMode)
        var presentationMode
        
        @EnvironmentObject var viewModel: ViewModel
        @Binding var image: Image?
        
        class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
            
            @Binding var presentationMode: PresentationMode
            @Binding var image: Image?
            @EnvironmentObject var viewModel: ViewModel
            
            init(presentationMode: Binding<PresentationMode>, image: Binding<Image?>, viewModel: EnvironmentObject<ViewModel>) {
                _presentationMode = presentationMode
                _image = image
                _viewModel = viewModel
            }
            
            func imagePickerController(_ picker: UIImagePickerController,
                                       didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
                let uiImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
                image = Image(uiImage: uiImage)
                self.viewModel.saveProfileImage(uiImage: uiImage)
                presentationMode.dismiss()
                
            }
            
            func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
                presentationMode.dismiss()
            }
        }
        
        func makeCoordinator() -> Coordinator {
            return Coordinator(presentationMode: presentationMode, image: $image, viewModel: _viewModel)
            }

            func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
                let picker = UIImagePickerController()
                picker.delegate = context.coordinator
                return picker
            }

            func updateUIViewController(_ uiViewController: UIImagePickerController,
                                        context: UIViewControllerRepresentableContext<ImagePicker>) {
            }
    }
}

extension ProfileView{
    struct profileHeaderView: View {
        @Binding var profileImage: Image?
        @Binding var showImagePicker: Bool
        
        var body: some View {
            VStack(spacing: 25){
                
                ProfileImageView(profileImage: $profileImage, showImagePicker: $showImagePicker)
                
                Text("Cyrus")
                .font(
                Font.custom("SF Pro Text", size: 17)
                .weight(.semibold)
                )
                .multilineTextAlignment(.center)
                .foregroundColor(.black)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .background{
                DynamicTwoCircleBackgroundView(backgroundColor: .gray)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            }
        }

        struct ProfileImageView: View {
            @Binding var profileImage: Image?
            @Binding var showImagePicker: Bool

            var body: some View {
                ZStack{
                        profileImage?
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .clipped()
                            .clipShape(
                                Circle()
                            )
                            .overlay{
                                Circle()
                                    .strokeBorder(lineWidth: 2)
                                    .fill(.white)
                            }
                    
                    ZStack{
                        Circle()
                            .fill(.gray)
                            .frame(height: 25)
                            .background{
                                Circle()
                                    .fill(.white)
                                    .padding(-1)
                            }
                        Image(systemName: "camera")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 15)
                }
                    .offset(x: 35, y: 35)
                }
                .onTapGesture {
                    showImagePicker = true
                }
            }
        }
    }
    
    enum Setting {
        case editProfile
        case settings
        case prefrences
        case invite
        case help
        
        var title: String {
            switch self {
            case .editProfile:
                return "Edit Profile"
            case .settings:
                return "Settings"
            case .prefrences:
                return "Preferences"
            case .invite:
                return "Invite a friend"
            case .help:
                return "Help"
            }
        }
        
        var image: String {
            switch self {
            case .editProfile:
                return "person.circle"
            case .settings:
                return "gearshape"
            case .prefrences:
                return "rectangle.and.pencil.and.ellipsis"
            case .invite:
                return "person.badge.plus"
            case .help:
                return "ellipsis.message"
            }
        }
    }
    
    struct ProfileSettingView: View {
        var body: some View {
            ScrollView{
                VStack(alignment: .leading, spacing: 0) {
                    SettingCellView(.editProfile)
                    SettingCellView(.settings)
                    SettingCellView(.prefrences)
                    
                    Divider()
                    
                    SettingCellView(.invite)
                    SettingCellView(.help)
                }
                .clipShape(
                    .rect(
                        topLeadingRadius: 20,
                        bottomLeadingRadius: 0,
                        bottomTrailingRadius: 0,
                        topTrailingRadius: 20
                    )
                )
                .padding(.top, 32)
                .padding(.bottom, 103)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.white)
            }
        }
        
        struct SettingCellView: View {
            let settingType: Setting
            
            init(_ settingType: Setting) {
                self.settingType = settingType
            }
            
            var body: some View {
                    ZStack {
                        HStack(alignment: .center) {
                            HStack{
                                HStack(alignment: .center, spacing: 10) {
                                    Image(systemName: settingType.image)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 25, height: 25)
                                }
                                .padding(5)
                                .frame(width: 50, height: 50, alignment: .center)
                                .background(Color(red: 0.75, green: 0.75, blue: 0.75))
                                .cornerRadius(10)
                                
                                // Bold/Body
                                Text(settingType.title)
                                    .font(
                                        Font.custom("SF Pro Text", size: 17)
                                            .weight(.semibold)
                                    )
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(.black)
                            }
                            
                            Spacer()
                            Image(systemName: "chevron.right")
                                .frame(width: 28, height: 28)
                            
                                .foregroundStyle(.black)
                        }
                        .padding(0)
                        .frame(width: 350, alignment: .center)
                        
                        AvaNavigationLink {
                            Text(settingType.title)
                                .avaNavigationBarBackButtonHidden(false)
                                .avaNavigationBarTitle("")
                        } label: {
                            Text("")
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    .padding(8)
                    .foregroundStyle(.black)
            }
        }
    }
}

extension ProfileView {
    class ViewModel: ObservableObject {
        @Published var profileImage: Image? = Image(systemName: "person.circle")
        
        let container: DIContainer
        let isRunningTests: Bool
        private var cancelBag: CancelBag = CancelBag()
        
        init(container: DIContainer, isRunningTests: Bool = false, profileImage: Image? = Image(systemName: "person.circle") ) {
            self.container = container
            self.isRunningTests = isRunningTests
            self.profileImage = profileImage
            
            container.appState.value.userData.objectWillChange.sink { (_) in
                self.objectWillChange.send()
            }
            .store(in: cancelBag)
            
        }
        
        func saveProfileImage(uiImage: UIImage){
            container.services.profileService.saveProfileImage(image: .init(imageData: uiImage.pngData()!))
        }
        
        func loadProfileImage() {
            container.services.profileService.loadProfileImage()
                .sink { completion in
                        switch completion {
                        case .failure(_):
                            self.profileImage = Image(systemName: "person.circle")
                        case .finished:
                            // Handle the successful completion
                            break
                        }
                } receiveValue: {
                    if ($0 != nil ){
                        self.profileImage = $0
                    }
                    else{
                        self.profileImage = Image(systemName: "person.circle")
                    }
                }
                .store(in: cancelBag)
        }
    }
}

#Preview {
    ProfileView(viewModel: .init(container: .preview))
}
