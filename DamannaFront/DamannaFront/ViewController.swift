//
//  ViewController.swift
//  DamannaFront
//
//  Created by InJe Choi on 2021/05/20.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var userName: UITextField!
    @IBOutlet var inputName: UILabel!
    
    override func viewDidLoad() {
        self.userName.becomeFirstResponder()
    }
    
    // MARK:- 이름 전달 
    // Action Seguway 방식으로 입력받은 이름 전달
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dest = segue.destination
        
        guard let rvc = dest as? RoomSelect else {
            return
        }
        
        rvc.userName = self.userName.text!
    }
}
