import Foundation
import Dispatch
import Signals
import Swifter
import ArgumentParser

class HolaServer {

    var port: UInt16
    let bonjour: NetService!
    let server = HttpServer()
    let semaphore = DispatchSemaphore(value: 0)

    init(_ port: UInt16) {
        self.port = port
        bonjour = NetService(domain: "local.", type: "_http._tcp.", name: "Local Service", port: Int32(port))
        let service = "/service"
        let files = "/files/:path"
        let sources = "https://github.com/rhwood/hola-server"
        bonjour.setTXTRecord(NetService.data(fromTXTRecord: ["path": service.data(using: .utf8)!]))
        server[service] = scopes {
            html {
                head {
                    meta { charset = "UTF-8" }
                    element("meta",
                            ["viewport": "width=device-width, initial-scale=1.0, user-scalable=yes"], {}
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
                        inner = "Source code at <a href=\"\(sources)\">\(sources)</a>."
                    }
                }
            }
        }
        server[files] = directoryBrowser("/")
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

struct Main: ParsableCommand {

    @Argument
    var port = 9090

    mutating func run() throws {
        server = HolaServer(UInt16(port))
        server.start()
    }
}

var server: HolaServer

Signals.trap(signal: .int) { signal in
    server.stop()
    Signals.restore(signal: .int)
    Signals.raise(signal: .int)
}

Signals.trap(signal: .kill) { signal in
    server.stop()
    Signals.restore(signal: .kill)
    Signals.raise(signal: .kill)
}

Main.main()
