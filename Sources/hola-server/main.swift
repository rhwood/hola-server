import Foundation
import Signals
import ArgumentParser

struct Main: ParsableCommand {

    @Argument
    var port = 9090

    mutating func run() throws {
        server = HolaServer(UInt16(port))
        server.start()
    }
}

var server: HolaServer

Signals.trap(signals: [.int, .kill]) { signal in
    server.stop()
    Signals.restore(signal: .user(Int(signal)))
    Signals.raise(signal: .user(Int(signal)))
}

Main.main()
