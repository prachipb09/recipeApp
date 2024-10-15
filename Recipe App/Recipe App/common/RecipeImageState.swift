//
//  FCVehicleImageState.swift
//  Recipe App
//
//  Created by Prachi Bharadwaj on 15/10/24.
//


import SwiftUI

enum RecipeImageState {
    case notAvailable
    case loading
    case loaded
    case notLoaded

    func getMessage() -> String {
        switch self {
        case .notAvailable: 
                return "Not available"
        case .notLoaded:
                return "not loaded"
        default:
                return ""
        }
    }
}

struct RecipeImage: View {

    private let recipeImageKey: String?
    private let placeholderImage: String?
    private let shouldDisplayPlaceholderImageOnError: Bool

    init(recipeImageKey: String?,
         placeholderImage: String? = nil,
         shouldDisplayPlaceholderImageOnError: Bool = false) {
        self.recipeImageKey = recipeImageKey
        self.placeholderImage = placeholderImage
        self.shouldDisplayPlaceholderImageOnError = shouldDisplayPlaceholderImageOnError
    }

    @State private var state: RecipeImageState = .loading
    @StateObject private var imageLoader = RecipeImageLoader()

    @ViewBuilder private func errorView(state: RecipeImageState) -> some View {
        VStack(spacing: 4.0) {
            ProgressView()
            Text(state.getMessage())
                .font(.caption)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .cornerRadius(4.0)
    }

    @ViewBuilder private func recipePlaceHolder(image: String) -> some View {
        Image(image)
            .resizable()
            .frame(maxWidth: .infinity)
    }

    var body: some View {
        if let recipeImageKey = recipeImageKey, !recipeImageKey.isEmpty {
            switch state {
            case .notAvailable:
                if shouldDisplayPlaceholderImageOnError, let placeholderImage = placeholderImage {
                    recipePlaceHolder(image: placeholderImage)
                } else {
                    errorView(state: .notAvailable)
                }
            case .loading:
                    ProgressView()
                    .task {
                        try? await imageLoader.fetchRecipeImage(recipeImageKey: recipeImageKey)
                        state = .loaded
                    }
            case .loaded:
                if let uiImage = imageLoader.uiImage {
                    Image(uiImage: uiImage)
                        .resizable()
                        .frame(maxWidth: .infinity)
                } else {
                    if shouldDisplayPlaceholderImageOnError, let placeholderImage = placeholderImage {
                        recipePlaceHolder(image: placeholderImage)
                    } else {
                        errorView(state: .notAvailable)
                    }
                }
            case .notLoaded:
                if shouldDisplayPlaceholderImageOnError, let placeholderImage = placeholderImage {
                    recipePlaceHolder(image: placeholderImage)
                } else {
                    errorView(state: .notLoaded)
                }
            }
        } else {
            if shouldDisplayPlaceholderImageOnError, let placeholderImage = placeholderImage {
                recipePlaceHolder(image: placeholderImage)
            } else {
                errorView(state: .notAvailable)
            }
        }
    }
}
