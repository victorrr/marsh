import Foundation

extension String {

    var localized: String {
        NSLocalizedString(self, comment: "")
    }

    var cgFloat: CGFloat? {
        Double(self).map { CGFloat($0) }
    }
}
