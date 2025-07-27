//
//  ButtonComponents.swift
//  IndieBuilderKit
//
//  Beautiful, reusable button components for modern iOS apps
//

import SwiftUI

// MARK: - Primary Button

public struct PrimaryButton: View {
    private let title: String
    private let action: () -> Void
    private let isLoading: Bool
    private let isDisabled: Bool
    private let style: PrimaryButtonStyle
    
    public init(
        _ title: String,
        isLoading: Bool = false,
        isDisabled: Bool = false,
        style: PrimaryButtonStyle = .default,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.action = action
        self.isLoading = isLoading
        self.isDisabled = isDisabled
        self.style = style
    }
    
    public var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: style.foregroundColor))
                        .scaleEffect(0.8)
                } else {
                    Text(title)
                        .font(.medium(16))
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: style.height)
            .background(
                LinearGradient(
                    colors: isDisabled ? [.gray, .gray.opacity(0.8)] : style.backgroundColors,
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .foregroundColor(style.foregroundColor)
            .cornerRadius(style.cornerRadius)
            .shadow(
                color: isDisabled ? .clear : style.shadowColor,
                radius: style.shadowRadius,
                x: 0,
                y: style.shadowOffset
            )
        }
        .disabled(isDisabled || isLoading)
        .buttonStyle(ScaleButtonStyle())
    }
}

// MARK: - Secondary Button

public struct SecondaryButton: View {
    private let title: String
    private let action: () -> Void
    private let isDisabled: Bool
    private let style: SecondaryButtonStyle
    
    public init(
        _ title: String,
        isDisabled: Bool = false,
        style: SecondaryButtonStyle = .default,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.action = action
        self.isDisabled = isDisabled
        self.style = style
    }
    
    public var body: some View {
        Button(action: action) {
            Text(title)
                .font(.medium(16))
                .frame(maxWidth: .infinity)
                .frame(height: style.height)
                .foregroundColor(isDisabled ? .gray : style.foregroundColor)
                .background(
                    RoundedRectangle(cornerRadius: style.cornerRadius)
                        .stroke(
                            isDisabled ? .gray : style.borderColor,
                            lineWidth: style.borderWidth
                        )
                        .background(
                            RoundedRectangle(cornerRadius: style.cornerRadius)
                                .fill(style.backgroundColor)
                        )
                )
        }
        .disabled(isDisabled)
        .buttonStyle(ScaleButtonStyle())
    }
}

// MARK: - Icon Button

public struct IconButton: View {
    private let icon: String
    private let title: String?
    private let action: () -> Void
    private let style: IconButtonStyle
    
    public init(
        icon: String,
        title: String? = nil,
        style: IconButtonStyle = .default,
        action: @escaping () -> Void
    ) {
        self.icon = icon
        self.title = title
        self.action = action
        self.style = style
    }
    
    public var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: style.iconSize, weight: .medium))
                
                if let title = title {
                    Text(title)
                        .font(.medium(14))
                }
            }
            .padding(.horizontal, title != nil ? 16 : 12)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: style.cornerRadius)
                    .fill(style.backgroundColor)
            )
            .foregroundColor(style.foregroundColor)
            .shadow(
                color: style.shadowColor,
                radius: style.shadowRadius,
                x: 0,
                y: 2
            )
        }
        .buttonStyle(ScaleButtonStyle())
    }
}

// MARK: - Floating Action Button

public struct FloatingActionButton: View {
    private let icon: String
    private let action: () -> Void
    private let style: FloatingButtonStyle
    
    public init(
        icon: String,
        style: FloatingButtonStyle = .default,
        action: @escaping () -> Void
    ) {
        self.icon = icon
        self.action = action
        self.style = style
    }
    
    public var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: style.iconSize, weight: .semibold))
                .foregroundColor(style.foregroundColor)
                .frame(width: style.size, height: style.size)
                .background(
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: style.backgroundColors,
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                )
                .shadow(
                    color: style.shadowColor,
                    radius: style.shadowRadius,
                    x: 0,
                    y: 4
                )
        }
        .buttonStyle(ScaleButtonStyle(scale: 0.9))
    }
}

// MARK: - Chip Button

public struct ChipButton: View {
    private let title: String
    private let isSelected: Bool
    private let action: () -> Void
    private let style: ChipButtonStyle
    
    public init(
        _ title: String,
        isSelected: Bool = false,
        style: ChipButtonStyle = .default,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.isSelected = isSelected
        self.action = action
        self.style = style
    }
    
