//
//  CusInfoColleVC.swift
//  Swift_playground
//
//  Created by yesdgq on 2019/7/8.
//  Copyright © 2019 yesdgq. All rights reserved.
//

import Foundation

class CusInfoColleVC: UITableViewController {
    
    
    override func viewDidLoad() {
        
        self.view.backgroundColor = UIColor(hexString: "#24303B")
        self.navigationItem.title = "信息核查工具"
        self.navigationItem.backBarButtonItem?.title = "返回"
        
        self.tableView.tableFooterView = UIView()
    }
    
    
    
    
    deinit {
        DDLogDebug("CusInfoColleVC 控制器释放")
    }
    
    
    
    
}


extension CusInfoColleVC {
    
    // 分区数
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    // cell数
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    // cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = MyTableViewCell.cellWithTableView(tableView)
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: nil) // 系统默认cell
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

extension CusInfoColleVC {
    
    
    
}
