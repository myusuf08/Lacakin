//  
//  HomeViewController.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 18/01/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import UIKit
import RxSwift
import KYDrawerController
import CoreLocation
import Realm
import RealmSwift

class HomeViewController: BaseViewController {
    
    @IBOutlet weak var bgNotificationView: UIView!
    @IBOutlet weak var countNotificationLabel: UILabel!
    @IBOutlet weak var bgSearchView: UIView!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var registeredButton: UIButton!
    @IBOutlet weak var thisMonthButton: UIButton!
    @IBOutlet weak var allButton: UIButton!
    @IBOutlet weak var eventsView: UIView!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var addActivityButton: UIButton!
    @IBOutlet weak var notificationsButton: UIButton!
    @IBOutlet weak var sideMenuButton: UIButton!
    @IBOutlet weak var mineButton: UIButton!
    @IBOutlet weak var othersButton: UIButton!
    @IBOutlet weak var viewScrollView: UIView!
    @IBOutlet weak var widthViewScrollConstraint: NSLayoutConstraint!
//    @IBOutlet weak var heightViewScrollConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tabView: TabView!
    @IBOutlet weak var heightSearchConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var heightEventViewScrollConstraint: NSLayoutConstraint!
    @IBOutlet weak var widthEventViewScrollConstraint: NSLayoutConstraint!
    @IBOutlet weak var eventScrollView: UIScrollView!
    @IBOutlet weak var eventViewScrollView: UIView!
    
    //
    var isSearch = false
    var isMine = true
    var indexPage = 0
    var viewModel: HomeViewModel!
    var coordinator: HomeCoordinator!
    var locationManager = CLLocationManager()
    let geocoder = CLGeocoder()
    var placemark: CLPlacemark?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews() //tvxyz
        var alreadyLoaded = false
        if !alreadyLoaded {
            alreadyLoaded = true
            initScrollView()
            initEventScrollView()
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if isMine {
            mine(animated: false)
        } else {
            others(animated: false)
        }
        setNotifCount()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bindViewModel()
        initNotification()
        initTabView()
        initEventView()
        initLocation()
        viewModel.inputs.onViewDidLoad()
        let notificationName = Notification.Name("updateprofilelacakin")
        NotificationCenter.default.post(name: notificationName, object: nil)
        searchTextField.returnKeyType = .search
        searchTextField.delegate = self
        searchTextField.clearButtonMode = .always
        
    }
    
    override func subscribeNotifDidSuccess() {
         setNotifCount()
    }
}

// MARK: Private

extension HomeViewController {
    
