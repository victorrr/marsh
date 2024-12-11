import Foundation

// MARK: - Localizations

extension String {

    var localized: String {
        NSLocalizedString(self, comment: "")
    }
}
