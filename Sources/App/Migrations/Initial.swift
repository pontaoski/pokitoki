import Fluent

struct Initial: AsyncMigration {
    func revert(on database: Database) async throws {
        try await database.schema(DatabasePOFile.schema).delete()
        try await database.schema(Project.schema).delete()
        try await database.schema(User.schema).delete()
    }

    func prepare(on database: Database) async throws {
        try await database.schema(User.schema)
            .id()
            .field("created_at", .datetime)
            .field("updated_at", .datetime)
            .field("deleted_at", .datetime)
            .field("username", .string, .required)
            .unique(on: "username")
            .field("password", .string, .required)
            .create()

        try await database.schema(Project.schema)
            .id()
            .field("created_at", .datetime)
            .field("updated_at", .datetime)
            .field("deleted_at", .datetime)
            .field("owner_id", .uuid, .required, .references(User.schema, "id"))
            .field("name", .string, .required)
            .field("slug", .string, .required)
            .field("languages", .json, .required)
            .create()

        try await database.schema(DatabasePOFile.schema)
            .id()
            .field("created_at", .datetime)
            .field("updated_at", .datetime)
            .field("deleted_at", .datetime)
            .field("project_id", .uuid, .required, .references(Project.schema, "id"))
            .field("name", .string, .required)
            .field("header", .dictionary(of: .string), .required)
            .field("languageSpecificHeaders", .dictionary(of: .dictionary(of: .string)), .required)
            .field("entries", .json, .required)
            .create()
    }
}
