//
//  APIClient.swift
//  Operators Techno Lab, Ahmedabad
//
//  Developed by Harsh Kadiya
//  Created by OTL-HK on 26/02/2019.
//  Copyright © 2023 OTL-HK. All rights reserved.
//

import Foundation
import OTLContaner
import Alamofire

public typealias OTLJson = [String : Any]
public typealias OTLStringJson = [String : String]
public typealias OTLAPIResultBlock = (OTLAPIClientResult) -> Void
public typealias OTLAPIProgressBlock = (Double) -> Void
public typealias OTLJsonArray = [[String : Any]]

private let ResponseParseErrorMessage = "Sorry, Unable to connect the server"

class OTLAPIClient: NSObject {
      
      static let shared = OTLAPIClient()
      private var requestObjc: OTLAPIRequest!
      var session: Session {
            return AF
      }
      
      func performTask(with request: OTLAPIRequest) {
            self.requestObjc = request
            guard isInternetAvailable() else {
                  request.resultCompletion?(.fail("Internet not avaible", 11,nil))
                  return
            }
            
          let headers =  OTLAPIClient.httpsHeaders(request.header)
            
            let arrayContains = request.parameter?.contains(where: { (keyVal) -> Bool in
                  if let _ = keyVal.value as? NSArray { return true }
                  else { return false }
            })
            
            let isJsonPara : Bool = { () -> (Bool) in
                  for paraObject in request.parameter ?? [:] {
                        if ((paraObject.value as? [String:Any]) != nil) { return true }
                  }
                  return false
            }()
            
            let reqURL = request.path.replacingOccurrences(of: " ", with: "%20")
            
            printLog(separator: "============================", log: .api_request)
            printLog(reqURL, log: .api_request)
            printLog(request.parameter as Any, log: .api_request)
            printLog("Token : \(headers)", log: .api_request)
            printLog(separator: "============================", log: .api_request)
            
            if isInternetAvailable() {
                  if arrayContains ?? false {
                        var req = URLRequest(url: URL(string: reqURL)!)
                      req.httpMethod = request.method.rawValue
                        
                        req.httpBody = try? JSONSerialization.data(withJSONObject: request.parameter ?? [:])
                      var myheaders: [String:String] = ["Content-Type": "application/json"]
                      headers.forEach { obj in
                          myheaders[obj.name] = obj.value
                      }
                              req.allHTTPHeaderFields = myheaders
                        
                        //Now use this URLRequest with Alamofire to make request
                        session.request(req).responseJSON { response in
                              self.manageResponse(response: response)
                        }
                        
                  } else {
                      let methods = HTTPMethod(rawValue: request.method.rawValue)
                        if isJsonPara {
                            session.request(reqURL, method: methods,
                                              parameters: request.parameter,
                                              encoding: JSONEncoding.default,
                                              headers: headers).responseJSON { (response) in
                                                self.manageResponse(response: response)
                                              }
                        }
                        else {
                            session.request(reqURL, method: methods,
                                              parameters: request.parameter,
                                              encoding: URLEncoding.default,
                                              headers: headers).responseJSON { (response) in
                                                self.manageResponse(response: response)
                                              }
                        }
                  }
            }
      }
      
      func performMultipartTask(with request: OTLAPIRequest) {
            self.requestObjc = request
            guard isInternetAvailable() else {
                request.resultCompletion?(.fail("Internet not avaible", 11,nil))
                  return
            }
            let headers = OTLAPIClient.httpsHeaders(request.header)
            printLog(separator: "============================", log: .api_request)
            printLog(request.path, log: .api_request)
            printLog(request.parameter as Any, log: .api_request)
            printLog("Token : \(headers)", log: .api_request)
            printLog(separator: "============================", log: .api_request)
            session.upload(multipartFormData: { multiPart in
                  
                  for item in request.multipartItems! {
                        if let data = item.data {
                              multiPart.append(data, withName: item.name, fileName: item.filename, mimeType: item.mimeType.rawValue)
                        }
                  }
                  if let params = request.parameter {
                        for (key, value) in params {
                              multiPart.append(("\(value)").data(using: .utf8)!, withName: key)
                        }
                  }
            }, to: request.path, method: .post, headers: headers).uploadProgress(queue: .main, closure: { progress in
                  self.requestObjc.progressBlock?(progress.fractionCompleted)
                  printLog("Upload Progress : \(progress.fractionCompleted)", log: .api_uplodingPrograss)
            }).responseJSON(completionHandler: { response in
                  self.manageResponse(response: response)
            })
      }
      
      fileprivate func manageResponse(response: AFDataResponse<Any>) {
          let statusCode = response.response?.statusCode ?? 111
            switch response.result {
                  case .failure(let error):
                        printLog("RequestError:: \(error.localizedDescription)", log: .api_failure)
                        if error.localizedDescription.contains("JSON could not be serialized") {
                            requestObjc.resultCompletion?(.fail(ResponseParseErrorMessage, statusCode, nil))
                        } else {
                              requestObjc.resultCompletion?(.fail(error.localizedDescription, statusCode,nil))
                        }
                        
                  case .success(let value):
                        if let json = value as? [String: Any] {

                            printLog("RequestResponse: \(json)", log: .api_response)
                            if response.response?.statusCode == 401 {
                                showAlert(title: "Session Expired", message: "You must login again to continue", buttons: [OTLAlertModel(title: "Okay", id: 0)])
                                authUser?.logout()
                                DispatchQueue.main.async {
                                    mackRootView(LoginVC())
                                }
                            } else {
                                let objResponse = APIResponse(json, code: statusCode)
                                requestObjc.resultCompletion?(.success(objResponse))
                            }
                        } else {
                              requestObjc.resultCompletion?(.fail(ResponseParseErrorMessage, statusCode, nil))
                        }
            }
      }
      
