import SwiftUI
import IndieBuilderKit

struct NetworkDemo: View {
    @Environment(\.dismiss) private var dismiss
    @State private var posts: [JSONPlaceholderPost] = []
    @State private var users: [JSONPlaceholderUser] = []
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var selectedTab = 0
    @State private var newPostTitle = ""
    @State private var newPostBody = ""
    @State private var showCreatePost = false
    
    private let networkService = NetworkService.shared
    
    var body: some View {
        NavigationView {
            VStack {
                Picker("Content", selection: $selectedTab) {
                    Text("Posts").tag(0)
                    Text("Users").tag(1)
                    Text("Create").tag(2)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                TabView(selection: $selectedTab) {
                    // Posts Tab
                    postsView
                        .tag(0)
                    
                    // Users Tab
                    usersView
                        .tag(1)
                    
                    // Create Post Tab
                    createPostView
                        .tag(2)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            }
            .navigationTitle("Network Demo")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Refresh") {
                        Task {
                            await loadData()
                        }
                    }
                    .disabled(isLoading)
                }
            }
            .task {
                await loadData()
            }
        }
    }
    
    // MARK: - Posts View
    
    private var postsView: some View {
        Group {
            if isLoading && posts.isEmpty {
                LoadingView(message: "Loading posts...")
            } else if posts.isEmpty {
                EmptyStateView(
                    title: "No Posts",
                    subtitle: "Tap refresh to load posts from JSONPlaceholder API",
                    systemImage: "doc.text",
                    actionTitle: "Refresh",
                    tintColor: .blue
                ) {
                    Task { await loadData() }
                }
            } else {
                List(posts) { post in
                    PostRowView(post: post)
                }
                .refreshable {
                    await loadData()
                }
            }
        }
        .overlay(alignment: .bottom) {
            if let errorMessage = errorMessage {
                ErrorBannerView(message: errorMessage) {
                    self.errorMessage = nil
                }
            }
        }
    }
    
    // MARK: - Users View
    
    private var usersView: some View {
        Group {
            if isLoading && users.isEmpty {
                LoadingView(message: "Loading users...")
            } else if users.isEmpty {
                EmptyStateView(
                    title: "No Users",
                    subtitle: "Tap refresh to load users from JSONPlaceholder API",
                    systemImage: "person.3",
                    actionTitle: "Refresh",
                    tintColor: .green
                ) {
                    Task { await loadData() }
                }
            } else {
                List(users) { user in
                    UserRowView(user: user)
                }
                .refreshable {
                    await loadData()
                }
            }
        }
        .overlay(alignment: .bottom) {
            if let errorMessage = errorMessage {
                ErrorBannerView(message: errorMessage) {
                    self.errorMessage = nil
                }
            }
        }
    }
    
    // MARK: - Create Post View
    
    private var createPostView: some View {
        VStack(spacing: 24) {
            VStack(alignment: .leading, spacing: 16) {
                Text("Create New Post")
                    .font(.bold(24))
                    .padding(.top)
                
                Text("This will send a POST request to JSONPlaceholder API. The API simulates creating a post but doesn't actually store it.")
                    .font(.regular(14))
                    .foregroundColor(.secondary)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Title")
                        .font(.medium(16))
                    
                    TextField("Enter post title", text: $newPostTitle)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Body")
                        .font(.medium(16))
                    
                    TextField("Enter post content", text: $newPostBody, axis: .vertical)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .lineLimit(4...8)
                }
                
                Button(action: {
                    Task {
                        await createPost()
                    }
                }) {
                    HStack {
                        if isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .scaleEffect(0.8)
                        } else {
                            Image(systemName: "plus.circle.fill")
                            Text("Create Post")
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(
                        !newPostTitle.isEmpty && !newPostBody.isEmpty ?
                        Color.blue : Color.gray
                    )
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }
                .disabled(newPostTitle.isEmpty || newPostBody.isEmpty || isLoading)
            }
            .padding()
            
            Spacer()
        }
        .overlay(alignment: .bottom) {
            if let errorMessage = errorMessage {
                ErrorBannerView(message: errorMessage) {
                    self.errorMessage = nil
                }
            }
        }
    }
    
    // MARK: - Network Methods
    
    @MainActor
    private func loadData() async {
        isLoading = true
        errorMessage = nil
        
        do {
            // Load posts and users in parallel
            try await loadPosts()
            try await loadUsers()
            
        } catch {
            handleError(error)
        }
        
        isLoading = false
    }
    
    private func loadPosts() async throws {
        let url = URL(string: "https://jsonplaceholder.typicode.com/posts")!
        let fetchedPosts = try await networkService.get(
            url: url,
            responseType: [JSONPlaceholderPost].self
        )
        
        await MainActor.run {
            posts = fetchedPosts
        }
    }
    
    private func loadUsers() async throws {
        let url = URL(string: "https://jsonplaceholder.typicode.com/users")!
        let fetchedUsers = try await networkService.get(
            url: url,
            responseType: [JSONPlaceholderUser].self
        )
        
        await MainActor.run {
            users = fetchedUsers
        }
    }
    
    @MainActor
    private func createPost() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let url = URL(string: "https://jsonplaceholder.typicode.com/posts")!
            let newPost = CreateJSONPlaceholderPost(
                title: newPostTitle,
                body: newPostBody,
                userId: 1
            )
            
            let createdPost = try await networkService.post(
                url: url,
                body: newPost,
                responseType: JSONPlaceholderPost.self
            )
            
            // Add the created post to the beginning of the list
            posts.insert(createdPost, at: 0)
            
            // Clear the form
            newPostTitle = ""
            newPostBody = ""
            
            // Switch to posts tab to show the result
            selectedTab = 0
            
        } catch {
            handleError(error)
        }
        
        isLoading = false
    }
    
    private func handleError(_ error: Error) {
        if let networkError = error as? NetworkError {
            switch networkError {
            case .unauthorized:
                errorMessage = "Authentication failed"
            case .notFound:
                errorMessage = "Resource not found"
            case .noInternetConnection:
                errorMessage = "No internet connection"
            case .decodingFailed:
                errorMessage = "Failed to parse response"
            case .serverError(let code):
                errorMessage = "Server error (\(code))"
            default:
                errorMessage = networkError.localizedDescription
            }
        } else {
            errorMessage = error.localizedDescription
        }
    }
}

