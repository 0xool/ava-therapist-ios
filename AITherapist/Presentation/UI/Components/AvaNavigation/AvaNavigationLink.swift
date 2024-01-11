//
//  AvaNavLink.swift
//  AITherapist
//
//  Created by Cyrus Refahi on 11/5/23.
//

import SwiftUI

struct AvaNavigationLink<Label, Destination> : View where Label : View, Destination : View {
    
    let label: Label
    let destination: Destination
    
    public init(@ViewBuilder destination: () -> Destination, @ViewBuilder label: () -> Label)
    {
        self.destination = destination()
        self.label = label()
    }
    
    var body: some View {
        NavigationLink {
            AvaNavBarView{
                destination
            } background: {
                EmptyView()
            }
            .navigationBarBackButtonHidden(true)
        } label: {
            label
        }

    }
}

#Preview {
    AvaNavigationView{
        AvaNavigationLink {
            Text("des")
        } label: {
            Text("Click me")
        }
    } background: {
        Color.blue
    }
}
