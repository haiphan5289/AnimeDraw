//
//  DisplayTutorialVC.swift
//  AnimeDraw
//
//  Created by paxcreation on 12/14/20.
//

import UIKit
import RxCocoa
import RxSwift

class DisplayTutorialVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var titleDisplay: String = ""
    @VariableReplay private var listImage: [DisplayTutorialModel] = []
    private let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.visualize()
        self.setupRX()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
}
extension DisplayTutorialVC {
    private func visualize() {
        self.navigationItem.title = self.titleDisplay
        tableView.delegate = self
        tableView.register(DisplayTutorialCell.nib, forCellReuseIdentifier: DisplayTutorialCell.identifier)
    }
    private func setupRX() {
        self.$listImage.asObservable()
            .bind(to: tableView.rx.items(cellIdentifier: DisplayTutorialCell.identifier, cellType: DisplayTutorialCell.self)) {(row, element, cell) in
                if let content = element.text {
                    cell.lbContent.text = content
                    cell.hLabel.constant = content.getTextSizeNoteView(fontSize: 15, width: self.view.bounds.width, height: 1000).height + 50
                } else {
                    cell.hLabel.constant = 0
                    cell.lbContent.text = ""
                }
                if let img = element.image {
                    cell.img.image = UIImage(named: img)
                    cell.img.isHidden = false
                    cell.hImage.constant = 299
                } else {
                    cell.img.isHidden = true
                    cell.hImage.constant = 0
                }
        }.disposed(by: disposeBag)
        
        ReadJSON.shared.readJSONObs(offType: [DisplayTutorialModel].self, name: self.titleDisplay, type: TypeJSON.json.rawValue)
            .subscribe { [weak self] (result) in
                guard let wSelf = self else {
                    return
                }
                switch result {
                case .success(let data):
                    wSelf.listImage = data
                case .failure(let err):
                    print("\(err)")
                }
            } onError: { (err) in
                print("\(err.localizedDescription)")
            }.disposed(by: disposeBag)
    }
}
extension DisplayTutorialVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
}

