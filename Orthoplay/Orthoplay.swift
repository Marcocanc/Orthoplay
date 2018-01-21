//
//  Orthoplay.swift
//  Orthoplay
//
//  Created by Marco Cancellieri on 21.01.18.
//  Copyright © 2018 Marco Cancellieri. All rights reserved.
//

import Foundation
import ReactiveSwift
import Result

public class Orthoplay {
    let socket: ReactiveWebSocket
    
    init(url: URL) {
        self.socket = ReactiveWebSocket(url: url)
        let messageSignal = socket.textSignal.mapTo(Message.self)
    }
    
    func sendAction(action: Action) {
        guard let jsonString = action.jsonString else { return }
        socket.write(string: jsonString)
    }
    
}



extension Signal where Value == String, Error == NoError {
    func mapTo<T: Decodable>(_ objType: T.Type) -> Signal<T, Error> {
        return filterMap { T($0) }
    }
}

extension Decodable {
    init?(_ jsonString: String) {
        let decoder = JSONDecoder()
        guard let data = jsonString.data(using: .utf8),
            let out = try? decoder.decode(Self.self, from: data)
            else { return nil }
        self = out
    }
}
