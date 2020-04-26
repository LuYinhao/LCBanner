//
//  ViewController.swift
//  LCBanner
//
//  Created by 卢荫豪 on 04/25/2020.
//  Copyright (c) 2020 卢荫豪. All rights reserved.
//

import UIKit
import LCBanner
class ViewController: UIViewController {
    
    //MARK: - Property
    @IBOutlet weak var listView: UITableView!
    /// 选项数据源
    let titles = ["默认样式",
                  "可以看到前后两张(正常样式)",
                  "可以看到前后两张(两边缩放)",
                  "可以看到前后两张(中间一张放大)",
                  "自定义cell"]
    
    let types = [LCBannerStyle.normal,
                 LCBannerStyle.preview_normal,
                 LCBannerStyle.preview_zoom,
                 LCBannerStyle.preview_big,
                 LCBannerStyle.unknown]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "LCBanner"
        self.configureUI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func configureUI () {
        self.view.backgroundColor = UIColor.white
        self.automaticallyAdjustsScrollViewInsets = false;
        self.listView.tableFooterView = UIView.init()
    }
    
}
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    // cell selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let type = self.types[indexPath.row]
        let showVC = ShowViewController.init(style: type)
        showVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(showVC, animated: true)
    }
    
    // cell numbers
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.titles.count
    }
    
    // cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let idStr = "cellId"
        var cell = tableView.dequeueReusableCell(withIdentifier: idStr)
        if cell == nil {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: idStr)
            cell?.accessoryType = .disclosureIndicator
        }
        cell?.textLabel?.text = self.titles[indexPath.row]
        return cell!
    }
    
    // cell height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
}
