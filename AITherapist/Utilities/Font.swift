//
//  Font.swift
//  AITherapist
//
//  Created by cyrus refahi on 3/17/24.
//

import Foundation
import SwiftUI

enum AppFont: String {
    case sfProText = "SF-Pro-Text"
    case sfProTextMedium = "SF-Pro-Text-Medium"
    case sfProTextBold = "SF-Pro-Text-Bold"
}

public class FontTemplate {
    private var id: UUID
    public var font: Font
    public var weight: Font.Weight
    public var foregroundColor: Color
    public var italic: Bool
    public var lineSpacing: CGFloat
    public init(font: Font,
                weight: Font.Weight,
                foregroundColor: Color,
                italic: Bool = false,
                lineSpacing: CGFloat = 10.0) {
        self.id = UUID()
        self.font = font
        self.weight = weight
        self.foregroundColor = foregroundColor
        self.italic = italic
        self.lineSpacing = lineSpacing
    }
}

struct AppFontTemplate {
    static let title = FontTemplate(font: Font.custom(AppFont.sfProText.rawValue, size: 18.0),
                                    weight: .bold,
                                    foregroundColor: .black)
    static let heading = FontTemplate(font: Font.custom(AppFont.sfProText.rawValue, size: 16.0),
                                      weight: .medium,
                                      foregroundColor: .black)
    static let body = FontTemplate(font: Font.custom(AppFont.sfProText.rawValue, size: 12.0),
                                   weight: .regular,
                                   foregroundColor: .black)
}

struct FontTemplateModifier: ViewModifier {
    let template: FontTemplate
    init(template: FontTemplate) {
        self.template = template
    }
    func body(content: Content) -> some View {
        content
            .font(template.font
                    .weight(template.weight)
                    .italic(template.italic))
            .lineSpacing(template.lineSpacing)
            .foregroundColor(template.foregroundColor)
    }
}
extension Font {
    public func italic(_ value: Bool) -> Font {
        return value ? self.italic() : self
    }
}
