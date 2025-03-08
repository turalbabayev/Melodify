import SwiftUI

struct LaunchScreen: View {
    @State private var isAnimating = false
    @State private var showMainView = false
    @State private var progress: CGFloat = 0
    
    var body: some View {
        ZStack {
            // Arka plan
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 24) {
                // Logo animasyonu
                ZStack {
                    // Dış halka
                    Circle()
                        .stroke(
                            LinearGradient(
                                colors: [.purple.opacity(0.5), .blue.opacity(0.2)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 8
                        )
                        .frame(width: 100, height: 100)
                        .rotationEffect(Angle(degrees: isAnimating ? 360 : 0))
                        .animation(
                            .linear(duration: 2)
                            .repeatForever(autoreverses: false),
                            value: isAnimating
                        )
                    
                    // İç logo
                    Image("AppIcon")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 60, height: 60)
                        .scaleEffect(isAnimating ? 1.1 : 0.9)
                        .animation(
                            .easeInOut(duration: 1)
                            .repeatForever(autoreverses: true),
                            value: isAnimating
                        )
                }
                .padding(.bottom, 20)
                
                // App ismi ve Tagline
                VStack(spacing: 8) {
                    Text("MELODIFY")
                        .font(.system(size: 36, weight: .black))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.white, .white.opacity(0.7)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .opacity(isAnimating ? 1 : 0)
                        .animation(.easeIn(duration: 0.8).delay(0.3), value: isAnimating)
                    
                    Text("CREATE YOUR MUSIC")
                        .font(.system(size: 16, weight: .medium))
                        .tracking(4) // Harfler arası boşluk
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.purple.opacity(0.8), .blue.opacity(0.8)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .opacity(isAnimating ? 1 : 0)
                        .animation(.easeIn(duration: 0.8).delay(0.5), value: isAnimating)
                }
                
                // Progress Bar
                VStack(spacing: 12) {
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 200, height: 4)
                        
                        RoundedRectangle(cornerRadius: 20)
                            .fill(
                                LinearGradient(
                                    colors: [.purple, .blue],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: 200 * progress, height: 4)
                    }
                    
                    Text("Loading...")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.gray.opacity(0.8))
                }
                .opacity(isAnimating ? 1 : 0)
                .animation(.easeIn(duration: 0.8).delay(0.7), value: isAnimating)
            }
        }
        .onAppear {
            isAnimating = true
            
            // Progress bar animasyonu
            withAnimation(.linear(duration: 2.5)) {
                progress = 1.0
            }
            
            // Ana ekrana geçiş
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                withAnimation {
                    showMainView = true
                }
            }
        }
        .fullScreenCover(isPresented: $showMainView) {
            MainView()
        }
    }
}

#Preview {
    LaunchScreen()
} 
