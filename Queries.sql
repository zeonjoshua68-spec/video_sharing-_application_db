------------------------------------------------
Create Table scripts
------------------------------------------------
-- 1. CATEGORIES_TBL	
CREATE TABLE CATEGORIES_TBL (
    CategoryID    NUMBER(10)    NOT NULL,
    CategoryName  VARCHAR2(100) NOT NULL,
    CONSTRAINT pk_category PRIMARY KEY (CategoryID),
    CONSTRAINT uq_category_name UNIQUE (CategoryName)
);

-- 2. USER_TBL
CREATE TABLE USER_TBL (
    UserID             NUMBER(10)    NOT NULL,
    Username           VARCHAR2(50)  NOT NULL,
    FirstName          VARCHAR2(50)  NOT NULL,
    LastName           VARCHAR2(50)  NOT NULL,
    Email              VARCHAR2(100) NOT NULL,
    DOB                DATE          NOT NULL,
    PasswordHash       VARCHAR2(255) NOT NULL,
    ProfilePictureURL  VARCHAR2(500),
    AccountCreatedDate DATE          DEFAULT SYSDATE NOT NULL,
    AccountStatus      VARCHAR2(20)  DEFAULT 'active' NOT NULL,
    CONSTRAINT pk_user PRIMARY KEY (UserID),
    CONSTRAINT uq_username UNIQUE (Username),
    CONSTRAINT uq_email UNIQUE (Email),
    CONSTRAINT chk_dob CHECK (DOB <= SYSDATE - INTERVAL '13' YEAR),
    CONSTRAINT chk_user_status CHECK (AccountStatus IN ('active','suspended','banned'))
);

-- 3. CONTENT_TBL
CREATE TABLE CONTENT_TBL (
    ContentID      NUMBER(10)     NOT NULL,
    UserID         NUMBER(10)     NOT NULL,
    CategoryID     NUMBER(10),
    Title          VARCHAR2(200)  NOT NULL,
    Description    VARCHAR2(2000),
    Duration       NUMBER(6)      NOT NULL,
    UploadDate     DATE           DEFAULT SYSDATE NOT NULL,
    ViewCount      NUMBER(15)     DEFAULT 0 NOT NULL,
    Status         VARCHAR2(20)   DEFAULT 'public' NOT NULL,
    FilePath       VARCHAR2(500)  NOT NULL,
    ThumbnailURL   VARCHAR2(500),
    CONSTRAINT pk_content PRIMARY KEY (ContentID),
    CONSTRAINT fk_content_user FOREIGN KEY (UserID) REFERENCES USER_TBL(UserID),
    CONSTRAINT fk_content_category FOREIGN KEY (CategoryID) REFERENCES CATEGORIES_TBL(CategoryID),
    CONSTRAINT chk_duration CHECK (Duration > 0),
    CONSTRAINT chk_viewcount CHECK (ViewCount >= 0),
    CONSTRAINT chk_content_status CHECK (Status IN ('public','private','draft'))
);

-- 4. COMMENT_TBL
CREATE TABLE COMMENT_TBL (
    CommentID       NUMBER(10)    NOT NULL,
    ContentID       NUMBER(10)    NOT NULL,
    UserID          NUMBER(10)    NOT NULL,
    ParentCommentID NUMBER(10),
    CommentText     VARCHAR2(1000) NOT NULL,
    CommentDate     DATE          DEFAULT SYSDATE NOT NULL,
    Status          VARCHAR2(20)  DEFAULT 'visible' NOT NULL,
    CONSTRAINT pk_comment PRIMARY KEY (CommentID),
    CONSTRAINT fk_comment_content FOREIGN KEY (ContentID) REFERENCES CONTENT_TBL(ContentID),
    CONSTRAINT fk_comment_user FOREIGN KEY (UserID) REFERENCES USER_TBL(UserID),
    CONSTRAINT fk_comment_parent FOREIGN KEY (ParentCommentID) REFERENCES COMMENT_TBL(CommentID),
    CONSTRAINT chk_comment_status CHECK (Status IN ('visible','hidden','flagged'))
);

