import Fluent
import Vapor
import Redis

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
        guard let user = try await User.query(on: request.db).filter(\.$username == basic.username).first() else {
            throw Abort(.notFound)
        }

        let ok =
            try await request.password.async.verify(basic.password, created: user.password)

        if !ok {
            throw Abort(.unauthorized)
        }

        try await request.createNewSessionFor(user: user)
        request.auth.login(user)
    }
}

struct UserSessionAuthenticator: AsyncSessionAuthenticator {
    typealias User = App.User

    func authenticate(sessionID: String, for request: Request) async throws {
        let key: RedisKey = "sessions/\(sessionID)"
        let id = try await request.redis.get(key, asJSON: UUID.self)

        if let id = id {
            guard let user = try await User.query(on: request.db).filter(\.$id == id).first() else {
                throw Abort(.unauthorized)
            }
            user.sessionID = sessionID

            request.auth.login(user)
        }
    }
}

extension Request {
    func createNewSessionFor(user: User) async throws {
        user.sessionID = randomString(length: 30)
        let key: RedisKey = "sessions/\(user.sessionID)"

        try await self.redis.set(key, toJSON: user.id)
        try await self.redis.expire(key, after: .hours(24 * 7)).get()
    }
}