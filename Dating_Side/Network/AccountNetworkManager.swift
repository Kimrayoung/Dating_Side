//
//  AccountNetworkManager.swift
//  Dating_Side
//
//  Created by 김라영 on 2025/05/07.
//

import Foundation


///계정관련 Network(ex. 성별, 생년월일, 닉네임, 키, 지역, 등)
struct AccountNetworkManager {
    private let networkManager: NetworkProtocol
    
    init(networkManager: NetworkProtocol = NetworkManager.shared) {
        self.networkManager = networkManager
    }
    
    func postUserData(requestModel: Data, boundaryString: String) async throws -> Result<VoidResponse, Error> {
        return await networkManager.callWithAsync(endpoint: AccountAPIManager.postUserProfileData(signupData: requestModel, boundaryString: boundaryString), httpCodes: .success)
    }
    
    func patchUserData(requestModel: Data, boundaryString: String) async throws -> Result<VoidResponse, Error>  {
        return await networkManager.callWithAsync(endpoint: AccountAPIManager.patchUserProfileData(userData: requestModel, boundaryString: boundaryString), httpCodes: .success)
    }
    
    func fetchAddressData(_ addrCode: String?) async throws -> Result<AddressResponse, Error>  {
        return await networkManager.callWithAsync(endpoint: AccountAPIManager.getAddressData(addrCode: addrCode), httpCodes: .success)
    }
 
    func fetchJobType() async throws -> Result<JobTypeResponse, Error>  {
        return await networkManager.callWithAsync(endpoint: AccountAPIManager.getJopTypes, httpCodes: .success)
    }
    
    func fetchPreferenceType(_ preferenceType: String) async throws -> Result<PreferenceTypeResponse, Error>  {
        return await networkManager.callWithAsync(endpoint: AccountAPIManager.getPreferenceTypes(preferenceType: preferenceType), httpCodes: .success)
    }
    
    func fetchLifeStyleDatas() async throws -> Result<LifeStyleResponse, Error>  {
        return await networkManager.callWithAsync(endpoint: AccountAPIManager.getLifeStyleDatas, httpCodes: .success)
    }
    
    func login(userSocialId: LoginRequest) async throws -> Result<VoidResponse, Error> {
        return await networkManager.callWithAsync(endpoint: AccountAPIManager.login(userSocialId: userSocialId), httpCodes: .success)
    }
    
    func logout() async throws -> Result<VoidResponse, Error> {
        return await networkManager.callWithAsync(endpoint: AccountAPIManager.logout, httpCodes: .success)
    }
    
    func deleteAccount() async throws -> Result<VoidResponse, Error> {
        return await networkManager.callWithAsync(endpoint: AccountAPIManager.accountDelete, httpCodes: .success)
    }
}

enum AccountAPIManager {
    case postUserProfileData(signupData: Data, boundaryString: String)
    case patchUserProfileData(userData: Data, boundaryString: String)
    case getAddressData(addrCode: String?)
    case getJopTypes
    case getLifeStyleDatas
    case getPreferenceTypes(preferenceType: String)
    /// 로그인(소셜로그인 -> 소셜로그인 accessToken 전달 -> 404: 계정 없음)
    case login(userSocialId: LoginRequest)
    case logout
    case accountDelete
}

extension AccountAPIManager: APIManager {
    var path: String {
        switch self {
        case .accountDelete, .patchUserProfileData:
            return "account"
        case .login:
            return "account/login"
        case .logout:
            return "account/logout"
        case .postUserProfileData:
                return "account/signup"
        case .getAddressData(let addrCode):
            return addrCode == nil ? "address" : "address?code=\(addrCode!)"
        case .getJopTypes:
            return "account/job-type"
        case .getLifeStyleDatas:
            return "account/lifestyle-type"
        case .getPreferenceTypes(let preferenceType):
            return "account/preference-type?preferenceType=\(preferenceType)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getAddressData, .getJopTypes, .getLifeStyleDatas, .getPreferenceTypes: return .get
        case .postUserProfileData, .login, .logout: return .post
        case .patchUserProfileData: return .patch
        case .accountDelete: return .delete
        }
    }
    
    var headers: [String : String]? {
        guard let accessToken = KeychainManager.shared.getAccessToken() else { return nil }
        Log.debugPublic("accessToken: ", accessToken)
        
        switch self {
        case .postUserProfileData(_, let boundaryString):
            return [
                "Content-Type" : "multipart/form-data; boundary=\(boundaryString)",
            ]
        case let .patchUserProfileData(_, boundaryString):
            return [
                "Content-Type" : "multipart/form-data; boundary=\(boundaryString)",
                "Authorization": "Bearer \(accessToken)"
            ]
        case .logout, .accountDelete:
            return [
                "Authorization": "Bearer \(accessToken)",
                "Content-Type" : "application/json",
            ]
        default:
            return [
                "Content-Type" : "application/json",
            ]
        }
    }
    
    func body() throws -> Data? {
        switch self {
        case .login(let loginRequest):
            let jsonData = try JSONEncoder().encode(loginRequest)
            return jsonData
        case .postUserProfileData(let signupData, _):
            return signupData
        case .patchUserProfileData(let userData, _):
            if let userStringData = String(data: userData, encoding: .utf8) {
                Log.debugPrivate("patchUserProfileData", userStringData)
            } else {
                Log.debugPrivate("patchUserProfileData 실패")
            }
            
            return userData
        default: return nil
        }
    }
    
    
}
