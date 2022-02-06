import Fluent
import Vapor
import MongoDBVapor

struct ProjectController: AppRouteCollection {
    func boot(with: Application) throws {
        with.group(User.guardMiddleware()) {
            $0.get("projects", use: myProjects)
            $0.post("projects", use: createProjectPost)
            $0.get("create-project", use: createProject)
        }
        with.get(["projects-of", ":ofuser"], use: projects)
        with.get(["projects", ":slug"], use: project)
    }

    struct ProjectsData: Codable {
        let ownerID: BSONObjectID
        let ownerName: String
        let projects: [DatabaseProject]
    }

    func myProjects(req: Request) async throws -> Response {
        let user: User = req.auth.get()!

        return req.redirect(to: "/projects-of/\(user.username)")
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

    func createProject(req: Request) async throws -> View {
        return try await req.view.render("create-project", NoData())
    }

    struct CreateProjectData: Codable {
        let projectName: String
    }
    func createProjectPost(req: Request) async throws -> Response {
        let user: User = req.auth.get()!
        let form = try req.content.decode(CreateProjectData.self)
        guard let slugged = form.projectName.slugged else {
            throw Abort(.badRequest)
        }

        let slug = slugged + "-" + randomString(length: 4)
        
        try await req.projectCollection.insertOne(DatabaseProject(
            _id: nil,
            owner: user.userID,
            name: form.projectName,
            slug: slug,
            languages: [],
            files: []
        ))

        return req.redirect(to: "/projects/\(slug)")
    }
    func project(req: Request) async throws -> View {
        let project =
            try await req.projectCollection.getBy(slug: req.parameters.get("slug")!)

        return try await req.view.render("project-homepage", project)
    }
}
