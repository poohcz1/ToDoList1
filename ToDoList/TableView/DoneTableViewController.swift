//
//  DoneTableViewController.swift
//  ToDoList
//
//  Created by kp_mac on 2020/07/15.
//  Copyright © 2020 kp_mac. All rights reserved.
//

import UIKit
import SQLite3

class DoneTableViewController: UITableViewController {

    @IBOutlet var toDoListTableView: UITableView!
    
    var doneReceivedData = [ToDoListModel]()
    var db: OpaquePointer?
    var todolist = [ToDoListModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("ToDoListData.sqlite")
        
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK{
            print("error opening database")
        }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return doneReceivedData.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DoneListCell", for: indexPath)

        let todolists: ToDoListModel
        todolists = doneReceivedData[indexPath.row]
        
        cell.textLabel?.text = todolists.ucontent
        cell.detailTextLabel?.text = todolists.udate
        
        // Configure the cell...

        return cell
    }
    
    func readValue(){
        
        todolist.removeAll()
        
        let doneSelect = Network()
        doneReceivedData = doneSelect.doneSelectAction()
        self.toDoListTableView.reloadData()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        readValue()
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
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

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
        if segue.identifier == "doneSegue"{
            let cell = sender as! UITableViewCell
            let indexPath = self.toDoListTableView.indexPath(for: cell)
            let doneView = segue.destination as! DoneViewController
            let item: ToDoListModel = doneReceivedData[(indexPath! as NSIndexPath).row]
             
            let uid = Int(item.uid)
            let udate = String(item.udate!)
            let ucontent = String(item.ucontent!)
            let udone = String(item.udone!)
            
//            doneView.receivedData(uid, udate, ucontent, udone)
        }
    }
}
