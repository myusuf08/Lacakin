//  
//  TrackMapsViewController.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 03/03/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import UIKit
import RxSwift
import CoreLocation
import GoogleMaps
import Kingfisher
import Polyline
import Alamofire
import CocoaMQTT

class TrackMapsViewController: BaseViewController {

    @IBOutlet weak var widthViewScrollConstraint: NSLayoutConstraint!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var bgScrollView: UIView!
    @IBOutlet var stopButton: UIButton!
    @IBOutlet var myLocationButton: UIButton!
    @IBOutlet var firstButton: UIButton!
    @IBOutlet var secondButton: UIButton!
    @IBOutlet var thirdButton: UIButton!
    @IBOutlet var fourButton: UIButton!
    @IBOutlet var fiveButton: UIButton!
    @IBOutlet weak var topCheckpointConstraint: NSLayoutConstraint!
    @IBOutlet var backButton: UIButton!
    @IBOutlet var checkPointButton: UIButton!
    @IBOutlet var routeButton: UIButton!
    @IBOutlet var nearbyButton: UIButton!
    @IBOutlet var chatButton: UIButton!
    @IBOutlet var arrowButton: UIButton!
    @IBOutlet var arrowImage: UIImageView!
    @IBOutlet var playButton: UIButton!
    @IBOutlet var playView: UIView!
    @IBOutlet var stopView: UIView!
    @IBOutlet var mapView: UIView!
    var timer: Timer?
    
    var locationManager = CLLocationManager()
    var isBottomViewShow = false
    var isFirstButtonTapped = false
    var isTraffic = false
    var isSatellite = false
    var isShowNearby = true
    var isDirectionShow = false
    var viewModel: TrackMapsViewModel!
    var coordinator: TrackMapsCoordinator!

    var checkpointMarker : [GMSMarker] = []
    var routePolyline : [GMSPolyline] = []
    var nearbyMarker : [GMSMarker] = []
    var map: GMSMapView?
    
    var markerUser: GMSMarker?
    
    var isCheckpoint = true
    var isRoute = false
    var isNearby = false
    var isChat = false
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        initScrollView()
    }
    
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
        initLocation()
        viewModel.inputs.onViewDidLoad()
        subscribeTracking()
        initScrollView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if isCheckpoint == true {
            checkPoint(false)
        } else if isRoute == true {
            route(false)
        } else if isNearby == true {
            nearby(false)
        } else if isChat == true {
            chat(false)
        }
    }
}

// MARK: Private

extension TrackMapsViewController {
    
