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
    let imageName: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            
            ZStack {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 160, height: 160)
                    .cornerRadius(12)
                
                AsyncImage(url: URL(string: imageName)) { phase in
                    switch phase {
                    case .empty:
                        ProgressView() // loading spinner
                        
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 160, height: 160) // height fixed
                            .frame(maxWidth: .infinity) // width auto
                            .clipped()
                            .cornerRadius(15)
                        
                    case .failure:
                        Image(systemName: "photo") // fallback icon
                            .resizable()
                            .scaledToFit()
                            .frame(width: 160, height: 160)
                            .foregroundColor(.gray)
                        
                    @unknown default:
                        EmptyView()
                    }
                }
            }
            
            Text(title)
                .font(.headline)
                .foregroundStyle(
                    .linearGradient(
                        colors: [.black, .orange],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .lineLimit(1)
            
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

