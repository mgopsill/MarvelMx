//
//  CharacterService.swift
//  MarvelRx
//
//  Created by Mike Gopsill on 22/10/2019.
//  Copyright © 2019 mgopsill. All rights reserved.
//

import RxSwift

enum API {
    static let charactersUrl = "https://gateway.marvel.com/v1/public/characters?ts=1&apikey=ff3d4847092294acc724123682af904b&hash=412b0d63f1d175474216fadfcc4e4fed&limit=25&orderBy=-modified"
}

protocol CharacterServiceProtocol {
    func fetchCharacters() -> Observable<CharacterResponseModel?>
}

final class CharacterService: CharacterServiceProtocol {
    
    private let session: URLSessionProtocol
    
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    func fetchCharacters() -> Observable<CharacterResponseModel?> {
        guard let url = URL(string: API.charactersUrl) else { return Observable.just(nil) }
        return session.data(from: url).map { data -> CharacterResponseModel? in
            let jsonDecoder = JSONDecoder()
            jsonDecoder.dateDecodingStrategy = .iso8601
            return try? jsonDecoder.decode(CharacterResponseModel.self, from: data)
        }
    }
}
