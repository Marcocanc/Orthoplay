//
//  Orthoplay.swift
//  Orthoplay
//
//  Created by Marco Cancellieri on 21.01.18.
//  Copyright © 2018 Marco Cancellieri. All rights reserved.
//

import Foundation
import Result
import Starscream

public class Orthoplay: WebSocketDelegate {
    let socket: WebSocket
    private let uid: String
    let name: String
    let isRealtime: Bool
    
    init(url: URL, name: String = "guest", realtime: Bool = false) {
        self.socket = WebSocket(url: url)
        self.name = name
        self.isRealtime = realtime
        self.uid = UUID().uuidString
        socket.delegate = self
        
    }
    
    
    public func websocketDidConnect(socket: WebSocketClient) {
        print("connected")
        sendAction(action: Actions.GlobalJoin(protocolMajorVersion: 0, protocolMinorVersion: 4))
    }
    
    public func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        print("recv data")
    }
    
    public func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        print("disconnect")
    }
    
    public func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        if let message = Message(text) {
            self.processMessage(message)
        }
    }
    
    func processMessage(_ msg: Message) {
        switch msg {
        case .update(let update):
            self.handleUpdate(update)
        case .response(let response):
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
//                self.playlistTracks = playlistTracks
                break
            default:
                break
            }
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
            print(stateChange.sid)
            if stateChange.sid == self.sid {
                self.playing = stateChange.playing
            }
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
    
    public private(set) var sid: Int?
    public private(set) var palette: Palette?
    public private(set) var currentGroup: Group?
    public private(set) var playing: Bool = false
    public private(set) var currentTrack: Track? {
        didSet {
            if let track = currentTrack {
                print("set new track \(track.title) by \(track.artist)")
            }
            
        }
    }
    public private(set) var groups: Set<Group> = []
    public private(set) var clients: Set<Client> = []
    public private(set) var services: Set<Service> = []
    public private(set) var speakers: Set<Speaker> = [] {
        didSet {
            print("speakers updated")
        }
    }
    
    public private(set) var sources: [Source] = []
    
    public var source: Source?
    
    public private(set) var groupVolume: Int = 0 {
        didSet {
            print("new group volume: \(groupVolume)")
        }
    }
    
    public private(set) var realtimeData: Updates.Realtime? {
        didSet {
            print("realtime")
        }
    }
    
    public private(set) var playlistTracks: [Track] = [] {
        didSet {
            print(playlistTracks)
        }
    }
    
    func sendAction(action: Action) {
        guard let jsonString = action.jsonString else { return }
        socket.write(string: jsonString)
    }
    
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
