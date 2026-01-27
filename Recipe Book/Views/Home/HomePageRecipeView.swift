//
//  HomePageRecipeView.swift
//  Recipe Book
//
//  Created by Grizzowl on 2026/01/23.
//

import SwiftUI

struct HomePageRecipeView: View {

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {

                Text("Food Name")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 200)
                    .cornerRadius(12)

                Text("Ingredients")
                    .font(.title2)
                    .fontWeight(.semibold)

                ForEach(0..<5, id: \.self) { _ in
                    Text("• Ingredient item")
                }

                Divider()

                Text("Instructions")
                    .font(.title2)
                    .fontWeight(.semibold)

                ForEach(0..<4, id: \.self) { step in
                    Text("\(step + 1). Instruction step goes here.")
                }
            }
            .padding()
        }
    }
}


struct HomePageRecipeView_Previews: PreviewProvider {
    static var previews: some View {
        HomePageRecipeView()
    }
}
