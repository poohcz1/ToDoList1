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
    
    
    /*
     ----
     변수선언
     toDo : 할일내용
     toDoDay : 날짜
     toDoDate : 시간
     ----
     */
    @IBOutlet weak var toDo: UITextField!
    @IBOutlet weak var toDoDay: UITextField!
    @IBOutlet weak var toDoDate: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // SQLite 생성하기
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("ToDoListDataBase.sqlite")
        
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK{
            print("error opening database")
        }

        // Do any additional setup after loading the view.
    }
    
    @IBAction func addActionBtn(_ sender: UIButton) {
        // Java의 Statement
        var stmt: OpaquePointer?
        // 바인딩하기 위한 코드
        let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
        /*
         trimmingCharacters = trim
         date변수에 시간을 넣는코드
         */
        let date = toDoDate.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        /*
         content변수에 할일을 넣는코드
         */
        let content = toDo.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // date나 content가 nil값이라면 alert창 띄우는 코드
        if date == "" || content == "" {
            let resultAlert = UIAlertController(title: "결과", message: "날짜나 내용을 입력해주세요.", preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction(title: "네, 알겠습니다.", style: UIAlertAction.Style.default, handler: nil)
            resultAlert.addAction(okAction)
            present(resultAlert, animated: true, completion: nil)
            
        }else{
            
            // insert 쿼리 넣기
            let insertQuery = "INSERT INTO ToDoList(ucontent, udate) VALUES (?, ?)"
            
            // 쿼리 실행 준비
            if sqlite3_prepare(db, insertQuery, -1, &stmt, nil) != SQLITE_OK{
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("error preparing insert : \(errmsg)")
                return
            }
            
            //values 값2개 넣기
            if sqlite3_bind_text(stmt, 1, date, -1, SQLITE_TRANSIENT) != SQLITE_OK{
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("failure binding date: \(errmsg)")
                return
            }
            
            if sqlite3_bind_text(stmt, 2, content, -1, SQLITE_TRANSIENT) != SQLITE_OK{
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("failure binding content: \(errmsg)")
                return
            }
            
            // 쿼리 실행
            if sqlite3_step(stmt) != SQLITE_DONE {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("Failed Insert Query: \(errmsg)")
                return
            }
            
            let resultAlert = UIAlertController(title: "결과", message: "입력되었습니다.", preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction(title: "네, 알겠습니다.", style: UIAlertAction.Style.default, handler: nil)
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
