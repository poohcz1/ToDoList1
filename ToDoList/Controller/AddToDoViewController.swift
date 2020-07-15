//
//  AddToDoViewController.swift
//  ToDoList
//
//  Created by kp_mac on 2020/07/13.
//  Copyright © 2020 kp_mac. All rights reserved.
//

import UIKit
import SQLite3

class AddToDoViewController: UIViewController {

    var db: OpaquePointer?
    var preparedView = UIView()
    
    /*
     ----
     변수선언
     toDo : 할일내용
     toDoDay : 날짜
     toDoDate : 시간
     ----
     */

    @IBOutlet weak var addBtn: NSLayoutConstraint!
    
    @IBOutlet weak var currentTime: UILabel!
    @IBOutlet weak var toMeetTime: UILabel!
    @IBOutlet weak var toDo: UITextView!
    

    var inteval = 1.0
    let timeSelector: Selector = #selector(ShowToDoTableViewController.updateTime)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // SQLite 생성하기
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("ToDoListData.sqlite")
        
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK{
            print("error opening database")
        }
        
        Timer.scheduledTimer(timeInterval: inteval, target: self, selector: timeSelector, userInfo: nil, repeats: true)

        // Do any additional setup after loading the view.
    }
    


     private func addKeyboardNotification() {
        
      NotificationCenter.default.addObserver(self,selector: #selector(keyboardWillShow),name: UIResponder.keyboardWillShowNotification,object: nil)
        
      NotificationCenter.default.addObserver(self,selector: #selector(keyboardWillHide),name: UIResponder.keyboardWillHideNotification,object: nil)
     }
    

    @objc private func keyboardWillShow(notification: Notification) {
        self.addBtn.constant = 300
        
    }
    
    @objc private func keyboardWillHide(notification: Notification) {
         self.addBtn.constant = 20
        
    }

    

    
    
    
    
    
    
    
    
    
    
    
    
    @IBAction func addActionBtn(_ sender: UIButton) {

        let date = toMeetTime.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let content = toDo.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // date나 content가 nil값이라면 alert창 띄우는 코드
        if date == "" || content == "" {
            let resultAlert = UIAlertController(title: "결과", message: "날짜나 내용을 입력해주세요.", preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction(title: "네, 알겠습니다.", style: UIAlertAction.Style.default, handler: nil)
            resultAlert.addAction(okAction)
            present(resultAlert, animated: true, completion: nil)
            
        }else{
            
            let paramDate = date
            let paramContent = content
            let insert = Network()
            insert.insertAction(paramDate!, paramContent!, db!)
            
            let resultAlert = UIAlertController(title: "결과", message: "입력되었습니다.", preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction(title: "네, 알겠습니다.", style: UIAlertAction.Style.default, handler: {ACTION in self.navigationController?.popViewController(animated: true)})
            resultAlert.addAction(okAction)
            present(resultAlert, animated: true, completion: nil)
            
            print("SuccessFully!")
        }
    }
    
    @objc func updateTime(){
        let date = NSDate()
        let formatter = DateFormatter()
        
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy년 MM월 dd일 HH:mm:ss E"
        currentTime.text = formatter.string(from: date as Date)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){

          self.view.endEditing(true)
    }
    
    @IBAction func actionPickerView(_ sender: UIDatePicker) {
        
        let datePickerView = sender
        let formatter = DateFormatter()
       
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy년 MM월 dd일 HH:mm:ss E"
        
        toMeetTime.text = formatter.string(from: datePickerView.date)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
