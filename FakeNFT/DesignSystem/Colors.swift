import UIKit

extension UIColor {
    // Creates color from a hex string
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let alpha, red, green, blue: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (alpha, red, green, blue) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (alpha, red, green, blue) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (alpha, red, green, blue) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (alpha, red, green, blue) = (255, 0, 0, 0)
        }
        self.init(
            red: CGFloat(red) / 255,
            green: CGFloat(green) / 255,
            blue: CGFloat(blue) / 255,
            alpha: CGFloat(alpha) / 255
        )
    }

    // Primary Colors
    private static let primaryBlack = UIColor(hexString: "1A1B22")
    private static let primaryWhite = UIColor(hexString: "FFFFFF")

    // Secondary Colors
    private static let yaLightGrayDay = UIColor(hexString: "F7F7F8")
    private static let yaLightGrayNight = UIColor(hexString: "2C2C2E")
    static let yaBlue = UIColor(hexString: "0A84FF")
    static let yaGray = UIColor(hexString: "625C5C")
    static let yaRed = UIColor(hexString: "F56B6C")
    static let yaGreen = UIColor(hexString: "1C9F00")
    static let yaYellow = UIColor(hexString: "FEEF0D")
    static let yaBlack = primaryBlack
    static let yaWhite = primaryWhite

    // Background Colors
    static let background50: UIColor = primaryBlack.withAlphaComponent(0.5)

    static let placeholderBackground = UIColor { traits in
        return traits.userInterfaceStyle == .dark
        ? .yaLightGrayNight
        : .yaLightGrayDay
    }

    static let buttonBackground = UIColor { traits in
        return traits.userInterfaceStyle == .dark
        ? .primaryWhite
        : .primaryBlack
    }

    static let screenBackground = UIColor { traits in
        return traits.userInterfaceStyle == .dark
        ? .primaryBlack
        : .primaryWhite
    }

    // Text Colors
    static let textPrimary = UIColor { traits in
        return traits.userInterfaceStyle == .dark
        ? .primaryWhite
        : .primaryBlack
    }

    static let textPrimaryInvert = UIColor { traits in
        return traits.userInterfaceStyle == .dark
        ? .primaryBlack
        : .primaryWhite
    }

    // Tint colors
    static let segmentActive = UIColor { traits in
        return traits.userInterfaceStyle == .dark
        ? .primaryWhite
        : .primaryBlack
    }

    static let segmentInactive = UIColor { traits in
        return traits.userInterfaceStyle == .dark
        ? .yaLightGrayNight
        : .yaLightGrayDay
    }

    static let closeButton = UIColor { traits in
        return traits.userInterfaceStyle == .dark
        ? .primaryWhite
        : .primaryBlack
    }

    static let tabActive = yaBlue

    static let tabInactive = UIColor { traits in
        return traits.userInterfaceStyle == .dark
        ? .primaryWhite
        : .primaryBlack
    }

    // Border colors
    static let borderColor = UIColor { traits in
        return traits.userInterfaceStyle == .dark
        ? .primaryWhite
        : .primaryBlack
    }
}

