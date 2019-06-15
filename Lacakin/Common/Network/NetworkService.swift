//
//  NetworkService.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 07/02/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import Foundation
import UIKit
import Moya

//let networkActivityClosure = NetworkActivityPlugin { change, target  in
//    if change == .began {
//        UIApplication.shared.isNetworkActivityIndicatorVisible = true
//    } else {
//        UIApplication.shared.isNetworkActivityIndicatorVisible = false
//    }
//}

//var tokenClosure: String {
//    return ""//UserUtil.shared.token ?? ""
//}
//let authPlugin = AccessTokenPlugin { () -> String in tokenClosure }

let lacakinApiProvider = MoyaProvider<LacakinApi>(plugins: [NetworkLoggerPlugin(verbose: true)])//, //networkActivityClosure, authPlugin])

public enum LacakinApi {
    case login(LoginRequest)
    case loginGoogle(LoginGoogleRequest)
    case register(RegisterRequest)
    case requestOTP(RequestOTPRequest)
    case confirmOTP(ConfirmOTPRequest)
    case activityList(ActivityListRequest)
    case activityListOthers(ActivityListOthersRequest)
    case addActivity(AddActivityRequest)
    case logout(LogoutRequest)
    case resetPassword(ResetPasswordRequest)
    case newPassword(NewPasswordRequest)
    case setUsername(SetUsernameRequest)
    case setPassword(SetPasswordRequest)
    case setEmail(SetEmailRequest)
    case setPhone(SetPhoneRequest)
    case setOTPPhone(SetOTPPhoneRequest)
    case updatePhoto(UpdatePhotoRequest)
    case updateProfile(UpdateProfileRequest)
    case getProfile()
    case detailActivity(DetailActivityRequest)
    case editActivity(EditActivityRequest)
    case joinActivity(JoinActivityRequest)
    case detailJoinActivity(DetailJoinActivityRequest)
    case detailBeforeJoinActivity(DetailBeforeJoinActivityRequest)
    case memberActivityList(MemberActivityListRequest)
    case memberActivityListOthers(MemberActivityListOthersRequest)
    case memberJoinActivityList(MemberJoinActivityListRequest)
    case approveMemberActivity(ApproveMemberActivityRequest)
    case friendProfile(FriendProfileRequest)
    case friendActivity(FriendActivityRequest)
    case listLikeActivity(ListLikeActivityRequest)
    case userLikeActivity(UserLikeActivityRequest)
    case userDislikeActivity(UserDislikeActivityRequest)
    case listCommentActivity(ListCommentActivityRequest)
    case commentActivity(CommentActivityRequest)
    case listPhotoActivity(ListPhotoActivityRequest)
    case deletePhotoActivity(DeletePhotoActivityRequest)
    case startTracking(StartTrackingRequest)
    case stopTracking(StopTrackingRequest)
    case listRoute(ListRouteRequest)
    case listCheckpoint(ListCheckpointRequest)
    case listNearby(ListNearbyRequest)
    case checkinCheckpoint(CheckinCheckpointRequest)
    case listGroupChat(ListGroupChatRequest)
    case importRoute(ImportRouteRequest)
}

extension LacakinApi: TargetType, AccessTokenAuthorizable {
    
    public var baseURL: URL { return URL(string: String.BaseApiUrl)! }
    
