//
//  RoomSelect.swift
//  DamannaFront
//
//  Created by InJe Choi on 2021/05/25.
//

import UIKit

class RoomSelect: UITableViewController {
    
    var roomList = [RoomVO]()
    var topic = RoomVO()
    
    // POST 할 데이터 정의 
    struct PostComment: Codable {
        let roomID: String
        let tags: String
    }
    
    @IBAction func addRoom(_ sender: Any) {
        var postRoomID: String = ""
        var postTag: String = ""
        
        // 알림창 객체 생성
        let alert = UIAlertController(title: "새로운 채팅방 만들기", message: "채팅방의 설명을 작성하세요", preferredStyle: .alert)
        
        // 알림창에 입력 폼 추가
        alert.addTextField() { (tf) in
            tf.placeholder = "방 이름을 입력하세요"
        }
        alert.addTextField() { (tf) in
            tf.placeholder = "방 설명을 입력하세요"
        }
        
        // OK 버튼 객체 생성
        let ok = UIAlertAction(title: "추가하기", style: .default) { (_) in
            // 알림창의 0번째 입력 필드에 값이 있다면
            
            let rvo = RoomVO()
            
            let title = alert.textFields?[0].text
            let tag = alert.textFields?[1].text
            
            if (title != nil), (tag != nil) {
                postRoomID = title!
                postTag = tag!
                
                // MARK: POST 하기
                // JSON 객체 준비
                let comment = PostComment(roomID: postRoomID, tags: postTag)
                guard let uploadData = try? JSONEncoder().encode(comment) else {
                    return
                }
                
                // POST request 만들기
                let url: URL! = URL(string: "https://test-message2.herokuapp.com/room/save")
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                
                // request에 JSON 데이터 넣고, URLSession 객체를 통해 전송 및 응답값 처리
                let task = URLSession.shared.uploadTask(with: request, from: uploadData) { (data, response, error) in
                        // 서버가 응답이 없거나 통신이 실패
                        if let e = error {
                            NSLog("An error has occured: \(e.localizedDescription)")
                            return
                        }
                    // 응답 처리 로직
                    print("comment post success")
                }
                // POST 전송
                task.resume()
                
                // 배열에 입력된 값을 추가하고 테이블 갱신
                rvo.Topic = title
                rvo.roomTag = tag
                
                self.roomList.append(rvo)
                self.tableView.reloadData()
            }
        }
        
        // 취소 버튼 객체 생성
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        // 알림창 객체에 버튼 객체 등록
        alert.addAction(ok)
        alert.addAction(cancel)
        
        // 알림창 띄우기
        self.present(alert, animated: false)
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.roomList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let row = self.roomList[indexPath.row] // 행 번호를 알고자 할 때는 indexPath.row
        
        // "cell" 아이디를 가진 셀을 읽어온다. 없으면 UITableViewCell 인스턴스를 생성한다
        let cell = tableView.dequeueReusableCell(withIdentifier: "roomCell") as! RoomCell
        
        // 셀의 기본 텍스트 레이블 행 수 제한을 없앤다
        //cell.textLabel?.numberOfLines = 0
        
        // 셀의 기본 텍스트 레이블에 배열 변수의 값을 할당한다
        cell.Topic?.text = row.Topic
        cell.roomTag?.text = row.roomTag
        
        return cell
    }
    
//    테이블 뷰에 행이 하나 추가되어 reload() 되어 뷰가 나타날 떄 cell의 크기를 자동으로 글자 수의 길이에 맞춰 늘림
    override func viewWillAppear(_ animated: Bool) {
        
        let url: URL! = URL(string: "https://test-message2.herokuapp.com/room/read")
        let dbData = try! Data(contentsOf: url)
        let log = NSString(data: dbData, encoding: String.Encoding.utf8.rawValue) ?? "No Data"
        NSLog("API Result = \(log)")
        
        do {
            // DB에서 가져온 json객체를 NSArray로 변환
            let data = try JSONSerialization.jsonObject(with: dbData, options: []) as! NSArray
            
            roomList.removeAll()
            // 변환한 데이터에서 객체 하나씩 뽑아서 String으로 캐스팅 후 리스트에 추가
            for row in data {
                let r = row as! NSDictionary
                let rvo = RoomVO()
                rvo.Topic = r["roomID"] as? String
                rvo.roomTag = r["tags"] as? String
                roomList.append(rvo)
            }
            
        } catch {
            NSLog("Parse Error!")
        }
        self.tableView.reloadData()
    }
    
    // 선택한 행(방 주제)에 대해 일어나는 event 정의
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        topic = roomList[indexPath.row]
        
        // Segueway 실제 이동
        // performSegue(withIdentifier: "moveToChatRoom", sender: self)
        
        let vc = ChatViewContoller()
        vc.roomTopic = self.topic.Topic!
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
