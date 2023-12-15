//
//  ServiceHelper.swift
//  Pokemon
//
//  Created by Angga Setiawan on 16/12/23.
//

import Foundation
import Moya

public enum NetworkRequestResponseIdentifier: String {
    case request = "Request"
    case header = "Request Headers"
    case requestBody = "Request Body"
    case method = "HTTP Request Method"
    case response = "Response"
    case responseBody = "Response Body"

    case unknown
}

// swiftlint:disable line_length
public struct ServiceHelper {

    public static func session(timeout: DispatchTimeInterval = .seconds(30)) -> Session {
        let configuration = URLSessionConfiguration.default
        configuration.headers = .default
        configuration.timeoutIntervalForRequest = timeout.toDouble() // as seconds, you can set your request timeout
        configuration.timeoutIntervalForResource = timeout.toDouble() // as seconds, you can set your resource timeout
        configuration.requestCachePolicy = .useProtocolCachePolicy
        return Session(configuration: configuration, startRequestsImmediately: false)
    }

    public static var defaultPlugins: [PluginType] {
        var plugins: [PluginType] = [
            NetworkActivityPlugin(networkActivityClosure: { (type, _) in
                DispatchQueue.main.async { UIApplication.shared.isNetworkActivityIndicatorVisible = type == .began }
            })
        ]

        let config = NetworkLoggerPlugin.Configuration
            .init(formatter:
                    .init(entry: defaultEntryFormatter,
                          requestData: JSONResponseDataFormatter,
                          responseData: JSONResponseDataFormatter),
                  logOptions: .verbose)
        plugins.append(NetworkLoggerPlugin(configuration: config))
        return plugins
    }

    fileprivate static func endpointClosure<T: PokemonApi>(for type: T.Type) -> ((T) -> Endpoint) {
        let endpointClosure = { (target: T) -> Endpoint in
            let defaultEndpoint = MoyaProvider.defaultEndpointMapping(for: target)
            return Endpoint(url: defaultEndpoint.url,
                            sampleResponseClosure: defaultEndpoint.sampleResponseClosure,
                            method: defaultEndpoint.method,
                            task: defaultEndpoint.task,
                            httpHeaderFields: defaultEndpoint.httpHeaderFields)
        }
        return endpointClosure
    }

    static var emptyMultipartData: Moya.MultipartFormData {
        return MultipartFormData(provider: .data(Data()), name: "empty")
    }

    public static func provider<T: PokemonApi>(
        for type: T.Type,
        timeout: DispatchTimeInterval = .seconds(30)) -> MoyaProvider<T> {
            return MoyaProvider<T>(endpointClosure: ServiceHelper.endpointClosure(for: T.self),
                                   session: ServiceHelper.session(timeout: timeout),
                                   plugins: ServiceHelper.defaultPlugins)
    }
}

extension ServiceHelper {
    fileprivate static func defaultEntryFormatter(identifier: String, message: String, target: TargetType) -> String {
        let date = defaultEntryDateFormatter.string(from: Date())
        var modifiedMessage: String = message

        let reqRespIdentifier: NetworkRequestResponseIdentifier = NetworkRequestResponseIdentifier(rawValue: identifier) ?? .unknown
        switch reqRespIdentifier {
        case .header: modifiedMessage = self.headerBeautify(headers: target.headers)
        default: break
        }

        return "\(self.divider(identifier: identifier))Moya Logger: \(date)\nEndpoint: \(self.urlBeautify(base: target.baseURL.absoluteString, path: target.path))\n\(identifier): \(modifiedMessage)\(self.divider(identifier: identifier))"
    }

    fileprivate static var defaultEntryDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .long
        formatter.dateStyle = .long
        return formatter
    }()

    fileprivate static func JSONResponseDataFormatter(_ data: Data) -> String {
        do {
            let dataAsJSON = try JSONSerialization.jsonObject(with: data)
            let prettyData = try JSONSerialization.data(withJSONObject: dataAsJSON, options: .prettyPrinted)
            return String(data: prettyData, encoding: .utf8) ?? String(data: data, encoding: .utf8) ?? ""
        } catch {
            return String(data: data, encoding: .utf8) ?? ""
        }
    }

    fileprivate static func headerBeautify(headers: [String: String]?) -> String {
        if let headers {
            var string: String = "[\n"
            for (key, value) in headers {
                let temp = "     \"\(key)\": \"\(value)\"\n"
                string.append(temp)
            }
            return "\(string.trailingSpacesTrimmed)\n]"
        }
        return ""
    }

    fileprivate static func urlBeautify(base: String, path: String) -> String {
        if let lastBaseChar = base.last {
            if lastBaseChar != "/" {
                return base + "/" + path
            }
        }
        return base + path
    }

    fileprivate static func divider(identifier: String) -> String {
        return "\n======================================== \(identifier) ========================================\n"
    }
}

