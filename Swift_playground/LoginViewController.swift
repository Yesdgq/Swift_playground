//
//  LoginViewController.swift
//  Swift_playground
//
//  Created by yesdgq on 2018/1/25.
//  Copyright © 2018年 yesdgq. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import SwiftyJSON

private let CELL_ID = "cell_id"

class LoginViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var idTextfield: UITextField!
    var collectionView: UICollectionView?
    var name: String?
    var dataArray: [CellModel] = Array()
    
    let jsonArray: [[String : String]] = [
        ["name" : "蛙儿子1",  "imageUrl" : "http://n.sinaimg.cn/translate"],
        ["name" : "蛙儿子2",  "imageUrl" : "http://ww1.sinaimg.cn/large/5f9dbc69ly1fo7w1bzua0j20ic0abwf0.jpg"],
        ["name" : "蛙儿子3",  "imageUrl" : "https://raw.githubusercontent.com/onevcat/Kingfisher/master/images/kingfisher-1.jpg"],
        ["name" : "蛙儿子4",  "imageUrl" : "http://ww1.sinaimg.cn/large/5f9dbc69ly1fo7w1bzua0j20ic0abwf0.jpg"],
        ["name" : "蛙儿子5",  "imageUrl" : "http://ww1.sinaimg.cn/large/5f9dbc69ly1fo7w1bzua0j20ic0abwf0.jpg"],
        ["name" : "蛙儿子1",  "imageUrl" : "http://n.sinaimg.cn/translate"],
        ["name" : "蛙儿子2",  "imageUrl" : "http://ww1.sinaimg.cn/large/5f9dbc69ly1fo7w1bzua0j20ic0abwf0.jpg"],
        ["name" : "蛙儿子4",  "imageUrl" : "http://ww1.sinaimg.cn/large/5f9dbc69ly1fo7w1bzua0j20ic0abwf0.jpg"],
        ["name" : "蛙儿子5",  "imageUrl" : "http://ww1.sinaimg.cn/large/5f9dbc69ly1fo7w1bzua0j20ic0abwf0.jpg"],
        ["name" : "蛙儿子6",  "imageUrl" : "https://raw.githubusercontent.com/onevcat/Kingfisher/master/images/kingfisher-1.jpg"],
        ["name" : "蛙儿子1",  "imageUrl" : "http://n.sinaimg.cn/translate"],
        ["name" : "蛙儿子2",  "imageUrl" : "http://ww1.sinaimg.cn/large/5f9dbc69ly1fo7w1bzua0j20ic0abwf0.jpg"],
        ["name" : "蛙儿子3",  "imageUrl" : "https://raw.githubusercontent.com/onevcat/Kingfisher/master/images/kingfisher-1.jpg"],
        ["name" : "蛙儿子4",  "imageUrl" : "http://ww1.sinaimg.cn/large/5f9dbc69ly1fo7w1bzua0j20ic0abwf0.jpg"],
        ["name" : "蛙儿子5",  "imageUrl" : "http://ww1.sinaimg.cn/large/5f9dbc69ly1fo7w1bzua0j20ic0abwf0.jpg"],
        ["name" : "蛙儿子6",  "imageUrl" : "https://raw.githubusercontent.com/onevcat/Kingfisher/master/images/kingfisher-1.jpg"]]
    
    override func viewDidLoad() {
        self.title = "登录"
        
        self.idTextfield.borderStyle = UITextField.BorderStyle.roundedRect
        // 设置 提示字
        self.idTextfield.placeholder = "我是 UITextfield"
        // 设置 文字颜色   (颜色系统默认为 nil )
        self.idTextfield.textColor = UIColor.blue
        // 设置 文字大小
        self.idTextfield.font = UIFont.systemFont(ofSize: 15)
        // 设置 水平对齐
        self.idTextfield.textAlignment = NSTextAlignment.left // 居中对齐
        //       NSTextAlignment.left   // 左对齐
        //        NSTextAlignment.right  // 右对齐
        // 设置 文字超出文本框时自适应大小
        self.idTextfield.adjustsFontSizeToFitWidth = true
        // 设置 最小可缩小的字号
        self.idTextfield.minimumFontSize = 13
        // 设置 清理按钮 (.never 从不出现 .whileEditing 编辑时出现 .unlessEditing 编辑时不出现 编辑完后出现 .always 一直出现)
        self.idTextfield.clearButtonMode = UITextField.ViewMode.whileEditing
        //  设置 键盘样式
        self.idTextfield.keyboardType = UIKeyboardType.emailAddress
        // 设置 代理
        self.idTextfield.delegate = self
        
        for dict in jsonArray {
            let jsonData = JSON(dict)
            let model = CellModel(jsonData: jsonData)
            dataArray.append(model)
        }
        
        self.setupCollectionView()
        
    }
    
    deinit {
        DDLogDebug("LoginViewController 控制器释放")
    }
    
    
    
    func setupCollectionView() {
        let flowLayout = UICollectionViewFlowLayout.init()
        flowLayout.itemSize = CGSize.init(width: 100, height: 100)
        flowLayout.minimumLineSpacing = 10
        flowLayout.minimumInteritemSpacing = 10
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 150, width: 375, height: 500), collectionViewLayout: flowLayout);
        collectionView?.dataSource = self
        collectionView?.delegate = self
        collectionView?.backgroundColor = UIColor.white
        
        self.collectionView?.collectionViewLayout = flowLayout
        collectionView?.register(CollectionViewCell.self, forCellWithReuseIdentifier: CELL_ID)
        
        self.view .addSubview(self.collectionView!)
        
        // Snapkit使用示例
        collectionView?.snp.makeConstraints({ (make) -> Void in
            make.top.equalTo(self.view.snp.top).offset(150)
            make.right.left.equalTo(self.view)
            make.height.equalTo(500)
        })
    }
    
    // MARK: - UICollectionView 代理
    
    // 分区数
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    // 每个分区含有的 item 个数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataArray.count;
    }
    
    // 返回 cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_ID, for: indexPath as IndexPath) as! CollectionViewCell;
        
        let cell = CollectionViewCell.cellWithCollectionView(collectionView, indexPath: indexPath)
        let cellModel = self.dataArray[indexPath.row]
        cell.cellModel = cellModel
        
        return cell;
    }
    
    //item 对应的点击事件
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        DONG_Log("index is \(indexPath.row)");
    }
}

