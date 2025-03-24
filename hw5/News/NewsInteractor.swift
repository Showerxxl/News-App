import Foundation

protocol NewsBusinessLogic {
    func loadFreshNews()
    func loadMoreNews()
}

protocol NewsDataStore {
    var articles: [ArticleModel] { get set }
}

class NewsInteractor: NewsBusinessLogic, NewsDataStore {
    var presenter: NewsPresentationLogic?
    var articles: [ArticleModel] = [] {
        didSet {
            presenter?.presentNews(articles: articles)
        }
    }
    
    private let articleWorker = ArticleWorker()
    
    private var isLoading = false

    func loadFreshNews() {
        guard !isLoading else { return }
        isLoading = true
        
        articleWorker.fetchNews { [weak self] fetchedArticles in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.articles = fetchedArticles
                self.isLoading = false
            }
        }
    }

    func loadMoreNews() {
        guard !isLoading else { return }
        isLoading = true
        
        articleWorker.fetchMoreNews { [weak self] additionalArticles in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.articles.append(contentsOf: additionalArticles)
                self.isLoading = false
            }
        }
    }
}
