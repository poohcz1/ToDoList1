//
//  ToDoListModel.swift
//  ToDoList
//
//  Created by kp_mac on 2020/07/13.
//  Copyright © 2020 kp_mac. All rights reserved.
//

import Foundation

class ToDoListModel {
    var sid: Int
    var sdate: String?
    var scontent: String?
    
    init(sid: Int, sdate: String?, scontent: String?){
        self.sid = sid
        self.sdate = sdate
        self.scontent = scontent
    }
}
