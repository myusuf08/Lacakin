//  
//  SearchEventsViewController.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 23/06/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import UIKit
import RxSwift

class SearchEventsViewController: BaseViewController {

    @IBOutlet weak var bgFilterView: UIView!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var filterImageView: UIImageView!
    @IBOutlet weak var fromDateTextField: UITextField!
    @IBOutlet weak var toDateTextField: UITextField!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var minCostTextField: UITextField!
    @IBOutlet weak var maxCostTextField: UITextField!
    @IBOutlet weak var locationView: UIView!
    @IBOutlet weak var selectLocationTextField: UITextField!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var updateFilterButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var heightFilterView: NSLayoutConstraint! // 380
    
    var viewModel: SearchEventsViewModel!
    var coordinator: SearchEventsCoordinator!
    var isFilter = false
    var fromDate = ""
    var toDate = ""
    var location = ""
    
    var locationDummy = ["Aceh","Sumatera Utara", "Sumatera Barat", "Riau", "Jambi", "Sumatera Selatan", "Bengkulu", "Lampung", "Kepulauan Bangka Belitung", "Kepulauan Riau", "DKI Jakarta", "Jawa Barat", "Jawa Tengah", "Banten", "Bali", "Yogyakarta", "Nusa Tenggara Barat", "Nusa Tenggara Timur", "Kalimantan Barat", "Kalimantan Tengah", "Kalimantan Selatan", "Kalimantan Timur", "Kalimantan Utara", "Sulawesi Utara", "Sulawesi Tengah", "Sulawesi Selatan", "Sulawesi Tenggara", "Sulawesi Barat", "Maluku", "Maluku Utara", "Papua Barat", "Papua"]
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bindViewModel()
        viewModel.inputs.onViewDidLoad()
        searchTextField.text = viewModel.keyword ?? ""
    }
    
}

// MARK: Private

extension SearchEventsViewController {
    
    func setupViews() {
        initTableView()
        setupButton()
        setupTextField()
    }
    
