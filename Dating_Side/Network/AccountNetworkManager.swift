//
//  OnboardingNetworkManager.swift
//  Dating_Side
//
//  Created by 김라영 on 2025/05/07.
//

import Foundation

///계정관련 Network(ex. 성별, 생년월일, 닉네임, 키, 지역, 등)
class AccountNetworkManager {
    private let networkManager: NetworkProtocol
    
    init(networkManager: NetworkProtocol = NetworkManager.shared) {
        self.networkManager = networkManager
    }
    
    func postUserData(signupData: SignupRequest) async throws -> Result<ResponseBoolean, Error> {
        return await networkManager.callWithAsync(endpoint: AccountAPIManager.postUserProfileData(signupData: signupData), httpCodes: .success)
    }
    
    func patchUserData(userData: UserData) async throws -> Result<ResponseBoolean, Error>  {
        return await networkManager.callWithAsync(endpoint: AccountAPIManager.patchUserProfileData(userData: userData), httpCodes: .success)
    }
    
    func fetchUserData() async throws -> Result<UserProfileResponse, Error>  {
        return await networkManager.callWithAsync(endpoint: AccountAPIManager.getUserProfile, httpCodes: .success)
    }
    
    func fetchAddressData(_ addrCode: String? = nil) async throws -> Result<[Address], Error>  {
        return await networkManager.callWithAsync(endpoint: AccountAPIManager.getAddressData(addrCode: addrCode), httpCodes: .success)
    }
 
    func fetchJobType() async throws -> Result<[String], Error>  {
        return await networkManager.callWithAsync(endpoint: AccountAPIManager.getJopTypes, httpCodes: .success)
    }
    
    func fetchPreferenceType(_ preferenceType: String) async throws -> Result<[String], Error>  {
        return await networkManager.callWithAsync(endpoint: AccountAPIManager.getPreferenceTypes(preferenceType: preferenceType), httpCodes: .success)
    }
}

enum AccountAPIManager {
    case getUserProfile
    case patchUserProfileData(userData: UserData)
    case postUserProfileData(signupData: SignupRequest)
    case getAddressData(addrCode: String?)
    case getJopTypes
    case getLifeStyleDatas
    case getPreferenceTypes(preferenceType: String)
}

extension AccountAPIManager: APIManager {
    var path: String {
        switch self {
        case .getUserProfile, .patchUserProfileData:
            return "account"
        case .postUserProfileData:
                return "account/signup"
        case .getAddressData(let addrCode):
            return addrCode == nil ? "address" : "address?code=\(addrCode!)"
        case .getJopTypes:
            return "account/job-type"
        case .getLifeStyleDatas:
            return "account/lifestyle-type"
        case .getPreferenceTypes(let preferenceType):
            return "account/preference-type/preferenceType=\(preferenceType)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getUserProfile, .getAddressData, .getJopTypes, .getLifeStyleDatas, .getPreferenceTypes: return .get
        case .patchUserProfileData: return .patch
        case .postUserProfileData: return .post
        }
    }
    
    var headers: [String : String]? {
        if let accessToken = KeychainManager.shared.getToken(service: "com.loveway.auth", account: "accessToken") {
            return [
                "Content-Type" : "application/json",
                "SMS_Authorization" : "Bearer " + accessToken
            ]
        } else { return nil }
    }
    
    func body() throws -> Data? {
        switch self {
        case .getUserProfile, .getAddressData, .getJopTypes, .getLifeStyleDatas, .getPreferenceTypes:
            return nil
        case .patchUserProfileData(let userProfileData):
            let patchDic = try userProfileData.asPatchJSON()
            let jsonData = try JSONSerialization.data(withJSONObject: patchDic)
            return jsonData
        case .postUserProfileData(let signupData):
            let jsonEncoder = JSONEncoder()
            let jsonData = try jsonEncoder.encode(signupData)
            return jsonData
        }
    }
    
    
}
