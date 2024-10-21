// swiftlint:disable all

import Foundation

// MARK: - Strings

internal enum AppStrings {
  internal static let errorsServerError = AppStrings.tr("Localizable", "errors_server_error")
  internal static let mainTitle = AppStrings.tr("Localizable", "main_title")
}

// MARK: - Implementation Details

extension AppStrings {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = Bundle.main.localizedString(forKey: key, value: nil, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

