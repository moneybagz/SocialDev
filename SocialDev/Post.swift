//
//  Post.swift
//  SocialDev
//
//  Created by Clyfford Millet on 2/2/17.
//  Copyright © 2017 Clyff Millet. All rights reserved.
//

import Foundation
import Firebase

class Post {
    private var _caption: String!
    private var _imageURL: String!
    private var _likes: Int!
    private var _postkey: String!
    private var _postRef: FIRDatabaseReference!
    
    var caption: String {
        return _caption
    }
    
    var imageURL: String {
        return _imageURL
    }
    
    var likes: Int {
        return _likes
    }
    
    var postkey: String {
        return _postkey
    }
    
    init(caption: String, imageURL: String, likes: Int, postKey: String) {
        self._caption = caption
        self._imageURL = imageURL
        self._likes = likes
    }
    
    init(postKey: String, postData: Dictionary<String, AnyObject>) {
        self._postkey = postKey
        
        if let caption = postData["caption"] as? String {
            self._caption = caption
        }
        
        if let imageURL = postData["imageURL"] as? String{
            self._imageURL = imageURL
        }
        
        if let likes = postData["likes"] as? Int {
            self._likes = likes
        }
        
        _postRef = DataService.ds.REF_POSTS.child(_postkey)
    }
    
    func adjustLikes(addLike: Bool) {
        if addLike {
            _likes = _likes + 1
        } else {
            _likes = _likes - 1
        }
        _postRef.child("likes").setValue(_likes)
    }
}
