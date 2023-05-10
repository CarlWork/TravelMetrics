//  NetworkManager.swift
//  TravelMetrics
//
//  Created by Carl Work on 5/1/23.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    private let apiKey = "U8L8sRLZ05vM3zybjq1Oz1A0ermMa107"
    private let baseURL = "https://api.apilayer.com/exchangerates_data"

    private init() {}
    
    // Fetch converted amount function
    func fetchConvertedAmount(amount: String, from: String, to: String, completion: @escaping (Result<Double, Error>) -> Void) {
        let url = "\(baseURL)/convert?to=\(to)&from=\(from)&amount=\(amount)"
        
        var request = URLRequest(url: URL(string: url)!,timeoutInterval: Double.infinity)
        request.httpMethod = "GET"
        request.addValue(apiKey, forHTTPHeaderField: "apikey")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: -1, userInfo: nil)))
                return
            }

            do {
                let jsonResponse = try JSONSerialization.jsonObject(with: data, options: [])
                guard let jsonDict = jsonResponse as? [String: Any], let result = jsonDict["result"] as? Double else {
                    completion(.failure(NSError(domain: "Invalid response", code: -1, userInfo: nil)))
                    return
                }

                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
        }

        task.resume()
    }
    
    func fetchAvailableSymbols(completion: @escaping (Result<[Currency], Error>) -> Void) {
        let url = "\(baseURL)/symbols"
        
        var request = URLRequest(url: URL(string: url)!,timeoutInterval: Double.infinity)
        request.httpMethod = "GET"
        request.addValue(apiKey, forHTTPHeaderField: "apikey")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: -1, userInfo: nil)))
                return
            }

            do {
                let jsonResponse = try JSONSerialization.jsonObject(with: data, options: [])
                guard let jsonDict = jsonResponse as? [String: Any], let symbolsDict = jsonDict["symbols"] as? [String: String] else {
                    completion(.failure(NSError(domain: "Invalid response", code: -1, userInfo: nil)))
                    return
                }

                var currencies: [Currency] = []
                for (code, name) in symbolsDict {
                    let currency = Currency(code: code, name: name)
                    currencies.append(currency)
                }

                completion(.success(currencies))
            } catch {
                completion(.failure(error))
            }
        }

        task.resume()
    }
}

