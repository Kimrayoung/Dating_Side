//
//  OnboardingNetworkManager.swift
//  Dating_Side
//
//  Created by 김라영 on 2025/05/07.
//

import Foundation

///계정관련 Network(ex. 성별, 생년월일, 닉네임, 키, 지역, 등)
class OnboardingNetworkManager {
    private let networkManager: NetworkProtocol
    
    init(networkManager: NetworkProtocol = NetworkManager.shared) {
        self.networkManager = networkManager
    }
    
    func postUserData(requestModel: Data, boundaryString: String) async throws -> Result<VoidResponse, Error> {
        return await networkManager.callWithAsync(endpoint: OnboardingAPIManager.postUserProfileData(signupData: requestModel, boundaryString: boundaryString), httpCodes: .success)
    }
    
    func fetchAddressData(_ addrCode: String?) async throws -> Result<[Address], Error>  {
        return await networkManager.callWithAsync(endpoint: OnboardingAPIManager.getAddressData(addrCode: addrCode), httpCodes: .success)
    }
 
    func fetchJobType() async throws -> Result<[KoreanData], Error>  {
        return await networkManager.callWithAsync(endpoint: OnboardingAPIManager.getJopTypes, httpCodes: .success)
    }
    
    func fetchPreferenceType(_ preferenceType: String) async throws -> Result<[KoreanData], Error>  {
        return await networkManager.callWithAsync(endpoint: OnboardingAPIManager.getPreferenceTypes(preferenceType: preferenceType), httpCodes: .success)
    }
    
    func fetchLifeStyleDatas() async throws -> Result<LifeStyleResponse, Error>  {
        return await networkManager.callWithAsync(endpoint: OnboardingAPIManager.getLifeStyleDatas, httpCodes: .success)
    }
}

enum OnboardingAPIManager {
    case postUserProfileData(signupData: Data, boundaryString: String)
    case getAddressData(addrCode: String?)
    case getJopTypes
    case getLifeStyleDatas
    case getPreferenceTypes(preferenceType: String)
}

extension OnboardingAPIManager: APIManager {
    var path: String {
        switch self {
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
        case .postUserProfileData: return .post
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .postUserProfileData(_, let boundaryString):
            return [
                "Content-Type" : "multipart/form-data; boundary=\(boundaryString)",
            ]
        default:
            return [
                "Content-Type" : "application/json",
            ]
        }
    }
    
    func body() throws -> Data? {
        switch self {
        case .getAddressData, .getJopTypes, .getLifeStyleDatas, .getPreferenceTypes:
            return nil
        case .postUserProfileData(let signupData, _):
            return signupData
        }
    }
    
    
}
