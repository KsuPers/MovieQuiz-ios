import Foundation

protocol MoviesLoading {
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void)
}

struct MoviesLoader: MoviesLoading {
    // MARK: - NetworkClient
    private let networkClient = NetworkClient()
    
    // MARK: - URL
    private var mostPopularMoviesUrl: URL {
            // Если мы не смогли преобразовать строку в URL, то приложение упадёт с ошибкой
        guard let url = URL(string: "https://imdb-api.com/en/API/Top250Movies/k_c79azxy6") else {
            preconditionFailure("Unable to construct mostPopularMoviesUrl")
        }
        return url
    }
    
    enum DecodingError: Error {
        case decodingError
    }
    
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void) {
        networkClient.fetch(url: mostPopularMoviesUrl) { result in
            switch result {
            case .failure(let error): handler (.failure(error))
            case .success(let data):
                let moviesList = try? JSONDecoder().decode(MostPopularMovies.self, from: data)
                if let moviesList = moviesList {
                    handler(.success(moviesList)) } else {
                        handler(.failure(DecodingError.decodingError))
                }
            }
        }
    }
                        
    /*
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void) {
            networkClient.fetch(url: mostPopularMoviesUrl) { result in
                switch result {
                case .failure(let error): handler(.failure(error))
                case .success(let data):
                    let topMovieList = try? JSONDecoder().decode(MostPopularMovies.self, from: data)
                    if let topMovieList = topMovieList {
                        handler(.success(topMovieList)) } else {
                            handler(.failure(error))
                        }
                }
            }
        }
   */
        
        /*Используйте переменные networkClient и mostPopularMoviesUrl.
         В замыкании обработайте ошибочное состояние и передайте его дальше в handler.
         Преобразуйте данные в MostPopularMovies, используя JSONDecoder.
         Верните их, используя handler.*/
}
