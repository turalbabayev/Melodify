import SwiftUI

struct CreatePlaylistSheet: View {
    @ObservedObject var viewModel: PlaylistViewModel
    @Environment(\.dismiss) var dismiss
    @FocusState private var focusedField: Field?
    
    enum Field {
        case name, description
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.opacity(0.9)
                    .ignoresSafeArea()
                
                VStack(spacing: 24) {
                    // Playlist Icon
                    Circle()
                        .fill(Color.purple.opacity(0.2))
                        .frame(width: 120, height: 120)
                        .overlay(
                            Image(systemName: "music.note.list")
                                .font(.system(size: 40))
                                .foregroundColor(.purple)
                        )
                        .padding(.top, 32)
                    
                    // Input Fields
                    VStack(spacing: 20) {
                        // Name Field
                        VStack(alignment: .leading, spacing: 8) {
                            Text("PLAYLIST NAME")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundColor(.gray)
                            
                            TextField("", text: $viewModel.newPlaylistName)
                                .placeholder(when: viewModel.newPlaylistName.isEmpty) {
                                    Text("My Awesome Playlist")
                                        .foregroundColor(.gray.opacity(0.5))
                                }
                                .font(.system(size: 16))
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.white.opacity(0.1))
                                .cornerRadius(12)
                                .focused($focusedField, equals: .name)
                        }
                        
                        // Description Field
                        VStack(alignment: .leading, spacing: 8) {
                            Text("DESCRIPTION")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundColor(.gray)
                            
                            TextField("", text: $viewModel.newPlaylistDescription)
                                .placeholder(when: viewModel.newPlaylistDescription.isEmpty) {
                                    Text("Add an optional description")
                                        .foregroundColor(.gray.opacity(0.5))
                                }
                                .font(.system(size: 16))
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.white.opacity(0.1))
                                .cornerRadius(12)
                                .focused($focusedField, equals: .description)
                        }
                    }
                    .padding(.horizontal, 24)
                    
                    Spacer()
                    
                    // Create Button
                    Button {
                        viewModel.createPlaylist()
                    } label: {
                        Text("Create Playlist")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                viewModel.newPlaylistName.isEmpty ?
                                Color.gray.opacity(0.3) :
                                Color.purple
                            )
                            .cornerRadius(16)
                    }
                    .disabled(viewModel.newPlaylistName.isEmpty)
                    .padding(.horizontal, 24)
                    .padding(.bottom, 32)
                }
            }
            .navigationTitle("New Playlist")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white)
                    }
                }
            }
        }
    }
}

// Placeholder modifier için extension
extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {
        
        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}

#Preview {
    CreatePlaylistSheet(viewModel: PlaylistViewModel())
} 