// MARK: - JSONPlaceholder Models

struct JSONPlaceholderPost: Codable, Identifiable, Sendable {
    let id: Int
    let userId: Int
    let title: String
    let body: String
}

struct CreateJSONPlaceholderPost: Codable, Sendable {
    let title: String
    let body: String
    let userId: Int
}

struct JSONPlaceholderUser: Codable, Identifiable, Sendable {
    let id: Int
    let name: String
    let username: String
    let email: String
    let phone: String
    let website: String
    let company: Company
    let address: Address
    
    struct Company: Codable, Sendable {
        let name: String
        let catchPhrase: String
        let bs: String
    }
    
    struct Address: Codable, Sendable {
        let street: String
        let suite: String
        let city: String
        let zipcode: String
        let geo: Geo
        
        struct Geo: Codable, Sendable {
            let lat: String
            let lng: String
        }
    }
}

// MARK: - Row Views

private struct PostRowView: View {
    let post: JSONPlaceholderPost
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Post #\(post.id)")
                    .font(.regular(12))
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Text("User \(post.userId)")
                    .font(.regular(12))
                    .foregroundColor(.secondary)
            }
            
            Text(post.title)
                .font(.medium(16))
                .foregroundColor(.primary)
            
            Text(post.body)
                .font(.regular(14))
                .foregroundColor(.secondary)
                .lineLimit(3)
        }
        .padding(.vertical, 4)
    }
}

private struct UserRowView: View {
    let user: JSONPlaceholderUser
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(user.name)
                        .font(.medium(16))
                        .foregroundColor(.primary)
                    
                    Text("@\(user.username)")
                        .font(.regular(14))
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 2) {
                    Text(user.email)
                        .font(.regular(12))
                        .foregroundColor(.blue)
                    
                    Text(user.phone)
                        .font(.regular(12))
                        .foregroundColor(.secondary)
                }
            }
            
            HStack {
                Label(user.company.name, systemImage: "building.2")
                    .font(.regular(12))
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Label("\(user.address.city), \(user.address.zipcode)", systemImage: "location")
                    .font(.regular(12))
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Error Banner

private struct ErrorBannerView: View {
    let message: String
    let onDismiss: () -> Void
    
    var body: some View {
        HStack {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundColor(.white)
            
            Text(message)
                .font(.medium(14))
                .foregroundColor(.white)
                .multilineTextAlignment(.leading)
            
            Spacer()
            
            Button("Dismiss") {
                onDismiss()
            }
            .font(.medium(14))
            .foregroundColor(.white)
        }
        .padding(16)
        .background(Color.red)
        .cornerRadius(12)
        .padding()
        .shadow(radius: 4)
    }
}

#Preview {
    NetworkDemo()
}
