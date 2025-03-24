import Foundation

class ArticleWorker {
    private let decoder: JSONDecoder = JSONDecoder()

    // Dynamically generate the URL based on rubric and pageIndex
    private func getURL(rubric: Int, pageIndex: Int) -> URL? {
        let urlString = "https://news.myseldon.com/api/Section?rubricId=\(rubric)&pageSize=10&pageIndex=\(pageIndex)"
        return URL(string: urlString)
    }

    // Fetch articles based on rubric and page index
    private func fetchArticles(rubric: Int, pageIndex: Int, completion: @escaping ([ArticleModel]) -> Void) {
        guard let url = getURL(rubric: rubric, pageIndex: pageIndex) else {
            print("Invalid URL")
            completion([])  // Return empty array if URL is invalid
            return
        }

        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            if let error = error {
                print("Error fetching articles:", error)
                completion([])  // Return empty array on error
                return
            }

            guard let data = data else {
                print("No data received.")
                completion([])  // Return empty array if no data
                return
            }

            do {
                let newsPage = try self?.decoder.decode(NewsPage.self, from: data)
                if var newsPage = newsPage {
                    newsPage.passTheRequestId()  // Optional step to handle requestId
                    completion(newsPage.news ?? [])  // Return articles or empty array
                } else {
                    print("Failed to decode the data into NewsPage.")
                    completion([])  // Return empty array
                }
            } catch {
                print("Error decoding JSON:", error)
                completion([])  // Return empty array on decoding failure
            }
        }.resume()
    }

    // Public method to fetch news (pageIndex = 1)
    public func fetchNews(completion: @escaping ([ArticleModel]) -> Void) {
        fetchArticles(rubric: 4, pageIndex: 1, completion: completion)
    }

    // Public method to fetch more news (pageIndex = 2)
    public func fetchMoreNews(completion: @escaping ([ArticleModel]) -> Void) {
        fetchArticles(rubric: 4, pageIndex: 2, completion: completion)
    }
}
