--
-- PostgreSQL database dump
--

-- Dumped from database version 17.4
-- Dumped by pg_dump version 17.4

-- Started on 2025-05-10 17:28:49

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 264 (class 1259 OID 26397)
-- Name: access_permissions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.access_permissions (
    "AccessID" integer NOT NULL,
    "Name" character varying,
    "Description" character varying,
    "UserID" integer
);


ALTER TABLE public.access_permissions OWNER TO postgres;

--
-- TOC entry 263 (class 1259 OID 26396)
-- Name: access_permissions_AccessID_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."access_permissions_AccessID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."access_permissions_AccessID_seq" OWNER TO postgres;

--
-- TOC entry 5183 (class 0 OID 0)
-- Dependencies: 263
-- Name: access_permissions_AccessID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."access_permissions_AccessID_seq" OWNED BY public.access_permissions."AccessID";


--
-- TOC entry 229 (class 1259 OID 26060)
-- Name: administrative_staffs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.administrative_staffs (
    "AdminID" integer NOT NULL,
    "Note" character varying
);


ALTER TABLE public.administrative_staffs OWNER TO postgres;

--
-- TOC entry 244 (class 1259 OID 26223)
-- Name: class_posts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.class_posts (
    "PostID" integer NOT NULL,
    "Title" character varying,
    "Type" character varying,
    "Content" text,
    "EventDate" timestamp without time zone,
    "CreatedAt" timestamp without time zone,
    "TeacherID" integer,
    "ClassID" integer
);


ALTER TABLE public.class_posts OWNER TO postgres;

--
-- TOC entry 243 (class 1259 OID 26222)
-- Name: class_posts_PostID_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."class_posts_PostID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."class_posts_PostID_seq" OWNER TO postgres;

--
-- TOC entry 5184 (class 0 OID 0)
-- Dependencies: 243
-- Name: class_posts_PostID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."class_posts_PostID_seq" OWNED BY public.class_posts."PostID";


--
-- TOC entry 242 (class 1259 OID 26198)
-- Name: class_subjects; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.class_subjects (
    "ClassSubjectID" integer NOT NULL,
    "TeacherID" integer,
    "ClassID" integer,
    "SubjectID" integer,
    "Semester" character varying,
    "AcademicYear" character varying,
    "UpdatedAt" timestamp without time zone
);


ALTER TABLE public.class_subjects OWNER TO postgres;

--
-- TOC entry 241 (class 1259 OID 26197)
-- Name: class_subjects_ClassSubjectID_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."class_subjects_ClassSubjectID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."class_subjects_ClassSubjectID_seq" OWNER TO postgres;

--
-- TOC entry 5185 (class 0 OID 0)
-- Dependencies: 241
-- Name: class_subjects_ClassSubjectID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."class_subjects_ClassSubjectID_seq" OWNED BY public.class_subjects."ClassSubjectID";


--
-- TOC entry 235 (class 1259 OID 26133)
-- Name: classes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.classes (
    "ClassID" integer NOT NULL,
    "ClassName" character varying,
    "GradeLevel" character varying,
    "AcademicYear" character varying,
    "HomeroomTeacherID" integer
);


ALTER TABLE public.classes OWNER TO postgres;

--
-- TOC entry 234 (class 1259 OID 26132)
-- Name: classes_ClassID_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."classes_ClassID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."classes_ClassID_seq" OWNER TO postgres;

--
-- TOC entry 5186 (class 0 OID 0)
-- Dependencies: 234
-- Name: classes_ClassID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."classes_ClassID_seq" OWNED BY public.classes."ClassID";


--
-- TOC entry 220 (class 1259 OID 25989)
-- Name: conversations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.conversations (
    "ConversationID" integer NOT NULL,
    "CreatedAt" timestamp without time zone,
    "Name" character varying,
    "NumOfParticipation" integer
);


ALTER TABLE public.conversations OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 25988)
-- Name: conversations_ConversationID_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."conversations_ConversationID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."conversations_ConversationID_seq" OWNER TO postgres;

--
-- TOC entry 5187 (class 0 OID 0)
-- Dependencies: 219
-- Name: conversations_ConversationID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."conversations_ConversationID_seq" OWNED BY public.conversations."ConversationID";


--
-- TOC entry 258 (class 1259 OID 26346)
-- Name: daily_progress; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.daily_progress (
    "DailyID" integer NOT NULL,
    "Overall" text,
    "Attendance" character varying,
    "StudyOutcome" text,
    "Reprimand" text,
    "Date" date,
    "TeacherID" integer,
    "StudentID" integer
);


ALTER TABLE public.daily_progress OWNER TO postgres;

--
-- TOC entry 257 (class 1259 OID 26345)
-- Name: daily_progress_DailyID_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."daily_progress_DailyID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."daily_progress_DailyID_seq" OWNER TO postgres;

--
-- TOC entry 5188 (class 0 OID 0)
-- Dependencies: 257
-- Name: daily_progress_DailyID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."daily_progress_DailyID_seq" OWNED BY public.daily_progress."DailyID";


--
-- TOC entry 222 (class 1259 OID 25999)
-- Name: departments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.departments (
    "DepartmentID" integer NOT NULL,
    "DepartmentName" character varying,
    "Description" character varying
);


ALTER TABLE public.departments OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 25998)
-- Name: departments_DepartmentID_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."departments_DepartmentID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."departments_DepartmentID_seq" OWNER TO postgres;

--
-- TOC entry 5189 (class 0 OID 0)
-- Dependencies: 221
-- Name: departments_DepartmentID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."departments_DepartmentID_seq" OWNED BY public.departments."DepartmentID";


--
-- TOC entry 248 (class 1259 OID 26258)
-- Name: event_files; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.event_files (
    "FileID" integer NOT NULL,
    "FileName" character varying,
    "FilePath" character varying,
    "FileSize" integer,
    "ContentType" character varying,
    "SubmittedAt" timestamp without time zone,
    "EventID" integer
);


ALTER TABLE public.event_files OWNER TO postgres;

--
-- TOC entry 247 (class 1259 OID 26257)
-- Name: event_files_FileID_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."event_files_FileID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."event_files_FileID_seq" OWNER TO postgres;

--
-- TOC entry 5190 (class 0 OID 0)
-- Dependencies: 247
-- Name: event_files_FileID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."event_files_FileID_seq" OWNED BY public.event_files."FileID";


--
-- TOC entry 233 (class 1259 OID 26117)
-- Name: events; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.events (
    "EventID" integer NOT NULL,
    "Title" character varying,
    "Type" character varying,
    "Content" text,
    "EventDate" timestamp without time zone,
    "CreatedAt" timestamp without time zone,
    "AdminID" integer
);


ALTER TABLE public.events OWNER TO postgres;

--
-- TOC entry 232 (class 1259 OID 26116)
-- Name: events_EventID_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."events_EventID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."events_EventID_seq" OWNER TO postgres;

--
-- TOC entry 5191 (class 0 OID 0)
-- Dependencies: 232
-- Name: events_EventID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."events_EventID_seq" OWNED BY public.events."EventID";


--
-- TOC entry 262 (class 1259 OID 26381)
-- Name: grade_components; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.grade_components (
    "ComponentID" integer NOT NULL,
    "ComponentName" character varying,
    "GradeID" integer,
    "Weight" double precision,
    "Score" double precision,
    "SubmitDate" timestamp without time zone
);


ALTER TABLE public.grade_components OWNER TO postgres;

--
-- TOC entry 261 (class 1259 OID 26380)
-- Name: grade_components_ComponentID_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."grade_components_ComponentID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."grade_components_ComponentID_seq" OWNER TO postgres;

--
-- TOC entry 5192 (class 0 OID 0)
-- Dependencies: 261
-- Name: grade_components_ComponentID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."grade_components_ComponentID_seq" OWNED BY public.grade_components."ComponentID";


--
-- TOC entry 252 (class 1259 OID 26291)
-- Name: grades; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.grades (
    "GradeID" integer NOT NULL,
    "StudentID" integer,
    "ClassSubjectID" integer,
    "FinalScore" double precision,
    "Semester" character varying,
    "UpdatedAt" timestamp without time zone
);


ALTER TABLE public.grades OWNER TO postgres;

--
-- TOC entry 251 (class 1259 OID 26290)
-- Name: grades_GradeID_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."grades_GradeID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."grades_GradeID_seq" OWNER TO postgres;

--
-- TOC entry 5193 (class 0 OID 0)
-- Dependencies: 251
-- Name: grades_GradeID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."grades_GradeID_seq" OWNED BY public.grades."GradeID";


--
-- TOC entry 239 (class 1259 OID 26168)
-- Name: message_files; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.message_files (
    "FileID" integer NOT NULL,
    "FileName" character varying,
    "FileSize" integer,
    "ContentType" character varying,
    "SubmittedAt" timestamp without time zone,
    "MessageID" integer
);


ALTER TABLE public.message_files OWNER TO postgres;

--
-- TOC entry 238 (class 1259 OID 26167)
-- Name: message_files_FileID_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."message_files_FileID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."message_files_FileID_seq" OWNER TO postgres;

