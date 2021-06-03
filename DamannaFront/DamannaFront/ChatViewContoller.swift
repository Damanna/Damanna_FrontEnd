//
//  chatViewContoller.swift
//  DamannaFront
//
//  Created by InJe Choi on 2021/06/02.
//

import UIKit
import MessageKit
import InputBarAccessoryView
import StompClientLib

struct Sender: SenderType {
    var senderId: String
    var displayName: String
}

struct Message: MessageType {
    var sender: SenderType
    var messageId: String // Should be Unique
    var sentDate: Date
    var kind: MessageKind // 메시지의 종류 (텍스트, 사진, 비디오, 이모티콘...)
    
    let user = Sender(senderId: "self", displayName: "Jason Choi")
    
    var dictionary: [String: MessageType]{
        return ["Message": Message(sender: user, messageId: "1", sentDate: Date(), kind: .text("abc"))]
    }
    
    var nsDictionary : NSDictionary{
        return dictionary as NSDictionary
    }
}

class ChatViewContoller: MessagesViewController, MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate {
    
    // MARK: Stomp로 웹소켓 서버 연결을 위한 metadata
    let url = NSURL(string: "wss://test-message2.herokuapp.com/ws/websocket")
    let intervalSec = 1.0
    var roomID: String = "temp"
    public var socketClient = StompClientLib()
    
    // RoomSelect 클래스에서 채팅방 주제를 전달받기 위한 프로퍼티
    var roomTopic: String = ""
    // AppDelegate 저장소에서 userName 전달 받을 프로퍼티
    var userName: String?
    
    var currentUser = Sender(senderId: "", displayName: "")
    var otherUser = Sender(senderId: "", displayName: "")
    
    var messages = [MessageType]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // AppDelegate 저장소에서 userName 전달 받기
        let ad = UIApplication.shared.delegate as? AppDelegate
        self.userName = ad?.name
        
        // 내 이름을 currentUser로 저장
        currentUser = Sender(senderId: "self", displayName: userName!)
        
        // 뷰가 메모리에 로드될 때 stomp client에서 연결 시작 및 초기 설정
        socketClient.openSocketWithURLRequest(request: NSURLRequest(url: url! as URL), delegate: self)
        print("\(socketClient)")
        // 채팅방 이름 설정
        self.navigationItem.title = roomTopic + " 채팅방"
        
        // subscribe 할 때 사용자가 선택한 방 이름 전송
        roomID = roomTopic
        
        // 메시지 입력란 Delegation
        messageInputBar.delegate = self
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
                
    }

    func currentSender() -> SenderType {
        return currentUser
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    // Number of Messages
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
}

// MARK: MessageKit에서 TextField랑 SendButton 다루기
extension ChatViewContoller: InputBarAccessoryViewDelegate {

    // TextField에 메시지 입력 후 Send 버튼 누르면 수행되는 메소드
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        guard !text.replacingOccurrences(of: " ", with: "").isEmpty else {
            return
        }
        print("Sending: \(text)")
        
        // Send Message
        let sendPath = "/app/chat/sendMessage/" + roomID
        let chat = ["type": "CHAT", "content": text, "sender": userName!] as NSDictionary
        socketClient.sendJSONForDict(dict: chat, toDestination: sendPath)
    }
}

// MARK: Stomp 시작
extension ChatViewContoller: StompClientLibDelegate {
    // JSON 형식으로 data 전달을 위한 구조체
    struct subscribeMessage : Codable {
        var type: String? = ""
        var content: String? = ""
        var sender: String? = ""
        
        var dictionary: [String: String]{
            return ["sender": sender!, "type": "JOIN"]
        }
        
        var nsDictionary : NSDictionary{
            return dictionary as NSDictionary
        }
    }
    
    func stompClient(client: StompClientLib!, didReceiveMessageWithJSONBody jsonBody: AnyObject?, akaStringBody stringBody: String?, withHeader header: [String : String]?, withDestination destination: String) {
        
        print("Destination : \(destination)")
        print("JSON Body : \(String(describing: jsonBody))")
        
        var receivedName: String = ""
        if let name = jsonBody?["sender"] as? String {
            receivedName = name
        }
        
        var receivedContent: String = ""
        if let contents = jsonBody?["content"] as? String {
            receivedContent = contents
        }

        if receivedName == currentUser.displayName {
            messages.append(Message(sender: currentUser,
                                    messageId: "1",
                                    sentDate: Date(),
                                    kind: .text(receivedContent)))
        } else {
            otherUser = Sender(senderId: "other", displayName: receivedName)
            messages.append(Message(sender: otherUser,
                                    messageId: "1",
                                    sentDate: Date(),
                                    kind: .text(receivedContent)))
        }
        
        self.messagesCollectionView.reloadData()
    }
    
    func stompClientDidDisconnect(client: StompClientLib!) {
        print("Socket is Disconnected")
    }
    
    // Subscribe하는 단계
    func stompClientDidConnect(client: StompClientLib!) {
        print("Socket is connected")
        print(roomTopic)
        socketClient.subscribe(destination: "/topic/" + roomID)
        let subPath = "/app/chat/addUser/" + roomID
        let sub = subscribeMessage(sender: userName)
        socketClient.sendJSONForDict(dict: sub.nsDictionary, toDestination: subPath)
    }
    
    func serverDidSendReceipt(client: StompClientLib!, withReceiptId receiptId: String) {
        print("Receipt : \(receiptId)")
    }
    
    func serverDidSendError(client: StompClientLib!, withErrorMessage description: String, detailedErrorMessage message: String?) {
        print("Error Send : \(String(describing: message))")
        if(!socketClient.isConnected()) {
            // reconnect()
        }
    }
    
    func serverDidSendPing() {
        print("Server ping")
    }
    
}
