import SwiftUI

struct PaywallView: View {
    @StateObject private var viewModel = PaywallViewModel()
    @Environment(\.dismiss) private var dismiss
    @State private var showCloseButton = false
    
    var body: some View {
        ZStack {
            // Arkaplan gradyanı
            LinearGradient(
                colors: [
                    .black,
                    .purple.opacity(0.3),
                    .black
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    // Header
                    headerSection
                    
                    // Features
                    featuresSection
                    
                    // Plans
                    plansSection
                    
                    // Terms & Privacy
                    termsSection
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 30)
            }
            
            // Close button
            if showCloseButton {
                closeButton
                    .transition(.opacity)
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation {
                    showCloseButton = true
                }
            }
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 16) {
            Image("premium_icon") // Premium ikon asset'i eklenecek
                .resizable()
                .frame(width: 80, height: 80)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(LinearGradient(
                            colors: [.purple, .blue],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ), lineWidth: 2)
                )
                .shadow(color: .purple.opacity(0.3), radius: 10)
            
            Text("paywall_unlock_premium".localized)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
            
            Text("paywall_description".localized)
                .font(.system(size: 16))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
    }
    
    private var featuresSection: some View {
        VStack(spacing: 16) {
            ForEach(viewModel.features) { feature in
                HStack(spacing: 12) {
                    Image(systemName: feature.icon)
                        .foregroundColor(.purple)
                        .font(.system(size: 22))
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(feature.title.localized)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                        
                        Text(feature.description.localized)
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                }
                .padding()
                .background(Color.white.opacity(0.05))
                .cornerRadius(12)
            }
        }
    }
    
    private var plansSection: some View {
        VStack(spacing: 16) {
            ForEach(viewModel.plans) { plan in
                Button {
                    viewModel.selectPlan(plan)
                } label: {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(plan.title.localized)
                                .font(.system(size: 18, weight: .bold))
                            
                            Text("\(plan.credits) " + "credits".localized)
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                            
                            if let savings = plan.savings {
                                Text("paywall_save".localized + " \(savings)%")
                                    .font(.system(size: 14))
                                    .foregroundColor(.green)
                            }
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: 4) {
                            Text(plan.price)
                                .font(.system(size: 22, weight: .bold))
                            
                            if let perMonth = plan.pricePerMonth {
                                Text("\(perMonth) / " + "paywall_month".localized)
                                    .font(.system(size: 14))
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .padding()
                    .background(plan.isSelected ? Color.purple.opacity(0.3) : Color.white.opacity(0.05))
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(plan.isSelected ? Color.purple : Color.clear, lineWidth: 2)
                    )
                }
                .buttonStyle(PlainButtonStyle())
            }
            
            // Purchase Button
            Button {
                viewModel.purchase()
            } label: {
                Text("paywall_start_premium".localized)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        LinearGradient(
                            colors: [.purple, .blue],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(12)
            }
            .padding(.top, 16)
        }
    }
    
    private var termsSection: some View {
        VStack(spacing: 8) {
            Text("paywall_terms_description".localized)
                .font(.system(size: 12))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
            
            HStack(spacing: 16) {
                Button("paywall_terms".localized) {
                    viewModel.showTerms()
                }
                
                Button("paywall_privacy".localized) {
                    viewModel.showPrivacy()
                }
            }
            .font(.system(size: 12))
            .foregroundColor(.purple)
        }
    }
    
    private var closeButton: some View {
        VStack {
            HStack {
                Spacer()
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                        .padding(12)
                        .background(.ultraThinMaterial)
                        .clipShape(Circle())
                }
                .padding(20)
            }
            Spacer()
        }
    }
} 