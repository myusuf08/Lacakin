//
//  MQTTManager.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 25/04/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//


import Foundation
import CocoaMQTT

class MQTTManager: NSObject {
    var mqtt: CocoaMQTT?
    let defaultHost = "mq.lacakin.id"
    // live tcp://mq.lacakin.id:6768
    // dev "demo.pickpoint.me"
    static var shared = MQTTManager()
    var isLoadingConnect: Bool?
    var isConnect: Bool?
    var isNotificationConnect: Bool?
    
    override init() {
        
    }

    func connect() {
        establishConnection()
    }

    func subscribeTopicOne(topic: String) {
        mqtt?.subscribe(topic, qos: .qos0)
    }
    
    func subscribeTopicTwo(topic: String) {
        mqtt?.subscribe(topic, qos: .qos1)
    }
    
    func subscribeTopicThree(topic: String) {
        mqtt?.subscribe(topic, qos: .qos2)
    }
    
    func publishMessage(message: CocoaMQTTMessage) {
        mqtt?.publish(message)
    }

}

extension MQTTManager {
    func establishConnection() {
        let clientID = "lacakin_\(User.shared.profile?.username ?? "")"
        mqtt = CocoaMQTT(clientID: clientID, host: defaultHost, port: 6768)
        mqtt!.username = User.shared.profile?.userId ?? ""
        mqtt!.password = User.shared.profile?.token ?? ""
        mqtt!.keepAlive = 60
        mqtt!.delegate = self
        mqtt!.connect()
        
    }

    func TRACE(_ message: String = "", fun: String = #function) {
        let names = fun.components(separatedBy: ":")
        var prettyName: String
        if names.count == 1 {
            prettyName = names[0]
        } else {
            prettyName = names[1]
        }

        if fun == "mqttDidDisconnect(_:withError:)" {
            prettyName = "didDisconect"
        }

        print("[TRACE] [\(prettyName)]: \(message)")
    }
}


extension MQTTManager: CocoaMQTTDelegate {
    // Optional ssl CocoaMQTTDelegate
    func mqtt(_ mqtt: CocoaMQTT, didReceive trust: SecTrust, completionHandler: @escaping (Bool) -> Void) {
        TRACE("trust: \(trust)")
        completionHandler(true)
    }

    func mqtt(_ mqtt: CocoaMQTT, didConnectAck ack: CocoaMQTTConnAck) {
        TRACE("ack: \(ack)")
        if ack == .accept {
            self.isConnect = true
        }
        
    }

    func mqtt(_ mqtt: CocoaMQTT, didStateChangeTo state: CocoaMQTTConnState) {
        TRACE("new state: \(state)")
        if state == .disconnected {
            mqtt.connect()
        }
    }

    func mqtt(_ mqtt: CocoaMQTT, didPublishMessage message: CocoaMQTTMessage, id: UInt16) {
        TRACE("message: \(message.string?.description ?? ""), id: \(id)")
    }

    func mqtt(_ mqtt: CocoaMQTT, didPublishAck id: UInt16) {
        TRACE("id: \(id)")
    }

    func mqtt(_ mqtt: CocoaMQTT, didReceiveMessage message: CocoaMQTTMessage, id: UInt16 ) {
        TRACE("message: \(message.string ?? ""), id: \(id)")
    }

    func mqtt(_ mqtt: CocoaMQTT, didSubscribeTopic topic: String) {
        TRACE("topic: \(topic)")
    }

    func mqtt(_ mqtt: CocoaMQTT, didUnsubscribeTopic topic: String) {
        TRACE("topic: \(topic)")
    }

    func mqttDidPing(_ mqtt: CocoaMQTT) {
        TRACE()
    }

    func mqttDidReceivePong(_ mqtt: CocoaMQTT) {
        TRACE()
    }

    func mqttDidDisconnect(_ mqtt: CocoaMQTT, withError err: Error?) {
        TRACE("\(err?.localizedDescription ?? "")")
        MQTTManager.shared.isLoadingConnect = false
    }
}
