//
//  RoomSelect.swift
//  DamannaFront
//
//  Created by InJe Choi on 2021/05/25.
//

import UIKit

class RoomSelect: UITableViewController {
    
    var userName: String = ""
    var roomList = [String]()
    var topic: String = ""
    
    // POST 할 데이터 정의 
    struct PostComment: Codable {
        let roomID: String
    }
    
    override func viewDidLoad() {
        print(userName)
        
        let url: URL! = URL(string: "https://damanna.herokuapp.com/room/read")
        let dbData = try! Data(contentsOf: url)
        let log = NSString(data: dbData, encoding: String.Encoding.utf8.rawValue) ?? "No Data"
        NSLog("API Result = \(log)")
        
        do {
            // DB에서 가져온 json객체를 NSArray로 변환
            let data = try JSONSerialization.jsonObject(with: dbData, options: []) as! NSArray
            
            // 변환한 데이터에서 객체 하나씩 뽑아서 String으로 캐스팅 후 리스트에 추가
            for row in data {
                let r = row as! NSDictionary
                
                roomList.append(r["roomID"] as! String)
            }
            
        } catch {
            NSLog("Parse Error!")
        }
    }
    
    // MARK:- 주제 전달
    // Segue perform 전에 미리 해야할 일 정의, 선택한 주제 전달
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dest = segue.destination
        
        // ChatRoom 이름 설정을 위해 주제 전달 
        guard let chatroomVC = dest as? ChatRoom else {
            return
        }
        
        chatroomVC.roomTopic = self.topic
    }
    
    @IBAction func addRoom(_ sender: Any) {
        var postRoomID: String = ""
        
        // 알림창 객체 생성
        let alert = UIAlertController(title: "새로운 주제 입력", message: "추가하고 싶은 대화 방의 주제를 입력하세요", preferredStyle: .alert)
        
        // 알림창에 입력 폼 추가
        alert.addTextField() { (tf) in
            tf.placeholder = "주제를 입력하세요"
        }
        
        // OK 버튼 객체 생성
        let ok = UIAlertAction(title: "추가하기", style: .default) { (_) in
            // 알림창의 0번째 입력 필드에 값이 있다면
            if let title = alert.textFields?[0].text {
                // TextField에서 입력 받은 값을 JSON 객체로 날릴 변수에 저장
                postRoomID = title
                
                // MARK: POST 하기
                // JSON 객체 준비
                let comment = PostComment(roomID: postRoomID)
                guard let uploadData = try? JSONEncoder().encode(comment) else {
                    return
                }
                
                // POST request 만들기
                let url: URL! = URL(string: "https://damanna.herokuapp.com/room/save")
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
                self.roomList.append(title)
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
        
        // "cell" 아이디를 가진 셀을 읽어온다. 없으면 UITableViewCell 인스턴스를 생성한다
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") ?? UITableViewCell()
        
        // 셀의 기본 텍스트 레이블 행 수 제한을 없앤다
        cell.textLabel?.numberOfLines = 0
        
        // 셀의 기본 텍스트 레이블에 배열 변수의 값을 할당한다
        cell.textLabel?.text = roomList[indexPath.row]
        return cell
    }
    
//    테이블 뷰에 행이 하나 추가되어 reload() 되어 뷰가 나타날 떄 cell의 크기를 자동으로 글자 수의 길이에 맞춰 늘림 (근데 없어도 잘 된다..?)
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.estimatedRowHeight = 50
        self.tableView.rowHeight = UITableView.automaticDimension
    }
    
    // 선택한 행(방 주제)에 대해 일어나는 event 정의
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        topic = roomList[indexPath.row]
        
        // Segueway 실제 이동
        performSegue(withIdentifier: "moveToChatRoom", sender: self)
    }
    
}
