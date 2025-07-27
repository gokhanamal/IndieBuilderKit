//
//  FontTestView.swift
//  IndieBuilderKit
//
//  Test view to verify font fallback functionality
//

import SwiftUI

#if DEBUG
struct FontTestView: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("Font Test")
                .font(.system(.largeTitle, weight: .bold))
            
            Group {
                Text("Regular Font")
                    .font(.regular(16))
                
                Text("Medium Font")
                    .font(.medium(16))
                
                Text("Bold Font") 
                    .font(.bold(16))
                
                Text("Light Font")
                    .font(.light(16))
                
                Text("Italic Font")
                    .font(.italic(16))
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(8)
            
            Text("All fonts above should display correctly,\nusing Roboto if available, or system fonts as fallback")
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
}

struct FontTestView_Previews: PreviewProvider {
    static var previews: some View {
        FontTestView()
            .onAppear {
                // Register fonts for preview
                IndieBuilderKit.registerCustomFonts()
            }
    }
}
#endif