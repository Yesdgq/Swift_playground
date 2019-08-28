//
//  GitHubInfoViewController.swift
//  Swift_playground
//
//  Created by yesdgq on 2019/8/20.
//  Copyright © 2019 yesdgq. All rights reserved.
//  MVVM demo

import Foundation
import RxSwift
import RxCocoa

class GitHubInfoVC: UIViewController {
    
    var tableView: UITableView!
    var searchBar: UISearchBar!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView = UITableView(frame: self.view.bounds, style: .plain)
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.view.addSubview(self.tableView)
        
        //创建表头搜索栏
        self.searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 56))
        self.tableView.tableHeaderView = self.searchBar
        
        //查询条件输入
        let searchAction = searchBar.rx.text.orEmpty //orEmpty可以将String?类型的ControlProperty转成String
            .throttle(0.5, scheduler: MainScheduler.instance) //只有间隔超过0.5秒才发送
            .distinctUntilChanged() //过滤掉连续重复的事件
            .asObservable()

        
        //初始化viewModel
        let viewModel = GitHubViewModel(searchAction: searchAction)
        
        //绑定导航栏标题数据
        viewModel.navigationTitle.bind(to: self.navigationItem.rx.title).disposed(by: disposeBag)
        
        //将数据绑定到表格
        viewModel.repositories.bind(to: tableView.rx.items) {
            (tableView, row, element) in
            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
            cell.textLabel?.text = element.name
            cell.detailTextLabel?.text = element.htmlUrl
            return cell
        }.disposed(by: disposeBag)
        
        //单元格点击
        tableView.rx.modelSelected(GitHubRepository.self)
            .subscribe(onNext: {[weak self] item in
                
                //显示资源问题
                self?.showAlert(tittle: item.fullName, message: item.description)
            }).disposed(by: disposeBag)
        
    }
    
    
    //显示消息
    func showAlert(tittle: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "确定", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
       super.didReceiveMemoryWarning()
    }
    
    
    
    
    
}
