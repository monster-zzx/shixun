CREATE TABLE IF NOT EXISTS post (
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(200) NOT NULL,
    content TEXT NOT NULL,
    user_id INT NOT NULL,
    bar_id INT NOT NULL,
    view_count INT DEFAULT 0,
    like_count INT DEFAULT 0,
    comment_count INT DEFAULT 0,
    status VARCHAR(20) DEFAULT 'ACTIVE',
    pubtime DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES user(id) ON DELETE CASCADE,
    FOREIGN KEY (bar_id) REFERENCES bar(id) ON DELETE CASCADE,
    INDEX idx_user_id (user_id),
    INDEX idx_bar_id (bar_id),
    INDEX idx_status (status),
    INDEX idx_pubtime (pubtime)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
