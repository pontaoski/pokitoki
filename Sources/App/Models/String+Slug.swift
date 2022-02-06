import Foundation

extension String {
    private static let slugSafeCharacters = CharacterSet(charactersIn: "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz-")

    public var slugged: String? {
        get {
            guard let data = self.data(using: .ascii, allowLossyConversion: true) else {
                return nil
            }
            guard let str = String(data: data, encoding: .ascii) else {
                return nil
            }

            return str.lowercased()
               .components(separatedBy: String.slugSafeCharacters.inverted)
               .filter { $0 != "" }
               .joined(separator: "-")
        }
    }
}