--
-- TOC entry 5194 (class 0 OID 0)
-- Dependencies: 238
-- Name: message_files_FileID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."message_files_FileID_seq" OWNED BY public.message_files."FileID";


--
-- TOC entry 226 (class 1259 OID 26023)
-- Name: messages; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.messages (
    "MessageID" integer NOT NULL,
    "ConversationID" integer,
    "Content" character varying,
    "SentAt" timestamp without time zone,
    "UserID" integer
);


ALTER TABLE public.messages OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 26022)
-- Name: messages_MessageID_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."messages_MessageID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."messages_MessageID_seq" OWNER TO postgres;

--
-- TOC entry 5195 (class 0 OID 0)
-- Dependencies: 225
-- Name: messages_MessageID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."messages_MessageID_seq" OWNED BY public.messages."MessageID";


--
-- TOC entry 250 (class 1259 OID 26273)
-- Name: parent_students; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.parent_students (
    "RelationshipID" integer NOT NULL,
    "Relationship" public.relationshiptype,
    "ParentID" integer,
    "StudentID" integer
);


ALTER TABLE public.parent_students OWNER TO postgres;

--
-- TOC entry 249 (class 1259 OID 26272)
-- Name: parent_students_RelationshipID_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."parent_students_RelationshipID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."parent_students_RelationshipID_seq" OWNER TO postgres;

--
-- TOC entry 5196 (class 0 OID 0)
-- Dependencies: 249
-- Name: parent_students_RelationshipID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."parent_students_RelationshipID_seq" OWNED BY public.parent_students."RelationshipID";


--
-- TOC entry 231 (class 1259 OID 26089)
-- Name: parents; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.parents (
    "ParentID" integer NOT NULL,
    "Occupation" character varying
);


ALTER TABLE public.parents OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 26043)
-- Name: participations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.participations (
    "ParticipationID" integer NOT NULL,
    "ConversationID" integer,
    "UserID" integer,
    "JoinedAt" timestamp without time zone
);


ALTER TABLE public.participations OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 26042)
-- Name: participations_ParticipationID_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."participations_ParticipationID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."participations_ParticipationID_seq" OWNER TO postgres;

--
-- TOC entry 5197 (class 0 OID 0)
-- Dependencies: 227
-- Name: participations_ParticipationID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."participations_ParticipationID_seq" OWNED BY public.participations."ParticipationID";


--
-- TOC entry 246 (class 1259 OID 26243)
-- Name: petition_files; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.petition_files (
    "FileID" integer NOT NULL,
    "FileName" character varying,
    "FilePath" character varying,
    "FileSize" integer,
    "ContentType" character varying,
    "SubmittedAt" timestamp without time zone,
    "PetitionID" integer
);


ALTER TABLE public.petition_files OWNER TO postgres;

--
-- TOC entry 245 (class 1259 OID 26242)
-- Name: petition_files_FileID_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."petition_files_FileID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."petition_files_FileID_seq" OWNER TO postgres;

--
-- TOC entry 5198 (class 0 OID 0)
-- Dependencies: 245
-- Name: petition_files_FileID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."petition_files_FileID_seq" OWNED BY public.petition_files."FileID";


--
-- TOC entry 237 (class 1259 OID 26148)
-- Name: petitions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.petitions (
    "PetitionID" integer NOT NULL,
    "ParentID" integer,
    "AdminID" integer,
    "Title" character varying,
    "Content" character varying,
    "Status" public.petitionstatus,
    "SubmittedAt" timestamp without time zone,
    "Response" character varying
);


ALTER TABLE public.petitions OWNER TO postgres;

--
-- TOC entry 236 (class 1259 OID 26147)
-- Name: petitions_PetitionID_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."petitions_PetitionID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."petitions_PetitionID_seq" OWNER TO postgres;

--
-- TOC entry 5199 (class 0 OID 0)
-- Dependencies: 236
-- Name: petitions_PetitionID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."petitions_PetitionID_seq" OWNED BY public.petitions."PetitionID";


--
-- TOC entry 256 (class 1259 OID 26331)
-- Name: post_files; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.post_files (
    "FileID" integer NOT NULL,
    "FileName" character varying,
    "FilePath" character varying,
    "FileSize" integer,
    "ContentType" character varying,
    "SubmittedAt" timestamp without time zone,
    "PostID" integer
);


ALTER TABLE public.post_files OWNER TO postgres;

--
-- TOC entry 255 (class 1259 OID 26330)
-- Name: post_files_FileID_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."post_files_FileID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."post_files_FileID_seq" OWNER TO postgres;

--
-- TOC entry 5200 (class 0 OID 0)
-- Dependencies: 255
-- Name: post_files_FileID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."post_files_FileID_seq" OWNED BY public.post_files."FileID";


--
-- TOC entry 254 (class 1259 OID 26311)
-- Name: reward_punishments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.reward_punishments (
    "RecordID" integer NOT NULL,
    "Title" character varying,
    "Type" public.rnptype,
    "Description" character varying,
    "Date" timestamp without time zone,
    "Semester" character varying,
    "Week" integer,
    "StudentID" integer,
    "AdminID" integer
);


ALTER TABLE public.reward_punishments OWNER TO postgres;

--
-- TOC entry 253 (class 1259 OID 26310)
-- Name: reward_punishments_RecordID_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."reward_punishments_RecordID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."reward_punishments_RecordID_seq" OWNER TO postgres;

--
-- TOC entry 5201 (class 0 OID 0)
-- Dependencies: 253
-- Name: reward_punishments_RecordID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."reward_punishments_RecordID_seq" OWNED BY public.reward_punishments."RecordID";


--
-- TOC entry 240 (class 1259 OID 26182)
-- Name: students; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.students (
    "StudentID" integer NOT NULL,
    "ClassID" integer,
    "EnrollmentDate" timestamp without time zone,
    "YtDate" timestamp without time zone
);


ALTER TABLE public.students OWNER TO postgres;

--
-- TOC entry 260 (class 1259 OID 26366)
-- Name: subject_schedules; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.subject_schedules (
    "SubjectScheduleID" integer NOT NULL,
    "ClassSubjectID" integer,
    "StartPeriod" integer,
    "EndPeriod" integer,
    "Day" character varying
);


ALTER TABLE public.subject_schedules OWNER TO postgres;

--
-- TOC entry 259 (class 1259 OID 26365)
-- Name: subject_schedules_SubjectScheduleID_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."subject_schedules_SubjectScheduleID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."subject_schedules_SubjectScheduleID_seq" OWNER TO postgres;

--
-- TOC entry 5202 (class 0 OID 0)
-- Dependencies: 259
-- Name: subject_schedules_SubjectScheduleID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."subject_schedules_SubjectScheduleID_seq" OWNED BY public.subject_schedules."SubjectScheduleID";


--
-- TOC entry 224 (class 1259 OID 26011)
-- Name: subjects; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.subjects (
    "SubjectID" integer NOT NULL,
    "SubjectName" character varying,
    "Description" character varying
);


ALTER TABLE public.subjects OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 26010)
-- Name: subjects_SubjectID_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."subjects_SubjectID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."subjects_SubjectID_seq" OWNER TO postgres;

--
-- TOC entry 5203 (class 0 OID 0)
-- Dependencies: 223
-- Name: subjects_SubjectID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."subjects_SubjectID_seq" OWNED BY public.subjects."SubjectID";


--
-- TOC entry 230 (class 1259 OID 26072)
-- Name: teachers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.teachers (
    "TeacherID" integer NOT NULL,
    "DepartmentID" integer,
    "Graduate" character varying,
    "Degree" character varying,
    "Position" character varying
);


ALTER TABLE public.teachers OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 25978)
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    "UserID" integer NOT NULL,
    "FirstName" character varying,
    "LastName" character varying,
    "Street" character varying,
    "District" character varying,
    "City" character varying,
    "Email" character varying,
    "Password" character varying,
    "PhoneNumber" character varying,
    "DOB" timestamp without time zone,
    "PlaceOfBirth" character varying,
    "Gender" public.gender,
    "Address" character varying,
    "CreatedAt" timestamp without time zone,
    "UpdatedAt" timestamp without time zone,
    "Status" public.userstatus,
    role public.userrole
);


ALTER TABLE public.users OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 25977)
-- Name: users_UserID_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."users_UserID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."users_UserID_seq" OWNER TO postgres;

--
-- TOC entry 5204 (class 0 OID 0)
-- Dependencies: 217
-- Name: users_UserID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."users_UserID_seq" OWNED BY public.users."UserID";


--
-- TOC entry 4870 (class 2604 OID 26400)
-- Name: access_permissions AccessID; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.access_permissions ALTER COLUMN "AccessID" SET DEFAULT nextval('public."access_permissions_AccessID_seq"'::regclass);


--
-- TOC entry 4860 (class 2604 OID 26226)
-- Name: class_posts PostID; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.class_posts ALTER COLUMN "PostID" SET DEFAULT nextval('public."class_posts_PostID_seq"'::regclass);