      func performDownloadTask(with request: OTLAPIRequest) {
            
      }
      
      func performUploadTask(with endpoint: OTLAPIRequest) {
            
      }
      
      // class methods
      class func httpsHeaders(_ header: OTLStringJson? = nil) -> HTTPHeaders {
          var defaultHeaders = HTTPHeaders()
          if let header = header, header.count > 0 {
              header.forEach { headerObj in
                  defaultHeaders[headerObj.key] = headerObj.value
              }
          } else {
              OTLWebserviceConfiguration.instance.header.forEach { headerObj in
                  defaultHeaders[headerObj.key] = headerObj.value
              }
          }
            
            return defaultHeaders
      }
      
}


// MARK: - Helper Classes
public struct APIResponse {
    public var code: Int = 0
    public var body: OTLJson?
    public var message: String = ""
    
    init(_ json: Any, code: Int) {
        // handle response code and message
        // it may be different as per API development.
        self.code = code
        let config = OTLWebserviceConfiguration.instance
        if let json = json as? OTLJson {
            let msg = json[config.messageKey] as? String ?? ""
            body = json
            message = msg
        } else if let array = json as? OTLJsonArray {
            body = ["data": array]
            message = "Array Json"
        }
    }
}

// Result : will be returned to API caller
public enum OTLAPIClientResult {
      case fail(String,Int?,Any?)
      case success(APIResponse)
}

// not using in current version
public enum OTLAPIClientUploadDownloadResult {
      case fail(Error)
      case success(Any)
      case progress(Float)
}

public protocol OTLEndPointProtocol {
      var path: String { get set }
      var method: OTLHTTPMethod  { get set }
      var parameter: OTLJson?  { get set }
    var header: OTLStringJson? {get set}
      var resultCompletion: OTLAPIResultBlock?  { get set }
}

struct  OTLAPIRequest: OTLEndPointProtocol {
   var path: String
      var method: OTLHTTPMethod
      var parameter: OTLJson?
      var resultCompletion: OTLAPIResultBlock?
      var progressBlock: OTLAPIProgressBlock?
      var header: OTLStringJson?
      
      var multipartItems: [OTLMultipartFormData]?
      
      init(path: String,
           method: OTLHTTPMethod = .get,
           parameter: OTLJson? = nil,
           header: OTLStringJson? = nil,
           progress:OTLAPIProgressBlock? = nil,
           completion: @escaping OTLAPIResultBlock) {
            self.path = path
            self.method = method
            self.parameter = parameter
            self.header = header
            self.resultCompletion = completion
            self.progressBlock = progress
      }
      
      func execute() {
          OTLAPIClient().performTask(with: self)
      }
      
      func executeMultiPart() {
          OTLAPIClient().performMultipartTask(with: self)
      }
}


public class OTLMultipartFormData {
      var name = ""
      var data: Data?
      var mimeType = MIMEType.image_jpeg
      var filename = ""
      
      enum MIMEType: String {
            case text_plain = "text/plain"
            case text_html = "text/html"
            case text_javascript = "text/javascript"
            case text_css = "text/css"
            case image_jpeg = "image/jpeg"
            case image_png = "image/png"
            case audio_mepg = "audio/mpeg"
            case audio_ogg = "audio/ogg"
            case video_mp4 = "video/mp4"
            case image = "image"
      }
      
      init(name: String, filename: String, data: Data, mimeType: MIMEType = .image_jpeg) {
            self.name = name
            self.filename = filename
            self.data = data
            self.mimeType = mimeType
      }
}

public struct OTLHTTPMethod: RawRepresentable, Equatable, Hashable {
    /// `CONNECT` method.
    public static let connect = OTLHTTPMethod(rawValue: "CONNECT")
    /// `DELETE` method.
    public static let delete = OTLHTTPMethod(rawValue: "DELETE")
    /// `GET` method.
    public static let get = OTLHTTPMethod(rawValue: "GET")
    /// `HEAD` method.
    public static let head = OTLHTTPMethod(rawValue: "HEAD")
    /// `OPTIONS` method.
    public static let options = OTLHTTPMethod(rawValue: "OPTIONS")
    /// `PATCH` method.
    public static let patch = OTLHTTPMethod(rawValue: "PATCH")
    /// `POST` method.
    public static let post = OTLHTTPMethod(rawValue: "POST")
    /// `PUT` method.
    public static let put = OTLHTTPMethod(rawValue: "PUT")
    /// `QUERY` method.
    public static let query = OTLHTTPMethod(rawValue: "QUERY")
    /// `TRACE` method.
    public static let trace = OTLHTTPMethod(rawValue: "TRACE")

    public let rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }
}
