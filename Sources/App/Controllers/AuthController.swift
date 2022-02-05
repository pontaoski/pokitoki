import Fluent
import Vapor
import Redis

struct IndexController: AppRouteCollection {
    func boot(with: Application) throws {
        with.get(use: index)
    }

    func index(req: Request) async throws -> View {
        return try await req.view.render("index", NoData())
    } 
}

struct AuthController: AppRouteCollection {
    func boot(with: Application) throws {
        let auths = with.grouped("auth")

        auths.get("register", use: register)
        auths.post("register", use: registerPost)

        auths.get("login", use: login)
        auths.post("login", use: loginPost)
    }

    struct RegisterForm: Codable {
        var username: String
        var password: String
    }
    func registerPost(req: Request) async throws -> Response {
        let form = try req.content.decode(RegisterForm.self)

        let newUser = DatabaseUser(
            _id: nil,
            username: form.username,
            password: try await req.password.async.hash(form.password)
        )

        guard let id = try await req.userCollection.insertOne(newUser) else {
            throw Abort(.internalServerError)
        }

        try await req.createNewSessionFor(userID: id.insertedID.objectIDValue!)

        return req.redirect(to: "/")
    }

    func register(req: Request) async throws -> View {
        return try await req.view.render("register", NoData())
    }

    struct LoginForm: Codable {
        var username: String
        var password: String
    }
    func loginPost(req: Request) async throws -> Response {
        let form = try req.content.decode(LoginForm.self)
        guard let user = try await req.userCollection.findOne(["username": .string(form.username)]) else {
            throw Abort(.notFound)
        }

        let ok = try await req.password.async.verify(form.password, created: user.password)
        if !ok {
            throw Abort(.unauthorized)
        }

        try await req.createNewSessionFor(userID: user._id!)

        return req.redirect(to: "/")
    }

    func login(req: Request) async throws -> View {
        return try await req.view.render("login", NoData())
    }
}