--
-- TOC entry 4859 (class 2604 OID 26201)
-- Name: class_subjects ClassSubjectID; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.class_subjects ALTER COLUMN "ClassSubjectID" SET DEFAULT nextval('public."class_subjects_ClassSubjectID_seq"'::regclass);


--
-- TOC entry 4856 (class 2604 OID 26136)
-- Name: classes ClassID; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.classes ALTER COLUMN "ClassID" SET DEFAULT nextval('public."classes_ClassID_seq"'::regclass);


--
-- TOC entry 4850 (class 2604 OID 25992)
-- Name: conversations ConversationID; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.conversations ALTER COLUMN "ConversationID" SET DEFAULT nextval('public."conversations_ConversationID_seq"'::regclass);


--
-- TOC entry 4867 (class 2604 OID 26349)
-- Name: daily_progress DailyID; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.daily_progress ALTER COLUMN "DailyID" SET DEFAULT nextval('public."daily_progress_DailyID_seq"'::regclass);


--
-- TOC entry 4851 (class 2604 OID 26002)
-- Name: departments DepartmentID; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.departments ALTER COLUMN "DepartmentID" SET DEFAULT nextval('public."departments_DepartmentID_seq"'::regclass);


--
-- TOC entry 4862 (class 2604 OID 26261)
-- Name: event_files FileID; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.event_files ALTER COLUMN "FileID" SET DEFAULT nextval('public."event_files_FileID_seq"'::regclass);


--
-- TOC entry 4855 (class 2604 OID 26120)
-- Name: events EventID; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.events ALTER COLUMN "EventID" SET DEFAULT nextval('public."events_EventID_seq"'::regclass);


--
-- TOC entry 4869 (class 2604 OID 26384)
-- Name: grade_components ComponentID; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grade_components ALTER COLUMN "ComponentID" SET DEFAULT nextval('public."grade_components_ComponentID_seq"'::regclass);


--
-- TOC entry 4864 (class 2604 OID 26294)
-- Name: grades GradeID; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grades ALTER COLUMN "GradeID" SET DEFAULT nextval('public."grades_GradeID_seq"'::regclass);


--
-- TOC entry 4858 (class 2604 OID 26171)
-- Name: message_files FileID; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.message_files ALTER COLUMN "FileID" SET DEFAULT nextval('public."message_files_FileID_seq"'::regclass);


--
-- TOC entry 4853 (class 2604 OID 26026)
-- Name: messages MessageID; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.messages ALTER COLUMN "MessageID" SET DEFAULT nextval('public."messages_MessageID_seq"'::regclass);


--
-- TOC entry 4863 (class 2604 OID 26276)
-- Name: parent_students RelationshipID; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parent_students ALTER COLUMN "RelationshipID" SET DEFAULT nextval('public."parent_students_RelationshipID_seq"'::regclass);


--
-- TOC entry 4854 (class 2604 OID 26046)
-- Name: participations ParticipationID; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.participations ALTER COLUMN "ParticipationID" SET DEFAULT nextval('public."participations_ParticipationID_seq"'::regclass);


--
-- TOC entry 4861 (class 2604 OID 26246)
-- Name: petition_files FileID; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.petition_files ALTER COLUMN "FileID" SET DEFAULT nextval('public."petition_files_FileID_seq"'::regclass);


--
-- TOC entry 4857 (class 2604 OID 26151)
-- Name: petitions PetitionID; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.petitions ALTER COLUMN "PetitionID" SET DEFAULT nextval('public."petitions_PetitionID_seq"'::regclass);


--
-- TOC entry 4866 (class 2604 OID 26334)
-- Name: post_files FileID; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.post_files ALTER COLUMN "FileID" SET DEFAULT nextval('public."post_files_FileID_seq"'::regclass);


--
-- TOC entry 4865 (class 2604 OID 26314)
-- Name: reward_punishments RecordID; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reward_punishments ALTER COLUMN "RecordID" SET DEFAULT nextval('public."reward_punishments_RecordID_seq"'::regclass);


--
-- TOC entry 4868 (class 2604 OID 26369)
-- Name: subject_schedules SubjectScheduleID; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subject_schedules ALTER COLUMN "SubjectScheduleID" SET DEFAULT nextval('public."subject_schedules_SubjectScheduleID_seq"'::regclass);


--
-- TOC entry 4852 (class 2604 OID 26014)
-- Name: subjects SubjectID; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subjects ALTER COLUMN "SubjectID" SET DEFAULT nextval('public."subjects_SubjectID_seq"'::regclass);


--
-- TOC entry 4849 (class 2604 OID 25981)
-- Name: users UserID; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN "UserID" SET DEFAULT nextval('public."users_UserID_seq"'::regclass);


--
-- TOC entry 5177 (class 0 OID 26397)
-- Dependencies: 264
-- Data for Name: access_permissions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.access_permissions ("AccessID", "Name", "Description", "UserID") FROM stdin;
\.


--
-- TOC entry 5142 (class 0 OID 26060)
-- Dependencies: 229
-- Data for Name: administrative_staffs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.administrative_staffs ("AdminID", "Note") FROM stdin;
39	\N
40	\N
41	\N
\.


--
-- TOC entry 5157 (class 0 OID 26223)
-- Dependencies: 244
-- Data for Name: class_posts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.class_posts ("PostID", "Title", "Type", "Content", "EventDate", "CreatedAt", "TeacherID", "ClassID") FROM stdin;
\.


--
-- TOC entry 5155 (class 0 OID 26198)
-- Dependencies: 242
-- Data for Name: class_subjects; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.class_subjects ("ClassSubjectID", "TeacherID", "ClassID", "SubjectID", "Semester", "AcademicYear", "UpdatedAt") FROM stdin;
3	26	2	1	HK1	2023-2024	2025-05-09 15:38:29.971545
4	26	2	2	HK1	2023-2024	2025-05-09 15:38:48.962971
5	28	2	3	HK1	2023-2024	2025-05-09 15:38:59.232668
6	28	2	4	HK1	2023-2024	2025-05-09 15:39:05.401366
7	28	2	5	HK1	2023-2024	2025-05-09 15:39:09.836868
8	28	2	6	HK1	2023-2024	2025-05-09 15:39:17.83572
9	8	2	8	HK1	2022-2023	2025-05-09 16:06:51.880112
10	28	2	3	HK1	2022-2023	2025-05-09 16:15:48.560503
11	26	2	7	HK1	2023-2024	2025-05-10 09:00:25.844248
12	26	2	4	HK1	2022-2023	2025-05-10 09:07:18.666068
13	26	2	9	HK1	2022-2023	2025-05-10 09:09:13.660003
14	26	6	1	HK2	2022-2023	2025-05-10 09:58:14.230657
\.


--
-- TOC entry 5148 (class 0 OID 26133)
-- Dependencies: 235
-- Data for Name: classes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.classes ("ClassID", "ClassName", "GradeLevel", "AcademicYear", "HomeroomTeacherID") FROM stdin;
3	A2	12	22	8
6	A1	11	22	28
2	A1*	12	22	26
11	A1	11	22	44
\.


--
-- TOC entry 5133 (class 0 OID 25989)
-- Dependencies: 220
-- Data for Name: conversations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.conversations ("ConversationID", "CreatedAt", "Name", "NumOfParticipation") FROM stdin;
2	2025-05-08 15:40:16.896488	\N	3
3	2025-05-08 15:54:41.406517	\N	3
4	2025-05-08 19:33:10.739888	Phụ huynh Lớp A1	1
5	2025-05-08 19:33:10.786494	Học sinh Lớp A1	3
1	2025-05-08 11:00:18.399398	HEHE	3
\.


--
-- TOC entry 5171 (class 0 OID 26346)
-- Dependencies: 258
-- Data for Name: daily_progress; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.daily_progress ("DailyID", "Overall", "Attendance", "StudyOutcome", "Reprimand", "Date", "TeacherID", "StudentID") FROM stdin;
\.


--
-- TOC entry 5135 (class 0 OID 25999)
-- Dependencies: 222
-- Data for Name: departments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.departments ("DepartmentID", "DepartmentName", "Description") FROM stdin;
1	BGH	Ban giám hiệu
3	Toán Tin	\N
2	Lý Hóa Sinh	HEHE1
\.


--
-- TOC entry 5161 (class 0 OID 26258)
-- Dependencies: 248
-- Data for Name: event_files; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.event_files ("FileID", "FileName", "FilePath", "FileSize", "ContentType", "SubmittedAt", "EventID") FROM stdin;
\.


--
-- TOC entry 5146 (class 0 OID 26117)
-- Dependencies: 233
-- Data for Name: events; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.events ("EventID", "Title", "Type", "Content", "EventDate", "CreatedAt", "AdminID") FROM stdin;
\.


