//
//  NavigationChatView.swift
//  AITherapist
//
//  Created by cyrus refahi on 2/13/24.
//

import SwiftUI

struct NavigationChatView: View {
    let conversation: Conversation
    let container: DIContainer
    
    var body: some View {
        AvaNavigationLink {
            ChatView(viewModel: .init(conversation: self.conversation, container: self.container))
                .avaNavigationBarTopLeftButton(.back)
                .avaNavigationBarTitle("")
        } label: {
            EmptyView()
        } background: {
            ChatEarBackgroundView()
        }
        .opacity(0)
    }
}

#if DEBUG
#Preview {
    NavigationChatView(conversation: .init(id: 0, conversationName: "test", date: .now), container: .previews)
}
#endif
