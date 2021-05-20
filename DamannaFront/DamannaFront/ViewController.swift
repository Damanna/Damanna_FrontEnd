//
//  ViewController.swift
//  DamannaFront
//
//  Created by InJe Choi on 2021/05/20.
//

import UIKit
import StompClientLib

class ViewController: UIViewController, StompClientLibDelegate {

    let url = NSURL(string: "wss://test-message2.herokuapp.com/ws/websocket")
    let intervalSec = 1.0
    public var socketClient = StompClientLib()


    override func viewDidLoad() {
        super.viewDidLoad()
        print("1")
        socketClient.openSocketWithURLRequest(request: NSURLRequest(url: url! as URL), delegate: self)
        print("2")
        print("\(socketClient)")
        print("3")
    }
    
    @IBOutlet var welcomeLabel: UILabel!
    
    struct test {
        var content: String? = ""
        var sender: String? = ""
        
        var dictionary : [String: Any]{
            return ["sender" : sender!, "type" : "JOIN"]
        }
        
        var nsDictionary : NSDictionary{
            return dictionary as NSDictionary
        }
    }
    
    @IBAction func submitButton(_ sender: Any) {
        
        let sendPath = "/app/chat.addUser"
        let tt = test(content: "abc", sender: "jason")
        
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
        socketClient.subscribe(destination: "/topic/apple")
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