--
-- TOC entry 5175 (class 0 OID 26381)
-- Dependencies: 262
-- Data for Name: grade_components; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.grade_components ("ComponentID", "ComponentName", "GradeID", "Weight", "Score", "SubmitDate") FROM stdin;
1	Điểm hệ số 1 #1	1	1	\N	2025-05-10 09:07:18.745239
2	Điểm hệ số 1 #2	1	1	\N	2025-05-10 09:07:18.745239
3	Điểm hệ số 1 #3	1	1	\N	2025-05-10 09:07:18.745239
4	Điểm hệ số 2 #1	1	2	\N	2025-05-10 09:07:18.745239
5	Điểm hệ số 2 #2	1	2	\N	2025-05-10 09:07:18.745239
6	Điểm hệ số 3	1	3	\N	2025-05-10 09:07:18.745239
13	Điểm hệ số 1 #1	3	1	\N	2025-05-10 09:07:18.745239
14	Điểm hệ số 1 #2	3	1	\N	2025-05-10 09:07:18.745239
15	Điểm hệ số 1 #3	3	1	\N	2025-05-10 09:07:18.745239
16	Điểm hệ số 2 #1	3	2	\N	2025-05-10 09:07:18.745239
17	Điểm hệ số 2 #2	3	2	\N	2025-05-10 09:07:18.745239
18	Điểm hệ số 3	3	3	\N	2025-05-10 09:07:18.745239
19	Điểm hệ số 1 #1	4	1	\N	2025-05-10 09:07:18.745239
20	Điểm hệ số 1 #2	4	1	\N	2025-05-10 09:07:18.745239
21	Điểm hệ số 1 #3	4	1	\N	2025-05-10 09:07:18.745239
22	Điểm hệ số 2 #1	4	2	\N	2025-05-10 09:07:18.745239
23	Điểm hệ số 2 #2	4	2	\N	2025-05-10 09:07:18.745239
24	Điểm hệ số 3	4	3	\N	2025-05-10 09:07:18.745239
25	Điểm hệ số 1 #1	5	1	\N	2025-05-10 09:07:18.745239
26	Điểm hệ số 1 #2	5	1	\N	2025-05-10 09:07:18.745239
27	Điểm hệ số 1 #3	5	1	\N	2025-05-10 09:07:18.745239
28	Điểm hệ số 2 #1	5	2	\N	2025-05-10 09:07:18.745239
29	Điểm hệ số 2 #2	5	2	\N	2025-05-10 09:07:18.745239
30	Điểm hệ số 3	5	3	\N	2025-05-10 09:07:18.745239
31	Điểm hệ số 1 #1	6	1	\N	2025-05-10 09:09:13.725746
32	Điểm hệ số 1 #2	6	1	\N	2025-05-10 09:09:13.725746
33	Điểm hệ số 1 #3	6	1	\N	2025-05-10 09:09:13.725746
34	Điểm hệ số 2 #1	6	2	\N	2025-05-10 09:09:13.725746
35	Điểm hệ số 2 #2	6	2	\N	2025-05-10 09:09:13.725746
36	Điểm hệ số 3	6	3	\N	2025-05-10 09:09:13.725746
39	Điểm hệ số 1 #3	7	1	\N	2025-05-10 09:09:13.725746
49	Điểm hệ số 1 #1	9	1	\N	2025-05-10 09:09:13.725746
50	Điểm hệ số 1 #2	9	1	\N	2025-05-10 09:09:13.725746
51	Điểm hệ số 1 #3	9	1	\N	2025-05-10 09:09:13.725746
52	Điểm hệ số 2 #1	9	2	\N	2025-05-10 09:09:13.725746
53	Điểm hệ số 2 #2	9	2	\N	2025-05-10 09:09:13.725746
54	Điểm hệ số 3	9	3	\N	2025-05-10 09:09:13.725746
55	Điểm hệ số 1 #1	10	1	\N	2025-05-10 09:09:13.725746
56	Điểm hệ số 1 #2	10	1	\N	2025-05-10 09:09:13.725746
57	Điểm hệ số 1 #3	10	1	\N	2025-05-10 09:09:13.725746
58	Điểm hệ số 2 #1	10	2	\N	2025-05-10 09:09:13.725746
59	Điểm hệ số 2 #2	10	2	\N	2025-05-10 09:09:13.725746
60	Điểm hệ số 3	10	3	\N	2025-05-10 09:09:13.725746
81	Điểm hệ số 1 #3	2	1	\N	2025-05-10 09:30:47.137187
82	Điểm hệ số 2 #1	2	2	\N	2025-05-10 09:30:47.137187
83	Điểm hệ số 2 #2	2	2	\N	2025-05-10 09:30:47.137187
79	Điểm hệ số 1 #1	2	1	10	2025-05-10 09:30:47.137187
80	Điểm hệ số 1 #2	2	1	10	2025-05-10 09:30:47.137187
38	Điểm hệ số 1 #2	7	1	4.5	2025-05-10 09:09:13.725746
84	Điểm hệ số 3	2	3	9.3	2025-05-10 09:30:47.137187
42	Điểm hệ số 3	7	3	10	2025-05-10 09:09:13.725746
40	Điểm hệ số 2 #1	7	2	8	2025-05-10 09:09:13.725746
41	Điểm hệ số 2 #2	7	2	7	2025-05-10 09:09:13.725746
37	Điểm hệ số 1 #1	7	1	6	2025-05-10 09:09:13.725746
43	Điểm hệ số 1 #1	8	1	10	2025-05-10 09:09:13.725746
44	Điểm hệ số 1 #2	8	1	9	2025-05-10 09:09:13.725746
45	Điểm hệ số 1 #3	8	1	8	2025-05-10 09:09:13.725746
48	Điểm hệ số 3	8	3	10	2025-05-10 09:09:13.725746
47	Điểm hệ số 2 #2	8	2	8	2025-05-10 09:09:13.725746
46	Điểm hệ số 2 #1	8	2	8	2025-05-10 09:09:13.725746
\.


--
-- TOC entry 5165 (class 0 OID 26291)
-- Dependencies: 252
-- Data for Name: grades; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.grades ("GradeID", "StudentID", "ClassSubjectID", "FinalScore", "Semester", "UpdatedAt") FROM stdin;
1	1	12	\N	HK1	2025-05-10 09:07:18.69822
3	13	12	\N	HK1	2025-05-10 09:07:18.706638
4	17	12	\N	HK1	2025-05-10 09:07:18.710647
5	16	12	\N	HK1	2025-05-10 09:07:18.713638
6	1	13	\N	HK1	2025-05-10 09:09:13.678218
9	17	13	\N	HK1	2025-05-10 09:09:13.687736
10	16	13	\N	HK1	2025-05-10 09:09:13.69176
2	11	12	9.580000000000002	HK1	2025-05-10 09:35:28.533805
7	11	13	7.833333333333333	HK1	2025-05-10 09:39:18.888271
8	13	13	8.9	HK1	2025-05-10 09:48:53.36096
\.


--
-- TOC entry 5152 (class 0 OID 26168)
-- Dependencies: 239
-- Data for Name: message_files; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.message_files ("FileID", "FileName", "FileSize", "ContentType", "SubmittedAt", "MessageID") FROM stdin;
\.


--
-- TOC entry 5139 (class 0 OID 26023)
-- Dependencies: 226
-- Data for Name: messages; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.messages ("MessageID", "ConversationID", "Content", "SentAt", "UserID") FROM stdin;
1	1	hello	2025-05-08 11:00:22.105128	2
2	1	hello	2025-05-08 11:00:49.150328	1
3	1	ee	2025-05-08 11:01:18.678389	2
4	1	ê	2025-05-08 11:01:25.952567	2
5	1	ê	2025-05-08 11:01:32.554081	2
6	1	ê	2025-05-08 11:01:48.729029	1
7	1	ê	2025-05-08 11:37:50.353447	1
8	2	ê	2025-05-08 15:40:19.396333	3
9	2	ok	2025-05-08 15:41:01.065559	1
10	3	hê	2025-05-08 15:54:45.423447	1
11	3	ê	2025-05-08 15:54:56.904383	3
12	5	hello	2025-05-08 19:39:30.649652	26
13	3	ê	2025-05-09 07:31:48.333925	1
14	3	hello	2025-05-09 07:31:53.352619	1
\.


--
-- TOC entry 5163 (class 0 OID 26273)
-- Dependencies: 250
-- Data for Name: parent_students; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.parent_students ("RelationshipID", "Relationship", "ParentID", "StudentID") FROM stdin;
1	\N	3	10
2	\N	3	1
3	\N	19	1
\.


--
-- TOC entry 5144 (class 0 OID 26089)
-- Dependencies: 231
-- Data for Name: parents; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.parents ("ParentID", "Occupation") FROM stdin;
19	Kỹ sư
23	Bác sĩ
3	12345
\.


--
-- TOC entry 5141 (class 0 OID 26043)
-- Dependencies: 228
-- Data for Name: participations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.participations ("ParticipationID", "ConversationID", "UserID", "JoinedAt") FROM stdin;
1	1	1	2025-05-08 11:00:18.407474
2	1	2	2025-05-08 11:00:18.407474
3	2	1	2025-05-08 15:40:16.910092
4	2	2	2025-05-08 15:40:16.910092
5	2	3	2025-05-08 15:40:16.910092
6	3	1	2025-05-08 15:54:41.417206
7	3	2	2025-05-08 15:54:41.417206
8	3	3	2025-05-08 15:54:41.417206
9	4	26	2025-05-08 19:33:10.753326
10	5	26	2025-05-08 19:33:10.788918
11	5	12	2025-05-08 19:39:00.526233
13	1	3	2025-05-09 08:06:33.814844
\.


