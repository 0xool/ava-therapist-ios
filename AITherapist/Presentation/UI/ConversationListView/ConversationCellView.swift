//
//  ConversationCellView.swift
//  AITherapist
//
//  Created by cyrus refahi on 3/13/24.
//

import SwiftUI

struct ConversationCellView<Content: View>: View {
    
    var conversation: Conversation
    let imageName: String = "ImagePlaceholder"
    @State var isOpen: Bool = false
    @State private var labelHeight = CGFloat.zero
    
    @ViewBuilder let navigationView: Content
    
    var body: some View {
        cellView
    }
    
    @ViewBuilder private var cellView: some View {
        ZStack{
            VStack(alignment: .center, spacing: 8) {
                HStack(alignment: .center, spacing: 8) {
                    Text(getDateString())
                        .font(Font.custom("SF Pro Text", size: 11))
                        .kerning(0.066)
                        .multilineTextAlignment(.center)
                        .foregroundColor(ColorPallet.DarkBlue)
                        .frame(width: 60)
                    
                    ConversationCustomDivider(height: labelHeight)
                    
                    HStack{
                        Spacer()
                        Text(self.conversation.summary ?? "No Summary")
                            .font(Font.custom("SF Pro Text", size: 11))
                            .kerning(0.066)
                            .multilineTextAlignment(.center)
                            .foregroundColor((self.conversation.summary != nil) ? ColorPallet.DarkBlue : ColorPallet.TertiaryYellow)
                        Spacer()
                    }
                    
                    ConversationCustomDivider(height: labelHeight)
                    
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 70, height: 70)
                        .background(
                            Text(getMoodEmojiFromString(mood: self.conversation.mood))
                                .font(.system(size: 35))
                                .frame(width: 70, height: 70)
                                .clipped()
                        )
                        .cornerRadius(15)
                }
                .background(GeometryReader {
                    Color.clear.preference(key: ViewHeightKey.self,
                                           value: $0.frame(in: .local).size.height)
                })
                .frame(maxHeight:  isOpen ? nil : 100)
                .onPreferenceChange(ViewHeightKey.self) {
                    self.labelHeight = $0
                }
                .frame(maxWidth: .infinity)
                .onTapGesture {
                    withAnimation{
                        isOpen = true
                    }
                }
                
                ZStack{
                    Text("Continue")
                        .font(Font.custom("SF Pro Text", size: 15))
                        .kerning(0.066)
                        .foregroundColor(ColorPallet.DarkBlueText)
                        .frame(width: 74, alignment: .center)
                    
                    navigationView
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .opacity(isOpen ? 1 : 0)
                .frame(height: isOpen ? 30 : 0)
                .frame(maxWidth: .infinity)
                .background{
                    RoundedRectangle(cornerRadius: 25)
                        .fill(ColorPallet.SkyBlue)
                }
                
                RoundedRectangle(cornerRadius: 15)
                    .fill(ColorPallet.SkyBlue)
                    .frame(maxWidth: .infinity)
                    .frame(height: 1)
                    .shadow(color: ColorPallet.SkyBlue, radius: 10, x: 0, y: 5)
                
            }
        }
        .padding()
        .padding([.bottom, .top], 2)
    }
    
    private func getDateString() -> String {
        let components = conversation.dateCreated.get(.month, .day, .year)
        if let day = components.day, let month = components.month, let year = components.year {
            return "\(day)/\(month)/\(year)"
        }
        
        return ""
    }
}

extension ConversationCellView{
    struct ViewHeightKey: PreferenceKey {
        static var defaultValue: CGFloat { 0 }
        static func reduce(value: inout Value, nextValue: () -> Value) {
            value = value + nextValue()
        }
    }
}

extension ConversationCellView{
    struct ConversationCustomDivider: View {
        let height: CGFloat
        let color: Color = ColorPallet.DarkBlue
        let width: CGFloat = 1
        
        var body: some View {
            Line()
                .stroke(style: .init(dash: [4]))
                .foregroundStyle(ColorPallet.SkyBlue)
                .frame(width: width, height: height)
        }
    }
    
    struct Line: Shape {
        func path(in rect: CGRect) -> Path {
            var path = Path()
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: 0, y: rect.height))
            return path
        }
    }
}

#if DEBUG
#Preview {
    ConversationCellView(conversation: .init(id: 0, conversationName: "Test", date: .now, summary: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.")) {
        
    }
}
#endif
