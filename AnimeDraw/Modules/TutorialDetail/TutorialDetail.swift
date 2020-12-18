//
//  TutorialDetail.swift
//  AnimeDraw
//
//  Created by paxcreation on 12/14/20.
//

import UIKit
import RxCocoa
import RxSwift
import GoogleMobileAds

class TutorialDetail: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var titleTutorial: String = ""
    @VariableReplay private var listImage: [StepModel] = []
    private let banner: GADBannerView = {
       let b = GADBannerView()
        //source
//        ca-app-pub-3940256099942544/2934735716
        //drawanime
        //ca-app-pub-1498500288840011/7599119385
        //ca-app-pub-1498500288840011/7599119385
        b.adUnitID = AdModId.share.bannerID
        b.load(GADRequest())
        b.adSize = kGADAdSizeSmartBannerPortrait
        b.backgroundColor = .secondarySystemBackground
        return b
    }()
    private let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        banner.rootViewController = self
        self.view.addSubview(banner)
        banner.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(50)
            make.width.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
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
extension TutorialDetail {
    private func visualize() {
        self.navigationItem.title = self.titleTutorial
        tableView.delegate = self
        tableView.register(TutorialDetailCell.nib, forCellReuseIdentifier: TutorialDetailCell.identifier)
        
    }
    private func setupRX() {
        self.$listImage.asObservable()
            .bind(to: tableView.rx.items(cellIdentifier: TutorialDetailCell.identifier, cellType: TutorialDetailCell.self)) {(row, element, cell) in
                cell.textLabel?.text = element.text
        }.disposed(by: disposeBag)
        
        self.tableView.rx.itemSelected.bind { [weak self] (idx) in
            guard let wSelf = self else {
                return
            }
            let vc = DisplayTutorialVC(nibName: "DisplayTutorialVC", bundle: nil)
            let item = wSelf.listImage[idx.row]
            vc.anime = item
            wSelf.navigationController?.pushViewController(vc, animated: true)
        }.disposed(by: disposeBag)
        
        ReadJSON.shared.readJSONObs(offType: [StepModel].self, name: self.titleTutorial, type: TypeJSON.json.rawValue)
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
extension TutorialDetail: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
}
extension TutorialDetail: GADAdLoaderDelegate {
    func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: GADRequestError) {
        
    }
    
    
}
