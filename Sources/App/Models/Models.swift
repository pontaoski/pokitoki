import Fluent
import Vapor

final class User: Model, Authenticatable, SessionAuthenticatable, Codable {
    static let schema = "users"

    @ID(key: .id)
    var id: UUID?

    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?

    @Timestamp(key: "updated_at", on: .update)
    var updatedAt: Date?

    @Timestamp(key: "deleted_at", on: .delete)
    var deletedAt: Date?

    @Field(key: "username")
    var username: String

    @Field(key: "password")
    var password: String

    @Children(for: \.$owner)
    var projects: [Project]

    var sessionID: String = ""

    init() { }

    init(id: UUID? = nil, username: String, password: String) {
        self.id = id
        self.username = username
        self.password = password
    }
}

struct Language: Codable {
    var name: String
    var code: String
    var pluralForms: PluralForms
    var textDirection: TextDirection
}

enum TextDirection: Codable {
    case LeftToRight, RightToLeft
}

enum PluralForms: Codable {
    case OneOther,
         OneTwoOther,
         OneFewOther,
         OneFewManyOther,
         OneTwoFewOther,
         OneTwoFewManyOther,
         ZeroOneOther,
         ZeroOneTwoFewManyOther,
         Other
}

final class Project: Model, Codable {
    static let schema = "projects"

    @ID(key: .id)
    var id: UUID?

    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?

    @Timestamp(key: "updated_at", on: .update)
    var updatedAt: Date?

    @Timestamp(key: "deleted_at", on: .delete)
    var deletedAt: Date?

    @Parent(key: "owner_id")
    var owner: User

    @Field(key: "name")
    var name: String

    @Field(key: "slug")
    var slug: String

    @Field(key: "languages")
    var languages: [Language]

    @Children(for: \.$project)
    var files: [DatabasePOFile]

    init() { }

    init(id: UUID? = nil, owner: User.IDValue, name: String, slug: String, languages: [Language]) {
        self.id = id
        self.$owner.id = owner
        self.name = name
        self.slug = slug
        self.languages = languages
    }
}

final class DatabasePOFile: Model, Codable {
    static let schema = "pofiles"

    @ID(key: .id)
    var id: UUID?

    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?

    @Timestamp(key: "updated_at", on: .update)
    var updatedAt: Date?

    @Timestamp(key: "deleted_at", on: .delete)
    var deletedAt: Date?

    @Parent(key: "project_id")
    var project: Project

    @Field(key: "name")
    var name: String

    @Field(key: "header")
    var header: [String: String]

    @Field(key: "languageSpecificHeaders")
    var languageSpecificHeaders: [String: [String: String]]

    @Field(key: "entries")
    var entries: [DatabasePOEntry]

    init() { }

    init(id: UUID? = nil, name: String, header: [String: String], languageSpecificHeaders: [String: [String: String]], entries: [DatabasePOEntry]) {
        self.id = id
        self.name = name
        self.header = header
        self.languageSpecificHeaders = languageSpecificHeaders
        self.entries = entries
    }
}

struct DatabasePOEntry: Codable {
    var translatorComments: [String]
    var codeComments: [String]
    var references: [String]
    var flags: [String]
    var messageContext: String?
    var messageID: String
    var pluralMessageID: String?
    var translations: [String: TranslationKind]
    var proposedTranslations: [String: [DatabaseProposedTranslation]]
}

struct DatabaseProposedTranslation: Codable {
    var translation: TranslationKind
    var fromUser: UUID
}
