import App
import Vapor
import MongoDBVapor

var env = try Environment.detect()
try LoggingSystem.bootstrap(from: &env)
let app = Application(env)
defer {
    app.shutdown()
}
try configure(app)
defer {
    app.mongoDB.cleanup()
    cleanupMongoSwift()
}
try app.run()
