//
//  File.swift
//  AITherapist
//
//  Created by Cyrus Refahi on 3/4/23.
//

import Foundation
import Alamofire


class NetworkManager {
    func GetRequest<D: Decodable>(decoderModel: D.Type, pathVariable: String? = nil, params:[String : Any] , successHandler:@escaping (_: DataResponse<D, AFError>) -> (),  failedHandler:@escaping (_: DataResponse<D, AFError>) -> (), url :String) {
        let url = (pathVariable != nil) ? URL(string: url)?.appending(path: pathVariable!) : URL(string: url)
        AF.request(url! , parameters: params)
            .responseDecodable (of: D.self) { response in
                switch response.result{
                case .success:
                    successHandler(response)
                    break
                case .failure:
                    failedHandler(response)
                    break
                }
            }
    }
    
    func SendRequest<D: Decodable>(decoderModel: D.Type, pathVariable: String? = nil, params:[String : Any] , successHandler:@escaping (_: DataResponse<D, AFError>) -> (),  failedHandler:@escaping (_: DataResponse<D, AFError>) -> (), url :String) {
        let url = (pathVariable != nil) ? URL(string: url)?.appending(path: pathVariable!) : URL(string: url)
        AF.request(url! , method: .post, parameters: params, encoding: JSONEncoding.default)
            .responseDecodable (of: D.self) { response in
                switch response.result{
                case .success:
                    successHandler(response)
                    break
                case .failure:
                    failedHandler(response)
                    break
                }
            }
    }
}
