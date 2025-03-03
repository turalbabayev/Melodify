import SwiftUI

struct SearchView: View {
    var body: some View {
        VStack {
            Text("Search View")
                .font(.largeTitle)
                .padding()
            // Arama alanı ve diğer bileşenler buraya eklenebilir
        }
        .navigationTitle("Search")
    }
}

#Preview {
    SearchView()
} 