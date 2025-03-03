import SwiftUI

struct SearchView: View {
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                LazyVStack(spacing: 6) {
                    CompositionalLayout {
                        ForEach(1...50, id: \.self) { _ in
                            Rectangle()
                                .fill(.red.gradient)
                        }
                    }
                }
            }
        }
    }
} 

#Preview {
    SearchView()
}
