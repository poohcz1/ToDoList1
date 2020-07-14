//
//  ShowToDoTableViewController.swift
//  ToDoList
//
//  Created by kp_mac on 2020/07/13.
//  Copyright © 2020 kp_mac. All rights reserved.
//
// https://www.simplifiedios.net/swift-sqlite-tutorial/
// https://studyhard24.tistory.com/96
// https://github.com/WenchaoD/FSCalendar
// https://hyongdoc.tistory.com/334
// https://moonibot.tistory.com/13
// https://app-developer.tistory.com/127
// https://zeddios.tistory.com/310
// https://itchipmunk.tistory.com/189
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
        formatter.dateFormat = "yyyy년 MM월 dd일 HH:mm:ss E"
        currentDayAndDate.text = formatter.string(from: date as Date)
    }
    
    // SQLite생성
    func opendb(){
           let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("ToDoListData.sqlite")
           
           if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
               print("DataBase Open Failed")
           }
            
          if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS todolist (uid INTEGER PRIMARY KEY AUTOINCREMENT, ucontent TEXT, udate TEXT, udone TEXT)", nil, nil, nil) != SQLITE_OK {
               let errmsg = String(cString: sqlite3_errmsg(db)!)
               print("error creating table: \(errmsg)")
           }
        readValues()
       }
    
    func readValues(){
        
        let select = Network()
        select.selectAction()
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
        
        cell.textLabel?.text = todolists.ucontent
        cell.detailTextLabel?.text = todolists.udate
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
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "modifysegue"{
            let cell = sender as! UITableViewCell
            let indexPath = self.toDoListTableView.indexPath(for: cell)
            let modifyView = segue.destination as! ModifyViewController
            let item: ToDoListModel = todolist[(indexPath! as NSIndexPath).row]
            
            let uid = Int(item.uid)
            let udate = String(item.udate!)
            let ucontent = String(item.ucontent!)
            let udone = String(item.udone!)
           
            modifyView.receivedData(uid, udate, ucontent, udone)
        }
        
    }
    

}
