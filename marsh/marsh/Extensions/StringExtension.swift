import Foundation

// MARK: - Localization

extension String {

    var localized: String {
        NSLocalizedString(self, comment: "")
    }
}
