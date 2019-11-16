//  
//  DetailActivityViewController.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 03/03/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import UIKit
import RxSwift
import GoogleMaps
import Photos
import PhotosUI
import GSImageViewerController
import Polyline

class DetailActivityViewController: BaseViewController {

    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet weak var addRouteView: UIView!
    @IBOutlet weak var addRouteButton: UIButton!
    @IBOutlet weak var multipleImageActivityButton: UIButton!
    @IBOutlet weak var countListImageActivityLabel: UILabel!
    @IBOutlet weak var openLikeVCButton: UIButton!
    @IBOutlet weak var addImageLabel: UILabel!
    @IBOutlet weak var noImageView: UIImageView!
    @IBOutlet weak var heightBgImageView: NSLayoutConstraint!
    @IBOutlet weak var editImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var joinButton: UIButton!
    @IBOutlet weak var heightBgView: NSLayoutConstraint!
    @IBOutlet weak var heightJoinButton: NSLayoutConstraint!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var statusDateLabel: UILabel!
    @IBOutlet weak var topParticipantConstraint: NSLayoutConstraint!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var privateLabel: UILabel!
    @IBOutlet weak var privateImageView: UIImageView!
    @IBOutlet weak var approvalLabel: UILabel!
    @IBOutlet weak var approvalImageView: UIImageView!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var descTextView: UITextView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var userLikeImageView: UIImageView!
    @IBOutlet weak var widthUserLikeConstraint: NSLayoutConstraint!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var shareCodeView: UIView!
    @IBOutlet weak var shareCodeButton: UIButton!
    @IBOutlet weak var shareCodeLabel: UILabel!
    @IBOutlet weak var participantButton: UIButton!
    @IBOutlet weak var participantLabel: UILabel!
    @IBOutlet weak var arrowImage: UIImageView!
    @IBOutlet weak var firstImageView: UIImageView!
    @IBOutlet weak var mapView: UIView!
    @IBOutlet weak var multipleImageUIView: UIView!
    @IBOutlet weak var mapButton: UIButton!
    @IBOutlet weak var multipleImageButton: UIButton!
    
    var imageSend: UIImage = UIImage()
    var isPushReady = false
    var isParticipantOn = false
    var locationManager = CLLocationManager()
    var shareName = ""
    
    var map: GMSMapView?
    var viewModel: DetailActivityViewModel!
    var coordinator: DetailActivityCoordinator!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bindViewModel()
        viewModel.inputs.onViewDidLoad()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateComment),
            name: NSNotification.Name(rawValue: "updateComment"),
            object: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updatePhotos),
            name: NSNotification.Name(rawValue: "updatePhotos"),
            object: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateDetailActivity),
            name: NSNotification.Name(rawValue: "updateDetailActivity"),
            object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if isPushReady {
            isPushReady = false
            let vc = UploadPhotoViewController()
            vc.actId = viewModel.actId
            vc.image = imageSend
            navigationController?.pushViewController(vc, animated: false)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
}

// MARK: Private

extension DetailActivityViewController {
    