--
-- TOC entry 5159 (class 0 OID 26243)
-- Dependencies: 246
-- Data for Name: petition_files; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.petition_files ("FileID", "FileName", "FilePath", "FileSize", "ContentType", "SubmittedAt", "PetitionID") FROM stdin;
\.


--
-- TOC entry 5150 (class 0 OID 26148)
-- Dependencies: 237
-- Data for Name: petitions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.petitions ("PetitionID", "ParentID", "AdminID", "Title", "Content", "Status", "SubmittedAt", "Response") FROM stdin;
\.


--
-- TOC entry 5169 (class 0 OID 26331)
-- Dependencies: 256
-- Data for Name: post_files; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.post_files ("FileID", "FileName", "FilePath", "FileSize", "ContentType", "SubmittedAt", "PostID") FROM stdin;
\.


--
-- TOC entry 5167 (class 0 OID 26311)
-- Dependencies: 254
-- Data for Name: reward_punishments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.reward_punishments ("RecordID", "Title", "Type", "Description", "Date", "Semester", "Week", "StudentID", "AdminID") FROM stdin;
\.


--
-- TOC entry 5153 (class 0 OID 26182)
-- Dependencies: 240
-- Data for Name: students; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.students ("StudentID", "ClassID", "EnrollmentDate", "YtDate") FROM stdin;
1	2	2025-05-07 20:12:30.137971	\N
10	3	\N	\N
11	2	\N	\N
22	\N	2025-05-08 18:36:32.997625	\N
24	\N	2025-05-08 18:36:33.928303	\N
13	2	2025-05-08 18:05:38.511832	\N
12	11	2025-05-08 18:04:04.741486	\N
17	2	2025-05-08 18:36:30.662385	\N
16	2	2025-05-08 18:36:30.162978	\N
\.


--
-- TOC entry 5173 (class 0 OID 26366)
-- Dependencies: 260
-- Data for Name: subject_schedules; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.subject_schedules ("SubjectScheduleID", "ClassSubjectID", "StartPeriod", "EndPeriod", "Day") FROM stdin;
1	3	1	2	Monday
2	4	3	4	Wednesday
3	5	1	3	Tuesday
4	3	8	8	Monday
5	10	9	10	Monday
\.


--
-- TOC entry 5137 (class 0 OID 26011)
-- Dependencies: 224
-- Data for Name: subjects; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.subjects ("SubjectID", "SubjectName", "Description") FROM stdin;
2	Văn	khó
3	Anh	khó
4	Lý	khó
5	Hóa	khó
6	Sinh	khó
7	Tin	khó
1	Toán	khó vch\n
8	Mỹ Thuật	
9	Lịch sử	
\.


--
-- TOC entry 5143 (class 0 OID 26072)
-- Dependencies: 230
-- Data for Name: teachers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.teachers ("TeacherID", "DepartmentID", "Graduate", "Degree", "Position") FROM stdin;
2	\N	\N	\N	\N
26	2	Đại học Sư phạm	ThS	Giáo viên
28	2	Đại học Khoa học	CN	Giáo viên
44	2	Cao đẳng	\N	Trưởng phòng
8	2	123	123	string
29	2	123	\N	Trưởng phòng
\.


--
-- TOC entry 5131 (class 0 OID 25978)
-- Dependencies: 218
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users ("UserID", "FirstName", "LastName", "Street", "District", "City", "Email", "Password", "PhoneNumber", "DOB", "PlaceOfBirth", "Gender", "Address", "CreatedAt", "UpdatedAt", "Status", role) FROM stdin;
23	Lan	Hoàng Thị	\N	\N	\N	lan.ht@example.com	$2b$12$q4Vs9K/CCnO46hIhj1d78u/tA.MLra9MdyCLOBZBzr7sxCZHl.Y3m	0943210987	1980-09-12 00:00:00	\N	FEMALE	222 Đường PQR, Q.GV	2025-05-08 18:36:33.463746	2025-05-08 18:36:33.463746	ACTIVE	parent
24	Minh	Võ Quốc	\N	\N	\N	minh.vq@example.com	$2b$12$JgHv94XNdBKqF7jzxzF8kOFtmgDnj3cmBWcxYLKgHQMOUxuontF5u	0943210987	2005-08-15 00:00:00	\N	MALE	\N	2025-05-08 18:36:33.926803	2025-05-08 18:36:33.926803	ACTIVE	student
28	Hải	Đỗ Minh	\N	\N	\N	hai.dm@example.com	$2b$12$AI9I4T/in7Np4jzs4ubavelll2eXdOsDmjc6UC.e4a62wi1gV9C2.	0965432109	1988-07-19 00:00:00	\N	MALE	987 Đường JKL, Q11	2025-05-08 18:39:26.456712	2025-05-08 18:39:26.456712	ACTIVE	teacher
12	Dat	Phan	\N	\N	\N	3@gmail.com	$2b$12$QxtT5MS15AfmaDejAv607.AWdQAHWC30ISHI4jdIVvWlarkVFoBU.	0366603376	2004-06-01 07:00:00	\N	MALE	Việt Nam 1	2025-05-08 18:04:04.740487	2025-05-08 19:39:00.4826	ACTIVE	student
3	Dat	Phan	\N	\N	\N	parent@gmail.com	$2b$12$P1oPI/6XbjF3CjP2tpHF.OkymVcfm1BerGN3PLhwZJ7KHSe5Px57.	0366603376	\N	\N	\N	Việt Nam 1	2025-05-08 15:39:57.201096	2025-05-08 15:39:57.201096	ACTIVE	parent
9	Dat	Phan	\N	\N	\N	student1@gmail.com	$2b$12$e9rKJtt7V.J0os1NIn1wt.ZAHd2joM22Con917wd4ir8I4gY0WbmC	0366603376	2004-06-01 07:00:00	\N	MALE	\N	2025-05-08 17:35:02.988733	2025-05-08 17:35:02.988733	ACTIVE	student
17	Bình	Trần Thị	\N	\N	\N	binh.tt@example.com	$2b$12$OpSRKMpG1fJYT83Z0hQRyOtM9KmUHSEDI8.LaaU5J6AsR1u9AFNG2	0902345678	2006-01-19 07:00:00	\N	FEMALE	456 Đường XYZ, Q3	2025-05-08 18:36:30.660387	2025-05-08 19:40:02.62161	ACTIVE	student
26	Cường	Lê Văn	\N	\N	\N	cuong.lv@example.com	$2b$12$zIiRtgDmvyP0hc/QoNJUfulSDmaHtswaSYIfNXgR86Vjx2dcpNQdm	0913456789	1990-05-09 07:00:00	\N	MALE	789 Đường KLM, Q5	2025-05-08 18:39:25.487515	2025-05-08 18:51:53.526747	ACTIVE	teacher
11	1	2	\N	\N	\N	1@gmail.com	$2b$12$wJVbn20uvZc6UYt812c0/.SJG302YiLHTsrXqhNPQRSF1aPp5S1TG	0366603376	2004-01-06 07:00:00	\N	MALE	\N	2025-05-08 17:38:13.820871	2025-05-08 18:03:07.533169	ACTIVE	student
10	Cruze	Howes	\N	\N	\N	student2@gmail.com	$2b$12$uShr3H8ykoNAPe7thUvk3.M9j6OUwX04mXfKd.QYB1t8mDwXuSIv6	0366603376	2004-06-01 07:00:00	\N	MALE	\N	2025-05-08 17:35:39.237454	2025-05-08 18:15:48.02324	ACTIVE	student
19	Dung	Phạm Thị	\N	\N	\N	dung.pt@example.com	$2b$12$Gx86FiaH.xtgj.WfIlwaUuVRP/aArN/GUqAMxtFL4PANV1A.U4MNC	0987654321	1985-11-03 00:00:00	\N	FEMALE	321 Đường DEF, Q7	2025-05-08 18:36:31.587925	2025-05-08 18:36:31.587925	ACTIVE	parent
22	Khang	Bùi Chí	\N	\N	\N	khang.bc@example.com	$2b$12$l0X/VNc6oslg37ZMuKjQ4.2ry0YNZqUPGinHlT1Xhf41WG4r55D/K	0954321098	2005-03-22 00:00:00	\N	MALE	111 Đường MNO, Q.TB	2025-05-08 18:36:32.996581	2025-05-08 18:36:32.996581	ACTIVE	student
39	admin	test	\N	\N	\N	admintest@gmail.com	$2b$12$tOf7fKwwglW5ZCusHs3brenezRAJO6Vcau3xEVGb/fgVZZSDopAvy	0976453782	2004-01-01 07:00:00	\N	MALE	Việt Nam	2025-05-09 10:08:09.401636	2025-05-09 10:08:09.401636	ACTIVE	admin
2	Dat	Phan	\N	\N	\N	admin@gmail.com	$2b$12$9DQLCqc..la8sjN6NmLnzezhh8BaA.yBaVnXD7r2NZVV2od5VtL5a	0366603376	2004-06-01 07:00:00	HN	MALE	Việt Nam 1	2025-05-08 11:00:06.127729	2025-05-08 19:03:07.636984	ACTIVE	admin
8	string	string	\N	\N	\N	user@example.com	$2b$12$D7cYmz3m3UZaRl4vsb8cJ.kKY17B/eN6isSn5HS0Q7oJNLFEY5RnK	string	2025-05-08 07:00:00	string	MALE	string	2025-05-08 16:39:54.913415	2025-05-08 19:07:50.57383	ACTIVE	teacher
13	Dat	4	\N	\N	\N	4@gmail.com	$2b$12$yFP/wU3eX1IeFl2Ayx0KoewyQL7aaI.4jlFTt.NHaWCh5SJcP8pH2	0366603376	2004-06-01 07:00:00	\N	MALE	Việt Nam 1	2025-05-08 18:05:38.509832	2025-05-08 19:19:12.518134	ACTIVE	student
40	string	string	\N	\N	\N	admin1@gmail.com	$2b$12$jTZ1cIh3fu3OTvBOE57Ake0jm8XLWkUJqpZanxdsFUFx1cwIp9bsm	string	2025-05-09 17:29:24.47	string	MALE	string	2025-05-09 10:30:08.950166	2025-05-09 10:30:08.950166	ACTIVE	admin
41	Giang	Vũ Thị	\N	\N	\N	giang.vt@example.com	$2b$12$JKfVJUQRe90TvWmXzQGTlOPqeK3e.iZWRIP4izKtZ9H9BYTorv7za	0976543210	1992-02-28 00:00:00	\N	FEMALE	654 Đường GHI, Q10	2025-05-09 10:58:08.969314	2025-05-09 10:58:08.969314	ACTIVE	admin
44	Nam 1	Phan Hữu	\N	\N	\N	nam@example.com	$2b$12$jN7HVYiT/TZTJZEJWYxxZOp30nxy6O9R8ueF3Bys5xU1jelOTi/yO	0943210987	1975-12-01 00:00:00	\N	MALE	333 Đường STU, Q.PN	2025-05-09 11:00:51.954016	2025-05-09 11:00:51.954016	ACTIVE	teacher
29	Nam	Phan Hữu	\N	\N	\N	nam.ph@example.com	$2b$12$TSfECDeEXu.Npnm4NndmF.XMu0.4l4Wf64CLjIy.2PSLZUykO0Rfy	0943210987	1975-11-30 07:00:00	\N	MALE	333 Đường STU, Q.PN	2025-05-08 18:39:26.962891	2025-05-09 11:11:49.52086	ACTIVE	teacher
16	An	Nguyễn Văn	\N	\N	\N	an.nv@example.com	$2b$12$LBVwteKrgLWL79Zrngkf3uogcJfN8.J1eBXR.Rp8WgHGVV8GbXsYm	0901234567	2005-08-14 07:00:00	\N	MALE	123 Đường ABC, Q1	2025-05-08 18:36:30.160978	2025-05-09 16:28:55.989428	ACTIVE	student
1	Dat	Phan	Việt Nam		Hà Nội	phandat01666603376@gmail.com	$2b$12$ZefaGZmy/fHQfktR4vij/O8u1.blC6OMK/6scW9JvqKaldYExgTcG	0366603376	2004-05-30 07:00:00	Phúc Yên	MALE	Việt Nam 1	2025-05-07 20:12:30.130931	2025-05-10 07:34:24.232028	ACTIVE	student
\.


