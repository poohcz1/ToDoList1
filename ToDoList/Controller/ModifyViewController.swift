//
//  ModifyViewController.swift
//  ToDoList
//
//  Created by kp_mac on 2020/07/14.
//  Copyright © 2020 kp_mac. All rights reserved.
//

import UIKit
import SQLite3

class ModifyViewController: UIViewController {

    var receivedId = 0
    var receivedDate = ""
    var receivedContent = ""
    var receivedDone = ""
    var db: OpaquePointer?
    let interval = 1.0
    let timeSelector: Selector = #selector(ModifyViewController.updateTime)
    @IBOutlet weak var beforeMeetTime: UILabel!
    @IBOutlet weak var newMeetTime: UILabel!
    @IBOutlet weak var newToDo: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Timer.scheduledTimer(timeInterval: interval, target: self, selector: timeSelector, userInfo: nil, repeats: true)
        newToDo.text = receivedContent
        beforeMeetTime.text = receivedDate
        
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("ToDoListData.sqlite")
        
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK{
            print("error opening database")
        }
        // Do any additional setup after loading the view.
    }
    
    func receivedData(_ uid: Int, _ udate: String, _ ucontent: String, _ udone: String){
        receivedId = uid
        receivedDate = udate
        receivedContent = ucontent
        receivedDone = udone
    }
    
    @objc func updateTime(){
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일 HH:mm:ss E"
    }
    
    @IBAction func pickerView(_ sender: UIDatePicker) {
        
        let datePickerView = sender
        let formatter = DateFormatter()
        
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy년 MM월 dd일 HH:mm:ss E"
        newMeetTime.text = formatter.string(from: datePickerView.date)
    }
    
    @IBAction func deleteActionBtn(_ sender: UIButton) {
     
        let id = receivedId
        let deleteData = Network()
        
        print("uid", id)
        deleteData.deleteAction(String(id), db!)
        
        let resultAlert = UIAlertController(title: "결과", message: "삭제되었습니다.", preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "네, 알겠습니다.", style: UIAlertAction.Style.default, handler: {ACTION in self.navigationController?.popViewController(animated: true)})
        resultAlert.addAction(okAction)
        present(resultAlert, animated: true, completion: nil)
        
        print("Deleted successfully!")
    }
    
    @IBAction func modifyActionBtn(_ sender: UIButton) {
        
        let date = newMeetTime.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let content = newToDo.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // date나 content가 nil값이라면 alert창 띄우는 코드
        if date == "" || content == "" {
            let resultAlert = UIAlertController(title: "결과", message: "날짜나 내용을 입력해주세요.", preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction(title: "네, 알겠습니다.", style: UIAlertAction.Style.default, handler: nil)
            resultAlert.addAction(okAction)
            present(resultAlert, animated: true, completion: nil)
            
        }else{
            
            let id = receivedId
            let paramDate = date
            let paramContent = content
            let modify = Network()
            modify.modifyAction(String(id), paramDate!, paramContent!, db!)
            
            let resultAlert = UIAlertController(title: "결과", message: "수정되었습니다.", preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction(title: "네, 알겠습니다.", style: UIAlertAction.Style.default, handler: {ACTION in self.navigationController?.popViewController(animated: true)})
            resultAlert.addAction(okAction)
            present(resultAlert, animated: true, completion: nil)
            
            print("SuccessFully!")
        }
        
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
