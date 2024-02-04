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
    
    @ObservedObject var viewModel: ViewModel
    @State var showImagePicker: Bool = false

    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        GeometryReader{ geo in
            VStack(spacing: 0){
                profileHeaderView(profileImage: $viewModel.profileImage, showImagePicker: $showImagePicker, name: self.viewModel.user?.name ?? "")
                        .frame(height: profileHeaderHeight(geo))
                        .frame(maxWidth: .infinity)
                        .offset(y: -35)
                ProfileSettingView(container: self.viewModel.container)
                        .frame(maxWidth: .infinity, maxHeight: .infinity + 35)
                        .ignoresSafeArea()
                        .background(ColorPallet.Verdigris)
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
            .background(.clear)
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
        
        let name: String
        
        var body: some View {
            VStack(spacing: 20){
                ProfileImageView(profileImage: $profileImage, showImagePicker: $showImagePicker)
                
                Text(name)
                .font(
                Font.custom("SF Pro Text", size: 17)
                .weight(.semibold)
                )
                .multilineTextAlignment(.center)
                .foregroundColor(ColorPallet.DarkBlack)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .background{ Color.clear }
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
                            .foregroundStyle(ColorPallet.IconBlue)
                            .overlay{
                                Circle()
                                    .strokeBorder(lineWidth: 2)
                                    .fill(ColorPallet.SkyBlue)
                            }
                    
                    ZStack{
                        Circle()
                            .fill(ColorPallet.Celeste)
                            .frame(height: 25)
                            .background{
                                Circle()
                                    .fill(ColorPallet.SkyBlue)
                                    .padding(-1)
                            }
                        Image(systemName: "camera")
                            .resizable()
                            .scaledToFit()
                            .foregroundStyle(ColorPallet.IconBlue)
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
    
    struct ProfileSettingView: View {
        
        let container: DIContainer
        
        var body: some View {
            ScrollView{
                VStack(alignment: .leading, spacing: 0) {
                    SettingCellView(.editProfile(container: container))
                    SettingCellView(.settings(container: container))
                    SettingCellView(.prefrences)
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
                .background(ColorPallet.Verdigris)
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
                                HStack(alignment: .center, spacing: 10) {
                                    Image(systemName: settingType.image)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 25, height: 25)
                                        .foregroundStyle(ColorPallet.IconBlue)
                                }
                                .padding(5)
                                .frame(width: 50, height: 50, alignment: .center)
                                .background(ColorPallet.Celeste)
                                .cornerRadius(10)

                            VStack{
                                HStack{
                                    Text(settingType.title)
                                        .font(
                                            Font.custom("SF Pro Text", size: 17)
                                                .weight(.semibold)
                                        )
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(ColorPallet.DarkBlack)
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .frame(width: 28, height: 28)
                                        .foregroundColor(ColorPallet.DarkBlack)
                                }
                                
                                Rectangle()
                                    .frame(height: 1)
                                    .frame(maxWidth: .infinity)
                                    .foregroundColor(ColorPallet.Celeste)
                                    
                            }
                        }
                        .padding(0)
                        .frame(width: 350, alignment: .center)
                        
                        AvaNavigationLink {
                            settingType.view
                                .avaNavigationBarTopLeftButton(.back)
                                .avaNavigationBarTitle("")
                        } label: {
                            Text("")
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        } background: {
                            settingType.background
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
    enum Setting {
        case editProfile(container: DIContainer)
        case settings(container: DIContainer)
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
        
        @ViewBuilder var view: some View {
            switch self {
            case let .editProfile(container):
                EditUserSettingsView(viewModel: .init(container: container))
            case let .settings(container):
                SettingView(viewModel: .init(container: container))
            case .prefrences:
                Text(self.title)
            case .invite:
                InviteFriendView()
            case .help:
                HelpView()
            }
        }
        
        @ViewBuilder private var helpBackground: some View {
            MenuBackground()
        }
        
        @ViewBuilder var background: some View {
            switch self {
            case .editProfile:
                helpBackground
            case .settings:
                helpBackground
            case .prefrences:
                helpBackground
            case .invite:
                helpBackground
            case .help:
                helpBackground
            }
        }
    }
}

extension ProfileView {
    class ViewModel: ObservableObject {
        @Published var profileImage: Image? = Image(systemName: "person.circle")
        var user: User?{
            get{
                return self.container.appState[\.userData.user].value
            }
        }
        
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

#if DEBUG
#Preview {
    ProfileView(viewModel: .init(container: .preview))
}
#endif
