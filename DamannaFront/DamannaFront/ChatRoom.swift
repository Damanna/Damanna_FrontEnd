//
//  ChatRoom.swift
//  DamannaFront
//
//  Created by InJe Choi on 2021/05/25.
//

import UIKit
import StompClientLib

class ChatRoom: UIViewController, UITextFieldDelegate {
    
    // MARK: Stomp로 웹소켓 서버 연결을 위한 metadata
    let url = NSURL(string: "wss://damanna.herokuapp.com/ws/websocket")
    let intervalSec = 1.0
    var roomID: String = "temp"
    public var socketClient = StompClientLib()
    
    // RoomSelect 클래스에서 채팅방 주제를 전달받기 위한 프로퍼티
    var roomTopic: String = ""
    
    // 채팅들이 보여질 테이블 뷰
    @IBOutlet var chatTable: UITableView!
    
    // 사용자에게 메시지 입력받는 Text Field
    @IBOutlet var userMessage: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TextField Delegation
        self.userMessage.delegate = self
        
        // 뷰가 메모리에 로드될 때 stomp client에서 연결 시작 및 초기 설정
        socketClient.openSocketWithURLRequest(request: NSURLRequest(url: url! as URL), delegate: self)
        
        // 채팅방 이름 설정
        self.navigationItem.title = roomTopic + " 채팅방"
        
        // subscribe 할 때 사용자가 선택한 방 이름 전송
        roomID = roomTopic
        
        
    }
    
    // return key 누르면 키보드 사라지게
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        print("return key has entered")
        return true
    }
   
}


// MARK: Stomp 시작
extension ChatRoom: StompClientLibDelegate {
    // JSON 형식으로 data 전달을 위한 구조체
    struct chatMessage : Codable {
        var type: String? = ""
        var content: String? = ""
        var sender: String? = ""
        
        var dictionary : [String: Any]{
            return ["sender" : sender!, "type" : "JOIN"]
        }
        
        var nsDictionary : NSDictionary{
            return dictionary as NSDictionary
        }
    }
    
    // MARK:- 사용자 이름 및 접속하려는 roomID 전달
    @IBAction func submitButton(_ sender: Any) {
        
        let sendPath = "/app/chat/sendMessage/" + roomID
        let tt = chatMessage(sender: "jason")
        
        socketClient.sendJSONForDict(dict: tt.nsDictionary, toDestination: sendPath)
    }
    
    func stompClient(client: StompClientLib!, didReceiveMessageWithJSONBody jsonBody: AnyObject?, akaStringBody stringBody: String?, withHeader header: [String : String]?, withDestination destination: String) {
        
        print("Destination : \(destination)")
        print("JSON Body : \(String(describing: jsonBody))")
        
        var userName: String = ""
        if let name = jsonBody?["sender"] as? String {
            userName = name
        }
        print(userName)
        
        print("String Body : \(stringBody ?? "nil")")
    }
    
    func stompClientDidDisconnect(client: StompClientLib!) {
        print("Socket is Disconnected")
    }
    
    func stompClientDidConnect(client: StompClientLib!) {
        print("Socket is connected")
        print(roomTopic)
        socketClient.subscribe(destination: "/topic/" + roomID)
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

