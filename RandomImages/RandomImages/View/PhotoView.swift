//
//  PhotoView.swift
//  RandomImages
//
//  Created by Sanket Likhe on 9/2/25.
//

import SwiftUI

struct PhotoView: View {
    let photo: Photos
    let onDelete: () -> Void //Callback for delete action
    
    //Individual row component for displaying each saved image
    var body: some View {
        HStack(spacing: 12) {
            //Async image with loading placeholder
            AsyncImage(url: URL(string: photo.thumbnailUrl)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(.systemGray5))
                    .overlay {
                        ProgressView()
                    }
            }
            .frame(width: 80, height: 60)
            .clipped()
            .cornerRadius(8)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("© \(photo.author)")
                    .font(.headline)
                    .lineLimit(1)
                
                Text("\(photo.width) × \(photo.height)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text("ID: \(photo.id)")
                    .font(.caption2)
                    .foregroundColor(.blue)
            }
            
            Spacer()
            
            Button(action: onDelete) {
                Image(systemName: "trash")
                    .foregroundColor(.red)
                    .font(.title3)
            }
            .buttonStyle(.borderless)
        }
        .padding(.vertical, 4)
    }
}
