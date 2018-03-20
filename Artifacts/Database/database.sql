-- Tables
DROP TABLE IF EXISTS Category CASCADE;
DROP TABLE IF EXISTS QuestionCategory CASCADE;
DROP TABLE IF EXISTS Question CASCADE;
DROP TABLE IF EXISTS Answer CASCADE;
DROP TABLE IF EXISTS Commentable CASCADE;
DROP TABLE IF EXISTS Comment CASCADE;
DROP TABLE IF EXISTS Message CASCADE;
DROP TABLE IF EXISTS MessageContent CASCADE;
DROP TABLE IF EXISTS "TimeStamp" CASCADE;
DROP TABLE IF EXISTS ModEdition CASCADE;
DROP TABLE IF EXISTS Vote CASCADE;
DROP TABLE IF EXISTS "User" CASCADE;
DROP TABLE IF EXISTS Moderator CASCADE;
DROP TABLE IF EXISTS Notification CASCADE;
DROP TABLE IF EXISTS CommentableNotification CASCADE;
DROP TABLE IF EXISTS BadgeNotification CASCADE;
DROP TABLE IF EXISTS BadgeAttainment CASCADE;
DROP TABLE IF EXISTS Badge CASCADE;
DROP TABLE IF EXISTS ModeratorBadge CASCADE;
DROP TABLE IF EXISTS TrustedBadge CASCADE;

CREATE TABLE Category (
    id SERIAL,
    name TEXT NOT NULL,
    description TEXT,
    num_posts INTEGER DEFAULT 0 NOT NULL
);

CREATE TABLE QuestionCategory (
    question_id BIGINT NOT NULL,
    category_id INTEGER NOT NULL
);

CREATE TABLE Question (
    id BIGINT NOT NULL,
    title TEXT NOT NULL,
    correct_answer BIGINT
);

CREATE TABLE Answer (
    id BIGINT NOT NULL,
    question_id BIGINT NOT NULL
);

CREATE TABLE Commentable (
    id BIGINT NOT NULL
);

CREATE TABLE Comment (
    id BIGINT NOT NULL,
    commentable_id BIGINT NOT NULL
);

CREATE TABLE Message (
    id BIGSERIAL,
    creation_date TIMESTAMP WITH TIME ZONE DEFAULT now() NOT NULL,
    score INTEGER DEFAULT 0 NOT NULL,
    num_reports SMALLINT DEFAULT 0 NOT NULL,
    is_banned BOOLEAN DEFAULT FALSE
);

CREATE TABLE MessageContent (
    id BIGSERIAL,
    content TEXT NOT NULL,
    message_id BIGINT
);

CREATE TABLE "TimeStamp" (
    message_content_id BIGINT NOT NULL,
    user_id BIGINT NOT NULL,
    creation_time TIMESTAMP WITH TIME ZONE DEFAULT now() NOT NULL
);

CREATE TABLE ModeratorEdition (
    message_content_id BIGINT NOT NULL,
    moderator_id BIGINT NOT NULL,
    creation_time TIMESTAMP WITH TIME ZONE DEFAULT now() NOT NULL
);

CREATE TABLE Vote (
    message_id BIGINT NOT NULL,
    user_id BIGINT NOT NULL,
    positive BOOLEAN NOT NULL
);

CREATE TABLE "User" (
    id BIGSERIAL,
    username TEXT NOT NULL,
    email TEXT NOT NULL,
    password_hash TEXT NOT NULL,
    biography TEXT,
    reputation SMALLINT NOT NULL
);

CREATE TABLE Moderator (
    id BIGINT NOT NULL
);

CREATE TABLE Notification (
    id BIGSERIAL,
    description TEXT NOT NULL,
    "date" TIMESTAMP WITH TIME ZONE DEFAULT now() NOT NULL,
    read BOOLEAN NOT NULL,
    user_id BIGINT NOT NULL
);

CREATE TABLE CommentableNotification (
    id BIGINT NOT NULL,
    commentable_id BIGINT NOT NULL
);

CREATE TABLE BadgeNotification (
    id BIGINT NOT NULL,
    badge_id BIGINT NOT NULL
);

CREATE TABLE BadgeAttainment (
    user_id BIGINT NOT NULL,
    badge_id SMALLINT NOT NULL,
    attainment_date TIMESTAMP WITH TIME ZONE DEFAULT now() NOT NULL
);

