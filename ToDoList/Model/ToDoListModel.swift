//
//  ToDoListModel.swift
//  ToDoList
//
//  Created by kp_mac on 2020/07/13.
//  Copyright © 2020 kp_mac. All rights reserved.
//

import Foundation

class ToDoListModel {
    var uid: Int
    var udate: String?
    var ucontent: String?
    var udone: String?
    
    init(uid: Int, udate: String?, ucontent: String?, udone: String?){
        self.uid = uid
        self.udate = udate
        self.ucontent = ucontent
        self.udone = udone
    }
}
