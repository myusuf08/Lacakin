//
//  BaseViewController.swift
//  CIRCLMVVM
//
//  Created by Muhammad Yusuf on 02/11/18.
//  Copyright © 2018 Muhammad Yusuf. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import Realm
import RealmSwift
import NotificationView

class BaseViewController: UIViewController {
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    var greyView: UIView = UIView()
    
    enum CloseBehavior {
        case pop
        case dismiss
    }
    
    let realm = try! Realm()
    let disposeBag = DisposeBag()
    var closeBehavior: CloseBehavior = .pop
    var isNotificationOn = true
    var isTrackOn = false
    var codeAct = ""
    
    override func viewDidLoad() {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if MQTTManager.shared.isConnect == true {
            return
        }
        let userId = User.shared.profile?.userId ?? ""
        if userId != "" {
            if MQTTManager.shared.isLoadingConnect != true {
                MQTTManager.shared.isLoadingConnect = true
                MQTTManager.shared.connect()
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setNotificationMQTT()
    }
    
    func activityIndicatorBegin(_ enableTouchView: Bool = true) {
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        disableUserInteraction()
        
        greyView = UIView()
        greyView.frame = CGRect(x: self.view.frame.size.width/2 - 25, y: self.view.frame.size.height/2 - 25, width: 50, height: 50)
        greyView.backgroundColor = .black
        greyView.alpha = 0.5
        self.view.addSubview(greyView)
        self.view.isUserInteractionEnabled = enableTouchView
    }
    
    func activityIndicatorEnd() {
        self.activityIndicator.stopAnimating()
        enableUserInteraction()
        self.greyView.removeFromSuperview()
        self.view.isUserInteractionEnabled = true
    }
    
    func disableUserInteraction() {
        view.isUserInteractionEnabled = false
    }
    
    func enableUserInteraction() {
        view.isUserInteractionEnabled = true
    }
    
    func setNotificationMQTT() {
        if MQTTManager.shared.isConnect == true {
            let userId = User.shared.profile?.userId ?? ""
            if userId != "" {
                if MQTTManager.shared.isNotificationConnect != true {
                    subscribeNotification()
                    MQTTManager.shared.isNotificationConnect = true
                }
                receiveMessageNotif()
            }
        }
        
    }
    
    func receiveMessageNotif() {
        MQTTManager.shared.mqtt?.didReceiveMessage = { mqtt, message, id in
            print("Message received in topic \(message.topic) with payload \(message.string!)")
            let topic = "lacakin/notify/\(User.shared.profile?.userId ?? "")"
            if message.topic == topic {
                let string = message.string ?? ""
                let data = string.data(using: .utf8)!
                do {
                    let model = try JSONDecoder().decode(MTQQNotification.self, from: data)
                    let notificationView = NotificationView.default
                    notificationView.title = model.title ?? ""
                    notificationView.subtitle = model.text ?? ""
                    let imagesView = UIImageView()
                    let url = URL(string: model.icon ?? "")
                    imagesView.kf.setImage(with: url, placeholder: UIImage(named: "common_avatar"))
                    notificationView.image = imagesView.image
                    notificationView.show()
                    try! self.realm.write() {
                        let models = MTQQNotificationRealm()
                        models.type = model.type ?? ""
                        models.from = model.from ?? ""
                        models.sticky = model.sticky ?? false
                        models.title = model.title ?? ""
                        models.text = model.text ?? ""
                        models.actcode = model.actcode ?? ""
                        models.icon = model.icon ?? ""
                        models.userid = model.userid ?? ""
                        models.timestamp = model.timestamp ?? ""
                        models.channel = model.channel ?? 0
                        models.isRead = false
                        self.realm.add(models)
                    }
                    self.subscribeNotifDidSuccess()
                } catch let error as NSError {
                    print(error)
                    self.subscribeNotifDidFailed()
                }
            }
        }
    }
}

// MARK: Public

extension BaseViewController {
    func addBackButton(behavior: CloseBehavior = .pop) {
        closeBehavior = behavior
        addLeftBackButton(#selector(onCloseButtonClicked))
    }
    
    @objc func onCloseButtonClicked() {
        switch closeBehavior {
        case .pop: navigationController?.popViewController(animated: true)
        case .dismiss: dismiss(animated: true)
        }
    }
}


extension BaseViewController {
    
    @objc func subscribeNotifDidSuccess() {
        
    }
    
    @objc func subscribeNotifDidFailed() {
        
    }
    
    func subscribeNotification() {
        let topic = "lacakin/notify/\(User.shared.profile?.userId ?? "")"
        MQTTManager.shared.subscribeTopicOne(topic: topic)
    }
//
//    func establishConnection() {
//        let clientID = "lacakin_\(User.shared.profile?.username ?? "")"
//        mqtt = CocoaMQTT(clientID: clientID, host: defaultHost, port: 6768)
//        mqtt!.username = User.shared.profile?.userId ?? ""
//        mqtt!.password = User.shared.profile?.token ?? ""
//        mqtt!.keepAlive = 60
//        mqtt!.connect()
//    }
    
//    func TRACE(_ message: String = "", fun: String = #function) {
//        let names = fun.components(separatedBy: ":")
//        var prettyName: String
//        if names.count == 1 {
//            prettyName = names[0]
//        } else {
//            prettyName = names[1]
//        }
//
//        if fun == "mqttDidDisconnect(_:withError:)" {
//            prettyName = "didDisconect"
//        }
//
//        print("[TRACE] [\(prettyName)]: \(message)")
//    }
}

//
//extension BaseViewController: CocoaMQTTDelegate {
//    // Optional ssl CocoaMQTTDelegate
//    func mqtt(_ mqtt: CocoaMQTT, didReceive trust: SecTrust, completionHandler: @escaping (Bool) -> Void) {
//        TRACE("trust: \(trust)")
//        completionHandler(true)
//    }
//
//    func mqtt(_ mqtt: CocoaMQTT, didConnectAck ack: CocoaMQTTConnAck) {
//        TRACE("ack: \(ack)")
//        if isNotificationOn {
//            mqtt.subscribe("lacakin/notify/\(User.shared.profile?.userId ?? "")", qos: CocoaMQTTQOS.qos1)
//        }
//        if isTrackOn {
//            mqtt.subscribe("lacakin/track/\(codeAct)", qos: CocoaMQTTQOS.qos1)
//        }
//    }
//
//    func mqtt(_ mqtt: CocoaMQTT, didStateChangeTo state: CocoaMQTTConnState) {
//        TRACE("new state: \(state)")
//    }
//
//    func mqtt(_ mqtt: CocoaMQTT, didPublishMessage message: CocoaMQTTMessage, id: UInt16) {
//        TRACE("message: \(message.string?.description ?? ""), id: \(id)")
//    }
//
//    func mqtt(_ mqtt: CocoaMQTT, didPublishAck id: UInt16) {
//        TRACE("id: \(id)")
//    }
//
//    func mqtt(_ mqtt: CocoaMQTT, didReceiveMessage message: CocoaMQTTMessage, id: UInt16 ) {
//        TRACE("message: \(message.string ?? ""), id: \(id)")
//        if isNotificationOn {
//            let string = message.string ?? ""
//            let data = string.data(using: .utf8)!
//            do {
//                let model = try JSONDecoder().decode(MTQQNotification.self, from: data)
//                let notificationView = NotificationView.default
//                notificationView.title = model.title ?? ""
//                notificationView.subtitle = model.text ?? ""
//                let imagesView = UIImageView()
//                let url = URL(string: model.icon ?? "")
//                imagesView.kf.setImage(with: url, placeholder: UIImage(named: "common_avatar"))
//                notificationView.image = imagesView.image
//                notificationView.show()
//                try! realm.write() {
//                    let models = MTQQNotificationRealm()
//                    models.type = model.type ?? ""
//                    models.from = model.from ?? ""
//                    models.sticky = model.sticky ?? false
//                    models.title = model.title ?? ""
//                    models.text = model.text ?? ""
//                    models.actcode = model.actcode ?? ""
//                    models.icon = model.icon ?? ""
//                    models.userid = model.userid ?? ""
//                    models.timestamp = model.timestamp ?? ""
//                    models.channel = model.channel ?? 0
//                    models.isRead = false
//                    realm.add(models)
//                }
//                self.subscribeDidSuccess()
//            } catch let error as NSError {
//                print(error)
//                self.subscribeDidFailed()
//            }
//        }
//    }
//
//    func mqtt(_ mqtt: CocoaMQTT, didSubscribeTopic topic: String) {
//        TRACE("topic: \(topic)")
//    }
//
//    func mqtt(_ mqtt: CocoaMQTT, didUnsubscribeTopic topic: String) {
//        TRACE("topic: \(topic)")
//    }
//
//    func mqttDidPing(_ mqtt: CocoaMQTT) {
//        TRACE()
//    }
//
//    func mqttDidReceivePong(_ mqtt: CocoaMQTT) {
//        TRACE()
//    }
//
//    func mqttDidDisconnect(_ mqtt: CocoaMQTT, withError err: Error?) {
//        TRACE("\(err?.localizedDescription ?? "")")
//    }
//}

