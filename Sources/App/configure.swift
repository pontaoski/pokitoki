import Redis
import MongoDBVapor
import Leaf
import Vapor
import Foundation

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

    // cors middleware should come before default error middleware using `at: .beginning`
    app.middleware.use(cors, at: .beginning)
    app.middleware.use(app.sessions.middleware)
    app.middleware.use(UserSessionAuthenticator())
    app.middleware.use(UserBasicAuthenticator())

    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    try app.mongoDB.configure("mongodb://localhost:27017")
    app.redis.configuration = try RedisConfiguration(hostname: "localhost")

    app.views.use(.wrappedLeaf)
    app.commands.use(MigrateCommand(), as: "mongo-migrate")

    // register routes
    try routes(app)
}
