import SwiftUI

struct SettingsSectionHeader: View {
    let title: String
    
    var body: some View {
        Text(title)
            .font(.system(size: 14, weight: .semibold))
            .foregroundColor(.gray)
            .padding(.leading, 8)
    }
} 