//
//  ShowToDoTableViewController.swift
//  ToDoList
//
//  Created by kp_mac on 2020/07/13.
//  Copyright © 2020 kp_mac. All rights reserved.
//

import UIKit
import SQLite3

class ShowToDoTableViewController: UITableViewController {

    var db: OpaquePointer?
    var todolist = [ToDoListModel]()
    var inteval = 1.0
    let timeSelector: Selector = #selector(ShowToDoTableViewController.updateTime)
    
    @IBOutlet weak var currentDayAndDate: UILabel!
    @IBOutlet var toDoListTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        Timer.scheduledTimer(timeInterval: inteval, target: self, selector: timeSelector, userInfo: nil, repeats: true)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        opendb()
    }

    @objc func updateTime(){
        let date = NSDate()
        let formatter = DateFormatter()
        
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy년 MM월 dd일 E"
        currentDayAndDate.text = "오늘의 날짜 : " + formatter.string(from: date as Date)
    }
    
    // SQLite생성
    func opendb(){
           let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("ToDoListDataBase.sqlite")
           
           if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
               print("DataBase Open Failed")
           }
            
          if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS ToDoList (uid INTEGER PRIMARY KEY AUTOINCREMENT, ucontent TEXT, udate TEXT)", nil, nil, nil) != SQLITE_OK {
               let errmsg = String(cString: sqlite3_errmsg(db)!)
               print("error creating table: \(errmsg)")
           }
    
        readValues()
        
       }
    
    func readValues(){
        todolist.removeAll()
        
        let queryString = "SELECT * FROM ToDoList"
        var stmt: OpaquePointer?
        
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing select: \(errmsg)")
            return
        }
        
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            let id = sqlite3_column_int(stmt, 0)
            let date = String(cString: sqlite3_column_text(stmt, 1))
            let content = String(cString: sqlite3_column_text(stmt, 2))
            
            print(id, date, content)
            todolist.append(ToDoListModel(sid: Int(id), sdate: String(describing: date), scontent: String(describing: content)))
        }
        self.toDoListTableView.reloadData()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return todolist.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShowListCell", for: indexPath)

        let todolists: ToDoListModel
        todolists = todolist[indexPath.row]
        
        cell.textLabel?.text = todolists.scontent
        cell.detailTextLabel?.text = todolists.sdate
        // Configure the cell...

        return cell
    }
    

    override func viewDidAppear(_ animated: Bool) {
        readValues()
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    // 스와이프하였을때 어떤거 할지 적는 코드(삭제, 추가 등)
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let todolists = todolist[indexPath.row]
//            let sid = String(todolists.sid)
            //let update = UpdateToDoViewController()
            
            todolist.remove(at: (indexPath as NSIndexPath as NSIndexPath).row)
//            update.updateAction(sid, db!)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
 */
    

    
    // Override to support rearranging the table view.
    // rearranging 말 그대로 목록을 재 정렬하는 코드
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        
        let todolistToMove = todolist[(fromIndexPath as NSIndexPath).row]
        todolist.remove(at: (fromIndexPath as NSIndexPath).row)
        todolist.insert(todolistToMove, at: (to as NSIndexPath).row)
    }
    

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
