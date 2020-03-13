import FirebaseFirestore
import FirebaseAuth

class FirestoreService {
    
    // MARK:- Static Properties
    
    static let manager = FirestoreService()
    static let postsCollection = "posts"
    static let usersCollection = "users"
    static let commentsCollection = "comments"

    // MARK:- Private Properties
    
    private let db = Firestore.firestore()
    
    // MARK:- Internal Properties
    
    func getPosts(onCompletion: @escaping (Result<[Post], Error>) -> Void) {
        db.collection(FirestoreService.postsCollection).getDocuments() { (querySnapshot, err) in
            if let err = err {
                onCompletion(.failure(err))
            } else {
                let posts = querySnapshot!.documents.compactMap { (snapShot) -> Post? in
                    guard let uuid = UUID(uuidString: snapShot.documentID) else { return nil }
                    return Post(from: snapShot.data(), andUUID: uuid)
                }
                onCompletion(.success(posts))
            }
        }
    }
    
    func create(_ user: PersistedUser, onCompletion: @escaping (Result<Void, Error>) -> Void) {
        db.collection(FirestoreService.usersCollection).document(user.uid).setData(user.fieldsDict) { err in
            if let err = err {
                onCompletion(.failure(err))
            } else {
                onCompletion(.success(()))
            }
        }
    }
    
    func create(_ post: Post, onCompletion: @escaping (Result<Void, Error>) -> Void) {
        db.collection("posts").document(post.uuidStr).setData(post.fieldsDict) { err in
            if let err = err {
                onCompletion(.failure(err))
            } else {
                onCompletion(.success(()))
            }
        }
    }
    
    func makePostsOnUser(_ post: Post, comment: String, completion: @escaping (Result<Bool, Error>) -> () ) {
        guard let user = Auth.auth().currentUser else { return }
    
        let docRef = db.collection(FirestoreService.postsCollection).document(post.uuidStr).collection(FirestoreService.commentsCollection).document()
        
        
        
        
    }
}
