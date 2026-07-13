# video_sharing-_application_db


---

**Short description (one line):**

A relational database for a video sharing platform, designed and built as part of a Systems Analysis & Database Design module (CO1605), featuring 11 normalised tables built to 3NF in Oracle Apex.

---

**README description:**

**Video Sharing Platform — Database Design **

This project is a fully normalised relational database designed for a video sharing application similar to YouTube. Built as part of the CO1605 Systems Analysis & Database Design module.This is a relational database system designed for a video sharing platform where users can upload videos, interact through comments and likes, follow other creators, and organise content into playlists. This system solves the real-world problem of storing and managing large volumes of user-generated content and social interactions in a structured, efficient way.

The database covers the following core features:
- User account management
- Video content uploading and categorisation
- Commenting system with reply threading
- Like and dislike tracking
- User follow relationships
- Playlist creation and management
- View tracking
- Content reporting

Technical Details:
- 11 tables designed to Third Normal Form (3NF)
- Built and tested in Oracle Apex
- Includes full data dictionary with constraints
- Sample data of 10 records per table
- SQL CREATE TABLE scripts with PKs, FKs, CHECK constraints and DEFAULT values
- Demonstration queries showing JOIN operations across multiple tables

Normalisation Journey:
- Unnormalised Form (UNF) → First Normal Form (1NF) → Second Normal Form (2NF) → Third Normal Form (3NF)


 Key Design Decisions:

-A self-referencing foreign key is used in the Comment table (ParentCommentID) rather than creating a separate reply table. This avoids duplicating identical data structures and keeps the schema clean while still supporting threaded comment replies.

-Categories are stored in a separate table rather than directly in the Content table to eliminate the transitive dependency VideoID → CategoryID →CategoryName.This was a key step in reaching Third Normal Form (3NF) and avoids repeating category names across multiple video records.

-The Follow table uses two foreign keys (FollowerID and FolloweeID) both referencing the same User table rather than creating separate Follower and Followee     tables. This avoids duplicating user data and correctly models the many-to-many relationship between users in a single junction table.