CREATE TABLE Badge (
    id SERIAL,
    description TEXT NOT NULL
);

CREATE TABLE ModeratorBadge (
    id INTEGER NOT NULL
);

CREATE TABLE TrustedBadge (
    id INTEGER NOT NULL
);


-- Primary Keys
ALTER TABLE ONLY Category
  ADD CONSTRAINT category_pkey PRIMARY KEY (id);

ALTER TABLE ONLY QuestionCategory
  ADD CONSTRAINT question_category_pkey PRIMARY KEY (question_id, category_id);

ALTER TABLE ONLY Question
  ADD CONSTRAINT question_pkey PRIMARY KEY (id);

ALTER TABLE ONLY Answer
  ADD CONSTRAINT answer_pkey PRIMARY KEY (id);

ALTER TABLE ONLY Commentable
  ADD CONSTRAINT commentable_pkey PRIMARY KEY (id);

ALTER TABLE ONLY Comment
  ADD CONSTRAINT comment_pkey PRIMARY KEY (id);

ALTER TABLE ONLY Message
  ADD CONSTRAINT message_pkey PRIMARY KEY (id);

ALTER TABLE ONLY MessageContent
  ADD CONSTRAINT message_content_pkey PRIMARY KEY (id);

ALTER TABLE ONLY "TimeStamp"
  ADD CONSTRAINT timestamp_pkey PRIMARY KEY (message_content_id);

ALTER TABLE ONLY ModeratorEdition
  ADD CONSTRAINT moderator_edition_pkey PRIMARY KEY (message_content_id);

ALTER TABLE ONLY Vote
  ADD CONSTRAINT vote_pkey PRIMARY KEY (message_id, user_id);

ALTER TABLE ONLY "User"
  ADD CONSTRAINT user_pkey PRIMARY KEY (id);

ALTER TABLE ONLY Moderator
  ADD CONSTRAINT moderator_pkey PRIMARY KEY (id);

ALTER TABLE ONLY Notification
  ADD CONSTRAINT notification_pkey PRIMARY KEY (id);

ALTER TABLE ONLY CommentableNotification
  ADD CONSTRAINT commentable_notification_pkey PRIMARY KEY (id);

ALTER TABLE ONLY BadgeNotification
  ADD CONSTRAINT badge_notification_pkey PRIMARY KEY (id);

ALTER TABLE ONLY BadgeAttainment
  ADD CONSTRAINT badge_attainment_pkey PRIMARY KEY (user_id, badge_id);

ALTER TABLE ONLY Badge
  ADD CONSTRAINT badge_pkey PRIMARY KEY (id);

ALTER TABLE ONLY ModeratorBadge
  ADD CONSTRAINT moderator_badge_pkey PRIMARY KEY (id);

ALTER TABLE ONLY TrustedBadge
  ADD CONSTRAINT trusted_badge_pkey PRIMARY KEY (id);


-- Unique
ALTER TABLE ONLY Question
  ADD CONSTRAINT correct_answer_key UNIQUE (correct_answer);

ALTER TABLE ONLY "User"
  ADD CONSTRAINT user_email_key UNIQUE (email);

ALTER TABLE ONLY "User"
  ADD CONSTRAINT username_key UNIQUE (username);


-- Foreign Keys
ALTER TABLE ONLY QuestionCategory
  ADD CONSTRAINT question_category_question_fkey FOREIGN KEY (question_id) REFERENCES Question(id) ON UPDATE CASCADE;

ALTER TABLE ONLY QuestionCategory
  ADD CONSTRAINT question_category_category_fkey FOREIGN KEY (category_id) REFERENCES Category(id) ON UPDATE CASCADE;

ALTER TABLE ONLY Question
  ADD CONSTRAINT question_fkey FOREIGN KEY (id) REFERENCES Commentable(id) ON UPDATE CASCADE;

ALTER TABLE ONLY Question
  ADD CONSTRAINT question_correct_fkey FOREIGN KEY (correct_answer) REFERENCES Answer(id) ON UPDATE CASCADE;

ALTER TABLE ONLY Answer
  ADD CONSTRAINT answer_fkey FOREIGN KEY (id) REFERENCES Commentable(id) ON UPDATE CASCADE;

