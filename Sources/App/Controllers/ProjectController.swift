import Fluent
import Vapor

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
        let user: User
        let projects: [Project]
    }

    func myProjects(req: Request) async throws -> Response {
        let user: User = try req.auth.require()

        return req.redirect(to: "/projects-of/\(user.username)")
    }
    func projects(req: Request) async throws -> View {
        guard let user = try await User.query(on: req.db).with(\.$projects).filter(\.$username == req.parameters.get("ofuser")!).first() else {
            throw Abort(.notFound)
        }

        return try await req.view.render("projects", ProjectsData(
            user: user,
            projects: user.projects
        ))
    }

    func createProject(req: Request) async throws -> View {
        return try await req.view.render("create-project", NoData())
    }

    struct CreateProjectData: Codable {
        let projectName: String
    }
    func createProjectPost(req: Request) async throws -> Response {
        let user: User = try req.auth.require()
        let form = try req.content.decode(CreateProjectData.self)
        guard let slugged = form.projectName.slugged else {
            throw Abort(.badRequest)
        }

        let slug = slugged + "-" + randomString(length: 4)

        try await Project(
            id: nil,
            owner: user.id!,
            name: form.projectName,
            slug: slug,
            languages: []
        ).save(on: req.db)

        return req.redirect(to: "/projects/\(slug)")
    }
    func project(req: Request) async throws -> View {
        guard let project =
            try await Project.query(on: req.db).filter(\.$slug == req.parameters.get("slug")!).first() else {
            throw Abort(.notFound)
        }

        return try await req.view.render("project-homepage", project)
    }
}
