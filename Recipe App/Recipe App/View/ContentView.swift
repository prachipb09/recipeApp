//
//  ContentView.swift
//  Recipe App
//
//  Created by Prachi Bharadwaj on 14/10/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel: RecipeViewModel = RecipeViewModel()
    @State private var showLoader: Bool = false
    @State private var showErrorView: Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Welcome Sam!")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Spacer().frame(height: 8.0)
            
            Text("Explore our menu...")
                .font(.title)
                .fontWeight(.semibold)
            ScrollView(.vertical) {
                VStack(alignment: .leading) {
                    if !viewModel.sortedRecipes.isEmpty {
                        ForEach(viewModel.sortedRecipes, id: \.uuid) { recipe in
                            rowView(recipe: recipe)
                        }
                    }
                }.padding(.vertical, 16.0)
            }
        }.padding(.all, 16.0)
        .onLoad {
            fetchData()
        }
        .alert(isPresented: $showErrorView, content: {
            Alert(title: Text(ErrorMessage.generic.message))
        })
        .showLoader(showLoader)
        .refreshable {
            fetchData()
        }
    }
    
    @ViewBuilder func rowView(recipe: RecipeElementModel) -> some View {
        VStack(alignment: .leading) {
            HStack(spacing: 16) {
                RecipeImage(recipeImageKey: recipe.photoURLSmall)
                    .frame(maxWidth: 175, maxHeight: 175)
                VStack(alignment: .leading, spacing: 16) {
                    HStack(alignment: .top) {
                        Text("name:")
                            .font(.subheadline)
                        Text(recipe.name ?? "")
                            .font(.headline)
                            .multilineTextAlignment(.leading)
                    }
                    HStack {
                        Text("cuisine:")
                            .font(.subheadline)
                        Text(recipe.cuisine ?? "")
                            .font(.headline)
                    }
                }
            }
            Divider()
                .foregroundStyle(.black)
        }
    }
    
   private func fetchData() {
        Task {
            do {
                showLoader = true
                try await viewModel.fetchData()
            } catch {
                showErrorView = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5,
                                          execute: DispatchWorkItem(block: {
                showLoader = false
            }))
        }
    }
}

#Preview {
    ContentView()
}
