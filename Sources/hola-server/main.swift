import Foundation
import Lifecycle
import ArgumentParser

struct Main: ParsableCommand {

    @Argument
    var port = 9090

    mutating func run() throws {
        let server = HolaServer(UInt16(port))
        let lifecycle = ServiceLifecycle()
        lifecycle.register(
            label: "HolaServer",
            start: .sync(server.start),
            shutdown: .sync(server.stop)
        )
        server.start()
    }
}

Main.main()
