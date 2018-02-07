//
//  TableListVC.swift
//  Swift_playground
//
//  Created by yesdgq on 2018/2/6.
//  Copyright © 2018年 yesdgq. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class MyTableListVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var myTableView: UITableView?
    var dataArray: [CellModel] = Array()
    
    
    // MARK: - 懒加载
    lazy var dataSourceArry: [String]? = {
        return ["me", "she", "he", "other", "ww", "zl"]
    }()
   
    let jsonArray: [[String : String]] = [
        ["name" : "蛙儿子1",  "imageUrl" : "http://n.sinaimg.cn/translate/w660h371/20180201/o53s-fyrcsrw4144209.jpg"],
        ["name" : "蛙儿子2",  "imageUrl" : "http://ww1.sinaimg.cn/large/5f9dbc69ly1fo7w1bzua0j20ic0abwf0.jpg"],
        ["name" : "蛙儿子3",  "imageUrl" : "https://raw.githubusercontent.com/onevcat/Kingfisher/master/images/kingfisher-1.jpg"],
        ["name" : "蛙儿子4",  "imageUrl" : "http://ww1.sinaimg.cn/large/5f9dbc69ly1fo7w1bzua0j20ic0abwf0.jpg"],
        ["name" : "蛙儿子5",  "imageUrl" : "https://raw.githubusercontent.com/onevcat/Kingfisher/master/images/kingfisher-1.jpg"],
        ["name" : "蛙儿子6",  "imageUrl" : "http://ww1.sinaimg.cn/large/5f9dbc69ly1fo7w1bzua0j20ic0abwf0.jpg"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.lightGray
        
        for dict in jsonArray {
            let jsonData = JSON(dict)
            let model = CellModel(jsonData: jsonData)
            dataArray.append(model)
        }
        
        self.setuptableView()
        
    }
    
    
    
    func setuptableView() {
        myTableView = UITableView.init(frame: CGRect(x: 0, y: 0, width: 375, height: 667), style: UITableViewStyle.grouped)
        myTableView?.delegate = self
        myTableView?.dataSource = self
        
        self.view.addSubview(myTableView!)
    }
    
    // mark - tableViewDelegate
    // 分区数
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // cell数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    // cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = MyTableViewCell.cellWithTableView(tableView)
//        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: nil) // 系统默认cell
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
}




private let ID = "MyTableViewCell"

class MyTableViewCell: UITableViewCell {
    
    let iconIV: UIImageView
    let label: UILabel
    var cellModel: CellModel?
    
    
    class func cellWithTableView(_ tableView : UITableView) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: ID) as? MyTableViewCell
        if cell == nil {
            cell = MyTableViewCell(style: .default, reuseIdentifier: ID)
            // nib创建
            //let nib = UINib(nibName:"MyTableViewCell", bundle:nil)
            //tableView.register(nib, forCellReuseIdentifier:ID)
        }
        return cell!
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        self.iconIV = UIImageView()
        self.label = UILabel()
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    override func setSelected(_ selected:Bool, animated:Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

class CellModel: NSObject {
    var name: String?
    var imageUrl: String?
    
    init(jsonData: JSON) {
        name = jsonData["name"].stringValue
        imageUrl = jsonData["imageUrl"].stringValue
    }
}





