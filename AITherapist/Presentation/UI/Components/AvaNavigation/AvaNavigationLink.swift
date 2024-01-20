//
//  AvaNavLink.swift
//  AITherapist
//
//  Created by Cyrus Refahi on 11/5/23.
//

import SwiftUI

struct AvaNavigationLink<Label, Destination, Background> : View where Background: View, Label : View, Destination : View {
    
    let label: Label
    let destination: Destination
    let background: Background
    
    public init(@ViewBuilder destination: () -> Destination, @ViewBuilder label: () -> Label, @ViewBuilder background: () -> Background)
    {
        self.destination = destination()
        self.label = label()
        self.background = background()
    }
    
    var body: some View {
        NavigationLink {
            AvaNavBarView{
                destination
            } background: {
                self.background
            }
            .navigationBarBackButtonHidden(true)
            .toolbarBackground(.hidden, for: .navigationBar)
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
        }background: {
            EmptyView()
        }
    } background: {
        Color.blue
    }
}
