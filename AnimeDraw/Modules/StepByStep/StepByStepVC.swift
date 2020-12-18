//
//  StepByStepVC.swift
//  AnimeDraw
//
//  Created by haiphan on 12/5/20.
//

import UIKit
import RxSwift
import RxCocoa
import DZNEmptyDataSet
import ViewAnimator
import SnapKit
import GoogleMobileAds

enum TypeJSON: String {
    case json
}

class StepByStepVC: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var navigation: UINavigationItem!
    @IBOutlet weak var searchBar: UISearchBar!
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
    @VariableReplay private var listAnime: [StepModel] = []
    @VariableReplay private var listAnimeSearch: [StepModel] = []
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.visualize()
        self.setupRX()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        self.hidesBottomBarWhenPushed = false
        guard let navigationController = navigationController else { return }
            navigationController.navigationBar.prefersLargeTitles = true
            navigationItem.largeTitleDisplayMode = .automatic
            navigationController.navigationBar.sizeToFit()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
}
extension StepByStepVC {
    private func visualize() {
        collectionView.delegate = self
        collectionView.register(StepCell.nib, forCellWithReuseIdentifier: StepCell.identifier)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        title = "Step by Step"
        self.navigationItem.title = "Step by Step"
        searchBar.backgroundImage = UIImage()
        
        
        banner.rootViewController = self
        self.view.addSubview(banner)
        banner.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(50)
            make.width.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
    private func setupRX() {
        self.$listAnime.asObservable()
            .bind(to: collectionView.rx.items(cellIdentifier: StepCell.identifier, cellType: StepCell.self)) { row, data, cell in
                cell.lbName.text = data.text
                cell.lbName.sizeToFit()
                cell.img.image = UIImage(named: data.image ?? "")
            }.disposed(by: disposeBag)
        
        ReadJSON.shared.readJSONObs(offType: [StepModel].self, name: "Step by Step", type: TypeJSON.json.rawValue)
            .subscribe { [weak self] (result) in
                guard let wSelf = self else {
                    return
                }
                switch result {
                case .success(let data):
                    wSelf.listAnime = data
                    wSelf.listAnimeSearch = data
                case .failure(let err):
                    print("\(err)")
                }
            } onError: { (err) in
                print("\(err.localizedDescription)")
            }.disposed(by: disposeBag)
        
        collectionView.rx.itemSelected.bind { [weak self] (idx) in
            guard let wSelf = self else {
                return
            }
            let vc = StepDetail(nibName: "StepDetail", bundle: nil)
            let item = self?.listAnime[idx.row]
            vc.anime = item
            vc.hidesBottomBarWhenPushed = true
            wSelf.navigationController?.pushViewController(vc, animated: true)
        }.disposed(by: disposeBag)
        
        self.searchBar.rx.text.withLatestFrom(self.$listAnimeSearch) { (text, list) -> [StepModel] in
            guard let text = text, text != "" else {
                return list
            }
            return list.filter { ($0.text?.lowercased().contains(text.lowercased()) ?? false) }
        }.bind(onNext: weakify({ (listSearch, wSelf) in
            wSelf.listAnime = listSearch
        })).disposed(by: disposeBag)
        
    }
}
extension StepByStepVC: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (self.view.bounds.width - 30) / 2 , height: 200)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.collectionView.reloadData()
    }
}