-- 5. LIKE_TBL
CREATE TABLE LIKE_TBL (
    LikeID     NUMBER(10)  NOT NULL,
    ContentID  NUMBER(10)  NOT NULL,
    UserID     NUMBER(10)  NOT NULL,
    Type       VARCHAR2(10) NOT NULL,
    DateLiked  DATE        DEFAULT SYSDATE NOT NULL,
    CONSTRAINT pk_like PRIMARY KEY (LikeID),
    CONSTRAINT fk_like_content FOREIGN KEY (ContentID) REFERENCES CONTENT_TBL(ContentID),
    CONSTRAINT fk_like_user FOREIGN KEY (UserID) REFERENCES USER_TBL(UserID),
    CONSTRAINT chk_like_type CHECK (Type IN ('like','dislike'))
);

-- 6. FOLLOW_TBL
CREATE TABLE FOLLOW_TBL (
    FollowID    NUMBER(10) NOT NULL,
    FollowerID  NUMBER(10) NOT NULL,
    FolloweeID  NUMBER(10) NOT NULL,
    FollowDate  DATE       DEFAULT SYSDATE NOT NULL,
    CONSTRAINT pk_follow PRIMARY KEY (FollowID),
    CONSTRAINT fk_follower FOREIGN KEY (FollowerID) REFERENCES USER_TBL(UserID),
    CONSTRAINT fk_followee FOREIGN KEY (FolloweeID) REFERENCES USER_TBL(UserID),
    CONSTRAINT chk_no_self_follow CHECK (FollowerID != FolloweeID)
);

-- 7. REPORTER_TBL
CREATE TABLE REPORTER_TBL (
    ReporterID  NUMBER(10)   NOT NULL,
    UserID      NUMBER(10)   NOT NULL,
    ContentID   NUMBER(10)   NOT NULL,
    Reason      VARCHAR2(500) NOT NULL,
    ReportDate  DATE         DEFAULT SYSDATE NOT NULL,
    CONSTRAINT pk_reporter PRIMARY KEY (ReporterID),
    CONSTRAINT fk_reporter_user FOREIGN KEY (UserID) REFERENCES USER_TBL(UserID),
    CONSTRAINT fk_reporter_content FOREIGN KEY (ContentID) REFERENCES CONTENT_TBL(ContentID)
);

-- 8. VIEW_TBL
CREATE TABLE VIEW_TBL (
    ViewID      NUMBER(10) NOT NULL,
    UserID      NUMBER(10) NOT NULL,
    ContentID   NUMBER(10) NOT NULL,
    DateViewed  DATE       DEFAULT SYSDATE NOT NULL,
    CONSTRAINT pk_view PRIMARY KEY (ViewID),
    CONSTRAINT fk_view_user FOREIGN KEY (UserID) REFERENCES USER_TBL(UserID),
    CONSTRAINT fk_view_content FOREIGN KEY (ContentID) REFERENCES CONTENT_TBL(ContentID)
);

-- 9. PLAYLISTS_TBL
CREATE TABLE PLAYLISTS_TBL (
    PlaylistID    NUMBER(10)   NOT NULL,
    UserID        NUMBER(10)   NOT NULL,
    PlaylistName  VARCHAR2(200) NOT NULL,
    CreatedDate   DATE         DEFAULT SYSDATE NOT NULL,
    CONSTRAINT pk_playlist PRIMARY KEY (PlaylistID),
    CONSTRAINT fk_playlist_user FOREIGN KEY (UserID) REFERENCES USER_TBL(UserID)
);

-- 10. PLAYLISTCONTENT_TBL
CREATE TABLE PLAYLISTCONTENT_TBL (
    PlaylistContentID  NUMBER(10) NOT NULL,
    PlaylistID         NUMBER(10) NOT NULL,
    ContentID          NUMBER(10) NOT NULL,
    AddedDate          DATE       DEFAULT SYSDATE NOT NULL,
    OrderIndex         NUMBER(5)  NOT NULL,
    CONSTRAINT pk_playlistcontent PRIMARY KEY (PlaylistContentID),
    CONSTRAINT fk_pc_playlist FOREIGN KEY (PlaylistID) REFERENCES PLAYLISTS_TBL(PlaylistID),
    CONSTRAINT fk_pc_content FOREIGN KEY (ContentID) REFERENCES CONTENT_TBL(ContentID),
    CONSTRAINT chk_order_index CHECK (OrderIndex >= 1)
);

