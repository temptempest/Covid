//
//  FlagImageService.swift
//  Covid
//
//  Created by temptempest on 17.12.2022.
//

import Foundation
import SDWebImage

typealias FlagImageResult = Result<Data, Error>
protocol IFlagImageService {
    func getFlagImageData(by countryCode: String, completion: @escaping (FlagImageResult) -> Void)
}
struct FlagImageService: IFlagImageService {
    private let manager = SDWebImageManager.shared
    private let cache = SDImageCache.shared
    func getFlagImageData(by countryCode: String, completion: @escaping (FlagImageResult) -> Void) {
        manager.loadImage(
            with: URL(string: API.flagUrl + countryCode),
            options: [.highPriority, .progressiveLoad, .waitStoreCache, .retryFailed],
            progress: nil,
            completed: {(_, data, error, _, finished, _) in
                if let imageData = data, finished {
                    OperationQueue.mainAsyncIfNeeded {
                        completion(.success(imageData))
                    }
                } else {
                    guard let downloadError = error else { return }
                    OperationQueue.mainAsyncIfNeeded {
                        completion(.failure(downloadError))
                    }
                }
            }
        )
    }
}

// MARK: - FlagImageService Mock
struct FlagImageServiceMock: IFlagImageService {
    func getFlagImageData(by countryCode: String, completion: @escaping (FlagImageResult) -> Void) {
        let data = Data()
        completion(.success(data))
    }
}
