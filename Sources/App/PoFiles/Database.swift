import Foundation
import MongoDBVapor
import Vapor
import Redis

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
    var fromUser: BSONObjectID
}

struct DatabasePOFile: Codable {
    var header: [String: String]
    var languageSpecificHeaders: [String: [String: String]]
    var entries: [DatabasePOEntry]
}

struct DatabaseLanguage: Codable {
    var name: String
    var code: String
}

struct DatabaseProject: Codable {
    var owner: BSONObjectID
    var languages: [DatabaseLanguage]
    var files: [DatabasePOFile]
}

struct DatabaseUser: Codable {
    var _id: BSONObjectID?

    let username: String
    let password: String
}

struct User: Codable, Authenticatable, SessionAuthenticatable {
    var userID: BSONObjectID    
    var username: String
    var sessionID: String
}

func randomString(length: Int) -> String {
    let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    return String((0..<length).map{ _ in letters.randomElement()! })
}

struct UserBasicAuthenticator: AsyncBasicAuthenticator {
    typealias User = App.User

    func authenticate(
        basic: BasicAuthorization,
        for request: Request
    ) async throws {
        guard let user = try await request.userCollection.findOne(
            ["username": .string(basic.username)]
        ) else {
            throw Abort(.notFound)
        }

        let ok =
            try await request.password.async.verify(basic.password, created: user.password)

        if ok {
            try await request.createNewSessionFor(userID: user._id!)
        }
    }
}

struct UserSessionAuthenticator: AsyncSessionAuthenticator {
    typealias User = App.User

    func authenticate(sessionID: String, for request: Request) async throws {
        let key: RedisKey = "sessions/\(sessionID)"
        let id = try await request.redis.get(key, asJSON: BSONObjectID.self)

        if let id = id {
            _ = try await request.redis.expire(key, after: .hours(24 * 7)).get()
            guard let user = try await request.userCollection.findOne(["_id": .objectID(id)]) else {
                throw Abort(.unauthorized)
            }
            request.auth.login(User(userID: id, username: user.username, sessionID: sessionID))
        }
    }
}

extension Request {
    var userCollection: MongoCollection<DatabaseUser> {
        self.application.userCollection
    }
    var projectCollection: MongoCollection<DatabaseProject> {
        self.application.projectCollection
    }
    func createNewSessionFor(userID: BSONObjectID) async throws {
        let session = randomString(length: 20)

        let key: RedisKey = "sessions/\(session)"
        try await self.redis.set(key, toJSON: userID)
        _ = try await self.redis.expire(key, after: .hours(24 * 7)).get()
        guard let user = try await self.userCollection.findOne(["_id": .objectID(userID)]) else {
            throw Abort(.unauthorized)
        }

        self.auth.login(User(userID: userID, username: user.username, sessionID: session))
    }
}

extension MongoCollection where T == DatabaseProject {
    func getOwnedBy(_ user: User) async throws -> [DatabaseProject] {
        let cursor =
            try await self.find(["owner": .objectID(user.userID)]).get()
        
        return try await cursor.toArray()
    }
    func getOwnedBy(_ user: DatabaseUser) async throws -> [DatabaseProject] {
        let cursor =
            try await self.find(["owner": .objectID(user._id!)]).get()
        
        return try await cursor.toArray()
    }
}

extension MongoCollection where T == DatabaseUser {
    func getBy(username: String) async throws -> DatabaseUser {
        guard let user = try await self.findOne(["username": .string(username)]) else {
            throw Abort(.notFound)
        }
        return user
    }
}

extension Application {
    var userCollection: MongoCollection<DatabaseUser> {
        self.mongoDB.client.db("home").collection("users", withType: DatabaseUser.self)
    }
    var projectCollection: MongoCollection<DatabaseProject> {
        self.mongoDB.client.db("home").collection("projects", withType: DatabaseProject.self)
    }
}

extension Application {
    func register(collection: AppRouteCollection) throws {
        try collection.boot(with: self)
    }
}

protocol AppRouteCollection {
    func boot(with: Application) throws
}

struct MigrateCommand: Command {
    func run(using context: CommandContext, signature: Signature) throws {
        let index = try context.application.userCollection.createIndex(["username": 1], indexOptions: IndexOptions(unique: true)).wait()
        print("created", index)
    }

    var help: String {
        "migrates stuff"
    }

    struct Signature: CommandSignature { }
}

struct AppData: Codable {
    var user: User?

    internal init(from req: Request) async throws {
        self.user = req.auth.get()
    }
}

struct NoData: Codable { }

struct WrappedRenderer: ViewRenderer {
    let inner: ViewRenderer

    struct Wrapper: ViewRenderer {
        let inner: ViewRenderer
        let request: Request

        struct Merged<T>: Encodable where T: Encodable {
            var data: T
            var app: AppData
        }

        func `for`(_ request: Request) -> ViewRenderer {
            return self
        }

        func render<E>(_ name: String, _ context: E) -> EventLoopFuture<View> where E : Encodable {
            let promise = self.request.eventLoop.makePromise(of: View.self)
            promise.completeWithTask {
                let merged = Merged(
                    data: context,
                    app: try await AppData(from: self.request)
                )

                return try await self.inner.render(name, merged)
            }
            return promise.futureResult
        }
    }

    func `for`(_ request: Request) -> ViewRenderer {
        return Wrapper(inner: inner.for(request), request: request)
    }

    func render<E>(_ name: String, _ context: E) -> EventLoopFuture<View> where E : Encodable {
        return inner.render(name, context)
    }
}
