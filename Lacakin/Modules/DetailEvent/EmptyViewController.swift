//
//  EmptyViewController.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 19/08/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import UIKit

class EmptyViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.activityIndicatorBegin()
        let randomInt = Int.random(in: 0..<30)
        var timer = Timer.scheduledTimer(timeInterval: TimeInterval(randomInt), target: self, selector: #selector(timerDidFire), userInfo: nil, repeats: true)
        // Do any additional setup after loading the view.
    }

    @objc private func timerDidFire(timer: Timer) {
        ToastView.show(message: "Failed to map json", in: self, length: .short)
        self.activityIndicatorEnd()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