    public var path: String {
        switch self {
        case .login: return "/user/login"
        case .loginGoogle: return "/auth/google"
        case .register: return "/user/reg"
        case .requestOTP: return "/user/req_otp"
        case .confirmOTP: return "/user/confirm_otp"
        case .activityList: return "/activity/list"
        case .activityListOthers: return "/activity/list_join"
        case .addActivity: return "/activity/add/plan"
        case .logout: return "/user/logout"
        case .resetPassword: return "/user/reset_password"
        case .newPassword: return "/user/new_password"
        case .setUsername: return "/user/set/username"
        case .setPassword: return "/user/set/password"
        case .setEmail: return "/user/set/email"
        case .setPhone: return "/user/set/phone"
        case .setOTPPhone: return "/user/confirm/set_phone"
        case .updatePhoto: return "/user/set/pic"
        case .updateProfile: return "/user/update_profile"
        case .getProfile: return "/user/get/profile"
        case .detailActivity(let request): return "/activity/detail/\(request.code ?? "")"
        case .editActivity: return "/activity/edit"
        case .joinActivity: return "/activity/join"
        case .detailJoinActivity(let request): return "/activity/detail/join/\(request.code ?? "")"
        case .detailBeforeJoinActivity(let request): return "/activity/detail/before/\(request.code ?? "")"
        case .memberActivityList: return "/activity/list_member"
        case .memberActivityListOthers: return "/activity/list_member_other"
        case .memberJoinActivityList(let request): return "/activity/list/member/join/\(request.code ?? "")"
        case .approveMemberActivity: return "/activity/approve_member"
        case .friendProfile: return "/user/get/friend"
        case .friendActivity: return "/user/get/friend/act"
        case .listLikeActivity: return "/activity/list_likes"
        case .userLikeActivity: return "/activity/like"
        case .userDislikeActivity: return "/activity/unlike"
        case .listCommentActivity: return "/activity/list_comment"
        case .commentActivity: return "/activity/add_comment"
        case .listPhotoActivity: return "/activity/list_photo"
        case .deletePhotoActivity: return "/activity/del_photo"
        case .startTracking: return "/activity/tracking/start"
        case .stopTracking: return "/activity/tracking/stop"
        case .listRoute(let request): return "/activity/list/routes/\(request.code ?? "")"
        case .listCheckpoint(let request): return "/activity/list/cps/\(request.code ?? "")"
        case .listNearby(let request): return "/activity/nearby/\(request.code ?? "")"
        case .checkinCheckpoint: return "/activity/cekin/cp"
        case .listGroupChat(let request): return "/chat/msg/group/\(request.code ?? "")"
        case .importRoute(let request): return "/import/route"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .activityList, .activityListOthers, .getProfile, .detailActivity, .detailJoinActivity , .detailBeforeJoinActivity, .memberActivityList, .memberJoinActivityList, .memberActivityListOthers, .friendProfile ,
             .friendActivity, .getProfile, .listLikeActivity, .listCommentActivity ,.listPhotoActivity, .listRoute, .listCheckpoint, .listNearby, .listGroupChat, .logout:
            return .get
        default:
            return .post
        }
    }
    
    public var sampleData: Data {
        return "".data(using: .utf8)!
    }
    