    func setupViews() {
        eventsView.isHidden = true
        mineButton.layer.cornerRadius = 15
        othersButton.layer.cornerRadius = 15
        mineButton.addTarget(self, action: #selector(mine), for: .touchUpInside)
        mineButton.setTitleColor(.white, for: .normal)
        mineButton.backgroundColor = .defaultBlue
        othersButton.addTarget(self, action: #selector(others), for: .touchUpInside)
        othersButton.setTitleColor(.lightGray, for: .normal)
        othersButton.backgroundColor = .clear
        sideMenuButton.addTarget(self, action: #selector(sidemenu), for: .touchUpInside)
        notificationsButton.addTarget(self, action: #selector(notifications), for: .touchUpInside)
        addActivityButton.addTarget(self, action: #selector(addActivity), for: .touchUpInside)
        
    }
    
    func initEventView() {
        heightSearchConstraint.constant = 0
        bgSearchView.layer.cornerRadius = 12
        bgSearchView.layer.borderWidth = 0.5
        bgSearchView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        allButton.setTitleColor(.white, for: .normal)
        thisMonthButton.setTitleColor(.lightGray, for: .normal)
        registeredButton.setTitleColor(.lightGray, for: .normal)
        allButton.backgroundColor = .defaultBlue
        thisMonthButton.backgroundColor = .white
        registeredButton.backgroundColor = .white
        allButton.addTarget(self, action: #selector(all), for: .touchUpInside)
        thisMonthButton.addTarget(self, action: #selector(thisMonth), for: .touchUpInside)
        registeredButton.addTarget(self, action: #selector(registered), for: .touchUpInside)
        searchButton.addTarget(self, action: #selector(search), for: .touchUpInside)
        allButton.layer.cornerRadius = 15
        thisMonthButton.layer.cornerRadius = 15
        registeredButton.layer.cornerRadius = 15
    }
    
    func initLocation() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            initWeather()
            getCity()
        } else if CLLocationManager.authorizationStatus() ==
            .notDetermined {
            if CLLocationManager.authorizationStatus() != .authorizedWhenInUse {
                locationManager.requestWhenInUseAuthorization()
            }
        } else {
            initWeather()
            getCity()
        }
        
    }
    
    func setNotifCount() {
        let notifCount = realm.objects(MTQQNotificationRealm.self).filter("isRead = false")
        if notifCount.count > 0 {
            bgNotificationView.isHidden = false
            countNotificationLabel.text = "\(notifCount.count)"
        } else {
            bgNotificationView.isHidden = true
        }
    }
    
    func getCity() {
        let lat = locationManager.location?.coordinate.latitude ?? -6.21462
        let lng = locationManager.location?.coordinate.longitude ?? 106.84513
        User.shared.lat = "\(lat)"
        User.shared.lng = "\(lng)"
        let lastLocation = CLLocation(latitude: lat, longitude: lng)
        geocoder.reverseGeocodeLocation(lastLocation, completionHandler: { (placemarks, error) in
            // always good to check if no error
            // also we have to unwrap the placemark because it's optional
            // I have done all in a single if but you check them separately
            if error == nil, let placemark = placemarks, !placemark.isEmpty {
                self.placemark = placemark.last
            }
            // a new function where you start to parse placemarks to get the information you need
            self.parsePlacemarks()
            
        })
    }
    
    func parsePlacemarks() {
        if let placemark = placemark {
            // wow now you can get the city name. remember that apple refers to city name as locality not city
            // again we have to unwrap the locality remember optionalllls also some times there is no text so we check that it should not be empty
            if let city = placemark.locality, !city.isEmpty {
                // here you have the city name
                // assign city name to our iVar
                User.shared.city = city
            }
            // the same story optionalllls also they are not empty
            if let country = placemark.country, !country.isEmpty {
                
                //self.country = country
            }
            // get the country short name which is called isoCountryCode
            if let countryShortName = placemark.isoCountryCode, !countryShortName.isEmpty {
                
                //self.countryShortName = countryShortName
            }
            
        }
        
    }
    
    func initWeather() {
        let lat = locationManager.location?.coordinate.latitude ?? -6.21462
        let lng = locationManager.location?.coordinate.longitude ?? 106.84513
        let APIUrl = NSURL(string:"https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lng)&appid=e7b2054dc37b1f464d912c00dd309595&units=Metric")
        var request = URLRequest(url:APIUrl! as URL)
        request.httpMethod = "GET"
        let dataTask = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error ?? "Error is empty.")
            } else {
                let httpResponse = response as? HTTPURLResponse
                print(httpResponse ?? "HTTP response is empty.")
            }
            
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:Any]
                let weather = json["weather"] as! [[String:Any]]
                for review in weather {
                    if let status = review["main"] as? String {
                        DispatchQueue.main.async {
                            if status == "Rain" {
                                self.weatherImage.image = ImageConstant.weatherRain
                                self.weatherLabel.text = "Rain"
                            } else if status == "Clouds" {
                                self.weatherImage.image = ImageConstant.weatherCloudly
                                self.weatherLabel.text = "Cloudly"
                            } else {
                                self.weatherImage.image = ImageConstant.weatherSunny
                                self.weatherLabel.text = "No data weather"
                            }
                        }
                    } // Rain, Clouds , Sunny
                }
                
            } catch  {
                print("error parsing response from POST on /todos")
                return
            }
            
        })
        
        dataTask.resume()
    }
    func initTabView() {
        tabView.addTabs(["Activities","Events"])
        tabView.delegate = self
    }
    
    func initScrollView() {
        print("initScrollView")
        
        let width = UIScreen.main.bounds.width
        let height = scrollView.frame.height
        widthViewScrollConstraint.constant = 2 * width
//        heightViewScrollConstraint.constant = height
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        
        // Mine
        let mineFrame = CGRect(x: 0, y: 0, width: width, height: height)
        let mine = MineCoordinator.createMineViewController()
        addChild(mine)
        viewScrollView.addSubview(mine.view)
        mine.didMove(toParent: self)
        mine.view.frame = mineFrame
        
        // Others
        let othersFrame = CGRect(x: width, y: 0, width: width, height: height)
        let others = OthersCoordinator.createOthersViewController()
        addChild(others)
        viewScrollView.addSubview(others.view)
        others.didMove(toParent: self)
        others.view.frame = othersFrame
        
        scrollView.isScrollEnabled = false
        scrollView.canCancelContentTouches = false
        scrollView.delaysContentTouches = true
        scrollView.contentSize = CGSize(width: 2 * width,
                                        height: height)
        
        viewScrollView.setNeedsLayout()
        viewScrollView.layoutIfNeeded()
        scrollView.setNeedsLayout()
        scrollView.layoutIfNeeded()
        view.layoutIfNeeded()
    }
    
    func initEventScrollView() {
        let width = UIScreen.main.bounds.width
        let height = eventScrollView.frame.height
        widthEventViewScrollConstraint.constant = 3 * width
//        heightEventViewScrollConstraint.constant = height
        eventScrollView.delegate = self
        eventScrollView.isPagingEnabled = true
        
        // All
        let allFrame = CGRect(x: 0, y: 0, width: width, height: height)
        let all = EventsCoordinator.createEventsViewController(emptyLabel: "There's no upcoming event right now")
        addChild(all)
        eventViewScrollView.addSubview(all.view)
        all.didMove(toParent: self)
        all.view.frame = allFrame
        
        // This Month
        let thisMonthFrame = CGRect(x: width, y: 0, width: width, height: height)
        let thisMonth = EventThisMonthCoordinator.createEventThisMonthViewController(emptyLabel: "There's no upcoming event right now")
        addChild(thisMonth)
        eventViewScrollView.addSubview(thisMonth.view)
        thisMonth.didMove(toParent: self)
        thisMonth.view.frame = thisMonthFrame
        
        // Registered
        let registeredFrame = CGRect(x: width * 2, y: 0, width: width, height: height)
        let registered = EventRegisteredCoordinator.createEventRegisteredViewController(emptyLabel: "You have registered in no events")
        addChild(registered)
        eventViewScrollView.addSubview(registered.view)
        registered.didMove(toParent: self)
        registered.view.frame = registeredFrame
        
        eventScrollView.isScrollEnabled = false
        eventScrollView.canCancelContentTouches = false
        eventScrollView.delaysContentTouches = true
        eventScrollView.contentSize = CGSize(width: 3 * width,
                                        height: height)
        
        eventViewScrollView.setNeedsLayout()
        eventViewScrollView.layoutIfNeeded()
        scrollView.setNeedsLayout()
        eventScrollView.layoutIfNeeded()
        view.layoutIfNeeded()
    }
    
    func initNotification() {
        NotificationManager.observe(.showPopupCode)
            .subscribe(onNext: { [weak self] _ in
                self?.showPopupCode()
            })
            .disposed(by: disposeBag)
    }
    
    func bindViewModel() {
        observeUpdate()
    }
    
    func observeUpdate() {
        viewModel.outputs.update
            .subscribe(onNext: { [weak self] _ in
                // doing update
            })
            .disposed(by: disposeBag)
    }
}

extension HomeViewController: TabViewDelegate {
    func tabView(_ tabView: TabView, didSelectAt index: Int) {
        if index == 0 {
            eventsView.isHidden = true
        } else if index == 1 {
            eventsView.isHidden = false
        }
    }
}

extension HomeViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print(scrollView.contentOffset.x)
    }
}



