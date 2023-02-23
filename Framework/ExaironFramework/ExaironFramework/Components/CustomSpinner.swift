//
//  CustomSpinner.swift
//  ExaironFramework
//
//  Created by Exairon on 23.02.2023.
//

import SwiftUI

struct CustomSpinner: View {
    var frameSize: CGFloat = 72
    @State private var isAnimating = false
    
    var foreverAnimation: Animation {
        Animation
            .spring(response: 1, dampingFraction: 0.7, blendDuration: 0)
            .repeatForever(autoreverses: false)
    }
    
    var body: some View {
        Image(systemName: "photo")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: frameSize)
            .rotationEffect(Angle(degrees: isAnimating ? 360.0 : 0.0))
            .animation(foreverAnimation)
            .onAppear {
                isAnimating = true
            }
    }
}
