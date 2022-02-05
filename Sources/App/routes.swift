import Fluent
import Vapor
import MongoDBVapor

func routes(_ app: Application) throws {
    try app.register(collection: IndexController())
    try app.register(collection: AuthController())
    try app.register(collection: ProjectController())
}
