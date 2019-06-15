//  
//  WebViewViewModel.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 20/01/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import Foundation
import RxSwift

protocol WebViewViewModelType {
    var inputs: WebViewViewModelInputs { get }
    var outputs: WebViewViewModelOutputs { get }
}

protocol WebViewViewModelInputs {
    func onViewDidLoad()
}

protocol WebViewViewModelOutputs {
    var update: Observable<Bool> { get }
    var title: Observable<String> { get }
    var url: Observable<String> { get }
    var text: Observable<String> { get }
}

class WebViewViewModel: BaseViewModel {

    private let updateVariable = Variable<Bool>(false)
    private let titleNavigation = Variable<String>("")
    private let urlVariable = Variable<String>("")
    private var textVariable = Variable<String>("")
    var isWebView = false
    var urlWebview = ""
    var WebViewModel: WebViewModel?
    
    init(title: String, url: String, isWebView: Bool) {
        super.init()
        self.titleNavigation.value = title
        self.urlWebview = url
        self.isWebView = isWebView
    }
}

// MARK: Private

extension WebViewViewModel {
    
}

extension WebViewViewModel: WebViewViewModelType {
    var inputs: WebViewViewModelInputs { return self }
    var outputs: WebViewViewModelOutputs { return self }
}

extension WebViewViewModel: WebViewViewModelInputs {
    
    func onViewDidLoad() {
        if isWebView {
            urlVariable.value = urlWebview
        } else {
            textVariable.value = """
            This privacy policy governs your use of Lacakin (“Apps”) that was created by PT. Gamatechno Indonesia (“Gamatechno”). Lacakin is a smartphone based GPS tracker, enabling users to see each other on the map by using the same event code.
            
            What information does the Application obtain and how is it used?
            
            User Provided Information
            
            The Apps obtains the information you provide when you download and register the Apps. Registration with us is optional. However, please keep in mind that you may not be able to use some of the features offered by the Apps unless you register with us.
            
            When you register with us and use the Apps, you generally provide (a) your name, email address, phone number; (b) transaction-related information, such as when you make purchases, respond to any offers, or download or use the apps from us; (c) information you provide us when you contact us for help; (d) credit card information for purchase and use of the Apps, and; (e) information you enter into our system when using the Apps, such as contact information.
            
            We may also use the information you provided us to contact your from time to time to provide you with important information, required notices and marketing promotions.
            
            Automatically Collected Information
            
            In addition, the Apps may collect certain information automatically, including, but not limited to, the type of mobile device you use, your mobile devices unique device ID, the IP address of your mobile device, your mobile operating system, the type of mobile Internet browsers you use, and information about the way you use the Apps.
            
            Does the Apps collect precise real time location information of the device?
            
            When you use the Apps, we use GPS technology to determine your current location, displays your location on the map, and shares your location to other Apps users who is using the same event code. We will not share your current location with users outside of this Apps or partners.
            
            If you do not want us to use your location for the purposes set forth above, you should turn off the location services for the mobile apps located in your account settings or in your mobile phone settings and/or within the mobile apps.
            
            Do third parties see and/or have access to information obtained by the Apps?
            
            Only aggregated, anonymized data is periodically transmitted to external services to help us improve the Apps and our service. We will share your information with third parties only in the ways that are described in this privacy statement.
            
            We may disclose User Provided and Automatically Collected Information:
            
            as required by law, such as to comply with a subpoena, or similar legal process;
            when we believe in good faith that disclosure is necessary to protect our rights, protect your safety or the safety of others, investigate fraud, or respond to a government request;
            with our trusted services providers who work on our behalf, do not have an independent use of the information we disclose to them, and have agreed to adhere to the rules set forth in this privacy statement.
            if Gamatechno is involved in a merger, acquisition, or sale of all or a portion of its assets, you will be notified via email and/or a prominent notice on our Web site of any change in ownership or uses of this information, as well as any choices you may have regarding this information.
            What are my opt-out rights?
            
            You can stop all collection of information by the Apps easily by uninstalling the Apps. You may use the standard uninstall processes as may be available as part of your mobile device or via the mobile apps marketplace or network.
            
            Data Retention Policy, Managing Your Information
            
            We will retain User Provided data for as long as you use the Apps  and for a reasonable time thereafter. We will retain Automatically Collected information for up to 24 months and thereafter may store it in aggregate. If you’d like us to delete User Provided Data that you have provided via the Apps, please contact us at info@lacakin.id and we will respond in a reasonable time. Please note that some or all of the User Provided Data may be required in order for the Apps to function properly.
            
            Security
            
            We are concerned about safeguarding the confidentiality of your information. We provide physical, electronic, and procedural safeguards to protect information we process and maintain. For example, we limit access to this information to authorized employees and contractors who need to know that information in order to operate, develop or improve our Apps. Please be aware that, although we endeavor provide reasonable security for information we process and maintain, no security system can prevent all potential security breaches.
            
            Changes
            
            This Privacy Policy may be updated from time to time for any reason. We will notify you of any changes to our Privacy Policy by posting the new Privacy Policy here and informing you via email or text message. You are advised to consult this Privacy Policy regularly for any changes, as continued use is deemed approval of all changes.
            
            Your Consent
            
            By using the Apps, you are consenting to our processing of your information as set forth in this Privacy Policy now and as amended by us. "Processing,” means using cookies on a computer/hand held device or using or touching information in any way, including, but not limited to, collecting, storing, deleting, using, combining and disclosing information, all of which activities will take place in Indonesia.
            
            Contact us
            
            If you have any questions regarding privacy while using the Apps, or have questions about our practices, please contact us via email at info@lacakin.id
            """
        }
    }
}

extension WebViewViewModel: WebViewViewModelOutputs {
    
    var update: Observable<Bool> {
        return updateVariable.asObservable().filter { $0 }
    }
    
    var title: Observable<String> {
        return titleNavigation.asObservable()
    }
    
    var text: Observable<String> {
        return textVariable.asObservable().filter { $0 != ""}.map{ $0 }
    }
    
    var url: Observable<String> {
        return urlVariable.asObservable().filter { $0 != ""}.map{ $0 }
    }
}
