//  
//  TrackChatViewController.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 22/04/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import UIKit
import RxSwift
import GrowingTextView
import CocoaMQTT

class TrackChatViewController: BaseViewController {

    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textView: GrowingTextView!
    
    var viewModel: TrackChatViewModel!
    var coordinator: TrackChatCoordinator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bindViewModel()
        viewModel.inputs.onViewDidLoad()
        self.isNotificationOn = false
        self.isTrackOn = true
        self.codeAct = viewModel.outputs.code
//        self.establishConnection()
//        self.mqtt!.delegate = self
        
    }
}

// MARK: Private

extension TrackChatViewController {
    
    func setupViews() {
        initTableView()
        sendButton.addTarget(self, action: #selector(send), for: .touchUpInside)
        subscribeChat()
    }
    
    func initTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.registerNib(UserCommentTableViewCell.self)
        tableView.registerNib(FriendCommentTableViewCell.self)
    }
    
    func bindViewModel() {
        observeUpdate()
        observeError()
        observeMessageText()
    }
    
    func observeMessageText() {
        textView.rx.text.orEmpty
            .distinctUntilChanged()
            .subscribe(onNext: { [unowned self] text in
                self.viewModel.inputs.onMessageText(text: text)
            })
            .disposed(by: disposeBag)
    }
    
    func observeUpdate() {
        viewModel.outputs.update
            .subscribe(onNext: { [weak self] _ in
                self?.tableView.reloadData()
                self?.scrollToBottom()
            })
            .disposed(by: disposeBag)
    }
    
    func observeError() {
        viewModel.outputs.errorString
            .subscribe(onNext: { [unowned self] error in
                ToastView.show(message: error, in: self, length: .short)
            })
            .disposed(by: disposeBag)
    }
    
    func scrollToBottom() {
        DispatchQueue.main.async {
            self.tableView.setContentOffset(CGPoint.init(x: 0, y: self.tableView.contentSize.height), animated: true)
        }
    }
    
    @objc func send() {
        if textView.text == "" {
            ToastView.show(message: "Field not complete", in: self, length: .short)
            return
        }
        let date = Int(Date().timeIntervalSince1970)
        let chatModel = ListGroupChatResponse.init(chatUid: "\(1)", chatUserId: User.shared.profile?.userId ?? "", chatUserName: User.shared.profile?.fullname ?? "", chatUserPhoto: User.shared.profile?.photoUrl ?? "", chatTime: "\(date)", chatSent: date, chatMsg: textView.text ?? "")
        self.viewModel.inputs.onAddChat(model: chatModel)
        self.textView.text = ""
        
        let topic = "lacakin/chat/\(User.shared.profile?.userId ?? "")/group/\(viewModel.outputs.code)"
        let stringModel = "[{\"chat_time\":\(date),\"chat_msg\":\"\(textView.text ?? "")\",\"ip\":\"127.0.0.1\",\"tz\":\"Asia/Jakarta\"}]"
        do {
            let jsonData = try JSONEncoder().encode(stringModel)
            let jsonString = String(data: jsonData, encoding: .utf8) ?? ""
            let data = Array(jsonString.utf8)
            let message = CocoaMQTTMessage.init(topic: topic, payload: data)
            MQTTManager.shared.publishMessage(message: message)
        }
        catch {
            
        }
    }
    
    func subscribeChat() {
        let topic = "chat/group/\(viewModel.outputs.code)"
        MQTTManager.shared.subscribeTopicTwo(topic: topic)
        MQTTManager.shared.mqtt?.didReceiveMessage = { mqtt, message, id in
            print("Message received in topic tracking \(message.topic) with payload \(message.string!)")
            if message.topic == topic {
                let string = message.string ?? ""
                let data = string.data(using: .utf8)!
                do {
                    let model = try JSONDecoder().decode(MTQQChat.self, from: data)
                    let modelResponse = ListGroupChatResponse.init(chatUid: model.chatUid, chatUserId: model.chatUserId, chatUserName: model.chatUserName, chatUserPhoto: model.chatUserPhoto, chatTime: model.chatTime, chatSent: model.chatSent, chatMsg: model.chatMsg)
                    self.viewModel.onAddChat(model: modelResponse)
                    self.tableView.reloadData()
                    
                    
                } catch let error as NSError {
                    print(error)
                    
                }
            }
        }
    }
}

extension TrackChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.outputs.model?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = viewModel.outputs.model?[indexPath.row]
        if model?.chatUserId == User.shared.profile?.userId {
            let cell = tableView.dequeueClass(UserCommentTableViewCell.self)
            cell.configureChat(model: model)
            return cell
        } else {
            let cell = tableView.dequeueClass(FriendCommentTableViewCell.self)
            cell.configureChat(model: model)
            return cell
        }
    }
}

extension TrackChatViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

//extension TrackChatViewController: CocoaMQTTDelegate {
//    // Optional ssl CocoaMQTTDelegate
//    
//    func mqtt(_ mqtt: CocoaMQTT, didReceive trust: SecTrust, completionHandler: @escaping (Bool) -> Void) {
//        TRACE("trust: \(trust)")
//        completionHandler(true)
//    }
//    
//    func mqtt(_ mqtt: CocoaMQTT, didConnectAck ack: CocoaMQTTConnAck) {
//        TRACE("didConnectAck ack: \(ack)")
//        mqtt.subscribe("lacakin/chat/group/\(viewModel.outputs.code))", qos: CocoaMQTTQOS.qos1)
//    }
//    
//    func mqtt(_ mqtt: CocoaMQTT, didStateChangeTo state: CocoaMQTTConnState) {
//        TRACE("new state: \(state)")
//    }
//    
//    func mqtt(_ mqtt: CocoaMQTT, didPublishMessage message: CocoaMQTTMessage, id: UInt16) {
//        TRACE("message: \(message.string?.description ?? ""), id: \(id)")
//        let string = message.string ?? ""
//        let data = string.data(using: .utf8)!
//        do {
//            let model = try JSONDecoder().decode(Array<MTQQChat>.self, from: data)
//            let chatModel = ListGroupChatResponse.init(chatUid: "\(id)", chatUserId: User.shared.profile?.userId ?? "", chatUserName: User.shared.profile?.fullname ?? "", chatUserPhoto: User.shared.profile?.photoUrl ?? "", chatTime: "\( model[0].chatTime ?? 0)", chatSent: model[0].chatTime ?? 0, chatMsg: model[0].chatMsg ?? "")
//            self.viewModel.inputs.onAddChat(model: chatModel)
//            self.textView.text = ""
//        } catch let error as NSError {
//            print(error)
//            
//        }
//        
//    }
//    
//    func mqtt(_ mqtt: CocoaMQTT, didPublishAck id: UInt16) {
//        TRACE("id: \(id)")
//    }
//    
//    func mqtt(_ mqtt: CocoaMQTT, didReceiveMessage message: CocoaMQTTMessage, id: UInt16 ) {
//        TRACE("message: \(message.string ?? ""), id: \(id)")
//
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
//    
//}
