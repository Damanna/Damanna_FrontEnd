//
//  ChatRoom.swift
//  DamannaFront
//
//  Created by InJe Choi on 2021/05/25.
//

import UIKit
import StompClientLib

class ChatRoom: UIViewController, StompClientLibDelegate {
    
    let url = NSURL(string: "wss://damanna.herokuapp.com/ws/websocket")
    let intervalSec = 1.0
    let roomID:String = "abc"
    
    public var socketClient = StompClientLib()


    override func viewDidLoad() {
        super.viewDidLoad()
        print("1")
        socketClient.openSocketWithURLRequest(request: NSURLRequest(url: url! as URL), delegate: self)
        print("2")
        print("\(socketClient)")
        print("3")
    }
    
    struct test : Codable {
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
        let sendPath = "/app/chat/addUser/"  + roomID// + topic (입력받은 값)
        let tt = test(sender: "jason")
        
        socketClient.sendJSONForDict(dict: tt.nsDictionary, toDestination: sendPath)
    }
    
    func stompClient(client: StompClientLib!, didReceiveMessageWithJSONBody jsonBody: AnyObject?, akaStringBody stringBody: String?, withHeader header: [String : String]?, withDestination destination: String) {
        
        print("Destination : \(destination)")
        print("JSON Body : \(String(describing: jsonBody))")
        print("String Body : \(stringBody ?? "nil")")
    }
    
    func stompClientDidDisconnect(client: StompClientLib!) {
        print("Socket is Disconnected")
    }
    
    func stompClientDidConnect(client: StompClientLib!) {
        print("Socket is connected")
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
