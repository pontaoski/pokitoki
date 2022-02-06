import Redis
import Leaf
import Vapor
import Foundation
import FluentSQLiteDriver

extension Application.Views.Provider {
    public static var wrappedLeaf: Self {
        .init {
            $0.views.use {
                WrappedRenderer(inner: $0.leaf.renderer)
            }
        }
    }
}

// configures your application
public func configure(_ app: Application) throws {
    let corsConfiguration = CORSMiddleware.Configuration(
        allowedOrigin: .all,
        allowedMethods: [.GET, .POST, .PUT, .OPTIONS, .DELETE, .PATCH],
        allowedHeaders: [.accept, .authorization, .contentType, .origin, .xRequestedWith, .userAgent, .accessControlAllowOrigin]
    )

    let cors = CORSMiddleware(configuration: corsConfiguration)
    app.sessions.use(.redis)

    app.migrations.add(Initial())
    app.databases.use(.sqlite(.file("db.sqlite")), as: .sqlite)

    // cors middleware should come before default error middleware using `at: .beginning`
    app.middleware.use(cors, at: .beginning)
    app.middleware.use(app.sessions.middleware)
    app.middleware.use(UserSessionAuthenticator())
    app.middleware.use(UserBasicAuthenticator())
    app.redis.configuration = try RedisConfiguration(hostname: "localhost")

    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    app.views.use(.wrappedLeaf)

    // register routes
    try routes(app)
}
