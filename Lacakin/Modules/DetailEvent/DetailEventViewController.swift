//  
//  DetailEventViewController.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 16/06/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import UIKit
import RxSwift
import GoogleMaps
import GooglePlaces
import Alamofire

class DetailEventViewController: BaseViewController {
    
    @IBOutlet var bgTicketView: UIView!
    @IBOutlet var bgGestureTicketView: UIView!
    @IBOutlet var titlePackageLabel: UILabel!
    @IBOutlet var subtitlePackageLabel: UILabel!
    @IBOutlet var pricePackageLabel: UILabel!
    @IBOutlet var quotaPackageLabel: UILabel!
    @IBOutlet var buyTicketButton: UIButton!
    @IBOutlet var packageCollectionView: UICollectionView!
    @IBOutlet var equipmentPackageLabel: UILabel!
    @IBOutlet var heightPackageViewCons: NSLayoutConstraint! // 380 vs 210
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var ticketView: UIView!
    @IBOutlet weak var topImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var toDateLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var mapView: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var fromToDateLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var topEventViewConst: NSLayoutConstraint! // 200
    @IBOutlet weak var heightEventViewConst: NSLayoutConstraint! // 400
    @IBOutlet weak var heightBgViewConst: NSLayoutConstraint! // 875
    
    var map: GMSMapView?
    var viewModel: DetailEventViewModel!
    var coordinator: DetailEventCoordinator!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bindViewModel()
        viewModel.inputs.onViewDidLoad()
    }
}

// MARK: Private

extension DetailEventViewController {
    
    func setupViews() {
        initCollectionView()
        backButton.addTarget(self, action: #selector(back), for: .touchUpInside)
    }
    
    func initCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerNib(DetailEventCollectionViewCell.self)
        
        packageCollectionView.delegate = self
        packageCollectionView.dataSource = self
        packageCollectionView.registerNib(DetailEventCollectionViewCell.self)
    }
    
