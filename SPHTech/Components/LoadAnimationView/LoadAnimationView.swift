//
//  LoadAnimationView.swift
//  SPHTech
//
//  Created by creazylee on 2020/6/29.
//  Copyright © 2020 creazylee. All rights reserved.
//

import UIKit


protocol LoadAnimationViewDelegate {
    func loadAnimationViewNeedReloadView()
}

enum LoadAnimationStatus {
    case loading
    case success
    case error
}

class LoadAnimationView: UIView {
    
    var delegate: LoadAnimationViewDelegate?
    
    private lazy var activityView: UIActivityIndicatorView = {
        let tmpActivityView = UIActivityIndicatorView.init(style: .gray)
        tmpActivityView.center = self.center
        tmpActivityView.isHidden = true
        self.addSubview(tmpActivityView)
        return tmpActivityView
    }()
    
    private lazy var errorContentView: UIView = {
        let tmpView = UIView.init(frame: self.bounds)
        tmpView.backgroundColor = UIColor.white
        self.addSubview(tmpView)
        return tmpView
    }()
    
    private lazy var errorMsgLabel: UILabel = {
        let errorLabel = UILabel.init(frame: CGRect.init(x: 15, y: self.bounds.size.height/2 - 10, width: self.bounds.size.width - 30, height: 20))
        errorLabel.font = UIFont.systemFont(ofSize: 15)
        errorLabel.textColor = UIColor.black
        errorLabel.text = "加载失败，点击重新加载"
        errorLabel.textAlignment = NSTextAlignment.center
        self.errorContentView.addSubview(errorLabel)
        return errorLabel
    }()
    
    private lazy var reloadButton: UIButton = {
        let button = UIButton.init(frame: CGRect.init(x: self.frame.size.width/2 - 88/2, y: self.errorMsgLabel.frame.maxY + 6, width: 88, height: 36))
        button.backgroundColor = UIColor.hexColor("#428eda")
        button.setTitle("重新加载", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.layer.cornerRadius = 4
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(clickReload), for: .touchUpInside)
        self.errorContentView.addSubview(button)
        return button
    }()
    
    @objc func clickReload() {
        self.delegate?.loadAnimationViewNeedReloadView()
    }
    
    var loadStatus: LoadAnimationStatus! {
        didSet {
            self.refreshUI()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.loadStatus = .loading
    }

    private func refreshUI() {
        switch self.loadStatus {
        case .loading:
            self.activityView.isHidden = false
            self.activityView.startAnimating()
            self.errorContentView.isHidden = true
            self.isHidden = false
            break
        case .success:
            self.activityView.isHidden = true
            self.errorContentView.isHidden = true
            self.isHidden = true
            break
        case .error:
            self.activityView.isHidden = true
            self.errorContentView.isHidden = false
            self.errorMsgLabel.isHidden = false
            self.reloadButton.isHidden = false
            self.isHidden = false
            break
        case .none: break
            
        }
    }
    
}
