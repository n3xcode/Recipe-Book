//
//  RecipeTileView.swift
//  Recipe Book
//
//  Created by Grizzowl on 2026/01/19.
//

import SwiftUI

struct RecipeTileView: View {
    
    let title: String
    let subtitle: String
    let imageName: String   // later this becomes a URL
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            
            ZStack {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 120)
                    .cornerRadius(12)
                
                AsyncImage(url: URL(string: imageName)) { phase in
                    switch phase {
                    case .empty:
                        ProgressView() // loading spinner
                        
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(height: 140)
                            .clipped()
                        
                    case .failure:
                        Image(systemName: "photo") // fallback icon
                            .resizable()
                            .scaledToFit()
                            .frame(height: 140)
                            .foregroundColor(.gray)
                        
                    @unknown default:
                        EmptyView()
                    }
                }
            }
            
            Text(title)
                .font(.headline)
                .lineLimit(2)
            
            Text(subtitle)
                .font(.caption)
                .foregroundColor(.secondary)
                .lineLimit(1)
        }
    }
}


struct RecipeTileView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeTileView(title: "Jamaican Curry Chicken Recipe", subtitle: "Jamaican", imageName: "https://www.themealdb.com/images/media/meals/o5fuq51764789643.jpg")
        .padding()
        .previewLayout(.sizeThatFits)
    }
}

