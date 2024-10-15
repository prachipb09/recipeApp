//
//  Loader.swift
//  Recipe App
//
//  Created by Prachi Bharadwaj on 14/10/24.
//


import SwiftUI

struct Loader: ViewModifier {
    var showLoader: Bool

    func body(content: Content) -> some View {
        content
            .overlay {
                if showLoader {
                    ProgressView()
                        .progressViewStyle(.circular)
                }
            }
    }
}

extension View {
    @ViewBuilder func showLoader(_ showLoader: Bool) -> some View {
        modifier(Loader(showLoader: showLoader))
    }
}