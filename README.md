conversations (collection)
└── conversationId (document)  // ví dụ: a_b hoặc tự sinh id
    ├── userIds: [a, b]
    ├── lastMessage: "xin chào"
    ├── lastTimestamp: ...
    └── messages (subcollection)
        └── messageId (document)
        ├── senderId: a
        ├── text: "xin chào"
        ├── timestamp: ...