    public var body: some View {
        Button(action: action) {
            Text(title)
                .font(.medium(14))
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    Capsule()
                        .fill(isSelected ? style.selectedBackgroundColor : style.backgroundColor)
                        .overlay(
                            Capsule()
                                .stroke(
                                    isSelected ? style.selectedBorderColor : style.borderColor,
                                    lineWidth: 1
                                )
                        )
                )
                .foregroundColor(isSelected ? style.selectedForegroundColor : style.foregroundColor)
        }
        .buttonStyle(ScaleButtonStyle())
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
}

// MARK: - Link Button

public struct LinkButton: View {
    private let title: String
    private let action: () -> Void
    private let style: LinkButtonStyle
    
    public init(
        _ title: String,
        style: LinkButtonStyle = .default,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.action = action
        self.style = style
    }
    
    public var body: some View {
        Button(action: action) {
            Text(title)
                .font(.medium(style.fontSize))
                .foregroundColor(style.foregroundColor)
                .underline(style.showUnderline)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Button Styles

public struct PrimaryButtonStyle {
    public let height: CGFloat
    public let cornerRadius: CGFloat
    public let backgroundColors: [Color]
    public let foregroundColor: Color
    public let shadowColor: Color
    public let shadowRadius: CGFloat
    public let shadowOffset: CGFloat
    
    public init(
        height: CGFloat = 50,
        cornerRadius: CGFloat = 12,
        backgroundColors: [Color] = [.accentColor, .accentColor.opacity(0.8)],
        foregroundColor: Color = .white,
        shadowColor: Color = .accentColor.opacity(0.3),
        shadowRadius: CGFloat = 8,
        shadowOffset: CGFloat = 4
    ) {
        self.height = height
        self.cornerRadius = cornerRadius
        self.backgroundColors = backgroundColors
        self.foregroundColor = foregroundColor
        self.shadowColor = shadowColor
        self.shadowRadius = shadowRadius
        self.shadowOffset = shadowOffset
    }
    
    public static let `default` = PrimaryButtonStyle()
    public static let rounded = PrimaryButtonStyle(cornerRadius: 25)
    public static let compact = PrimaryButtonStyle(height: 40)
    public static let destructive = PrimaryButtonStyle(
        backgroundColors: [.red, .red.opacity(0.8)],
        shadowColor: .red.opacity(0.3)
    )
    public static let success = PrimaryButtonStyle(
        backgroundColors: [.green, .green.opacity(0.8)],
        shadowColor: .green.opacity(0.3)
    )
}

public struct SecondaryButtonStyle {
    public let height: CGFloat
    public let cornerRadius: CGFloat
    public let backgroundColor: Color
    public let foregroundColor: Color
    public let borderColor: Color
    public let borderWidth: CGFloat
    
    public init(
        height: CGFloat = 50,
        cornerRadius: CGFloat = 12,
        backgroundColor: Color = .clear,
        foregroundColor: Color = .accentColor,
        borderColor: Color = .accentColor,
        borderWidth: CGFloat = 2
    ) {
        self.height = height
        self.cornerRadius = cornerRadius
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
        self.borderColor = borderColor
        self.borderWidth = borderWidth
    }
    
    public static let `default` = SecondaryButtonStyle()
    public static let filled = SecondaryButtonStyle(backgroundColor: .accentColor.opacity(0.1))
    public static let rounded = SecondaryButtonStyle(cornerRadius: 25)
}

public struct IconButtonStyle {
    public let iconSize: CGFloat
    public let cornerRadius: CGFloat
    public let backgroundColor: Color
    public let foregroundColor: Color
    public let shadowColor: Color
    public let shadowRadius: CGFloat
    
    public init(
        iconSize: CGFloat = 16,
        cornerRadius: CGFloat = 8,
        backgroundColor: Color = Color(.systemGray6),
        foregroundColor: Color = .primary,
        shadowColor: Color = .black.opacity(0.1),
        shadowRadius: CGFloat = 2
    ) {
        self.iconSize = iconSize
        self.cornerRadius = cornerRadius
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
        self.shadowColor = shadowColor
        self.shadowRadius = shadowRadius
    }
    
    public static let `default` = IconButtonStyle()
    public static let prominent = IconButtonStyle(
        backgroundColor: .accentColor,
        foregroundColor: .white,
        shadowColor: .accentColor.opacity(0.3),
        shadowRadius: 4
    )
}

public struct FloatingButtonStyle {
    public let size: CGFloat
    public let iconSize: CGFloat
    public let backgroundColors: [Color]
    public let foregroundColor: Color
    public let shadowColor: Color
    public let shadowRadius: CGFloat
    
    public init(
        size: CGFloat = 56,
        iconSize: CGFloat = 24,
        backgroundColors: [Color] = [.accentColor, .accentColor.opacity(0.8)],
        foregroundColor: Color = .white,
        shadowColor: Color = .black.opacity(0.2),
        shadowRadius: CGFloat = 8
    ) {
        self.size = size
        self.iconSize = iconSize
        self.backgroundColors = backgroundColors
        self.foregroundColor = foregroundColor
        self.shadowColor = shadowColor
        self.shadowRadius = shadowRadius
    }
    
    public static let `default` = FloatingButtonStyle()
    public static let compact = FloatingButtonStyle(size: 44, iconSize: 20)
    public static let large = FloatingButtonStyle(size: 64, iconSize: 28)
}

public struct ChipButtonStyle {
    public let backgroundColor: Color
    public let selectedBackgroundColor: Color
    public let foregroundColor: Color
    public let selectedForegroundColor: Color
    public let borderColor: Color
    public let selectedBorderColor: Color
    
    public init(
        backgroundColor: Color = .clear,
        selectedBackgroundColor: Color = .accentColor,
        foregroundColor: Color = .primary,
        selectedForegroundColor: Color = .white,
        borderColor: Color = Color(.systemGray4),
        selectedBorderColor: Color = .accentColor
    ) {
        self.backgroundColor = backgroundColor
        self.selectedBackgroundColor = selectedBackgroundColor
        self.foregroundColor = foregroundColor
        self.selectedForegroundColor = selectedForegroundColor
        self.borderColor = borderColor
        self.selectedBorderColor = selectedBorderColor
    }
    
    public static let `default` = ChipButtonStyle()
}

public struct LinkButtonStyle {
    public let fontSize: CGFloat
    public let foregroundColor: Color
    public let showUnderline: Bool
    
    public init(
        fontSize: CGFloat = 16,
        foregroundColor: Color = .accentColor,
        showUnderline: Bool = false
    ) {
        self.fontSize = fontSize
        self.foregroundColor = foregroundColor
        self.showUnderline = showUnderline
    }
    
    public static let `default` = LinkButtonStyle()
    public static let underlined = LinkButtonStyle(showUnderline: true)
    public static let small = LinkButtonStyle(fontSize: 14)
}

// MARK: - Scale Button Style

private struct ScaleButtonStyle: ButtonStyle {
    let scale: CGFloat
    
    init(scale: CGFloat = 0.95) {
        self.scale = scale
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? scale : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

// MARK: - Preview Examples

#if DEBUG
struct ButtonComponents_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            VStack(spacing: 20) {
                Group {
                    Text("Primary Buttons")
                        .font(.bold(18))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    PrimaryButton("Default Primary") { }
                    PrimaryButton("Loading", isLoading: true) { }
                    PrimaryButton("Disabled", isDisabled: true) { }
                    PrimaryButton("Rounded", style: .rounded) { }
                    PrimaryButton("Destructive", style: .destructive) { }
                }
                
                Group {
                    Text("Secondary Buttons")
                        .font(.bold(18))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    SecondaryButton("Default Secondary") { }
                    SecondaryButton("Filled", style: .filled) { }
                    SecondaryButton("Disabled", isDisabled: true) { }
                }
                
                Group {
                    Text("Icon Buttons")
                        .font(.bold(18))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    HStack {
                        IconButton(icon: "heart.fill") { }
                        IconButton(icon: "star.fill", title: "Favorite") { }
                        IconButton(icon: "share", style: .prominent) { }
                        Spacer()
                    }
                }
                
                Group {
                    Text("Floating & Chip Buttons")
                        .font(.bold(18))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    HStack {
                        FloatingActionButton(icon: "plus") { }
                        FloatingActionButton(icon: "message", style: .compact) { }
                        Spacer()
                    }
                    
                    HStack {
                        ChipButton("Design", isSelected: true) { }
                        ChipButton("Development") { }
                        ChipButton("Marketing") { }
                        Spacer()
                    }
                }
                
                Group {
                    Text("Link Buttons")
                        .font(.bold(18))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    HStack {
                        LinkButton("Learn More") { }
                        LinkButton("Terms of Service", style: .underlined) { }
                        LinkButton("Small Link", style: .small) { }
                        Spacer()
                    }
                }
            }
            .padding()
        }
    }
}
#endif