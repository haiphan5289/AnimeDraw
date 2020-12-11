//
//  StepDetail.swift
//  AnimeDraw
//
//  Created by haiphan on 12/11/20.
//

import UIKit
import RxCocoa
import RxSwift

class StepDetail: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
}
