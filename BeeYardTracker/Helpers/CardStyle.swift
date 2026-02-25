import SwiftUI

struct CardStyle: ViewModifier {
    var opacity: Double = 0.6
    func body(content: Content) -> some View {
        content
            .padding()
            .background(Color.white.opacity(opacity))
            .cornerRadius(18)
            .shadow(color: Color.black.opacity(0.08), radius: 5, x: 0, y: 2)
    }
}

extension View {
    func cardStyle(opacity: Double = 0.6) -> some View {
        modifier(CardStyle(opacity: opacity))
    }
}

struct Theme {
    static let primary = Color(red: 0.85, green: 0.65, blue: 0.1)
    static let secondary = Color(red: 0.7, green: 0.5, blue: 0.05)
    static let accent = Color(red: 0.95, green: 0.75, blue: 0.2)
    static let hive = Color(red: 0.55, green: 0.35, blue: 0.15)
    static let honey = Color(red: 0.9, green: 0.7, blue: 0.15)
    static let backgroundTop = Color(red: 0.98, green: 0.96, blue: 0.9)
    static let backgroundBottom = Color(red: 0.95, green: 0.91, blue: 0.82)
    static let textPrimary = Color(red: 0.25, green: 0.18, blue: 0.08)
    static let textSecondary = Color(red: 0.5, green: 0.4, blue: 0.25)
    static let success = Color(red: 0.3, green: 0.7, blue: 0.3)
    static let warning = Color(red: 0.95, green: 0.7, blue: 0.1)
    static let danger = Color(red: 0.85, green: 0.25, blue: 0.2)
    static var backgroundGradient: LinearGradient {
        LinearGradient(colors: [backgroundTop, backgroundBottom], startPoint: .top, endPoint: .bottom)
    }
    static var primaryGradient: LinearGradient {
        LinearGradient(colors: [primary, secondary], startPoint: .topLeading, endPoint: .bottomTrailing)
    }
    static var honeyGradient: LinearGradient {
        LinearGradient(colors: [accent, Color(red: 0.85, green: 0.6, blue: 0.05)], startPoint: .top, endPoint: .bottom)
    }
}