    func setupTicketView(with index: Int) {
        let gesture = UIGestureRecognizer.init(target: self, action: #selector(dismissView))
        bgGestureTicketView.addGestureRecognizer(gesture)
        guard let model = viewModel.model else { return }
        let selectedIndex = model.eventPackages?[index]
        if selectedIndex?.packageEquipments?.count ?? 0 == 0 {
            heightPackageViewCons.constant = 210
        }
        titlePackageLabel.text = selectedIndex?.packageName ?? ""
        subtitlePackageLabel.text = selectedIndex?.packageDesc ?? ""
        let price = "\(selectedIndex?.packagePrice ?? 0)"
        if price == "0" {
            pricePackageLabel.text = "Free"
        } else {
            let filterPrice = price.dropLast(3)
            pricePackageLabel.text = "\(filterPrice)K"
        }
        quotaPackageLabel.text = "Quota: \(selectedIndex?.packageQuota ?? 0) People"
        buyTicketButton.addTarget(self, action: #selector(buyTicket), for: .touchUpInside)
    }
    
    func setupData() {
        guard let model = viewModel.model else { return }
        if let photoURL = model.eventPhoto?.photoUrl {
            let url = URL(string: photoURL)
            topImageView.kf.setImage(with: url, placeholder: UIImage(named: ""))
        } else {
            DispatchQueue.main.async {
                self.topEventViewConst.constant = 64
                self.heightBgViewConst.constant = 739
            }
        }
        nameLabel.text = model.eventName ?? ""
        typeLabel.text = model.eventType ?? ""
        locationLabel.text = model.eventLocation
        let toDat = Date(timeIntervalSince1970: TimeInterval(model.eventStartDateUnix ?? 0))
        let dateOpen = Date(timeIntervalSince1970: TimeInterval(model.eventRegistrationOpenDateUnix ?? 0))
        let dateClose = Date(timeIntervalSince1970: TimeInterval(model.eventRegistrationCloseDateUnix ?? 0))
        toDateLabel.text = "\(toDat.dateToStringStandart())"
        descLabel.text = model.eventDescription ?? ""
        descLabel.sizeToFit()
        descLabel.layoutIfNeeded()
        let close = model.isRegClose ?? "0"
        statusLabel.layer.cornerRadius = 6
        statusLabel.layer.masksToBounds = true
        if close == "0" {
            statusLabel.text = "  Opened  "
            statusLabel.backgroundColor = UIColor.init(red: 61.0/255.0, green: 182.0/255.0, blue: 122.0/255.0, alpha: 1.0)
        } else {
            statusLabel.text = "  Closed  "
            statusLabel.backgroundColor = UIColor.red
        }
        fromToDateLabel.text = "\(dateOpen.dateToStringStandart()) - \(dateClose.dateToStringStandart())"
//        let expired = model.paymentIsExpired ?? 0
//        if expired == 1 {
//            statusLabel.text = "  Expired  "
//            statusLabel.backgroundColor = UIColor.red
//        }
        let lat = model.eventLocationLatitude ?? -6.21462
        let lng = model.eventLocationLongitude ?? 106.84513
        let camera = GMSCameraPosition.camera(withLatitude: (Double(lat)), longitude: (Double(lng)), zoom: 14)
        map = GMSMapView.map(withFrame: CGRect(x: 0, y: 0, width: mapView.frame.size.width, height: mapView.frame.size.height), camera: camera)
        map!.isMyLocationEnabled = false
        mapView.addSubview(map!)
        mapView.sendSubviewToBack(map!)
        mapView.isUserInteractionEnabled = false
        
        let latStart = model.eventStartPointLatitude ?? -6.21462
        let lngStart = model.eventStartPointLongitude ?? 106.84513
        let origin = "\(lat),\(lng)"
        let destination = "\(latStart),\(lngStart)"
        let urlMaps = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=driving&key=AIzaSyBGSAUhiZ7hlffCv7FnHou2Q4klOO6AOkQ"
        
        Alamofire.request(urlMaps).responseJSON { response in
            do {
                if let json : [String:Any] = try JSONSerialization.jsonObject(with: response.data!, options: .allowFragments) as? [String: Any] {
                    let routes = json["routes"] as? [Any]
                    let overviewPolyline = routes?[0] as? [String:Any]
                    let polyObject = overviewPolyline?["overview_polyline"] as? AnyObject
                    let polyString = polyObject?["points"] as? String
                    let path = GMSPath(fromEncodedPath: polyString ?? "")
                    let polyline = GMSPolyline(path: path)
                    polyline.strokeColor = .defaultBlue
                    polyline.strokeWidth = 3.0
                    polyline.map = self.map
                }
            } catch {
                print("error in JSONSerialization")
            }
        }
        collectionView.reloadData()
    }
    
    func bindViewModel() {
        observeUpdate()
        observeError()
    }
    
    func observeUpdate() {
        viewModel.outputs.update
            .subscribe(onNext: { [weak self] _ in
                self?.setupData()
            })
            .disposed(by: disposeBag)
    }
    
    func observeError() {
        viewModel.outputs.errorString
            .subscribe(onNext: { [unowned self] error in
                ToastView.show(message: error, in: self, length: .short)
            })
            .disposed(by: disposeBag)
    }
    
    @objc func back() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func buyTicket() {
        
    }
    
    @objc func dismissView() {
        UIView.animate(withDuration: 0.33) {
            self.bgTicketView.isHidden = true
        }
    }
}

extension DetailEventViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.model?.eventPackages?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueClass(indexPath,
                                               DetailEventCollectionViewCell.self)
        guard let model = viewModel.model?.eventPackages?[indexPath.row] else {
            return cell
        }
        cell.configure(model: model)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let model = viewModel.model else { return }
        let close = model.isRegClose ?? "0"
        if close == "0" {
//            let vc = EmptyViewController()
//            self.navigationController?.pushViewController(vc, animated: true)
            ToastView.show(message: "Event is closed", in: self, length: .short)
//            setupTicketView(with: indexPath.row)
//            UIView.animate(withDuration: 0.33) {
//                self.bgTicketView.isHidden = false
//            }
        } else {
//            let vc = EmptyViewController()
//            self.navigationController?.pushViewController(vc, animated: true)
//            ToastView.show(message: "Event is closed", in: self, length: .short)
        }
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        
        let width = CGFloat(200)
        let height = CGFloat(128)
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 0, left: 16, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
}
