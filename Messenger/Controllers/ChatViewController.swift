//
//  ChatViewController.swift
//  Messenger
//
//  Created by Alibek Baisholanov on 29.01.2025.
//

import UIKit
import MessageKit

class ChatViewController: MessagesViewController, MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate {
    
    private var messages = [Message]()
    
    private let selfSender = Sender(photoURL: "", senderId: "1", displayName: "Alibeeek")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messages.append(Message(sender: selfSender, messageId: UUID().uuidString, sentDate: Date(), kind: .text("Hello world bro yooou")))
        messages.append(Message(sender: selfSender, messageId: UUID().uuidString, sentDate: Date(), kind: .text("Hello world bro yooou")))

        view.backgroundColor = .green
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
    }
    
    var currentSender: any MessageKit.SenderType {
        return self.selfSender
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessageKit.MessagesCollectionView) -> any MessageKit.MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessageKit.MessagesCollectionView) -> Int {
        return messages.count 
    }
    
}

