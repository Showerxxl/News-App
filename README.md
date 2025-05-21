
# News App

This is an iOS application that allows users to browse the latest news in a user-friendly format.

## Key Features

- Fetches and displays a list of news articles.
- Full article reading via built-in WebView.
- Refresh the news feed with Pull-to-Refresh.
- Shimmer loading effect for improved user experience.
- Code structured using the Clean Swift (VIP: View-Interactor-Presenter) architecture pattern.
- Includes unit and UI tests.

## Architecture

The project follows the Clean Swift (VIP) pattern:
- **View:** Displays data and handles user interactions
- **Interactor:** Contains business logic (NewsInteractor)
- **Presenter:** Formats and prepares data for the View (NewsPresenter)
- **Worker:** (ArticleWorker) for auxiliary tasks like networking or storage
