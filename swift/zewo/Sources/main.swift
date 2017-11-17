

import Foundation
import HTTP


func hasPrefix(_ prefix: String) -> (String) -> Bool {
    return { value in value.hasPrefix(prefix) }
}

let server = Server(header: "") { request in
    print(request)
    switch request.method {
    case .get:
        // GET '/' return status code 200 with empty body
        guard let path = request.uri.path else { return Response(status: .badRequest) }
        if (path == "/") { return Response(status: .ok) }
        if (path.hasPrefix("/user/")) {
            let i = path.index(path.startIndex, offsetBy: 6)
            print("\(path[i...])")
            return Response(status: .ok, body: "\(path[i...])")
        }
        return Response(status: .notFound)
    // GET '/user/:id' return status code 200 with the id
    case .post:
        // POST '/user' return status code 200 with empty body
        if let path = request.uri.path, path.hasPrefix("/user") {
            return Response(status: .ok)
        }
    default:
        break
    }
    return Response(status: .notFound)
}


try server.start(port: 3000)
