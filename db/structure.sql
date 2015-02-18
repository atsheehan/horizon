--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: announcement_receipts; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE announcement_receipts (
    id integer NOT NULL,
    user_id integer NOT NULL,
    announcement_id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: announcement_receipts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE announcement_receipts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: announcement_receipts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE announcement_receipts_id_seq OWNED BY announcement_receipts.id;


--
-- Name: announcements; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE announcements (
    id integer NOT NULL,
    title character varying(255) NOT NULL,
    description text NOT NULL,
    team_id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: announcements_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE announcements_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: announcements_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE announcements_id_seq OWNED BY announcements.id;


--
-- Name: answers; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE answers (
    id integer NOT NULL,
    question_id integer NOT NULL,
    user_id integer NOT NULL,
    body text NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    searchable tsvector
);


--
-- Name: answers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE answers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: answers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE answers_id_seq OWNED BY answers.id;


--
-- Name: assignments; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE assignments (
    id integer NOT NULL,
    team_id integer NOT NULL,
    lesson_id integer NOT NULL,
    due_on timestamp without time zone NOT NULL,
    required boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: assignments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE assignments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: assignments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE assignments_id_seq OWNED BY assignments.id;


--
-- Name: calendars; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE calendars (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    cid character varying(255) NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: calendars_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE calendars_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: calendars_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE calendars_id_seq OWNED BY calendars.id;


--
-- Name: comments; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE comments (
    id integer NOT NULL,
    user_id integer NOT NULL,
    submission_id integer NOT NULL,
    body text NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    line_number integer,
    source_file_id integer,
    delivered boolean DEFAULT false NOT NULL
);


--
-- Name: comments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE comments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: comments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE comments_id_seq OWNED BY comments.id;


--
-- Name: feed_items; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE feed_items (
    id integer NOT NULL,
    subject_id integer NOT NULL,
    subject_type character varying(255) NOT NULL,
    recipient_id integer NOT NULL,
    actor_id integer NOT NULL,
    verb character varying(255) NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: feed_items_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE feed_items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: feed_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE feed_items_id_seq OWNED BY feed_items.id;


--
-- Name: identities; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE identities (
    id integer NOT NULL,
    uid character varying(255) NOT NULL,
    provider character varying(255) NOT NULL,
    user_id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: identities_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE identities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: identities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE identities_id_seq OWNED BY identities.id;


--
-- Name: lessons; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE lessons (
    id integer NOT NULL,
    type character varying(255) NOT NULL,
    title character varying(255) NOT NULL,
    slug character varying(255) NOT NULL,
    body text NOT NULL,
    description text,
    searchable tsvector,
    archive character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    "position" integer NOT NULL,
    visibility character varying(255) DEFAULT 'public'::character varying NOT NULL
);


--
-- Name: lessons_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE lessons_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: lessons_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE lessons_id_seq OWNED BY lessons.id;


--
-- Name: question_queues; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE question_queues (
    id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    status character varying(255) DEFAULT 'open'::character varying,
    user_id integer,
    sort_order integer DEFAULT 0,
    no_show_counter integer DEFAULT 0
);


--
-- Name: question_queues_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE question_queues_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: question_queues_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE question_queues_id_seq OWNED BY question_queues.id;


--
-- Name: questions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE questions (
    id integer NOT NULL,
    user_id integer NOT NULL,
    title character varying(255) NOT NULL,
    body text NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    accepted_answer_id integer,
    answers_count integer DEFAULT 0 NOT NULL,
    searchable tsvector,
    question_queue_id integer
);


--
-- Name: questions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE questions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: questions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE questions_id_seq OWNED BY questions.id;


--
-- Name: ratings; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE ratings (
    id integer NOT NULL,
    user_id integer NOT NULL,
    lesson_id integer NOT NULL,
    clarity integer NOT NULL,
    helpfulness integer NOT NULL,
    comment text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: ratings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ratings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ratings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ratings_id_seq OWNED BY ratings.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying(255) NOT NULL
);


--
-- Name: source_files; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE source_files (
    id integer NOT NULL,
    submission_id integer NOT NULL,
    filename character varying(255) DEFAULT 'untitled.txt'::character varying NOT NULL,
    body text NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: source_files_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE source_files_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: source_files_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE source_files_id_seq OWNED BY source_files.id;


--
-- Name: submissions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE submissions (
    id integer NOT NULL,
    user_id integer NOT NULL,
    lesson_id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    archive character varying(255) NOT NULL,
    public boolean DEFAULT false NOT NULL,
    featured boolean DEFAULT false NOT NULL,
    comments_count integer DEFAULT 0 NOT NULL
);


--
-- Name: submissions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE submissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: submissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE submissions_id_seq OWNED BY submissions.id;


--
-- Name: team_memberships; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE team_memberships (
    id integer NOT NULL,
    user_id integer NOT NULL,
    team_id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: team_memberships_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE team_memberships_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: team_memberships_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE team_memberships_id_seq OWNED BY team_memberships.id;


--
-- Name: teams; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE teams (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    calendar_id integer
);


--
-- Name: teams_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE teams_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: teams_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE teams_id_seq OWNED BY teams.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE users (
    id integer NOT NULL,
    email character varying(255) NOT NULL,
    username character varying(255) NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    role character varying(255) DEFAULT 'member'::character varying NOT NULL,
    token character varying(255) NOT NULL,
    first_name character varying(255) NOT NULL,
    last_name character varying(255) NOT NULL
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY announcement_receipts ALTER COLUMN id SET DEFAULT nextval('announcement_receipts_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY announcements ALTER COLUMN id SET DEFAULT nextval('announcements_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY answers ALTER COLUMN id SET DEFAULT nextval('answers_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY assignments ALTER COLUMN id SET DEFAULT nextval('assignments_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY calendars ALTER COLUMN id SET DEFAULT nextval('calendars_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY comments ALTER COLUMN id SET DEFAULT nextval('comments_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY feed_items ALTER COLUMN id SET DEFAULT nextval('feed_items_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY identities ALTER COLUMN id SET DEFAULT nextval('identities_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY lessons ALTER COLUMN id SET DEFAULT nextval('lessons_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY question_queues ALTER COLUMN id SET DEFAULT nextval('question_queues_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY questions ALTER COLUMN id SET DEFAULT nextval('questions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY ratings ALTER COLUMN id SET DEFAULT nextval('ratings_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY source_files ALTER COLUMN id SET DEFAULT nextval('source_files_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY submissions ALTER COLUMN id SET DEFAULT nextval('submissions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY team_memberships ALTER COLUMN id SET DEFAULT nextval('team_memberships_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY teams ALTER COLUMN id SET DEFAULT nextval('teams_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: announcement_receipts_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY announcement_receipts
    ADD CONSTRAINT announcement_receipts_pkey PRIMARY KEY (id);


--
-- Name: announcements_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY announcements
    ADD CONSTRAINT announcements_pkey PRIMARY KEY (id);


--
-- Name: answers_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY answers
    ADD CONSTRAINT answers_pkey PRIMARY KEY (id);


--
-- Name: assignments_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY assignments
    ADD CONSTRAINT assignments_pkey PRIMARY KEY (id);


--
-- Name: calendars_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY calendars
    ADD CONSTRAINT calendars_pkey PRIMARY KEY (id);


--
-- Name: comments_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY comments
    ADD CONSTRAINT comments_pkey PRIMARY KEY (id);


--
-- Name: feed_items_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY feed_items
    ADD CONSTRAINT feed_items_pkey PRIMARY KEY (id);


--
-- Name: identities_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY identities
    ADD CONSTRAINT identities_pkey PRIMARY KEY (id);


--
-- Name: lessons_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY lessons
    ADD CONSTRAINT lessons_pkey PRIMARY KEY (id);


--
-- Name: question_queues_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY question_queues
    ADD CONSTRAINT question_queues_pkey PRIMARY KEY (id);


--
-- Name: questions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY questions
    ADD CONSTRAINT questions_pkey PRIMARY KEY (id);


--
-- Name: ratings_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY ratings
    ADD CONSTRAINT ratings_pkey PRIMARY KEY (id);


--
-- Name: source_files_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY source_files
    ADD CONSTRAINT source_files_pkey PRIMARY KEY (id);


--
-- Name: submissions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY submissions
    ADD CONSTRAINT submissions_pkey PRIMARY KEY (id);


--
-- Name: team_memberships_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY team_memberships
    ADD CONSTRAINT team_memberships_pkey PRIMARY KEY (id);


--
-- Name: teams_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY teams
    ADD CONSTRAINT teams_pkey PRIMARY KEY (id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: index_announcements_on_team_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_announcements_on_team_id ON announcements USING btree (team_id);


--
-- Name: index_answers_on_question_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_answers_on_question_id ON answers USING btree (question_id);


--
-- Name: index_answers_on_searchable; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_answers_on_searchable ON answers USING gin (searchable);


--
-- Name: index_answers_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_answers_on_user_id ON answers USING btree (user_id);


--
-- Name: index_assignments_on_lesson_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_assignments_on_lesson_id ON assignments USING btree (lesson_id);


--
-- Name: index_assignments_on_team_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_assignments_on_team_id ON assignments USING btree (team_id);


--
-- Name: index_calendars_on_cid; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_calendars_on_cid ON calendars USING btree (cid);


--
-- Name: index_comments_on_delivered; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_comments_on_delivered ON comments USING btree (delivered) WHERE (delivered = false);


--
-- Name: index_comments_on_source_file_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_comments_on_source_file_id ON comments USING btree (source_file_id);


--
-- Name: index_comments_on_submission_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_comments_on_submission_id ON comments USING btree (submission_id);


--
-- Name: index_comments_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_comments_on_user_id ON comments USING btree (user_id);


--
-- Name: index_feed_items_on_actor_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_feed_items_on_actor_id ON feed_items USING btree (actor_id);


--
-- Name: index_feed_items_on_recipient_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_feed_items_on_recipient_id ON feed_items USING btree (recipient_id);


--
-- Name: index_feed_items_on_subject_id_and_subject_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_feed_items_on_subject_id_and_subject_type ON feed_items USING btree (subject_id, subject_type);


--
-- Name: index_identities_on_uid_and_provider; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_identities_on_uid_and_provider ON identities USING btree (uid, provider);


--
-- Name: index_identities_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_identities_on_user_id ON identities USING btree (user_id);


--
-- Name: index_lessons_on_searchable; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_lessons_on_searchable ON lessons USING gin (searchable);


--
-- Name: index_lessons_on_slug; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_lessons_on_slug ON lessons USING btree (slug);


--
-- Name: index_lessons_on_visibility; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_lessons_on_visibility ON lessons USING btree (visibility);


--
-- Name: index_questions_on_searchable; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_questions_on_searchable ON questions USING gin (searchable);


--
-- Name: index_questions_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_questions_on_user_id ON questions USING btree (user_id);


--
-- Name: index_ratings_on_lesson_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_ratings_on_lesson_id ON ratings USING btree (lesson_id);


--
-- Name: index_ratings_on_user_id_and_lesson_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_ratings_on_user_id_and_lesson_id ON ratings USING btree (user_id, lesson_id);


--
-- Name: index_source_files_on_submission_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_source_files_on_submission_id ON source_files USING btree (submission_id);


--
-- Name: index_submissions_on_lesson_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_submissions_on_lesson_id ON submissions USING btree (lesson_id);


--
-- Name: index_submissions_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_submissions_on_user_id ON submissions USING btree (user_id);


--
-- Name: index_team_memberships_on_team_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_team_memberships_on_team_id ON team_memberships USING btree (team_id);


--
-- Name: index_team_memberships_on_user_id_and_team_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_team_memberships_on_user_id_and_team_id ON team_memberships USING btree (user_id, team_id);


--
-- Name: index_teams_on_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_teams_on_name ON teams USING btree (name);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_email ON users USING btree (email);


--
-- Name: index_users_on_lowercase_username; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_lowercase_username ON users USING btree (lower((username)::text));


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- Name: answers_searchable_update; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER answers_searchable_update BEFORE INSERT OR UPDATE ON answers FOR EACH ROW EXECUTE PROCEDURE tsvector_update_trigger('searchable', 'pg_catalog.english', 'body');


--
-- Name: lessons_searchable_update; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER lessons_searchable_update BEFORE INSERT OR UPDATE ON lessons FOR EACH ROW EXECUTE PROCEDURE tsvector_update_trigger('searchable', 'pg_catalog.english', 'title', 'body', 'description');


--
-- Name: questions_searchable_update; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER questions_searchable_update BEFORE INSERT OR UPDATE ON questions FOR EACH ROW EXECUTE PROCEDURE tsvector_update_trigger('searchable', 'pg_catalog.english', 'title', 'body');


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user",public;

INSERT INTO schema_migrations (version) VALUES ('20140704220243');

INSERT INTO schema_migrations (version) VALUES ('20140705025620');

INSERT INTO schema_migrations (version) VALUES ('20140705060613');

INSERT INTO schema_migrations (version) VALUES ('20140706174616');

INSERT INTO schema_migrations (version) VALUES ('20140706183730');

INSERT INTO schema_migrations (version) VALUES ('20140707014614');

INSERT INTO schema_migrations (version) VALUES ('20140708222017');

INSERT INTO schema_migrations (version) VALUES ('20140708222338');

INSERT INTO schema_migrations (version) VALUES ('20140711194907');

INSERT INTO schema_migrations (version) VALUES ('20140712155618');

INSERT INTO schema_migrations (version) VALUES ('20140712191638');

INSERT INTO schema_migrations (version) VALUES ('20140713160257');

INSERT INTO schema_migrations (version) VALUES ('20140714010254');

INSERT INTO schema_migrations (version) VALUES ('20140715190942');

INSERT INTO schema_migrations (version) VALUES ('20140720030415');

INSERT INTO schema_migrations (version) VALUES ('20140720030640');

INSERT INTO schema_migrations (version) VALUES ('20140720040146');

INSERT INTO schema_migrations (version) VALUES ('20140720040402');

INSERT INTO schema_migrations (version) VALUES ('20140720185457');

INSERT INTO schema_migrations (version) VALUES ('20140802123039');

INSERT INTO schema_migrations (version) VALUES ('20140807181006');

INSERT INTO schema_migrations (version) VALUES ('20140810001317');

INSERT INTO schema_migrations (version) VALUES ('20140814010454');

INSERT INTO schema_migrations (version) VALUES ('20140814011324');

INSERT INTO schema_migrations (version) VALUES ('20140814011639');

INSERT INTO schema_migrations (version) VALUES ('20140814011852');

INSERT INTO schema_migrations (version) VALUES ('20140814012512');

INSERT INTO schema_migrations (version) VALUES ('20140818203653');

INSERT INTO schema_migrations (version) VALUES ('20140819174653');

INSERT INTO schema_migrations (version) VALUES ('20140826152921');

INSERT INTO schema_migrations (version) VALUES ('20140901185227');

INSERT INTO schema_migrations (version) VALUES ('20140901191401');

INSERT INTO schema_migrations (version) VALUES ('20140901191402');

INSERT INTO schema_migrations (version) VALUES ('20140928165428');

INSERT INTO schema_migrations (version) VALUES ('20140928170912');

INSERT INTO schema_migrations (version) VALUES ('20140928175407');

INSERT INTO schema_migrations (version) VALUES ('20140930132041');

INSERT INTO schema_migrations (version) VALUES ('20141003154749');

INSERT INTO schema_migrations (version) VALUES ('20141013190514');

INSERT INTO schema_migrations (version) VALUES ('20141019150156');

INSERT INTO schema_migrations (version) VALUES ('20141019150403');

INSERT INTO schema_migrations (version) VALUES ('20141021185401');

INSERT INTO schema_migrations (version) VALUES ('20141030203942');

INSERT INTO schema_migrations (version) VALUES ('20141102184011');

INSERT INTO schema_migrations (version) VALUES ('20141113200644');

INSERT INTO schema_migrations (version) VALUES ('20141126230346');

INSERT INTO schema_migrations (version) VALUES ('20141204203947');

INSERT INTO schema_migrations (version) VALUES ('20141216173739');

INSERT INTO schema_migrations (version) VALUES ('20141216212826');

INSERT INTO schema_migrations (version) VALUES ('20141217191055');

INSERT INTO schema_migrations (version) VALUES ('20150102202537');

INSERT INTO schema_migrations (version) VALUES ('20150116001337');

INSERT INTO schema_migrations (version) VALUES ('20150122213444');

INSERT INTO schema_migrations (version) VALUES ('20150123164500');

INSERT INTO schema_migrations (version) VALUES ('20150123203729');

INSERT INTO schema_migrations (version) VALUES ('20150205180710');

INSERT INTO schema_migrations (version) VALUES ('20150205184909');

INSERT INTO schema_migrations (version) VALUES ('20150206162914');

INSERT INTO schema_migrations (version) VALUES ('20150206184403');

INSERT INTO schema_migrations (version) VALUES ('20150206211308');

INSERT INTO schema_migrations (version) VALUES ('20150209154829');

INSERT INTO schema_migrations (version) VALUES ('20150210202615');

INSERT INTO schema_migrations (version) VALUES ('20150210203036');

INSERT INTO schema_migrations (version) VALUES ('20150211121322');

INSERT INTO schema_migrations (version) VALUES ('20150212144048');

INSERT INTO schema_migrations (version) VALUES ('20150212145515');

INSERT INTO schema_migrations (version) VALUES ('20150212145738');

INSERT INTO schema_migrations (version) VALUES ('20150216154949');

