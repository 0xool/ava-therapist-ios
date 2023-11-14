//
//  ProfileView.swift
//  AITherapist
//
//  Created by cyrus refahi on 11/13/23.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        ZStack{
            Text("Hello World")
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.gray)
    }
}

extension ProfileView{
    struct profileImageView: View {
        var body: some View {
            /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Hello, world!@*/Text("Hello, world!")/*@END_MENU_TOKEN@*/
        }
    }
}

#Preview {
    ProfileView()
}