    func initTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.separatorColor = .clear
        tableView.registerNib(EventsTableViewCell.self)
    }
    
    func setupButton() {
        backButton.addTarget(self, action: #selector(back), for: .touchUpInside)
        resetButton.addTarget(self, action: #selector(reset), for: .touchUpInside)
        closeButton.addTarget(self, action: #selector(close), for: .touchUpInside)
        filterButton.addTarget(self, action: #selector(filter), for: .touchUpInside)
        updateFilterButton.addTarget(self, action: #selector(updateFilter), for: .touchUpInside)
        closeButton.layer.cornerRadius = 8
        closeButton.layer.masksToBounds = true
        closeButton.layer.borderColor = UIColor.lightGray.cgColor
        closeButton.layer.borderWidth = 1
        updateFilterButton.layer.cornerRadius = 8
        updateFilterButton.layer.masksToBounds = true
        updateFilterButton.layer.borderColor = UIColor.clear.cgColor
        updateFilterButton.layer.borderWidth = 1
    }
    
    func setupTextField() {
        self.heightFilterView.constant = 0
        self.bgFilterView.isHidden = true
        self.filterImageView.alpha = 1
        
        searchTextField.clearButtonMode = .always
        searchTextField.returnKeyType = .search
        searchTextField.delegate = self
        
        locationView.layer.borderWidth = 1
        locationView.layer.borderColor = UIColor.lightGray.cgColor
        locationView.layer.cornerRadius = 4
        locationView.layer.masksToBounds = true
        
        fromDateTextField.layer.borderWidth = 1
        fromDateTextField.layer.borderColor = UIColor.lightGray.cgColor
        fromDateTextField.layer.cornerRadius = 4
        fromDateTextField.layer.masksToBounds = true
        
        toDateTextField.layer.borderWidth = 1
        toDateTextField.layer.borderColor = UIColor.lightGray.cgColor
        toDateTextField.layer.cornerRadius = 4
        toDateTextField.layer.masksToBounds = true
        
        
        minCostTextField.layer.borderWidth = 1
        minCostTextField.layer.borderColor = UIColor.lightGray.cgColor
        minCostTextField.layer.cornerRadius = 4
        minCostTextField.layer.masksToBounds = true
        minCostTextField.keyboardType = .numberPad
        
        maxCostTextField.layer.borderWidth = 1
        maxCostTextField.layer.borderColor = UIColor.lightGray.cgColor
        maxCostTextField.layer.cornerRadius = 4
        maxCostTextField.layer.masksToBounds = true
        maxCostTextField.keyboardType = .numberPad
        
        let dateFromPickerView = UIDatePicker()
        dateFromPickerView.datePickerMode = .date
        fromDateTextField.inputView = dateFromPickerView
        dateFromPickerView.addTarget(self, action: #selector(handleFromDatePicker), for: .valueChanged)
        
        
        let toFromPickerView = UIDatePicker()
        toFromPickerView.datePickerMode = .date
        toDateTextField.inputView = toFromPickerView
        toFromPickerView.addTarget(self, action: #selector(handleToDatePicker), for: .valueChanged)
        
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        selectLocationTextField.inputView = pickerView
        
    }
    
    func bindViewModel() {
        observeUpdate()
        observeError()
    }
    
    func observeUpdate() {
        viewModel.outputs.update
            .subscribe(onNext: { [weak self] bool in
                self?.tableView.reloadData()
                self?.tableView.isHidden = !bool
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
    
    @objc func reset() {
        viewModel.resetFilter(keyword: searchTextField.text ?? "")
        fromDate = ""
        toDate = ""
        location = ""
        fromDateTextField.text = ""
        toDateTextField.text = ""
        minCostTextField.text = ""
        maxCostTextField.text = ""
        selectLocationTextField.text = ""
    }
    
    @objc func close() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.33, execute: {
            self.heightFilterView.constant = 0
            self.bgFilterView.isHidden = true
            self.filterImageView.alpha = 1
        })
    }
    
    @objc func filter() {
        if isFilter {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.33, execute: {
                self.heightFilterView.constant = 0
                self.bgFilterView.isHidden = true
                self.filterImageView.alpha = 1
            })
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.33, execute: {
                self.heightFilterView.constant = 380
                self.bgFilterView.isHidden = false
                self.filterImageView.alpha = 0.5
            })
            
        }
    }
    
    @objc func updateFilter() {
        viewModel.setFilter(keyword: searchTextField.text ?? "", fromDate: fromDate, toDate: toDate, minCost: Int(minCostTextField.text ?? "") ?? 0, maxCost: Int(maxCostTextField.text ?? "") ?? 0, location: location)
    }
    
    @objc func handleFromDatePicker(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        fromDateTextField.text = dateFormatter.string(from: sender.date)
        fromDate = "\(sender.date.timeIntervalSince1970)"
    }
    
    @objc func handleToDatePicker(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        toDateTextField.text = dateFormatter.string(from: sender.date)
        toDate = "\(sender.date.timeIntervalSince1970)"
    }
    
}


extension SearchEventsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.outputs.model?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = viewModel.outputs.model?[indexPath.row]
        let cell = tableView.dequeueClass(EventsTableViewCell.self)
        guard let models = model else {
            return cell
        }
        cell.configure(model: models)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension SearchEventsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = viewModel.outputs.model?[indexPath.row]
        let vc = DetailEventCoordinator.createDetailEventViewController(eventId: "\(model?.eventId ?? 0)")
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension SearchEventsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == searchTextField {
            viewModel.getAllListEventFiltered()
            searchTextField.resignFirstResponder()
            return true
        }
        return true
    }
}

extension SearchEventsViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return locationDummy.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return locationDummy[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let itemselected = locationDummy[row]
        selectLocationTextField.text = itemselected
        location = itemselected
    }
}
