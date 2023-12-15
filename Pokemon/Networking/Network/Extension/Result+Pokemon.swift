//
//  Result+Pokemon.swift
//  Pokemon
//
//  Created by Angga Setiawan on 16/12/23.
//

import Foundation
import Moya

// swiftlint:disable line_length
public enum ResponseFormatter {

    case v1Object
    case v1Array

    func format<C: Decodable>(to: C.Type, from data: Data, statusCode: Int) -> Result<AppResponse<C>, NSError> {
        do {
            switch self {
            case .v1Object, .v1Array:
                return try formatV1(to: C.self, from: data, statusCode: statusCode)
            }
        } catch {
            pLogger.log("[JSON] Error: 1 \(error) | Type: \(to)")
            return .failure(NSError(
                domain: .errorLogicDomain,
                code: statusCode,
                userInfo: [NSLocalizedDescriptionKey: error.localizedDescription]
            ))
        }
    }

    private func formatV1<C: Decodable>(to: C.Type, from data: Data, statusCode: Int) throws -> Result<AppResponse<C>, NSError> {
        let response = try JSONDecoder().decode(AppResponse<C>.self, from: data)
        if statusCode / 100 == 2 {
            return .success(response)
        }

        let error = NSError(
            domain: .errorLogicDomain,
            code: statusCode,
            userInfo: [NSLocalizedDescriptionKey: ""]
        )
        return .failure(error)
    }

    private func formatV1Array<C: Decodable>(to: C.Type, from data: Data, statusCode: Int) throws -> Result<AppPagedResponse<C>, NSError> {
        let response = try JSONDecoder().decode(AppPagedResponse<C>.self, from: data)
        if statusCode / 100 == 2 {
            return .success(response)
        }

        let error = NSError(
            domain: .errorLogicDomain,
            code: statusCode,
            userInfo: [NSLocalizedDescriptionKey: ""]
        )
        return .failure(error)
    }
}

// swiftlint:disable function_body_length
public extension Result where Success: Moya.Response {
    func map<C: Decodable>(to: C.Type, formatter: ResponseFormatter = .v1Object) -> Result<AppResponse<C>, NSError> {
        switch self {
        case .success(let moyaResponse):
            if moyaResponse.statusCode / 100 == 5 {
                let error = NSError(
                    domain: .errorServiceDomain,
                    code: moyaResponse.statusCode,
                    userInfo: nil
                )
                return .failure(error)
            }

            return formatter.format(to: C.self, from: moyaResponse.data, statusCode: moyaResponse.statusCode)
        case .failure(let error):
            return .failure(NSError(
                domain: .errorSystemDomain,
                code: 0,
                userInfo: [NSLocalizedDescriptionKey: error.localizedDescription]
            ))
        }
    }
}
