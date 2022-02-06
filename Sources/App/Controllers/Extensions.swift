import Vapor

extension Application {
    func register(collection: AppRouteCollection) throws {
        try collection.boot(with: self)
    }
}

protocol AppRouteCollection {
    func boot(with: Application) throws
}
