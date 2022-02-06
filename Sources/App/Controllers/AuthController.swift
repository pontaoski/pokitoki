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

        let newUser = User(
            id: nil,
            username: form.username,
            password: try await req.password.async.hash(form.password)
        )
        try await newUser.save(on: req.db)

        try await req.createNewSessionFor(user: newUser)

        req.auth.login(newUser)

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
        
        guard let user = try await User.query(on: req.db).filter(\.$username == form.username).first() else {
            throw Abort(.notFound)
        }

        let ok = try await req.password.async.verify(form.password, created: user.password)
        if !ok {
            throw Abort(.unauthorized)
        }

        try await req.createNewSessionFor(user: user)

        req.auth.login(user)

        return req.redirect(to: "/")
    }

    func login(req: Request) async throws -> View {
        return try await req.view.render("login", NoData())
    }
}