-- 11. COMMENTLIKES_TBL
CREATE TABLE COMMENTLIKES_TBL (
    CommentLikeID  NUMBER(10) NOT NULL,
    CommentID      NUMBER(10) NOT NULL,
    UserID         NUMBER(10) NOT NULL,
    DateLiked      DATE       DEFAULT SYSDATE NOT NULL,
    CONSTRAINT pk_commentlike PRIMARY KEY (CommentLikeID),
    CONSTRAINT fk_cl_comment FOREIGN KEY (CommentID) REFERENCES COMMENT_TBL(CommentID),
    CONSTRAINT fk_cl_user FOREIGN KEY (UserID) REFERENCES USER_TBL(UserID)
);
 
------------------------------------------------------------
Demonstrations:
------------------------------------------------------------

1. Show all videos with their creator and category
SELECT c.Title, u.Username, cat.CategoryName, c.ViewCount, c.Status
FROM CONTENT_TBL c
JOIN USER_TBL u ON c.UserID = u.UserID
JOIN CATEGORIES_TBL cat ON c.CategoryID = cat.CategoryID
ORDER BY c.ViewCount DESC;
 


2. Show all comments on a specific video including replies
SELECT c.CommentID, u.Username, c.CommentText, c.ParentCommentID, c.CommentDate
FROM COMMENT_TBL c
JOIN USER_TBL u ON c.UserID = u.UserID
WHERE c.ContentID = 1
ORDER BY c.CommentDate;
 

3. Show total likes and dislikes per video
SELECT c.Title,
SUM(CASE WHEN l.Type = 'like' THEN 1 ELSE 0 END) AS TotalLikes,
SUM(CASE WHEN l.Type = 'dislike' THEN 1 ELSE 0 END) AS TotalDislikes
FROM CONTENT_TBL c
JOIN LIKE_TBL l ON c.ContentID = l.ContentID
GROUP BY c.Title
ORDER BY TotalLikes DESC;
 

4. Show all followers of a specific user
SELECT u.Username AS Follower, u2.Username AS Following
FROM FOLLOW_TBL f
JOIN USER_TBL u ON f.FollowerID = u.UserID
JOIN USER_TBL u2 ON f.FolloweeID = u2.UserID
WHERE f.FolloweeID = 1;
 

5. Show most viewed videos
SELECT c.Title, u.Username, c.ViewCount
FROM CONTENT_TBL c
JOIN USER_TBL u ON c.UserID = u.UserID
ORDER BY c.ViewCount DESC;
 

6. Show all reported content with reason
SELECT u.Username AS ReportedBy, c.Title AS VideoReported, r.Reason, r.ReportDate
FROM REPORTER_TBL r
JOIN USER_TBL u ON r.UserID = u.UserID
JOIN CONTENT_TBL c ON r.ContentID = c.ContentID
ORDER BY r.ReportDate;
 

7. Show all videos in a specific playlist
SELECT p.PlaylistName, c.Title, pc.OrderIndex, pc.AddedDate
FROM PLAYLISTCONTENT_TBL pc
JOIN PLAYLISTS_TBL p ON pc.PlaylistID = p.PlaylistID
JOIN CONTENT_TBL c ON pc.ContentID = c.ContentID
WHERE pc.PlaylistID = 1
ORDER BY pc.OrderIndex;
 


8. Show users who liked a comment and which comment
SELECT u.Username, co.CommentText, cl.DateLiked
FROM COMMENTLIKES_TBL cl
JOIN USER_TBL u ON cl.UserID = u.UserID
JOIN COMMENT_TBL co ON cl.CommentID = co.CommentID
ORDER BY cl.DateLiked;
 


9. Show active users who have uploaded videos
SELECT DISTINCT u.Username, u.AccountStatus, COUNT(c.ContentID) AS TotalVideos
FROM USER_TBL u
JOIN CONTENT_TBL c ON u.UserID = c.UserID
WHERE u.AccountStatus = 'active'
GROUP BY u.Username, u.AccountStatus
ORDER BY TotalVideos DESC;
 


10. Show all videos watched by a specific user
SELECT u.Username, c.Title, v.DateViewed
FROM VIEW_TBL v
JOIN USER_TBL u ON v.UserID = u.UserID
JOIN CONTENT_TBL c ON v.ContentID = c.ContentID
WHERE v.UserID = 1
ORDER BY v.DateViewed;

