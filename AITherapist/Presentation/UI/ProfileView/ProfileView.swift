//
//  ProfileView.swift
//  AITherapist
//
//  Created by cyrus refahi on 11/13/23.
//

import SwiftUI

struct ProfileView: View {
    
    static let HEADER_HEIGHT_RATIO = 0.4
    let profileHeaderHeight: (GeometryProxy) -> CGFloat = { geo in
        return geo.size.height * CGFloat(HEADER_HEIGHT_RATIO)
    }
    let profileSettingHeight: (GeometryProxy) -> CGFloat = { geo in
        return geo.size.height * CGFloat(1 - HEADER_HEIGHT_RATIO)
    }
    
    var body: some View {
        GeometryReader{ geo in
            ZStack{
                VStack{
                    profileHeaderView()
                        .frame(height: profileHeaderHeight(geo))
                        .frame(maxWidth: .infinity)
                    Spacer()
                    ProfileSettingView()
                        .frame(height: profileSettingHeight(geo))
                        .frame(maxWidth: .infinity)
                    
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea()
            .background(.gray)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

extension ProfileView{
    struct profileHeaderView: View {
        var body: some View {
            VStack{
                Image(systemName: "person.circle")
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
            
            VStack(alignment: .leading, spacing: 25) {
                SettingCellView(.editProfile)
                SettingCellView(.settings)
                SettingCellView(.prefrences)
                
                Divider()
                
                SettingCellView(.invite)
                SettingCellView(.help)
            }
            .padding(.horizontal, 29)
            .padding(.top, 32)
            .padding(.bottom, 103)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.white)
            .cornerRadius(20)
            
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
//                        .opacity(0)
                }
                .foregroundStyle(.black)
            }
        }
    }
}

#Preview {
    ProfileView()
}