    public var task: Task {
        switch self {
        case .login(let request):
            return jsonEncodedTask(parameters: request.dictionary ?? [:])
        case .loginGoogle(let request):
            return jsonEncodedTask(parameters: request.dictionary ?? [:])
        case .register(let request):
            return jsonEncodedTask(parameters: request.dictionary ?? [:])
        case .requestOTP(let request):
            return jsonEncodedTask(parameters: request.dictionary ?? [:])
        case .confirmOTP(let request):
            return jsonEncodedTask(parameters: request.dictionary ?? [:])
        case .activityList(let request):
            return urlEncodedTask(parameters: request.dictionary ?? [:])
        case .activityListOthers(let request):
            return urlEncodedTask(parameters: request.dictionary ?? [:])
        case .addActivity(let request):
            return jsonEncodedTask(parameters: request.dictionary ?? [:])
        case .editActivity(let request):
            return jsonEncodedTask(parameters: request.dictionary ?? [:])
        case .logout(let request):
            return urlEncodedTask(parameters: request.dictionary ?? [:])
        case .resetPassword(let request):
            return jsonEncodedTask(parameters: request.dictionary ?? [:])
        case .newPassword(let request):
            return jsonEncodedTask(parameters: request.dictionary ?? [:])
        case .setUsername(let request):
            return jsonEncodedTask(parameters: request.dictionary ?? [:])
        case .setPassword(let request):
            return jsonEncodedTask(parameters: request.dictionary ?? [:])
        case .setEmail(let request):
            return jsonEncodedTask(parameters: request.dictionary ?? [:])
        case .setPhone(let request):
            return jsonEncodedTask(parameters: request.dictionary ?? [:])
        case .setOTPPhone(let request):
            return jsonEncodedTask(parameters: request.dictionary ?? [:])
        case .updatePhoto(let request):
            return jsonEncodedTask(parameters: request.dictionary ?? [:])
        case .updateProfile(let request):
            return jsonEncodedTask(parameters: request.dictionary ?? [:])
        case .getProfile(let request):
            return .requestPlain
        case .detailActivity(let request):
            return .requestPlain
        case .joinActivity(let request):
            return jsonEncodedTask(parameters: request.dictionary ?? [:])
        case .detailJoinActivity(let request):
            return .requestPlain
        case .detailBeforeJoinActivity(let request):
             return .requestPlain
        case .memberActivityList(let request):
            return urlEncodedTask(parameters: request.dictionary ?? [:])
        case .memberJoinActivityList(let request):
            return .requestPlain
        case .memberActivityListOthers(let request):
            return urlEncodedTask(parameters: request.dictionary ?? [:])
        case .approveMemberActivity(let request):
            return jsonEncodedTask(parameters: request.dictionary ?? [:])
        case .friendProfile(let request):
            return urlEncodedTask(parameters: request.dictionary ?? [:])
        case .friendActivity(let request):
            return urlEncodedTask(parameters: request.dictionary ?? [:])
        case .listLikeActivity(let request):
            return urlEncodedTask(parameters: request.dictionary ?? [:])
        case .userLikeActivity(let request):
            return jsonEncodedTask(parameters: request.dictionary ?? [:])
        case .userDislikeActivity(let request):
            return jsonEncodedTask(parameters: request.dictionary ?? [:])
        case .listCommentActivity(let request):
            return urlEncodedTask(parameters: request.dictionary ?? [:])
        case .commentActivity(let request):
            return jsonEncodedTask(parameters: request.dictionary ?? [:])
        case .listPhotoActivity(let request):
            return urlEncodedTask(parameters: request.dictionary ?? [:])
        case .deletePhotoActivity(let request):
            return jsonEncodedTask(parameters: request.dictionary ?? [:])
        case .startTracking(let request):
            return jsonEncodedTask(parameters: request.dictionary ?? [:])
        case .stopTracking(let request):
            return jsonEncodedTask(parameters: request.dictionary ?? [:])
        case .listRoute(let request):
            return urlEncodedTask(parameters: request.dictionary ?? [:])
        case .listCheckpoint(let request):
            return urlEncodedTask(parameters: request.dictionary ?? [:])
        case .listNearby(let request):
            return urlEncodedTask(parameters: request.dictionary ?? [:])
        case .checkinCheckpoint(let request):
            return jsonEncodedTask(parameters: request.dictionary ?? [:])
        case .listGroupChat(let request):
            return urlEncodedTask(parameters: request.dictionary ?? [:])
        case .importRoute(let request):
            return jsonEncodedTask(parameters: request.dictionary ?? [:])
        }
    }
    
    private func jsonEncodedTask(parameters: [String: Any]) -> Task {
        return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
    }
    
    private func urlEncodedTask(parameters: [String: Any]) -> Task {
        return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
    }
    
    public var headers: [String : String]? {
        switch self {
        case .login, .register, .loginGoogle, .resetPassword:
            return nil
        default:
            return ["x-access-token":User.shared.header ?? ""]
        }
    }
    
    public var authorizationType: AuthorizationType {
        switch self {
        case .login, .register:
            return .none
        default:
            return .none
        }
    }
    
}

