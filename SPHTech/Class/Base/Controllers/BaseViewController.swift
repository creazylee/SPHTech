//
//  BaseViewController.swift
//  SPHTech
//
//  Created by creazylee on 2020/6/28.
//  Copyright © 2020 creazylee. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController,LoadAnimationViewDelegate {
    
    func loadAnimationViewNeedReloadView() {
        
    }
        
    private lazy var loadAnimationView: LoadAnimationView = {
        let loadView = LoadAnimationView.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - NavigationHeight))
        loadView.isHidden = true
        loadView.backgroundColor = UIColor.white
        loadView.delegate = self
        self.view.addSubview(loadView)
        return loadView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = []
    }
    
    func showLoadAnimation() {
        self.loadAnimationView.loadStatus = .loading
    }
    
    func loadAnimationSuccess() {
        self.loadAnimationView.loadStatus = .success
    }
    
    func loadAnimationWithError() {
        self.loadAnimationView.loadStatus = .error
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
