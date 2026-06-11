import Foundation

struct GitHubRepository: Codable, Identifiable, Hashable {
    var id: String { url }
    let url: String

    var displayName: String {
        guard let components = URL(string: url)?.pathComponents.filter({ $0 != "/" }),
              components.count >= 2 else {
            return url
        }
        return "\(components[components.count - 2])/\(components[components.count - 1])"
    }
}

struct RepositoryListResponse: Codable {
    let items: [GitHubRepository]
}

struct CursorModel: Codable, Identifiable, Hashable {
    let id: String
    let displayName: String
    let description: String?
    let aliases: [String]?
}

struct ModelListResponse: Codable {
    let items: [CursorModel]
}

struct APIKeyInfo: Codable {
    let apiKeyName: String
    let createdAt: Date
    let userId: Int?
    let userEmail: String?
    let userFirstName: String?
    let userLastName: String?

    var displayName: String {
        if let first = userFirstName, let last = userLastName {
            return "\(first) \(last)"
        }
        return userEmail ?? apiKeyName
    }
}