extension LoginViewController: UITextFieldDelegate {
    
    // 输入框询问是否可以编辑 true 可以编辑  false 不能编辑
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        DONG_Log("我要开始编辑了...")
        return   true
    }
    // 该方法代表输入框已经可以开始编辑  进入编辑状态
    func textFieldDidBeginEditing(_ textField: UITextField) {
        DONG_Log("我正在编辑状态中...")
    }
    // 输入框将要将要结束编辑
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        DONG_Log("我即将编辑结束...")
        return true
    }
    // 输入框结束编辑状态
    func textFieldDidEndEditing(_ textField: UITextField) {
        DONG_Log("我已经结束编辑状态...")
    } // 文本框是否可以清除内容
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true
    }
    // 输入框按下键盘 return 收回键盘
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    // 该方法当文本框内容出现变化时 及时获取文本最新内容
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        return true
    }
}

private let ID = "Collection"

class CollectionViewCell: UICollectionViewCell {
    
    var iconImage: UIImageView?
    var label: UILabel?

    var cellModel: CellModel? {
        willSet {
            self.label?.text = newValue?.name
            let url = URL(string: (newValue?.imageUrl!)!)
            // 1.SDWebImage
            //            self.iconIV.sd_setImage(with: url, placeholderImage: UIImage(named: "imageHolder"))
            // 2.Kingfisher
            self.iconImage?.kf.setImage(with: url, placeholder: UIImage(named: "imageHolder"))
        }
    }

    init(iconImage: UIImageView, label: UILabel, name: String, frame: CGRect) {
        self.iconImage = iconImage
        self.label = label
        super.init(frame: frame)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }
    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.iconImage?.snp.makeConstraints { (make) in
            make.left.top.equalTo(self.contentView).offset(2)
            make.right.equalTo(self.contentView.snp.right).offset(-2)
            make.height.equalTo(70)
        }

        self.label?.textAlignment = .center
        self.label?.snp.makeConstraints { (make) in
            make.top.equalTo(self.iconImage!.snp.bottom).offset(5)
            make.centerX.equalTo(self.iconImage!)
            make.size.equalTo(CGSize(width: 80, height: 20))
        }
    }

    // Xib 初始化
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.red
    }
    
    func setupUI() {
        self.backgroundColor = UIColor.red
        self.iconImage = UIImageView(image: UIImage(named: "imageHolder"))
        self.label = UILabel()
        self.label?.text = "label"
        self.contentView.addSubview(self.iconImage!)
        self.contentView.addSubview(self.label!)
    }
    
    class func cellWithCollectionView(_ collectionView : UICollectionView , indexPath : IndexPath) -> CollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_ID, for: indexPath) as! CollectionViewCell
        return cell
    }

}



