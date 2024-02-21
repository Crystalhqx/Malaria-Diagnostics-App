//
//  GPTAPI.swift
//  Malaria Diagnostics App
//
//  Created by crystal on 2/20/24.
//

import Foundation

class GPTAPI {
    let apiKey = "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"
    let session = URLSession.shared
    let apiUrlString = "https://api.openai.com/v1/chat/completions"

    // Send request to OpenAI API
    func sendRequest(withMessage message: String, images: [String], completion: @escaping (Result<String, Error>) -> Void) {
        guard let url = URL(string: apiUrlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        
        
        let imageContents = images.compactMap { imagePath -> [String: Any]? in
            return [
                "type": "image_url",
                "image_url": [
                    "url": "data:image/jpeg;base64,\(imagePath)",
                    "detail": "auto"
                ],
            ]
        }
        
        let payload: [String: Any] = [
            "model": "gpt-4-vision-preview",
            "messages": [
                [
                    "role": "user",
                    "content": [
                        ["type": "text", "text": message]
                    ] + imageContents
                ]
            ],
            "max_tokens": 200
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: payload, options: [])
        
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data, let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any], let choices = jsonResponse["choices"] as? [[String: Any]], let firstChoice = choices.first, let text = firstChoice["message"] as? [String: Any], let content = text["content"] as? String else {
                completion(.failure(NSError(domain: "Invalid response", code: -2, userInfo: nil)))
                return
            }
            
            completion(.success(content))
        }
        task.resume()
    }
    
    // Encode image to Base64
    private func encodeImageToBase64(imagePath: String) -> String? {
        guard let imageData = try? Data(contentsOf: URL(fileURLWithPath: imagePath)) else {
            return nil
        }
        return imageData.base64EncodedString()
    }
}
