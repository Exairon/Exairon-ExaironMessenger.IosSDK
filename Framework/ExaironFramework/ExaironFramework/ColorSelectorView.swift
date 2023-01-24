//
//  ColorSelectorView.swift
//  ExaironFramework
//
//  Created by Exairon on 23.01.2023.
//

import SwiftUI

public struct ColorSelectorView: View {
    
    @Binding var selectedColor: Color
    
    let colors: [Color] = [.red, .purple, .green, .yellow, .blue]
    
    public init(selectedColor: Binding<Color>){
        self._selectedColor = selectedColor
    }
    
    public var body: some View {
        HStack {
            ForEach(colors, id: \.self) {
                color in Image(systemName: selectedColor == color ? "record.circle.fill" : "circle.fill").foregroundColor(color).onTapGesture {
                    selectedColor = color
                }
            }
        }
    }
}

struct ColorSelectorView_Previews: PreviewProvider {
    static var previews: some View {
        ColorSelectorView(selectedColor: .constant(.blue))
    }
}