--
-- TOC entry 5205 (class 0 OID 0)
-- Dependencies: 263
-- Name: access_permissions_AccessID_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."access_permissions_AccessID_seq"', 1, false);


--
-- TOC entry 5206 (class 0 OID 0)
-- Dependencies: 243
-- Name: class_posts_PostID_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."class_posts_PostID_seq"', 1, false);


--
-- TOC entry 5207 (class 0 OID 0)
-- Dependencies: 241
-- Name: class_subjects_ClassSubjectID_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."class_subjects_ClassSubjectID_seq"', 14, true);


--
-- TOC entry 5208 (class 0 OID 0)
-- Dependencies: 234
-- Name: classes_ClassID_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."classes_ClassID_seq"', 11, true);


--
-- TOC entry 5209 (class 0 OID 0)
-- Dependencies: 219
-- Name: conversations_ConversationID_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."conversations_ConversationID_seq"', 5, true);


--
-- TOC entry 5210 (class 0 OID 0)
-- Dependencies: 257
-- Name: daily_progress_DailyID_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."daily_progress_DailyID_seq"', 1, false);


--
-- TOC entry 5211 (class 0 OID 0)
-- Dependencies: 221
-- Name: departments_DepartmentID_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."departments_DepartmentID_seq"', 4, true);


--
-- TOC entry 5212 (class 0 OID 0)
-- Dependencies: 247
-- Name: event_files_FileID_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."event_files_FileID_seq"', 1, false);


--
-- TOC entry 5213 (class 0 OID 0)
-- Dependencies: 232
-- Name: events_EventID_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."events_EventID_seq"', 1, false);


--
-- TOC entry 5214 (class 0 OID 0)
-- Dependencies: 261
-- Name: grade_components_ComponentID_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."grade_components_ComponentID_seq"', 84, true);


--
-- TOC entry 5215 (class 0 OID 0)
-- Dependencies: 251
-- Name: grades_GradeID_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."grades_GradeID_seq"', 10, true);


--
-- TOC entry 5216 (class 0 OID 0)
-- Dependencies: 238
-- Name: message_files_FileID_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."message_files_FileID_seq"', 1, false);


--
-- TOC entry 5217 (class 0 OID 0)
-- Dependencies: 225
-- Name: messages_MessageID_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."messages_MessageID_seq"', 14, true);


--
-- TOC entry 5218 (class 0 OID 0)
-- Dependencies: 249
-- Name: parent_students_RelationshipID_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."parent_students_RelationshipID_seq"', 3, true);


--
-- TOC entry 5219 (class 0 OID 0)
-- Dependencies: 227
-- Name: participations_ParticipationID_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."participations_ParticipationID_seq"', 13, true);


--
-- TOC entry 5220 (class 0 OID 0)
-- Dependencies: 245
-- Name: petition_files_FileID_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."petition_files_FileID_seq"', 1, false);


--
-- TOC entry 5221 (class 0 OID 0)
-- Dependencies: 236
-- Name: petitions_PetitionID_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."petitions_PetitionID_seq"', 1, false);


--
-- TOC entry 5222 (class 0 OID 0)
-- Dependencies: 255
-- Name: post_files_FileID_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."post_files_FileID_seq"', 1, false);


--
-- TOC entry 5223 (class 0 OID 0)
-- Dependencies: 253
-- Name: reward_punishments_RecordID_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."reward_punishments_RecordID_seq"', 1, false);


--
-- TOC entry 5224 (class 0 OID 0)
-- Dependencies: 259
-- Name: subject_schedules_SubjectScheduleID_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."subject_schedules_SubjectScheduleID_seq"', 5, true);


--
-- TOC entry 5225 (class 0 OID 0)
-- Dependencies: 223
-- Name: subjects_SubjectID_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."subjects_SubjectID_seq"', 9, true);


--
-- TOC entry 5226 (class 0 OID 0)
-- Dependencies: 217
-- Name: users_UserID_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."users_UserID_seq"', 44, true);


--
-- TOC entry 4949 (class 2606 OID 26404)
-- Name: access_permissions access_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.access_permissions
    ADD CONSTRAINT access_permissions_pkey PRIMARY KEY ("AccessID");


--
-- TOC entry 4895 (class 2606 OID 26066)
-- Name: administrative_staffs administrative_staffs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.administrative_staffs
    ADD CONSTRAINT administrative_staffs_pkey PRIMARY KEY ("AdminID");


--
-- TOC entry 4919 (class 2606 OID 26230)
-- Name: class_posts class_posts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.class_posts
    ADD CONSTRAINT class_posts_pkey PRIMARY KEY ("PostID");


--
-- TOC entry 4916 (class 2606 OID 26205)
-- Name: class_subjects class_subjects_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.class_subjects
    ADD CONSTRAINT class_subjects_pkey PRIMARY KEY ("ClassSubjectID");


--
-- TOC entry 4905 (class 2606 OID 26140)
-- Name: classes classes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.classes
    ADD CONSTRAINT classes_pkey PRIMARY KEY ("ClassID");


--
-- TOC entry 4876 (class 2606 OID 25996)
-- Name: conversations conversations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.conversations
    ADD CONSTRAINT conversations_pkey PRIMARY KEY ("ConversationID");


--
-- TOC entry 4940 (class 2606 OID 26353)
-- Name: daily_progress daily_progress_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.daily_progress
    ADD CONSTRAINT daily_progress_pkey PRIMARY KEY ("DailyID");


