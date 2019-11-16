//  
//  PhotoActivityViewController.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 23/04/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import UIKit
import RxSwift
import GSImageViewerController

class PhotoActivityViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    let picker = UIImagePickerController()
    var imageSend = UIImage()
    var isPushReady = false
    var viewModel: PhotoActivityViewModel!
    var coordinator: PhotoActivityCoordinator!
    var isMemberValid: Bool? = false

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bindViewModel()
        viewModel.inputs.onViewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if isPushReady {
            isPushReady = false
            let vc = UploadPhotoViewController()
            vc.actId = viewModel.actId
            vc.image = imageSend
            navigationController?.pushViewController(vc, animated: false)
        } else {
            viewModel.inputs.onViewDidAppear()
        }
    }
}

// MARK: Private

extension PhotoActivityViewController {
    
    func setupViews() {
        addDefaultTitleNav(title: "Photo Activity")
        addLeftBackButton(#selector(back))
        if isMemberValid == true {
            addRightBarButtonAdd(#selector(add))
        }
        initTableView()
        picker.delegate = self
    }
    
    func initTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.separatorColor = .clear
        tableView.registerNib(PhotoActivityTableViewCell.self)
    }
    
    func bindViewModel() {
        observeUpdate()
        observeError()
        observeLoading()
    }
    
    func observeLoading() {
        viewModel.outputs.loading
            .subscribe(onNext: { [weak self] loading in
                if loading {
                    self?.activityIndicatorBegin(false)
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
    
    @objc func add() {
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        self.present(picker, animated: true, completion: nil)
    }
}

extension PhotoActivityViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.outputs.model?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = viewModel.outputs.model?[indexPath.row]
        print("indexPath button model= \(indexPath.row)")
        let cell = tableView.dequeueClass(PhotoActivityTableViewCell.self)
        cell.configure(model: model)
        cell.bgButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                let imageInfo = GSImageInfo(image: cell.bgImageView.image ?? UIImage(), imageMode: .aspectFit)
                let transitionInfo = GSTransitionInfo(fromView: self.view)
                let imageViewer    = GSImageViewerController(imageInfo: imageInfo, transitionInfo: transitionInfo)
                self.present(imageViewer, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        cell.didTrashTap = {
            print("indexPath button = \(indexPath.row)")
            let alert = UIAlertController(title: "Delete Image", message: "Are you sure to delete this image?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "DELETE", style: .default, handler: { action in
                switch action.style{
                case .default:
                    print("default")
                    self.viewModel.inputs.deletePhoto(photoId: "\(model?.actphoId ?? 0)")
                case .cancel:
                    print("cancel")
                case .destructive:
                    print("destructive")
                }}))
            alert.addAction(UIAlertAction(title: "CANCEL", style: .cancel, handler: { action in
                switch action.style{
                case .default:
                    print("default")
                case .cancel:
                    print("cancel")
                    alert.dismiss(animated: true, completion: nil)
                case .destructive:
                    print("destructive")
                }}))
            self.present(alert, animated: true, completion: nil)
        }
        return cell
    }
}

extension PhotoActivityViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 210
    }
}

extension PhotoActivityViewController: UINavigationControllerDelegate {
    
}

extension PhotoActivityViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            imageSend = image
            isPushReady = true
        }
        picker.dismiss(animated: false, completion: nil);
    }
}

