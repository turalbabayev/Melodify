import SwiftUI

extension View {
    func tabBarHidden(_ hidden: Bool) -> some View {
        modifier(TabBarHidden(hidden: hidden))
    }
}

struct TabBarHidden: ViewModifier {
    let hidden: Bool
    
    func body(content: Content) -> some View {
        content
            .toolbar(hidden ? .hidden : .visible, for: .tabBar)
    }
} 