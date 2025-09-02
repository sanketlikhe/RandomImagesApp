//
//  ErrorView.swift
//  RandomImages
//
//  Created by Sanket Likhe on 9/2/25.
//

import SwiftUI

struct ErrorView: View {
    let message: String
    let onDismiss: () -> Void //Callback when user dismisses error
    
    var body: some View {
        HStack {
            //Warning icon
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundColor(.orange)
    
            Text(message)
                .font(.caption)
                .foregroundColor(.primary)
            
            Spacer()
            
            Button("Dismiss") {
                onDismiss()
            }
            .font(.caption)
            .foregroundColor(.blue)
        }
        .padding()
        .background(Color(.systemYellow).opacity(0.1))
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color(.systemYellow), lineWidth: 1)
        )
    }
}
