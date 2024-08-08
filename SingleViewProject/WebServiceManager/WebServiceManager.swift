//
//  WebServiceManager.swift
//  SingleViewProject
//
//  Created by Ateeq Ahmed on 08/08/24.
//

import Foundation

class WebServiceManager {
    static let shared = WebServiceManager()
    private init(){}
    
    var formFields: [Field] = []
    var onFormFieldsUpdated: (() -> Void)?
    
    func fetchFormData() {
        guard let url = URL(string: "http://dev.fileshore.com/api/document/getFsFormDataDemo") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let requestBody: [String: Any] = [:]
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody, options: [])
        } catch {
            print("Failed to serialize request body: \(error)")
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self, let data = data, error == nil else { return }
            do {
                let apiResponse = try JSONDecoder().decode(APIResponse.self, from: data)
                self.formFields = apiResponse.data.list
                DispatchQueue.main.async {
                    self.onFormFieldsUpdated?()
                }
            } catch {
                print("Failed to parse JSON: \(error)")
            }
        }
        task.resume()
    }

}
