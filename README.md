# skyislimit
Machine Test


# 🚀 GitHub Explorer App

GitHub Explorer is a beautiful and functional Flutter application that allows users to search for GitHub profiles and view their public profile information and repositories.

## 📱 Features

### 🔍 User Search
- Users can enter a GitHub username on the search screen.
- Validation is added to ensure input is not empty.
- On submission, the app fetches the user details and repositories using GitHub APIs.

### 📄 Profile & Repository Tabs
- Once the user is fetched, the app navigates to a new page using **AutoRoute**.
- The user sees two tabs:
    - **Profile**: Displays user avatar, name, followers, bio, and more.
    - **Repositories**: Lists repositories with filtering, sorting, and animations.

---

## 🧱 Architecture & Structure

The app follows a clean structure with modular separation of concerns:


---

## 🛠 Widgets & Utilities

### 🎨 Custom Widgets
- `CustomAppBar` – A beautiful, consistent app bar across screens.
- `LoginButton` – A reusable button with custom loading states and actions.
- `ShimmerLoader` – Shimmer effects for skeleton loading screens while data loads.

### 🧑‍🎨 Theme Management
- Centralized `themeData()` is defined in `/theme/themes.dart`.
- All UI components use `TextTheme` for consistent styling.
- Colors, gradients, and font styles are centralized for scalability.

---

## ⚙️ State Management

- **Riverpod** is used for handling state across the application:
    - `searchUserProvider` – Handles fetching GitHub user data.
    - `homePageProvider` – Fetches repositories for the searched user.
- Riverpod allows separation of UI and logic, easy testing, and reusability.

---

## 💾 Local Storage with Hive

- Hive is integrated for lightweight local storage.
- On successful search, user data is cached using `HiveRepo` in `rest/hive_repo.dart`.
- Stored user data is used for initializing the home screen even when offline.

---

## 🌐 Error Handling & Feedback

- Displays loading indicators and shimmer skeletons while fetching data.
- Validations are applied on all input fields.
- Handles edge cases:
    - No internet connection.
    - Invalid usernames.
    - No repositories found.
    - API errors with proper `SnackBar` feedback.

---

## 🧭 Navigation

- Uses **AutoRoute** for declarative and typed navigation.
- After a successful username search, navigates to the `HomeScreen` using:
  ```dart
  context.pushRoute(HomeRoute());

 
##  Repository Tab Functionalities
##  🧩 Filtering & Sorting
  -TextField with a search bar allows live filtering by repository name.
  -A filter icon in the TextField opens a popup menu to sort by:
   Size
   Watchers
- Sorted repositories are displayed in descending order.

## 🌈 Animations
- Uses flutter_staggered_animations for beautiful list reveal effects.
-Repositories slide in with fade + vertical animation.

## 🌐 External Links
- On tapping a repository card, it opens the GitHub repository in a Custom Chrome Tab using flutter_custom_tabs.