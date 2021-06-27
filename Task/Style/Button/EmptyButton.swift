import SwiftUI

struct EmptyButton: ButtonStyle {
    let color: Color
    let isSelect: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.horizontal)
            .padding(.vertical, 4)
            .background(color)
            .opacity(isSelect ? 1 : 0.5)
            .cornerRadius(12)
    }
}