    func setupViews() {
        playAvailable()
        let playLongPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressedPlay))
        playButton.addGestureRecognizer(playLongPressRecognizer)
        playButton.addTarget(self, action: #selector(play), for: .touchUpInside)
        
        let stopLongPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressedStop))
        stopButton.addGestureRecognizer(stopLongPressRecognizer)
        stopButton.addTarget(self, action: #selector(stop), for: .touchUpInside)
        
        backButton.addTarget(self, action: #selector(back), for: .touchUpInside)
        checkPointButton.layer.cornerRadius = 15
        routeButton.layer.cornerRadius = 15
        nearbyButton.layer.cornerRadius = 15
        chatButton.layer.cornerRadius = 15
        checkPointButton.addTarget(self, action: #selector(checkPoint), for: .touchUpInside)
        checkPointButton.setTitleColor(.white, for: .normal)
        checkPointButton.backgroundColor = .defaultBlue
        routeButton.addTarget(self, action: #selector(route), for: .touchUpInside)
        routeButton.setTitleColor(.lightGray, for: .normal)
        routeButton.backgroundColor = .clear
        nearbyButton.addTarget(self, action: #selector(nearby), for: .touchUpInside)
        nearbyButton.setTitleColor(.lightGray, for: .normal)
        nearbyButton.backgroundColor = .clear
        chatButton.addTarget(self, action: #selector(chat), for: .touchUpInside)
        chatButton.setTitleColor(.lightGray, for: .normal)
        chatButton.backgroundColor = .clear
        arrowButton.addTarget(self, action: #selector(bottomViewShow), for: .touchUpInside)
        let height = UIScreen.main.bounds.height
        topCheckpointConstraint.constant = height - 50
        arrowImage.image = UIImage(named: "arrow_top")
        firstButton.layer.cornerRadius = 20
        secondButton.layer.cornerRadius = 20
        thirdButton.layer.cornerRadius = 20
        fourButton.layer.cornerRadius = 20
        fiveButton.layer.cornerRadius = 20
        firstButton.addTarget(self, action: #selector(first), for: .touchUpInside)
        secondButton.addTarget(self, action: #selector(second), for: .touchUpInside)
        thirdButton.addTarget(self, action: #selector(third), for: .touchUpInside)
        fourButton.addTarget(self, action: #selector(four), for: .touchUpInside)
        fiveButton.addTarget(self, action: #selector(five), for: .touchUpInside)
        myLocationButton.addTarget(self, action: #selector(myLocation), for: .touchUpInside)
        
        if User.shared.isTracking == true {
            if viewModel.outputs.code == User.shared.isCodeTracking {
                longPressedPlay()
            }
        }
    }
    
    func initScrollView() {
        let width = UIScreen.main.bounds.width
        let height = scrollView.frame.height
        widthViewScrollConstraint.constant = 4 * width
        scrollView.delegate = self
        scrollView.isPagingEnabled = false
        
        // Checkpoint
        let checkpointFrame = CGRect(x: 0, y: 0, width: width, height: height)
        let checkpoint = CheckpointCoordinator.createCheckpointViewController(code: viewModel.outputs.code)
        checkpoint.delegate = self
        addChild(checkpoint)
        scrollView.addSubview(checkpoint.view)
        checkpoint.didMove(toParent: self)
        checkpoint.view.frame = checkpointFrame
        
        // Route
        let routeFrame = CGRect(x: width, y: 0, width: width, height: height)
        let route = RouteCoordinator.createRouteViewController(code: viewModel.outputs.code)
        route.delegate = self
        addChild(route)
        scrollView.addSubview(route.view)
        route.didMove(toParent: self)
        route.view.frame = routeFrame
        
        // Nearby
        let nearbyFrame = CGRect(x: width * 2, y: 0, width: width, height: height)
        let nearby = NearbyCoordinator.createNearbyViewController(code: viewModel.outputs.code)
        nearby.delegate = self
        addChild(nearby)
        scrollView.addSubview(nearby.view)
        nearby.didMove(toParent: self)
        nearby.view.frame = nearbyFrame
        
        // Chat
        let chatFrame = CGRect(x: width * 3, y: 0, width: width, height: height)
        let chat = TrackChatCoordinator.createTrackChatViewController(code: viewModel.outputs.code)
        addChild(chat)
        scrollView.addSubview(chat.view)
        chat.didMove(toParent: self)
        chat.view.frame = chatFrame
        
        scrollView.isScrollEnabled = false
        scrollView.canCancelContentTouches = false
        scrollView.delaysContentTouches = true
        scrollView.contentSize = CGSize(width: 4 * width,
                                             height: height)
        
        scrollView.layoutIfNeeded()
        view.layoutIfNeeded()
        
        if isCheckpoint == true {
            self.checkPoint(false)
        } else if isRoute == true {
            self.route(false)
        } else if isNearby == true {
            self.nearby(false)
        } else if isChat == true {
            self.chat(false)
        }
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
        let lat = locationManager.location?.coordinate.latitude ?? -6.21462
        let lng = locationManager.location?.coordinate.longitude ?? 106.84513
        let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: lng, zoom: 12.0)
        let screenSize = UIScreen.main.bounds
        map = GMSMapView.map(withFrame: CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height - 50), camera: camera)
        self.map!.settings.myLocationButton = true
        mapView.addSubview(self.map!)
        mapView.sendSubviewToBack(self.map!)
        initUserLocation()
    }
    
    func initUserLocation() {
        let lat = locationManager.location?.coordinate.latitude ?? -6.21462
        let lng = locationManager.location?.coordinate.longitude ?? 106.84513
        let image = UIImageView()
        let url = URL(string: User.shared.profile?.photoUrl ?? "")
        image.kf.setImage(with: url, placeholder: UIImage(named: "common_avatar"))
        image.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        image.layer.cornerRadius = 15
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        image.layer.masksToBounds = true
        image.layer.borderColor = UIColor.bluePath.cgColor
        image.layer.borderWidth = 2
        markerUser = GMSMarker(position: CLLocationCoordinate2D(latitude: lat, longitude: lng))
        markerUser?.iconView = image
        markerUser?.snippet = User.shared.profile?.fullname ?? ""
        markerUser?.map = self.map
    }
    
    func initRoute(model: ListRouteData) {
        routePolyline = []
        let data = model.data ?? []
        for item in data {
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
                polylines.map = self.map
                self.routePolyline.append(polylines)
            }
        }
    }
    
    func initCheckpoint(model: ListCheckpointData) {
        checkpointMarker = []
        let data = model.data ?? []
        for item in data {
            let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 30, height: 30))
            view.backgroundColor = .red
            view.layer.cornerRadius = 15
            let checkPointLabel = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: 30, height: 30))
            checkPointLabel.textAlignment = .center
            checkPointLabel.font = UIFont.systemFont(ofSize: 20)
            checkPointLabel.textColor = .white
            checkPointLabel.text = "P"
            view.addSubview(checkPointLabel)
            let image = UIImageView()
            let url = URL(string: item.actcpIcon ?? "")
            image.kf.setImage(with: url)
            image.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            image.layer.cornerRadius = 15
            image.contentMode = .scaleAspectFit
            image.clipsToBounds = true
            image.layer.masksToBounds = true
            image.layer.borderColor = UIColor.bluePath.cgColor
            image.layer.borderWidth = 2
            var point = item.actcpPoint ?? ""
            point = point.replacingOccurrences(of: "[", with: "")
            point = point.replacingOccurrences(of: "]", with: "")
            let latLong = point.components(separatedBy: ",")
            let lat = latLong.first ?? "0"
            let lng = latLong.last ?? "0"
            let marker = GMSMarker(position: CLLocationCoordinate2D.init(latitude: (Double(lat))!, longitude: (Double(lng))!))
            view.addSubview(image)
            marker.iconView = view
            marker.snippet = item.actcpName ?? ""
            marker.map = self.map
            checkpointMarker.append(marker)
        }
    }
    
    func initNearby(model: ListNearbyData) {
        nearbyMarker = []
        let data = model.data ?? []
        for item in data {
            let image = UIImageView()
            let url = URL(string: item.photo ?? "")
            image.kf.setImage(with: url, placeholder: UIImage(named: ""))
            image.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            image.layer.cornerRadius = 15
            image.contentMode = .scaleAspectFit
            image.clipsToBounds = true
            image.layer.masksToBounds = true
            image.layer.borderColor = UIColor.bluePath.cgColor
            image.layer.borderWidth = 2
            let lat = item.la ?? "0"
            let lng = item.lo ?? "0"
            let marker = GMSMarker(position: CLLocationCoordinate2D(latitude: (Double(lat))!, longitude: (Double(lng))!))
            marker.iconView = image
            marker.snippet = item.name ?? ""
            marker.map = self.map
            nearbyMarker.append(marker)
        }
    }
    
    
    @objc func start() {
        let code = self.viewModel.outputs.code
        let userId = User.shared.profile?.userId ?? ""
        let topic = "lacakin/gps/\(userId)/\(code)"
        let lat = self.locationManager.location?.coordinate.latitude ?? -6.21462
        let lng = self.locationManager.location?.coordinate.longitude ?? 106.84513
        let date = Int(Date().timeIntervalSince1970)
        let stringModel = MTQQTrackingMap.init(la: lat, lo: lng, al: 5.0, co: 0, sp: 0, bat: 70, tm: date, tz: "Asia/Jakarta", name: User.shared.profile?.fullname ?? "", userid: userId, ip: "", act: code)
        do {
            let jsonData = try JSONEncoder().encode(stringModel)
            let jsonString = String(data: jsonData, encoding: .utf8) ?? ""
            let data = Array(jsonString.utf8)
            let message = CocoaMQTTMessage.init(topic: topic, payload: data)
            MQTTManager.shared.publishMessage(message: message)
            //self.mqtt!.publish(message)
            //self.mqtt?.publish(topic, withString: string, qos: .qos1, retained: false, dup: false)
        }
        catch {
            
        }
       
    }
    
    func subscribeTracking() {
        let topic = "lacakin/track/\(viewModel.outputs.code)"
        MQTTManager.shared.subscribeTopicThree(topic: topic)
        MQTTManager.shared.mqtt?.didReceiveMessage = { mqtt, message, id in
            print("Message received in topic tracking \(message.topic) with payload \(message.string!)")
            if message.topic == topic {
                let string = message.string ?? ""
                print("subscribeTracking = \(string)")
            }
        }
    }
    
    func stopSubscribe() {
        MQTTManager.shared.mqtt?.unsubscribe("lacakin/track/\(viewModel.outputs.code)")
    }
    
    func bindViewModel() {
        observeUpdate()
        observeError()
        observeListRoute()
        observeListCheckpoint()
        observeListNearby()
        observeSuccessTracking()
        observeStopTracking()
    }
    
    func observeSuccessTracking() {
        viewModel.outputs.notifyTrackStart
            .subscribe(onNext: { [weak self] models in
                if self?.timer != nil {
                    self?.timer = nil
                    self?.timer?.invalidate()
                }
                self?.timer = Timer.scheduledTimer(timeInterval: 30, target: self!, selector: #selector(self?.start), userInfo: nil, repeats: true)
                self?.stopAvailable()
                print("notifyTrackStart")
                ToastView.show(message: "Start tracking your position", in: self!, length: .short)
            })
            .disposed(by: disposeBag)
    }
    
    func observeStopTracking() {
        viewModel.outputs.notifyTrackStop
            .subscribe(onNext: { [weak self] models in
                print("notifyTrackStop")
                self?.stopSubscribe()
                self?.timer?.invalidate()
                self?.timer = nil
                self?.playAvailable()
                ToastView.show(message: "Stop tracking your position", in: self!, length: .short)
            })
            .disposed(by: disposeBag)
    }
    
    func observeListRoute() {
        viewModel.outputs.listRouteModel
            .subscribe(onNext: { [weak self] models in
                guard let model = models else { return }
                self?.initRoute(model: model)
            })
            .disposed(by: disposeBag)
    }
    
    func observeListCheckpoint() {
        viewModel.outputs.listCheckpointModel
            .subscribe(onNext: { [weak self] models in
                guard let model = models else { return }
                self?.initCheckpoint(model: model)
            })
            .disposed(by: disposeBag)
    }
    
    func observeListNearby() {
        viewModel.outputs.listNearbyModel
            .subscribe(onNext: { [weak self] models in
                guard let model = models else { return }
                self?.initNearby(model: model)
            })
            .disposed(by: disposeBag)
    }
    
    func observeUpdate() {
        viewModel.outputs.update
            .subscribe(onNext: { [weak self] _ in
                // doing update
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
    
    func moveCameraMaps(lat: CLLocationDegrees = -6.21462, lng: CLLocationDegrees = 106.84513) {
        let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: lng, zoom: 12)
        map?.camera = camera
        map?.animate(to: camera)
    }
}

extension TrackMapsViewController {
    func playAvailable() {
        stopButton.isHidden = true
        stopView.isHidden = true
        playButton.isHidden = false
        playView.isHidden = false
    }
    
    func stopAvailable() {
        stopButton.isHidden = false
        stopView.isHidden = false
        playButton.isHidden = true
        playView.isHidden = true
    }
    
    @objc func myLocation() {
        let lat = locationManager.location?.coordinate.latitude ?? -6.21462
        let lng = locationManager.location?.coordinate.longitude ?? 106.84513
        moveCameraMaps(lat: lat, lng: lng)
    }
    
    @objc func longPressedPlay() {
        viewModel.inputs.startTracking()
    }
    
    @objc func longPressedStop() {
        viewModel.inputs.stopTracking()
    }
    
    @objc func stop() {
        ToastView.show(message: "Press 2 second to stop tracking position", in: self, length: .short)
    }
    
    @objc func play() {
        ToastView.show(message: "Press 2 second to start tracking position", in: self, length: .short)
    }
    
    @objc func checkPoint(_ animated: Bool = true) {
        isCheckpoint = true
        isRoute = false
        isNearby = false
        isChat = false
        let firstPage = CGPoint(x: 0,
                                 y: scrollView.contentOffset.y)
        scrollView.setContentOffset(firstPage, animated: animated)
        checkPointButton.setTitleColor(.white, for: .normal)
        routeButton.setTitleColor(.lightGray, for: .normal)
        nearbyButton.setTitleColor(.lightGray, for: .normal)
        chatButton.setTitleColor(.lightGray, for: .normal)
        checkPointButton.backgroundColor = .defaultBlue
        routeButton.backgroundColor = .clear
        nearbyButton.backgroundColor = .clear
        chatButton.backgroundColor = .clear
    }
    
    @objc func route(_ animated: Bool = true) {
        isCheckpoint = false
        isRoute = true
        isNearby = false
        isChat = false
        let screen = UIScreen.main.bounds
        let secondPage = CGPoint(x: screen.width,
                                 y: scrollView.contentOffset.y)
        scrollView.setContentOffset(secondPage, animated: animated)
        checkPointButton.setTitleColor(.lightGray, for: .normal)
        routeButton.setTitleColor(.white, for: .normal)
        nearbyButton.setTitleColor(.lightGray, for: .normal)
        chatButton.setTitleColor(.lightGray, for: .normal)
        checkPointButton.backgroundColor = .clear
        routeButton.backgroundColor = .defaultBlue
        nearbyButton.backgroundColor = .clear
        chatButton.backgroundColor = .clear
    }
    
    @objc func nearby(_ animated: Bool = true) {
        isCheckpoint = false
        isRoute = false
        isNearby = true
        isChat = false
        let screen = UIScreen.main.bounds
        let thirdPage = CGPoint(x: screen.width * 2,
                                 y: scrollView.contentOffset.y)
        scrollView.setContentOffset(thirdPage, animated: animated)
        checkPointButton.setTitleColor(.lightGray, for: .normal)
        routeButton.setTitleColor(.lightGray, for: .normal)
        nearbyButton.setTitleColor(.white, for: .normal)
        chatButton.setTitleColor(.lightGray, for: .normal)
        checkPointButton.backgroundColor = .clear
        routeButton.backgroundColor = .clear
        nearbyButton.backgroundColor = .defaultBlue
        chatButton.backgroundColor = .clear
    }
    
    @objc func chat(_ animated: Bool = true) {
        isCheckpoint = false
        isRoute = false
        isNearby = false
        isChat = true
        let screen = UIScreen.main.bounds
        let fourPage = CGPoint(x: screen.width * 3,
                                y: scrollView.contentOffset.y)
        scrollView.setContentOffset(fourPage, animated: animated)
        checkPointButton.setTitleColor(.lightGray, for: .normal)
        routeButton.setTitleColor(.lightGray, for: .normal)
        nearbyButton.setTitleColor(.lightGray, for: .normal)
        chatButton.setTitleColor(.white, for: .normal)
        checkPointButton.backgroundColor = .clear
        routeButton.backgroundColor = .clear
        nearbyButton.backgroundColor = .clear
        chatButton.backgroundColor = .defaultBlue
    }

    @objc func back() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func bottomViewShow() {
        let height = UIScreen.main.bounds.height
        if isBottomViewShow {
            arrowImage.image = UIImage(named: "arrow_bottom")
            topCheckpointConstraint.constant = 20
            UIView.animate(withDuration: 0.33) {
                self.view.layoutIfNeeded()
                if self.isCheckpoint == true {
                    self.checkPoint(false)
                } else if self.isRoute == true {
                    self.route(false)
                } else if self.isNearby == true {
                    self.nearby(false)
                } else if self.isChat == true {
                    self.chat(false)
                }
            }
            isBottomViewShow = false
            
            
        } else {
            arrowImage.image = UIImage(named: "arrow_top")
            topCheckpointConstraint.constant = height - 50
            UIView.animate(withDuration: 0.33) {
                self.view.layoutIfNeeded()
            }
            isBottomViewShow = true
        }
    }
    
    @objc func first() {
        if isFirstButtonTapped {
            isFirstButtonTapped = false
            
            UIView.transition(with: secondButton, duration: 0.55, options: .transitionCrossDissolve, animations: {
                self.secondButton.isHidden = true
            }, completion: nil)
            
            UIView.transition(with: thirdButton, duration: 0.66, options: .transitionCrossDissolve, animations: {
                self.thirdButton.isHidden = true
            }, completion: nil)
            
            UIView.transition(with: fourButton, duration: 0.77, options: .transitionCrossDissolve, animations: {
                self.fourButton.isHidden = true
            }, completion: nil)
            
        } else {
            isFirstButtonTapped = true
            
            UIView.transition(with: secondButton, duration: 0.55, options: .transitionCrossDissolve, animations: {
                self.secondButton.isHidden = false
            }, completion: nil)
            
            UIView.transition(with: thirdButton, duration: 0.66, options: .transitionCrossDissolve, animations: {
                self.thirdButton.isHidden = false
            }, completion: nil)
            
            UIView.transition(with: fourButton, duration: 0.77, options: .transitionCrossDissolve, animations: {
                self.fourButton.isHidden = false
            }, completion: nil)
        }
        
    }
    
    @objc func second() {
        if isSatellite {
            map?.mapType = .normal
            isSatellite = false
        } else {
            map?.mapType = .satellite
            isSatellite = true
        }
    }
    
    @objc func third() {
        if isTraffic {
            map?.isTrafficEnabled = false
            isTraffic = false
        } else {
            map?.isTrafficEnabled = true
            isTraffic = true
        }
    }
    
    @objc func four() {
        if isShowNearby {
            isShowNearby = false
            map?.clear()
            initUserLocation()
            initRoute(model: viewModel.outputs.listRouteModels!)
            initCheckpoint(model: viewModel.outputs.listCheckpointModels!)
        } else {
            isShowNearby = true
            initUserLocation()
            initRoute(model: viewModel.outputs.listRouteModels!)
            initCheckpoint(model: viewModel.outputs.listCheckpointModels!)
            initNearby(model: viewModel.outputs.listNearbyModels!)
        }
    }
    
    @objc func five() {
        isDirectionShow = false
        fiveButton.isHidden = true
        map?.clear()
        initUserLocation()
        initRoute(model: viewModel.outputs.listRouteModels!)
        initCheckpoint(model: viewModel.outputs.listCheckpointModels!)
        initNearby(model: viewModel.outputs.listNearbyModels!)
    }
}

extension TrackMapsViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print(scrollView.contentOffset.x)
    }
}

extension TrackMapsViewController: CheckPointDelegate {
    func didCheckpointSelected(index: Int) {
        bottomViewShow()
        let markerSelected = checkpointMarker[index]
        let lat = markerSelected.position.latitude
        let lng = markerSelected.position.longitude
        map?.selectedMarker = markerSelected
        moveCameraMaps(lat: lat, lng: lng)
    }
    
    func didCheckinSelected(index: Int) {
        bottomViewShow()
    }
    
    func didDirectionSelected(index: Int) {
        bottomViewShow()
        let fromLat = locationManager.location?.coordinate.latitude ?? -6.21462
        let fromLng = locationManager.location?.coordinate.longitude ?? 106.84513
        let markerSelected = checkpointMarker[index]
        let toLat = markerSelected.position.latitude
        let toLng = markerSelected.position.longitude
        getPolyline(fromLat: fromLat, fromLng: fromLng, toLat: toLat, toLng: toLng)
    }
}

extension TrackMapsViewController {
    func fitAllMarkers(_path: GMSPath) {
        var bounds = GMSCoordinateBounds()
        for index in 1..._path.count() {
            bounds = bounds.includingCoordinate(_path.coordinate(at: index))
        }
        map?.animate(with: GMSCameraUpdate.fit(bounds))
    }
    
    func getPolyline(fromLat: Double, fromLng: Double, toLat: Double, toLng: Double) {
        let origin = "\(fromLat),\(fromLng)"
        let destination = "\(toLat),\(toLng)"
        let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=driving&key=AIzaSyBGSAUhiZ7hlffCv7FnHou2Q4klOO6AOkQ"
        Alamofire.request(url).responseJSON { response in
            do {
                if let json : [String:Any] = try JSONSerialization.jsonObject(with: response.data!, options: .allowFragments) as? [String: Any] {
                    let routes = json["routes"] as? [Any]
                    let overviewPolyline = routes?[0] as? [String:Any]
                    let polyObject = overviewPolyline?["overview_polyline"] as? AnyObject
                    let polyString = polyObject?["points"] as? String
                    self.showPath(polyStr: polyString ?? "")
                }
            } catch {
                print("error in JSONSerialization")
            }
        }
    }
    
    func showPath(polyStr: String) {
        let path = GMSPath(fromEncodedPath: polyStr)
        fitAllMarkers(_path: path!)
        let polyline = GMSPolyline(path: path)
        polyline.strokeWidth = 3.0
        polyline.strokeColor = .defaultBlue
        polyline.map = map
        isDirectionShow = true
        fiveButton.isHidden = false
        self.isFirstButtonTapped = false
        self.first()
    }
}

extension TrackMapsViewController: RouteDelegate {
    func didRouteSelected(index: Int) {
        bottomViewShow()
        let model = routePolyline[index]
        guard let path = model.path else { return }
        fitAllMarkers(_path: path)
    }
}

extension TrackMapsViewController: NearbyDelegate {
    func didNearbyLocationSelected(index: Int) {
        bottomViewShow()
        let markerSelected = nearbyMarker[index]
        let lat = markerSelected.position.latitude
        let lng = markerSelected.position.longitude
        map?.selectedMarker = markerSelected
        moveCameraMaps(lat: lat, lng: lng)
    }
}
//
//
//extension TrackMapsViewController: CocoaMQTTDelegate {
//    // Optional ssl CocoaMQTTDelegate
//
//    func mqtt(_ mqtt: CocoaMQTT, didReceive trust: SecTrust, completionHandler: @escaping (Bool) -> Void) {
//        TRACE("trust: \(trust)")
//        completionHandler(true)
//    }
//
//    func mqtt(_ mqtt: CocoaMQTT, didConnectAck ack: CocoaMQTTConnAck) {
//        TRACE("didConnectAck ack: \(ack)")
//        mqtt.subscribe("lacakin/track/\(viewModel.outputs.code)", qos: CocoaMQTTQOS.qos1)
//    }
//
//    func mqtt(_ mqtt: CocoaMQTT, didStateChangeTo state: CocoaMQTTConnState) {
//        TRACE("new state: \(state)")
//    }
//
//    func mqtt(_ mqtt: CocoaMQTT, didPublishMessage message: CocoaMQTTMessage, id: UInt16) {
//        TRACE("message: \(message.string?.description ?? ""), id: \(id)")
//        self.markerUser?.map = nil
//        self.initUserLocation()
//        let string = message.string ?? ""
//        let data = string.data(using: .utf8)!
//        do {
//            //let model = try JSONDecoder().decode(Array<MTQQChat>.self, from: data)
//
//        } catch let error as NSError {
//            print(error)
//
//        }
//
//    }
//
//    func mqtt(_ mqtt: CocoaMQTT, didPublishAck id: UInt16) {
//        TRACE("id: \(id)")
//    }
//
//    func mqtt(_ mqtt: CocoaMQTT, didReceiveMessage message: CocoaMQTTMessage, id: UInt16 ) {
//        TRACE("message: \(message.string ?? ""), id: \(id)")
//
//    }
//
//    func mqtt(_ mqtt: CocoaMQTT, didSubscribeTopic topic: String) {
//        TRACE("topic: \(topic)")
//    }
//
//    func mqtt(_ mqtt: CocoaMQTT, didUnsubscribeTopic topic: String) {
//        TRACE("topic: \(topic)")
//    }
//
//    func mqttDidPing(_ mqtt: CocoaMQTT) {
//        TRACE()
//    }
//
//    func mqttDidReceivePong(_ mqtt: CocoaMQTT) {
//        TRACE()
//    }
//
//    func mqttDidDisconnect(_ mqtt: CocoaMQTT, withError err: Error?) {
//        TRACE("\(err?.localizedDescription ?? "")")
//    }
//
//}
