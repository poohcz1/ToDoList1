//
//  DeleteNetwork.swift
//  ToDoList
//
//  Created by kp_mac on 2020/07/14.
//  Copyright © 2020 kp_mac. All rights reserved.
//

import Foundation
import SQLite3


class Network{
    
    var db: OpaquePointer?
    var todolist = [ToDoListModel]()
    
    func deleteAction(_ id: String, _ db:OpaquePointer){
        
        var stmt: OpaquePointer?
        let deleteQuery = "DELETE FROM todolist WHERE uid = ?"
        
        if sqlite3_prepare(db, deleteQuery, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing delete : \(errmsg)")
            return
        }
        
        if sqlite3_bind_int(stmt, 1, (id as NSString).intValue) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding id: \(errmsg)")
            return
        }
        
        if sqlite3_step(stmt) != SQLITE_DONE{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure deleting user: \(errmsg)")
            return
        }
    }
    
    func modifyAction(_ id: String, _ date: String, _ content: String, _ db:OpaquePointer){
        
        var stmt: OpaquePointer?
        let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
        
        let modifyQuery = "UPDATE todolist SET udate = ?, ucontent = ?, udone = 0 WHERE uid = ?"
        
        if sqlite3_prepare(db, modifyQuery, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing update : \(errmsg)")
            return
        }
        
        if sqlite3_bind_text(stmt, 1, content, -1, SQLITE_TRANSIENT) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding date: \(errmsg)")
            return
        }
        
        if sqlite3_bind_text(stmt, 2, date, -1, SQLITE_TRANSIENT) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding content: \(errmsg)")
            return
        }
        
        if sqlite3_bind_int(stmt, 3, (String(id) as NSString).intValue) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding id: \(errmsg)")
            return
        }
        
        if sqlite3_step(stmt) != SQLITE_DONE{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure updating student: \(errmsg)")
            return
        }
    }
    
    func doneAction(){
        
    }
    
    func selectAction() -> [ToDoListModel]{
        
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("ToDoListData.sqlite")
        
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK{
            print("error opening database")
        }
        
        let selectQuery = "SELECT * FROM todolist WHERE udone = 0 ORDER BY udate ASC"
        var stmt: OpaquePointer?
        
        if sqlite3_prepare(db, selectQuery, -1, &stmt, nil) != SQLITE_OK{
            print("모델2")
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing select: \(errmsg)")
            
        }
        
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            print("모델3")
            let id = sqlite3_column_int(stmt, 0)
            let date = String(cString: sqlite3_column_text(stmt, 1))
            let content = String(cString: sqlite3_column_text(stmt, 2))
            let done = String(cString: sqlite3_column_text(stmt, 3))
            print("모델4")
            
            todolist.append(ToDoListModel(uid: Int(id), udate: String(describing: date), ucontent: String(describing: content), udone: String(describing: done)))
              print(todolist)
        }
        return todolist
    }
    
    func insertAction(_ date: String, _ content: String, _ db:OpaquePointer){
        
        // Java의 Statement
        var stmt: OpaquePointer?
         // 바인딩하기 위한 코드
        let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
        // insert 쿼리 넣기
        let insertQuery = "INSERT INTO todolist(ucontent, udate, udone) VALUES (?, ?, 0)"
        
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
    }
}
