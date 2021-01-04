//
//  DisplayTutorialVC.swift
//  AnimeDraw
//
//  Created by paxcreation on 12/14/20.
//

import UIKit
import RxCocoa
import RxSwift
import GoogleMobileAds

class DisplayTutorialVC: UIViewController, GADRewardedAdDelegate {

    @IBOutlet weak var tableView: UITableView!
    var anime: StepModel?
    @VariableReplay private var listImage: [DisplayTutorialModel] = []
    @VariableReplay private var listTutorialRealm: [StepModel] = []
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
    private var interstitial: GADInterstitial!
    private var rewardedAd: GADRewardedAd?
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
        self.navigationItem.title = self.anime?.text
        tableView.delegate = self
        tableView.register(DisplayTutorialCell.nib, forCellReuseIdentifier: DisplayTutorialCell.identifier)
        
        let btPlus: UIButton = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: 50, height: 50)))
        btPlus.setImage(UIImage(systemName: "plus"), for: .normal)
        btPlus.setTitleColor(.black, for: .normal)
        btPlus.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let rightBarButton = UIBarButtonItem(customView: btPlus)
        navigationItem.rightBarButtonItem = rightBarButton
        btPlus.rx.tap.bind { [weak self] _ in
            guard let wSelf = self, let item = wSelf.anime else {
                return
            }
            wSelf.showAlert(msg: "Do you want to add in BookMarks", buttonTitle: ["Cancel", "OK"]) { (index) in
                if index == 1 {
                    RealmManage.share.addTutorial(model: item)
                }
            }
            
        }.disposed(by: disposeBag)
        
        self.listTutorialRealm = RealmManage.share.getTutorial()
        
        self.$listTutorialRealm.asObservable().bind { [weak self] (l) in
            guard let wSelf = self, let anime = wSelf.anime else {
                return
            }
            for i in l where i.text == anime.text {
                btPlus.isHidden = true
            }
        }.disposed(by: disposeBag)
        
//        banner.rootViewController = self
//        self.view.addSubview(banner)
//        banner.snp.makeConstraints { (make) in
//            make.left.right.equalToSuperview()
//            make.height.equalTo(50)
//            make.width.equalToSuperview()
//            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
//        }
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
                
                if row == 4 {
                    self.interstitial = GADInterstitial(adUnitID: AdModId.share.interstitialID)
                    let request = GADRequest()
                    self.interstitial.load(request)
                    self.interstitial.delegate = self
                }
                
                if row == self.listImage.count - 1 {
                    self.rewardedAd?.present(fromRootViewController: self, delegate: self)
                }
        }.disposed(by: disposeBag)
        
        guard let title = self.anime?.text else {
            return
        }
        
        ReadJSON.shared.readJSONObs(offType: [DisplayTutorialModel].self, name: title, type: TypeJSON.json.rawValue)
            .subscribe { [weak self] (result) in
                guard let wSelf = self else {
                    return
                }
                switch result {
                case .success(let data):
                    wSelf.listImage = data
                case .failure(let err):
                    print("\(err.localizedDescription)")
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

extension DisplayTutorialVC: GADInterstitialDelegate {
    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
        interstitial.present(fromRootViewController: self)
    }
}
extension DisplayTutorialVC {
    /// Tells the delegate that the user earned a reward.
    func rewardedAd(_ rewardedAd: GADRewardedAd, userDidEarn reward: GADAdReward) {
      print("Reward received with currency: \(reward.type), amount \(reward.amount).")
    }
    /// Tells the delegate that the rewarded ad was presented.
    func rewardedAdDidPresent(_ rewardedAd: GADRewardedAd) {
      print("Rewarded ad presented.")
    }
    /// Tells the delegate that the rewarded ad was dismissed.
    func rewardedAdDidDismiss(_ rewardedAd: GADRewardedAd) {
      print("Rewarded ad dismissed.")
    }
    /// Tells the delegate that the rewarded ad failed to present.
    func rewardedAd(_ rewardedAd: GADRewardedAd, didFailToPresentWithError error: Error) {
      print("Rewarded ad failed to present.")
    }
}