ALTER TABLE ONLY Answer
  ADD CONSTRAINT answer_question_fkey FOREIGN KEY (question_id) REFERENCES Question(id) ON UPDATE CASCADE;

ALTER TABLE ONLY Commentable
  ADD CONSTRAINT commentable_message_fkey FOREIGN KEY (id) REFERENCES Message(id) ON UPDATE CASCADE;

ALTER TABLE ONLY Comment
  ADD CONSTRAINT comment_fkey FOREIGN KEY (id) REFERENCES Message(id) ON UPDATE CASCADE;

ALTER TABLE ONLY Comment
  ADD CONSTRAINT comment_commentable_fkey FOREIGN KEY (commentable_id) REFERENCES Commentable(id) ON UPDATE CASCADE;

ALTER TABLE ONLY MessageContent
  ADD CONSTRAINT message_content_message_fkey FOREIGN KEY (message_id) REFERENCES Message(id) ON UPDATE CASCADE;

ALTER TABLE ONLY "TimeStamp"
  ADD CONSTRAINT time_stamp_message_content_fkey FOREIGN KEY (message_content_id) REFERENCES MessageContent(id) ON UPDATE CASCADE;

ALTER TABLE ONLY "TimeStamp"
  ADD CONSTRAINT time_stamp_user_fkey FOREIGN KEY (user_id) REFERENCES "User"(id) ON UPDATE CASCADE;

ALTER TABLE ONLY ModeratorEdition
  ADD CONSTRAINT moderator_edition_message_content_fkey FOREIGN KEY (message_content_id) REFERENCES MessageContent(id) ON UPDATE CASCADE;

ALTER TABLE ONLY ModeratorEdition
  ADD CONSTRAINT moderator_edition_user_fkey FOREIGN KEY (moderator_id) REFERENCES Moderator(id) ON UPDATE CASCADE;

ALTER TABLE ONLY Vote
  ADD CONSTRAINT vote_message_fkey FOREIGN KEY (message_id) REFERENCES Message(id) ON UPDATE CASCADE;

ALTER TABLE ONLY Vote
  ADD CONSTRAINT vote_user_fkey FOREIGN KEY (user_id) REFERENCES "User"(id) ON UPDATE CASCADE;

ALTER TABLE ONLY Moderator
  ADD CONSTRAINT moderator_user_fkey FOREIGN KEY (id) REFERENCES "User"(id) ON UPDATE CASCADE;

ALTER TABLE ONLY Notification
  ADD CONSTRAINT notification_user_fkey FOREIGN KEY (user_id) REFERENCES "User"(id) ON UPDATE CASCADE;

ALTER TABLE ONLY CommentableNotification
  ADD CONSTRAINT commentable_notification_fkey FOREIGN KEY (id) REFERENCES Notification(id) ON UPDATE CASCADE;

ALTER TABLE ONLY CommentableNotification
  ADD CONSTRAINT commentable_notification_commentable_fkey FOREIGN KEY (id) REFERENCES Commentable(id) ON UPDATE CASCADE;

ALTER TABLE ONLY BadgeNotification
  ADD CONSTRAINT badge_notification_fkey FOREIGN KEY (id) REFERENCES Notification(id) ON UPDATE CASCADE;

ALTER TABLE ONLY BadgeNotification
  ADD CONSTRAINT badge_notification_badge_fkey FOREIGN KEY (badge_id) REFERENCES Badge(id) ON UPDATE CASCADE;

ALTER TABLE ONLY BadgeAttainment
  ADD CONSTRAINT badge_attainment_user_fkey FOREIGN KEY (user_id) REFERENCES "User"(id) ON UPDATE CASCADE;

ALTER TABLE ONLY BadgeAttainment
  ADD CONSTRAINT badge_attainment_badge_fkey FOREIGN KEY (badge_id) REFERENCES Badge(id) ON UPDATE CASCADE;

ALTER TABLE ONLY ModeratorBadge
  ADD CONSTRAINT moderator_badge_fkey FOREIGN KEY (id) REFERENCES Badge(id) ON UPDATE CASCADE;

ALTER TABLE ONLY TrustedBadge
  ADD CONSTRAINT trusted_badge_fkey FOREIGN KEY (id) REFERENCES Badge(id) ON UPDATE CASCADE;