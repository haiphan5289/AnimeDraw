//
//  HomeTabbar.swift
//  SoundRain
//
//  Created by Phan Hai on 22/08/2020.
//  Copyright © 2020 Phan Hai. All rights reserved.
//

import UIKit

enum HomeType: Int, CaseIterable {
    case step
    case tutorials
    case bookmarks
    
    var text: String {
        switch self {
        case .step:
            return "Step by Step"
        case .tutorials:
            return "Tutorials"
        case .bookmarks:
            return "Bookmarks"
        }
    }
    var img: UIImage? {
        switch self {
        case .step:
            return UIImage(named: "ic_step")
        case .tutorials:
            return UIImage(named: "ic_tutorial")
        case .bookmarks:
            return UIImage(named: "ic_bookmark")
        }
    }
}

class HomeTabbar: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        visualize()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
}
extension HomeTabbar {
    private func visualize() {
        self.view.backgroundColor = .white
        
    }
}
