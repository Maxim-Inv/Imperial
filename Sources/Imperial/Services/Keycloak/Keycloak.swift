import Vapor

public class Keycloak: FederatedService {
    public var tokens: FederatedServiceTokens
    public var router: FederatedServiceRouter
    
    @discardableResult
    public required init(
        router: Routes,
        authenticate: String,
        authenticateCallback: ((Request) throws -> (EventLoopFuture<Void>))?,
        callback: String,
        scope: [String] = [],
        completion: @escaping (Request, String) throws -> (EventLoopFuture<ResponseEncodable>)
    ) throws {
        self.router = try KeycloakRouter(callback: callback, completion: completion)
        self.tokens = self.router.tokens
        
        self.router.scope = scope
        try self.router.configureRoutes(withAuthURL: authenticate, authenticateCallback: authenticateCallback, on: router)
        
        OAuthService.register(.keycloak)
    }
}