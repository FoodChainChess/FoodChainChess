import Foundation
import SwiftUI

protocol TextStyle : ViewModifier {
    
}

struct TitleTextStyle : TextStyle {
    func body (content: Content) -> some View {
        content
            .foregroundColor(Colors.text)
            .fontWeight(.bold)
            .font(.title)
    }
}

extension Text {
    func TextStyle <T:TextStyle>(_ style : T) -> some View {
        modifier(style)
    }
}

struct TextStyles {
    static let titleTextStyle = TitleTextStyle()
}
