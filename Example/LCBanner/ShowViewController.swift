//
//  ShowViewController.swift
//  LCBanner_Example
//
//  Created by 卢荫豪 on 2020/4/25.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import LCBanner
let cellReuseId = "cellReuseId"
class ShowViewController: UIViewController {
    var lastIndex = -1
    let colors = [UIColor.red,UIColor.purple,UIColor.green,UIColor.yellow,UIColor.purple]
    
    //MARK: - INITILAL
    init(style: LCBannerStyle) {
        self.bannerStyle = style
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.bannerStyle = .unknown
        super.init(coder: aDecoder)
    }
    
    deinit {
        NSLog("[%@ -- %@]", NSStringFromClass(self.classForCoder), #function)
    }
    
    //MARK: - LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.bannerView.bannerWillAppear()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.bannerView.bannerWillDisAppear()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK: - PROPERTY
    let bannerStyle: LCBannerStyle
    
    let imgNames = ["1.jpg",
                    "2.jpg",
                    "3.jpg",
                    "4.jpg",
                    "5.jpg"]
    
    lazy var bannerView: LCBanner = {
        let layout = LCSwiftFlowLayout.init(style: self.bannerStyle == LCBannerStyle.unknown ? .normal : self.bannerStyle)
        let banner = LCBanner.init(frame: CGRect.init(x: 0, y: 100, width: UIScreen.main.bounds.width, height: 240), flowLayout: layout, delegate: self)
        self.view.addSubview(banner)
        banner.backgroundColor = self.view.backgroundColor
        
        ///自定义的cell(当然,任何风格的都可以自定义cell)
        if self.bannerStyle == .unknown{
            banner.banner.register(UINib.init(nibName: "CustomCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: cellReuseId)
        }else{
            banner.banner.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellReuseId)
        }
        ///是否开启自动滚动 默认 否
        banner.autoPlay = true
        ///是否无限轮播 默认 是
        banner.endless = true
        ///滚动时间间隔 默认 3s
        banner.timeInterval = 2
        
        
        return banner
    }()
}

//MARK: - LCBannerDelegate
extension ShowViewController: LCBannerDelegate {
    
    
    
    
    public  func bannerNumbers() -> Int {
        return self.imgNames.count
    }
    
    func bannerView(banner: LCBanner, index: Int, indexPath: IndexPath) -> UICollectionViewCell {
        if self.bannerStyle == .unknown {
            let cell:CustomCollectionViewCell = banner.banner.dequeueReusableCell(withReuseIdentifier: cellReuseId, for: indexPath) as! CustomCollectionViewCell
            cell.imgView.image = UIImage.init(named:imgNames[index])
            cell.titLabel.text = "\(index)"
            return cell
            
        }else{
            let cell = banner.banner.dequeueReusableCell(withReuseIdentifier: cellReuseId, for: indexPath)
            var imgView = cell.contentView.viewWithTag(999)
            var label = cell.contentView.viewWithTag(888)
            if imgView == nil {
                imgView = UIImageView.init(frame: cell.contentView.bounds)
                imgView?.tag = 999
                cell.contentView.addSubview(imgView!)
                imgView?.layer.cornerRadius = 4.0
                imgView?.layer.masksToBounds = true
                
                label = UILabel.init(frame: CGRect.init(x: 30, y: 0, width: 60, height: 30))
                (label as! UILabel).textColor = UIColor.white
                (label as! UILabel).font = UIFont.systemFont(ofSize: 21)
                label?.tag = 888
                cell.contentView.addSubview(label!)
            }
            (imgView as! UIImageView).image = UIImage.init(named: self.imgNames[index])
            (label as! UILabel).text = "\(index)"
            return cell
        }
    }
    
    func didSelected(banner: LCBanner, index: Int, indexPath: IndexPath) {
        print("📳点击 \(index) click...")
    }
    
    func didStartScroll(banner: LCBanner, index: Int, indexPath: IndexPath) {
        if banner.isScroll == false {
            print("✋手动开始滑动: \(index) ==\(indexPath.row) ...")
        }else{
            //            print("🚗自动开始滑动: \(index) ==\(indexPath.row)...")
        }
    }
    
    func didEndScroll(banner: LCBanner, index: Int, indexPath: IndexPath) {
        if banner.isScroll == false {
            print("🤚手动结束滑动: \(index) ==\(indexPath.row) ...")
        }else{
            print("🚗自动结束滑动: \(index) ==\(indexPath.row) ...")
            
        }
        
    }
    func scrollOffet(banner: LCBanner, index: Int, indexPath: IndexPath, offset: CGFloat) {
        print("🚄滚动偏移量: \(index) ==\(offset) ...")
        
    }
    
    
    
    
    
}

// MARK: - CONFIGURE UI
extension ShowViewController {
    fileprivate func configureUI() {
        self.view.backgroundColor = UIColor.white
        self.navigationItem.title = "show"
        self.bannerView.freshBanner()
        self.automaticallyAdjustsScrollViewInsets = false
    }
}
