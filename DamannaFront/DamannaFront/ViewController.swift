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
    // Submit 버튼 누를 때 Action Seguway 방식으로 입력받은 이름 전달
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // AppDelegate 저장소 이용해서 userName 저장 
        let ad = UIApplication.shared.delegate as? AppDelegate
        ad?.name = self.userName.text!
    }
    
}