    func setupViews() {
        initTableView()
        initCollectionView()
        addLeftBackButton(#selector(back))
        addDefaultTitleNav(title: "Detail")
        joinButton.addTarget(self, action: #selector(join), for: .touchUpInside)
        editButton.addTarget(self, action: #selector(edit), for: .touchUpInside)
        mapButton.addTarget(self, action: #selector(goToMap), for: .touchUpInside)
        multipleImageButton.addTarget(self, action: #selector(addImage), for: .touchUpInside)
        multipleImageActivityButton.addTarget(self, action: #selector(goToListImage), for: .touchUpInside)
        openLikeVCButton.addTarget(self, action: #selector(likeVC), for: .touchUpInside)
        likeButton.addTarget(self, action: #selector(like), for: .touchUpInside)
        commentButton.addTarget(self, action: #selector(comment), for: .touchUpInside)
        shareCodeButton.addTarget(self, action: #selector(share), for: .touchUpInside)
        participantButton.addTarget(self, action: #selector(participant), for: .touchUpInside)
        addRouteButton.addTarget(self, action: #selector(addRoute), for: .touchUpInside)
        shareCodeView.layer.cornerRadius = 5
        shareCodeView.layer.borderWidth = 1
        shareCodeView.layer.borderColor = UIColor.black.withAlphaComponent(0.2).cgColor
        editButton.layer.cornerRadius = 5
        editButton.layer.borderWidth = 1
        editButton.layer.borderColor = UIColor.black.withAlphaComponent(0.2).cgColor
        let height = UIScreen.main.bounds.height
        topParticipantConstraint.constant = height - 50
        arrowImage.image = UIImage(named: "arrow_top")
        //Photos
        let photos = PHPhotoLibrary.authorizationStatus()
        if photos == .notDetermined {
            PHPhotoLibrary.requestAuthorization({status in
                if status == .authorized{
                    print("authorized")
                } else {
                    print("decline")
                }
            })
        }
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
        }
        scrollView.contentInset = UIEdgeInsets(top: 64, left: 0, bottom: 0, right: 0)
        firstImageView.contentMode = .scaleAspectFill
        firstImageView.clipsToBounds = true
    }
    
    func initCollectionView() {
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
        imageCollectionView.registerNib(ImageCollectionViewCell.self)
    }
    
    func initTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.registerNib(ParticipantActivityTableViewCell.self)
    }
    
    func initLocation() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            initMap()
        } else if CLLocationManager.authorizationStatus() ==
            .notDetermined {
            if CLLocationManager.authorizationStatus() != .authorizedWhenInUse {
                locationManager.requestWhenInUseAuthorization()
            }
        } else {
            initMap()
        }
    }
    
    func initMap() {
        let latLong = viewModel.outputs.latLong.components(separatedBy: ",") 
        let lat = latLong.first ?? "-6.21462"
        let lng = latLong.last ?? "106.84513"
        let camera = GMSCameraPosition.camera(withLatitude: (Double(lat))!, longitude: (Double(lng))!, zoom: 13)
        let screenSize = UIScreen.main.bounds
        map = GMSMapView.map(withFrame: CGRect(x: 0, y: 0, width: screenSize.width, height: mapView.frame.size.height), camera: camera)
        map!.isMyLocationEnabled = false
        mapView.addSubview(map!)
        mapView.sendSubviewToBack(map!)
        
    }
    
    func fitAllMarkers(_path: GMSPath) {
        var bounds = GMSCoordinateBounds()
        for index in 1..._path.count() {
            bounds = bounds.includingCoordinate(_path.coordinate(at: index))
        }
        map?.animate(with: GMSCameraUpdate.fit(bounds))
    }
    
    func bindViewModel() {
        observeUpdate()
        observeError()
//        observeModel()
//        observeModelOthers()
        observeLoading()
        observerModelList()
        observerModelDetailJoin()
        observerModelDetailBeforeJoin()
        observeCountMember()
        observeCountLike()
        observeListImageActivity()
    }
    
    func observeListImageActivity() {
        viewModel.outputs.listActivityPhotoModel
            .subscribe(onNext: { [weak self] model in
                if self?.viewModel.outputs.isFromList == true && self?.viewModel.outputs.isJoinApproved == true || self?.viewModel.outputs.isJoinApproved == true && self?.viewModel.outputs.isFromList == false {
                    self?.addRightBarButtonMore(#selector(self?.more))
                } else {
                    self?.addEmptyBarButton(isRight: true)
                }
                if model?.count ?? 0 > 0 {
                    let url = URL(string: model?[0].actphoPhotourl ?? "")
                    self?.firstImageView.kf.setImage(with: url, placeholder: UIImage(named: ""))
                }
                if model?.count ?? 0 == 0 {
                    self?.multipleImageUIView.isHidden = true
                    self?.heightBgImageView.constant = 0
                    let screenSize = UIScreen.main.bounds
                    let height = self?.viewModel.outputs.desc.height(withConstrainedWidth: screenSize.width - 20, font: UIFont.systemFont(ofSize: 13))
                    DispatchQueue.main.async {
                        self?.heightBgView.constant = 550 + CGFloat(height ?? 0)
                    }
                    
                    //self?.multipleImageActivityButton.isHidden = true
                    self?.multipleImageActivityButton.isHidden = false
                    self?.countListImageActivityLabel.isHidden = true
                    self?.imageCollectionView.isHidden = true
                } else if model?.count ?? 0 == 1 {
                    //self?.multipleImageActivityButton.isHidden = true
                    self?.multipleImageActivityButton.isHidden = false
                    self?.countListImageActivityLabel.isHidden = true
                    self?.imageCollectionView.isHidden = true
                    
                    self?.multipleImageUIView.isHidden = false
                    self?.heightBgImageView.constant = 200
                    let screenSize = UIScreen.main.bounds
                    let height = self?.viewModel.outputs.desc.height(withConstrainedWidth: screenSize.width - 20, font: UIFont.systemFont(ofSize: 13))
                    DispatchQueue.main.async {
                        self?.heightBgView.constant = 750 + CGFloat(height ?? 0)
                    }
                } else {
                    self?.multipleImageUIView.isHidden = false
                    self?.heightBgImageView.constant = 200
                    let screenSize = UIScreen.main.bounds
                    let height = self?.viewModel.outputs.desc.height(withConstrainedWidth: screenSize.width - 20, font: UIFont.systemFont(ofSize: 13))
                    DispatchQueue.main.async {
                        self?.heightBgView.constant = 750 + CGFloat(height ?? 0)
                    }
                    
                    self?.imageCollectionView.isHidden = false
                    self?.multipleImageActivityButton.isHidden = false
                    self?.countListImageActivityLabel.isHidden = false
                    self?.countListImageActivityLabel.text = "   1 from \(model?.count ?? 0) photos   "
                    self?.imageCollectionView.reloadData()
                }
                
                
            })
            .disposed(by: disposeBag)
    }
    func observeCountLike() {
        viewModel.outputs.countLike
            .subscribe(onNext: { [weak self] count in
                self?.likeLabel.text = "\(count) Like"
                if self?.viewModel.outputs.isUserLike == true {
                    self?.userLikeImageView.image = UIImage(named: "ic_thumb-up")
                } else {
                    self?.userLikeImageView.image = UIImage(named: "ic_thumb-up-outline")
                }
            })
            .disposed(by: disposeBag)
    }
    
    func observeLoading() {
        viewModel.outputs.loading
            .subscribe(onNext: { [weak self] loading in
                if loading {
                    self?.activityIndicatorBegin()
                } else {
                    self?.activityIndicatorEnd()
                }
            })
            .disposed(by: disposeBag)
    }
    
    func observeUpdate() {
        viewModel.outputs.update
            .subscribe(onNext: { [weak self] _ in
                self?.tableView.reloadData()
            })
            .disposed(by: disposeBag)
    }
    
    func observeCountMember() {
        viewModel.outputs.countMember
            .subscribe(onNext: { [weak self] count in
                self?.participantLabel.text = "\(count) Participants"
            })
            .disposed(by: disposeBag)
    }
    
    func observerModelList() {
        viewModel.outputs.modelDetail
            .subscribe(onNext: { [weak self] model in
                guard let self = self else { return }
                self.initLocation()
                self.heightJoinButton.constant = 0
                let profile = User.shared.profile
                let url = URL(string: profile?.photoUrl ?? "")
                self.userImageView.kf.setImage(with: url, placeholder: UIImage(named: "common_avatar"))
                self.userImageView.layer.cornerRadius = self.userImageView.frame.size.width/2
                self.userImageView.clipsToBounds = true
                self.usernameLabel.text = profile?.fullname ?? ""
                self.shareName = profile?.fullname ?? ""
                self.titleLabel.text = model?.actName ?? ""
                self.descTextView.text = model?.actDesc ?? ""
                self.descTextView.isEditable = false
                self.descTextView.sizeToFit()
                self.descTextView.layoutIfNeeded()
                self.locationLabel.text = model?.actLocation ?? ""
                self.likeLabel.text = "\(model?.actLikes ?? 0) Like"
                self.commentLabel.text = "\(model?.actComments ?? 0) Comment"
                self.shareCodeLabel.text = model?.actCode ?? ""
                let isLike = model?.actIslike ?? 0
                if isLike == 1 {
                    self.userLikeImageView.image = UIImage(named: "ic_thumb-up")
                } else {
                    self.userLikeImageView.image = UIImage(named: "ic_thumb-up-outline")
                }
                let privatePublic = model?.actPublic ?? 0
                if privatePublic == 1 {
                    self.privateLabel.text = "Public"
                    self.approvalLabel.text = "Not require approval to join"
                    self.approvalImageView.image = UIImage(named: "activity_lock")
                    self.privateImageView.image = UIImage(named: "public")
                } else {
                    self.privateLabel.text = "Private"
                    self.approvalLabel.text = "Require approval to join"
                    self.approvalImageView.image = UIImage(named: "activity_lock")
                    self.privateImageView.image = UIImage(named: "activity_account")
                }
                let joinApproval = model?.actJoinApproval ?? 0
                self.approvalImageView.image = UIImage(named: "activity_lock")
                if joinApproval == 1 {
                    self.approvalLabel.text = "Require approval to join"
                } else {
                    self.approvalLabel.text = "Not require approval to join"
                }
                let actDate = Date(timeIntervalSince1970: TimeInterval(model?.actDateTimeStart ?? 0))
                self.dateTimeLabel.text = actDate.dateToStringFull()
                let screenSize = UIScreen.main.bounds
                let height = model?.actDesc?.height(withConstrainedWidth: screenSize.width - 20, font: UIFont.systemFont(ofSize: 13))
                self.editButton.isHidden = false
                self.editImageView.isHidden = false
                DispatchQueue.main.async {
                    self.heightBgView.constant = 750 + CGFloat(height ?? 0)
                }
                if self.viewModel.outputs.isJoinApproved == true || self.viewModel.outputs.isFromList == true {
                    self.addRightBarButtonMore(#selector(self.more))
                } else {
                    self.addEmptyBarButton(isRight: true)
                }
                let routes = model?.actRoutes ?? []
                if routes.count > 0 {
                    for item in routes {
                        if item.actruteEncode == 1 {
                            let polyline = Polyline(encodedPolyline: item.actruteData ?? "")
                            let decodedCoordinates: [CLLocationCoordinate2D]? = polyline.coordinates
                            let polylineFix = decodedCoordinates ?? []
                            let path = GMSMutablePath()
                            for items in polylineFix {
                                path.add(items)
                            }
                            let polylines = GMSPolyline(path: path)
                            polylines.strokeColor = .bluePath
                            polylines.strokeWidth = 2
                            polylines.map = self.map!
                            self.fitAllMarkers(_path: path)
                        }
                    }
                }
            })
            .disposed(by: disposeBag)
    }
    
    func observerModelDetailBeforeJoin() {
        viewModel.outputs.modelDetailBeforeJoin
            .subscribe(onNext: { [weak self] model in
                guard let self = self else { return }
                self.initLocation()
                let url = URL(string: model?.ownerPhoto ?? "")
                self.userImageView.kf.setImage(with: url, placeholder: UIImage(named: "common_avatar"))
                self.userImageView.layer.cornerRadius = self.userImageView.frame.size.width/2
                self.userImageView.clipsToBounds = true
                self.usernameLabel.text = model?.ownerName ?? ""
                self.shareName = model?.ownerName ?? ""
                self.titleLabel.text = model?.actName ?? ""
                self.descTextView.text = model?.actDesc ?? ""
                self.descTextView.isEditable = false
                self.descTextView.sizeToFit()
                self.descTextView.layoutIfNeeded()
                self.locationLabel.text = model?.actLocation ?? ""
                self.likeLabel.text = "\(model?.actLikes ?? 0) Like"
                self.commentLabel.text = "\(model?.actComments ?? 0) Comment"
                self.shareCodeLabel.text = model?.actCode ?? ""
                let isLike = model?.actIslike ?? 0
                if isLike == 1 {
                    self.userLikeImageView.image = UIImage(named: "ic_thumb-up")
                } else {
                    self.userLikeImageView.image = UIImage(named: "ic_thumb-up-outline")
                }
                let privatePublic = model?.actPublic ?? 0
                if privatePublic == 1 {
                    self.privateLabel.text = "Public"
                    self.privateImageView.image = UIImage(named: "public")
                } else {
                    self.privateLabel.text = "Private"
                    self.privateImageView.image = UIImage(named: "activity_account")
                }
                let joinApproval = model?.actJoinApproval ?? 0
                self.approvalImageView.image = UIImage(named: "activity_lock")
                if joinApproval == 1 {
                    self.approvalLabel.text = "Require approval to join"
                } else {
                    self.approvalLabel.text = "Not require approval to join"
                }
                let actDate = Date(timeIntervalSince1970: TimeInterval(model?.actDateTimeStart ?? 0))
                self.dateTimeLabel.text = actDate.dateToStringFull()
                self.statusLabel.isHidden = true
                self.statusDateLabel.isHidden = true
                let screenSize = UIScreen.main.bounds
                let height = model?.actDesc?.height(withConstrainedWidth: screenSize.width - 20, font: UIFont.systemFont(ofSize: 13))
                if model?.ismember == true {
                    self.viewModel.inputs.getDetailJoinActivity(fromJoin: false)
                    DispatchQueue.main.async {
                        self.heightBgView.constant = 750 + CGFloat(height ?? 0)
                    }
                } else {
                    self.heightJoinButton.constant = 32
                    DispatchQueue.main.async {
                        self.heightBgView.constant = 550 + CGFloat(height ?? 0)
                    }
                }
                let routes = model?.actRoutes ?? []
                if routes.count > 0 {
                    for item in routes {
                        if item.actruteEncode == 1 {
                            let polyline = Polyline(encodedPolyline: item.actruteData ?? "")
                            let decodedCoordinates: [CLLocationCoordinate2D]? = polyline.coordinates
                            let polylineFix = decodedCoordinates ?? []
                            let path = GMSMutablePath()
                            for items in polylineFix {
                                path.add(items)
                            }
                            let polylines = GMSPolyline(path: path)
                            polylines.strokeColor = .bluePath
                            polylines.strokeWidth = 2
                            polylines.map = self.map!
                            self.fitAllMarkers(_path: path)
                        }
                    }
                }
            })
            .disposed(by: disposeBag)
    }
    
    func observerModelDetailJoin() {
        viewModel.outputs.modelDetailJoin
            .subscribe(onNext: { [weak self] model in
                guard let self = self else { return }
                self.initLocation()
                self.heightJoinButton.constant = 0
                let url = URL(string: model?.ownerPhoto ?? "")
                self.userImageView.kf.setImage(with: url, placeholder: UIImage(named: "common_avatar"))
                self.userImageView.layer.cornerRadius = self.userImageView.frame.size.width/2
                self.userImageView.clipsToBounds = true
                self.usernameLabel.text = model?.ownerName ?? ""
                self.shareName = model?.ownerName ?? ""
                self.titleLabel.text = model?.actName ?? ""
                self.descTextView.text = model?.actDesc ?? ""
                self.descTextView.isEditable = false
                self.descTextView.sizeToFit()
                self.descTextView.layoutIfNeeded()
                self.locationLabel.text = model?.actLocation ?? ""
                self.likeLabel.text = "\(model?.actLikes ?? 0) Like"
                self.commentLabel.text = "\(model?.actComments ?? 0) Comment"
                self.shareCodeLabel.text = model?.actCode ?? ""
                let isLike = model?.actIslike ?? 0
                if isLike == 1 {
                    self.userLikeImageView.image = UIImage(named: "ic_thumb-up")
                } else {
                    self.userLikeImageView.image = UIImage(named: "ic_thumb-up-outline")
                }
                let privatePublic = model?.actPublic ?? 0
                if privatePublic == 1 {
                    self.privateLabel.text = "Public"
                    self.privateImageView.image = UIImage(named: "public")
                } else {
                    self.privateLabel.text = "Private"
                    self.privateImageView.image = UIImage(named: "activity_account")
                }
                let joinApproval = model?.actJoinApproval ?? 0
                self.approvalImageView.image = UIImage(named: "activity_lock")
                if joinApproval == 1 {
                    self.approvalLabel.text = "Require approval to join"
                } else {
                    self.approvalLabel.text = "Not require approval to join"
                }
                self.approvalLabel.isHidden = true
                self.approvalImageView.isHidden = true
                let actDate = Date(timeIntervalSince1970: TimeInterval(model?.actDateTimeStart ?? 0))
                self.dateTimeLabel.text = actDate.dateToStringFull()
                let screenSize = UIScreen.main.bounds
                let height = model?.actDesc?.height(withConstrainedWidth: screenSize.width - 20, font: UIFont.systemFont(ofSize: 13))
                if model?.actmemActive == 1 {
                    self.multipleImageUIView.isHidden = false
                    self.heightBgImageView.constant = 200
                    self.statusLabel.isHidden = false
                    self.statusDateLabel.isHidden = false
                    self.statusLabel.text = "   \("Approved")   "
                    self.statusLabel.backgroundColor = UIColor.init(red: 50.0/255.0, green: 181.0/255.0, blue: 39.0/255.0, alpha: 1.0)
                    let date = Date(timeIntervalSince1970: TimeInterval(model?.actCreated ?? 0))
                    self.statusDateLabel.text = "Join at \(date.dateToString())"
                    DispatchQueue.main.async {
                        self.heightBgView.constant = 750 + CGFloat(height ?? 0)
                    }
                } else {
                    self.multipleImageUIView.isHidden = true
                    self.heightBgImageView.constant = 0
                    self.statusLabel.isHidden = false
                    self.statusDateLabel.isHidden = false
                    self.statusLabel.text = "   \("Waiting for Approval")   "
                    self.statusLabel.backgroundColor = UIColor.init(red: 215.0/255.0, green: 166.0/255.0, blue: 61.0/255.0, alpha: 1.0)
                    let date = Date(timeIntervalSince1970: TimeInterval(model?.actCreated ?? 0))
                    self.statusDateLabel.text = "Join at \(date.dateToString())"
                    DispatchQueue.main.async {
                        self.heightBgView.constant = 550 + CGFloat(height ?? 0)
                    }
                }
                let routes = model?.actRoutes ?? []
                if routes.count > 0 {
                    for item in routes {
                        if item.actruteEncode == 1 {
                            let polyline = Polyline(encodedPolyline: item.actruteData ?? "")
                            let decodedCoordinates: [CLLocationCoordinate2D]? = polyline.coordinates
                            let polylineFix = decodedCoordinates ?? []
                            let path = GMSMutablePath()
                            for items in polylineFix {
                                path.add(items)
                            }
                            let polylines = GMSPolyline(path: path)
                            polylines.strokeColor = .bluePath
                            polylines.strokeWidth = 2
                            polylines.map = self.map!
                            self.fitAllMarkers(_path: path)
                        }
                    }
                }
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
}

extension DetailActivityViewController {
    
    @objc func back() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func addRoute() {
        let vc = AddRouteCoordinator.createAddRouteViewController(actCode: viewModel.outputs.actCode)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @objc func more() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let editActivity = UIAlertAction(title: "Edit Activity", style: .default, handler: { action in
            switch action.style{
            case .default:
                self.edit()
                print("default")
            case .cancel:
                print("cancel")
            case .destructive:
                print("destructive")
            }})
        let addImage = UIAlertAction(title: "Add Image", style: .default, handler: { action in
            switch action.style{
            case .default:
                let picker = UIImagePickerController()
                picker.allowsEditing = true
                picker.sourceType = .photoLibrary
                picker.delegate = self
                self.present(picker, animated: true, completion: nil)
                print("default")
            case .cancel:
                print("cancel")
            case .destructive:
                print("destructive")
            }})
        let addRoute = UIAlertAction(title: "Add Route", style: .default, handler: { action in
            switch action.style{
            case .default:
                let vc = AddRouteCoordinator.createAddRouteViewController(actCode: self.viewModel.outputs.actCode)
                self.navigationController?.pushViewController(vc, animated: true)
                print("default")
            case .cancel:
                print("cancel")
            case .destructive:
                print("destructive")
            }})
        let cancel = UIAlertAction(title: "Cancel", style: .default, handler: { action in
            switch action.style{
            case .default:
                print("default")
            case .cancel:
                print("cancel")
            case .destructive:
                print("destructive")
            }})
        if viewModel.outputs.isFromList == true && self.viewModel.outputs.isJoinApproved == true {
            alert.addAction(editActivity)
            alert.addAction(addImage)
            alert.addAction(addRoute)
            alert.addAction(cancel)
        }
        if self.viewModel.outputs.isJoinApproved == true && viewModel.outputs.isFromList == false {
            alert.addAction(addImage)
            alert.addAction(cancel)
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc private func updateComment(notification: NSNotification){
        viewModel.inputs.onViewDidAppear()
    }
    
    @objc func updateDetailActivity(notification: NSNotification) {
        viewModel.inputs.onViewDidLoad()
    }
    
    @objc private func updatePhotos(notification: NSNotification){
        viewModel.inputs.getListPhotoActivity()
    }
    
    @objc func join() {
        viewModel.inputs.joinActivity()
    }
    
    @objc func edit() {
        let model = viewModel.inputs.onDetailModel()
        let vc = ActivityCoordinator.createActivityViewController(isEdit: true, idActivity: "\(model?.actId ?? 0)")
        vc.isEdit = true
        let latLong = viewModel.outputs.latLong.components(separatedBy: ",")
        let lat = latLong.first ?? "-6.21462"
        let lng = latLong.last ?? "106.84513"
        vc.latEdit = lat
        vc.lngEdit = lng
        vc.dateEdit = Date(timeIntervalSince1970: TimeInterval(model?.actDateTimeStart ?? 0))
        vc.titleEdit = model?.actName ?? ""
        vc.locationEdit = viewModel.outputs.location
        vc.descEdit = model?.actDesc ?? ""
        if model?.actPublic == 0 {
            vc.isPublic = false
        } else {
            vc.isPublic = true
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func goToMap() {
        if viewModel.outputs.isJoinApproved == false {
            ToastView.show(message: "this activity is private, your access is limited", in: self, length: .short)
            return
        }
        let vc = TrackMapsCoordinator.createTrackMapsViewController(code: viewModel.actCode)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func goToListImage() {
        let vc = PhotoActivityCoordinator.createPhotoActivityViewController(isMemberValid: viewModel.outputs.isMemberValid, actId: viewModel.actId, model: viewModel.outputs.listActivityPhotoModels)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func addImage() {
        if self.viewModel.outputs.isListImageEmpty == true {
            let picker = UIImagePickerController()
            picker.allowsEditing = true
            picker.sourceType = .photoLibrary
            picker.delegate = self
            self.present(picker, animated: true, completion: nil)
        } else {
            let imageInfo = GSImageInfo(image: self.firstImageView.image ?? UIImage(), imageMode: .aspectFit)
            let transitionInfo = GSTransitionInfo(fromView: view)
            let imageViewer    = GSImageViewerController(imageInfo: imageInfo, transitionInfo: transitionInfo)
            present(imageViewer, animated: true, completion: nil)
        }
        
    }
    
    @objc func likeVC() {
        let vc = LikeActivityCoordinator.createLikeActivityViewController(actId: viewModel.outputs.actId, actCode: viewModel.outputs.actCode)
        vc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        self.present(vc, animated: true, completion: nil)
    }
    @objc func like() {
        viewModel.inputs.userLikeDislikeActivity()
    }
    
    @objc func comment() {
        let vc = CommentCoordinator.createCommentViewController(actCode: viewModel.outputs.actCode, actId: viewModel.outputs.actId)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func share() {
        
        let text = shareCodeLabel.text
        let textShare = ["See \(shareName) activity in Lacakin: \(String.BaseApiUrl)/link/activity/\(text ?? "") You also can join activity by inputting code \(text ?? "") in Lacakin app."]
        let activityViewController = UIActivityViewController(activityItems: textShare as [Any] , applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @objc func participant() {
        let height = UIScreen.main.bounds.height
        if isParticipantOn {
            arrowImage.image = UIImage(named: "arrow_bottom")
            topParticipantConstraint.constant = 64
            UIView.animate(withDuration: 0.33) {
                self.view.layoutIfNeeded()
            }
            isParticipantOn = false
        } else {
            arrowImage.image = UIImage(named: "arrow_top")
            topParticipantConstraint.constant = height - 50
            UIView.animate(withDuration: 0.33) {
                self.view.layoutIfNeeded()
            }
            isParticipantOn = true // OQZWD
        }
    }
}

extension DetailActivityViewController: UINavigationControllerDelegate {
    
}

extension DetailActivityViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            imageSend = image
            isPushReady = true
        }
        picker.dismiss(animated: false, completion: nil);
    }
}

extension DetailActivityViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let joinActivityCode = viewModel.outputs.joinActivityCode
        let isFromList = viewModel.outputs.isFromList
        if joinActivityCode != "" {
            let count = viewModel.inputs.onMemberActivityOthersModel().count
            return count
//            let count = viewModel.inputs.onMemberJoinActivityModel().count
//            return count
        } else {
            if isFromList {
                let count = viewModel.inputs.onMemberActivityModel().count
                return count
            } else {
                let count = viewModel.inputs.onMemberActivityOthersModel().count
                return count
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { //approveMemberJoinActivity
        let cell = tableView.dequeueClass(ParticipantActivityTableViewCell.self)
        let joinActivityCode = viewModel.outputs.joinActivityCode
        let isFromList = viewModel.outputs.isFromList
        if joinActivityCode != "" {
//            let model = viewModel.inputs.onMemberJoinActivityModel()[indexPath.row]
//            cell.configureJoin(model: model)
            let model = viewModel.inputs.onMemberActivityOthersModel()[indexPath.row]
            cell.configureOthers(model: model)
        } else {
            if isFromList {
                let model = viewModel.inputs.onMemberActivityModel()[indexPath.row]
                cell.configure(model: model)
                cell.approveButton.rx.tap
                    .subscribe(onNext: { [unowned self] in
                    self.viewModel.approveMemberJoinActivity(memId: "\(model.memId ?? 0)")
                })
                .disposed(by: disposeBag)
            } else {
                let model = viewModel.inputs.onMemberActivityOthersModel()[indexPath.row]
                cell.configureOthers(model: model)
            }
        }
        return cell
    }
}

extension DetailActivityViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let joinActivityCode = viewModel.outputs.joinActivityCode
        let isFromList = viewModel.outputs.isFromList
        if joinActivityCode != "" {
            let model = viewModel.inputs.onMemberActivityOthersModel()[indexPath.row]
            let vc = DetailProfileCoordinator.createDetailProfileViewController(friendId: model.userId ?? "", isUser: false)
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            if isFromList {
                let model = viewModel.inputs.onMemberActivityModel()[indexPath.row]
                let vc = DetailProfileCoordinator.createDetailProfileViewController(friendId: model.userId ?? "", isUser: false)
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                let model = viewModel.inputs.onMemberActivityOthersModel()[indexPath.row]
                let vc = DetailProfileCoordinator.createDetailProfileViewController(friendId: model.userId ?? "", isUser: false)
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 76
    }
}

extension DetailActivityViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return viewModel.inputs.onListPhotoModel().count
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueClass(indexPath,
                                               ImageCollectionViewCell.self)
        let model = viewModel.inputs.onListPhotoModel()[indexPath.row]
        cell.configure(url: model.actphoPhotourl ?? "")
        return cell
    }
}

extension DetailActivityViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? ImageCollectionViewCell {
            let imageInfo = GSImageInfo(image: cell.images.image ?? UIImage(), imageMode: .aspectFit)
            let transitionInfo = GSTransitionInfo(fromView: view)
            let imageViewer    = GSImageViewerController(imageInfo: imageInfo, transitionInfo: transitionInfo)
            present(imageViewer, animated: true, completion: nil)
        }
    }
}

extension DetailActivityViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        
        let width = UIScreen.main.bounds.width
        let height = CGFloat(200)
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}

extension DetailActivityViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == self.scrollView {
            
        } else {
            var visibleRect = CGRect()
            
            visibleRect.origin = imageCollectionView.contentOffset
            visibleRect.size = imageCollectionView.bounds.size
            
            let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
            
            guard let indexPath = imageCollectionView.indexPathForItem(at: visiblePoint) else { return }
            
            print(indexPath)
            
            countListImageActivityLabel.text = "   \(indexPath.row + 1) from \(viewModel.inputs.onListPhotoModel().count ) photos   "
            imageCollectionView.scrollToItem(at: indexPath, at: UICollectionView.ScrollPosition.centeredHorizontally, animated: true)
        }
    }
}
