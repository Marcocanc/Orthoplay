//
//  ReactiveWebSocket.swift
//  Orthoplay
//
//  Created by Marco Cancellieri on 21.01.18.
//  Copyright © 2018 Marco Cancellieri. All rights reserved.
//

import Foundation
import Starscream
import ReactiveSwift
import Result

let orthoplayScheduler = QueueScheduler(name: "sh.marco.orthoplayqueue", targeting: .global())

/// A Reactive Wrapper for WebSocket
final internal class ReactiveWebSocket {
    private let socket: WebSocket
    /// The "connect" message, flagging that the websocket did connect to the server.
    public var connectSignal: Signal<Void, NoError>
    /// A disconnect message that may contain an `Error` containing the reason for the disconection.
    public var disconnectSignal: Signal<Error?, NoError>
    /// Any data messages received by the client, excluding strings.
    public var dataSignal: Signal<Data, NoError>
    /// Any string messages received by the client.
    public var textSignal: Signal<String, NoError>
    /// The "pong" message the server may respond to a "ping".
    public var pongSignal: Signal<Data?, NoError>
    
    public init(request: URLRequest, protocols: [String]? = nil, stream: WSStream = FoundationStream()) {
        let (connectSignal, connectObserver) = Signal<(), NoError>.pipe()
        let (disconnectSignal, disconnectObserver) = Signal<Error?, NoError>.pipe()
        let (dataSignal, dataObserver) = Signal<Data, NoError>.pipe()
        let (textSignal, textObserver) = Signal<String, NoError>.pipe()
        let (pongSignal, pongObserver) = Signal<Data?, NoError>.pipe()
        
        self.connectSignal = connectSignal
        self.disconnectSignal = disconnectSignal
        self.dataSignal = dataSignal
        self.textSignal = textSignal
        self.pongSignal = pongSignal
        
        
        self.socket = WebSocket(request: request, protocols: protocols, stream: stream)
        self.socket.callbackQueue = orthoplayScheduler.queue
        self.socket.onConnect = { connectObserver.send(value: ()) }
        self.socket.onDisconnect = { disconnectObserver.send(value: $0) }
        self.socket.onText = { textObserver.send(value: $0) }
        self.socket.onData = { dataObserver.send(value: $0) }
        self.socket.onPong = { pongObserver.send(value: $0) }
    }
    
    public convenience init(url: URL, protocols: [String]? = nil) {
        var request = URLRequest(url: url)
        request.timeoutInterval = 5
        self.init(request: request, protocols: protocols)
    }
    
    public func connect() {
        socket.connect()
    }
    
    public func disconnect(forceTimeout: TimeInterval? = nil, closeCode: UInt16 = CloseCode.normal.rawValue) {
        socket.disconnect(forceTimeout: forceTimeout, closeCode: closeCode)
    }
    
    func write(string: String, completion: (() -> ())? = nil) {
        socket.write(string: string, completion: completion)
    }
    
    var isConnected: Bool {
        return socket.isConnected
    }
    
}