extension HomeViewController {
    @objc func mine(animated: Bool = true) {
        isMine = true
        let firstPage = CGPoint(x: 0, y: scrollView.contentOffset.y)
        scrollView.setContentOffset(firstPage, animated: animated)
        othersButton.setTitleColor(.lightGray, for: .normal)
        othersButton.backgroundColor = .clear
        mineButton.setTitleColor(.white, for: .normal)
        mineButton.backgroundColor = .defaultBlue
    }
    
    @objc func others(animated: Bool = true) {
        isMine = false
        mineButton.setTitleColor(.lightGray, for: .normal)
        mineButton.backgroundColor = .clear
        othersButton.setTitleColor(.white, for: .normal)
        othersButton.backgroundColor = .defaultBlue
        let screen = UIScreen.main.bounds
        let secondPage = CGPoint(x: screen.width,
                                 y: scrollView.contentOffset.y)
        scrollView.setContentOffset(secondPage, animated: animated)
    }
    
    @objc func sidemenu() {
        if let drawerController = navigationController?.parent as? KYDrawerController {
            drawerController.setDrawerState(.opened, animated: true)
        }
    }
    
    @objc func notifications() {
        let vc = NotificationsCoordinator.createNotificationsViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func showPopupCode() {
        let vc = PopupCodeViewController()
        vc.delegate = self
        vc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func addActivity() {
        let vc = ActivityCoordinator.createActivityViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func all() {
        let firstPage = CGPoint(x: 0, y: eventScrollView.contentOffset.y)
        eventScrollView.setContentOffset(firstPage, animated: true)
        allButton.setTitleColor(.white, for: .normal)
        thisMonthButton.setTitleColor(.lightGray, for: .normal)
        registeredButton.setTitleColor(.lightGray, for: .normal)
        allButton.backgroundColor = .defaultBlue
        thisMonthButton.backgroundColor = .white
        registeredButton.backgroundColor = .white
    }
    
    @objc func thisMonth() {
        let screen = UIScreen.main.bounds
        let secondPage = CGPoint(x: screen.width,
                                 y: eventScrollView.contentOffset.y)
        eventScrollView.setContentOffset(secondPage, animated: true)
        let firstPage = CGPoint(x: 0, y: scrollView.contentOffset.y)
        scrollView.setContentOffset(firstPage, animated: true)
        thisMonthButton.setTitleColor(.white, for: .normal)
        allButton.setTitleColor(.lightGray, for: .normal)
        registeredButton.setTitleColor(.lightGray, for: .normal)
        thisMonthButton.backgroundColor = .defaultBlue
        allButton.backgroundColor = .white
        registeredButton.backgroundColor = .white
    }
    
    @objc func registered() {
        let screen = UIScreen.main.bounds
        let thirdPage = CGPoint(x: screen.width * 2,
                                 y: eventScrollView.contentOffset.y)
        eventScrollView.setContentOffset(thirdPage, animated: true)
        registeredButton.setTitleColor(.white, for: .normal)
        thisMonthButton.setTitleColor(.lightGray, for: .normal)
        allButton.setTitleColor(.lightGray, for: .normal)
        registeredButton.backgroundColor = .defaultBlue
        thisMonthButton.backgroundColor = .white
        allButton.backgroundColor = .white
    }
    
    @objc func search() {
        if isSearch {
            isSearch = false
            heightSearchConstraint.constant = 0
        } else {
            isSearch = true
            heightSearchConstraint.constant = 50
        }
    }
}

extension HomeViewController: PopupCodeSuccessDelegate {
    func pushToDetailVC(code: String) {
        let emptyModel = ActivityListResponse.init(actId: nil, actCode: nil, actName: nil, actDesc: nil, actDateTimeStart: nil, actTimezone: nil, actPublic: nil, actCreated: nil, actComments: nil, actUserid: nil, actLikes: nil, actIslike: nil,actLocation: nil, photos: [])
        let emptyModel2 = ActivityListOthersResponse.init(actId: nil, actCode: nil, actName: nil, actDesc: nil, actDateTimeStart: nil, actTimezone: nil, actCreated: nil, actComments: nil, actUserid: nil, actLikes: nil, actIslike: nil, actmemActive: nil, actmemDate: nil, ownerId: nil, ownerName: nil, ownerPhoto: nil, photos: [])
        let vc = DetailActivityCoordinator.createDetailActivityViewController(activityModel: emptyModel, activityModelOthers: emptyModel2, isFromList: false, joinActivityCode: code, isFromFriend: false)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension HomeViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text?.count == 0 {
            ToastView.show(message: "Text must be filled", in: self, length: .short)
            return false
        }
        textField.resignFirstResponder()
        let vc = SearchEventsCoordinator.createSearchEventsViewController(keyword: textField.text ?? "")
        navigationController?.pushViewController(vc, animated: true)
        return true
    }
}


