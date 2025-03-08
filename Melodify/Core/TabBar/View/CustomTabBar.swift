import SwiftUI

struct CustomTabBar: View {
    @Binding var selectedTab: Tab
    
    // TabBar için yeni renkler
    private let backgroundColor = Color(UIColor(red: 0.02, green: 0.02, blue: 0.02, alpha: 1.0)) // #050505
    private let selectedColor = Color.purple
    private let unselectedColor = Color(UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 1.0)) // #666666
    private let separatorColor = Color(UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0)) // #1A1A1A
    
    var body: some View {
        VStack(spacing: 0) {
            // Üst çizgi
            Rectangle()
                .frame(height: 0.5)
                .foregroundColor(separatorColor)
                .opacity(0.5)
            
            // TabBar içeriği
            HStack {
                ForEach(Tab.allCases, id: \.self) { tab in
                    Spacer()
                    TabBarButton(
                        selectedTab: $selectedTab,
                        tab: tab,
                        selectedColor: selectedColor,
                        unselectedColor: unselectedColor
                    )
                    Spacer()
                }
            }
            .padding(.top, 8)
            
            // Safe area için ekstra boşluk
            Rectangle()
                .fill(backgroundColor)
                .frame(height: UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0)
        }
        .background(backgroundColor)
    }
}

struct TabBarButton: View {
    @Binding var selectedTab: Tab
    let tab: Tab
    let selectedColor: Color
    let unselectedColor: Color
    
    var body: some View {
        Button {
            withAnimation(.easeInOut) {
                selectedTab = tab
            }
        } label: {
            if tab == .create {
                // Özel Create Butonu
                VStack(spacing: 4) {
                    ZStack {
                        Circle()
                            .fill(Color.purple)
                            .frame(width: 48, height: 48)
                            .shadow(color: .purple.opacity(0.3), radius: 8, x: 0, y: 4)
                        
                        Image(tab.rawValue)
                            .resizable()
                            .renderingMode(.template)
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 24, height: 24)
                            .foregroundColor(.white)
                    }
                    .offset(y: -15)
                    
                    Text(tab.title)
                        .font(.system(size: 12))
                        .foregroundColor(selectedTab == tab ? selectedColor : unselectedColor)
                        .offset(y: -15)
                }
            } else {
                // Normal Tab Butonu
                VStack(spacing: 4) {
                    Image(tab.rawValue)
                        .resizable()
                        .renderingMode(.template)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 24, height: 24)
                        .foregroundColor(selectedTab == tab ? selectedColor : unselectedColor)
                    
                    Text(tab.title)
                        .font(.system(size: 12))
                        .foregroundColor(selectedTab == tab ? selectedColor : unselectedColor)
                }
            }
        }
    }
}

#Preview {
    CustomTabBar(selectedTab: .constant(.home))
        .preferredColorScheme(.dark)
}
// Hex renk oluşturucu extension
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
} 