--
-- TOC entry 4879 (class 2606 OID 26008)
-- Name: departments departments_DepartmentName_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.departments
    ADD CONSTRAINT "departments_DepartmentName_key" UNIQUE ("DepartmentName");


--
-- TOC entry 4881 (class 2606 OID 26006)
-- Name: departments departments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.departments
    ADD CONSTRAINT departments_pkey PRIMARY KEY ("DepartmentID");


--
-- TOC entry 4925 (class 2606 OID 26265)
-- Name: event_files event_files_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.event_files
    ADD CONSTRAINT event_files_pkey PRIMARY KEY ("FileID");


--
-- TOC entry 4901 (class 2606 OID 26124)
-- Name: events events_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_pkey PRIMARY KEY ("EventID");


--
-- TOC entry 4946 (class 2606 OID 26388)
-- Name: grade_components grade_components_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grade_components
    ADD CONSTRAINT grade_components_pkey PRIMARY KEY ("ComponentID");


--
-- TOC entry 4931 (class 2606 OID 26298)
-- Name: grades grades_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grades
    ADD CONSTRAINT grades_pkey PRIMARY KEY ("GradeID");


--
-- TOC entry 4912 (class 2606 OID 26175)
-- Name: message_files message_files_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.message_files
    ADD CONSTRAINT message_files_pkey PRIMARY KEY ("FileID");


--
-- TOC entry 4890 (class 2606 OID 26030)
-- Name: messages messages_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.messages
    ADD CONSTRAINT messages_pkey PRIMARY KEY ("MessageID");


--
-- TOC entry 4929 (class 2606 OID 26278)
-- Name: parent_students parent_students_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parent_students
    ADD CONSTRAINT parent_students_pkey PRIMARY KEY ("RelationshipID");


--
-- TOC entry 4899 (class 2606 OID 26095)
-- Name: parents parents_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parents
    ADD CONSTRAINT parents_pkey PRIMARY KEY ("ParentID");


--
-- TOC entry 4893 (class 2606 OID 26048)
-- Name: participations participations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.participations
    ADD CONSTRAINT participations_pkey PRIMARY KEY ("ParticipationID");


--
-- TOC entry 4923 (class 2606 OID 26250)
-- Name: petition_files petition_files_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.petition_files
    ADD CONSTRAINT petition_files_pkey PRIMARY KEY ("FileID");


--
-- TOC entry 4909 (class 2606 OID 26155)
-- Name: petitions petitions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.petitions
    ADD CONSTRAINT petitions_pkey PRIMARY KEY ("PetitionID");


--
-- TOC entry 4938 (class 2606 OID 26338)
-- Name: post_files post_files_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.post_files
    ADD CONSTRAINT post_files_pkey PRIMARY KEY ("FileID");


--
-- TOC entry 4935 (class 2606 OID 26318)
-- Name: reward_punishments reward_punishments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reward_punishments
    ADD CONSTRAINT reward_punishments_pkey PRIMARY KEY ("RecordID");


--
-- TOC entry 4914 (class 2606 OID 26186)
-- Name: students students_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.students
    ADD CONSTRAINT students_pkey PRIMARY KEY ("StudentID");


--
-- TOC entry 4944 (class 2606 OID 26373)
-- Name: subject_schedules subject_schedules_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subject_schedules
    ADD CONSTRAINT subject_schedules_pkey PRIMARY KEY ("SubjectScheduleID");


--
-- TOC entry 4885 (class 2606 OID 26020)
-- Name: subjects subjects_SubjectName_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subjects
    ADD CONSTRAINT "subjects_SubjectName_key" UNIQUE ("SubjectName");


--
-- TOC entry 4887 (class 2606 OID 26018)
-- Name: subjects subjects_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subjects
    ADD CONSTRAINT subjects_pkey PRIMARY KEY ("SubjectID");


--
-- TOC entry 4897 (class 2606 OID 26078)
-- Name: teachers teachers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teachers
    ADD CONSTRAINT teachers_pkey PRIMARY KEY ("TeacherID");


--
-- TOC entry 4874 (class 2606 OID 25985)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY ("UserID");


--
-- TOC entry 4950 (class 1259 OID 26410)
-- Name: ix_access_permissions_AccessID; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "ix_access_permissions_AccessID" ON public.access_permissions USING btree ("AccessID");


--
-- TOC entry 4920 (class 1259 OID 26241)
-- Name: ix_class_posts_PostID; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "ix_class_posts_PostID" ON public.class_posts USING btree ("PostID");


--
-- TOC entry 4917 (class 1259 OID 26221)
-- Name: ix_class_subjects_ClassSubjectID; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "ix_class_subjects_ClassSubjectID" ON public.class_subjects USING btree ("ClassSubjectID");


--
-- TOC entry 4906 (class 1259 OID 26146)
-- Name: ix_classes_ClassID; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "ix_classes_ClassID" ON public.classes USING btree ("ClassID");


--
-- TOC entry 4877 (class 1259 OID 25997)
-- Name: ix_conversations_ConversationID; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "ix_conversations_ConversationID" ON public.conversations USING btree ("ConversationID");


--
-- TOC entry 4941 (class 1259 OID 26364)
-- Name: ix_daily_progress_DailyID; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "ix_daily_progress_DailyID" ON public.daily_progress USING btree ("DailyID");


--
-- TOC entry 4882 (class 1259 OID 26009)
-- Name: ix_departments_DepartmentID; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "ix_departments_DepartmentID" ON public.departments USING btree ("DepartmentID");


--
-- TOC entry 4926 (class 1259 OID 26271)
-- Name: ix_event_files_FileID; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "ix_event_files_FileID" ON public.event_files USING btree ("FileID");


--
-- TOC entry 4902 (class 1259 OID 26130)
-- Name: ix_events_EventID; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "ix_events_EventID" ON public.events USING btree ("EventID");


--
-- TOC entry 4903 (class 1259 OID 26131)
-- Name: ix_events_Title; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "ix_events_Title" ON public.events USING btree ("Title");


--
-- TOC entry 4947 (class 1259 OID 26394)
-- Name: ix_grade_components_ComponentID; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "ix_grade_components_ComponentID" ON public.grade_components USING btree ("ComponentID");


--
-- TOC entry 4932 (class 1259 OID 26309)
-- Name: ix_grades_GradeID; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "ix_grades_GradeID" ON public.grades USING btree ("GradeID");


--
-- TOC entry 4910 (class 1259 OID 26181)
-- Name: ix_message_files_FileID; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "ix_message_files_FileID" ON public.message_files USING btree ("FileID");


--
-- TOC entry 4888 (class 1259 OID 26041)
-- Name: ix_messages_MessageID; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "ix_messages_MessageID" ON public.messages USING btree ("MessageID");


--
-- TOC entry 4927 (class 1259 OID 26289)
-- Name: ix_parent_students_RelationshipID; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "ix_parent_students_RelationshipID" ON public.parent_students USING btree ("RelationshipID");


--
-- TOC entry 4891 (class 1259 OID 26059)
-- Name: ix_participations_ParticipationID; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "ix_participations_ParticipationID" ON public.participations USING btree ("ParticipationID");


--
-- TOC entry 4921 (class 1259 OID 26256)
-- Name: ix_petition_files_FileID; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "ix_petition_files_FileID" ON public.petition_files USING btree ("FileID");


--
-- TOC entry 4907 (class 1259 OID 26166)
-- Name: ix_petitions_PetitionID; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "ix_petitions_PetitionID" ON public.petitions USING btree ("PetitionID");


--
-- TOC entry 4936 (class 1259 OID 26344)
-- Name: ix_post_files_FileID; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "ix_post_files_FileID" ON public.post_files USING btree ("FileID");


--
-- TOC entry 4933 (class 1259 OID 26329)
-- Name: ix_reward_punishments_RecordID; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "ix_reward_punishments_RecordID" ON public.reward_punishments USING btree ("RecordID");


--
-- TOC entry 4942 (class 1259 OID 26379)
-- Name: ix_subject_schedules_SubjectScheduleID; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "ix_subject_schedules_SubjectScheduleID" ON public.subject_schedules USING btree ("SubjectScheduleID");


--
-- TOC entry 4883 (class 1259 OID 26021)
-- Name: ix_subjects_SubjectID; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "ix_subjects_SubjectID" ON public.subjects USING btree ("SubjectID");


--
-- TOC entry 4871 (class 1259 OID 25987)
-- Name: ix_users_Email; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "ix_users_Email" ON public.users USING btree ("Email");


--
-- TOC entry 4872 (class 1259 OID 25986)
-- Name: ix_users_UserID; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "ix_users_UserID" ON public.users USING btree ("UserID");


--
-- TOC entry 4984 (class 2606 OID 26405)
-- Name: access_permissions access_permissions_UserID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.access_permissions
    ADD CONSTRAINT "access_permissions_UserID_fkey" FOREIGN KEY ("UserID") REFERENCES public.users("UserID");


