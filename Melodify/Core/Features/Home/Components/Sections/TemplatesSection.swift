import SwiftUI

struct TemplatesSection: View {
    @ObservedObject var viewModel: HomeViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Ready Templates")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(.white)
                
                Spacer()
                
                Button {
                    // Tümünü gör
                } label: {
                    Text("View All")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(AppColors.primaryPurple)
                }
            }
            
            VStack(spacing: 12) {
                ForEach(viewModel.templates) { template in
                    TemplateCard(
                        template: template,
                        isHovered: viewModel.hoveredTemplate == template,
                        onSelect: { viewModel.selectTemplate(template) }
                    )
                    .onHover { isHovered in
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                            viewModel.hoveredTemplate = isHovered ? template : nil
                        }
                    }
                }
            }
        }
    }
} 