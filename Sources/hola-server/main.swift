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
        server["/service"] = scopes {
            html {
                head {
                    meta { charset = "UTF-8" }
                    element("meta",
                            ["viewport": "width=device-width, initial-scale=1.0, user-scalable=yes"],
                            {}
                    )
                }
                body {
                    style = "background: #408000; color: #FFFFFF"
                    h1 {
                        inner = "¡Hola!"
                    }
                    p {
                        inner = "Hola Browser discovers running HTTP services ."
                    }
                    p {
                        inner = "Source code at <a href=\"https://github.com/rhwood/hola-server\">https://github.com/rhwood/hola-server</a>."
                    }
                }
            }
        }
        server["/files/:path"] = directoryBrowser("/")
    }
    
    func start() {
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
