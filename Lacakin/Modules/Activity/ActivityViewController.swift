//  
//  ActivityViewController.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 20/01/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import UIKit
import RxSwift
import GooglePlaces

class ActivityViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: ActivityViewModel!
    var coordinator: ActivityCoordinator!
    let dateFormatter = DateFormatter()
    let locale = NSLocale.current
    var datePicker: UIDatePicker?
    var toolBar: UIToolbar?
    var activityDate = ""
    var activityTime = ""
    var isPublic = true
    var isJoin = true
    var disableNoButton = false
    var isEdit = false
    var titleEdit = ""
    var dateEdit = Date()
    var locationEdit = ""
    var latEdit = ""
    var lngEdit = ""
    var timezoneEdit = ""
    var descEdit = ""
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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

extension ActivityViewController {
    
    func setupViews() {
        if isEdit {
            addDefaultTitleNav(title: "Edit activity")
            setDateTime(date: dateEdit)
        } else {
            addDefaultTitleNav(title: "Add activity")
            viewModel.inputs.onJoinApprovalChanged("1")
            viewModel.inputs.onPublicChanged("1")
            setDateTime()
        }
        addLeftBackButton(#selector(back))
        addRightBarButtonSave(#selector(save))
        initTableView()
    }
    
    func setDateTime(date: Date = Date()) {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        activityDate = date.dateToString()
        activityTime = "\(hour):\(minutes)"
        viewModel.inputs.onDateChanged(activityDate)
        viewModel.inputs.onTimeChanged(activityTime)
        
    }
    
    func initTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.separatorColor = .clear
        tableView.registerNib(ActivityTitleTableViewCell.self)
        tableView.registerNib(ActivityTimeTableViewCell.self)
        tableView.registerNib(ActivityLocationTableViewCell.self)
        tableView.registerNib(ActivityDescTableViewCell.self)
        tableView.registerNib(ActivityControlsTableViewCell.self)
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
    }
    
    func bindViewModel() {
        observeError()
        observeLoading()
        observeSaveSuccess()
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
    
    func observeSaveSuccess() {
        viewModel.outputs.shouldNotifySaveSuccess
            .subscribe(onNext: { _ in
                if self.isEdit {
                    NotificationCenter.default.post(name: Notification.Name("updateDetailActivity"), object: nil, userInfo: nil)
                    self.navigationController?.popViewController(animated: true)
                } else {
                    self.navigationController?.popToRootViewController(animated: true)
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

extension ActivityViewController {
    @objc func back() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func save() {
        viewModel.inputs.onAddActivityClicked()
    }
}

extension ActivityViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return ActivityCell.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch ActivityCell(rawValue: section)! {
        case .controls, .desc, .location, .time, .title:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch ActivityCell(rawValue: indexPath.section)! {
        case .title:
            let cell = tableView.dequeueClass(ActivityTitleTableViewCell.self)
            if isEdit {
                cell.titleTextField.text = titleEdit
            }
            cell.titleTextField.rx.text.orEmpty
                .distinctUntilChanged()
                .subscribe(onNext: { [unowned self] text in
                    if self.isEdit {
                        self.titleEdit = text
                    }
                    self.viewModel.inputs.onTitleChanged(text)
                })
                .disposed(by: disposeBag)
            cell.configure()
            return cell
        case .time:
            let cell = tableView.dequeueClass(ActivityTimeTableViewCell.self)
            cell.configure(date: activityDate, time: activityTime)
            cell.dateButton.rx.tap
                .subscribe(onNext: { [unowned self] in
                    self.doDatePicker(mode: .date, done: #selector(self.dateDone))
                })
                .disposed(by: disposeBag)
            cell.timeButton.rx.tap
                .subscribe(onNext: { [unowned self] in
                    self.doDatePicker(mode: .time, done: #selector(self.timeDone))
                })
                .disposed(by: disposeBag)
            return cell
        case .location:
            let cell = tableView.dequeueClass(ActivityLocationTableViewCell.self)
            if isEdit {
                cell.locationTextField.text = locationEdit
                viewModel.inputs.onLocationChanged(locationEdit)
                viewModel.inputs.onLatLongChanged("\(latEdit),\(lngEdit)")
            }
            cell.configure(location: viewModel.outputs.actLocation)
            cell.locationButton.rx.tap
                .subscribe(onNext: { [unowned self] in
                    self.autocompleteClicked()
                })
                .disposed(by: disposeBag)
            return cell
        case .desc:
            let cell = tableView.dequeueClass(ActivityDescTableViewCell.self)
            cell.configure(isEdit: isEdit)
            if isEdit {
                cell.descTextView.text = descEdit
            }
            cell.descTextView.rx.text.orEmpty
                .distinctUntilChanged()
                .subscribe(onNext: { [unowned self] text in
                    if self.isEdit {
                        self.descEdit = text
                    }
                    self.viewModel.inputs.onDescChanged(text)
                })
                .disposed(by: disposeBag)
            return cell
        case .controls:
            let cell = tableView.dequeueClass(ActivityControlsTableViewCell.self)
            cell.configure(isPublic: isPublic, isJoin: isJoin, disableNoButton: disableNoButton)
            cell.publicButton.rx.tap
                .subscribe(onNext: { [unowned self] in
                    self.setPublic()
                })
                .disposed(by: disposeBag)
            cell.privateButton.rx.tap
                .subscribe(onNext: { [unowned self] in
                    self.setPrivate()
                })
                .disposed(by: disposeBag)
            cell.yesButton.rx.tap
                .subscribe(onNext: { [unowned self] in
                    self.setYes()
                })
                .disposed(by: disposeBag)
            cell.noButton.rx.tap
                .subscribe(onNext: { [unowned self] in
                    self.setNo()
                })
                .disposed(by: disposeBag)
            return cell
        }
    }
}

extension ActivityViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch ActivityCell(rawValue: indexPath.section)! {
        case .title:
            return 50
        case .time:
            return 50
        case .location:
            return 50
        case .desc:
            return 150
        case .controls:
            return 150
        }
    }
}

extension ActivityViewController {
    func doDatePicker(mode: UIDatePicker.Mode, done: Selector) {
        // DatePicker
        view.endEditing(true)
        if datePicker != nil {
            datePicker?.removeFromSuperview()
        }
        datePicker = UIDatePicker()
        let screenSize = UIScreen.main.bounds
        datePicker? = UIDatePicker(frame:CGRect(x: 0, y: screenSize.height - 200, width: screenSize.width, height: 200))
        datePicker?.backgroundColor = UIColor.white
        datePicker?.datePickerMode = mode
        view.addSubview(datePicker!)
        
        // ToolBar
        if toolBar != nil {
            toolBar?.removeFromSuperview()
        }
        toolBar = UIToolbar()
        toolBar?.barStyle = .default
        toolBar?.frame = CGRect(x: 0,y: screenSize.height - 246, width:screenSize.width,height: 46)
        toolBar?.isTranslucent = true
        toolBar?.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        toolBar?.sizeToFit()
        
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: done)
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelClick))
        toolBar?.setItems([cancelButton, spaceButton, doneButton], animated: true)
        toolBar?.isUserInteractionEnabled = true
        view.addSubview(toolBar!)
        toolBar?.isHidden = false
        
    }
    
    @objc func dateDone() {
        datePicker?.removeFromSuperview()
        toolBar?.removeFromSuperview()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let dateString = dateFormatter.string(from: datePicker?.date ?? Date())
        viewModel.inputs.onDateChanged(dateString)
        activityDate = dateString
        let indexPath = IndexPath(item: 0, section: 1)
        tableView.reloadRows(at: [indexPath], with: .none)
    }
    
    @objc func timeDone() {
        datePicker?.removeFromSuperview()
        toolBar?.removeFromSuperview()
        dateFormatter.dateFormat = "HH:mm"
        let timeString = dateFormatter.string(from: datePicker?.date ?? Date())
        viewModel.inputs.onTimeChanged(timeString)
        activityTime = timeString
        let indexPath = IndexPath(item: 0, section: 1)
        tableView.reloadRows(at: [indexPath], with: .none)
    }
    
    @objc func cancelClick() {
        datePicker?.removeFromSuperview()
        toolBar?.removeFromSuperview()
    }
    
    @objc func setPublic() {
        self.isPublic = true
        viewModel.inputs.onPublicChanged("1")
        disableNoButton = false
        let indexPath = IndexPath(item: 0, section: 4)
        tableView.reloadRows(at: [indexPath], with: .none)
    }
    
    @objc func setPrivate() {
        viewModel.inputs.onPublicChanged("0")
        viewModel.inputs.onJoinApprovalChanged("1")
        disableNoButton = true
        self.isPublic = false
        self.isJoin = true
        let indexPath = IndexPath(item: 0, section: 4)
        tableView.reloadRows(at: [indexPath], with: .none)
    }
    
    @objc func setYes() {
        viewModel.inputs.onJoinApprovalChanged("1")
        self.isJoin = true
        let indexPath = IndexPath(item: 0, section: 4)
        tableView.reloadRows(at: [indexPath], with: .none)
    }
    
    @objc func setNo() {
        viewModel.inputs.onJoinApprovalChanged("0")
        self.isJoin = false
        let indexPath = IndexPath(item: 0, section: 4)
        tableView.reloadRows(at: [indexPath], with: .none)
    }
    
    // Present the Autocomplete view controller when the button is pressed.
    @objc func autocompleteClicked() {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        // Specify a filter.
        let filter = GMSAutocompleteFilter()
        filter.type = .noFilter
        filter.country = "ID"
        autocompleteController.autocompleteFilter = filter
        
        // Display the autocomplete view controller.
        present(autocompleteController, animated: true, completion: nil)
    }
}


extension ActivityViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(place.name)")
        print("Place ID: \(place.placeID)")
        print("Place attributions: \(place.attributions)")
        viewModel.inputs.onLocationChanged(place.name ?? "")
        viewModel.inputs.onLatLongChanged("\(place.coordinate.latitude),\(place.coordinate.longitude)")
        
        locationEdit = place.name ?? ""
        latEdit = "\(place.coordinate.latitude)"
        lngEdit = "\(place.coordinate.longitude)"
        
        let indexPath = IndexPath(item: 0, section: 2)
        tableView.reloadRows(at: [indexPath], with: .none)
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
}
