import SwiftUI

struct LoadingView: View {
    @State private var isAnimating = false
    
    var body: some View {
        ZStack {
            // Arka plan blur
            Color.black.opacity(0.6)
                .ignoresSafeArea()
            
            // Loading içeriği
            VStack(spacing: 20) {
                // Animasyonlu loading indikatörü
                Circle()
                    .trim(from: 0, to: 0.7)
                    .stroke(
                        LinearGradient(
                            colors: [.purple, .blue],
                            startPoint: .leading,
                            endPoint: .trailing
                        ),
                        style: StrokeStyle(
                            lineWidth: 4,
                            lineCap: .round
                        )
                    )
                    .frame(width: 50, height: 50)
                    .rotationEffect(Angle(degrees: isAnimating ? 360 : 0))
                    .animation(
                        .linear(duration: 1)
                        .repeatForever(autoreverses: false),
                        value: isAnimating
                    )
                
                Text("Generating Music...")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white)
            }
            .padding(30)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.black.opacity(0.8))
            )
        }
        .onAppear {
            isAnimating = true
        }
    }
}

#Preview {
    LoadingView()
} 