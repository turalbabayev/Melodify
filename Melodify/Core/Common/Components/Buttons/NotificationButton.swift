import SwiftUI

struct NotificationButton: View {
    var body: some View {
        Button {
            // Bildirimler açılacak
        } label: {
            Image(systemName: "bell")
                .font(.system(size: 20, weight: .medium))
                .foregroundStyle(.white)
                .frame(width: 44, height: 44)
                .background {
                    Circle()
                        .fill(Color(UIColor.systemGray6).opacity(0.1))
                        .overlay {
                            Circle()
                                .stroke(.white.opacity(0.1), lineWidth: 1)
                        }
                }
        }
    }
} 