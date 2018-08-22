import Foundation
import Dispatch
import Swifter

class HolaServer {
    
    var service: NetService!
    let server = HttpServer()
    let semaphore = DispatchSemaphore(value: 0)
    
    func start() {
        server["/"] = scopes {
            html {
                head {
                    meta { charset = "UTF-8" }
                }
                body {
                    h1 {
                        style = "text-align: center";
                        inner = "¡Hola!"
                    }
                }
            }
        }
        server["/files/:path"] = directoryBrowser("/")
        do {
            try server.start(9080, forceIPv4: true)
            print("Server has started ( port = \(try server.port()) ). Try to connect now...")
            semaphore.wait()
        } catch {
            print("Server start error: \(error)")
            semaphore.signal()
        }
    }
    
    func stop() {
        server.stop()
    }
}

HolaServer().start()
