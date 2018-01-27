//
//  Orthoplay.swift
//  Orthoplay
//
//  Created by Marco Cancellieri on 21.01.18.
//  Copyright © 2018 Marco Cancellieri. All rights reserved.
//

import Foundation
import Starscream

public class Orthoplay: WebSocketDelegate {
    static let protocolVersion = (major: 0, minor: 4)
    let socket: WebSocket
    let uid: String
    let name: String
    let isRealtime: Bool
    
    var pingTimer: Timer?
    
    init(url: URL, name: String = "guest", realtime: Bool = false) {
        self.socket = WebSocket(url: url)
        self.name = name
        self.isRealtime = realtime
        self.uid = UUID().uuidString
        socket.delegate = self
    }
    
    @objc
    private func sendPing() {
        let time = Int((Date().timeIntervalSince1970).truncatingRemainder(dividingBy: 1000) * 1000)
        let pingAction = Actions.SpeakerPing(value: time)
        sendAction(action: pingAction)
    }
    
    // MARK: WebSocket Delegate
    public func websocketDidConnect(socket: WebSocketClient) {
        print("connected")
        self.pingTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(sendPing), userInfo: nil, repeats: true)
        let version = Orthoplay.protocolVersion
        sendAction(action: Actions.GlobalJoin(protocolMajorVersion: version.major, protocolMinorVersion: version.minor))
    }
    
    public func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        // Orthoplay communication doesn't seem to use binary messages
        return
    }
    
    public func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        print("disconnect")
        pingTimer?.invalidate()
    }
    
    public func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        if let message = Message(text) {
            self.processMessage(message)
        }
    }
    // MARK: Sending messages
    func sendAction(action: Action) {
        guard let jsonString = action.jsonString else { return }
        socket.write(string: jsonString)
    }
    
    // MARK: Message processing
    func processMessage(_ msg: Message) {
        switch msg {
        case .update(let update):
            handleUpdate(update)
        case .response(let response):
            handleResponse(response)
        }
    }
    
    private func handleResponse(_ response: Response) {
        
        switch response {
        case .globalJoined(let resp):
            self.palette = resp.palette
            self.services = resp.services
            resp.state.forEach(handleUpdate(_:))
            let action = Actions.GroupJoin(colorIndex: 0, name: self.name, realtimeData: self.isRealtime, uid: self.uid)
            sendAction(action: action)
        case .groupJoined(let resp):
            self.currentGroup = self.groups.first(where: {$0.id == resp.groupId })
            resp.state.forEach(handleUpdate(_:))
            self.sources = resp.sources
            self.sid = resp.sid
        case .playlistTracks(let playlistChange):
            // TODO: Implement partial playlist responses
            break
        case .speakerPong(let pong):
            // TODO: Maybe measure and store latency
            break
        default:
            break
        }
    }
    
    private func handleUpdate(_ update: Update) {
        switch update {
        case .speakerGroup(let group):
            self.groups.insert(group)
        case .groupVolumeChanged(let volChange):
            self.groupVolume = volChange.volume
        case .speakerAdded(let speaker):
            self.speakers.insert(speaker.speaker)
        case .playbackStateChanged(let stateChange):
            self.playing = stateChange.playing
        case .realtime(let rt):
            self.realtimeData = rt
        case .trackChanged(let track):
            self.currentTrack = track.track
        case .groupInputSourceChanged(let sourceUpdate):
            self.source = sources.first { $0.id == sourceUpdate.source }
        default:
            break
        }
    }
    // MARK: Client state
    public private(set) var sid: Int?
    public private(set) var palette: Palette?
    public private(set) var currentGroup: Group?
    public private(set) var playing: Bool = false
    public private(set) var currentTrack: Track?
    public private(set) var groups: Set<Group> = []
    public private(set) var clients: Set<Client> = []
    public private(set) var services: Set<Service> = []
    public private(set) var speakers: Set<Speaker> = []
    public private(set) var sources: [Source] = []
    public private(set) var source: Source?
    public private(set) var groupVolume: Int = 0
    public private(set) var realtimeData: Updates.Realtime?
    public private(set) var playlistTracks: [Track] = []
    
}




extension Decodable {
    init?(_ jsonString: String) {
        let decoder = JSONDecoder()
        guard let data = jsonString.data(using: .utf8) else { return nil }
        do {
            let out = try decoder.decode(Self.self, from: data)
            self = out
        } catch (let error) {
            print(error)
            return nil
        }
        
    }
}
