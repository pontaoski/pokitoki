import Fluent
import Vapor
import MongoDBVapor

struct ProjectController: AppRouteCollection {
    func boot(with: Application) throws {
        with.group(User.guardMiddleware()) {
            $0.get("projects", use: myProjects)
            $0.put("projects", use: createProject)
        }
        with.get(["projects", ":ofuser"], use: projects)
    }

    struct ProjectsData: Codable {
        let ownerID: BSONObjectID
        let ownerName: String
        let projects: [DatabaseProject]
    }

    func myProjects(req: Request) async throws -> Response {
        let user: User = req.auth.get()!

        return req.redirect(to: "/projects/\(user.username)")
    }
    func projects(req: Request) async throws -> View {
        let user = try await req.userCollection.getBy(username: req.parameters.get("ofuser")!)
        let projects = try await req.projectCollection.getOwnedBy(user)

        return try await req.view.render("projects", ProjectsData(
            ownerID: user._id!,
            ownerName: user.username,
            projects: projects
        ))
    }
    func createProject(req: Request) async throws -> Response {
        throw Abort(.notImplemented)
    }
}