--
-- TOC entry 4955 (class 2606 OID 26067)
-- Name: administrative_staffs administrative_staffs_AdminID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.administrative_staffs
    ADD CONSTRAINT "administrative_staffs_AdminID_fkey" FOREIGN KEY ("AdminID") REFERENCES public.users("UserID");


--
-- TOC entry 4969 (class 2606 OID 26236)
-- Name: class_posts class_posts_ClassID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.class_posts
    ADD CONSTRAINT "class_posts_ClassID_fkey" FOREIGN KEY ("ClassID") REFERENCES public.classes("ClassID");


--
-- TOC entry 4970 (class 2606 OID 26231)
-- Name: class_posts class_posts_TeacherID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.class_posts
    ADD CONSTRAINT "class_posts_TeacherID_fkey" FOREIGN KEY ("TeacherID") REFERENCES public.teachers("TeacherID");


--
-- TOC entry 4966 (class 2606 OID 26211)
-- Name: class_subjects class_subjects_ClassID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.class_subjects
    ADD CONSTRAINT "class_subjects_ClassID_fkey" FOREIGN KEY ("ClassID") REFERENCES public.classes("ClassID");


--
-- TOC entry 4967 (class 2606 OID 26216)
-- Name: class_subjects class_subjects_SubjectID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.class_subjects
    ADD CONSTRAINT "class_subjects_SubjectID_fkey" FOREIGN KEY ("SubjectID") REFERENCES public.subjects("SubjectID");


--
-- TOC entry 4968 (class 2606 OID 26206)
-- Name: class_subjects class_subjects_TeacherID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.class_subjects
    ADD CONSTRAINT "class_subjects_TeacherID_fkey" FOREIGN KEY ("TeacherID") REFERENCES public.teachers("TeacherID");


--
-- TOC entry 4960 (class 2606 OID 26141)
-- Name: classes classes_HomeroomTeacherID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.classes
    ADD CONSTRAINT "classes_HomeroomTeacherID_fkey" FOREIGN KEY ("HomeroomTeacherID") REFERENCES public.teachers("TeacherID");


--
-- TOC entry 4980 (class 2606 OID 26359)
-- Name: daily_progress daily_progress_StudentID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.daily_progress
    ADD CONSTRAINT "daily_progress_StudentID_fkey" FOREIGN KEY ("StudentID") REFERENCES public.students("StudentID");


--
-- TOC entry 4981 (class 2606 OID 26354)
-- Name: daily_progress daily_progress_TeacherID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.daily_progress
    ADD CONSTRAINT "daily_progress_TeacherID_fkey" FOREIGN KEY ("TeacherID") REFERENCES public.teachers("TeacherID");


--
-- TOC entry 4972 (class 2606 OID 26266)
-- Name: event_files event_files_EventID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.event_files
    ADD CONSTRAINT "event_files_EventID_fkey" FOREIGN KEY ("EventID") REFERENCES public.events("EventID");


--
-- TOC entry 4959 (class 2606 OID 26125)
-- Name: events events_AdminID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT "events_AdminID_fkey" FOREIGN KEY ("AdminID") REFERENCES public.administrative_staffs("AdminID");


--
-- TOC entry 4983 (class 2606 OID 26389)
-- Name: grade_components grade_components_GradeID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grade_components
    ADD CONSTRAINT "grade_components_GradeID_fkey" FOREIGN KEY ("GradeID") REFERENCES public.grades("GradeID");


--
-- TOC entry 4975 (class 2606 OID 26304)
-- Name: grades grades_ClassSubjectID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grades
    ADD CONSTRAINT "grades_ClassSubjectID_fkey" FOREIGN KEY ("ClassSubjectID") REFERENCES public.class_subjects("ClassSubjectID");


--
-- TOC entry 4976 (class 2606 OID 26299)
-- Name: grades grades_StudentID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grades
    ADD CONSTRAINT "grades_StudentID_fkey" FOREIGN KEY ("StudentID") REFERENCES public.students("StudentID");


--
-- TOC entry 4963 (class 2606 OID 26176)
-- Name: message_files message_files_MessageID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.message_files
    ADD CONSTRAINT "message_files_MessageID_fkey" FOREIGN KEY ("MessageID") REFERENCES public.messages("MessageID");


--
-- TOC entry 4951 (class 2606 OID 26031)
-- Name: messages messages_ConversationID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.messages
    ADD CONSTRAINT "messages_ConversationID_fkey" FOREIGN KEY ("ConversationID") REFERENCES public.conversations("ConversationID");


--
-- TOC entry 4952 (class 2606 OID 26036)
-- Name: messages messages_UserID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.messages
    ADD CONSTRAINT "messages_UserID_fkey" FOREIGN KEY ("UserID") REFERENCES public.users("UserID");


--
-- TOC entry 4973 (class 2606 OID 26279)
-- Name: parent_students parent_students_ParentID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parent_students
    ADD CONSTRAINT "parent_students_ParentID_fkey" FOREIGN KEY ("ParentID") REFERENCES public.parents("ParentID");


--
-- TOC entry 4974 (class 2606 OID 26284)
-- Name: parent_students parent_students_StudentID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parent_students
    ADD CONSTRAINT "parent_students_StudentID_fkey" FOREIGN KEY ("StudentID") REFERENCES public.students("StudentID");


--
-- TOC entry 4958 (class 2606 OID 26096)
-- Name: parents parents_ParentID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parents
    ADD CONSTRAINT "parents_ParentID_fkey" FOREIGN KEY ("ParentID") REFERENCES public.users("UserID");


--
-- TOC entry 4953 (class 2606 OID 26049)
-- Name: participations participations_ConversationID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.participations
    ADD CONSTRAINT "participations_ConversationID_fkey" FOREIGN KEY ("ConversationID") REFERENCES public.conversations("ConversationID");


--
-- TOC entry 4954 (class 2606 OID 26054)
-- Name: participations participations_UserID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.participations
    ADD CONSTRAINT "participations_UserID_fkey" FOREIGN KEY ("UserID") REFERENCES public.users("UserID");


--
-- TOC entry 4971 (class 2606 OID 26251)
-- Name: petition_files petition_files_PetitionID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.petition_files
    ADD CONSTRAINT "petition_files_PetitionID_fkey" FOREIGN KEY ("PetitionID") REFERENCES public.petitions("PetitionID");


--
-- TOC entry 4961 (class 2606 OID 26161)
-- Name: petitions petitions_AdminID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.petitions
    ADD CONSTRAINT "petitions_AdminID_fkey" FOREIGN KEY ("AdminID") REFERENCES public.administrative_staffs("AdminID");


--
-- TOC entry 4962 (class 2606 OID 26156)
-- Name: petitions petitions_ParentID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.petitions
    ADD CONSTRAINT "petitions_ParentID_fkey" FOREIGN KEY ("ParentID") REFERENCES public.parents("ParentID");


--
-- TOC entry 4979 (class 2606 OID 26339)
-- Name: post_files post_files_PostID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.post_files
    ADD CONSTRAINT "post_files_PostID_fkey" FOREIGN KEY ("PostID") REFERENCES public.class_posts("PostID");


--
-- TOC entry 4977 (class 2606 OID 26324)
-- Name: reward_punishments reward_punishments_AdminID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reward_punishments
    ADD CONSTRAINT "reward_punishments_AdminID_fkey" FOREIGN KEY ("AdminID") REFERENCES public.administrative_staffs("AdminID");


--
-- TOC entry 4978 (class 2606 OID 26319)
-- Name: reward_punishments reward_punishments_StudentID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reward_punishments
    ADD CONSTRAINT "reward_punishments_StudentID_fkey" FOREIGN KEY ("StudentID") REFERENCES public.students("StudentID");


--
-- TOC entry 4964 (class 2606 OID 26192)
-- Name: students students_ClassID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.students
    ADD CONSTRAINT "students_ClassID_fkey" FOREIGN KEY ("ClassID") REFERENCES public.classes("ClassID");


--
-- TOC entry 4965 (class 2606 OID 26187)
-- Name: students students_StudentID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.students
    ADD CONSTRAINT "students_StudentID_fkey" FOREIGN KEY ("StudentID") REFERENCES public.users("UserID");


--
-- TOC entry 4982 (class 2606 OID 26374)
-- Name: subject_schedules subject_schedules_ClassSubjectID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subject_schedules
    ADD CONSTRAINT "subject_schedules_ClassSubjectID_fkey" FOREIGN KEY ("ClassSubjectID") REFERENCES public.class_subjects("ClassSubjectID");


--
-- TOC entry 4956 (class 2606 OID 26084)
-- Name: teachers teachers_DepartmentID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teachers
    ADD CONSTRAINT "teachers_DepartmentID_fkey" FOREIGN KEY ("DepartmentID") REFERENCES public.departments("DepartmentID");


--
-- TOC entry 4957 (class 2606 OID 26079)
-- Name: teachers teachers_TeacherID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teachers
    ADD CONSTRAINT "teachers_TeacherID_fkey" FOREIGN KEY ("TeacherID") REFERENCES public.users("UserID");


-- Completed on 2025-05-10 17:28:50

--
-- PostgreSQL database dump complete
--

