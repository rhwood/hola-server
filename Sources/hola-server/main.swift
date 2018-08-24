import Foundation
import Dispatch
import Signals
import Swifter

class HolaServer {
    
    var port: UInt16
    let bonjour: NetService!
    let server = HttpServer()
    let semaphore = DispatchSemaphore(value: 0)
    
    init(_ port: UInt16) {
        self.port = port
        bonjour = NetService(domain: "local.", type: "_http._tcp.", name: "Local Service", port: Int32(port))
        bonjour.setTXTRecord(NetService.data(fromTXTRecord: ["path": "/service".data(using: .utf8)!]))
    }
    
    func start() {
        server["/service"] = scopes {
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
            try server.start(port, forceIPv4: true)
            print("Server has started ( port = \(try server.port()) ). Try to connect now...")
            bonjour.publish()
            semaphore.wait()
        } catch {
            print("Server start error: \(error)")
            semaphore.signal()
        }
    }
    
    func stop() {
        bonjour.stop()
        server.stop()
    }
}

let server = HolaServer(9090)

Signals.trap(signal: .int) { signal in
    server.stop()
    Signals.restore(signal: .int)
    Signals.raise(signal: .int)
}

server.start()
