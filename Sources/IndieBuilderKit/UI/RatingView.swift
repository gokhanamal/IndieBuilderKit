//
//  RatingView.swift
//  IndieBuilderKit
//
//  Custom view for requesting app store reviews
//

import SwiftUI

// MARK: - Rating View

public struct RatingView: View {
    @Environment(\.dismiss) private var dismiss
    
    private let configuration: RatingConfiguration
    private let onCompletion: (() -> Void)?
    
    public init(
        configuration: RatingConfiguration = .default(),
        onCompletion: (() -> Void)? = nil
    ) {
        self.configuration = configuration
        self.onCompletion = onCompletion
    }
    
    public var body: some View {
        NavigationView {
            reviewContent
            .navigationBarHidden(true)
        }
    }
    
    // MARK: - Review Content
    
    private var reviewContent: some View {
        VStack(spacing: 32) {
            Spacer()
            
            // Header Icon
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: configuration.iconColors.map { $0.opacity(0.1) },
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 120, height: 120)
                
                Image(systemName: configuration.iconName)
                    .font(.system(size: 50, weight: .medium))
                    .foregroundColor(configuration.iconColors.first ?? .blue)
            }
            
            // Title and Description
            VStack(spacing: 16) {
                Text(configuration.title)
                    .font(.bold(28))
                    .foregroundColor(.textColor)
                    .multilineTextAlignment(.center)
                
                Text(configuration.subtitle)
                    .font(.regular(16))
                    .foregroundColor(.secondaryTextColor)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .padding(.horizontal, 20)
            }
            
            // Benefits List
            VStack(spacing: 16) {
                ForEach(configuration.benefits.indices, id: \.self) { index in
                    let benefit = configuration.benefits[index]
                    RatingBenefitRow(
                        icon: benefit.icon,
                        title: benefit.title,
                        description: benefit.description,
                        accentColor: configuration.iconColors.first ?? .yellow
                    )
                }
            }
            .padding(.horizontal, 24)
            
            Spacer()
            
            // Action Buttons
            VStack(spacing: 12) {
                PrimaryButton(
                    configuration.primaryButtonTitle,
                    style: PrimaryButtonStyle(
                        cornerRadius: 12,
                        backgroundColors: [configuration.iconColors.first ?? .blue],
                        foregroundColor: .white
                    )
                ) {
                    // Request app store review
                    RatingService.shared.requestRating()
                    onCompletion?()
                    dismiss()
                }
                
                LinkButton(
                    configuration.secondaryButtonTitle,
                    style: LinkButtonStyle(
                        foregroundColor: configuration.iconColors.first ?? .blue
                    )
                ) {
                    onCompletion?()
                    dismiss()
                }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 40)
        }
    }
    
}

// MARK: - Rating Benefit Row

private struct RatingBenefitRow: View {
    let icon: String
    let title: String
    let description: String
    let accentColor: Color
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(accentColor)
                .frame(width: 32, height: 32)
                .background(accentColor.opacity(0.1))
                .cornerRadius(8)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.medium(16))
                    .foregroundColor(.textColor)
                
                Text(description)
                    .font(.regular(14))
                    .foregroundColor(.secondaryTextColor)
                    .lineLimit(2)
            }
            
            Spacer()
        }
    }
}

// MARK: - Convenience Initializers

public extension RatingView {
    /// Default rating prompt
    static func ratingPrompt(onCompletion: (() -> Void)? = nil) -> RatingView {
        return RatingView(configuration: .default(), onCompletion: onCompletion)
    }
}

#if DEBUG
struct RatingView_Previews: PreviewProvider {
    static var previews: some View {
        RatingView()
    }
}
#endif
