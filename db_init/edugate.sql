--
-- PostgreSQL database dump
--

-- Dumped from database version 17.4
-- Dumped by pg_dump version 17.4

-- Started on 2025-05-11 21:29:36

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

--
-- TOC entry 4 (class 2615 OID 2200)
-- Name: public; Type: SCHEMA; Schema: -; Owner: pg_database_owner
--

CREATE SCHEMA public;


ALTER SCHEMA public OWNER TO pg_database_owner;

--
-- TOC entry 5219 (class 0 OID 0)
-- Dependencies: 4
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: pg_database_owner
--

COMMENT ON SCHEMA public IS 'standard public schema';


--
-- TOC entry 893 (class 1247 OID 27356)
-- Name: gender; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.gender AS ENUM (
    'MALE',
    'FEMALE',
    'OTHER'
);


ALTER TYPE public.gender OWNER TO postgres;

--
-- TOC entry 908 (class 1247 OID 27396)
-- Name: petitionstatus; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.petitionstatus AS ENUM (
    'PENDING',
    'APPROVED',
    'REJECTED'
);


ALTER TYPE public.petitionstatus OWNER TO postgres;

--
-- TOC entry 902 (class 1247 OID 27382)
-- Name: relationshiptype; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.relationshiptype AS ENUM (
    'FATHER',
    'MOTHER',
    'GUARDIAN'
);


ALTER TYPE public.relationshiptype OWNER TO postgres;

--
-- TOC entry 905 (class 1247 OID 27390)
-- Name: rnptype; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.rnptype AS ENUM (
    'REWARD',
    'PUNISHMENT'
);


ALTER TYPE public.rnptype OWNER TO postgres;

--
-- TOC entry 899 (class 1247 OID 27372)
-- Name: userrole; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.userrole AS ENUM (
    'admin',
    'teacher',
    'parent',
    'student'
);


ALTER TYPE public.userrole OWNER TO postgres;

--
-- TOC entry 896 (class 1247 OID 27364)
-- Name: userstatus; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.userstatus AS ENUM (
    'ACTIVE',
    'INACTIVE',
    'SUSPENDED'
);


ALTER TYPE public.userstatus OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 233 (class 1259 OID 27528)
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
-- TOC entry 232 (class 1259 OID 27527)
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
-- TOC entry 5220 (class 0 OID 0)
-- Dependencies: 232
-- Name: access_permissions_AccessID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."access_permissions_AccessID_seq" OWNED BY public.access_permissions."AccessID";


--
-- TOC entry 229 (class 1259 OID 27486)
-- Name: administrative_staffs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.administrative_staffs (
    "AdminID" integer NOT NULL,
    "Note" character varying
);


ALTER TABLE public.administrative_staffs OWNER TO postgres;

--
-- TOC entry 246 (class 1259 OID 27649)
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
-- TOC entry 245 (class 1259 OID 27648)
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
-- TOC entry 5221 (class 0 OID 0)
-- Dependencies: 245
-- Name: class_posts_PostID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."class_posts_PostID_seq" OWNED BY public.class_posts."PostID";


--
-- TOC entry 244 (class 1259 OID 27624)
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
-- TOC entry 243 (class 1259 OID 27623)
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
-- TOC entry 5222 (class 0 OID 0)
-- Dependencies: 243
-- Name: class_subjects_ClassSubjectID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."class_subjects_ClassSubjectID_seq" OWNED BY public.class_subjects."ClassSubjectID";


--
-- TOC entry 237 (class 1259 OID 27559)
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
-- TOC entry 236 (class 1259 OID 27558)
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
-- TOC entry 5223 (class 0 OID 0)
-- Dependencies: 236
-- Name: classes_ClassID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."classes_ClassID_seq" OWNED BY public.classes."ClassID";


--
-- TOC entry 220 (class 1259 OID 27415)
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
-- TOC entry 219 (class 1259 OID 27414)
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
-- TOC entry 5224 (class 0 OID 0)
-- Dependencies: 219
-- Name: conversations_ConversationID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."conversations_ConversationID_seq" OWNED BY public.conversations."ConversationID";


--
-- TOC entry 260 (class 1259 OID 27772)
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
-- TOC entry 259 (class 1259 OID 27771)
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
-- TOC entry 5225 (class 0 OID 0)
-- Dependencies: 259
-- Name: daily_progress_DailyID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."daily_progress_DailyID_seq" OWNED BY public.daily_progress."DailyID";


--
-- TOC entry 222 (class 1259 OID 27425)
-- Name: departments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.departments (
    "DepartmentID" integer NOT NULL,
    "DepartmentName" character varying,
    "Description" character varying
);


ALTER TABLE public.departments OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 27424)
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
-- TOC entry 5226 (class 0 OID 0)
-- Dependencies: 221
-- Name: departments_DepartmentID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."departments_DepartmentID_seq" OWNED BY public.departments."DepartmentID";


--
-- TOC entry 250 (class 1259 OID 27684)
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
-- TOC entry 249 (class 1259 OID 27683)
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
-- TOC entry 5227 (class 0 OID 0)
-- Dependencies: 249
-- Name: event_files_FileID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."event_files_FileID_seq" OWNED BY public.event_files."FileID";


--
-- TOC entry 235 (class 1259 OID 27543)
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
-- TOC entry 234 (class 1259 OID 27542)
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
-- TOC entry 5228 (class 0 OID 0)
-- Dependencies: 234
-- Name: events_EventID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."events_EventID_seq" OWNED BY public.events."EventID";


--
-- TOC entry 264 (class 1259 OID 27809)
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
-- TOC entry 263 (class 1259 OID 27808)
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
-- TOC entry 5229 (class 0 OID 0)
-- Dependencies: 263
-- Name: grade_components_ComponentID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."grade_components_ComponentID_seq" OWNED BY public.grade_components."ComponentID";


--
-- TOC entry 254 (class 1259 OID 27717)
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
-- TOC entry 253 (class 1259 OID 27716)
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
-- TOC entry 5230 (class 0 OID 0)
-- Dependencies: 253
-- Name: grades_GradeID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."grades_GradeID_seq" OWNED BY public.grades."GradeID";


--
-- TOC entry 241 (class 1259 OID 27594)
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
-- TOC entry 240 (class 1259 OID 27593)
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
-- TOC entry 5231 (class 0 OID 0)
-- Dependencies: 240
-- Name: message_files_FileID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."message_files_FileID_seq" OWNED BY public.message_files."FileID";


--
-- TOC entry 226 (class 1259 OID 27449)
-- Name: messages; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.messages (
    "MessageID" integer NOT NULL,
    "ConversationID" integer,
    "UserID" integer,
    "Content" character varying,
    "SentAt" timestamp without time zone
);


ALTER TABLE public.messages OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 27448)
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
-- TOC entry 5232 (class 0 OID 0)
-- Dependencies: 225
-- Name: messages_MessageID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."messages_MessageID_seq" OWNED BY public.messages."MessageID";


--
-- TOC entry 252 (class 1259 OID 27699)
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
-- TOC entry 251 (class 1259 OID 27698)
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
-- TOC entry 5233 (class 0 OID 0)
-- Dependencies: 251
-- Name: parent_students_RelationshipID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."parent_students_RelationshipID_seq" OWNED BY public.parent_students."RelationshipID";


--
-- TOC entry 231 (class 1259 OID 27515)
-- Name: parents; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.parents (
    "ParentID" integer NOT NULL,
    "Occupation" character varying
);


ALTER TABLE public.parents OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 27469)
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
-- TOC entry 227 (class 1259 OID 27468)
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
-- TOC entry 5234 (class 0 OID 0)
-- Dependencies: 227
-- Name: participations_ParticipationID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."participations_ParticipationID_seq" OWNED BY public.participations."ParticipationID";


--
-- TOC entry 248 (class 1259 OID 27669)
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
-- TOC entry 247 (class 1259 OID 27668)
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
-- TOC entry 5235 (class 0 OID 0)
-- Dependencies: 247
-- Name: petition_files_FileID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."petition_files_FileID_seq" OWNED BY public.petition_files."FileID";


--
-- TOC entry 239 (class 1259 OID 27574)
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
-- TOC entry 238 (class 1259 OID 27573)
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
-- TOC entry 5236 (class 0 OID 0)
-- Dependencies: 238
-- Name: petitions_PetitionID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."petitions_PetitionID_seq" OWNED BY public.petitions."PetitionID";


--
-- TOC entry 258 (class 1259 OID 27757)
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
-- TOC entry 257 (class 1259 OID 27756)
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
-- TOC entry 5237 (class 0 OID 0)
-- Dependencies: 257
-- Name: post_files_FileID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."post_files_FileID_seq" OWNED BY public.post_files."FileID";


--
-- TOC entry 256 (class 1259 OID 27737)
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
-- TOC entry 255 (class 1259 OID 27736)
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
-- TOC entry 5238 (class 0 OID 0)
-- Dependencies: 255
-- Name: reward_punishments_RecordID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."reward_punishments_RecordID_seq" OWNED BY public.reward_punishments."RecordID";


--
-- TOC entry 242 (class 1259 OID 27608)
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
-- TOC entry 262 (class 1259 OID 27792)
-- Name: subject_schedules; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.subject_schedules (
    "SubjectScheduleID" integer NOT NULL,
    "ClassSubjectID" integer NOT NULL,
    "StartPeriod" integer NOT NULL,
    "EndPeriod" integer NOT NULL,
    "Day" character varying(20) NOT NULL,
    CONSTRAINT check_end_period CHECK ((("EndPeriod" > 0) AND ("EndPeriod" <= 12))),
    CONSTRAINT check_period_order CHECK (("EndPeriod" >= "StartPeriod")),
    CONSTRAINT check_start_period CHECK ((("StartPeriod" > 0) AND ("StartPeriod" <= 12))),
    CONSTRAINT check_valid_day CHECK ((("Day")::text = ANY ((ARRAY['Monday'::character varying, 'Tuesday'::character varying, 'Wednesday'::character varying, 'Thursday'::character varying, 'Friday'::character varying, 'Saturday'::character varying, 'Sunday'::character varying])::text[])))
);


ALTER TABLE public.subject_schedules OWNER TO postgres;

--
-- TOC entry 261 (class 1259 OID 27791)
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
-- TOC entry 5239 (class 0 OID 0)
-- Dependencies: 261
-- Name: subject_schedules_SubjectScheduleID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."subject_schedules_SubjectScheduleID_seq" OWNED BY public.subject_schedules."SubjectScheduleID";


--
-- TOC entry 224 (class 1259 OID 27437)
-- Name: subjects; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.subjects (
    "SubjectID" integer NOT NULL,
    "SubjectName" character varying(255) NOT NULL,
    "Description" text
);


ALTER TABLE public.subjects OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 27436)
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
-- TOC entry 5240 (class 0 OID 0)
-- Dependencies: 223
-- Name: subjects_SubjectID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."subjects_SubjectID_seq" OWNED BY public.subjects."SubjectID";


--
-- TOC entry 230 (class 1259 OID 27498)
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
-- TOC entry 218 (class 1259 OID 27404)
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
-- TOC entry 217 (class 1259 OID 27403)
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
-- TOC entry 5241 (class 0 OID 0)
-- Dependencies: 217
-- Name: users_UserID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."users_UserID_seq" OWNED BY public.users."UserID";


--
-- TOC entry 4887 (class 2604 OID 27531)
-- Name: access_permissions AccessID; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.access_permissions ALTER COLUMN "AccessID" SET DEFAULT nextval('public."access_permissions_AccessID_seq"'::regclass);


--
-- TOC entry 4893 (class 2604 OID 27652)
-- Name: class_posts PostID; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.class_posts ALTER COLUMN "PostID" SET DEFAULT nextval('public."class_posts_PostID_seq"'::regclass);


--
-- TOC entry 4892 (class 2604 OID 27627)
-- Name: class_subjects ClassSubjectID; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.class_subjects ALTER COLUMN "ClassSubjectID" SET DEFAULT nextval('public."class_subjects_ClassSubjectID_seq"'::regclass);


--
-- TOC entry 4889 (class 2604 OID 27562)
-- Name: classes ClassID; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.classes ALTER COLUMN "ClassID" SET DEFAULT nextval('public."classes_ClassID_seq"'::regclass);


--
-- TOC entry 4882 (class 2604 OID 27418)
-- Name: conversations ConversationID; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.conversations ALTER COLUMN "ConversationID" SET DEFAULT nextval('public."conversations_ConversationID_seq"'::regclass);


--
-- TOC entry 4900 (class 2604 OID 27775)
-- Name: daily_progress DailyID; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.daily_progress ALTER COLUMN "DailyID" SET DEFAULT nextval('public."daily_progress_DailyID_seq"'::regclass);


--
-- TOC entry 4883 (class 2604 OID 27428)
-- Name: departments DepartmentID; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.departments ALTER COLUMN "DepartmentID" SET DEFAULT nextval('public."departments_DepartmentID_seq"'::regclass);


--
-- TOC entry 4895 (class 2604 OID 27687)
-- Name: event_files FileID; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.event_files ALTER COLUMN "FileID" SET DEFAULT nextval('public."event_files_FileID_seq"'::regclass);


--
-- TOC entry 4888 (class 2604 OID 27546)
-- Name: events EventID; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.events ALTER COLUMN "EventID" SET DEFAULT nextval('public."events_EventID_seq"'::regclass);


--
-- TOC entry 4902 (class 2604 OID 27812)
-- Name: grade_components ComponentID; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grade_components ALTER COLUMN "ComponentID" SET DEFAULT nextval('public."grade_components_ComponentID_seq"'::regclass);


--
-- TOC entry 4897 (class 2604 OID 27720)
-- Name: grades GradeID; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grades ALTER COLUMN "GradeID" SET DEFAULT nextval('public."grades_GradeID_seq"'::regclass);


--
-- TOC entry 4891 (class 2604 OID 27597)
-- Name: message_files FileID; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.message_files ALTER COLUMN "FileID" SET DEFAULT nextval('public."message_files_FileID_seq"'::regclass);


--
-- TOC entry 4885 (class 2604 OID 27452)
-- Name: messages MessageID; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.messages ALTER COLUMN "MessageID" SET DEFAULT nextval('public."messages_MessageID_seq"'::regclass);


--
-- TOC entry 4896 (class 2604 OID 27702)
-- Name: parent_students RelationshipID; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parent_students ALTER COLUMN "RelationshipID" SET DEFAULT nextval('public."parent_students_RelationshipID_seq"'::regclass);


--
-- TOC entry 4886 (class 2604 OID 27472)
-- Name: participations ParticipationID; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.participations ALTER COLUMN "ParticipationID" SET DEFAULT nextval('public."participations_ParticipationID_seq"'::regclass);


--
-- TOC entry 4894 (class 2604 OID 27672)
-- Name: petition_files FileID; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.petition_files ALTER COLUMN "FileID" SET DEFAULT nextval('public."petition_files_FileID_seq"'::regclass);


--
-- TOC entry 4890 (class 2604 OID 27577)
-- Name: petitions PetitionID; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.petitions ALTER COLUMN "PetitionID" SET DEFAULT nextval('public."petitions_PetitionID_seq"'::regclass);


--
-- TOC entry 4899 (class 2604 OID 27760)
-- Name: post_files FileID; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.post_files ALTER COLUMN "FileID" SET DEFAULT nextval('public."post_files_FileID_seq"'::regclass);


--
-- TOC entry 4898 (class 2604 OID 27740)
-- Name: reward_punishments RecordID; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reward_punishments ALTER COLUMN "RecordID" SET DEFAULT nextval('public."reward_punishments_RecordID_seq"'::regclass);


--
-- TOC entry 4901 (class 2604 OID 27795)
-- Name: subject_schedules SubjectScheduleID; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subject_schedules ALTER COLUMN "SubjectScheduleID" SET DEFAULT nextval('public."subject_schedules_SubjectScheduleID_seq"'::regclass);


--
-- TOC entry 4884 (class 2604 OID 27440)
-- Name: subjects SubjectID; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subjects ALTER COLUMN "SubjectID" SET DEFAULT nextval('public."subjects_SubjectID_seq"'::regclass);


--
-- TOC entry 4881 (class 2604 OID 27407)
-- Name: users UserID; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN "UserID" SET DEFAULT nextval('public."users_UserID_seq"'::regclass);


--
-- TOC entry 5182 (class 0 OID 27528)
-- Dependencies: 233
-- Data for Name: access_permissions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.access_permissions ("AccessID", "Name", "Description", "UserID") FROM stdin;
\.


--
-- TOC entry 5178 (class 0 OID 27486)
-- Dependencies: 229
-- Data for Name: administrative_staffs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.administrative_staffs ("AdminID", "Note") FROM stdin;
1	\N
2	Hiệu trưởng
3	Hiệu phó
\.


--
-- TOC entry 5195 (class 0 OID 27649)
-- Dependencies: 246
-- Data for Name: class_posts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.class_posts ("PostID", "Title", "Type", "Content", "EventDate", "CreatedAt", "TeacherID", "ClassID") FROM stdin;
1	Thông báo về kiểm tra giữa kỳ I môn Toán - Lớp 10A1	Thông báo học tập	Các em học sinh lớp 10A1 chú ý lịch kiểm tra...	\N	2025-03-10 14:00:00	4	1
\.


--
-- TOC entry 5193 (class 0 OID 27624)
-- Dependencies: 244
-- Data for Name: class_subjects; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.class_subjects ("ClassSubjectID", "TeacherID", "ClassID", "SubjectID", "Semester", "AcademicYear", "UpdatedAt") FROM stdin;
20	2	14	1	HK1	2025-2026	2025-05-11 11:52:32.617022
4	2	14	1	HK1	2025-2026	2025-05-11 11:31:26.886758
5	2	14	1	HK1	2024-2025	2025-05-11 11:31:26.886758
6	3	14	2	HK1	2025-2026	2025-05-11 11:31:26.886758
7	2	14	13	HK1	2025-2026	2025-05-11 11:31:26.886758
8	4	14	3	HK1	2025-2026	2025-05-11 11:31:26.886758
9	6	14	4	HK1	2025-2026	2025-05-11 11:31:26.886758
10	5	14	11	HK1	2022-2023	2025-05-11 11:31:26.886758
11	6	14	11	HK1	2025-2026	2025-05-11 11:31:26.886758
12	6	14	7	HK1	2025-2026	2025-05-11 10:59:07.026233
13	7	14	7	HK1	2025-2026	2025-05-11 11:31:26.886758
14	4	14	10	HK1	2025-2026	2025-05-11 11:31:26.886758
15	3	14	9	HK1	2025-2026	2025-05-11 11:31:26.886758
16	3	14	6	HK1	2022-2023	2025-05-11 11:31:26.886758
17	5	14	5	HK1	2025-2026	2025-05-11 11:31:26.886758
18	7	14	3	HK1	2022-2023	2025-05-11 11:31:26.886758
19	3	14	8	HK1	2025-2026	2025-05-11 11:31:26.886758
\.


--
-- TOC entry 5186 (class 0 OID 27559)
-- Dependencies: 237
-- Data for Name: classes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.classes ("ClassID", "ClassName", "GradeLevel", "AcademicYear", "HomeroomTeacherID") FROM stdin;
1	10A1	10	2024-2025	4
2	10A2	10	2024-2025	7
3	11B1	11	2024-2025	5
4	11B2	11	2024-2025	6
6	12C2	12	2024-2025	7
14	12A1	12	2024-2025	2
\.


--
-- TOC entry 5169 (class 0 OID 27415)
-- Dependencies: 220
-- Data for Name: conversations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.conversations ("ConversationID", "CreatedAt", "Name", "NumOfParticipation") FROM stdin;
1	2025-01-20 10:00:00	Trao đổi về tình hình học tập của em An - Lớp 10A1	2
15	2025-05-11 11:41:46.18644	Học sinh Lớp 12A1	47
16	2025-05-11 11:41:46.214052	Phụ huynh Lớp 12A1	5
\.


--
-- TOC entry 5209 (class 0 OID 27772)
-- Dependencies: 260
-- Data for Name: daily_progress; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.daily_progress ("DailyID", "Overall", "Attendance", "StudyOutcome", "Reprimand", "Date", "TeacherID", "StudentID") FROM stdin;
1	Không có nhận xét thêm	điểm danh dầy đủ	Tốt	tốt	2025-05-11	2	16
\.


--
-- TOC entry 5171 (class 0 OID 27425)
-- Dependencies: 222
-- Data for Name: departments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.departments ("DepartmentID", "DepartmentName", "Description") FROM stdin;
2	Tổ Toán - Tin	Phụ trách giảng dạy các môn Toán và Tin học
3	Tổ Ngữ Văn	Phụ trách giảng dạy môn Ngữ Văn
4	Tổ Ngoại Ngữ	Phụ trách giảng dạy các môn Ngoại ngữ (Tiếng Anh, etc.)
5	Tổ Vật Lý - Công Nghệ	Phụ trách giảng dạy môn Vật Lý và Công Nghệ
6	Tổ Hóa Học	Phụ trách giảng dạy môn Hóa Học
7	Tổ Sinh Học	Phụ trách giảng dạy môn Sinh Học
8	Tổ Lịch Sử - Địa Lý - GDCD	Phụ trách giảng dạy Lịch Sử, Địa Lý, GDCD
9	Tổ Thể dục - GDQPAN	Phụ trách giảng dạy Thể dục và Giáo dục Quốc phòng An ninh
1	BGH	Quản lý chung nhà trường và các hoạt động giáo dục
\.


--
-- TOC entry 5199 (class 0 OID 27684)
-- Dependencies: 250
-- Data for Name: event_files; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.event_files ("FileID", "FileName", "FilePath", "FileSize", "ContentType", "SubmittedAt", "EventID") FROM stdin;
1	edugate_final.sql	uploads/events/492d3376-b656-4f0d-9e4c-5d3489810d15_edugate_final.sql	78555	application/octet-stream	2025-05-11 10:09:55.621576	1
2	133835077711522965.jpg	uploads/events/cf9a19f8-ccde-481a-90a1-7644104904e6_133835077711522965.jpg	1706128	image/jpeg	2025-05-11 11:11:38.560447	3
3	133831497777748945.jpg	uploads/events/0f8a9ea4-8d2a-4111-a5bd-c8f8b73434e6_133831497777748945.jpg	1569673	image/jpeg	2025-05-11 11:11:48.058043	4
4	133884266866120611.jpg	uploads/events/d8f151ba-0256-4110-8660-e273c7d36898_133884266866120611.jpg	2284918	image/jpeg	2025-05-11 11:11:55.186834	2
\.


--
-- TOC entry 5184 (class 0 OID 27543)
-- Dependencies: 235
-- Data for Name: events; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.events ("EventID", "Title", "Type", "Content", "EventDate", "CreatedAt", "AdminID") FROM stdin;
1	Lễ Khai Giảng Năm Học 2024-2025	Thông báo chung	Thông báo về Lễ Khai Giảng năm học 2024-2025...	2024-09-05 07:30:00	2024-08-20 09:00:00	2
2	Chào mừng năm học mới	activity	Chúc mừng năm học mới 2025-2026	2025-05-11 17:10:06.653	2025-05-11 10:10:40.540698	1
3	Nghỉ lễ 2/9	school	Nghỉ lễ cho toàn trường ngày 02/09/2025	2025-05-11 18:10:38.901	2025-05-11 11:11:06.911193	1
4	Test 123	competition		2025-05-11 18:11:14.858	2025-05-11 11:11:22.961123	1
\.


--
-- TOC entry 5213 (class 0 OID 27809)
-- Dependencies: 264
-- Data for Name: grade_components; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.grade_components ("ComponentID", "ComponentName", "GradeID", "Weight", "Score", "SubmitDate") FROM stdin;
11	Điểm hệ số 1 #1	2	1	\N	2025-05-11 10:35:25.233184
12	Điểm hệ số 1 #2	2	1	\N	2025-05-11 10:35:25.233184
13	Điểm hệ số 1 #3	2	1	\N	2025-05-11 10:35:25.233184
14	Điểm hệ số 2 #1	2	2	\N	2025-05-11 10:35:25.233184
15	Điểm hệ số 2 #2	2	2	\N	2025-05-11 10:35:25.233184
16	Điểm hệ số 3	2	3	\N	2025-05-11 10:35:25.233184
17	Điểm hệ số 1 #1	3	1	\N	2025-05-11 10:38:05.686051
18	Điểm hệ số 1 #2	3	1	\N	2025-05-11 10:38:05.686051
19	Điểm hệ số 1 #3	3	1	\N	2025-05-11 10:38:05.686051
20	Điểm hệ số 2 #1	3	2	\N	2025-05-11 10:38:05.686051
21	Điểm hệ số 2 #2	3	2	\N	2025-05-11 10:38:05.686051
22	Điểm hệ số 3	3	3	\N	2025-05-11 10:38:05.686051
23	Điểm hệ số 1 #1	4	1	\N	2025-05-11 10:52:46.215096
24	Điểm hệ số 1 #2	4	1	\N	2025-05-11 10:52:46.215096
25	Điểm hệ số 1 #3	4	1	\N	2025-05-11 10:52:46.215096
26	Điểm hệ số 2 #1	4	2	\N	2025-05-11 10:52:46.215096
27	Điểm hệ số 2 #2	4	2	\N	2025-05-11 10:52:46.215096
28	Điểm hệ số 3	4	3	\N	2025-05-11 10:52:46.215096
29	Điểm hệ số 1 #1	5	1	\N	2025-05-11 10:54:09.989957
30	Điểm hệ số 1 #2	5	1	\N	2025-05-11 10:54:09.989957
31	Điểm hệ số 1 #3	5	1	\N	2025-05-11 10:54:09.989957
32	Điểm hệ số 2 #1	5	2	\N	2025-05-11 10:54:09.989957
33	Điểm hệ số 2 #2	5	2	\N	2025-05-11 10:54:09.989957
34	Điểm hệ số 3	5	3	\N	2025-05-11 10:54:09.989957
35	Điểm hệ số 1 #1	6	1	\N	2025-05-11 10:56:50.766224
36	Điểm hệ số 1 #2	6	1	\N	2025-05-11 10:56:50.766224
37	Điểm hệ số 1 #3	6	1	\N	2025-05-11 10:56:50.766224
38	Điểm hệ số 2 #1	6	2	\N	2025-05-11 10:56:50.766224
39	Điểm hệ số 2 #2	6	2	\N	2025-05-11 10:56:50.766224
40	Điểm hệ số 3	6	3	\N	2025-05-11 10:56:50.766224
41	Điểm hệ số 1 #1	7	1	\N	2025-05-11 10:57:41.33224
42	Điểm hệ số 1 #2	7	1	\N	2025-05-11 10:57:41.33224
43	Điểm hệ số 1 #3	7	1	\N	2025-05-11 10:57:41.33224
44	Điểm hệ số 2 #1	7	2	\N	2025-05-11 10:57:41.33224
45	Điểm hệ số 2 #2	7	2	\N	2025-05-11 10:57:41.33224
46	Điểm hệ số 3	7	3	\N	2025-05-11 10:57:41.33224
47	Điểm hệ số 1 #1	8	1	\N	2025-05-11 10:58:22.328098
48	Điểm hệ số 1 #2	8	1	\N	2025-05-11 10:58:22.328098
49	Điểm hệ số 1 #3	8	1	\N	2025-05-11 10:58:22.328098
50	Điểm hệ số 2 #1	8	2	\N	2025-05-11 10:58:22.328098
51	Điểm hệ số 2 #2	8	2	\N	2025-05-11 10:58:22.328098
52	Điểm hệ số 3	8	3	\N	2025-05-11 10:58:22.328098
53	Điểm hệ số 1 #1	9	1	\N	2025-05-11 10:59:07.064275
54	Điểm hệ số 1 #2	9	1	\N	2025-05-11 10:59:07.064275
55	Điểm hệ số 1 #3	9	1	\N	2025-05-11 10:59:07.064275
56	Điểm hệ số 2 #1	9	2	\N	2025-05-11 10:59:07.064275
57	Điểm hệ số 2 #2	9	2	\N	2025-05-11 10:59:07.064275
58	Điểm hệ số 3	9	3	\N	2025-05-11 10:59:07.064275
59	Điểm hệ số 1 #1	10	1	\N	2025-05-11 10:59:07.064275
60	Điểm hệ số 1 #2	10	1	\N	2025-05-11 10:59:07.064275
61	Điểm hệ số 1 #3	10	1	\N	2025-05-11 10:59:07.064275
62	Điểm hệ số 2 #1	10	2	\N	2025-05-11 10:59:07.064275
63	Điểm hệ số 2 #2	10	2	\N	2025-05-11 10:59:07.064275
64	Điểm hệ số 3	10	3	\N	2025-05-11 10:59:07.064275
65	Điểm hệ số 1 #1	11	1	\N	2025-05-11 10:59:56.793029
66	Điểm hệ số 1 #2	11	1	\N	2025-05-11 10:59:56.793029
67	Điểm hệ số 1 #3	11	1	\N	2025-05-11 10:59:56.793029
68	Điểm hệ số 2 #1	11	2	\N	2025-05-11 10:59:56.793029
69	Điểm hệ số 2 #2	11	2	\N	2025-05-11 10:59:56.793029
70	Điểm hệ số 3	11	3	\N	2025-05-11 10:59:56.793029
71	Điểm hệ số 1 #1	12	1	\N	2025-05-11 11:01:20.57516
72	Điểm hệ số 1 #2	12	1	\N	2025-05-11 11:01:20.57516
73	Điểm hệ số 1 #3	12	1	\N	2025-05-11 11:01:20.57516
74	Điểm hệ số 2 #1	12	2	\N	2025-05-11 11:01:20.57516
75	Điểm hệ số 2 #2	12	2	\N	2025-05-11 11:01:20.57516
76	Điểm hệ số 3	12	3	\N	2025-05-11 11:01:20.57516
77	Điểm hệ số 1 #1	13	1	\N	2025-05-11 11:02:07.765939
78	Điểm hệ số 1 #2	13	1	\N	2025-05-11 11:02:07.765939
79	Điểm hệ số 1 #3	13	1	\N	2025-05-11 11:02:07.765939
80	Điểm hệ số 2 #1	13	2	\N	2025-05-11 11:02:07.765939
81	Điểm hệ số 2 #2	13	2	\N	2025-05-11 11:02:07.765939
82	Điểm hệ số 3	13	3	\N	2025-05-11 11:02:07.765939
83	Điểm hệ số 1 #1	14	1	\N	2025-05-11 11:02:36.406898
84	Điểm hệ số 1 #2	14	1	\N	2025-05-11 11:02:36.406898
85	Điểm hệ số 1 #3	14	1	\N	2025-05-11 11:02:36.406898
86	Điểm hệ số 2 #1	14	2	\N	2025-05-11 11:02:36.406898
87	Điểm hệ số 2 #2	14	2	\N	2025-05-11 11:02:36.406898
88	Điểm hệ số 3	14	3	\N	2025-05-11 11:02:36.406898
89	Điểm hệ số 1 #1	15	1	\N	2025-05-11 11:03:24.319126
90	Điểm hệ số 1 #2	15	1	\N	2025-05-11 11:03:24.319126
91	Điểm hệ số 1 #3	15	1	\N	2025-05-11 11:03:24.319126
92	Điểm hệ số 2 #1	15	2	\N	2025-05-11 11:03:24.319126
93	Điểm hệ số 2 #2	15	2	\N	2025-05-11 11:03:24.319126
94	Điểm hệ số 3	15	3	\N	2025-05-11 11:03:24.319126
95	Điểm hệ số 1 #1	16	1	\N	2025-05-11 11:05:29.475904
96	Điểm hệ số 1 #2	16	1	\N	2025-05-11 11:05:29.475904
97	Điểm hệ số 1 #3	16	1	\N	2025-05-11 11:05:29.475904
98	Điểm hệ số 2 #1	16	2	\N	2025-05-11 11:05:29.475904
99	Điểm hệ số 2 #2	16	2	\N	2025-05-11 11:05:29.475904
100	Điểm hệ số 3	16	3	\N	2025-05-11 11:05:29.475904
101	Điểm hệ số 1 #1	17	1	\N	2025-05-11 11:06:49.140967
102	Điểm hệ số 1 #2	17	1	\N	2025-05-11 11:06:49.140967
103	Điểm hệ số 1 #3	17	1	\N	2025-05-11 11:06:49.140967
104	Điểm hệ số 2 #1	17	2	\N	2025-05-11 11:06:49.140967
105	Điểm hệ số 2 #2	17	2	\N	2025-05-11 11:06:49.140967
106	Điểm hệ số 3	17	3	\N	2025-05-11 11:06:49.140967
10	Điểm hệ số 3	1	3	10	2025-05-11 10:34:49.682298
8	Điểm hệ số 2 #1	1	2	9.5	2025-05-11 10:34:49.682298
9	Điểm hệ số 2 #2	1	2	9	2025-05-11 10:34:49.682298
5	Điểm hệ số 1 #1	1	1	9.6	2025-05-11 10:34:49.682298
6	Điểm hệ số 1 #2	1	1	10	2025-05-11 10:34:49.682298
7	Điểm hệ số 1 #3	1	1	9.4	2025-05-11 10:34:49.682298
107	Điểm hệ số 1 #1	18	1	\N	2025-05-11 11:52:32.997459
108	Điểm hệ số 1 #2	18	1	\N	2025-05-11 11:52:32.997459
109	Điểm hệ số 1 #3	18	1	\N	2025-05-11 11:52:32.997459
110	Điểm hệ số 2 #1	18	2	\N	2025-05-11 11:52:32.997459
111	Điểm hệ số 2 #2	18	2	\N	2025-05-11 11:52:32.997459
112	Điểm hệ số 3	18	3	\N	2025-05-11 11:52:32.997459
113	Điểm hệ số 1 #1	19	1	\N	2025-05-11 11:52:32.997459
114	Điểm hệ số 1 #2	19	1	\N	2025-05-11 11:52:32.997459
115	Điểm hệ số 1 #3	19	1	\N	2025-05-11 11:52:32.997459
116	Điểm hệ số 2 #1	19	2	\N	2025-05-11 11:52:32.997459
117	Điểm hệ số 2 #2	19	2	\N	2025-05-11 11:52:32.997459
118	Điểm hệ số 3	19	3	\N	2025-05-11 11:52:32.997459
119	Điểm hệ số 1 #1	20	1	\N	2025-05-11 11:52:32.997459
120	Điểm hệ số 1 #2	20	1	\N	2025-05-11 11:52:32.997459
121	Điểm hệ số 1 #3	20	1	\N	2025-05-11 11:52:32.997459
122	Điểm hệ số 2 #1	20	2	\N	2025-05-11 11:52:32.997459
123	Điểm hệ số 2 #2	20	2	\N	2025-05-11 11:52:32.997459
124	Điểm hệ số 3	20	3	\N	2025-05-11 11:52:32.997459
125	Điểm hệ số 1 #1	21	1	\N	2025-05-11 11:52:32.997459
126	Điểm hệ số 1 #2	21	1	\N	2025-05-11 11:52:32.997459
127	Điểm hệ số 1 #3	21	1	\N	2025-05-11 11:52:32.997459
128	Điểm hệ số 2 #1	21	2	\N	2025-05-11 11:52:32.997459
129	Điểm hệ số 2 #2	21	2	\N	2025-05-11 11:52:32.997459
130	Điểm hệ số 3	21	3	\N	2025-05-11 11:52:32.997459
131	Điểm hệ số 1 #1	22	1	\N	2025-05-11 11:52:32.997459
132	Điểm hệ số 1 #2	22	1	\N	2025-05-11 11:52:32.997459
133	Điểm hệ số 1 #3	22	1	\N	2025-05-11 11:52:32.997459
134	Điểm hệ số 2 #1	22	2	\N	2025-05-11 11:52:32.997459
135	Điểm hệ số 2 #2	22	2	\N	2025-05-11 11:52:32.997459
136	Điểm hệ số 3	22	3	\N	2025-05-11 11:52:32.997459
137	Điểm hệ số 1 #1	23	1	\N	2025-05-11 11:52:32.997459
138	Điểm hệ số 1 #2	23	1	\N	2025-05-11 11:52:32.997459
139	Điểm hệ số 1 #3	23	1	\N	2025-05-11 11:52:32.997459
140	Điểm hệ số 2 #1	23	2	\N	2025-05-11 11:52:32.997459
141	Điểm hệ số 2 #2	23	2	\N	2025-05-11 11:52:32.997459
142	Điểm hệ số 3	23	3	\N	2025-05-11 11:52:32.997459
143	Điểm hệ số 1 #1	24	1	\N	2025-05-11 11:52:32.997459
144	Điểm hệ số 1 #2	24	1	\N	2025-05-11 11:52:32.997459
145	Điểm hệ số 1 #3	24	1	\N	2025-05-11 11:52:32.997459
146	Điểm hệ số 2 #1	24	2	\N	2025-05-11 11:52:32.997459
147	Điểm hệ số 2 #2	24	2	\N	2025-05-11 11:52:32.997459
148	Điểm hệ số 3	24	3	\N	2025-05-11 11:52:32.997459
149	Điểm hệ số 1 #1	25	1	\N	2025-05-11 11:52:32.997459
150	Điểm hệ số 1 #2	25	1	\N	2025-05-11 11:52:32.997459
151	Điểm hệ số 1 #3	25	1	\N	2025-05-11 11:52:32.997459
152	Điểm hệ số 2 #1	25	2	\N	2025-05-11 11:52:32.997459
153	Điểm hệ số 2 #2	25	2	\N	2025-05-11 11:52:32.997459
154	Điểm hệ số 3	25	3	\N	2025-05-11 11:52:32.997459
155	Điểm hệ số 1 #1	26	1	\N	2025-05-11 11:52:32.997459
156	Điểm hệ số 1 #2	26	1	\N	2025-05-11 11:52:32.997459
157	Điểm hệ số 1 #3	26	1	\N	2025-05-11 11:52:32.997459
158	Điểm hệ số 2 #1	26	2	\N	2025-05-11 11:52:32.997459
159	Điểm hệ số 2 #2	26	2	\N	2025-05-11 11:52:32.997459
160	Điểm hệ số 3	26	3	\N	2025-05-11 11:52:32.997459
161	Điểm hệ số 1 #1	27	1	\N	2025-05-11 11:52:32.997459
162	Điểm hệ số 1 #2	27	1	\N	2025-05-11 11:52:32.997459
163	Điểm hệ số 1 #3	27	1	\N	2025-05-11 11:52:32.997459
164	Điểm hệ số 2 #1	27	2	\N	2025-05-11 11:52:32.997459
165	Điểm hệ số 2 #2	27	2	\N	2025-05-11 11:52:32.997459
166	Điểm hệ số 3	27	3	\N	2025-05-11 11:52:32.997459
173	Điểm hệ số 1 #1	29	1	\N	2025-05-11 11:52:32.997459
174	Điểm hệ số 1 #2	29	1	\N	2025-05-11 11:52:32.997459
175	Điểm hệ số 1 #3	29	1	\N	2025-05-11 11:52:32.997459
176	Điểm hệ số 2 #1	29	2	\N	2025-05-11 11:52:32.997459
177	Điểm hệ số 2 #2	29	2	\N	2025-05-11 11:52:32.997459
178	Điểm hệ số 3	29	3	\N	2025-05-11 11:52:32.997459
179	Điểm hệ số 1 #1	30	1	\N	2025-05-11 11:52:32.997459
180	Điểm hệ số 1 #2	30	1	\N	2025-05-11 11:52:32.997459
181	Điểm hệ số 1 #3	30	1	\N	2025-05-11 11:52:32.997459
182	Điểm hệ số 2 #1	30	2	\N	2025-05-11 11:52:32.997459
183	Điểm hệ số 2 #2	30	2	\N	2025-05-11 11:52:32.997459
184	Điểm hệ số 3	30	3	\N	2025-05-11 11:52:32.997459
185	Điểm hệ số 1 #1	31	1	\N	2025-05-11 11:52:32.997459
186	Điểm hệ số 1 #2	31	1	\N	2025-05-11 11:52:32.997459
187	Điểm hệ số 1 #3	31	1	\N	2025-05-11 11:52:32.997459
188	Điểm hệ số 2 #1	31	2	\N	2025-05-11 11:52:32.997459
189	Điểm hệ số 2 #2	31	2	\N	2025-05-11 11:52:32.997459
190	Điểm hệ số 3	31	3	\N	2025-05-11 11:52:32.997459
191	Điểm hệ số 1 #1	32	1	\N	2025-05-11 11:52:32.997459
192	Điểm hệ số 1 #2	32	1	\N	2025-05-11 11:52:32.997459
193	Điểm hệ số 1 #3	32	1	\N	2025-05-11 11:52:32.997459
194	Điểm hệ số 2 #1	32	2	\N	2025-05-11 11:52:32.997459
195	Điểm hệ số 2 #2	32	2	\N	2025-05-11 11:52:32.997459
196	Điểm hệ số 3	32	3	\N	2025-05-11 11:52:32.997459
197	Điểm hệ số 1 #1	33	1	\N	2025-05-11 11:52:32.997459
198	Điểm hệ số 1 #2	33	1	\N	2025-05-11 11:52:32.997459
199	Điểm hệ số 1 #3	33	1	\N	2025-05-11 11:52:32.997459
200	Điểm hệ số 2 #1	33	2	\N	2025-05-11 11:52:32.997459
201	Điểm hệ số 2 #2	33	2	\N	2025-05-11 11:52:32.997459
202	Điểm hệ số 3	33	3	\N	2025-05-11 11:52:32.997459
203	Điểm hệ số 1 #1	34	1	\N	2025-05-11 11:52:32.997459
204	Điểm hệ số 1 #2	34	1	\N	2025-05-11 11:52:32.997459
205	Điểm hệ số 1 #3	34	1	\N	2025-05-11 11:52:32.997459
206	Điểm hệ số 2 #1	34	2	\N	2025-05-11 11:52:32.997459
207	Điểm hệ số 2 #2	34	2	\N	2025-05-11 11:52:32.997459
208	Điểm hệ số 3	34	3	\N	2025-05-11 11:52:32.997459
209	Điểm hệ số 1 #1	35	1	\N	2025-05-11 11:52:32.997459
210	Điểm hệ số 1 #2	35	1	\N	2025-05-11 11:52:32.997459
211	Điểm hệ số 1 #3	35	1	\N	2025-05-11 11:52:32.997459
212	Điểm hệ số 2 #1	35	2	\N	2025-05-11 11:52:32.997459
213	Điểm hệ số 2 #2	35	2	\N	2025-05-11 11:52:32.997459
214	Điểm hệ số 3	35	3	\N	2025-05-11 11:52:32.997459
215	Điểm hệ số 1 #1	36	1	\N	2025-05-11 11:52:32.997459
216	Điểm hệ số 1 #2	36	1	\N	2025-05-11 11:52:32.997459
217	Điểm hệ số 1 #3	36	1	\N	2025-05-11 11:52:32.997459
170	Điểm hệ số 2 #1	28	2	8	2025-05-11 11:52:32.997459
171	Điểm hệ số 2 #2	28	2	8	2025-05-11 11:52:32.997459
167	Điểm hệ số 1 #1	28	1	8	2025-05-11 11:52:32.997459
169	Điểm hệ số 1 #3	28	1	8	2025-05-11 11:52:32.997459
218	Điểm hệ số 2 #1	36	2	\N	2025-05-11 11:52:32.997459
219	Điểm hệ số 2 #2	36	2	\N	2025-05-11 11:52:32.997459
220	Điểm hệ số 3	36	3	\N	2025-05-11 11:52:32.997459
221	Điểm hệ số 1 #1	37	1	\N	2025-05-11 11:52:32.997459
222	Điểm hệ số 1 #2	37	1	\N	2025-05-11 11:52:32.997459
223	Điểm hệ số 1 #3	37	1	\N	2025-05-11 11:52:32.997459
224	Điểm hệ số 2 #1	37	2	\N	2025-05-11 11:52:32.997459
225	Điểm hệ số 2 #2	37	2	\N	2025-05-11 11:52:32.997459
226	Điểm hệ số 3	37	3	\N	2025-05-11 11:52:32.997459
227	Điểm hệ số 1 #1	38	1	\N	2025-05-11 11:52:32.997459
228	Điểm hệ số 1 #2	38	1	\N	2025-05-11 11:52:32.997459
229	Điểm hệ số 1 #3	38	1	\N	2025-05-11 11:52:32.997459
230	Điểm hệ số 2 #1	38	2	\N	2025-05-11 11:52:32.997459
231	Điểm hệ số 2 #2	38	2	\N	2025-05-11 11:52:32.997459
232	Điểm hệ số 3	38	3	\N	2025-05-11 11:52:32.997459
233	Điểm hệ số 1 #1	39	1	\N	2025-05-11 11:52:32.997459
234	Điểm hệ số 1 #2	39	1	\N	2025-05-11 11:52:32.997459
235	Điểm hệ số 1 #3	39	1	\N	2025-05-11 11:52:32.997459
236	Điểm hệ số 2 #1	39	2	\N	2025-05-11 11:52:32.997459
237	Điểm hệ số 2 #2	39	2	\N	2025-05-11 11:52:32.997459
238	Điểm hệ số 3	39	3	\N	2025-05-11 11:52:32.997459
245	Điểm hệ số 1 #1	41	1	\N	2025-05-11 11:52:32.997459
246	Điểm hệ số 1 #2	41	1	\N	2025-05-11 11:52:32.997459
247	Điểm hệ số 1 #3	41	1	\N	2025-05-11 11:52:32.997459
248	Điểm hệ số 2 #1	41	2	\N	2025-05-11 11:52:32.997459
249	Điểm hệ số 2 #2	41	2	\N	2025-05-11 11:52:32.997459
250	Điểm hệ số 3	41	3	\N	2025-05-11 11:52:32.997459
251	Điểm hệ số 1 #1	42	1	\N	2025-05-11 11:52:32.997459
252	Điểm hệ số 1 #2	42	1	\N	2025-05-11 11:52:32.997459
253	Điểm hệ số 1 #3	42	1	\N	2025-05-11 11:52:32.997459
254	Điểm hệ số 2 #1	42	2	\N	2025-05-11 11:52:32.997459
255	Điểm hệ số 2 #2	42	2	\N	2025-05-11 11:52:32.997459
256	Điểm hệ số 3	42	3	\N	2025-05-11 11:52:32.997459
257	Điểm hệ số 1 #1	43	1	\N	2025-05-11 11:52:32.997459
258	Điểm hệ số 1 #2	43	1	\N	2025-05-11 11:52:32.997459
259	Điểm hệ số 1 #3	43	1	\N	2025-05-11 11:52:32.997459
260	Điểm hệ số 2 #1	43	2	\N	2025-05-11 11:52:32.997459
261	Điểm hệ số 2 #2	43	2	\N	2025-05-11 11:52:32.997459
262	Điểm hệ số 3	43	3	\N	2025-05-11 11:52:32.997459
263	Điểm hệ số 1 #1	44	1	\N	2025-05-11 11:52:32.997459
264	Điểm hệ số 1 #2	44	1	\N	2025-05-11 11:52:32.997459
265	Điểm hệ số 1 #3	44	1	\N	2025-05-11 11:52:32.997459
266	Điểm hệ số 2 #1	44	2	\N	2025-05-11 11:52:32.997459
267	Điểm hệ số 2 #2	44	2	\N	2025-05-11 11:52:32.997459
268	Điểm hệ số 3	44	3	\N	2025-05-11 11:52:32.997459
269	Điểm hệ số 1 #1	45	1	\N	2025-05-11 11:52:32.997459
270	Điểm hệ số 1 #2	45	1	\N	2025-05-11 11:52:32.997459
271	Điểm hệ số 1 #3	45	1	\N	2025-05-11 11:52:32.997459
272	Điểm hệ số 2 #1	45	2	\N	2025-05-11 11:52:32.997459
273	Điểm hệ số 2 #2	45	2	\N	2025-05-11 11:52:32.997459
274	Điểm hệ số 3	45	3	\N	2025-05-11 11:52:32.997459
275	Điểm hệ số 1 #1	46	1	\N	2025-05-11 11:52:32.997459
276	Điểm hệ số 1 #2	46	1	\N	2025-05-11 11:52:32.997459
277	Điểm hệ số 1 #3	46	1	\N	2025-05-11 11:52:32.997459
278	Điểm hệ số 2 #1	46	2	\N	2025-05-11 11:52:32.997459
279	Điểm hệ số 2 #2	46	2	\N	2025-05-11 11:52:32.997459
280	Điểm hệ số 3	46	3	\N	2025-05-11 11:52:32.997459
287	Điểm hệ số 1 #1	48	1	\N	2025-05-11 11:52:32.99848
288	Điểm hệ số 1 #2	48	1	\N	2025-05-11 11:52:32.99848
289	Điểm hệ số 1 #3	48	1	\N	2025-05-11 11:52:32.99848
290	Điểm hệ số 2 #1	48	2	\N	2025-05-11 11:52:32.99848
291	Điểm hệ số 2 #2	48	2	\N	2025-05-11 11:52:32.99848
292	Điểm hệ số 3	48	3	\N	2025-05-11 11:52:32.99848
293	Điểm hệ số 1 #1	49	1	\N	2025-05-11 11:52:32.99848
294	Điểm hệ số 1 #2	49	1	\N	2025-05-11 11:52:32.99848
295	Điểm hệ số 1 #3	49	1	\N	2025-05-11 11:52:32.99848
296	Điểm hệ số 2 #1	49	2	\N	2025-05-11 11:52:32.99848
297	Điểm hệ số 2 #2	49	2	\N	2025-05-11 11:52:32.99848
298	Điểm hệ số 3	49	3	\N	2025-05-11 11:52:32.99848
299	Điểm hệ số 1 #1	50	1	\N	2025-05-11 11:52:32.99848
300	Điểm hệ số 1 #2	50	1	\N	2025-05-11 11:52:32.99848
301	Điểm hệ số 1 #3	50	1	\N	2025-05-11 11:52:32.99848
302	Điểm hệ số 2 #1	50	2	\N	2025-05-11 11:52:32.99848
303	Điểm hệ số 2 #2	50	2	\N	2025-05-11 11:52:32.99848
304	Điểm hệ số 3	50	3	\N	2025-05-11 11:52:32.99848
305	Điểm hệ số 1 #1	51	1	\N	2025-05-11 11:52:32.99848
306	Điểm hệ số 1 #2	51	1	\N	2025-05-11 11:52:32.99848
307	Điểm hệ số 1 #3	51	1	\N	2025-05-11 11:52:32.99848
308	Điểm hệ số 2 #1	51	2	\N	2025-05-11 11:52:32.99848
309	Điểm hệ số 2 #2	51	2	\N	2025-05-11 11:52:32.99848
310	Điểm hệ số 3	51	3	\N	2025-05-11 11:52:32.99848
311	Điểm hệ số 1 #1	52	1	\N	2025-05-11 11:52:32.99848
312	Điểm hệ số 1 #2	52	1	\N	2025-05-11 11:52:32.99848
313	Điểm hệ số 1 #3	52	1	\N	2025-05-11 11:52:32.99848
314	Điểm hệ số 2 #1	52	2	\N	2025-05-11 11:52:32.99848
315	Điểm hệ số 2 #2	52	2	\N	2025-05-11 11:52:32.99848
316	Điểm hệ số 3	52	3	\N	2025-05-11 11:52:32.99848
317	Điểm hệ số 1 #1	53	1	\N	2025-05-11 11:52:32.99848
318	Điểm hệ số 1 #2	53	1	\N	2025-05-11 11:52:32.99848
319	Điểm hệ số 1 #3	53	1	\N	2025-05-11 11:52:32.99848
320	Điểm hệ số 2 #1	53	2	\N	2025-05-11 11:52:32.99848
321	Điểm hệ số 2 #2	53	2	\N	2025-05-11 11:52:32.99848
322	Điểm hệ số 3	53	3	\N	2025-05-11 11:52:32.99848
323	Điểm hệ số 1 #1	54	1	\N	2025-05-11 11:52:32.99848
324	Điểm hệ số 1 #2	54	1	\N	2025-05-11 11:52:32.99848
284	Điểm hệ số 2 #1	47	2	9	2025-05-11 11:52:32.99848
285	Điểm hệ số 2 #2	47	2	9.8	2025-05-11 11:52:32.99848
281	Điểm hệ số 1 #1	47	1	10	2025-05-11 11:52:32.99848
283	Điểm hệ số 1 #3	47	1	8.9	2025-05-11 11:52:32.99848
244	Điểm hệ số 3	40	3	10	2025-05-11 11:52:32.997459
242	Điểm hệ số 2 #1	40	2	8	2025-05-11 11:52:32.997459
243	Điểm hệ số 2 #2	40	2	6	2025-05-11 11:52:32.997459
239	Điểm hệ số 1 #1	40	1	7	2025-05-11 11:52:32.997459
240	Điểm hệ số 1 #2	40	1	4	2025-05-11 11:52:32.997459
325	Điểm hệ số 1 #3	54	1	\N	2025-05-11 11:52:32.99848
326	Điểm hệ số 2 #1	54	2	\N	2025-05-11 11:52:32.99848
327	Điểm hệ số 2 #2	54	2	\N	2025-05-11 11:52:32.99848
328	Điểm hệ số 3	54	3	\N	2025-05-11 11:52:32.99848
329	Điểm hệ số 1 #1	55	1	\N	2025-05-11 11:52:32.99848
330	Điểm hệ số 1 #2	55	1	\N	2025-05-11 11:52:32.99848
331	Điểm hệ số 1 #3	55	1	\N	2025-05-11 11:52:32.99848
332	Điểm hệ số 2 #1	55	2	\N	2025-05-11 11:52:32.99848
333	Điểm hệ số 2 #2	55	2	\N	2025-05-11 11:52:32.99848
334	Điểm hệ số 3	55	3	\N	2025-05-11 11:52:32.99848
335	Điểm hệ số 1 #1	56	1	\N	2025-05-11 11:52:32.99848
336	Điểm hệ số 1 #2	56	1	\N	2025-05-11 11:52:32.99848
337	Điểm hệ số 1 #3	56	1	\N	2025-05-11 11:52:32.99848
338	Điểm hệ số 2 #1	56	2	\N	2025-05-11 11:52:32.99848
339	Điểm hệ số 2 #2	56	2	\N	2025-05-11 11:52:32.99848
340	Điểm hệ số 3	56	3	\N	2025-05-11 11:52:32.99848
341	Điểm hệ số 1 #1	57	1	\N	2025-05-11 11:52:32.99848
342	Điểm hệ số 1 #2	57	1	\N	2025-05-11 11:52:32.99848
343	Điểm hệ số 1 #3	57	1	\N	2025-05-11 11:52:32.99848
344	Điểm hệ số 2 #1	57	2	\N	2025-05-11 11:52:32.99848
345	Điểm hệ số 2 #2	57	2	\N	2025-05-11 11:52:32.99848
346	Điểm hệ số 3	57	3	\N	2025-05-11 11:52:32.99848
347	Điểm hệ số 1 #1	58	1	\N	2025-05-11 11:52:32.99848
348	Điểm hệ số 1 #2	58	1	\N	2025-05-11 11:52:32.99848
349	Điểm hệ số 1 #3	58	1	\N	2025-05-11 11:52:32.99848
350	Điểm hệ số 2 #1	58	2	\N	2025-05-11 11:52:32.99848
351	Điểm hệ số 2 #2	58	2	\N	2025-05-11 11:52:32.99848
352	Điểm hệ số 3	58	3	\N	2025-05-11 11:52:32.99848
359	Điểm hệ số 1 #1	60	1	\N	2025-05-11 11:52:32.99848
360	Điểm hệ số 1 #2	60	1	\N	2025-05-11 11:52:32.99848
361	Điểm hệ số 1 #3	60	1	\N	2025-05-11 11:52:32.99848
362	Điểm hệ số 2 #1	60	2	\N	2025-05-11 11:52:32.99848
363	Điểm hệ số 2 #2	60	2	\N	2025-05-11 11:52:32.99848
364	Điểm hệ số 3	60	3	\N	2025-05-11 11:52:32.99848
365	Điểm hệ số 1 #1	61	1	\N	2025-05-11 11:52:32.99848
366	Điểm hệ số 1 #2	61	1	\N	2025-05-11 11:52:32.99848
367	Điểm hệ số 1 #3	61	1	\N	2025-05-11 11:52:32.99848
368	Điểm hệ số 2 #1	61	2	\N	2025-05-11 11:52:32.99848
369	Điểm hệ số 2 #2	61	2	\N	2025-05-11 11:52:32.99848
370	Điểm hệ số 3	61	3	\N	2025-05-11 11:52:32.99848
371	Điểm hệ số 1 #1	62	1	\N	2025-05-11 11:52:32.99848
372	Điểm hệ số 1 #2	62	1	\N	2025-05-11 11:52:32.99848
373	Điểm hệ số 1 #3	62	1	\N	2025-05-11 11:52:32.99848
374	Điểm hệ số 2 #1	62	2	\N	2025-05-11 11:52:32.99848
375	Điểm hệ số 2 #2	62	2	\N	2025-05-11 11:52:32.99848
376	Điểm hệ số 3	62	3	\N	2025-05-11 11:52:32.99848
377	Điểm hệ số 1 #1	63	1	\N	2025-05-11 11:52:32.99848
378	Điểm hệ số 1 #2	63	1	\N	2025-05-11 11:52:32.99848
379	Điểm hệ số 1 #3	63	1	\N	2025-05-11 11:52:32.99848
380	Điểm hệ số 2 #1	63	2	\N	2025-05-11 11:52:32.99848
381	Điểm hệ số 2 #2	63	2	\N	2025-05-11 11:52:32.99848
382	Điểm hệ số 3	63	3	\N	2025-05-11 11:52:32.99848
383	Điểm hệ số 1 #1	64	1	\N	2025-05-11 12:11:42.870095
384	Điểm hệ số 1 #2	64	1	\N	2025-05-11 12:11:42.870095
385	Điểm hệ số 1 #3	64	1	\N	2025-05-11 12:11:42.870095
386	Điểm hệ số 2 #1	64	2	\N	2025-05-11 12:11:42.870095
387	Điểm hệ số 2 #2	64	2	\N	2025-05-11 12:11:42.870095
388	Điểm hệ số 3	64	3	\N	2025-05-11 12:11:42.870095
389	Điểm hệ số 1 #1	65	1	\N	2025-05-11 12:11:42.870095
390	Điểm hệ số 1 #2	65	1	\N	2025-05-11 12:11:42.870095
391	Điểm hệ số 1 #3	65	1	\N	2025-05-11 12:11:42.870095
392	Điểm hệ số 2 #1	65	2	\N	2025-05-11 12:11:42.870095
393	Điểm hệ số 2 #2	65	2	\N	2025-05-11 12:11:42.870095
394	Điểm hệ số 3	65	3	\N	2025-05-11 12:11:42.870095
395	Điểm hệ số 1 #1	66	1	\N	2025-05-11 12:11:42.870095
396	Điểm hệ số 1 #2	66	1	\N	2025-05-11 12:11:42.870095
397	Điểm hệ số 1 #3	66	1	\N	2025-05-11 12:11:42.870095
398	Điểm hệ số 2 #1	66	2	\N	2025-05-11 12:11:42.870095
399	Điểm hệ số 2 #2	66	2	\N	2025-05-11 12:11:42.870095
400	Điểm hệ số 3	66	3	\N	2025-05-11 12:11:42.870095
401	Điểm hệ số 1 #1	67	1	\N	2025-05-11 12:11:42.870095
402	Điểm hệ số 1 #2	67	1	\N	2025-05-11 12:11:42.870095
403	Điểm hệ số 1 #3	67	1	\N	2025-05-11 12:11:42.870095
404	Điểm hệ số 2 #1	67	2	\N	2025-05-11 12:11:42.870095
405	Điểm hệ số 2 #2	67	2	\N	2025-05-11 12:11:42.870095
406	Điểm hệ số 3	67	3	\N	2025-05-11 12:11:42.870095
407	Điểm hệ số 1 #1	68	1	\N	2025-05-11 12:11:42.870095
408	Điểm hệ số 1 #2	68	1	\N	2025-05-11 12:11:42.870095
409	Điểm hệ số 1 #3	68	1	\N	2025-05-11 12:11:42.870095
410	Điểm hệ số 2 #1	68	2	\N	2025-05-11 12:11:42.870095
411	Điểm hệ số 2 #2	68	2	\N	2025-05-11 12:11:42.870095
412	Điểm hệ số 3	68	3	\N	2025-05-11 12:11:42.870095
413	Điểm hệ số 1 #1	69	1	\N	2025-05-11 12:11:42.870095
414	Điểm hệ số 1 #2	69	1	\N	2025-05-11 12:11:42.870095
415	Điểm hệ số 1 #3	69	1	\N	2025-05-11 12:11:42.870095
416	Điểm hệ số 2 #1	69	2	\N	2025-05-11 12:11:42.870095
417	Điểm hệ số 2 #2	69	2	\N	2025-05-11 12:11:42.870095
418	Điểm hệ số 3	69	3	\N	2025-05-11 12:11:42.870095
419	Điểm hệ số 1 #1	70	1	\N	2025-05-11 12:11:42.870095
420	Điểm hệ số 1 #2	70	1	\N	2025-05-11 12:11:42.870095
421	Điểm hệ số 1 #3	70	1	\N	2025-05-11 12:11:42.870095
422	Điểm hệ số 2 #1	70	2	\N	2025-05-11 12:11:42.870095
423	Điểm hệ số 2 #2	70	2	\N	2025-05-11 12:11:42.870095
424	Điểm hệ số 3	70	3	\N	2025-05-11 12:11:42.870095
425	Điểm hệ số 1 #1	71	1	\N	2025-05-11 12:11:42.870095
426	Điểm hệ số 1 #2	71	1	\N	2025-05-11 12:11:42.870095
427	Điểm hệ số 1 #3	71	1	\N	2025-05-11 12:11:42.870095
428	Điểm hệ số 2 #1	71	2	\N	2025-05-11 12:11:42.870095
429	Điểm hệ số 2 #2	71	2	\N	2025-05-11 12:11:42.870095
430	Điểm hệ số 3	71	3	\N	2025-05-11 12:11:42.870095
431	Điểm hệ số 1 #1	72	1	\N	2025-05-11 12:11:42.870095
356	Điểm hệ số 2 #1	59	2	9	2025-05-11 11:52:32.99848
357	Điểm hệ số 2 #2	59	2	10	2025-05-11 11:52:32.99848
353	Điểm hệ số 1 #1	59	1	10	2025-05-11 11:52:32.99848
355	Điểm hệ số 1 #3	59	1	9.3	2025-05-11 11:52:32.99848
432	Điểm hệ số 1 #2	72	1	\N	2025-05-11 12:11:42.870095
433	Điểm hệ số 1 #3	72	1	\N	2025-05-11 12:11:42.870095
434	Điểm hệ số 2 #1	72	2	\N	2025-05-11 12:11:42.870095
435	Điểm hệ số 2 #2	72	2	\N	2025-05-11 12:11:42.870095
436	Điểm hệ số 3	72	3	\N	2025-05-11 12:11:42.870095
437	Điểm hệ số 1 #1	73	1	\N	2025-05-11 12:11:42.870095
438	Điểm hệ số 1 #2	73	1	\N	2025-05-11 12:11:42.870095
439	Điểm hệ số 1 #3	73	1	\N	2025-05-11 12:11:42.870095
440	Điểm hệ số 2 #1	73	2	\N	2025-05-11 12:11:42.870095
441	Điểm hệ số 2 #2	73	2	\N	2025-05-11 12:11:42.870095
442	Điểm hệ số 3	73	3	\N	2025-05-11 12:11:42.870095
443	Điểm hệ số 1 #1	74	1	\N	2025-05-11 12:11:42.870095
444	Điểm hệ số 1 #2	74	1	\N	2025-05-11 12:11:42.870095
445	Điểm hệ số 1 #3	74	1	\N	2025-05-11 12:11:42.870095
446	Điểm hệ số 2 #1	74	2	\N	2025-05-11 12:11:42.870095
447	Điểm hệ số 2 #2	74	2	\N	2025-05-11 12:11:42.870095
448	Điểm hệ số 3	74	3	\N	2025-05-11 12:11:42.870095
449	Điểm hệ số 1 #1	75	1	\N	2025-05-11 12:11:42.870095
450	Điểm hệ số 1 #2	75	1	\N	2025-05-11 12:11:42.870095
451	Điểm hệ số 1 #3	75	1	\N	2025-05-11 12:11:42.870095
452	Điểm hệ số 2 #1	75	2	\N	2025-05-11 12:11:42.870095
453	Điểm hệ số 2 #2	75	2	\N	2025-05-11 12:11:42.870095
454	Điểm hệ số 3	75	3	\N	2025-05-11 12:11:42.870095
455	Điểm hệ số 1 #1	76	1	\N	2025-05-11 12:11:42.870095
456	Điểm hệ số 1 #2	76	1	\N	2025-05-11 12:11:42.870095
457	Điểm hệ số 1 #3	76	1	\N	2025-05-11 12:11:42.870095
458	Điểm hệ số 2 #1	76	2	\N	2025-05-11 12:11:42.870095
459	Điểm hệ số 2 #2	76	2	\N	2025-05-11 12:11:42.870095
460	Điểm hệ số 3	76	3	\N	2025-05-11 12:11:42.870095
461	Điểm hệ số 1 #1	77	1	\N	2025-05-11 12:11:42.870095
462	Điểm hệ số 1 #2	77	1	\N	2025-05-11 12:11:42.870095
463	Điểm hệ số 1 #3	77	1	\N	2025-05-11 12:11:42.870095
464	Điểm hệ số 2 #1	77	2	\N	2025-05-11 12:11:42.870095
465	Điểm hệ số 2 #2	77	2	\N	2025-05-11 12:11:42.870095
466	Điểm hệ số 3	77	3	\N	2025-05-11 12:11:42.870095
467	Điểm hệ số 1 #1	78	1	\N	2025-05-11 12:11:42.870095
468	Điểm hệ số 1 #2	78	1	\N	2025-05-11 12:11:42.870095
469	Điểm hệ số 1 #3	78	1	\N	2025-05-11 12:11:42.870095
470	Điểm hệ số 2 #1	78	2	\N	2025-05-11 12:11:42.870095
471	Điểm hệ số 2 #2	78	2	\N	2025-05-11 12:11:42.870095
472	Điểm hệ số 3	78	3	\N	2025-05-11 12:11:42.870095
473	Điểm hệ số 1 #1	79	1	\N	2025-05-11 12:11:42.870095
474	Điểm hệ số 1 #2	79	1	\N	2025-05-11 12:11:42.870095
475	Điểm hệ số 1 #3	79	1	\N	2025-05-11 12:11:42.870095
476	Điểm hệ số 2 #1	79	2	\N	2025-05-11 12:11:42.870095
477	Điểm hệ số 2 #2	79	2	\N	2025-05-11 12:11:42.870095
478	Điểm hệ số 3	79	3	\N	2025-05-11 12:11:42.870095
479	Điểm hệ số 1 #1	80	1	\N	2025-05-11 12:11:42.870095
480	Điểm hệ số 1 #2	80	1	\N	2025-05-11 12:11:42.870095
481	Điểm hệ số 1 #3	80	1	\N	2025-05-11 12:11:42.870095
482	Điểm hệ số 2 #1	80	2	\N	2025-05-11 12:11:42.870095
483	Điểm hệ số 2 #2	80	2	\N	2025-05-11 12:11:42.870095
484	Điểm hệ số 3	80	3	\N	2025-05-11 12:11:42.870095
485	Điểm hệ số 1 #1	81	1	\N	2025-05-11 12:11:42.870095
486	Điểm hệ số 1 #2	81	1	\N	2025-05-11 12:11:42.870095
487	Điểm hệ số 1 #3	81	1	\N	2025-05-11 12:11:42.870095
488	Điểm hệ số 2 #1	81	2	\N	2025-05-11 12:11:42.870095
489	Điểm hệ số 2 #2	81	2	\N	2025-05-11 12:11:42.870095
490	Điểm hệ số 3	81	3	\N	2025-05-11 12:11:42.870095
491	Điểm hệ số 1 #1	82	1	\N	2025-05-11 12:11:42.870095
492	Điểm hệ số 1 #2	82	1	\N	2025-05-11 12:11:42.870095
493	Điểm hệ số 1 #3	82	1	\N	2025-05-11 12:11:42.870095
494	Điểm hệ số 2 #1	82	2	\N	2025-05-11 12:11:42.870095
495	Điểm hệ số 2 #2	82	2	\N	2025-05-11 12:11:42.870095
496	Điểm hệ số 3	82	3	\N	2025-05-11 12:11:42.870095
497	Điểm hệ số 1 #1	83	1	\N	2025-05-11 12:11:42.870095
498	Điểm hệ số 1 #2	83	1	\N	2025-05-11 12:11:42.870095
499	Điểm hệ số 1 #3	83	1	\N	2025-05-11 12:11:42.870095
500	Điểm hệ số 2 #1	83	2	\N	2025-05-11 12:11:42.870095
501	Điểm hệ số 2 #2	83	2	\N	2025-05-11 12:11:42.870095
502	Điểm hệ số 3	83	3	\N	2025-05-11 12:11:42.870095
503	Điểm hệ số 1 #1	84	1	\N	2025-05-11 12:11:42.870095
504	Điểm hệ số 1 #2	84	1	\N	2025-05-11 12:11:42.870095
505	Điểm hệ số 1 #3	84	1	\N	2025-05-11 12:11:42.870095
506	Điểm hệ số 2 #1	84	2	\N	2025-05-11 12:11:42.870095
507	Điểm hệ số 2 #2	84	2	\N	2025-05-11 12:11:42.870095
508	Điểm hệ số 3	84	3	\N	2025-05-11 12:11:42.870095
509	Điểm hệ số 1 #1	85	1	\N	2025-05-11 12:11:42.870095
510	Điểm hệ số 1 #2	85	1	\N	2025-05-11 12:11:42.870095
511	Điểm hệ số 1 #3	85	1	\N	2025-05-11 12:11:42.870095
512	Điểm hệ số 2 #1	85	2	\N	2025-05-11 12:11:42.870095
513	Điểm hệ số 2 #2	85	2	\N	2025-05-11 12:11:42.870095
514	Điểm hệ số 3	85	3	\N	2025-05-11 12:11:42.870095
515	Điểm hệ số 1 #1	86	1	\N	2025-05-11 12:11:42.870095
516	Điểm hệ số 1 #2	86	1	\N	2025-05-11 12:11:42.870095
517	Điểm hệ số 1 #3	86	1	\N	2025-05-11 12:11:42.870095
518	Điểm hệ số 2 #1	86	2	\N	2025-05-11 12:11:42.870095
519	Điểm hệ số 2 #2	86	2	\N	2025-05-11 12:11:42.870095
520	Điểm hệ số 3	86	3	\N	2025-05-11 12:11:42.870095
521	Điểm hệ số 1 #1	87	1	\N	2025-05-11 12:11:42.870095
522	Điểm hệ số 1 #2	87	1	\N	2025-05-11 12:11:42.870095
523	Điểm hệ số 1 #3	87	1	\N	2025-05-11 12:11:42.870095
524	Điểm hệ số 2 #1	87	2	\N	2025-05-11 12:11:42.870095
525	Điểm hệ số 2 #2	87	2	\N	2025-05-11 12:11:42.870095
526	Điểm hệ số 3	87	3	\N	2025-05-11 12:11:42.870095
527	Điểm hệ số 1 #1	88	1	\N	2025-05-11 12:11:42.870095
528	Điểm hệ số 1 #2	88	1	\N	2025-05-11 12:11:42.870095
529	Điểm hệ số 1 #3	88	1	\N	2025-05-11 12:11:42.870095
530	Điểm hệ số 2 #1	88	2	\N	2025-05-11 12:11:42.870095
531	Điểm hệ số 2 #2	88	2	\N	2025-05-11 12:11:42.870095
532	Điểm hệ số 3	88	3	\N	2025-05-11 12:11:42.870095
533	Điểm hệ số 1 #1	89	1	\N	2025-05-11 12:11:42.870095
534	Điểm hệ số 1 #2	89	1	\N	2025-05-11 12:11:42.870095
535	Điểm hệ số 1 #3	89	1	\N	2025-05-11 12:11:42.870095
536	Điểm hệ số 2 #1	89	2	\N	2025-05-11 12:11:42.870095
537	Điểm hệ số 2 #2	89	2	\N	2025-05-11 12:11:42.870095
538	Điểm hệ số 3	89	3	\N	2025-05-11 12:11:42.870095
539	Điểm hệ số 1 #1	90	1	\N	2025-05-11 12:11:42.870095
540	Điểm hệ số 1 #2	90	1	\N	2025-05-11 12:11:42.870095
541	Điểm hệ số 1 #3	90	1	\N	2025-05-11 12:11:42.870095
542	Điểm hệ số 2 #1	90	2	\N	2025-05-11 12:11:42.870095
543	Điểm hệ số 2 #2	90	2	\N	2025-05-11 12:11:42.870095
544	Điểm hệ số 3	90	3	\N	2025-05-11 12:11:42.870095
545	Điểm hệ số 1 #1	91	1	\N	2025-05-11 12:11:42.870095
546	Điểm hệ số 1 #2	91	1	\N	2025-05-11 12:11:42.870095
547	Điểm hệ số 1 #3	91	1	\N	2025-05-11 12:11:42.870095
548	Điểm hệ số 2 #1	91	2	\N	2025-05-11 12:11:42.870095
549	Điểm hệ số 2 #2	91	2	\N	2025-05-11 12:11:42.870095
550	Điểm hệ số 3	91	3	\N	2025-05-11 12:11:42.870095
551	Điểm hệ số 1 #1	92	1	\N	2025-05-11 12:11:42.870095
552	Điểm hệ số 1 #2	92	1	\N	2025-05-11 12:11:42.871067
553	Điểm hệ số 1 #3	92	1	\N	2025-05-11 12:11:42.871067
554	Điểm hệ số 2 #1	92	2	\N	2025-05-11 12:11:42.871067
555	Điểm hệ số 2 #2	92	2	\N	2025-05-11 12:11:42.871067
556	Điểm hệ số 3	92	3	\N	2025-05-11 12:11:42.871067
557	Điểm hệ số 1 #1	93	1	\N	2025-05-11 12:11:42.871067
558	Điểm hệ số 1 #2	93	1	\N	2025-05-11 12:11:42.871067
559	Điểm hệ số 1 #3	93	1	\N	2025-05-11 12:11:42.871067
560	Điểm hệ số 2 #1	93	2	\N	2025-05-11 12:11:42.871067
561	Điểm hệ số 2 #2	93	2	\N	2025-05-11 12:11:42.871067
562	Điểm hệ số 3	93	3	\N	2025-05-11 12:11:42.871067
563	Điểm hệ số 1 #1	94	1	\N	2025-05-11 12:11:42.871067
564	Điểm hệ số 1 #2	94	1	\N	2025-05-11 12:11:42.871067
565	Điểm hệ số 1 #3	94	1	\N	2025-05-11 12:11:42.871067
566	Điểm hệ số 2 #1	94	2	\N	2025-05-11 12:11:42.871067
567	Điểm hệ số 2 #2	94	2	\N	2025-05-11 12:11:42.871067
568	Điểm hệ số 3	94	3	\N	2025-05-11 12:11:42.871067
569	Điểm hệ số 1 #1	95	1	\N	2025-05-11 12:11:42.871067
570	Điểm hệ số 1 #2	95	1	\N	2025-05-11 12:11:42.871067
571	Điểm hệ số 1 #3	95	1	\N	2025-05-11 12:11:42.871067
572	Điểm hệ số 2 #1	95	2	\N	2025-05-11 12:11:42.871067
573	Điểm hệ số 2 #2	95	2	\N	2025-05-11 12:11:42.871067
574	Điểm hệ số 3	95	3	\N	2025-05-11 12:11:42.871067
575	Điểm hệ số 1 #1	96	1	\N	2025-05-11 12:11:42.871067
576	Điểm hệ số 1 #2	96	1	\N	2025-05-11 12:11:42.87148
577	Điểm hệ số 1 #3	96	1	\N	2025-05-11 12:11:42.87148
578	Điểm hệ số 2 #1	96	2	\N	2025-05-11 12:11:42.87148
579	Điểm hệ số 2 #2	96	2	\N	2025-05-11 12:11:42.87148
580	Điểm hệ số 3	96	3	\N	2025-05-11 12:11:42.87148
581	Điểm hệ số 1 #1	97	1	\N	2025-05-11 12:11:42.87148
582	Điểm hệ số 1 #2	97	1	\N	2025-05-11 12:11:42.87148
583	Điểm hệ số 1 #3	97	1	\N	2025-05-11 12:11:42.87148
584	Điểm hệ số 2 #1	97	2	\N	2025-05-11 12:11:42.87148
585	Điểm hệ số 2 #2	97	2	\N	2025-05-11 12:11:42.87148
586	Điểm hệ số 3	97	3	\N	2025-05-11 12:11:42.87148
587	Điểm hệ số 1 #1	98	1	\N	2025-05-11 12:11:42.87148
588	Điểm hệ số 1 #2	98	1	\N	2025-05-11 12:11:42.87148
589	Điểm hệ số 1 #3	98	1	\N	2025-05-11 12:11:42.87148
590	Điểm hệ số 2 #1	98	2	\N	2025-05-11 12:11:42.87148
591	Điểm hệ số 2 #2	98	2	\N	2025-05-11 12:11:42.87148
592	Điểm hệ số 3	98	3	\N	2025-05-11 12:11:42.87148
593	Điểm hệ số 1 #1	99	1	\N	2025-05-11 12:11:42.87148
594	Điểm hệ số 1 #2	99	1	\N	2025-05-11 12:11:42.87148
595	Điểm hệ số 1 #3	99	1	\N	2025-05-11 12:11:42.87148
596	Điểm hệ số 2 #1	99	2	\N	2025-05-11 12:11:42.87148
597	Điểm hệ số 2 #2	99	2	\N	2025-05-11 12:11:42.87148
598	Điểm hệ số 3	99	3	\N	2025-05-11 12:11:42.87148
599	Điểm hệ số 1 #1	100	1	\N	2025-05-11 12:11:42.87148
600	Điểm hệ số 1 #2	100	1	\N	2025-05-11 12:11:42.87148
601	Điểm hệ số 1 #3	100	1	\N	2025-05-11 12:11:42.87148
602	Điểm hệ số 2 #1	100	2	\N	2025-05-11 12:11:42.87148
603	Điểm hệ số 2 #2	100	2	\N	2025-05-11 12:11:42.87148
604	Điểm hệ số 3	100	3	\N	2025-05-11 12:11:42.87148
605	Điểm hệ số 1 #1	101	1	\N	2025-05-11 12:11:42.87148
606	Điểm hệ số 1 #2	101	1	\N	2025-05-11 12:11:42.87148
607	Điểm hệ số 1 #3	101	1	\N	2025-05-11 12:11:42.87148
608	Điểm hệ số 2 #1	101	2	\N	2025-05-11 12:11:42.87148
609	Điểm hệ số 2 #2	101	2	\N	2025-05-11 12:11:42.87148
610	Điểm hệ số 3	101	3	\N	2025-05-11 12:11:42.87148
611	Điểm hệ số 1 #1	102	1	\N	2025-05-11 12:11:42.87148
612	Điểm hệ số 1 #2	102	1	\N	2025-05-11 12:11:42.87148
613	Điểm hệ số 1 #3	102	1	\N	2025-05-11 12:11:42.87148
614	Điểm hệ số 2 #1	102	2	\N	2025-05-11 12:11:42.87148
615	Điểm hệ số 2 #2	102	2	\N	2025-05-11 12:11:42.87148
616	Điểm hệ số 3	102	3	\N	2025-05-11 12:11:42.87148
617	Điểm hệ số 1 #1	103	1	\N	2025-05-11 12:11:42.87148
618	Điểm hệ số 1 #2	103	1	\N	2025-05-11 12:11:42.87148
619	Điểm hệ số 1 #3	103	1	\N	2025-05-11 12:11:42.87148
620	Điểm hệ số 2 #1	103	2	\N	2025-05-11 12:11:42.87148
621	Điểm hệ số 2 #2	103	2	\N	2025-05-11 12:11:42.87148
622	Điểm hệ số 3	103	3	\N	2025-05-11 12:11:42.87148
623	Điểm hệ số 1 #1	104	1	\N	2025-05-11 12:11:42.87148
624	Điểm hệ số 1 #2	104	1	\N	2025-05-11 12:11:42.87148
625	Điểm hệ số 1 #3	104	1	\N	2025-05-11 12:11:42.87148
626	Điểm hệ số 2 #1	104	2	\N	2025-05-11 12:11:42.87148
627	Điểm hệ số 2 #2	104	2	\N	2025-05-11 12:11:42.87148
628	Điểm hệ số 3	104	3	\N	2025-05-11 12:11:42.87148
629	Điểm hệ số 1 #1	105	1	\N	2025-05-11 12:11:42.87148
630	Điểm hệ số 1 #2	105	1	\N	2025-05-11 12:11:42.87148
631	Điểm hệ số 1 #3	105	1	\N	2025-05-11 12:11:42.87148
632	Điểm hệ số 2 #1	105	2	\N	2025-05-11 12:11:42.87148
633	Điểm hệ số 2 #2	105	2	\N	2025-05-11 12:11:42.87148
634	Điểm hệ số 3	105	3	\N	2025-05-11 12:11:42.87148
635	Điểm hệ số 1 #1	106	1	\N	2025-05-11 12:11:42.87148
636	Điểm hệ số 1 #2	106	1	\N	2025-05-11 12:11:42.87148
637	Điểm hệ số 1 #3	106	1	\N	2025-05-11 12:11:42.87148
638	Điểm hệ số 2 #1	106	2	\N	2025-05-11 12:11:42.87148
639	Điểm hệ số 2 #2	106	2	\N	2025-05-11 12:11:42.87148
640	Điểm hệ số 3	106	3	\N	2025-05-11 12:11:42.87148
641	Điểm hệ số 1 #1	107	1	\N	2025-05-11 12:11:42.87148
642	Điểm hệ số 1 #2	107	1	\N	2025-05-11 12:11:42.87148
643	Điểm hệ số 1 #3	107	1	\N	2025-05-11 12:11:42.87148
644	Điểm hệ số 2 #1	107	2	\N	2025-05-11 12:11:42.87148
645	Điểm hệ số 2 #2	107	2	\N	2025-05-11 12:11:42.87199
646	Điểm hệ số 3	107	3	\N	2025-05-11 12:11:42.87199
647	Điểm hệ số 1 #1	108	1	\N	2025-05-11 12:11:42.87199
648	Điểm hệ số 1 #2	108	1	\N	2025-05-11 12:11:42.87199
649	Điểm hệ số 1 #3	108	1	\N	2025-05-11 12:11:42.87199
650	Điểm hệ số 2 #1	108	2	\N	2025-05-11 12:11:42.87199
651	Điểm hệ số 2 #2	108	2	\N	2025-05-11 12:11:42.87199
652	Điểm hệ số 3	108	3	\N	2025-05-11 12:11:42.87199
653	Điểm hệ số 1 #1	109	1	\N	2025-05-11 12:11:42.87199
654	Điểm hệ số 1 #2	109	1	\N	2025-05-11 12:11:42.87199
655	Điểm hệ số 1 #3	109	1	\N	2025-05-11 12:11:42.87199
656	Điểm hệ số 2 #1	109	2	\N	2025-05-11 12:11:42.87199
657	Điểm hệ số 2 #2	109	2	\N	2025-05-11 12:11:42.87199
658	Điểm hệ số 3	109	3	\N	2025-05-11 12:11:42.87199
659	Điểm hệ số 1 #1	110	1	\N	2025-05-11 12:11:42.87199
660	Điểm hệ số 1 #2	110	1	\N	2025-05-11 12:11:42.87199
661	Điểm hệ số 1 #3	110	1	\N	2025-05-11 12:11:42.87199
662	Điểm hệ số 2 #1	110	2	\N	2025-05-11 12:11:42.87199
663	Điểm hệ số 2 #2	110	2	\N	2025-05-11 12:11:42.87199
664	Điểm hệ số 3	110	3	\N	2025-05-11 12:11:42.87199
665	Điểm hệ số 1 #1	111	1	\N	2025-05-11 12:11:42.87199
666	Điểm hệ số 1 #2	111	1	\N	2025-05-11 12:11:42.87199
667	Điểm hệ số 1 #3	111	1	\N	2025-05-11 12:11:42.87199
668	Điểm hệ số 2 #1	111	2	\N	2025-05-11 12:11:42.87199
669	Điểm hệ số 2 #2	111	2	\N	2025-05-11 12:11:42.87199
670	Điểm hệ số 3	111	3	\N	2025-05-11 12:11:42.87199
671	Điểm hệ số 1 #1	112	1	\N	2025-05-11 12:11:42.87199
672	Điểm hệ số 1 #2	112	1	\N	2025-05-11 12:11:42.87199
673	Điểm hệ số 1 #3	112	1	\N	2025-05-11 12:11:42.87199
674	Điểm hệ số 2 #1	112	2	\N	2025-05-11 12:11:42.87199
675	Điểm hệ số 2 #2	112	2	\N	2025-05-11 12:11:42.87199
676	Điểm hệ số 3	112	3	\N	2025-05-11 12:11:42.87199
677	Điểm hệ số 1 #1	113	1	\N	2025-05-11 12:11:42.87199
678	Điểm hệ số 1 #2	113	1	\N	2025-05-11 12:11:42.87199
679	Điểm hệ số 1 #3	113	1	\N	2025-05-11 12:11:42.87199
680	Điểm hệ số 2 #1	113	2	\N	2025-05-11 12:11:42.87199
681	Điểm hệ số 2 #2	113	2	\N	2025-05-11 12:11:42.87199
682	Điểm hệ số 3	113	3	\N	2025-05-11 12:11:42.87199
683	Điểm hệ số 1 #1	114	1	\N	2025-05-11 12:11:42.87199
684	Điểm hệ số 1 #2	114	1	\N	2025-05-11 12:11:42.87199
685	Điểm hệ số 1 #3	114	1	\N	2025-05-11 12:11:42.87199
686	Điểm hệ số 2 #1	114	2	\N	2025-05-11 12:11:42.87199
687	Điểm hệ số 2 #2	114	2	\N	2025-05-11 12:11:42.87199
688	Điểm hệ số 3	114	3	\N	2025-05-11 12:11:42.87199
689	Điểm hệ số 1 #1	115	1	\N	2025-05-11 12:11:42.87199
690	Điểm hệ số 1 #2	115	1	\N	2025-05-11 12:11:42.87199
691	Điểm hệ số 1 #3	115	1	\N	2025-05-11 12:11:42.87199
692	Điểm hệ số 2 #1	115	2	\N	2025-05-11 12:11:42.87199
693	Điểm hệ số 2 #2	115	2	\N	2025-05-11 12:11:42.87199
694	Điểm hệ số 3	115	3	\N	2025-05-11 12:11:42.87199
695	Điểm hệ số 1 #1	116	1	\N	2025-05-11 12:11:42.87199
696	Điểm hệ số 1 #2	116	1	\N	2025-05-11 12:11:42.87199
697	Điểm hệ số 1 #3	116	1	\N	2025-05-11 12:11:42.87199
698	Điểm hệ số 2 #1	116	2	\N	2025-05-11 12:11:42.87199
699	Điểm hệ số 2 #2	116	2	\N	2025-05-11 12:11:42.87199
700	Điểm hệ số 3	116	3	\N	2025-05-11 12:11:42.87199
701	Điểm hệ số 1 #1	117	1	\N	2025-05-11 12:11:42.87199
702	Điểm hệ số 1 #2	117	1	\N	2025-05-11 12:11:42.87199
703	Điểm hệ số 1 #3	117	1	\N	2025-05-11 12:11:42.87199
704	Điểm hệ số 2 #1	117	2	\N	2025-05-11 12:11:42.87199
705	Điểm hệ số 2 #2	117	2	\N	2025-05-11 12:11:42.87199
706	Điểm hệ số 3	117	3	\N	2025-05-11 12:11:42.87199
707	Điểm hệ số 1 #1	118	1	\N	2025-05-11 12:11:42.87199
708	Điểm hệ số 1 #2	118	1	\N	2025-05-11 12:11:42.87199
709	Điểm hệ số 1 #3	118	1	\N	2025-05-11 12:11:42.87199
710	Điểm hệ số 2 #1	118	2	\N	2025-05-11 12:11:42.87199
711	Điểm hệ số 2 #2	118	2	\N	2025-05-11 12:11:42.87199
712	Điểm hệ số 3	118	3	\N	2025-05-11 12:11:42.87199
713	Điểm hệ số 1 #1	119	1	\N	2025-05-11 12:11:42.87199
714	Điểm hệ số 1 #2	119	1	\N	2025-05-11 12:11:42.87199
715	Điểm hệ số 1 #3	119	1	\N	2025-05-11 12:11:42.87199
716	Điểm hệ số 2 #1	119	2	\N	2025-05-11 12:11:42.87199
717	Điểm hệ số 2 #2	119	2	\N	2025-05-11 12:11:42.87199
718	Điểm hệ số 3	119	3	\N	2025-05-11 12:11:42.87199
719	Điểm hệ số 1 #1	120	1	\N	2025-05-11 12:11:42.87199
720	Điểm hệ số 1 #2	120	1	\N	2025-05-11 12:11:42.87199
721	Điểm hệ số 1 #3	120	1	\N	2025-05-11 12:11:42.87199
722	Điểm hệ số 2 #1	120	2	\N	2025-05-11 12:11:42.87199
723	Điểm hệ số 2 #2	120	2	\N	2025-05-11 12:11:42.87199
724	Điểm hệ số 3	120	3	\N	2025-05-11 12:11:42.87199
725	Điểm hệ số 1 #1	121	1	\N	2025-05-11 12:11:42.87199
726	Điểm hệ số 1 #2	121	1	\N	2025-05-11 12:11:42.87199
727	Điểm hệ số 1 #3	121	1	\N	2025-05-11 12:11:42.87199
728	Điểm hệ số 2 #1	121	2	\N	2025-05-11 12:11:42.87199
729	Điểm hệ số 2 #2	121	2	\N	2025-05-11 12:11:42.87199
730	Điểm hệ số 3	121	3	\N	2025-05-11 12:11:42.87199
731	Điểm hệ số 1 #1	122	1	\N	2025-05-11 12:11:42.87199
732	Điểm hệ số 1 #2	122	1	\N	2025-05-11 12:11:42.87199
733	Điểm hệ số 1 #3	122	1	\N	2025-05-11 12:11:42.87199
734	Điểm hệ số 2 #1	122	2	\N	2025-05-11 12:11:42.87199
735	Điểm hệ số 2 #2	122	2	\N	2025-05-11 12:11:42.87199
736	Điểm hệ số 3	122	3	\N	2025-05-11 12:11:42.87199
737	Điểm hệ số 1 #1	123	1	\N	2025-05-11 12:11:42.87199
738	Điểm hệ số 1 #2	123	1	\N	2025-05-11 12:11:42.87199
739	Điểm hệ số 1 #3	123	1	\N	2025-05-11 12:11:42.87199
740	Điểm hệ số 2 #1	123	2	\N	2025-05-11 12:11:42.87199
741	Điểm hệ số 2 #2	123	2	\N	2025-05-11 12:11:42.87199
742	Điểm hệ số 3	123	3	\N	2025-05-11 12:11:42.87199
743	Điểm hệ số 1 #1	124	1	\N	2025-05-11 12:11:42.87199
744	Điểm hệ số 1 #2	124	1	\N	2025-05-11 12:11:42.87199
745	Điểm hệ số 1 #3	124	1	\N	2025-05-11 12:11:42.87199
746	Điểm hệ số 2 #1	124	2	\N	2025-05-11 12:11:42.87199
747	Điểm hệ số 2 #2	124	2	\N	2025-05-11 12:11:42.87199
748	Điểm hệ số 3	124	3	\N	2025-05-11 12:11:42.87199
749	Điểm hệ số 1 #1	125	1	\N	2025-05-11 12:11:42.87199
750	Điểm hệ số 1 #2	125	1	\N	2025-05-11 12:11:42.87199
751	Điểm hệ số 1 #3	125	1	\N	2025-05-11 12:11:42.87199
752	Điểm hệ số 2 #1	125	2	\N	2025-05-11 12:11:42.87199
753	Điểm hệ số 2 #2	125	2	\N	2025-05-11 12:11:42.87199
754	Điểm hệ số 3	125	3	\N	2025-05-11 12:11:42.87199
755	Điểm hệ số 1 #1	126	1	\N	2025-05-11 12:11:42.87199
756	Điểm hệ số 1 #2	126	1	\N	2025-05-11 12:11:42.87199
757	Điểm hệ số 1 #3	126	1	\N	2025-05-11 12:11:42.87199
758	Điểm hệ số 2 #1	126	2	\N	2025-05-11 12:11:42.87199
759	Điểm hệ số 2 #2	126	2	\N	2025-05-11 12:11:42.87199
760	Điểm hệ số 3	126	3	\N	2025-05-11 12:11:42.87199
761	Điểm hệ số 1 #1	127	1	\N	2025-05-11 12:11:42.87199
762	Điểm hệ số 1 #2	127	1	\N	2025-05-11 12:11:42.87199
763	Điểm hệ số 1 #3	127	1	\N	2025-05-11 12:11:42.87199
764	Điểm hệ số 2 #1	127	2	\N	2025-05-11 12:11:42.87199
765	Điểm hệ số 2 #2	127	2	\N	2025-05-11 12:11:42.87199
766	Điểm hệ số 3	127	3	\N	2025-05-11 12:11:42.87199
767	Điểm hệ số 1 #1	128	1	\N	2025-05-11 12:11:42.87199
768	Điểm hệ số 1 #2	128	1	\N	2025-05-11 12:11:42.87199
769	Điểm hệ số 1 #3	128	1	\N	2025-05-11 12:11:42.87199
770	Điểm hệ số 2 #1	128	2	\N	2025-05-11 12:11:42.87199
771	Điểm hệ số 2 #2	128	2	\N	2025-05-11 12:11:42.87199
772	Điểm hệ số 3	128	3	\N	2025-05-11 12:11:42.87199
773	Điểm hệ số 1 #1	129	1	\N	2025-05-11 12:11:42.87199
774	Điểm hệ số 1 #2	129	1	\N	2025-05-11 12:11:42.87199
775	Điểm hệ số 1 #3	129	1	\N	2025-05-11 12:11:42.87199
776	Điểm hệ số 2 #1	129	2	\N	2025-05-11 12:11:42.87199
777	Điểm hệ số 2 #2	129	2	\N	2025-05-11 12:11:42.87199
778	Điểm hệ số 3	129	3	\N	2025-05-11 12:11:42.87199
779	Điểm hệ số 1 #1	130	1	\N	2025-05-11 12:11:42.87199
780	Điểm hệ số 1 #2	130	1	\N	2025-05-11 12:11:42.87199
781	Điểm hệ số 1 #3	130	1	\N	2025-05-11 12:11:42.87199
782	Điểm hệ số 2 #1	130	2	\N	2025-05-11 12:11:42.87199
783	Điểm hệ số 2 #2	130	2	\N	2025-05-11 12:11:42.87199
784	Điểm hệ số 3	130	3	\N	2025-05-11 12:11:42.87199
785	Điểm hệ số 1 #1	131	1	\N	2025-05-11 12:11:42.87199
786	Điểm hệ số 1 #2	131	1	\N	2025-05-11 12:11:42.87199
787	Điểm hệ số 1 #3	131	1	\N	2025-05-11 12:11:42.87199
788	Điểm hệ số 2 #1	131	2	\N	2025-05-11 12:11:42.87199
789	Điểm hệ số 2 #2	131	2	\N	2025-05-11 12:11:42.87199
790	Điểm hệ số 3	131	3	\N	2025-05-11 12:11:42.87199
791	Điểm hệ số 1 #1	132	1	\N	2025-05-11 12:11:42.87199
792	Điểm hệ số 1 #2	132	1	\N	2025-05-11 12:11:42.87199
793	Điểm hệ số 1 #3	132	1	\N	2025-05-11 12:11:42.87199
794	Điểm hệ số 2 #1	132	2	\N	2025-05-11 12:11:42.87199
795	Điểm hệ số 2 #2	132	2	\N	2025-05-11 12:11:42.87199
796	Điểm hệ số 3	132	3	\N	2025-05-11 12:11:42.87199
797	Điểm hệ số 1 #1	133	1	\N	2025-05-11 12:11:42.87199
798	Điểm hệ số 1 #2	133	1	\N	2025-05-11 12:11:42.87199
799	Điểm hệ số 1 #3	133	1	\N	2025-05-11 12:11:42.87199
800	Điểm hệ số 2 #1	133	2	\N	2025-05-11 12:11:42.87199
801	Điểm hệ số 2 #2	133	2	\N	2025-05-11 12:11:42.87199
802	Điểm hệ số 3	133	3	\N	2025-05-11 12:11:42.87199
803	Điểm hệ số 1 #1	134	1	\N	2025-05-11 12:11:42.87199
804	Điểm hệ số 1 #2	134	1	\N	2025-05-11 12:11:42.87199
805	Điểm hệ số 1 #3	134	1	\N	2025-05-11 12:11:42.87199
806	Điểm hệ số 2 #1	134	2	\N	2025-05-11 12:11:42.87199
807	Điểm hệ số 2 #2	134	2	\N	2025-05-11 12:11:42.87199
808	Điểm hệ số 3	134	3	\N	2025-05-11 12:11:42.87199
809	Điểm hệ số 1 #1	135	1	\N	2025-05-11 12:11:42.87199
810	Điểm hệ số 1 #2	135	1	\N	2025-05-11 12:11:42.87199
811	Điểm hệ số 1 #3	135	1	\N	2025-05-11 12:11:42.87199
812	Điểm hệ số 2 #1	135	2	\N	2025-05-11 12:11:42.87199
813	Điểm hệ số 2 #2	135	2	\N	2025-05-11 12:11:42.87199
814	Điểm hệ số 3	135	3	\N	2025-05-11 12:11:42.87199
815	Điểm hệ số 1 #1	136	1	\N	2025-05-11 12:11:42.87199
816	Điểm hệ số 1 #2	136	1	\N	2025-05-11 12:11:42.87199
817	Điểm hệ số 1 #3	136	1	\N	2025-05-11 12:11:42.87199
818	Điểm hệ số 2 #1	136	2	\N	2025-05-11 12:11:42.87199
819	Điểm hệ số 2 #2	136	2	\N	2025-05-11 12:11:42.87199
820	Điểm hệ số 3	136	3	\N	2025-05-11 12:11:42.87199
821	Điểm hệ số 1 #1	137	1	\N	2025-05-11 12:11:42.87199
822	Điểm hệ số 1 #2	137	1	\N	2025-05-11 12:11:42.87199
823	Điểm hệ số 1 #3	137	1	\N	2025-05-11 12:11:42.87199
824	Điểm hệ số 2 #1	137	2	\N	2025-05-11 12:11:42.87199
825	Điểm hệ số 2 #2	137	2	\N	2025-05-11 12:11:42.87199
826	Điểm hệ số 3	137	3	\N	2025-05-11 12:11:42.87199
827	Điểm hệ số 1 #1	138	1	\N	2025-05-11 12:11:42.87199
828	Điểm hệ số 1 #2	138	1	\N	2025-05-11 12:11:42.87199
829	Điểm hệ số 1 #3	138	1	\N	2025-05-11 12:11:42.87199
830	Điểm hệ số 2 #1	138	2	\N	2025-05-11 12:11:42.87199
831	Điểm hệ số 2 #2	138	2	\N	2025-05-11 12:11:42.87199
832	Điểm hệ số 3	138	3	\N	2025-05-11 12:11:42.87199
833	Điểm hệ số 1 #1	139	1	\N	2025-05-11 12:11:42.87199
834	Điểm hệ số 1 #2	139	1	\N	2025-05-11 12:11:42.87199
835	Điểm hệ số 1 #3	139	1	\N	2025-05-11 12:11:42.87199
836	Điểm hệ số 2 #1	139	2	\N	2025-05-11 12:11:42.87199
837	Điểm hệ số 2 #2	139	2	\N	2025-05-11 12:11:42.87199
838	Điểm hệ số 3	139	3	\N	2025-05-11 12:11:42.87199
839	Điểm hệ số 1 #1	140	1	\N	2025-05-11 12:11:42.87199
840	Điểm hệ số 1 #2	140	1	\N	2025-05-11 12:11:42.87199
841	Điểm hệ số 1 #3	140	1	\N	2025-05-11 12:11:42.87199
842	Điểm hệ số 2 #1	140	2	\N	2025-05-11 12:11:42.87199
843	Điểm hệ số 2 #2	140	2	\N	2025-05-11 12:11:42.87199
844	Điểm hệ số 3	140	3	\N	2025-05-11 12:11:42.87199
845	Điểm hệ số 1 #1	141	1	\N	2025-05-11 12:11:42.87199
846	Điểm hệ số 1 #2	141	1	\N	2025-05-11 12:11:42.87199
847	Điểm hệ số 1 #3	141	1	\N	2025-05-11 12:11:42.87199
848	Điểm hệ số 2 #1	141	2	\N	2025-05-11 12:11:42.87199
849	Điểm hệ số 2 #2	141	2	\N	2025-05-11 12:11:42.87199
850	Điểm hệ số 3	141	3	\N	2025-05-11 12:11:42.87199
851	Điểm hệ số 1 #1	142	1	\N	2025-05-11 12:11:42.87199
852	Điểm hệ số 1 #2	142	1	\N	2025-05-11 12:11:42.87199
853	Điểm hệ số 1 #3	142	1	\N	2025-05-11 12:11:42.87199
854	Điểm hệ số 2 #1	142	2	\N	2025-05-11 12:11:42.87199
855	Điểm hệ số 2 #2	142	2	\N	2025-05-11 12:11:42.87199
856	Điểm hệ số 3	142	3	\N	2025-05-11 12:11:42.87199
857	Điểm hệ số 1 #1	143	1	\N	2025-05-11 12:11:42.87199
858	Điểm hệ số 1 #2	143	1	\N	2025-05-11 12:11:42.873022
859	Điểm hệ số 1 #3	143	1	\N	2025-05-11 12:11:42.873022
860	Điểm hệ số 2 #1	143	2	\N	2025-05-11 12:11:42.873022
861	Điểm hệ số 2 #2	143	2	\N	2025-05-11 12:11:42.873022
862	Điểm hệ số 3	143	3	\N	2025-05-11 12:11:42.873022
863	Điểm hệ số 1 #1	144	1	\N	2025-05-11 12:11:42.873022
864	Điểm hệ số 1 #2	144	1	\N	2025-05-11 12:11:42.873022
865	Điểm hệ số 1 #3	144	1	\N	2025-05-11 12:11:42.873022
866	Điểm hệ số 2 #1	144	2	\N	2025-05-11 12:11:42.873022
867	Điểm hệ số 2 #2	144	2	\N	2025-05-11 12:11:42.873022
868	Điểm hệ số 3	144	3	\N	2025-05-11 12:11:42.873022
869	Điểm hệ số 1 #1	145	1	\N	2025-05-11 12:11:42.873022
870	Điểm hệ số 1 #2	145	1	\N	2025-05-11 12:11:42.873022
871	Điểm hệ số 1 #3	145	1	\N	2025-05-11 12:11:42.873022
872	Điểm hệ số 2 #1	145	2	\N	2025-05-11 12:11:42.873022
873	Điểm hệ số 2 #2	145	2	\N	2025-05-11 12:11:42.873022
874	Điểm hệ số 3	145	3	\N	2025-05-11 12:11:42.873022
875	Điểm hệ số 1 #1	146	1	\N	2025-05-11 12:11:42.873022
876	Điểm hệ số 1 #2	146	1	\N	2025-05-11 12:11:42.873022
877	Điểm hệ số 1 #3	146	1	\N	2025-05-11 12:11:42.873022
878	Điểm hệ số 2 #1	146	2	\N	2025-05-11 12:11:42.873022
879	Điểm hệ số 2 #2	146	2	\N	2025-05-11 12:11:42.873022
880	Điểm hệ số 3	146	3	\N	2025-05-11 12:11:42.873022
881	Điểm hệ số 1 #1	147	1	\N	2025-05-11 12:11:42.873022
882	Điểm hệ số 1 #2	147	1	\N	2025-05-11 12:11:42.873022
883	Điểm hệ số 1 #3	147	1	\N	2025-05-11 12:11:42.873022
884	Điểm hệ số 2 #1	147	2	\N	2025-05-11 12:11:42.873022
885	Điểm hệ số 2 #2	147	2	\N	2025-05-11 12:11:42.873022
886	Điểm hệ số 3	147	3	\N	2025-05-11 12:11:42.873022
887	Điểm hệ số 1 #1	148	1	\N	2025-05-11 12:11:42.873022
888	Điểm hệ số 1 #2	148	1	\N	2025-05-11 12:11:42.873022
889	Điểm hệ số 1 #3	148	1	\N	2025-05-11 12:11:42.873022
890	Điểm hệ số 2 #1	148	2	\N	2025-05-11 12:11:42.873022
891	Điểm hệ số 2 #2	148	2	\N	2025-05-11 12:11:42.873022
892	Điểm hệ số 3	148	3	\N	2025-05-11 12:11:42.873022
893	Điểm hệ số 1 #1	149	1	\N	2025-05-11 12:11:42.873022
894	Điểm hệ số 1 #2	149	1	\N	2025-05-11 12:11:42.873022
895	Điểm hệ số 1 #3	149	1	\N	2025-05-11 12:11:42.873022
896	Điểm hệ số 2 #1	149	2	\N	2025-05-11 12:11:42.873022
897	Điểm hệ số 2 #2	149	2	\N	2025-05-11 12:11:42.873022
898	Điểm hệ số 3	149	3	\N	2025-05-11 12:11:42.873022
899	Điểm hệ số 1 #1	150	1	\N	2025-05-11 12:11:42.873022
900	Điểm hệ số 1 #2	150	1	\N	2025-05-11 12:11:42.873022
901	Điểm hệ số 1 #3	150	1	\N	2025-05-11 12:11:42.873022
902	Điểm hệ số 2 #1	150	2	\N	2025-05-11 12:11:42.873022
903	Điểm hệ số 2 #2	150	2	\N	2025-05-11 12:11:42.873022
904	Điểm hệ số 3	150	3	\N	2025-05-11 12:11:42.873022
905	Điểm hệ số 1 #1	151	1	\N	2025-05-11 12:11:42.873022
906	Điểm hệ số 1 #2	151	1	\N	2025-05-11 12:11:42.873022
907	Điểm hệ số 1 #3	151	1	\N	2025-05-11 12:11:42.873022
908	Điểm hệ số 2 #1	151	2	\N	2025-05-11 12:11:42.873022
909	Điểm hệ số 2 #2	151	2	\N	2025-05-11 12:11:42.873022
910	Điểm hệ số 3	151	3	\N	2025-05-11 12:11:42.873022
911	Điểm hệ số 1 #1	152	1	\N	2025-05-11 12:11:42.873022
912	Điểm hệ số 1 #2	152	1	\N	2025-05-11 12:11:42.873022
913	Điểm hệ số 1 #3	152	1	\N	2025-05-11 12:11:42.873022
914	Điểm hệ số 2 #1	152	2	\N	2025-05-11 12:11:42.873022
915	Điểm hệ số 2 #2	152	2	\N	2025-05-11 12:11:42.873022
916	Điểm hệ số 3	152	3	\N	2025-05-11 12:11:42.873022
917	Điểm hệ số 1 #1	153	1	\N	2025-05-11 12:11:42.873022
918	Điểm hệ số 1 #2	153	1	\N	2025-05-11 12:11:42.873022
919	Điểm hệ số 1 #3	153	1	\N	2025-05-11 12:11:42.873022
920	Điểm hệ số 2 #1	153	2	\N	2025-05-11 12:11:42.873022
921	Điểm hệ số 2 #2	153	2	\N	2025-05-11 12:11:42.873022
922	Điểm hệ số 3	153	3	\N	2025-05-11 12:11:42.873022
923	Điểm hệ số 1 #1	154	1	\N	2025-05-11 12:11:42.873022
924	Điểm hệ số 1 #2	154	1	\N	2025-05-11 12:11:42.873022
925	Điểm hệ số 1 #3	154	1	\N	2025-05-11 12:11:42.873022
926	Điểm hệ số 2 #1	154	2	\N	2025-05-11 12:11:42.873022
927	Điểm hệ số 2 #2	154	2	\N	2025-05-11 12:11:42.873022
928	Điểm hệ số 3	154	3	\N	2025-05-11 12:11:42.873022
929	Điểm hệ số 1 #1	155	1	\N	2025-05-11 12:11:42.873022
930	Điểm hệ số 1 #2	155	1	\N	2025-05-11 12:11:42.873022
931	Điểm hệ số 1 #3	155	1	\N	2025-05-11 12:11:42.873022
932	Điểm hệ số 2 #1	155	2	\N	2025-05-11 12:11:42.873022
933	Điểm hệ số 2 #2	155	2	\N	2025-05-11 12:11:42.873022
934	Điểm hệ số 3	155	3	\N	2025-05-11 12:11:42.873022
935	Điểm hệ số 1 #1	156	1	\N	2025-05-11 12:12:11.581711
936	Điểm hệ số 1 #2	156	1	\N	2025-05-11 12:12:11.581711
937	Điểm hệ số 1 #3	156	1	\N	2025-05-11 12:12:11.581711
938	Điểm hệ số 2 #1	156	2	\N	2025-05-11 12:12:11.581711
939	Điểm hệ số 2 #2	156	2	\N	2025-05-11 12:12:11.581711
940	Điểm hệ số 3	156	3	\N	2025-05-11 12:12:11.581711
941	Điểm hệ số 1 #1	157	1	\N	2025-05-11 12:12:11.581711
942	Điểm hệ số 1 #2	157	1	\N	2025-05-11 12:12:11.581711
943	Điểm hệ số 1 #3	157	1	\N	2025-05-11 12:12:11.581711
944	Điểm hệ số 2 #1	157	2	\N	2025-05-11 12:12:11.581711
945	Điểm hệ số 2 #2	157	2	\N	2025-05-11 12:12:11.581711
946	Điểm hệ số 3	157	3	\N	2025-05-11 12:12:11.581711
947	Điểm hệ số 1 #1	158	1	\N	2025-05-11 12:12:11.581711
948	Điểm hệ số 1 #2	158	1	\N	2025-05-11 12:12:11.581711
949	Điểm hệ số 1 #3	158	1	\N	2025-05-11 12:12:11.581711
950	Điểm hệ số 2 #1	158	2	\N	2025-05-11 12:12:11.581711
951	Điểm hệ số 2 #2	158	2	\N	2025-05-11 12:12:11.581711
952	Điểm hệ số 3	158	3	\N	2025-05-11 12:12:11.581711
953	Điểm hệ số 1 #1	159	1	\N	2025-05-11 12:12:11.581711
954	Điểm hệ số 1 #2	159	1	\N	2025-05-11 12:12:11.581711
955	Điểm hệ số 1 #3	159	1	\N	2025-05-11 12:12:11.581711
956	Điểm hệ số 2 #1	159	2	\N	2025-05-11 12:12:11.581711
957	Điểm hệ số 2 #2	159	2	\N	2025-05-11 12:12:11.581711
958	Điểm hệ số 3	159	3	\N	2025-05-11 12:12:11.581711
959	Điểm hệ số 1 #1	160	1	\N	2025-05-11 12:12:11.581711
960	Điểm hệ số 1 #2	160	1	\N	2025-05-11 12:12:11.581711
961	Điểm hệ số 1 #3	160	1	\N	2025-05-11 12:12:11.581711
962	Điểm hệ số 2 #1	160	2	\N	2025-05-11 12:12:11.581711
963	Điểm hệ số 2 #2	160	2	\N	2025-05-11 12:12:11.581711
964	Điểm hệ số 3	160	3	\N	2025-05-11 12:12:11.581711
965	Điểm hệ số 1 #1	161	1	\N	2025-05-11 12:12:11.581711
966	Điểm hệ số 1 #2	161	1	\N	2025-05-11 12:12:11.581711
967	Điểm hệ số 1 #3	161	1	\N	2025-05-11 12:12:11.581711
968	Điểm hệ số 2 #1	161	2	\N	2025-05-11 12:12:11.581711
969	Điểm hệ số 2 #2	161	2	\N	2025-05-11 12:12:11.581711
970	Điểm hệ số 3	161	3	\N	2025-05-11 12:12:11.581711
971	Điểm hệ số 1 #1	162	1	\N	2025-05-11 12:12:11.581711
972	Điểm hệ số 1 #2	162	1	\N	2025-05-11 12:12:11.581711
973	Điểm hệ số 1 #3	162	1	\N	2025-05-11 12:12:11.581711
974	Điểm hệ số 2 #1	162	2	\N	2025-05-11 12:12:11.581711
975	Điểm hệ số 2 #2	162	2	\N	2025-05-11 12:12:11.581711
976	Điểm hệ số 3	162	3	\N	2025-05-11 12:12:11.581711
977	Điểm hệ số 1 #1	163	1	\N	2025-05-11 12:12:11.581711
978	Điểm hệ số 1 #2	163	1	\N	2025-05-11 12:12:11.581711
979	Điểm hệ số 1 #3	163	1	\N	2025-05-11 12:12:11.581711
980	Điểm hệ số 2 #1	163	2	\N	2025-05-11 12:12:11.581711
981	Điểm hệ số 2 #2	163	2	\N	2025-05-11 12:12:11.581711
982	Điểm hệ số 3	163	3	\N	2025-05-11 12:12:11.581711
983	Điểm hệ số 1 #1	164	1	\N	2025-05-11 12:12:11.581711
984	Điểm hệ số 1 #2	164	1	\N	2025-05-11 12:12:11.581711
985	Điểm hệ số 1 #3	164	1	\N	2025-05-11 12:12:11.581711
986	Điểm hệ số 2 #1	164	2	\N	2025-05-11 12:12:11.582709
987	Điểm hệ số 2 #2	164	2	\N	2025-05-11 12:12:11.582709
988	Điểm hệ số 3	164	3	\N	2025-05-11 12:12:11.582709
989	Điểm hệ số 1 #1	165	1	\N	2025-05-11 12:12:11.582709
990	Điểm hệ số 1 #2	165	1	\N	2025-05-11 12:12:11.582709
991	Điểm hệ số 1 #3	165	1	\N	2025-05-11 12:12:11.582709
992	Điểm hệ số 2 #1	165	2	\N	2025-05-11 12:12:11.582709
993	Điểm hệ số 2 #2	165	2	\N	2025-05-11 12:12:11.582709
994	Điểm hệ số 3	165	3	\N	2025-05-11 12:12:11.582709
995	Điểm hệ số 1 #1	166	1	\N	2025-05-11 12:12:11.582709
996	Điểm hệ số 1 #2	166	1	\N	2025-05-11 12:12:11.582709
997	Điểm hệ số 1 #3	166	1	\N	2025-05-11 12:12:11.582709
998	Điểm hệ số 2 #1	166	2	\N	2025-05-11 12:12:11.582709
999	Điểm hệ số 2 #2	166	2	\N	2025-05-11 12:12:11.582709
1000	Điểm hệ số 3	166	3	\N	2025-05-11 12:12:11.582709
1001	Điểm hệ số 1 #1	167	1	\N	2025-05-11 12:12:11.582709
1002	Điểm hệ số 1 #2	167	1	\N	2025-05-11 12:12:11.582709
1003	Điểm hệ số 1 #3	167	1	\N	2025-05-11 12:12:11.582709
1004	Điểm hệ số 2 #1	167	2	\N	2025-05-11 12:12:11.582709
1005	Điểm hệ số 2 #2	167	2	\N	2025-05-11 12:12:11.582709
1006	Điểm hệ số 3	167	3	\N	2025-05-11 12:12:11.582709
1007	Điểm hệ số 1 #1	168	1	\N	2025-05-11 12:12:11.582709
1008	Điểm hệ số 1 #2	168	1	\N	2025-05-11 12:12:11.582709
1009	Điểm hệ số 1 #3	168	1	\N	2025-05-11 12:12:11.582709
1010	Điểm hệ số 2 #1	168	2	\N	2025-05-11 12:12:11.582709
1011	Điểm hệ số 2 #2	168	2	\N	2025-05-11 12:12:11.582709
1012	Điểm hệ số 3	168	3	\N	2025-05-11 12:12:11.582709
1013	Điểm hệ số 1 #1	169	1	\N	2025-05-11 12:12:11.582709
1014	Điểm hệ số 1 #2	169	1	\N	2025-05-11 12:12:11.582709
1015	Điểm hệ số 1 #3	169	1	\N	2025-05-11 12:12:11.582709
1016	Điểm hệ số 2 #1	169	2	\N	2025-05-11 12:12:11.582709
1017	Điểm hệ số 2 #2	169	2	\N	2025-05-11 12:12:11.582709
1018	Điểm hệ số 3	169	3	\N	2025-05-11 12:12:11.582709
1019	Điểm hệ số 1 #1	170	1	\N	2025-05-11 12:12:11.582709
1020	Điểm hệ số 1 #2	170	1	\N	2025-05-11 12:12:11.582709
1021	Điểm hệ số 1 #3	170	1	\N	2025-05-11 12:12:11.582709
1022	Điểm hệ số 2 #1	170	2	\N	2025-05-11 12:12:11.582709
1023	Điểm hệ số 2 #2	170	2	\N	2025-05-11 12:12:11.582709
1024	Điểm hệ số 3	170	3	\N	2025-05-11 12:12:11.582709
1025	Điểm hệ số 1 #1	171	1	\N	2025-05-11 12:12:11.582709
1026	Điểm hệ số 1 #2	171	1	\N	2025-05-11 12:12:11.582709
1027	Điểm hệ số 1 #3	171	1	\N	2025-05-11 12:12:11.582709
1028	Điểm hệ số 2 #1	171	2	\N	2025-05-11 12:12:11.582709
1029	Điểm hệ số 2 #2	171	2	\N	2025-05-11 12:12:11.582709
1030	Điểm hệ số 3	171	3	\N	2025-05-11 12:12:11.582709
1031	Điểm hệ số 1 #1	172	1	\N	2025-05-11 12:12:11.582709
1032	Điểm hệ số 1 #2	172	1	\N	2025-05-11 12:12:11.582709
1033	Điểm hệ số 1 #3	172	1	\N	2025-05-11 12:12:11.582709
1034	Điểm hệ số 2 #1	172	2	\N	2025-05-11 12:12:11.582709
1035	Điểm hệ số 2 #2	172	2	\N	2025-05-11 12:12:11.582709
1036	Điểm hệ số 3	172	3	\N	2025-05-11 12:12:11.582709
1037	Điểm hệ số 1 #1	173	1	\N	2025-05-11 12:12:11.582709
1038	Điểm hệ số 1 #2	173	1	\N	2025-05-11 12:12:11.582709
1039	Điểm hệ số 1 #3	173	1	\N	2025-05-11 12:12:11.582709
1040	Điểm hệ số 2 #1	173	2	\N	2025-05-11 12:12:11.582709
1041	Điểm hệ số 2 #2	173	2	\N	2025-05-11 12:12:11.582709
1042	Điểm hệ số 3	173	3	\N	2025-05-11 12:12:11.582709
1043	Điểm hệ số 1 #1	174	1	\N	2025-05-11 12:12:11.582709
1044	Điểm hệ số 1 #2	174	1	\N	2025-05-11 12:12:11.582709
1045	Điểm hệ số 1 #3	174	1	\N	2025-05-11 12:12:11.582709
1046	Điểm hệ số 2 #1	174	2	\N	2025-05-11 12:12:11.582709
1047	Điểm hệ số 2 #2	174	2	\N	2025-05-11 12:12:11.582709
1048	Điểm hệ số 3	174	3	\N	2025-05-11 12:12:11.582709
1049	Điểm hệ số 1 #1	175	1	\N	2025-05-11 12:12:11.582709
1050	Điểm hệ số 1 #2	175	1	\N	2025-05-11 12:12:11.582709
1051	Điểm hệ số 1 #3	175	1	\N	2025-05-11 12:12:11.582709
1052	Điểm hệ số 2 #1	175	2	\N	2025-05-11 12:12:11.582709
1053	Điểm hệ số 2 #2	175	2	\N	2025-05-11 12:12:11.582709
1054	Điểm hệ số 3	175	3	\N	2025-05-11 12:12:11.582709
1055	Điểm hệ số 1 #1	176	1	\N	2025-05-11 12:12:11.582709
1056	Điểm hệ số 1 #2	176	1	\N	2025-05-11 12:12:11.582709
1057	Điểm hệ số 1 #3	176	1	\N	2025-05-11 12:12:11.582709
1058	Điểm hệ số 2 #1	176	2	\N	2025-05-11 12:12:11.582709
1059	Điểm hệ số 2 #2	176	2	\N	2025-05-11 12:12:11.582709
1060	Điểm hệ số 3	176	3	\N	2025-05-11 12:12:11.582709
1061	Điểm hệ số 1 #1	177	1	\N	2025-05-11 12:12:11.582709
1062	Điểm hệ số 1 #2	177	1	\N	2025-05-11 12:12:11.582709
1063	Điểm hệ số 1 #3	177	1	\N	2025-05-11 12:12:11.582709
1064	Điểm hệ số 2 #1	177	2	\N	2025-05-11 12:12:11.582709
1065	Điểm hệ số 2 #2	177	2	\N	2025-05-11 12:12:11.582709
1066	Điểm hệ số 3	177	3	\N	2025-05-11 12:12:11.582709
1067	Điểm hệ số 1 #1	178	1	\N	2025-05-11 12:12:11.582709
1068	Điểm hệ số 1 #2	178	1	\N	2025-05-11 12:12:11.582709
1069	Điểm hệ số 1 #3	178	1	\N	2025-05-11 12:12:11.582709
1070	Điểm hệ số 2 #1	178	2	\N	2025-05-11 12:12:11.582709
1071	Điểm hệ số 2 #2	178	2	\N	2025-05-11 12:12:11.582709
1072	Điểm hệ số 3	178	3	\N	2025-05-11 12:12:11.582709
1073	Điểm hệ số 1 #1	179	1	\N	2025-05-11 12:12:11.582709
1074	Điểm hệ số 1 #2	179	1	\N	2025-05-11 12:12:11.582709
1075	Điểm hệ số 1 #3	179	1	\N	2025-05-11 12:12:11.582709
1076	Điểm hệ số 2 #1	179	2	\N	2025-05-11 12:12:11.582709
1077	Điểm hệ số 2 #2	179	2	\N	2025-05-11 12:12:11.582709
1078	Điểm hệ số 3	179	3	\N	2025-05-11 12:12:11.582709
1079	Điểm hệ số 1 #1	180	1	\N	2025-05-11 12:12:11.582709
1080	Điểm hệ số 1 #2	180	1	\N	2025-05-11 12:12:11.582709
1081	Điểm hệ số 1 #3	180	1	\N	2025-05-11 12:12:11.582709
1082	Điểm hệ số 2 #1	180	2	\N	2025-05-11 12:12:11.582709
1083	Điểm hệ số 2 #2	180	2	\N	2025-05-11 12:12:11.582709
1084	Điểm hệ số 3	180	3	\N	2025-05-11 12:12:11.582709
1085	Điểm hệ số 1 #1	181	1	\N	2025-05-11 12:12:11.582709
1086	Điểm hệ số 1 #2	181	1	\N	2025-05-11 12:12:11.582709
1087	Điểm hệ số 1 #3	181	1	\N	2025-05-11 12:12:11.582709
1088	Điểm hệ số 2 #1	181	2	\N	2025-05-11 12:12:11.582709
1089	Điểm hệ số 2 #2	181	2	\N	2025-05-11 12:12:11.582709
1090	Điểm hệ số 3	181	3	\N	2025-05-11 12:12:11.582709
1091	Điểm hệ số 1 #1	182	1	\N	2025-05-11 12:12:11.582709
1092	Điểm hệ số 1 #2	182	1	\N	2025-05-11 12:12:11.582709
1093	Điểm hệ số 1 #3	182	1	\N	2025-05-11 12:12:11.582709
1094	Điểm hệ số 2 #1	182	2	\N	2025-05-11 12:12:11.582709
1095	Điểm hệ số 2 #2	182	2	\N	2025-05-11 12:12:11.582709
1096	Điểm hệ số 3	182	3	\N	2025-05-11 12:12:11.582709
1097	Điểm hệ số 1 #1	183	1	\N	2025-05-11 12:12:11.582709
1098	Điểm hệ số 1 #2	183	1	\N	2025-05-11 12:12:11.582709
1099	Điểm hệ số 1 #3	183	1	\N	2025-05-11 12:12:11.582709
1100	Điểm hệ số 2 #1	183	2	\N	2025-05-11 12:12:11.582709
1101	Điểm hệ số 2 #2	183	2	\N	2025-05-11 12:12:11.582709
1102	Điểm hệ số 3	183	3	\N	2025-05-11 12:12:11.582709
1103	Điểm hệ số 1 #1	184	1	\N	2025-05-11 12:12:11.582709
1104	Điểm hệ số 1 #2	184	1	\N	2025-05-11 12:12:11.582709
1105	Điểm hệ số 1 #3	184	1	\N	2025-05-11 12:12:11.582709
1106	Điểm hệ số 2 #1	184	2	\N	2025-05-11 12:12:11.582709
1107	Điểm hệ số 2 #2	184	2	\N	2025-05-11 12:12:11.582709
1108	Điểm hệ số 3	184	3	\N	2025-05-11 12:12:11.582709
1109	Điểm hệ số 1 #1	185	1	\N	2025-05-11 12:12:11.582709
1110	Điểm hệ số 1 #2	185	1	\N	2025-05-11 12:12:11.582709
1111	Điểm hệ số 1 #3	185	1	\N	2025-05-11 12:12:11.582709
1112	Điểm hệ số 2 #1	185	2	\N	2025-05-11 12:12:11.582709
1113	Điểm hệ số 2 #2	185	2	\N	2025-05-11 12:12:11.582709
1114	Điểm hệ số 3	185	3	\N	2025-05-11 12:12:11.582709
1115	Điểm hệ số 1 #1	186	1	\N	2025-05-11 12:12:11.582709
1116	Điểm hệ số 1 #2	186	1	\N	2025-05-11 12:12:11.582709
1117	Điểm hệ số 1 #3	186	1	\N	2025-05-11 12:12:11.582709
1118	Điểm hệ số 2 #1	186	2	\N	2025-05-11 12:12:11.582709
1119	Điểm hệ số 2 #2	186	2	\N	2025-05-11 12:12:11.582709
1120	Điểm hệ số 3	186	3	\N	2025-05-11 12:12:11.582709
1121	Điểm hệ số 1 #1	187	1	\N	2025-05-11 12:12:11.582709
1122	Điểm hệ số 1 #2	187	1	\N	2025-05-11 12:12:11.582709
1123	Điểm hệ số 1 #3	187	1	\N	2025-05-11 12:12:11.582709
1124	Điểm hệ số 2 #1	187	2	\N	2025-05-11 12:12:11.582709
1125	Điểm hệ số 2 #2	187	2	\N	2025-05-11 12:12:11.582709
1126	Điểm hệ số 3	187	3	\N	2025-05-11 12:12:11.582709
1127	Điểm hệ số 1 #1	188	1	\N	2025-05-11 12:12:11.582709
1128	Điểm hệ số 1 #2	188	1	\N	2025-05-11 12:12:11.582709
1129	Điểm hệ số 1 #3	188	1	\N	2025-05-11 12:12:11.582709
1130	Điểm hệ số 2 #1	188	2	\N	2025-05-11 12:12:11.582709
1131	Điểm hệ số 2 #2	188	2	\N	2025-05-11 12:12:11.582709
1132	Điểm hệ số 3	188	3	\N	2025-05-11 12:12:11.582709
1133	Điểm hệ số 1 #1	189	1	\N	2025-05-11 12:12:11.582709
1134	Điểm hệ số 1 #2	189	1	\N	2025-05-11 12:12:11.582709
1135	Điểm hệ số 1 #3	189	1	\N	2025-05-11 12:12:11.582709
1136	Điểm hệ số 2 #1	189	2	\N	2025-05-11 12:12:11.582709
1137	Điểm hệ số 2 #2	189	2	\N	2025-05-11 12:12:11.582709
1138	Điểm hệ số 3	189	3	\N	2025-05-11 12:12:11.582709
1139	Điểm hệ số 1 #1	190	1	\N	2025-05-11 12:12:11.582709
1140	Điểm hệ số 1 #2	190	1	\N	2025-05-11 12:12:11.582709
1141	Điểm hệ số 1 #3	190	1	\N	2025-05-11 12:12:11.582709
1142	Điểm hệ số 2 #1	190	2	\N	2025-05-11 12:12:11.582709
1143	Điểm hệ số 2 #2	190	2	\N	2025-05-11 12:12:11.582709
1144	Điểm hệ số 3	190	3	\N	2025-05-11 12:12:11.582709
1145	Điểm hệ số 1 #1	191	1	\N	2025-05-11 12:12:11.582709
1146	Điểm hệ số 1 #2	191	1	\N	2025-05-11 12:12:11.582709
1147	Điểm hệ số 1 #3	191	1	\N	2025-05-11 12:12:11.582709
1148	Điểm hệ số 2 #1	191	2	\N	2025-05-11 12:12:11.582709
1149	Điểm hệ số 2 #2	191	2	\N	2025-05-11 12:12:11.582709
1150	Điểm hệ số 3	191	3	\N	2025-05-11 12:12:11.582709
1151	Điểm hệ số 1 #1	192	1	\N	2025-05-11 12:12:11.582709
1152	Điểm hệ số 1 #2	192	1	\N	2025-05-11 12:12:11.582709
1153	Điểm hệ số 1 #3	192	1	\N	2025-05-11 12:12:11.582709
1154	Điểm hệ số 2 #1	192	2	\N	2025-05-11 12:12:11.582709
1155	Điểm hệ số 2 #2	192	2	\N	2025-05-11 12:12:11.582709
1156	Điểm hệ số 3	192	3	\N	2025-05-11 12:12:11.582709
1157	Điểm hệ số 1 #1	193	1	\N	2025-05-11 12:12:11.582709
1158	Điểm hệ số 1 #2	193	1	\N	2025-05-11 12:12:11.582709
1159	Điểm hệ số 1 #3	193	1	\N	2025-05-11 12:12:11.582709
1160	Điểm hệ số 2 #1	193	2	\N	2025-05-11 12:12:11.582709
1161	Điểm hệ số 2 #2	193	2	\N	2025-05-11 12:12:11.582709
1162	Điểm hệ số 3	193	3	\N	2025-05-11 12:12:11.582709
1163	Điểm hệ số 1 #1	194	1	\N	2025-05-11 12:12:11.582709
1164	Điểm hệ số 1 #2	194	1	\N	2025-05-11 12:12:11.582709
1165	Điểm hệ số 1 #3	194	1	\N	2025-05-11 12:12:11.582709
1166	Điểm hệ số 2 #1	194	2	\N	2025-05-11 12:12:11.582709
1167	Điểm hệ số 2 #2	194	2	\N	2025-05-11 12:12:11.582709
1168	Điểm hệ số 3	194	3	\N	2025-05-11 12:12:11.582709
1169	Điểm hệ số 1 #1	195	1	\N	2025-05-11 12:12:11.582709
1170	Điểm hệ số 1 #2	195	1	\N	2025-05-11 12:12:11.582709
1171	Điểm hệ số 1 #3	195	1	\N	2025-05-11 12:12:11.582709
1172	Điểm hệ số 2 #1	195	2	\N	2025-05-11 12:12:11.582709
1173	Điểm hệ số 2 #2	195	2	\N	2025-05-11 12:12:11.582709
1174	Điểm hệ số 3	195	3	\N	2025-05-11 12:12:11.582709
1175	Điểm hệ số 1 #1	196	1	\N	2025-05-11 12:12:11.582709
1176	Điểm hệ số 1 #2	196	1	\N	2025-05-11 12:12:11.582709
1177	Điểm hệ số 1 #3	196	1	\N	2025-05-11 12:12:11.582709
1178	Điểm hệ số 2 #1	196	2	\N	2025-05-11 12:12:11.582709
1179	Điểm hệ số 2 #2	196	2	\N	2025-05-11 12:12:11.582709
1180	Điểm hệ số 3	196	3	\N	2025-05-11 12:12:11.582709
1181	Điểm hệ số 1 #1	197	1	\N	2025-05-11 12:12:11.582709
1182	Điểm hệ số 1 #2	197	1	\N	2025-05-11 12:12:11.582709
1183	Điểm hệ số 1 #3	197	1	\N	2025-05-11 12:12:11.582709
1184	Điểm hệ số 2 #1	197	2	\N	2025-05-11 12:12:11.582709
1185	Điểm hệ số 2 #2	197	2	\N	2025-05-11 12:12:11.582709
1186	Điểm hệ số 3	197	3	\N	2025-05-11 12:12:11.582709
1187	Điểm hệ số 1 #1	198	1	\N	2025-05-11 12:12:11.582709
1188	Điểm hệ số 1 #2	198	1	\N	2025-05-11 12:12:11.582709
1189	Điểm hệ số 1 #3	198	1	\N	2025-05-11 12:12:11.582709
1190	Điểm hệ số 2 #1	198	2	\N	2025-05-11 12:12:11.582709
1191	Điểm hệ số 2 #2	198	2	\N	2025-05-11 12:12:11.582709
1192	Điểm hệ số 3	198	3	\N	2025-05-11 12:12:11.582709
1193	Điểm hệ số 1 #1	199	1	\N	2025-05-11 12:12:11.582709
1194	Điểm hệ số 1 #2	199	1	\N	2025-05-11 12:12:11.582709
1195	Điểm hệ số 1 #3	199	1	\N	2025-05-11 12:12:11.582709
1196	Điểm hệ số 2 #1	199	2	\N	2025-05-11 12:12:11.582709
1197	Điểm hệ số 2 #2	199	2	\N	2025-05-11 12:12:11.582709
1198	Điểm hệ số 3	199	3	\N	2025-05-11 12:12:11.582709
1199	Điểm hệ số 1 #1	200	1	\N	2025-05-11 12:12:11.582709
1200	Điểm hệ số 1 #2	200	1	\N	2025-05-11 12:12:11.582709
1201	Điểm hệ số 1 #3	200	1	\N	2025-05-11 12:12:11.582709
1202	Điểm hệ số 2 #1	200	2	\N	2025-05-11 12:12:11.582709
1203	Điểm hệ số 2 #2	200	2	\N	2025-05-11 12:12:11.582709
1204	Điểm hệ số 3	200	3	\N	2025-05-11 12:12:11.582709
1205	Điểm hệ số 1 #1	201	1	\N	2025-05-11 12:12:11.582709
1206	Điểm hệ số 1 #2	201	1	\N	2025-05-11 12:12:11.582709
1207	Điểm hệ số 1 #3	201	1	\N	2025-05-11 12:12:11.582709
1208	Điểm hệ số 2 #1	201	2	\N	2025-05-11 12:12:11.582709
1209	Điểm hệ số 2 #2	201	2	\N	2025-05-11 12:12:11.582709
1210	Điểm hệ số 3	201	3	\N	2025-05-11 12:12:11.582709
1211	Điểm hệ số 1 #1	202	1	\N	2025-05-11 12:12:11.582709
1212	Điểm hệ số 1 #2	202	1	\N	2025-05-11 12:12:11.582709
1213	Điểm hệ số 1 #3	202	1	\N	2025-05-11 12:12:11.582709
1214	Điểm hệ số 2 #1	202	2	\N	2025-05-11 12:12:11.583709
1215	Điểm hệ số 2 #2	202	2	\N	2025-05-11 12:12:11.583709
1216	Điểm hệ số 3	202	3	\N	2025-05-11 12:12:11.583709
1217	Điểm hệ số 1 #1	203	1	\N	2025-05-11 12:12:11.583709
1218	Điểm hệ số 1 #2	203	1	\N	2025-05-11 12:12:11.583709
1219	Điểm hệ số 1 #3	203	1	\N	2025-05-11 12:12:11.583709
1220	Điểm hệ số 2 #1	203	2	\N	2025-05-11 12:12:11.583709
1221	Điểm hệ số 2 #2	203	2	\N	2025-05-11 12:12:11.583709
1222	Điểm hệ số 3	203	3	\N	2025-05-11 12:12:11.583709
1223	Điểm hệ số 1 #1	204	1	\N	2025-05-11 12:12:11.583709
1224	Điểm hệ số 1 #2	204	1	\N	2025-05-11 12:12:11.583709
1225	Điểm hệ số 1 #3	204	1	\N	2025-05-11 12:12:11.583709
1226	Điểm hệ số 2 #1	204	2	\N	2025-05-11 12:12:11.583709
1227	Điểm hệ số 2 #2	204	2	\N	2025-05-11 12:12:11.583709
1228	Điểm hệ số 3	204	3	\N	2025-05-11 12:12:11.583709
1229	Điểm hệ số 1 #1	205	1	\N	2025-05-11 12:12:11.583709
1230	Điểm hệ số 1 #2	205	1	\N	2025-05-11 12:12:11.583709
1231	Điểm hệ số 1 #3	205	1	\N	2025-05-11 12:12:11.583709
1232	Điểm hệ số 2 #1	205	2	\N	2025-05-11 12:12:11.583709
1233	Điểm hệ số 2 #2	205	2	\N	2025-05-11 12:12:11.583709
1234	Điểm hệ số 3	205	3	\N	2025-05-11 12:12:11.583709
1235	Điểm hệ số 1 #1	206	1	\N	2025-05-11 12:12:11.583709
1236	Điểm hệ số 1 #2	206	1	\N	2025-05-11 12:12:11.583709
1237	Điểm hệ số 1 #3	206	1	\N	2025-05-11 12:12:11.583709
1238	Điểm hệ số 2 #1	206	2	\N	2025-05-11 12:12:11.583709
1239	Điểm hệ số 2 #2	206	2	\N	2025-05-11 12:12:11.583709
1240	Điểm hệ số 3	206	3	\N	2025-05-11 12:12:11.583709
1241	Điểm hệ số 1 #1	207	1	\N	2025-05-11 12:12:11.583709
1242	Điểm hệ số 1 #2	207	1	\N	2025-05-11 12:12:11.583709
1243	Điểm hệ số 1 #3	207	1	\N	2025-05-11 12:12:11.583709
1244	Điểm hệ số 2 #1	207	2	\N	2025-05-11 12:12:11.583709
1245	Điểm hệ số 2 #2	207	2	\N	2025-05-11 12:12:11.583709
1246	Điểm hệ số 3	207	3	\N	2025-05-11 12:12:11.583709
1247	Điểm hệ số 1 #1	208	1	\N	2025-05-11 12:12:11.583709
1248	Điểm hệ số 1 #2	208	1	\N	2025-05-11 12:12:11.583709
1249	Điểm hệ số 1 #3	208	1	\N	2025-05-11 12:12:11.583709
1250	Điểm hệ số 2 #1	208	2	\N	2025-05-11 12:12:11.583709
1251	Điểm hệ số 2 #2	208	2	\N	2025-05-11 12:12:11.583709
1252	Điểm hệ số 3	208	3	\N	2025-05-11 12:12:11.583709
1253	Điểm hệ số 1 #1	209	1	\N	2025-05-11 12:12:11.583709
1254	Điểm hệ số 1 #2	209	1	\N	2025-05-11 12:12:11.583709
1255	Điểm hệ số 1 #3	209	1	\N	2025-05-11 12:12:11.583709
1256	Điểm hệ số 2 #1	209	2	\N	2025-05-11 12:12:11.583709
1257	Điểm hệ số 2 #2	209	2	\N	2025-05-11 12:12:11.583709
1258	Điểm hệ số 3	209	3	\N	2025-05-11 12:12:11.583709
1259	Điểm hệ số 1 #1	210	1	\N	2025-05-11 12:12:11.583709
1260	Điểm hệ số 1 #2	210	1	\N	2025-05-11 12:12:11.583709
1261	Điểm hệ số 1 #3	210	1	\N	2025-05-11 12:12:11.583709
1262	Điểm hệ số 2 #1	210	2	\N	2025-05-11 12:12:11.583709
1263	Điểm hệ số 2 #2	210	2	\N	2025-05-11 12:12:11.583709
1264	Điểm hệ số 3	210	3	\N	2025-05-11 12:12:11.583709
1265	Điểm hệ số 1 #1	211	1	\N	2025-05-11 12:12:11.583709
1266	Điểm hệ số 1 #2	211	1	\N	2025-05-11 12:12:11.583709
1267	Điểm hệ số 1 #3	211	1	\N	2025-05-11 12:12:11.583709
1268	Điểm hệ số 2 #1	211	2	\N	2025-05-11 12:12:11.583709
1269	Điểm hệ số 2 #2	211	2	\N	2025-05-11 12:12:11.583709
1270	Điểm hệ số 3	211	3	\N	2025-05-11 12:12:11.583709
1271	Điểm hệ số 1 #1	212	1	\N	2025-05-11 12:12:11.583709
1272	Điểm hệ số 1 #2	212	1	\N	2025-05-11 12:12:11.583709
1273	Điểm hệ số 1 #3	212	1	\N	2025-05-11 12:12:11.583709
1274	Điểm hệ số 2 #1	212	2	\N	2025-05-11 12:12:11.583709
1275	Điểm hệ số 2 #2	212	2	\N	2025-05-11 12:12:11.583709
1276	Điểm hệ số 3	212	3	\N	2025-05-11 12:12:11.583709
1277	Điểm hệ số 1 #1	213	1	\N	2025-05-11 12:12:11.583709
1278	Điểm hệ số 1 #2	213	1	\N	2025-05-11 12:12:11.583709
1279	Điểm hệ số 1 #3	213	1	\N	2025-05-11 12:12:11.583709
1280	Điểm hệ số 2 #1	213	2	\N	2025-05-11 12:12:11.583709
1281	Điểm hệ số 2 #2	213	2	\N	2025-05-11 12:12:11.583709
1282	Điểm hệ số 3	213	3	\N	2025-05-11 12:12:11.583709
1283	Điểm hệ số 1 #1	214	1	\N	2025-05-11 12:12:11.583709
1284	Điểm hệ số 1 #2	214	1	\N	2025-05-11 12:12:11.583709
1285	Điểm hệ số 1 #3	214	1	\N	2025-05-11 12:12:11.583709
1286	Điểm hệ số 2 #1	214	2	\N	2025-05-11 12:12:11.583709
1287	Điểm hệ số 2 #2	214	2	\N	2025-05-11 12:12:11.583709
1288	Điểm hệ số 3	214	3	\N	2025-05-11 12:12:11.583709
1289	Điểm hệ số 1 #1	215	1	\N	2025-05-11 12:12:11.583709
1290	Điểm hệ số 1 #2	215	1	\N	2025-05-11 12:12:11.583709
1291	Điểm hệ số 1 #3	215	1	\N	2025-05-11 12:12:11.583709
1292	Điểm hệ số 2 #1	215	2	\N	2025-05-11 12:12:11.583709
1293	Điểm hệ số 2 #2	215	2	\N	2025-05-11 12:12:11.583709
1294	Điểm hệ số 3	215	3	\N	2025-05-11 12:12:11.583709
1295	Điểm hệ số 1 #1	216	1	\N	2025-05-11 12:12:11.583709
1296	Điểm hệ số 1 #2	216	1	\N	2025-05-11 12:12:11.583709
1297	Điểm hệ số 1 #3	216	1	\N	2025-05-11 12:12:11.583709
1298	Điểm hệ số 2 #1	216	2	\N	2025-05-11 12:12:11.583709
1299	Điểm hệ số 2 #2	216	2	\N	2025-05-11 12:12:11.583709
1300	Điểm hệ số 3	216	3	\N	2025-05-11 12:12:11.583709
1301	Điểm hệ số 1 #1	217	1	\N	2025-05-11 12:12:11.583709
1302	Điểm hệ số 1 #2	217	1	\N	2025-05-11 12:12:11.583709
1303	Điểm hệ số 1 #3	217	1	\N	2025-05-11 12:12:11.583709
1304	Điểm hệ số 2 #1	217	2	\N	2025-05-11 12:12:11.583709
1305	Điểm hệ số 2 #2	217	2	\N	2025-05-11 12:12:11.583709
1306	Điểm hệ số 3	217	3	\N	2025-05-11 12:12:11.583709
1307	Điểm hệ số 1 #1	218	1	\N	2025-05-11 12:12:11.583709
1308	Điểm hệ số 1 #2	218	1	\N	2025-05-11 12:12:11.583709
1309	Điểm hệ số 1 #3	218	1	\N	2025-05-11 12:12:11.583709
1310	Điểm hệ số 2 #1	218	2	\N	2025-05-11 12:12:11.583709
1311	Điểm hệ số 2 #2	218	2	\N	2025-05-11 12:12:11.583709
1312	Điểm hệ số 3	218	3	\N	2025-05-11 12:12:11.583709
1313	Điểm hệ số 1 #1	219	1	\N	2025-05-11 12:12:11.583709
1314	Điểm hệ số 1 #2	219	1	\N	2025-05-11 12:12:11.583709
1315	Điểm hệ số 1 #3	219	1	\N	2025-05-11 12:12:11.583709
1316	Điểm hệ số 2 #1	219	2	\N	2025-05-11 12:12:11.583709
1317	Điểm hệ số 2 #2	219	2	\N	2025-05-11 12:12:11.583709
1318	Điểm hệ số 3	219	3	\N	2025-05-11 12:12:11.583709
1319	Điểm hệ số 1 #1	220	1	\N	2025-05-11 12:12:11.583709
1320	Điểm hệ số 1 #2	220	1	\N	2025-05-11 12:12:11.583709
1321	Điểm hệ số 1 #3	220	1	\N	2025-05-11 12:12:11.583709
1322	Điểm hệ số 2 #1	220	2	\N	2025-05-11 12:12:11.583709
1323	Điểm hệ số 2 #2	220	2	\N	2025-05-11 12:12:11.583709
1324	Điểm hệ số 3	220	3	\N	2025-05-11 12:12:11.583709
1325	Điểm hệ số 1 #1	221	1	\N	2025-05-11 12:12:11.583709
1326	Điểm hệ số 1 #2	221	1	\N	2025-05-11 12:12:11.583709
1327	Điểm hệ số 1 #3	221	1	\N	2025-05-11 12:12:11.583709
1328	Điểm hệ số 2 #1	221	2	\N	2025-05-11 12:12:11.583709
1329	Điểm hệ số 2 #2	221	2	\N	2025-05-11 12:12:11.583709
1330	Điểm hệ số 3	221	3	\N	2025-05-11 12:12:11.583709
1331	Điểm hệ số 1 #1	222	1	\N	2025-05-11 12:12:11.583709
1332	Điểm hệ số 1 #2	222	1	\N	2025-05-11 12:12:11.583709
1333	Điểm hệ số 1 #3	222	1	\N	2025-05-11 12:12:11.583709
1334	Điểm hệ số 2 #1	222	2	\N	2025-05-11 12:12:11.583709
1335	Điểm hệ số 2 #2	222	2	\N	2025-05-11 12:12:11.583709
1336	Điểm hệ số 3	222	3	\N	2025-05-11 12:12:11.583709
1337	Điểm hệ số 1 #1	223	1	\N	2025-05-11 12:12:11.583709
1338	Điểm hệ số 1 #2	223	1	\N	2025-05-11 12:12:11.583709
1339	Điểm hệ số 1 #3	223	1	\N	2025-05-11 12:12:11.583709
1340	Điểm hệ số 2 #1	223	2	\N	2025-05-11 12:12:11.583709
1341	Điểm hệ số 2 #2	223	2	\N	2025-05-11 12:12:11.583709
1342	Điểm hệ số 3	223	3	\N	2025-05-11 12:12:11.583709
1343	Điểm hệ số 1 #1	224	1	\N	2025-05-11 12:12:11.583709
1344	Điểm hệ số 1 #2	224	1	\N	2025-05-11 12:12:11.583709
1345	Điểm hệ số 1 #3	224	1	\N	2025-05-11 12:12:11.583709
1346	Điểm hệ số 2 #1	224	2	\N	2025-05-11 12:12:11.583709
1347	Điểm hệ số 2 #2	224	2	\N	2025-05-11 12:12:11.583709
1348	Điểm hệ số 3	224	3	\N	2025-05-11 12:12:11.583709
1349	Điểm hệ số 1 #1	225	1	\N	2025-05-11 12:12:11.583709
1350	Điểm hệ số 1 #2	225	1	\N	2025-05-11 12:12:11.583709
1351	Điểm hệ số 1 #3	225	1	\N	2025-05-11 12:12:11.583709
1352	Điểm hệ số 2 #1	225	2	\N	2025-05-11 12:12:11.583709
1353	Điểm hệ số 2 #2	225	2	\N	2025-05-11 12:12:11.583709
1354	Điểm hệ số 3	225	3	\N	2025-05-11 12:12:11.583709
1355	Điểm hệ số 1 #1	226	1	\N	2025-05-11 12:12:11.583709
1356	Điểm hệ số 1 #2	226	1	\N	2025-05-11 12:12:11.583709
1357	Điểm hệ số 1 #3	226	1	\N	2025-05-11 12:12:11.583709
1358	Điểm hệ số 2 #1	226	2	\N	2025-05-11 12:12:11.583709
1359	Điểm hệ số 2 #2	226	2	\N	2025-05-11 12:12:11.583709
1360	Điểm hệ số 3	226	3	\N	2025-05-11 12:12:11.583709
1361	Điểm hệ số 1 #1	227	1	\N	2025-05-11 12:12:11.583709
1362	Điểm hệ số 1 #2	227	1	\N	2025-05-11 12:12:11.583709
1363	Điểm hệ số 1 #3	227	1	\N	2025-05-11 12:12:11.583709
1364	Điểm hệ số 2 #1	227	2	\N	2025-05-11 12:12:11.583709
1365	Điểm hệ số 2 #2	227	2	\N	2025-05-11 12:12:11.583709
1366	Điểm hệ số 3	227	3	\N	2025-05-11 12:12:11.583709
1367	Điểm hệ số 1 #1	228	1	\N	2025-05-11 12:12:11.583709
1368	Điểm hệ số 1 #2	228	1	\N	2025-05-11 12:12:11.583709
1369	Điểm hệ số 1 #3	228	1	\N	2025-05-11 12:12:11.583709
1370	Điểm hệ số 2 #1	228	2	\N	2025-05-11 12:12:11.583709
1371	Điểm hệ số 2 #2	228	2	\N	2025-05-11 12:12:11.583709
1372	Điểm hệ số 3	228	3	\N	2025-05-11 12:12:11.583709
1373	Điểm hệ số 1 #1	229	1	\N	2025-05-11 12:12:11.583709
1374	Điểm hệ số 1 #2	229	1	\N	2025-05-11 12:12:11.583709
1375	Điểm hệ số 1 #3	229	1	\N	2025-05-11 12:12:11.583709
1376	Điểm hệ số 2 #1	229	2	\N	2025-05-11 12:12:11.583709
1377	Điểm hệ số 2 #2	229	2	\N	2025-05-11 12:12:11.583709
1378	Điểm hệ số 3	229	3	\N	2025-05-11 12:12:11.583709
1379	Điểm hệ số 1 #1	230	1	\N	2025-05-11 12:12:11.583709
1380	Điểm hệ số 1 #2	230	1	\N	2025-05-11 12:12:11.583709
1381	Điểm hệ số 1 #3	230	1	\N	2025-05-11 12:12:11.583709
1382	Điểm hệ số 2 #1	230	2	\N	2025-05-11 12:12:11.583709
1383	Điểm hệ số 2 #2	230	2	\N	2025-05-11 12:12:11.583709
1384	Điểm hệ số 3	230	3	\N	2025-05-11 12:12:11.583709
1385	Điểm hệ số 1 #1	231	1	\N	2025-05-11 12:12:11.583709
1386	Điểm hệ số 1 #2	231	1	\N	2025-05-11 12:12:11.583709
1387	Điểm hệ số 1 #3	231	1	\N	2025-05-11 12:12:11.583709
1388	Điểm hệ số 2 #1	231	2	\N	2025-05-11 12:12:11.583709
1389	Điểm hệ số 2 #2	231	2	\N	2025-05-11 12:12:11.583709
1390	Điểm hệ số 3	231	3	\N	2025-05-11 12:12:11.583709
1391	Điểm hệ số 1 #1	232	1	\N	2025-05-11 12:12:11.583709
1392	Điểm hệ số 1 #2	232	1	\N	2025-05-11 12:12:11.583709
1393	Điểm hệ số 1 #3	232	1	\N	2025-05-11 12:12:11.583709
1394	Điểm hệ số 2 #1	232	2	\N	2025-05-11 12:12:11.583709
1395	Điểm hệ số 2 #2	232	2	\N	2025-05-11 12:12:11.583709
1396	Điểm hệ số 3	232	3	\N	2025-05-11 12:12:11.583709
1397	Điểm hệ số 1 #1	233	1	\N	2025-05-11 12:12:11.583709
1398	Điểm hệ số 1 #2	233	1	\N	2025-05-11 12:12:11.583709
1399	Điểm hệ số 1 #3	233	1	\N	2025-05-11 12:12:11.583709
1400	Điểm hệ số 2 #1	233	2	\N	2025-05-11 12:12:11.583709
1401	Điểm hệ số 2 #2	233	2	\N	2025-05-11 12:12:11.583709
1402	Điểm hệ số 3	233	3	\N	2025-05-11 12:12:11.583709
1403	Điểm hệ số 1 #1	234	1	\N	2025-05-11 12:12:11.583709
1404	Điểm hệ số 1 #2	234	1	\N	2025-05-11 12:12:11.583709
1405	Điểm hệ số 1 #3	234	1	\N	2025-05-11 12:12:11.583709
1406	Điểm hệ số 2 #1	234	2	\N	2025-05-11 12:12:11.583709
1407	Điểm hệ số 2 #2	234	2	\N	2025-05-11 12:12:11.583709
1408	Điểm hệ số 3	234	3	\N	2025-05-11 12:12:11.583709
1409	Điểm hệ số 1 #1	235	1	\N	2025-05-11 12:12:11.583709
1410	Điểm hệ số 1 #2	235	1	\N	2025-05-11 12:12:11.583709
1411	Điểm hệ số 1 #3	235	1	\N	2025-05-11 12:12:11.583709
1412	Điểm hệ số 2 #1	235	2	\N	2025-05-11 12:12:11.583709
1413	Điểm hệ số 2 #2	235	2	\N	2025-05-11 12:12:11.583709
1414	Điểm hệ số 3	235	3	\N	2025-05-11 12:12:11.583709
1415	Điểm hệ số 1 #1	236	1	\N	2025-05-11 12:12:11.583709
1416	Điểm hệ số 1 #2	236	1	\N	2025-05-11 12:12:11.583709
1417	Điểm hệ số 1 #3	236	1	\N	2025-05-11 12:12:11.583709
1418	Điểm hệ số 2 #1	236	2	\N	2025-05-11 12:12:11.583709
1419	Điểm hệ số 2 #2	236	2	\N	2025-05-11 12:12:11.583709
1420	Điểm hệ số 3	236	3	\N	2025-05-11 12:12:11.583709
1421	Điểm hệ số 1 #1	237	1	\N	2025-05-11 12:12:11.583709
1422	Điểm hệ số 1 #2	237	1	\N	2025-05-11 12:12:11.583709
1423	Điểm hệ số 1 #3	237	1	\N	2025-05-11 12:12:11.583709
1424	Điểm hệ số 2 #1	237	2	\N	2025-05-11 12:12:11.583709
1425	Điểm hệ số 2 #2	237	2	\N	2025-05-11 12:12:11.583709
1426	Điểm hệ số 3	237	3	\N	2025-05-11 12:12:11.583709
1427	Điểm hệ số 1 #1	238	1	\N	2025-05-11 12:12:11.583709
1428	Điểm hệ số 1 #2	238	1	\N	2025-05-11 12:12:11.583709
1429	Điểm hệ số 1 #3	238	1	\N	2025-05-11 12:12:11.583709
1430	Điểm hệ số 2 #1	238	2	\N	2025-05-11 12:12:11.583709
1431	Điểm hệ số 2 #2	238	2	\N	2025-05-11 12:12:11.583709
1432	Điểm hệ số 3	238	3	\N	2025-05-11 12:12:11.583709
1433	Điểm hệ số 1 #1	239	1	\N	2025-05-11 12:12:11.583709
1434	Điểm hệ số 1 #2	239	1	\N	2025-05-11 12:12:11.583709
1435	Điểm hệ số 1 #3	239	1	\N	2025-05-11 12:12:11.583709
1436	Điểm hệ số 2 #1	239	2	\N	2025-05-11 12:12:11.583709
1437	Điểm hệ số 2 #2	239	2	\N	2025-05-11 12:12:11.583709
1438	Điểm hệ số 3	239	3	\N	2025-05-11 12:12:11.583709
1439	Điểm hệ số 1 #1	240	1	\N	2025-05-11 12:12:11.583709
1440	Điểm hệ số 1 #2	240	1	\N	2025-05-11 12:12:11.583709
1441	Điểm hệ số 1 #3	240	1	\N	2025-05-11 12:12:11.583709
1442	Điểm hệ số 2 #1	240	2	\N	2025-05-11 12:12:11.583709
1443	Điểm hệ số 2 #2	240	2	\N	2025-05-11 12:12:11.583709
1444	Điểm hệ số 3	240	3	\N	2025-05-11 12:12:11.584709
1445	Điểm hệ số 1 #1	241	1	\N	2025-05-11 12:12:11.584709
1446	Điểm hệ số 1 #2	241	1	\N	2025-05-11 12:12:11.584709
1447	Điểm hệ số 1 #3	241	1	\N	2025-05-11 12:12:11.584709
1448	Điểm hệ số 2 #1	241	2	\N	2025-05-11 12:12:11.584709
1449	Điểm hệ số 2 #2	241	2	\N	2025-05-11 12:12:11.584709
1450	Điểm hệ số 3	241	3	\N	2025-05-11 12:12:11.584709
1451	Điểm hệ số 1 #1	242	1	\N	2025-05-11 12:12:11.584709
1452	Điểm hệ số 1 #2	242	1	\N	2025-05-11 12:12:11.584709
1453	Điểm hệ số 1 #3	242	1	\N	2025-05-11 12:12:11.584709
1454	Điểm hệ số 2 #1	242	2	\N	2025-05-11 12:12:11.584709
1455	Điểm hệ số 2 #2	242	2	\N	2025-05-11 12:12:11.584709
1456	Điểm hệ số 3	242	3	\N	2025-05-11 12:12:11.584709
1457	Điểm hệ số 1 #1	243	1	\N	2025-05-11 12:12:11.584709
1458	Điểm hệ số 1 #2	243	1	\N	2025-05-11 12:12:11.584709
1459	Điểm hệ số 1 #3	243	1	\N	2025-05-11 12:12:11.584709
1460	Điểm hệ số 2 #1	243	2	\N	2025-05-11 12:12:11.584709
1461	Điểm hệ số 2 #2	243	2	\N	2025-05-11 12:12:11.584709
1462	Điểm hệ số 3	243	3	\N	2025-05-11 12:12:11.584709
1463	Điểm hệ số 1 #1	244	1	\N	2025-05-11 12:12:11.584709
1464	Điểm hệ số 1 #2	244	1	\N	2025-05-11 12:12:11.584709
1465	Điểm hệ số 1 #3	244	1	\N	2025-05-11 12:12:11.584709
1466	Điểm hệ số 2 #1	244	2	\N	2025-05-11 12:12:11.584709
1467	Điểm hệ số 2 #2	244	2	\N	2025-05-11 12:12:11.584709
1468	Điểm hệ số 3	244	3	\N	2025-05-11 12:12:11.584709
1469	Điểm hệ số 1 #1	245	1	\N	2025-05-11 12:12:11.584709
1470	Điểm hệ số 1 #2	245	1	\N	2025-05-11 12:12:11.584709
1471	Điểm hệ số 1 #3	245	1	\N	2025-05-11 12:12:11.584709
1472	Điểm hệ số 2 #1	245	2	\N	2025-05-11 12:12:11.584709
1473	Điểm hệ số 2 #2	245	2	\N	2025-05-11 12:12:11.584709
1474	Điểm hệ số 3	245	3	\N	2025-05-11 12:12:11.584709
1475	Điểm hệ số 1 #1	246	1	\N	2025-05-11 12:12:11.584709
1476	Điểm hệ số 1 #2	246	1	\N	2025-05-11 12:12:11.584709
1477	Điểm hệ số 1 #3	246	1	\N	2025-05-11 12:12:11.584709
1478	Điểm hệ số 2 #1	246	2	\N	2025-05-11 12:12:11.584709
1479	Điểm hệ số 2 #2	246	2	\N	2025-05-11 12:12:11.584709
1480	Điểm hệ số 3	246	3	\N	2025-05-11 12:12:11.584709
1481	Điểm hệ số 1 #1	247	1	\N	2025-05-11 12:12:11.584709
1482	Điểm hệ số 1 #2	247	1	\N	2025-05-11 12:12:11.584709
1483	Điểm hệ số 1 #3	247	1	\N	2025-05-11 12:12:11.584709
1484	Điểm hệ số 2 #1	247	2	\N	2025-05-11 12:12:11.584709
1485	Điểm hệ số 2 #2	247	2	\N	2025-05-11 12:12:11.584709
1486	Điểm hệ số 3	247	3	\N	2025-05-11 12:12:11.584709
1487	Điểm hệ số 1 #1	248	1	\N	2025-05-11 12:12:12.817656
1488	Điểm hệ số 1 #2	248	1	\N	2025-05-11 12:12:12.817656
1489	Điểm hệ số 1 #3	248	1	\N	2025-05-11 12:12:12.817656
1490	Điểm hệ số 2 #1	248	2	\N	2025-05-11 12:12:12.817656
1491	Điểm hệ số 2 #2	248	2	\N	2025-05-11 12:12:12.817656
1492	Điểm hệ số 3	248	3	\N	2025-05-11 12:12:12.817656
1493	Điểm hệ số 1 #1	249	1	\N	2025-05-11 12:12:12.817656
1494	Điểm hệ số 1 #2	249	1	\N	2025-05-11 12:12:12.817656
1495	Điểm hệ số 1 #3	249	1	\N	2025-05-11 12:12:12.817656
1496	Điểm hệ số 2 #1	249	2	\N	2025-05-11 12:12:12.817656
1497	Điểm hệ số 2 #2	249	2	\N	2025-05-11 12:12:12.817656
1498	Điểm hệ số 3	249	3	\N	2025-05-11 12:12:12.817656
1499	Điểm hệ số 1 #1	250	1	\N	2025-05-11 12:12:12.817656
1500	Điểm hệ số 1 #2	250	1	\N	2025-05-11 12:12:12.817656
1501	Điểm hệ số 1 #3	250	1	\N	2025-05-11 12:12:12.817656
1502	Điểm hệ số 2 #1	250	2	\N	2025-05-11 12:12:12.817656
1503	Điểm hệ số 2 #2	250	2	\N	2025-05-11 12:12:12.817656
1504	Điểm hệ số 3	250	3	\N	2025-05-11 12:12:12.817656
1505	Điểm hệ số 1 #1	251	1	\N	2025-05-11 12:12:12.817656
1506	Điểm hệ số 1 #2	251	1	\N	2025-05-11 12:12:12.817656
1507	Điểm hệ số 1 #3	251	1	\N	2025-05-11 12:12:12.817656
1508	Điểm hệ số 2 #1	251	2	\N	2025-05-11 12:12:12.817656
1509	Điểm hệ số 2 #2	251	2	\N	2025-05-11 12:12:12.817656
1510	Điểm hệ số 3	251	3	\N	2025-05-11 12:12:12.817656
1511	Điểm hệ số 1 #1	252	1	\N	2025-05-11 12:12:12.817656
1512	Điểm hệ số 1 #2	252	1	\N	2025-05-11 12:12:12.817656
1513	Điểm hệ số 1 #3	252	1	\N	2025-05-11 12:12:12.817656
1514	Điểm hệ số 2 #1	252	2	\N	2025-05-11 12:12:12.817656
1515	Điểm hệ số 2 #2	252	2	\N	2025-05-11 12:12:12.817656
1516	Điểm hệ số 3	252	3	\N	2025-05-11 12:12:12.817656
1517	Điểm hệ số 1 #1	253	1	\N	2025-05-11 12:12:12.817656
1518	Điểm hệ số 1 #2	253	1	\N	2025-05-11 12:12:12.817656
1519	Điểm hệ số 1 #3	253	1	\N	2025-05-11 12:12:12.817656
1520	Điểm hệ số 2 #1	253	2	\N	2025-05-11 12:12:12.817656
1521	Điểm hệ số 2 #2	253	2	\N	2025-05-11 12:12:12.817656
1522	Điểm hệ số 3	253	3	\N	2025-05-11 12:12:12.817656
1523	Điểm hệ số 1 #1	254	1	\N	2025-05-11 12:12:12.817656
1524	Điểm hệ số 1 #2	254	1	\N	2025-05-11 12:12:12.817656
1525	Điểm hệ số 1 #3	254	1	\N	2025-05-11 12:12:12.817656
1526	Điểm hệ số 2 #1	254	2	\N	2025-05-11 12:12:12.817656
1527	Điểm hệ số 2 #2	254	2	\N	2025-05-11 12:12:12.817656
1528	Điểm hệ số 3	254	3	\N	2025-05-11 12:12:12.817656
1529	Điểm hệ số 1 #1	255	1	\N	2025-05-11 12:12:12.817656
1530	Điểm hệ số 1 #2	255	1	\N	2025-05-11 12:12:12.817656
1531	Điểm hệ số 1 #3	255	1	\N	2025-05-11 12:12:12.817656
1532	Điểm hệ số 2 #1	255	2	\N	2025-05-11 12:12:12.817656
1533	Điểm hệ số 2 #2	255	2	\N	2025-05-11 12:12:12.817656
1534	Điểm hệ số 3	255	3	\N	2025-05-11 12:12:12.817656
1535	Điểm hệ số 1 #1	256	1	\N	2025-05-11 12:12:12.817656
1536	Điểm hệ số 1 #2	256	1	\N	2025-05-11 12:12:12.817656
1537	Điểm hệ số 1 #3	256	1	\N	2025-05-11 12:12:12.817656
1538	Điểm hệ số 2 #1	256	2	\N	2025-05-11 12:12:12.817656
1539	Điểm hệ số 2 #2	256	2	\N	2025-05-11 12:12:12.817656
1540	Điểm hệ số 3	256	3	\N	2025-05-11 12:12:12.817656
1541	Điểm hệ số 1 #1	257	1	\N	2025-05-11 12:12:12.817656
1542	Điểm hệ số 1 #2	257	1	\N	2025-05-11 12:12:12.817656
1543	Điểm hệ số 1 #3	257	1	\N	2025-05-11 12:12:12.817656
1544	Điểm hệ số 2 #1	257	2	\N	2025-05-11 12:12:12.817656
1545	Điểm hệ số 2 #2	257	2	\N	2025-05-11 12:12:12.817656
1546	Điểm hệ số 3	257	3	\N	2025-05-11 12:12:12.817656
1547	Điểm hệ số 1 #1	258	1	\N	2025-05-11 12:12:12.817656
1548	Điểm hệ số 1 #2	258	1	\N	2025-05-11 12:12:12.817656
1549	Điểm hệ số 1 #3	258	1	\N	2025-05-11 12:12:12.817656
1550	Điểm hệ số 2 #1	258	2	\N	2025-05-11 12:12:12.817656
1551	Điểm hệ số 2 #2	258	2	\N	2025-05-11 12:12:12.817656
1552	Điểm hệ số 3	258	3	\N	2025-05-11 12:12:12.817656
1553	Điểm hệ số 1 #1	259	1	\N	2025-05-11 12:12:12.817656
1554	Điểm hệ số 1 #2	259	1	\N	2025-05-11 12:12:12.817656
1555	Điểm hệ số 1 #3	259	1	\N	2025-05-11 12:12:12.817656
1556	Điểm hệ số 2 #1	259	2	\N	2025-05-11 12:12:12.817656
1557	Điểm hệ số 2 #2	259	2	\N	2025-05-11 12:12:12.817656
1558	Điểm hệ số 3	259	3	\N	2025-05-11 12:12:12.817656
1559	Điểm hệ số 1 #1	260	1	\N	2025-05-11 12:12:12.817656
1560	Điểm hệ số 1 #2	260	1	\N	2025-05-11 12:12:12.817656
1561	Điểm hệ số 1 #3	260	1	\N	2025-05-11 12:12:12.817656
1562	Điểm hệ số 2 #1	260	2	\N	2025-05-11 12:12:12.817656
1563	Điểm hệ số 2 #2	260	2	\N	2025-05-11 12:12:12.817656
1564	Điểm hệ số 3	260	3	\N	2025-05-11 12:12:12.817656
1565	Điểm hệ số 1 #1	261	1	\N	2025-05-11 12:12:12.817656
1566	Điểm hệ số 1 #2	261	1	\N	2025-05-11 12:12:12.817656
1567	Điểm hệ số 1 #3	261	1	\N	2025-05-11 12:12:12.817656
1568	Điểm hệ số 2 #1	261	2	\N	2025-05-11 12:12:12.817656
1569	Điểm hệ số 2 #2	261	2	\N	2025-05-11 12:12:12.817656
1570	Điểm hệ số 3	261	3	\N	2025-05-11 12:12:12.817656
1571	Điểm hệ số 1 #1	262	1	\N	2025-05-11 12:12:12.817656
1572	Điểm hệ số 1 #2	262	1	\N	2025-05-11 12:12:12.817656
1573	Điểm hệ số 1 #3	262	1	\N	2025-05-11 12:12:12.817656
1574	Điểm hệ số 2 #1	262	2	\N	2025-05-11 12:12:12.818658
1575	Điểm hệ số 2 #2	262	2	\N	2025-05-11 12:12:12.818658
1576	Điểm hệ số 3	262	3	\N	2025-05-11 12:12:12.818658
1577	Điểm hệ số 1 #1	263	1	\N	2025-05-11 12:12:12.818658
1578	Điểm hệ số 1 #2	263	1	\N	2025-05-11 12:12:12.818658
1579	Điểm hệ số 1 #3	263	1	\N	2025-05-11 12:12:12.818658
1580	Điểm hệ số 2 #1	263	2	\N	2025-05-11 12:12:12.818658
1581	Điểm hệ số 2 #2	263	2	\N	2025-05-11 12:12:12.818658
1582	Điểm hệ số 3	263	3	\N	2025-05-11 12:12:12.818658
1583	Điểm hệ số 1 #1	264	1	\N	2025-05-11 12:12:12.818658
1584	Điểm hệ số 1 #2	264	1	\N	2025-05-11 12:12:12.818658
1585	Điểm hệ số 1 #3	264	1	\N	2025-05-11 12:12:12.818658
1586	Điểm hệ số 2 #1	264	2	\N	2025-05-11 12:12:12.818658
1587	Điểm hệ số 2 #2	264	2	\N	2025-05-11 12:12:12.818658
1588	Điểm hệ số 3	264	3	\N	2025-05-11 12:12:12.818658
1589	Điểm hệ số 1 #1	265	1	\N	2025-05-11 12:12:12.818658
1590	Điểm hệ số 1 #2	265	1	\N	2025-05-11 12:12:12.818658
1591	Điểm hệ số 1 #3	265	1	\N	2025-05-11 12:12:12.818658
1592	Điểm hệ số 2 #1	265	2	\N	2025-05-11 12:12:12.818658
1593	Điểm hệ số 2 #2	265	2	\N	2025-05-11 12:12:12.818658
1594	Điểm hệ số 3	265	3	\N	2025-05-11 12:12:12.818658
1595	Điểm hệ số 1 #1	266	1	\N	2025-05-11 12:12:12.818658
1596	Điểm hệ số 1 #2	266	1	\N	2025-05-11 12:12:12.818658
1597	Điểm hệ số 1 #3	266	1	\N	2025-05-11 12:12:12.818658
1598	Điểm hệ số 2 #1	266	2	\N	2025-05-11 12:12:12.818658
1599	Điểm hệ số 2 #2	266	2	\N	2025-05-11 12:12:12.818658
1600	Điểm hệ số 3	266	3	\N	2025-05-11 12:12:12.818658
1601	Điểm hệ số 1 #1	267	1	\N	2025-05-11 12:12:12.818658
1602	Điểm hệ số 1 #2	267	1	\N	2025-05-11 12:12:12.818658
1603	Điểm hệ số 1 #3	267	1	\N	2025-05-11 12:12:12.818658
1604	Điểm hệ số 2 #1	267	2	\N	2025-05-11 12:12:12.818658
1605	Điểm hệ số 2 #2	267	2	\N	2025-05-11 12:12:12.818658
1606	Điểm hệ số 3	267	3	\N	2025-05-11 12:12:12.818658
1607	Điểm hệ số 1 #1	268	1	\N	2025-05-11 12:12:12.818658
1608	Điểm hệ số 1 #2	268	1	\N	2025-05-11 12:12:12.818658
1609	Điểm hệ số 1 #3	268	1	\N	2025-05-11 12:12:12.818658
1610	Điểm hệ số 2 #1	268	2	\N	2025-05-11 12:12:12.818658
1611	Điểm hệ số 2 #2	268	2	\N	2025-05-11 12:12:12.818658
1612	Điểm hệ số 3	268	3	\N	2025-05-11 12:12:12.818658
1613	Điểm hệ số 1 #1	269	1	\N	2025-05-11 12:12:12.818658
1614	Điểm hệ số 1 #2	269	1	\N	2025-05-11 12:12:12.818658
1615	Điểm hệ số 1 #3	269	1	\N	2025-05-11 12:12:12.818658
1616	Điểm hệ số 2 #1	269	2	\N	2025-05-11 12:12:12.818658
1617	Điểm hệ số 2 #2	269	2	\N	2025-05-11 12:12:12.818658
1618	Điểm hệ số 3	269	3	\N	2025-05-11 12:12:12.818658
1619	Điểm hệ số 1 #1	270	1	\N	2025-05-11 12:12:12.818658
1620	Điểm hệ số 1 #2	270	1	\N	2025-05-11 12:12:12.818658
1621	Điểm hệ số 1 #3	270	1	\N	2025-05-11 12:12:12.818658
1622	Điểm hệ số 2 #1	270	2	\N	2025-05-11 12:12:12.818658
1623	Điểm hệ số 2 #2	270	2	\N	2025-05-11 12:12:12.818658
1624	Điểm hệ số 3	270	3	\N	2025-05-11 12:12:12.818658
1625	Điểm hệ số 1 #1	271	1	\N	2025-05-11 12:12:12.818658
1626	Điểm hệ số 1 #2	271	1	\N	2025-05-11 12:12:12.818658
1627	Điểm hệ số 1 #3	271	1	\N	2025-05-11 12:12:12.818658
1628	Điểm hệ số 2 #1	271	2	\N	2025-05-11 12:12:12.818658
1629	Điểm hệ số 2 #2	271	2	\N	2025-05-11 12:12:12.818658
1630	Điểm hệ số 3	271	3	\N	2025-05-11 12:12:12.818658
1631	Điểm hệ số 1 #1	272	1	\N	2025-05-11 12:12:12.818658
1632	Điểm hệ số 1 #2	272	1	\N	2025-05-11 12:12:12.818658
1633	Điểm hệ số 1 #3	272	1	\N	2025-05-11 12:12:12.818658
1634	Điểm hệ số 2 #1	272	2	\N	2025-05-11 12:12:12.818658
1635	Điểm hệ số 2 #2	272	2	\N	2025-05-11 12:12:12.818658
1636	Điểm hệ số 3	272	3	\N	2025-05-11 12:12:12.818658
1637	Điểm hệ số 1 #1	273	1	\N	2025-05-11 12:12:12.818658
1638	Điểm hệ số 1 #2	273	1	\N	2025-05-11 12:12:12.818658
1639	Điểm hệ số 1 #3	273	1	\N	2025-05-11 12:12:12.818658
1640	Điểm hệ số 2 #1	273	2	\N	2025-05-11 12:12:12.818658
1641	Điểm hệ số 2 #2	273	2	\N	2025-05-11 12:12:12.818658
1642	Điểm hệ số 3	273	3	\N	2025-05-11 12:12:12.818658
1643	Điểm hệ số 1 #1	274	1	\N	2025-05-11 12:12:12.818658
1644	Điểm hệ số 1 #2	274	1	\N	2025-05-11 12:12:12.818658
1645	Điểm hệ số 1 #3	274	1	\N	2025-05-11 12:12:12.818658
1646	Điểm hệ số 2 #1	274	2	\N	2025-05-11 12:12:12.818658
1647	Điểm hệ số 2 #2	274	2	\N	2025-05-11 12:12:12.818658
1648	Điểm hệ số 3	274	3	\N	2025-05-11 12:12:12.818658
1649	Điểm hệ số 1 #1	275	1	\N	2025-05-11 12:12:12.818658
1650	Điểm hệ số 1 #2	275	1	\N	2025-05-11 12:12:12.818658
1651	Điểm hệ số 1 #3	275	1	\N	2025-05-11 12:12:12.818658
1652	Điểm hệ số 2 #1	275	2	\N	2025-05-11 12:12:12.818658
1653	Điểm hệ số 2 #2	275	2	\N	2025-05-11 12:12:12.818658
1654	Điểm hệ số 3	275	3	\N	2025-05-11 12:12:12.818658
1655	Điểm hệ số 1 #1	276	1	\N	2025-05-11 12:12:12.818658
1656	Điểm hệ số 1 #2	276	1	\N	2025-05-11 12:12:12.818658
1657	Điểm hệ số 1 #3	276	1	\N	2025-05-11 12:12:12.818658
1658	Điểm hệ số 2 #1	276	2	\N	2025-05-11 12:12:12.818658
1659	Điểm hệ số 2 #2	276	2	\N	2025-05-11 12:12:12.818658
1660	Điểm hệ số 3	276	3	\N	2025-05-11 12:12:12.818658
1661	Điểm hệ số 1 #1	277	1	\N	2025-05-11 12:12:12.818658
1662	Điểm hệ số 1 #2	277	1	\N	2025-05-11 12:12:12.818658
1663	Điểm hệ số 1 #3	277	1	\N	2025-05-11 12:12:12.818658
1664	Điểm hệ số 2 #1	277	2	\N	2025-05-11 12:12:12.818658
1665	Điểm hệ số 2 #2	277	2	\N	2025-05-11 12:12:12.818658
1666	Điểm hệ số 3	277	3	\N	2025-05-11 12:12:12.818658
1667	Điểm hệ số 1 #1	278	1	\N	2025-05-11 12:12:12.818658
1668	Điểm hệ số 1 #2	278	1	\N	2025-05-11 12:12:12.818658
1669	Điểm hệ số 1 #3	278	1	\N	2025-05-11 12:12:12.818658
1670	Điểm hệ số 2 #1	278	2	\N	2025-05-11 12:12:12.818658
1671	Điểm hệ số 2 #2	278	2	\N	2025-05-11 12:12:12.818658
1672	Điểm hệ số 3	278	3	\N	2025-05-11 12:12:12.818658
1673	Điểm hệ số 1 #1	279	1	\N	2025-05-11 12:12:12.818658
1674	Điểm hệ số 1 #2	279	1	\N	2025-05-11 12:12:12.818658
1675	Điểm hệ số 1 #3	279	1	\N	2025-05-11 12:12:12.818658
1676	Điểm hệ số 2 #1	279	2	\N	2025-05-11 12:12:12.818658
1677	Điểm hệ số 2 #2	279	2	\N	2025-05-11 12:12:12.818658
1678	Điểm hệ số 3	279	3	\N	2025-05-11 12:12:12.818658
1679	Điểm hệ số 1 #1	280	1	\N	2025-05-11 12:12:12.818658
1680	Điểm hệ số 1 #2	280	1	\N	2025-05-11 12:12:12.818658
1681	Điểm hệ số 1 #3	280	1	\N	2025-05-11 12:12:12.818658
1682	Điểm hệ số 2 #1	280	2	\N	2025-05-11 12:12:12.818658
1683	Điểm hệ số 2 #2	280	2	\N	2025-05-11 12:12:12.818658
1684	Điểm hệ số 3	280	3	\N	2025-05-11 12:12:12.818658
1685	Điểm hệ số 1 #1	281	1	\N	2025-05-11 12:12:12.818658
1686	Điểm hệ số 1 #2	281	1	\N	2025-05-11 12:12:12.818658
1687	Điểm hệ số 1 #3	281	1	\N	2025-05-11 12:12:12.818658
1688	Điểm hệ số 2 #1	281	2	\N	2025-05-11 12:12:12.818658
1689	Điểm hệ số 2 #2	281	2	\N	2025-05-11 12:12:12.818658
1690	Điểm hệ số 3	281	3	\N	2025-05-11 12:12:12.818658
1691	Điểm hệ số 1 #1	282	1	\N	2025-05-11 12:12:12.818658
1692	Điểm hệ số 1 #2	282	1	\N	2025-05-11 12:12:12.818658
1693	Điểm hệ số 1 #3	282	1	\N	2025-05-11 12:12:12.818658
1694	Điểm hệ số 2 #1	282	2	\N	2025-05-11 12:12:12.818658
1695	Điểm hệ số 2 #2	282	2	\N	2025-05-11 12:12:12.818658
1696	Điểm hệ số 3	282	3	\N	2025-05-11 12:12:12.818658
1697	Điểm hệ số 1 #1	283	1	\N	2025-05-11 12:12:12.818658
1698	Điểm hệ số 1 #2	283	1	\N	2025-05-11 12:12:12.818658
1699	Điểm hệ số 1 #3	283	1	\N	2025-05-11 12:12:12.818658
1700	Điểm hệ số 2 #1	283	2	\N	2025-05-11 12:12:12.818658
1701	Điểm hệ số 2 #2	283	2	\N	2025-05-11 12:12:12.818658
1702	Điểm hệ số 3	283	3	\N	2025-05-11 12:12:12.818658
1703	Điểm hệ số 1 #1	284	1	\N	2025-05-11 12:12:12.818658
1704	Điểm hệ số 1 #2	284	1	\N	2025-05-11 12:12:12.818658
1705	Điểm hệ số 1 #3	284	1	\N	2025-05-11 12:12:12.818658
1706	Điểm hệ số 2 #1	284	2	\N	2025-05-11 12:12:12.818658
1707	Điểm hệ số 2 #2	284	2	\N	2025-05-11 12:12:12.818658
1708	Điểm hệ số 3	284	3	\N	2025-05-11 12:12:12.818658
1709	Điểm hệ số 1 #1	285	1	\N	2025-05-11 12:12:12.818658
1710	Điểm hệ số 1 #2	285	1	\N	2025-05-11 12:12:12.818658
1711	Điểm hệ số 1 #3	285	1	\N	2025-05-11 12:12:12.818658
1712	Điểm hệ số 2 #1	285	2	\N	2025-05-11 12:12:12.818658
1713	Điểm hệ số 2 #2	285	2	\N	2025-05-11 12:12:12.818658
1714	Điểm hệ số 3	285	3	\N	2025-05-11 12:12:12.818658
1715	Điểm hệ số 1 #1	286	1	\N	2025-05-11 12:12:12.818658
1716	Điểm hệ số 1 #2	286	1	\N	2025-05-11 12:12:12.818658
1717	Điểm hệ số 1 #3	286	1	\N	2025-05-11 12:12:12.818658
1718	Điểm hệ số 2 #1	286	2	\N	2025-05-11 12:12:12.818658
1719	Điểm hệ số 2 #2	286	2	\N	2025-05-11 12:12:12.818658
1720	Điểm hệ số 3	286	3	\N	2025-05-11 12:12:12.818658
1721	Điểm hệ số 1 #1	287	1	\N	2025-05-11 12:12:12.818658
1722	Điểm hệ số 1 #2	287	1	\N	2025-05-11 12:12:12.818658
1723	Điểm hệ số 1 #3	287	1	\N	2025-05-11 12:12:12.818658
1724	Điểm hệ số 2 #1	287	2	\N	2025-05-11 12:12:12.818658
1725	Điểm hệ số 2 #2	287	2	\N	2025-05-11 12:12:12.818658
1726	Điểm hệ số 3	287	3	\N	2025-05-11 12:12:12.818658
1727	Điểm hệ số 1 #1	288	1	\N	2025-05-11 12:12:12.818658
1728	Điểm hệ số 1 #2	288	1	\N	2025-05-11 12:12:12.818658
1729	Điểm hệ số 1 #3	288	1	\N	2025-05-11 12:12:12.818658
1730	Điểm hệ số 2 #1	288	2	\N	2025-05-11 12:12:12.818658
1731	Điểm hệ số 2 #2	288	2	\N	2025-05-11 12:12:12.819657
1732	Điểm hệ số 3	288	3	\N	2025-05-11 12:12:12.819657
1733	Điểm hệ số 1 #1	289	1	\N	2025-05-11 12:12:12.819657
1734	Điểm hệ số 1 #2	289	1	\N	2025-05-11 12:12:12.819657
1735	Điểm hệ số 1 #3	289	1	\N	2025-05-11 12:12:12.819657
1736	Điểm hệ số 2 #1	289	2	\N	2025-05-11 12:12:12.819657
1737	Điểm hệ số 2 #2	289	2	\N	2025-05-11 12:12:12.819657
1738	Điểm hệ số 3	289	3	\N	2025-05-11 12:12:12.819657
1739	Điểm hệ số 1 #1	290	1	\N	2025-05-11 12:12:12.819657
1740	Điểm hệ số 1 #2	290	1	\N	2025-05-11 12:12:12.819657
1741	Điểm hệ số 1 #3	290	1	\N	2025-05-11 12:12:12.819657
1742	Điểm hệ số 2 #1	290	2	\N	2025-05-11 12:12:12.819657
1743	Điểm hệ số 2 #2	290	2	\N	2025-05-11 12:12:12.819657
1744	Điểm hệ số 3	290	3	\N	2025-05-11 12:12:12.819657
1745	Điểm hệ số 1 #1	291	1	\N	2025-05-11 12:12:12.819657
1746	Điểm hệ số 1 #2	291	1	\N	2025-05-11 12:12:12.819657
1747	Điểm hệ số 1 #3	291	1	\N	2025-05-11 12:12:12.819657
1748	Điểm hệ số 2 #1	291	2	\N	2025-05-11 12:12:12.819657
1749	Điểm hệ số 2 #2	291	2	\N	2025-05-11 12:12:12.819657
1750	Điểm hệ số 3	291	3	\N	2025-05-11 12:12:12.819657
1751	Điểm hệ số 1 #1	292	1	\N	2025-05-11 12:12:12.819657
1752	Điểm hệ số 1 #2	292	1	\N	2025-05-11 12:12:12.819657
1753	Điểm hệ số 1 #3	292	1	\N	2025-05-11 12:12:12.819657
1754	Điểm hệ số 2 #1	292	2	\N	2025-05-11 12:12:12.819657
1755	Điểm hệ số 2 #2	292	2	\N	2025-05-11 12:12:12.819657
1756	Điểm hệ số 3	292	3	\N	2025-05-11 12:12:12.819657
1757	Điểm hệ số 1 #1	293	1	\N	2025-05-11 12:12:12.819657
1758	Điểm hệ số 1 #2	293	1	\N	2025-05-11 12:12:12.819657
1759	Điểm hệ số 1 #3	293	1	\N	2025-05-11 12:12:12.819657
1760	Điểm hệ số 2 #1	293	2	\N	2025-05-11 12:12:12.819657
1761	Điểm hệ số 2 #2	293	2	\N	2025-05-11 12:12:12.819657
1762	Điểm hệ số 3	293	3	\N	2025-05-11 12:12:12.819657
1763	Điểm hệ số 1 #1	294	1	\N	2025-05-11 12:12:12.819657
1764	Điểm hệ số 1 #2	294	1	\N	2025-05-11 12:12:12.819657
1765	Điểm hệ số 1 #3	294	1	\N	2025-05-11 12:12:12.819657
1766	Điểm hệ số 2 #1	294	2	\N	2025-05-11 12:12:12.819657
1767	Điểm hệ số 2 #2	294	2	\N	2025-05-11 12:12:12.819657
1768	Điểm hệ số 3	294	3	\N	2025-05-11 12:12:12.819657
1769	Điểm hệ số 1 #1	295	1	\N	2025-05-11 12:12:12.819657
1770	Điểm hệ số 1 #2	295	1	\N	2025-05-11 12:12:12.819657
1771	Điểm hệ số 1 #3	295	1	\N	2025-05-11 12:12:12.819657
1772	Điểm hệ số 2 #1	295	2	\N	2025-05-11 12:12:12.819657
1773	Điểm hệ số 2 #2	295	2	\N	2025-05-11 12:12:12.819657
1774	Điểm hệ số 3	295	3	\N	2025-05-11 12:12:12.819657
1775	Điểm hệ số 1 #1	296	1	\N	2025-05-11 12:12:12.819657
1776	Điểm hệ số 1 #2	296	1	\N	2025-05-11 12:12:12.819657
1777	Điểm hệ số 1 #3	296	1	\N	2025-05-11 12:12:12.819657
1778	Điểm hệ số 2 #1	296	2	\N	2025-05-11 12:12:12.819657
1779	Điểm hệ số 2 #2	296	2	\N	2025-05-11 12:12:12.819657
1780	Điểm hệ số 3	296	3	\N	2025-05-11 12:12:12.819657
1781	Điểm hệ số 1 #1	297	1	\N	2025-05-11 12:12:12.819657
1782	Điểm hệ số 1 #2	297	1	\N	2025-05-11 12:12:12.819657
1783	Điểm hệ số 1 #3	297	1	\N	2025-05-11 12:12:12.819657
1784	Điểm hệ số 2 #1	297	2	\N	2025-05-11 12:12:12.819657
1785	Điểm hệ số 2 #2	297	2	\N	2025-05-11 12:12:12.819657
1786	Điểm hệ số 3	297	3	\N	2025-05-11 12:12:12.819657
1787	Điểm hệ số 1 #1	298	1	\N	2025-05-11 12:12:12.819657
1788	Điểm hệ số 1 #2	298	1	\N	2025-05-11 12:12:12.819657
1789	Điểm hệ số 1 #3	298	1	\N	2025-05-11 12:12:12.819657
1790	Điểm hệ số 2 #1	298	2	\N	2025-05-11 12:12:12.819657
1791	Điểm hệ số 2 #2	298	2	\N	2025-05-11 12:12:12.819657
1792	Điểm hệ số 3	298	3	\N	2025-05-11 12:12:12.819657
1793	Điểm hệ số 1 #1	299	1	\N	2025-05-11 12:12:12.819657
1794	Điểm hệ số 1 #2	299	1	\N	2025-05-11 12:12:12.819657
1795	Điểm hệ số 1 #3	299	1	\N	2025-05-11 12:12:12.819657
1796	Điểm hệ số 2 #1	299	2	\N	2025-05-11 12:12:12.819657
1797	Điểm hệ số 2 #2	299	2	\N	2025-05-11 12:12:12.819657
1798	Điểm hệ số 3	299	3	\N	2025-05-11 12:12:12.819657
1799	Điểm hệ số 1 #1	300	1	\N	2025-05-11 12:12:12.819657
1800	Điểm hệ số 1 #2	300	1	\N	2025-05-11 12:12:12.819657
1801	Điểm hệ số 1 #3	300	1	\N	2025-05-11 12:12:12.819657
1802	Điểm hệ số 2 #1	300	2	\N	2025-05-11 12:12:12.819657
1803	Điểm hệ số 2 #2	300	2	\N	2025-05-11 12:12:12.819657
1804	Điểm hệ số 3	300	3	\N	2025-05-11 12:12:12.819657
1805	Điểm hệ số 1 #1	301	1	\N	2025-05-11 12:12:12.819657
1806	Điểm hệ số 1 #2	301	1	\N	2025-05-11 12:12:12.819657
1807	Điểm hệ số 1 #3	301	1	\N	2025-05-11 12:12:12.819657
1808	Điểm hệ số 2 #1	301	2	\N	2025-05-11 12:12:12.819657
1809	Điểm hệ số 2 #2	301	2	\N	2025-05-11 12:12:12.819657
1810	Điểm hệ số 3	301	3	\N	2025-05-11 12:12:12.819657
1811	Điểm hệ số 1 #1	302	1	\N	2025-05-11 12:12:12.819657
1812	Điểm hệ số 1 #2	302	1	\N	2025-05-11 12:12:12.819657
1813	Điểm hệ số 1 #3	302	1	\N	2025-05-11 12:12:12.819657
1814	Điểm hệ số 2 #1	302	2	\N	2025-05-11 12:12:12.819657
1815	Điểm hệ số 2 #2	302	2	\N	2025-05-11 12:12:12.819657
1816	Điểm hệ số 3	302	3	\N	2025-05-11 12:12:12.819657
1817	Điểm hệ số 1 #1	303	1	\N	2025-05-11 12:12:12.819657
1818	Điểm hệ số 1 #2	303	1	\N	2025-05-11 12:12:12.819657
1819	Điểm hệ số 1 #3	303	1	\N	2025-05-11 12:12:12.819657
1820	Điểm hệ số 2 #1	303	2	\N	2025-05-11 12:12:12.819657
1821	Điểm hệ số 2 #2	303	2	\N	2025-05-11 12:12:12.819657
1822	Điểm hệ số 3	303	3	\N	2025-05-11 12:12:12.819657
1823	Điểm hệ số 1 #1	304	1	\N	2025-05-11 12:12:12.819657
1824	Điểm hệ số 1 #2	304	1	\N	2025-05-11 12:12:12.819657
1825	Điểm hệ số 1 #3	304	1	\N	2025-05-11 12:12:12.819657
1826	Điểm hệ số 2 #1	304	2	\N	2025-05-11 12:12:12.819657
1827	Điểm hệ số 2 #2	304	2	\N	2025-05-11 12:12:12.819657
1828	Điểm hệ số 3	304	3	\N	2025-05-11 12:12:12.819657
1829	Điểm hệ số 1 #1	305	1	\N	2025-05-11 12:12:12.819657
1830	Điểm hệ số 1 #2	305	1	\N	2025-05-11 12:12:12.819657
1831	Điểm hệ số 1 #3	305	1	\N	2025-05-11 12:12:12.819657
1832	Điểm hệ số 2 #1	305	2	\N	2025-05-11 12:12:12.819657
1833	Điểm hệ số 2 #2	305	2	\N	2025-05-11 12:12:12.819657
1834	Điểm hệ số 3	305	3	\N	2025-05-11 12:12:12.819657
1835	Điểm hệ số 1 #1	306	1	\N	2025-05-11 12:12:12.819657
1836	Điểm hệ số 1 #2	306	1	\N	2025-05-11 12:12:12.819657
1837	Điểm hệ số 1 #3	306	1	\N	2025-05-11 12:12:12.819657
1838	Điểm hệ số 2 #1	306	2	\N	2025-05-11 12:12:12.819657
1839	Điểm hệ số 2 #2	306	2	\N	2025-05-11 12:12:12.819657
1840	Điểm hệ số 3	306	3	\N	2025-05-11 12:12:12.819657
1841	Điểm hệ số 1 #1	307	1	\N	2025-05-11 12:12:12.819657
1842	Điểm hệ số 1 #2	307	1	\N	2025-05-11 12:12:12.819657
1843	Điểm hệ số 1 #3	307	1	\N	2025-05-11 12:12:12.819657
1844	Điểm hệ số 2 #1	307	2	\N	2025-05-11 12:12:12.819657
1845	Điểm hệ số 2 #2	307	2	\N	2025-05-11 12:12:12.819657
1846	Điểm hệ số 3	307	3	\N	2025-05-11 12:12:12.819657
1847	Điểm hệ số 1 #1	308	1	\N	2025-05-11 12:12:12.819657
1848	Điểm hệ số 1 #2	308	1	\N	2025-05-11 12:12:12.819657
1849	Điểm hệ số 1 #3	308	1	\N	2025-05-11 12:12:12.819657
1850	Điểm hệ số 2 #1	308	2	\N	2025-05-11 12:12:12.819657
1851	Điểm hệ số 2 #2	308	2	\N	2025-05-11 12:12:12.819657
1852	Điểm hệ số 3	308	3	\N	2025-05-11 12:12:12.819657
1853	Điểm hệ số 1 #1	309	1	\N	2025-05-11 12:12:12.819657
1854	Điểm hệ số 1 #2	309	1	\N	2025-05-11 12:12:12.819657
1855	Điểm hệ số 1 #3	309	1	\N	2025-05-11 12:12:12.819657
1856	Điểm hệ số 2 #1	309	2	\N	2025-05-11 12:12:12.819657
1857	Điểm hệ số 2 #2	309	2	\N	2025-05-11 12:12:12.819657
1858	Điểm hệ số 3	309	3	\N	2025-05-11 12:12:12.819657
1859	Điểm hệ số 1 #1	310	1	\N	2025-05-11 12:12:12.819657
1860	Điểm hệ số 1 #2	310	1	\N	2025-05-11 12:12:12.819657
1861	Điểm hệ số 1 #3	310	1	\N	2025-05-11 12:12:12.819657
1862	Điểm hệ số 2 #1	310	2	\N	2025-05-11 12:12:12.819657
1863	Điểm hệ số 2 #2	310	2	\N	2025-05-11 12:12:12.819657
1864	Điểm hệ số 3	310	3	\N	2025-05-11 12:12:12.819657
1865	Điểm hệ số 1 #1	311	1	\N	2025-05-11 12:12:12.819657
1866	Điểm hệ số 1 #2	311	1	\N	2025-05-11 12:12:12.819657
1867	Điểm hệ số 1 #3	311	1	\N	2025-05-11 12:12:12.819657
1868	Điểm hệ số 2 #1	311	2	\N	2025-05-11 12:12:12.819657
1869	Điểm hệ số 2 #2	311	2	\N	2025-05-11 12:12:12.819657
1870	Điểm hệ số 3	311	3	\N	2025-05-11 12:12:12.819657
1871	Điểm hệ số 1 #1	312	1	\N	2025-05-11 12:12:12.819657
1872	Điểm hệ số 1 #2	312	1	\N	2025-05-11 12:12:12.819657
1873	Điểm hệ số 1 #3	312	1	\N	2025-05-11 12:12:12.819657
1874	Điểm hệ số 2 #1	312	2	\N	2025-05-11 12:12:12.819657
1875	Điểm hệ số 2 #2	312	2	\N	2025-05-11 12:12:12.819657
1876	Điểm hệ số 3	312	3	\N	2025-05-11 12:12:12.819657
1877	Điểm hệ số 1 #1	313	1	\N	2025-05-11 12:12:12.819657
1878	Điểm hệ số 1 #2	313	1	\N	2025-05-11 12:12:12.819657
1879	Điểm hệ số 1 #3	313	1	\N	2025-05-11 12:12:12.819657
1880	Điểm hệ số 2 #1	313	2	\N	2025-05-11 12:12:12.819657
1881	Điểm hệ số 2 #2	313	2	\N	2025-05-11 12:12:12.819657
1882	Điểm hệ số 3	313	3	\N	2025-05-11 12:12:12.819657
1883	Điểm hệ số 1 #1	314	1	\N	2025-05-11 12:12:12.819657
1884	Điểm hệ số 1 #2	314	1	\N	2025-05-11 12:12:12.819657
1885	Điểm hệ số 1 #3	314	1	\N	2025-05-11 12:12:12.819657
1886	Điểm hệ số 2 #1	314	2	\N	2025-05-11 12:12:12.820657
1887	Điểm hệ số 2 #2	314	2	\N	2025-05-11 12:12:12.820657
1888	Điểm hệ số 3	314	3	\N	2025-05-11 12:12:12.820657
1889	Điểm hệ số 1 #1	315	1	\N	2025-05-11 12:12:12.820657
1890	Điểm hệ số 1 #2	315	1	\N	2025-05-11 12:12:12.820657
1891	Điểm hệ số 1 #3	315	1	\N	2025-05-11 12:12:12.820657
1892	Điểm hệ số 2 #1	315	2	\N	2025-05-11 12:12:12.820657
1893	Điểm hệ số 2 #2	315	2	\N	2025-05-11 12:12:12.820657
1894	Điểm hệ số 3	315	3	\N	2025-05-11 12:12:12.820657
1895	Điểm hệ số 1 #1	316	1	\N	2025-05-11 12:12:12.820657
1896	Điểm hệ số 1 #2	316	1	\N	2025-05-11 12:12:12.820657
1897	Điểm hệ số 1 #3	316	1	\N	2025-05-11 12:12:12.820657
1898	Điểm hệ số 2 #1	316	2	\N	2025-05-11 12:12:12.820657
1899	Điểm hệ số 2 #2	316	2	\N	2025-05-11 12:12:12.820657
1900	Điểm hệ số 3	316	3	\N	2025-05-11 12:12:12.820657
1901	Điểm hệ số 1 #1	317	1	\N	2025-05-11 12:12:12.820657
1902	Điểm hệ số 1 #2	317	1	\N	2025-05-11 12:12:12.820657
1903	Điểm hệ số 1 #3	317	1	\N	2025-05-11 12:12:12.820657
1904	Điểm hệ số 2 #1	317	2	\N	2025-05-11 12:12:12.820657
1905	Điểm hệ số 2 #2	317	2	\N	2025-05-11 12:12:12.820657
1906	Điểm hệ số 3	317	3	\N	2025-05-11 12:12:12.820657
1907	Điểm hệ số 1 #1	318	1	\N	2025-05-11 12:12:12.820657
1908	Điểm hệ số 1 #2	318	1	\N	2025-05-11 12:12:12.820657
1909	Điểm hệ số 1 #3	318	1	\N	2025-05-11 12:12:12.820657
1910	Điểm hệ số 2 #1	318	2	\N	2025-05-11 12:12:12.820657
1911	Điểm hệ số 2 #2	318	2	\N	2025-05-11 12:12:12.820657
1912	Điểm hệ số 3	318	3	\N	2025-05-11 12:12:12.820657
1913	Điểm hệ số 1 #1	319	1	\N	2025-05-11 12:12:12.820657
1914	Điểm hệ số 1 #2	319	1	\N	2025-05-11 12:12:12.820657
1915	Điểm hệ số 1 #3	319	1	\N	2025-05-11 12:12:12.820657
1916	Điểm hệ số 2 #1	319	2	\N	2025-05-11 12:12:12.820657
1917	Điểm hệ số 2 #2	319	2	\N	2025-05-11 12:12:12.820657
1918	Điểm hệ số 3	319	3	\N	2025-05-11 12:12:12.820657
1919	Điểm hệ số 1 #1	320	1	\N	2025-05-11 12:12:12.820657
1920	Điểm hệ số 1 #2	320	1	\N	2025-05-11 12:12:12.820657
1921	Điểm hệ số 1 #3	320	1	\N	2025-05-11 12:12:12.820657
1922	Điểm hệ số 2 #1	320	2	\N	2025-05-11 12:12:12.820657
1923	Điểm hệ số 2 #2	320	2	\N	2025-05-11 12:12:12.820657
1924	Điểm hệ số 3	320	3	\N	2025-05-11 12:12:12.820657
1925	Điểm hệ số 1 #1	321	1	\N	2025-05-11 12:12:12.820657
1926	Điểm hệ số 1 #2	321	1	\N	2025-05-11 12:12:12.820657
1927	Điểm hệ số 1 #3	321	1	\N	2025-05-11 12:12:12.820657
1928	Điểm hệ số 2 #1	321	2	\N	2025-05-11 12:12:12.820657
1929	Điểm hệ số 2 #2	321	2	\N	2025-05-11 12:12:12.820657
1930	Điểm hệ số 3	321	3	\N	2025-05-11 12:12:12.820657
1931	Điểm hệ số 1 #1	322	1	\N	2025-05-11 12:12:12.820657
1932	Điểm hệ số 1 #2	322	1	\N	2025-05-11 12:12:12.820657
1933	Điểm hệ số 1 #3	322	1	\N	2025-05-11 12:12:12.820657
1934	Điểm hệ số 2 #1	322	2	\N	2025-05-11 12:12:12.820657
1935	Điểm hệ số 2 #2	322	2	\N	2025-05-11 12:12:12.820657
1936	Điểm hệ số 3	322	3	\N	2025-05-11 12:12:12.820657
1937	Điểm hệ số 1 #1	323	1	\N	2025-05-11 12:12:12.820657
1938	Điểm hệ số 1 #2	323	1	\N	2025-05-11 12:12:12.820657
1939	Điểm hệ số 1 #3	323	1	\N	2025-05-11 12:12:12.820657
1940	Điểm hệ số 2 #1	323	2	\N	2025-05-11 12:12:12.820657
1941	Điểm hệ số 2 #2	323	2	\N	2025-05-11 12:12:12.820657
1942	Điểm hệ số 3	323	3	\N	2025-05-11 12:12:12.820657
1943	Điểm hệ số 1 #1	324	1	\N	2025-05-11 12:12:12.820657
1944	Điểm hệ số 1 #2	324	1	\N	2025-05-11 12:12:12.820657
1945	Điểm hệ số 1 #3	324	1	\N	2025-05-11 12:12:12.820657
1946	Điểm hệ số 2 #1	324	2	\N	2025-05-11 12:12:12.820657
1947	Điểm hệ số 2 #2	324	2	\N	2025-05-11 12:12:12.820657
1948	Điểm hệ số 3	324	3	\N	2025-05-11 12:12:12.820657
1949	Điểm hệ số 1 #1	325	1	\N	2025-05-11 12:12:12.820657
1950	Điểm hệ số 1 #2	325	1	\N	2025-05-11 12:12:12.820657
1951	Điểm hệ số 1 #3	325	1	\N	2025-05-11 12:12:12.820657
1952	Điểm hệ số 2 #1	325	2	\N	2025-05-11 12:12:12.820657
1953	Điểm hệ số 2 #2	325	2	\N	2025-05-11 12:12:12.820657
1954	Điểm hệ số 3	325	3	\N	2025-05-11 12:12:12.820657
1955	Điểm hệ số 1 #1	326	1	\N	2025-05-11 12:12:12.820657
1956	Điểm hệ số 1 #2	326	1	\N	2025-05-11 12:12:12.820657
1957	Điểm hệ số 1 #3	326	1	\N	2025-05-11 12:12:12.820657
1958	Điểm hệ số 2 #1	326	2	\N	2025-05-11 12:12:12.820657
1959	Điểm hệ số 2 #2	326	2	\N	2025-05-11 12:12:12.820657
1960	Điểm hệ số 3	326	3	\N	2025-05-11 12:12:12.820657
1961	Điểm hệ số 1 #1	327	1	\N	2025-05-11 12:12:12.820657
1962	Điểm hệ số 1 #2	327	1	\N	2025-05-11 12:12:12.820657
1963	Điểm hệ số 1 #3	327	1	\N	2025-05-11 12:12:12.820657
1964	Điểm hệ số 2 #1	327	2	\N	2025-05-11 12:12:12.820657
1965	Điểm hệ số 2 #2	327	2	\N	2025-05-11 12:12:12.820657
1966	Điểm hệ số 3	327	3	\N	2025-05-11 12:12:12.820657
1967	Điểm hệ số 1 #1	328	1	\N	2025-05-11 12:12:12.820657
1968	Điểm hệ số 1 #2	328	1	\N	2025-05-11 12:12:12.820657
1969	Điểm hệ số 1 #3	328	1	\N	2025-05-11 12:12:12.820657
1970	Điểm hệ số 2 #1	328	2	\N	2025-05-11 12:12:12.820657
1971	Điểm hệ số 2 #2	328	2	\N	2025-05-11 12:12:12.820657
1972	Điểm hệ số 3	328	3	\N	2025-05-11 12:12:12.820657
1973	Điểm hệ số 1 #1	329	1	\N	2025-05-11 12:12:12.820657
1974	Điểm hệ số 1 #2	329	1	\N	2025-05-11 12:12:12.820657
1975	Điểm hệ số 1 #3	329	1	\N	2025-05-11 12:12:12.820657
1976	Điểm hệ số 2 #1	329	2	\N	2025-05-11 12:12:12.820657
1977	Điểm hệ số 2 #2	329	2	\N	2025-05-11 12:12:12.820657
1978	Điểm hệ số 3	329	3	\N	2025-05-11 12:12:12.820657
1979	Điểm hệ số 1 #1	330	1	\N	2025-05-11 12:12:12.820657
1980	Điểm hệ số 1 #2	330	1	\N	2025-05-11 12:12:12.820657
1981	Điểm hệ số 1 #3	330	1	\N	2025-05-11 12:12:12.820657
1982	Điểm hệ số 2 #1	330	2	\N	2025-05-11 12:12:12.820657
1983	Điểm hệ số 2 #2	330	2	\N	2025-05-11 12:12:12.820657
1984	Điểm hệ số 3	330	3	\N	2025-05-11 12:12:12.820657
1985	Điểm hệ số 1 #1	331	1	\N	2025-05-11 12:12:12.820657
1986	Điểm hệ số 1 #2	331	1	\N	2025-05-11 12:12:12.820657
1987	Điểm hệ số 1 #3	331	1	\N	2025-05-11 12:12:12.820657
1988	Điểm hệ số 2 #1	331	2	\N	2025-05-11 12:12:12.820657
1989	Điểm hệ số 2 #2	331	2	\N	2025-05-11 12:12:12.820657
1990	Điểm hệ số 3	331	3	\N	2025-05-11 12:12:12.820657
1991	Điểm hệ số 1 #1	332	1	\N	2025-05-11 12:12:12.820657
1992	Điểm hệ số 1 #2	332	1	\N	2025-05-11 12:12:12.820657
1993	Điểm hệ số 1 #3	332	1	\N	2025-05-11 12:12:12.820657
1994	Điểm hệ số 2 #1	332	2	\N	2025-05-11 12:12:12.820657
1995	Điểm hệ số 2 #2	332	2	\N	2025-05-11 12:12:12.820657
1996	Điểm hệ số 3	332	3	\N	2025-05-11 12:12:12.820657
1997	Điểm hệ số 1 #1	333	1	\N	2025-05-11 12:12:12.820657
1998	Điểm hệ số 1 #2	333	1	\N	2025-05-11 12:12:12.820657
1999	Điểm hệ số 1 #3	333	1	\N	2025-05-11 12:12:12.820657
2000	Điểm hệ số 2 #1	333	2	\N	2025-05-11 12:12:12.820657
2001	Điểm hệ số 2 #2	333	2	\N	2025-05-11 12:12:12.820657
2002	Điểm hệ số 3	333	3	\N	2025-05-11 12:12:12.820657
2003	Điểm hệ số 1 #1	334	1	\N	2025-05-11 12:12:12.820657
2004	Điểm hệ số 1 #2	334	1	\N	2025-05-11 12:12:12.820657
2005	Điểm hệ số 1 #3	334	1	\N	2025-05-11 12:12:12.820657
2006	Điểm hệ số 2 #1	334	2	\N	2025-05-11 12:12:12.820657
2007	Điểm hệ số 2 #2	334	2	\N	2025-05-11 12:12:12.820657
2008	Điểm hệ số 3	334	3	\N	2025-05-11 12:12:12.820657
2009	Điểm hệ số 1 #1	335	1	\N	2025-05-11 12:12:12.820657
2010	Điểm hệ số 1 #2	335	1	\N	2025-05-11 12:12:12.820657
2011	Điểm hệ số 1 #3	335	1	\N	2025-05-11 12:12:12.820657
2012	Điểm hệ số 2 #1	335	2	\N	2025-05-11 12:12:12.820657
2013	Điểm hệ số 2 #2	335	2	\N	2025-05-11 12:12:12.820657
2014	Điểm hệ số 3	335	3	\N	2025-05-11 12:12:12.820657
2015	Điểm hệ số 1 #1	336	1	\N	2025-05-11 12:12:12.820657
2016	Điểm hệ số 1 #2	336	1	\N	2025-05-11 12:12:12.820657
2017	Điểm hệ số 1 #3	336	1	\N	2025-05-11 12:12:12.820657
2018	Điểm hệ số 2 #1	336	2	\N	2025-05-11 12:12:12.820657
2019	Điểm hệ số 2 #2	336	2	\N	2025-05-11 12:12:12.820657
2020	Điểm hệ số 3	336	3	\N	2025-05-11 12:12:12.820657
2021	Điểm hệ số 1 #1	337	1	\N	2025-05-11 12:12:12.820657
2022	Điểm hệ số 1 #2	337	1	\N	2025-05-11 12:12:12.820657
2023	Điểm hệ số 1 #3	337	1	\N	2025-05-11 12:12:12.820657
2024	Điểm hệ số 2 #1	337	2	\N	2025-05-11 12:12:12.820657
2025	Điểm hệ số 2 #2	337	2	\N	2025-05-11 12:12:12.820657
2026	Điểm hệ số 3	337	3	\N	2025-05-11 12:12:12.820657
2027	Điểm hệ số 1 #1	338	1	\N	2025-05-11 12:12:12.820657
2028	Điểm hệ số 1 #2	338	1	\N	2025-05-11 12:12:12.820657
2029	Điểm hệ số 1 #3	338	1	\N	2025-05-11 12:12:12.820657
2030	Điểm hệ số 2 #1	338	2	\N	2025-05-11 12:12:12.820657
2031	Điểm hệ số 2 #2	338	2	\N	2025-05-11 12:12:12.820657
2032	Điểm hệ số 3	338	3	\N	2025-05-11 12:12:12.820657
2033	Điểm hệ số 1 #1	339	1	\N	2025-05-11 12:12:12.820657
2034	Điểm hệ số 1 #2	339	1	\N	2025-05-11 12:12:12.820657
2035	Điểm hệ số 1 #3	339	1	\N	2025-05-11 12:12:12.820657
2036	Điểm hệ số 2 #1	339	2	\N	2025-05-11 12:12:12.820657
2037	Điểm hệ số 2 #2	339	2	\N	2025-05-11 12:12:12.820657
2038	Điểm hệ số 3	339	3	\N	2025-05-11 12:12:12.820657
2039	Điểm hệ số 1 #1	340	1	\N	2025-05-11 12:12:13.987252
2040	Điểm hệ số 1 #2	340	1	\N	2025-05-11 12:12:13.987252
2041	Điểm hệ số 1 #3	340	1	\N	2025-05-11 12:12:13.987252
2042	Điểm hệ số 2 #1	340	2	\N	2025-05-11 12:12:13.987252
2043	Điểm hệ số 2 #2	340	2	\N	2025-05-11 12:12:13.987252
2044	Điểm hệ số 3	340	3	\N	2025-05-11 12:12:13.987252
2045	Điểm hệ số 1 #1	341	1	\N	2025-05-11 12:12:13.987252
2046	Điểm hệ số 1 #2	341	1	\N	2025-05-11 12:12:13.987252
2047	Điểm hệ số 1 #3	341	1	\N	2025-05-11 12:12:13.987252
2048	Điểm hệ số 2 #1	341	2	\N	2025-05-11 12:12:13.987252
2049	Điểm hệ số 2 #2	341	2	\N	2025-05-11 12:12:13.987252
2050	Điểm hệ số 3	341	3	\N	2025-05-11 12:12:13.987252
2051	Điểm hệ số 1 #1	342	1	\N	2025-05-11 12:12:13.987252
2052	Điểm hệ số 1 #2	342	1	\N	2025-05-11 12:12:13.987252
2053	Điểm hệ số 1 #3	342	1	\N	2025-05-11 12:12:13.987252
2054	Điểm hệ số 2 #1	342	2	\N	2025-05-11 12:12:13.987252
2055	Điểm hệ số 2 #2	342	2	\N	2025-05-11 12:12:13.987252
2056	Điểm hệ số 3	342	3	\N	2025-05-11 12:12:13.987252
2057	Điểm hệ số 1 #1	343	1	\N	2025-05-11 12:12:13.987252
2058	Điểm hệ số 1 #2	343	1	\N	2025-05-11 12:12:13.987252
2059	Điểm hệ số 1 #3	343	1	\N	2025-05-11 12:12:13.987252
2060	Điểm hệ số 2 #1	343	2	\N	2025-05-11 12:12:13.987252
2061	Điểm hệ số 2 #2	343	2	\N	2025-05-11 12:12:13.987252
2062	Điểm hệ số 3	343	3	\N	2025-05-11 12:12:13.987252
2063	Điểm hệ số 1 #1	344	1	\N	2025-05-11 12:12:13.987252
2064	Điểm hệ số 1 #2	344	1	\N	2025-05-11 12:12:13.987252
2065	Điểm hệ số 1 #3	344	1	\N	2025-05-11 12:12:13.987252
2066	Điểm hệ số 2 #1	344	2	\N	2025-05-11 12:12:13.987252
2067	Điểm hệ số 2 #2	344	2	\N	2025-05-11 12:12:13.987252
2068	Điểm hệ số 3	344	3	\N	2025-05-11 12:12:13.987252
2069	Điểm hệ số 1 #1	345	1	\N	2025-05-11 12:12:13.987252
2070	Điểm hệ số 1 #2	345	1	\N	2025-05-11 12:12:13.987252
2071	Điểm hệ số 1 #3	345	1	\N	2025-05-11 12:12:13.987252
2072	Điểm hệ số 2 #1	345	2	\N	2025-05-11 12:12:13.987252
2073	Điểm hệ số 2 #2	345	2	\N	2025-05-11 12:12:13.987252
2074	Điểm hệ số 3	345	3	\N	2025-05-11 12:12:13.987252
2075	Điểm hệ số 1 #1	346	1	\N	2025-05-11 12:12:13.987252
2076	Điểm hệ số 1 #2	346	1	\N	2025-05-11 12:12:13.987252
2077	Điểm hệ số 1 #3	346	1	\N	2025-05-11 12:12:13.987252
2078	Điểm hệ số 2 #1	346	2	\N	2025-05-11 12:12:13.987252
2079	Điểm hệ số 2 #2	346	2	\N	2025-05-11 12:12:13.987252
2080	Điểm hệ số 3	346	3	\N	2025-05-11 12:12:13.987252
2081	Điểm hệ số 1 #1	347	1	\N	2025-05-11 12:12:13.987252
2082	Điểm hệ số 1 #2	347	1	\N	2025-05-11 12:12:13.987252
2083	Điểm hệ số 1 #3	347	1	\N	2025-05-11 12:12:13.987252
2084	Điểm hệ số 2 #1	347	2	\N	2025-05-11 12:12:13.987252
2085	Điểm hệ số 2 #2	347	2	\N	2025-05-11 12:12:13.987252
2086	Điểm hệ số 3	347	3	\N	2025-05-11 12:12:13.987252
2087	Điểm hệ số 1 #1	348	1	\N	2025-05-11 12:12:13.987252
2088	Điểm hệ số 1 #2	348	1	\N	2025-05-11 12:12:13.987252
2089	Điểm hệ số 1 #3	348	1	\N	2025-05-11 12:12:13.987252
2090	Điểm hệ số 2 #1	348	2	\N	2025-05-11 12:12:13.987252
2091	Điểm hệ số 2 #2	348	2	\N	2025-05-11 12:12:13.987252
2092	Điểm hệ số 3	348	3	\N	2025-05-11 12:12:13.987252
2093	Điểm hệ số 1 #1	349	1	\N	2025-05-11 12:12:13.987252
2094	Điểm hệ số 1 #2	349	1	\N	2025-05-11 12:12:13.987252
2095	Điểm hệ số 1 #3	349	1	\N	2025-05-11 12:12:13.987252
2096	Điểm hệ số 2 #1	349	2	\N	2025-05-11 12:12:13.987252
2097	Điểm hệ số 2 #2	349	2	\N	2025-05-11 12:12:13.987252
2098	Điểm hệ số 3	349	3	\N	2025-05-11 12:12:13.987252
2099	Điểm hệ số 1 #1	350	1	\N	2025-05-11 12:12:13.988254
2100	Điểm hệ số 1 #2	350	1	\N	2025-05-11 12:12:13.988254
2101	Điểm hệ số 1 #3	350	1	\N	2025-05-11 12:12:13.988254
2102	Điểm hệ số 2 #1	350	2	\N	2025-05-11 12:12:13.988254
2103	Điểm hệ số 2 #2	350	2	\N	2025-05-11 12:12:13.988254
2104	Điểm hệ số 3	350	3	\N	2025-05-11 12:12:13.988254
2105	Điểm hệ số 1 #1	351	1	\N	2025-05-11 12:12:13.988254
2106	Điểm hệ số 1 #2	351	1	\N	2025-05-11 12:12:13.988254
2107	Điểm hệ số 1 #3	351	1	\N	2025-05-11 12:12:13.988254
2108	Điểm hệ số 2 #1	351	2	\N	2025-05-11 12:12:13.988254
2109	Điểm hệ số 2 #2	351	2	\N	2025-05-11 12:12:13.988254
2110	Điểm hệ số 3	351	3	\N	2025-05-11 12:12:13.988254
2111	Điểm hệ số 1 #1	352	1	\N	2025-05-11 12:12:13.988254
2112	Điểm hệ số 1 #2	352	1	\N	2025-05-11 12:12:13.988254
2113	Điểm hệ số 1 #3	352	1	\N	2025-05-11 12:12:13.988254
2114	Điểm hệ số 2 #1	352	2	\N	2025-05-11 12:12:13.988254
2115	Điểm hệ số 2 #2	352	2	\N	2025-05-11 12:12:13.988254
2116	Điểm hệ số 3	352	3	\N	2025-05-11 12:12:13.988254
2117	Điểm hệ số 1 #1	353	1	\N	2025-05-11 12:12:13.988254
2118	Điểm hệ số 1 #2	353	1	\N	2025-05-11 12:12:13.988254
2119	Điểm hệ số 1 #3	353	1	\N	2025-05-11 12:12:13.988254
2120	Điểm hệ số 2 #1	353	2	\N	2025-05-11 12:12:13.988254
2121	Điểm hệ số 2 #2	353	2	\N	2025-05-11 12:12:13.988254
2122	Điểm hệ số 3	353	3	\N	2025-05-11 12:12:13.988254
2123	Điểm hệ số 1 #1	354	1	\N	2025-05-11 12:12:13.988254
2124	Điểm hệ số 1 #2	354	1	\N	2025-05-11 12:12:13.988254
2125	Điểm hệ số 1 #3	354	1	\N	2025-05-11 12:12:13.988254
2126	Điểm hệ số 2 #1	354	2	\N	2025-05-11 12:12:13.988254
2127	Điểm hệ số 2 #2	354	2	\N	2025-05-11 12:12:13.988254
2128	Điểm hệ số 3	354	3	\N	2025-05-11 12:12:13.988254
2129	Điểm hệ số 1 #1	355	1	\N	2025-05-11 12:12:13.988254
2130	Điểm hệ số 1 #2	355	1	\N	2025-05-11 12:12:13.988254
2131	Điểm hệ số 1 #3	355	1	\N	2025-05-11 12:12:13.988254
2132	Điểm hệ số 2 #1	355	2	\N	2025-05-11 12:12:13.988254
2133	Điểm hệ số 2 #2	355	2	\N	2025-05-11 12:12:13.988254
2134	Điểm hệ số 3	355	3	\N	2025-05-11 12:12:13.988254
2135	Điểm hệ số 1 #1	356	1	\N	2025-05-11 12:12:13.988254
2136	Điểm hệ số 1 #2	356	1	\N	2025-05-11 12:12:13.988254
2137	Điểm hệ số 1 #3	356	1	\N	2025-05-11 12:12:13.988254
2138	Điểm hệ số 2 #1	356	2	\N	2025-05-11 12:12:13.988254
2139	Điểm hệ số 2 #2	356	2	\N	2025-05-11 12:12:13.988254
2140	Điểm hệ số 3	356	3	\N	2025-05-11 12:12:13.988254
2141	Điểm hệ số 1 #1	357	1	\N	2025-05-11 12:12:13.988254
2142	Điểm hệ số 1 #2	357	1	\N	2025-05-11 12:12:13.988254
2143	Điểm hệ số 1 #3	357	1	\N	2025-05-11 12:12:13.988254
2144	Điểm hệ số 2 #1	357	2	\N	2025-05-11 12:12:13.988254
2145	Điểm hệ số 2 #2	357	2	\N	2025-05-11 12:12:13.988254
2146	Điểm hệ số 3	357	3	\N	2025-05-11 12:12:13.988254
2147	Điểm hệ số 1 #1	358	1	\N	2025-05-11 12:12:13.988254
2148	Điểm hệ số 1 #2	358	1	\N	2025-05-11 12:12:13.988254
2149	Điểm hệ số 1 #3	358	1	\N	2025-05-11 12:12:13.988254
2150	Điểm hệ số 2 #1	358	2	\N	2025-05-11 12:12:13.988254
2151	Điểm hệ số 2 #2	358	2	\N	2025-05-11 12:12:13.988254
2152	Điểm hệ số 3	358	3	\N	2025-05-11 12:12:13.988254
2153	Điểm hệ số 1 #1	359	1	\N	2025-05-11 12:12:13.988254
2154	Điểm hệ số 1 #2	359	1	\N	2025-05-11 12:12:13.988254
2155	Điểm hệ số 1 #3	359	1	\N	2025-05-11 12:12:13.988254
2156	Điểm hệ số 2 #1	359	2	\N	2025-05-11 12:12:13.988254
2157	Điểm hệ số 2 #2	359	2	\N	2025-05-11 12:12:13.988254
2158	Điểm hệ số 3	359	3	\N	2025-05-11 12:12:13.988254
2159	Điểm hệ số 1 #1	360	1	\N	2025-05-11 12:12:13.988254
2160	Điểm hệ số 1 #2	360	1	\N	2025-05-11 12:12:13.988254
2161	Điểm hệ số 1 #3	360	1	\N	2025-05-11 12:12:13.988254
2162	Điểm hệ số 2 #1	360	2	\N	2025-05-11 12:12:13.988254
2163	Điểm hệ số 2 #2	360	2	\N	2025-05-11 12:12:13.988254
2164	Điểm hệ số 3	360	3	\N	2025-05-11 12:12:13.988254
2165	Điểm hệ số 1 #1	361	1	\N	2025-05-11 12:12:13.988254
2166	Điểm hệ số 1 #2	361	1	\N	2025-05-11 12:12:13.988254
2167	Điểm hệ số 1 #3	361	1	\N	2025-05-11 12:12:13.988254
2168	Điểm hệ số 2 #1	361	2	\N	2025-05-11 12:12:13.988254
2169	Điểm hệ số 2 #2	361	2	\N	2025-05-11 12:12:13.988254
2170	Điểm hệ số 3	361	3	\N	2025-05-11 12:12:13.988254
2171	Điểm hệ số 1 #1	362	1	\N	2025-05-11 12:12:13.988254
2172	Điểm hệ số 1 #2	362	1	\N	2025-05-11 12:12:13.988254
2173	Điểm hệ số 1 #3	362	1	\N	2025-05-11 12:12:13.988254
2174	Điểm hệ số 2 #1	362	2	\N	2025-05-11 12:12:13.988254
2175	Điểm hệ số 2 #2	362	2	\N	2025-05-11 12:12:13.988254
2176	Điểm hệ số 3	362	3	\N	2025-05-11 12:12:13.988254
2177	Điểm hệ số 1 #1	363	1	\N	2025-05-11 12:12:13.988254
2178	Điểm hệ số 1 #2	363	1	\N	2025-05-11 12:12:13.988254
2179	Điểm hệ số 1 #3	363	1	\N	2025-05-11 12:12:13.988254
2180	Điểm hệ số 2 #1	363	2	\N	2025-05-11 12:12:13.988254
2181	Điểm hệ số 2 #2	363	2	\N	2025-05-11 12:12:13.988254
2182	Điểm hệ số 3	363	3	\N	2025-05-11 12:12:13.988254
2183	Điểm hệ số 1 #1	364	1	\N	2025-05-11 12:12:13.988254
2184	Điểm hệ số 1 #2	364	1	\N	2025-05-11 12:12:13.988254
2185	Điểm hệ số 1 #3	364	1	\N	2025-05-11 12:12:13.988254
2186	Điểm hệ số 2 #1	364	2	\N	2025-05-11 12:12:13.988254
2187	Điểm hệ số 2 #2	364	2	\N	2025-05-11 12:12:13.988254
2188	Điểm hệ số 3	364	3	\N	2025-05-11 12:12:13.988254
2189	Điểm hệ số 1 #1	365	1	\N	2025-05-11 12:12:13.988254
2190	Điểm hệ số 1 #2	365	1	\N	2025-05-11 12:12:13.988254
2191	Điểm hệ số 1 #3	365	1	\N	2025-05-11 12:12:13.988254
2192	Điểm hệ số 2 #1	365	2	\N	2025-05-11 12:12:13.988254
2193	Điểm hệ số 2 #2	365	2	\N	2025-05-11 12:12:13.988254
2194	Điểm hệ số 3	365	3	\N	2025-05-11 12:12:13.988254
2195	Điểm hệ số 1 #1	366	1	\N	2025-05-11 12:12:13.988254
2196	Điểm hệ số 1 #2	366	1	\N	2025-05-11 12:12:13.988254
2197	Điểm hệ số 1 #3	366	1	\N	2025-05-11 12:12:13.988254
2198	Điểm hệ số 2 #1	366	2	\N	2025-05-11 12:12:13.988254
2199	Điểm hệ số 2 #2	366	2	\N	2025-05-11 12:12:13.988254
2200	Điểm hệ số 3	366	3	\N	2025-05-11 12:12:13.988254
2201	Điểm hệ số 1 #1	367	1	\N	2025-05-11 12:12:13.988254
2202	Điểm hệ số 1 #2	367	1	\N	2025-05-11 12:12:13.988254
2203	Điểm hệ số 1 #3	367	1	\N	2025-05-11 12:12:13.988254
2204	Điểm hệ số 2 #1	367	2	\N	2025-05-11 12:12:13.988254
2205	Điểm hệ số 2 #2	367	2	\N	2025-05-11 12:12:13.988254
2206	Điểm hệ số 3	367	3	\N	2025-05-11 12:12:13.988254
2207	Điểm hệ số 1 #1	368	1	\N	2025-05-11 12:12:13.988254
2208	Điểm hệ số 1 #2	368	1	\N	2025-05-11 12:12:13.988254
2209	Điểm hệ số 1 #3	368	1	\N	2025-05-11 12:12:13.988254
2210	Điểm hệ số 2 #1	368	2	\N	2025-05-11 12:12:13.988254
2211	Điểm hệ số 2 #2	368	2	\N	2025-05-11 12:12:13.988254
2212	Điểm hệ số 3	368	3	\N	2025-05-11 12:12:13.988254
2213	Điểm hệ số 1 #1	369	1	\N	2025-05-11 12:12:13.988254
2214	Điểm hệ số 1 #2	369	1	\N	2025-05-11 12:12:13.988254
2215	Điểm hệ số 1 #3	369	1	\N	2025-05-11 12:12:13.988254
2216	Điểm hệ số 2 #1	369	2	\N	2025-05-11 12:12:13.988254
2217	Điểm hệ số 2 #2	369	2	\N	2025-05-11 12:12:13.988254
2218	Điểm hệ số 3	369	3	\N	2025-05-11 12:12:13.988254
2219	Điểm hệ số 1 #1	370	1	\N	2025-05-11 12:12:13.988254
2220	Điểm hệ số 1 #2	370	1	\N	2025-05-11 12:12:13.988254
2221	Điểm hệ số 1 #3	370	1	\N	2025-05-11 12:12:13.988254
2222	Điểm hệ số 2 #1	370	2	\N	2025-05-11 12:12:13.988254
2223	Điểm hệ số 2 #2	370	2	\N	2025-05-11 12:12:13.988254
2224	Điểm hệ số 3	370	3	\N	2025-05-11 12:12:13.988254
2225	Điểm hệ số 1 #1	371	1	\N	2025-05-11 12:12:13.988254
2226	Điểm hệ số 1 #2	371	1	\N	2025-05-11 12:12:13.988254
2227	Điểm hệ số 1 #3	371	1	\N	2025-05-11 12:12:13.988254
2228	Điểm hệ số 2 #1	371	2	\N	2025-05-11 12:12:13.988254
2229	Điểm hệ số 2 #2	371	2	\N	2025-05-11 12:12:13.988254
2230	Điểm hệ số 3	371	3	\N	2025-05-11 12:12:13.988254
2231	Điểm hệ số 1 #1	372	1	\N	2025-05-11 12:12:13.988254
2232	Điểm hệ số 1 #2	372	1	\N	2025-05-11 12:12:13.988254
2233	Điểm hệ số 1 #3	372	1	\N	2025-05-11 12:12:13.988254
2234	Điểm hệ số 2 #1	372	2	\N	2025-05-11 12:12:13.988254
2235	Điểm hệ số 2 #2	372	2	\N	2025-05-11 12:12:13.988254
2236	Điểm hệ số 3	372	3	\N	2025-05-11 12:12:13.988254
2237	Điểm hệ số 1 #1	373	1	\N	2025-05-11 12:12:13.988254
2238	Điểm hệ số 1 #2	373	1	\N	2025-05-11 12:12:13.988254
2239	Điểm hệ số 1 #3	373	1	\N	2025-05-11 12:12:13.988254
2240	Điểm hệ số 2 #1	373	2	\N	2025-05-11 12:12:13.988254
2241	Điểm hệ số 2 #2	373	2	\N	2025-05-11 12:12:13.988254
2242	Điểm hệ số 3	373	3	\N	2025-05-11 12:12:13.988254
2243	Điểm hệ số 1 #1	374	1	\N	2025-05-11 12:12:13.988254
2244	Điểm hệ số 1 #2	374	1	\N	2025-05-11 12:12:13.988254
2245	Điểm hệ số 1 #3	374	1	\N	2025-05-11 12:12:13.988254
2246	Điểm hệ số 2 #1	374	2	\N	2025-05-11 12:12:13.988254
2247	Điểm hệ số 2 #2	374	2	\N	2025-05-11 12:12:13.988254
2248	Điểm hệ số 3	374	3	\N	2025-05-11 12:12:13.988254
2249	Điểm hệ số 1 #1	375	1	\N	2025-05-11 12:12:13.988254
2250	Điểm hệ số 1 #2	375	1	\N	2025-05-11 12:12:13.988254
2251	Điểm hệ số 1 #3	375	1	\N	2025-05-11 12:12:13.988254
2252	Điểm hệ số 2 #1	375	2	\N	2025-05-11 12:12:13.988254
2253	Điểm hệ số 2 #2	375	2	\N	2025-05-11 12:12:13.988254
2254	Điểm hệ số 3	375	3	\N	2025-05-11 12:12:13.988254
2255	Điểm hệ số 1 #1	376	1	\N	2025-05-11 12:12:13.988254
2256	Điểm hệ số 1 #2	376	1	\N	2025-05-11 12:12:13.988254
2257	Điểm hệ số 1 #3	376	1	\N	2025-05-11 12:12:13.988254
2258	Điểm hệ số 2 #1	376	2	\N	2025-05-11 12:12:13.988254
2259	Điểm hệ số 2 #2	376	2	\N	2025-05-11 12:12:13.988254
2260	Điểm hệ số 3	376	3	\N	2025-05-11 12:12:13.988254
2261	Điểm hệ số 1 #1	377	1	\N	2025-05-11 12:12:13.988254
2262	Điểm hệ số 1 #2	377	1	\N	2025-05-11 12:12:13.988254
2263	Điểm hệ số 1 #3	377	1	\N	2025-05-11 12:12:13.988254
2264	Điểm hệ số 2 #1	377	2	\N	2025-05-11 12:12:13.988254
2265	Điểm hệ số 2 #2	377	2	\N	2025-05-11 12:12:13.988254
2266	Điểm hệ số 3	377	3	\N	2025-05-11 12:12:13.988254
2267	Điểm hệ số 1 #1	378	1	\N	2025-05-11 12:12:13.988254
2268	Điểm hệ số 1 #2	378	1	\N	2025-05-11 12:12:13.988254
2269	Điểm hệ số 1 #3	378	1	\N	2025-05-11 12:12:13.988254
2270	Điểm hệ số 2 #1	378	2	\N	2025-05-11 12:12:13.988254
2271	Điểm hệ số 2 #2	378	2	\N	2025-05-11 12:12:13.988254
2272	Điểm hệ số 3	378	3	\N	2025-05-11 12:12:13.988254
2273	Điểm hệ số 1 #1	379	1	\N	2025-05-11 12:12:13.988254
2274	Điểm hệ số 1 #2	379	1	\N	2025-05-11 12:12:13.988254
2275	Điểm hệ số 1 #3	379	1	\N	2025-05-11 12:12:13.988254
2276	Điểm hệ số 2 #1	379	2	\N	2025-05-11 12:12:13.988254
2277	Điểm hệ số 2 #2	379	2	\N	2025-05-11 12:12:13.988254
2278	Điểm hệ số 3	379	3	\N	2025-05-11 12:12:13.988254
2279	Điểm hệ số 1 #1	380	1	\N	2025-05-11 12:12:13.988254
2280	Điểm hệ số 1 #2	380	1	\N	2025-05-11 12:12:13.988254
2281	Điểm hệ số 1 #3	380	1	\N	2025-05-11 12:12:13.988254
2282	Điểm hệ số 2 #1	380	2	\N	2025-05-11 12:12:13.988254
2283	Điểm hệ số 2 #2	380	2	\N	2025-05-11 12:12:13.988254
2284	Điểm hệ số 3	380	3	\N	2025-05-11 12:12:13.988254
2285	Điểm hệ số 1 #1	381	1	\N	2025-05-11 12:12:13.988254
2286	Điểm hệ số 1 #2	381	1	\N	2025-05-11 12:12:13.988254
2287	Điểm hệ số 1 #3	381	1	\N	2025-05-11 12:12:13.988254
2288	Điểm hệ số 2 #1	381	2	\N	2025-05-11 12:12:13.988254
2289	Điểm hệ số 2 #2	381	2	\N	2025-05-11 12:12:13.988254
2290	Điểm hệ số 3	381	3	\N	2025-05-11 12:12:13.988254
2291	Điểm hệ số 1 #1	382	1	\N	2025-05-11 12:12:13.988254
2292	Điểm hệ số 1 #2	382	1	\N	2025-05-11 12:12:13.988254
2293	Điểm hệ số 1 #3	382	1	\N	2025-05-11 12:12:13.988254
2294	Điểm hệ số 2 #1	382	2	\N	2025-05-11 12:12:13.988254
2295	Điểm hệ số 2 #2	382	2	\N	2025-05-11 12:12:13.988254
2296	Điểm hệ số 3	382	3	\N	2025-05-11 12:12:13.988254
2297	Điểm hệ số 1 #1	383	1	\N	2025-05-11 12:12:13.988254
2298	Điểm hệ số 1 #2	383	1	\N	2025-05-11 12:12:13.988254
2299	Điểm hệ số 1 #3	383	1	\N	2025-05-11 12:12:13.988254
2300	Điểm hệ số 2 #1	383	2	\N	2025-05-11 12:12:13.988254
2301	Điểm hệ số 2 #2	383	2	\N	2025-05-11 12:12:13.988254
2302	Điểm hệ số 3	383	3	\N	2025-05-11 12:12:13.988254
2303	Điểm hệ số 1 #1	384	1	\N	2025-05-11 12:12:13.988254
2304	Điểm hệ số 1 #2	384	1	\N	2025-05-11 12:12:13.988254
2305	Điểm hệ số 1 #3	384	1	\N	2025-05-11 12:12:13.988254
2306	Điểm hệ số 2 #1	384	2	\N	2025-05-11 12:12:13.988254
2307	Điểm hệ số 2 #2	384	2	\N	2025-05-11 12:12:13.988254
2308	Điểm hệ số 3	384	3	\N	2025-05-11 12:12:13.988254
2309	Điểm hệ số 1 #1	385	1	\N	2025-05-11 12:12:13.988254
2310	Điểm hệ số 1 #2	385	1	\N	2025-05-11 12:12:13.988254
2311	Điểm hệ số 1 #3	385	1	\N	2025-05-11 12:12:13.988254
2312	Điểm hệ số 2 #1	385	2	\N	2025-05-11 12:12:13.988254
2313	Điểm hệ số 2 #2	385	2	\N	2025-05-11 12:12:13.988254
2314	Điểm hệ số 3	385	3	\N	2025-05-11 12:12:13.988254
2315	Điểm hệ số 1 #1	386	1	\N	2025-05-11 12:12:13.988254
2316	Điểm hệ số 1 #2	386	1	\N	2025-05-11 12:12:13.988254
2317	Điểm hệ số 1 #3	386	1	\N	2025-05-11 12:12:13.988254
2318	Điểm hệ số 2 #1	386	2	\N	2025-05-11 12:12:13.988254
2319	Điểm hệ số 2 #2	386	2	\N	2025-05-11 12:12:13.988254
2320	Điểm hệ số 3	386	3	\N	2025-05-11 12:12:13.988254
2321	Điểm hệ số 1 #1	387	1	\N	2025-05-11 12:12:13.988254
2322	Điểm hệ số 1 #2	387	1	\N	2025-05-11 12:12:13.988254
2323	Điểm hệ số 1 #3	387	1	\N	2025-05-11 12:12:13.988254
2324	Điểm hệ số 2 #1	387	2	\N	2025-05-11 12:12:13.988254
2325	Điểm hệ số 2 #2	387	2	\N	2025-05-11 12:12:13.988254
2326	Điểm hệ số 3	387	3	\N	2025-05-11 12:12:13.988254
2327	Điểm hệ số 1 #1	388	1	\N	2025-05-11 12:12:13.988254
2328	Điểm hệ số 1 #2	388	1	\N	2025-05-11 12:12:13.988254
2329	Điểm hệ số 1 #3	388	1	\N	2025-05-11 12:12:13.988254
2330	Điểm hệ số 2 #1	388	2	\N	2025-05-11 12:12:13.988254
2331	Điểm hệ số 2 #2	388	2	\N	2025-05-11 12:12:13.988254
2332	Điểm hệ số 3	388	3	\N	2025-05-11 12:12:13.988254
2333	Điểm hệ số 1 #1	389	1	\N	2025-05-11 12:12:13.988254
2334	Điểm hệ số 1 #2	389	1	\N	2025-05-11 12:12:13.988254
2335	Điểm hệ số 1 #3	389	1	\N	2025-05-11 12:12:13.988254
2336	Điểm hệ số 2 #1	389	2	\N	2025-05-11 12:12:13.988254
2337	Điểm hệ số 2 #2	389	2	\N	2025-05-11 12:12:13.988254
2338	Điểm hệ số 3	389	3	\N	2025-05-11 12:12:13.988254
2339	Điểm hệ số 1 #1	390	1	\N	2025-05-11 12:12:13.988254
2340	Điểm hệ số 1 #2	390	1	\N	2025-05-11 12:12:13.988254
2341	Điểm hệ số 1 #3	390	1	\N	2025-05-11 12:12:13.988254
2342	Điểm hệ số 2 #1	390	2	\N	2025-05-11 12:12:13.988254
2343	Điểm hệ số 2 #2	390	2	\N	2025-05-11 12:12:13.988254
2344	Điểm hệ số 3	390	3	\N	2025-05-11 12:12:13.988254
2345	Điểm hệ số 1 #1	391	1	\N	2025-05-11 12:12:13.988254
2346	Điểm hệ số 1 #2	391	1	\N	2025-05-11 12:12:13.988254
2347	Điểm hệ số 1 #3	391	1	\N	2025-05-11 12:12:13.988254
2348	Điểm hệ số 2 #1	391	2	\N	2025-05-11 12:12:13.988254
2349	Điểm hệ số 2 #2	391	2	\N	2025-05-11 12:12:13.988254
2350	Điểm hệ số 3	391	3	\N	2025-05-11 12:12:13.988254
2351	Điểm hệ số 1 #1	392	1	\N	2025-05-11 12:12:13.988254
2352	Điểm hệ số 1 #2	392	1	\N	2025-05-11 12:12:13.988254
2353	Điểm hệ số 1 #3	392	1	\N	2025-05-11 12:12:13.988254
2354	Điểm hệ số 2 #1	392	2	\N	2025-05-11 12:12:13.988254
2355	Điểm hệ số 2 #2	392	2	\N	2025-05-11 12:12:13.988254
2356	Điểm hệ số 3	392	3	\N	2025-05-11 12:12:13.988254
2357	Điểm hệ số 1 #1	393	1	\N	2025-05-11 12:12:13.988254
2358	Điểm hệ số 1 #2	393	1	\N	2025-05-11 12:12:13.988254
2359	Điểm hệ số 1 #3	393	1	\N	2025-05-11 12:12:13.988254
2360	Điểm hệ số 2 #1	393	2	\N	2025-05-11 12:12:13.988254
2361	Điểm hệ số 2 #2	393	2	\N	2025-05-11 12:12:13.988254
2362	Điểm hệ số 3	393	3	\N	2025-05-11 12:12:13.988254
2363	Điểm hệ số 1 #1	394	1	\N	2025-05-11 12:12:13.988254
2364	Điểm hệ số 1 #2	394	1	\N	2025-05-11 12:12:13.988254
2365	Điểm hệ số 1 #3	394	1	\N	2025-05-11 12:12:13.988254
2366	Điểm hệ số 2 #1	394	2	\N	2025-05-11 12:12:13.988254
2367	Điểm hệ số 2 #2	394	2	\N	2025-05-11 12:12:13.988254
2368	Điểm hệ số 3	394	3	\N	2025-05-11 12:12:13.988254
2369	Điểm hệ số 1 #1	395	1	\N	2025-05-11 12:12:13.988254
2370	Điểm hệ số 1 #2	395	1	\N	2025-05-11 12:12:13.988254
2371	Điểm hệ số 1 #3	395	1	\N	2025-05-11 12:12:13.988254
2372	Điểm hệ số 2 #1	395	2	\N	2025-05-11 12:12:13.988254
2373	Điểm hệ số 2 #2	395	2	\N	2025-05-11 12:12:13.988254
2374	Điểm hệ số 3	395	3	\N	2025-05-11 12:12:13.988254
2375	Điểm hệ số 1 #1	396	1	\N	2025-05-11 12:12:13.988254
2376	Điểm hệ số 1 #2	396	1	\N	2025-05-11 12:12:13.988254
2377	Điểm hệ số 1 #3	396	1	\N	2025-05-11 12:12:13.988254
2378	Điểm hệ số 2 #1	396	2	\N	2025-05-11 12:12:13.988254
2379	Điểm hệ số 2 #2	396	2	\N	2025-05-11 12:12:13.988254
2380	Điểm hệ số 3	396	3	\N	2025-05-11 12:12:13.988254
2381	Điểm hệ số 1 #1	397	1	\N	2025-05-11 12:12:13.988254
2382	Điểm hệ số 1 #2	397	1	\N	2025-05-11 12:12:13.988254
2383	Điểm hệ số 1 #3	397	1	\N	2025-05-11 12:12:13.988254
2384	Điểm hệ số 2 #1	397	2	\N	2025-05-11 12:12:13.988254
2385	Điểm hệ số 2 #2	397	2	\N	2025-05-11 12:12:13.988254
2386	Điểm hệ số 3	397	3	\N	2025-05-11 12:12:13.988254
2387	Điểm hệ số 1 #1	398	1	\N	2025-05-11 12:12:13.988254
2388	Điểm hệ số 1 #2	398	1	\N	2025-05-11 12:12:13.988254
2389	Điểm hệ số 1 #3	398	1	\N	2025-05-11 12:12:13.988254
2390	Điểm hệ số 2 #1	398	2	\N	2025-05-11 12:12:13.988254
2391	Điểm hệ số 2 #2	398	2	\N	2025-05-11 12:12:13.988254
2392	Điểm hệ số 3	398	3	\N	2025-05-11 12:12:13.988254
2393	Điểm hệ số 1 #1	399	1	\N	2025-05-11 12:12:13.988254
2394	Điểm hệ số 1 #2	399	1	\N	2025-05-11 12:12:13.988254
2395	Điểm hệ số 1 #3	399	1	\N	2025-05-11 12:12:13.988254
2396	Điểm hệ số 2 #1	399	2	\N	2025-05-11 12:12:13.988254
2397	Điểm hệ số 2 #2	399	2	\N	2025-05-11 12:12:13.988254
2398	Điểm hệ số 3	399	3	\N	2025-05-11 12:12:13.988254
2399	Điểm hệ số 1 #1	400	1	\N	2025-05-11 12:12:13.988254
2400	Điểm hệ số 1 #2	400	1	\N	2025-05-11 12:12:13.988254
2401	Điểm hệ số 1 #3	400	1	\N	2025-05-11 12:12:13.988254
2402	Điểm hệ số 2 #1	400	2	\N	2025-05-11 12:12:13.988254
2403	Điểm hệ số 2 #2	400	2	\N	2025-05-11 12:12:13.988254
2404	Điểm hệ số 3	400	3	\N	2025-05-11 12:12:13.988254
2405	Điểm hệ số 1 #1	401	1	\N	2025-05-11 12:12:13.988254
2406	Điểm hệ số 1 #2	401	1	\N	2025-05-11 12:12:13.988254
2407	Điểm hệ số 1 #3	401	1	\N	2025-05-11 12:12:13.988254
2408	Điểm hệ số 2 #1	401	2	\N	2025-05-11 12:12:13.988254
2409	Điểm hệ số 2 #2	401	2	\N	2025-05-11 12:12:13.988254
2410	Điểm hệ số 3	401	3	\N	2025-05-11 12:12:13.988254
2411	Điểm hệ số 1 #1	402	1	\N	2025-05-11 12:12:13.988254
2412	Điểm hệ số 1 #2	402	1	\N	2025-05-11 12:12:13.988254
2413	Điểm hệ số 1 #3	402	1	\N	2025-05-11 12:12:13.988254
2414	Điểm hệ số 2 #1	402	2	\N	2025-05-11 12:12:13.988254
2415	Điểm hệ số 2 #2	402	2	\N	2025-05-11 12:12:13.988254
2416	Điểm hệ số 3	402	3	\N	2025-05-11 12:12:13.988254
2417	Điểm hệ số 1 #1	403	1	\N	2025-05-11 12:12:13.988254
2418	Điểm hệ số 1 #2	403	1	\N	2025-05-11 12:12:13.988254
2419	Điểm hệ số 1 #3	403	1	\N	2025-05-11 12:12:13.988254
2420	Điểm hệ số 2 #1	403	2	\N	2025-05-11 12:12:13.988254
2421	Điểm hệ số 2 #2	403	2	\N	2025-05-11 12:12:13.988254
2422	Điểm hệ số 3	403	3	\N	2025-05-11 12:12:13.988254
2423	Điểm hệ số 1 #1	404	1	\N	2025-05-11 12:12:13.988254
2424	Điểm hệ số 1 #2	404	1	\N	2025-05-11 12:12:13.988254
2425	Điểm hệ số 1 #3	404	1	\N	2025-05-11 12:12:13.988254
2426	Điểm hệ số 2 #1	404	2	\N	2025-05-11 12:12:13.988254
2427	Điểm hệ số 2 #2	404	2	\N	2025-05-11 12:12:13.988254
2428	Điểm hệ số 3	404	3	\N	2025-05-11 12:12:13.988254
2429	Điểm hệ số 1 #1	405	1	\N	2025-05-11 12:12:13.988254
2430	Điểm hệ số 1 #2	405	1	\N	2025-05-11 12:12:13.988254
2431	Điểm hệ số 1 #3	405	1	\N	2025-05-11 12:12:13.988254
2432	Điểm hệ số 2 #1	405	2	\N	2025-05-11 12:12:13.988254
2433	Điểm hệ số 2 #2	405	2	\N	2025-05-11 12:12:13.988254
2434	Điểm hệ số 3	405	3	\N	2025-05-11 12:12:13.988254
2435	Điểm hệ số 1 #1	406	1	\N	2025-05-11 12:12:13.988254
2436	Điểm hệ số 1 #2	406	1	\N	2025-05-11 12:12:13.988254
2437	Điểm hệ số 1 #3	406	1	\N	2025-05-11 12:12:13.988254
2438	Điểm hệ số 2 #1	406	2	\N	2025-05-11 12:12:13.988254
2439	Điểm hệ số 2 #2	406	2	\N	2025-05-11 12:12:13.988254
2440	Điểm hệ số 3	406	3	\N	2025-05-11 12:12:13.988254
2441	Điểm hệ số 1 #1	407	1	\N	2025-05-11 12:12:13.988254
2442	Điểm hệ số 1 #2	407	1	\N	2025-05-11 12:12:13.988254
2443	Điểm hệ số 1 #3	407	1	\N	2025-05-11 12:12:13.988254
2444	Điểm hệ số 2 #1	407	2	\N	2025-05-11 12:12:13.988254
2445	Điểm hệ số 2 #2	407	2	\N	2025-05-11 12:12:13.988254
2446	Điểm hệ số 3	407	3	\N	2025-05-11 12:12:13.988254
2447	Điểm hệ số 1 #1	408	1	\N	2025-05-11 12:12:13.988254
2448	Điểm hệ số 1 #2	408	1	\N	2025-05-11 12:12:13.988254
2449	Điểm hệ số 1 #3	408	1	\N	2025-05-11 12:12:13.988254
2450	Điểm hệ số 2 #1	408	2	\N	2025-05-11 12:12:13.988254
2451	Điểm hệ số 2 #2	408	2	\N	2025-05-11 12:12:13.988254
2452	Điểm hệ số 3	408	3	\N	2025-05-11 12:12:13.988254
2453	Điểm hệ số 1 #1	409	1	\N	2025-05-11 12:12:13.988254
2454	Điểm hệ số 1 #2	409	1	\N	2025-05-11 12:12:13.988254
2455	Điểm hệ số 1 #3	409	1	\N	2025-05-11 12:12:13.989791
2456	Điểm hệ số 2 #1	409	2	\N	2025-05-11 12:12:13.989791
2457	Điểm hệ số 2 #2	409	2	\N	2025-05-11 12:12:13.989791
2458	Điểm hệ số 3	409	3	\N	2025-05-11 12:12:13.989791
2459	Điểm hệ số 1 #1	410	1	\N	2025-05-11 12:12:13.989791
2460	Điểm hệ số 1 #2	410	1	\N	2025-05-11 12:12:13.989791
2461	Điểm hệ số 1 #3	410	1	\N	2025-05-11 12:12:13.989791
2462	Điểm hệ số 2 #1	410	2	\N	2025-05-11 12:12:13.989791
2463	Điểm hệ số 2 #2	410	2	\N	2025-05-11 12:12:13.989791
2464	Điểm hệ số 3	410	3	\N	2025-05-11 12:12:13.989791
2465	Điểm hệ số 1 #1	411	1	\N	2025-05-11 12:12:13.989791
2466	Điểm hệ số 1 #2	411	1	\N	2025-05-11 12:12:13.989791
2467	Điểm hệ số 1 #3	411	1	\N	2025-05-11 12:12:13.989791
2468	Điểm hệ số 2 #1	411	2	\N	2025-05-11 12:12:13.989791
2469	Điểm hệ số 2 #2	411	2	\N	2025-05-11 12:12:13.989791
2470	Điểm hệ số 3	411	3	\N	2025-05-11 12:12:13.989791
2471	Điểm hệ số 1 #1	412	1	\N	2025-05-11 12:12:13.989791
2472	Điểm hệ số 1 #2	412	1	\N	2025-05-11 12:12:13.989791
2473	Điểm hệ số 1 #3	412	1	\N	2025-05-11 12:12:13.989791
2474	Điểm hệ số 2 #1	412	2	\N	2025-05-11 12:12:13.989791
2475	Điểm hệ số 2 #2	412	2	\N	2025-05-11 12:12:13.989791
2476	Điểm hệ số 3	412	3	\N	2025-05-11 12:12:13.989791
2477	Điểm hệ số 1 #1	413	1	\N	2025-05-11 12:12:13.989791
2478	Điểm hệ số 1 #2	413	1	\N	2025-05-11 12:12:13.989791
2479	Điểm hệ số 1 #3	413	1	\N	2025-05-11 12:12:13.989791
2480	Điểm hệ số 2 #1	413	2	\N	2025-05-11 12:12:13.989791
2481	Điểm hệ số 2 #2	413	2	\N	2025-05-11 12:12:13.989791
2482	Điểm hệ số 3	413	3	\N	2025-05-11 12:12:13.989791
2483	Điểm hệ số 1 #1	414	1	\N	2025-05-11 12:12:13.989791
2484	Điểm hệ số 1 #2	414	1	\N	2025-05-11 12:12:13.989791
2485	Điểm hệ số 1 #3	414	1	\N	2025-05-11 12:12:13.989791
2486	Điểm hệ số 2 #1	414	2	\N	2025-05-11 12:12:13.989791
2487	Điểm hệ số 2 #2	414	2	\N	2025-05-11 12:12:13.989791
2488	Điểm hệ số 3	414	3	\N	2025-05-11 12:12:13.989791
2489	Điểm hệ số 1 #1	415	1	\N	2025-05-11 12:12:13.989791
2490	Điểm hệ số 1 #2	415	1	\N	2025-05-11 12:12:13.989791
2491	Điểm hệ số 1 #3	415	1	\N	2025-05-11 12:12:13.989791
2492	Điểm hệ số 2 #1	415	2	\N	2025-05-11 12:12:13.989791
2493	Điểm hệ số 2 #2	415	2	\N	2025-05-11 12:12:13.989791
2494	Điểm hệ số 3	415	3	\N	2025-05-11 12:12:13.989791
2495	Điểm hệ số 1 #1	416	1	\N	2025-05-11 12:12:13.989791
2496	Điểm hệ số 1 #2	416	1	\N	2025-05-11 12:12:13.989791
2497	Điểm hệ số 1 #3	416	1	\N	2025-05-11 12:12:13.989791
2498	Điểm hệ số 2 #1	416	2	\N	2025-05-11 12:12:13.989791
2499	Điểm hệ số 2 #2	416	2	\N	2025-05-11 12:12:13.989791
2500	Điểm hệ số 3	416	3	\N	2025-05-11 12:12:13.989791
2501	Điểm hệ số 1 #1	417	1	\N	2025-05-11 12:12:13.989791
2502	Điểm hệ số 1 #2	417	1	\N	2025-05-11 12:12:13.989791
2503	Điểm hệ số 1 #3	417	1	\N	2025-05-11 12:12:13.989791
2504	Điểm hệ số 2 #1	417	2	\N	2025-05-11 12:12:13.989791
2505	Điểm hệ số 2 #2	417	2	\N	2025-05-11 12:12:13.989791
2506	Điểm hệ số 3	417	3	\N	2025-05-11 12:12:13.989791
2507	Điểm hệ số 1 #1	418	1	\N	2025-05-11 12:12:13.989791
2508	Điểm hệ số 1 #2	418	1	\N	2025-05-11 12:12:13.989791
2509	Điểm hệ số 1 #3	418	1	\N	2025-05-11 12:12:13.989791
2510	Điểm hệ số 2 #1	418	2	\N	2025-05-11 12:12:13.989791
2511	Điểm hệ số 2 #2	418	2	\N	2025-05-11 12:12:13.989791
2512	Điểm hệ số 3	418	3	\N	2025-05-11 12:12:13.989791
2513	Điểm hệ số 1 #1	419	1	\N	2025-05-11 12:12:13.989791
2514	Điểm hệ số 1 #2	419	1	\N	2025-05-11 12:12:13.989791
2515	Điểm hệ số 1 #3	419	1	\N	2025-05-11 12:12:13.989791
2516	Điểm hệ số 2 #1	419	2	\N	2025-05-11 12:12:13.989791
2517	Điểm hệ số 2 #2	419	2	\N	2025-05-11 12:12:13.989791
2518	Điểm hệ số 3	419	3	\N	2025-05-11 12:12:13.989791
2519	Điểm hệ số 1 #1	420	1	\N	2025-05-11 12:12:13.989791
2520	Điểm hệ số 1 #2	420	1	\N	2025-05-11 12:12:13.989791
2521	Điểm hệ số 1 #3	420	1	\N	2025-05-11 12:12:13.989791
2522	Điểm hệ số 2 #1	420	2	\N	2025-05-11 12:12:13.989791
2523	Điểm hệ số 2 #2	420	2	\N	2025-05-11 12:12:13.989791
2524	Điểm hệ số 3	420	3	\N	2025-05-11 12:12:13.989791
2525	Điểm hệ số 1 #1	421	1	\N	2025-05-11 12:12:13.989791
2526	Điểm hệ số 1 #2	421	1	\N	2025-05-11 12:12:13.989791
2527	Điểm hệ số 1 #3	421	1	\N	2025-05-11 12:12:13.989791
2528	Điểm hệ số 2 #1	421	2	\N	2025-05-11 12:12:13.989791
2529	Điểm hệ số 2 #2	421	2	\N	2025-05-11 12:12:13.989791
2530	Điểm hệ số 3	421	3	\N	2025-05-11 12:12:13.989791
2531	Điểm hệ số 1 #1	422	1	\N	2025-05-11 12:12:13.989791
2532	Điểm hệ số 1 #2	422	1	\N	2025-05-11 12:12:13.989791
2533	Điểm hệ số 1 #3	422	1	\N	2025-05-11 12:12:13.989791
2534	Điểm hệ số 2 #1	422	2	\N	2025-05-11 12:12:13.989791
2535	Điểm hệ số 2 #2	422	2	\N	2025-05-11 12:12:13.989791
2536	Điểm hệ số 3	422	3	\N	2025-05-11 12:12:13.989791
2537	Điểm hệ số 1 #1	423	1	\N	2025-05-11 12:12:13.989791
2538	Điểm hệ số 1 #2	423	1	\N	2025-05-11 12:12:13.989791
2539	Điểm hệ số 1 #3	423	1	\N	2025-05-11 12:12:13.989791
2540	Điểm hệ số 2 #1	423	2	\N	2025-05-11 12:12:13.989791
2541	Điểm hệ số 2 #2	423	2	\N	2025-05-11 12:12:13.989791
2542	Điểm hệ số 3	423	3	\N	2025-05-11 12:12:13.989791
2543	Điểm hệ số 1 #1	424	1	\N	2025-05-11 12:12:13.989791
2544	Điểm hệ số 1 #2	424	1	\N	2025-05-11 12:12:13.989791
2545	Điểm hệ số 1 #3	424	1	\N	2025-05-11 12:12:13.989791
2546	Điểm hệ số 2 #1	424	2	\N	2025-05-11 12:12:13.989791
2547	Điểm hệ số 2 #2	424	2	\N	2025-05-11 12:12:13.989791
2548	Điểm hệ số 3	424	3	\N	2025-05-11 12:12:13.989791
2549	Điểm hệ số 1 #1	425	1	\N	2025-05-11 12:12:13.989791
2550	Điểm hệ số 1 #2	425	1	\N	2025-05-11 12:12:13.989791
2551	Điểm hệ số 1 #3	425	1	\N	2025-05-11 12:12:13.989791
2552	Điểm hệ số 2 #1	425	2	\N	2025-05-11 12:12:13.989791
2553	Điểm hệ số 2 #2	425	2	\N	2025-05-11 12:12:13.989791
2554	Điểm hệ số 3	425	3	\N	2025-05-11 12:12:13.989791
2555	Điểm hệ số 1 #1	426	1	\N	2025-05-11 12:12:13.989791
2556	Điểm hệ số 1 #2	426	1	\N	2025-05-11 12:12:13.989791
2557	Điểm hệ số 1 #3	426	1	\N	2025-05-11 12:12:13.989791
2558	Điểm hệ số 2 #1	426	2	\N	2025-05-11 12:12:13.989791
2559	Điểm hệ số 2 #2	426	2	\N	2025-05-11 12:12:13.989791
2560	Điểm hệ số 3	426	3	\N	2025-05-11 12:12:13.989791
2561	Điểm hệ số 1 #1	427	1	\N	2025-05-11 12:12:13.989791
2562	Điểm hệ số 1 #2	427	1	\N	2025-05-11 12:12:13.989791
2563	Điểm hệ số 1 #3	427	1	\N	2025-05-11 12:12:13.989791
2564	Điểm hệ số 2 #1	427	2	\N	2025-05-11 12:12:13.989791
2565	Điểm hệ số 2 #2	427	2	\N	2025-05-11 12:12:13.989791
2566	Điểm hệ số 3	427	3	\N	2025-05-11 12:12:13.989791
2567	Điểm hệ số 1 #1	428	1	\N	2025-05-11 12:12:13.989791
2568	Điểm hệ số 1 #2	428	1	\N	2025-05-11 12:12:13.989791
2569	Điểm hệ số 1 #3	428	1	\N	2025-05-11 12:12:13.989791
2570	Điểm hệ số 2 #1	428	2	\N	2025-05-11 12:12:13.989791
2571	Điểm hệ số 2 #2	428	2	\N	2025-05-11 12:12:13.989791
2572	Điểm hệ số 3	428	3	\N	2025-05-11 12:12:13.989791
2573	Điểm hệ số 1 #1	429	1	\N	2025-05-11 12:12:13.989791
2574	Điểm hệ số 1 #2	429	1	\N	2025-05-11 12:12:13.989791
2575	Điểm hệ số 1 #3	429	1	\N	2025-05-11 12:12:13.989791
2576	Điểm hệ số 2 #1	429	2	\N	2025-05-11 12:12:13.989791
2577	Điểm hệ số 2 #2	429	2	\N	2025-05-11 12:12:13.989791
2578	Điểm hệ số 3	429	3	\N	2025-05-11 12:12:13.989791
2579	Điểm hệ số 1 #1	430	1	\N	2025-05-11 12:12:13.989791
2580	Điểm hệ số 1 #2	430	1	\N	2025-05-11 12:12:13.989791
2581	Điểm hệ số 1 #3	430	1	\N	2025-05-11 12:12:13.989791
2582	Điểm hệ số 2 #1	430	2	\N	2025-05-11 12:12:13.989791
2583	Điểm hệ số 2 #2	430	2	\N	2025-05-11 12:12:13.989791
2584	Điểm hệ số 3	430	3	\N	2025-05-11 12:12:13.989791
2585	Điểm hệ số 1 #1	431	1	\N	2025-05-11 12:12:13.989791
2586	Điểm hệ số 1 #2	431	1	\N	2025-05-11 12:12:13.989791
2587	Điểm hệ số 1 #3	431	1	\N	2025-05-11 12:12:13.989791
2588	Điểm hệ số 2 #1	431	2	\N	2025-05-11 12:12:13.989791
2589	Điểm hệ số 2 #2	431	2	\N	2025-05-11 12:12:13.989791
2590	Điểm hệ số 3	431	3	\N	2025-05-11 12:12:13.989791
2591	Điểm hệ số 1 #1	432	1	\N	2025-05-11 12:12:14.978883
2592	Điểm hệ số 1 #2	432	1	\N	2025-05-11 12:12:14.978883
2593	Điểm hệ số 1 #3	432	1	\N	2025-05-11 12:12:14.978883
2594	Điểm hệ số 2 #1	432	2	\N	2025-05-11 12:12:14.978883
2595	Điểm hệ số 2 #2	432	2	\N	2025-05-11 12:12:14.978883
2596	Điểm hệ số 3	432	3	\N	2025-05-11 12:12:14.978883
2597	Điểm hệ số 1 #1	433	1	\N	2025-05-11 12:12:14.978883
2598	Điểm hệ số 1 #2	433	1	\N	2025-05-11 12:12:14.978883
2599	Điểm hệ số 1 #3	433	1	\N	2025-05-11 12:12:14.978883
2600	Điểm hệ số 2 #1	433	2	\N	2025-05-11 12:12:14.978883
2601	Điểm hệ số 2 #2	433	2	\N	2025-05-11 12:12:14.978883
2602	Điểm hệ số 3	433	3	\N	2025-05-11 12:12:14.978883
2603	Điểm hệ số 1 #1	434	1	\N	2025-05-11 12:12:14.978883
2604	Điểm hệ số 1 #2	434	1	\N	2025-05-11 12:12:14.978883
2605	Điểm hệ số 1 #3	434	1	\N	2025-05-11 12:12:14.978883
2606	Điểm hệ số 2 #1	434	2	\N	2025-05-11 12:12:14.978883
2607	Điểm hệ số 2 #2	434	2	\N	2025-05-11 12:12:14.978883
2608	Điểm hệ số 3	434	3	\N	2025-05-11 12:12:14.978883
2609	Điểm hệ số 1 #1	435	1	\N	2025-05-11 12:12:14.978883
2610	Điểm hệ số 1 #2	435	1	\N	2025-05-11 12:12:14.978883
2611	Điểm hệ số 1 #3	435	1	\N	2025-05-11 12:12:14.978883
2612	Điểm hệ số 2 #1	435	2	\N	2025-05-11 12:12:14.978883
2613	Điểm hệ số 2 #2	435	2	\N	2025-05-11 12:12:14.978883
2614	Điểm hệ số 3	435	3	\N	2025-05-11 12:12:14.978883
2615	Điểm hệ số 1 #1	436	1	\N	2025-05-11 12:12:14.978883
2616	Điểm hệ số 1 #2	436	1	\N	2025-05-11 12:12:14.978883
2617	Điểm hệ số 1 #3	436	1	\N	2025-05-11 12:12:14.978883
2618	Điểm hệ số 2 #1	436	2	\N	2025-05-11 12:12:14.978883
2619	Điểm hệ số 2 #2	436	2	\N	2025-05-11 12:12:14.978883
2620	Điểm hệ số 3	436	3	\N	2025-05-11 12:12:14.978883
2621	Điểm hệ số 1 #1	437	1	\N	2025-05-11 12:12:14.978883
2622	Điểm hệ số 1 #2	437	1	\N	2025-05-11 12:12:14.978883
2623	Điểm hệ số 1 #3	437	1	\N	2025-05-11 12:12:14.978883
2624	Điểm hệ số 2 #1	437	2	\N	2025-05-11 12:12:14.978883
2625	Điểm hệ số 2 #2	437	2	\N	2025-05-11 12:12:14.978883
2626	Điểm hệ số 3	437	3	\N	2025-05-11 12:12:14.978883
2627	Điểm hệ số 1 #1	438	1	\N	2025-05-11 12:12:14.978883
2628	Điểm hệ số 1 #2	438	1	\N	2025-05-11 12:12:14.978883
2629	Điểm hệ số 1 #3	438	1	\N	2025-05-11 12:12:14.978883
2630	Điểm hệ số 2 #1	438	2	\N	2025-05-11 12:12:14.978883
2631	Điểm hệ số 2 #2	438	2	\N	2025-05-11 12:12:14.978883
2632	Điểm hệ số 3	438	3	\N	2025-05-11 12:12:14.978883
2633	Điểm hệ số 1 #1	439	1	\N	2025-05-11 12:12:14.978883
2634	Điểm hệ số 1 #2	439	1	\N	2025-05-11 12:12:14.978883
2635	Điểm hệ số 1 #3	439	1	\N	2025-05-11 12:12:14.978883
2636	Điểm hệ số 2 #1	439	2	\N	2025-05-11 12:12:14.978883
2637	Điểm hệ số 2 #2	439	2	\N	2025-05-11 12:12:14.978883
2638	Điểm hệ số 3	439	3	\N	2025-05-11 12:12:14.978883
2639	Điểm hệ số 1 #1	440	1	\N	2025-05-11 12:12:14.978883
2640	Điểm hệ số 1 #2	440	1	\N	2025-05-11 12:12:14.978883
2641	Điểm hệ số 1 #3	440	1	\N	2025-05-11 12:12:14.978883
2642	Điểm hệ số 2 #1	440	2	\N	2025-05-11 12:12:14.978883
2643	Điểm hệ số 2 #2	440	2	\N	2025-05-11 12:12:14.978883
2644	Điểm hệ số 3	440	3	\N	2025-05-11 12:12:14.978883
2645	Điểm hệ số 1 #1	441	1	\N	2025-05-11 12:12:14.978883
2646	Điểm hệ số 1 #2	441	1	\N	2025-05-11 12:12:14.978883
2647	Điểm hệ số 1 #3	441	1	\N	2025-05-11 12:12:14.978883
2648	Điểm hệ số 2 #1	441	2	\N	2025-05-11 12:12:14.978883
2649	Điểm hệ số 2 #2	441	2	\N	2025-05-11 12:12:14.978883
2650	Điểm hệ số 3	441	3	\N	2025-05-11 12:12:14.978883
2651	Điểm hệ số 1 #1	442	1	\N	2025-05-11 12:12:14.978883
2652	Điểm hệ số 1 #2	442	1	\N	2025-05-11 12:12:14.978883
2653	Điểm hệ số 1 #3	442	1	\N	2025-05-11 12:12:14.978883
2654	Điểm hệ số 2 #1	442	2	\N	2025-05-11 12:12:14.978883
2655	Điểm hệ số 2 #2	442	2	\N	2025-05-11 12:12:14.978883
2656	Điểm hệ số 3	442	3	\N	2025-05-11 12:12:14.978883
2657	Điểm hệ số 1 #1	443	1	\N	2025-05-11 12:12:14.978883
2658	Điểm hệ số 1 #2	443	1	\N	2025-05-11 12:12:14.978883
2659	Điểm hệ số 1 #3	443	1	\N	2025-05-11 12:12:14.978883
2660	Điểm hệ số 2 #1	443	2	\N	2025-05-11 12:12:14.978883
2661	Điểm hệ số 2 #2	443	2	\N	2025-05-11 12:12:14.978883
2662	Điểm hệ số 3	443	3	\N	2025-05-11 12:12:14.978883
2663	Điểm hệ số 1 #1	444	1	\N	2025-05-11 12:12:14.978883
2664	Điểm hệ số 1 #2	444	1	\N	2025-05-11 12:12:14.978883
2665	Điểm hệ số 1 #3	444	1	\N	2025-05-11 12:12:14.978883
2666	Điểm hệ số 2 #1	444	2	\N	2025-05-11 12:12:14.978883
2667	Điểm hệ số 2 #2	444	2	\N	2025-05-11 12:12:14.978883
2668	Điểm hệ số 3	444	3	\N	2025-05-11 12:12:14.978883
2669	Điểm hệ số 1 #1	445	1	\N	2025-05-11 12:12:14.978883
2670	Điểm hệ số 1 #2	445	1	\N	2025-05-11 12:12:14.978883
2671	Điểm hệ số 1 #3	445	1	\N	2025-05-11 12:12:14.978883
2672	Điểm hệ số 2 #1	445	2	\N	2025-05-11 12:12:14.978883
2673	Điểm hệ số 2 #2	445	2	\N	2025-05-11 12:12:14.978883
2674	Điểm hệ số 3	445	3	\N	2025-05-11 12:12:14.978883
2675	Điểm hệ số 1 #1	446	1	\N	2025-05-11 12:12:14.978883
2676	Điểm hệ số 1 #2	446	1	\N	2025-05-11 12:12:14.978883
2677	Điểm hệ số 1 #3	446	1	\N	2025-05-11 12:12:14.978883
2678	Điểm hệ số 2 #1	446	2	\N	2025-05-11 12:12:14.978883
2679	Điểm hệ số 2 #2	446	2	\N	2025-05-11 12:12:14.978883
2680	Điểm hệ số 3	446	3	\N	2025-05-11 12:12:14.978883
2681	Điểm hệ số 1 #1	447	1	\N	2025-05-11 12:12:14.978883
2682	Điểm hệ số 1 #2	447	1	\N	2025-05-11 12:12:14.978883
2683	Điểm hệ số 1 #3	447	1	\N	2025-05-11 12:12:14.978883
2684	Điểm hệ số 2 #1	447	2	\N	2025-05-11 12:12:14.978883
2685	Điểm hệ số 2 #2	447	2	\N	2025-05-11 12:12:14.978883
2686	Điểm hệ số 3	447	3	\N	2025-05-11 12:12:14.978883
2687	Điểm hệ số 1 #1	448	1	\N	2025-05-11 12:12:14.978883
2688	Điểm hệ số 1 #2	448	1	\N	2025-05-11 12:12:14.978883
2689	Điểm hệ số 1 #3	448	1	\N	2025-05-11 12:12:14.978883
2690	Điểm hệ số 2 #1	448	2	\N	2025-05-11 12:12:14.978883
2691	Điểm hệ số 2 #2	448	2	\N	2025-05-11 12:12:14.978883
2692	Điểm hệ số 3	448	3	\N	2025-05-11 12:12:14.978883
2693	Điểm hệ số 1 #1	449	1	\N	2025-05-11 12:12:14.978883
2694	Điểm hệ số 1 #2	449	1	\N	2025-05-11 12:12:14.978883
2695	Điểm hệ số 1 #3	449	1	\N	2025-05-11 12:12:14.978883
2696	Điểm hệ số 2 #1	449	2	\N	2025-05-11 12:12:14.978883
2697	Điểm hệ số 2 #2	449	2	\N	2025-05-11 12:12:14.978883
2698	Điểm hệ số 3	449	3	\N	2025-05-11 12:12:14.978883
2699	Điểm hệ số 1 #1	450	1	\N	2025-05-11 12:12:14.978883
2700	Điểm hệ số 1 #2	450	1	\N	2025-05-11 12:12:14.978883
2701	Điểm hệ số 1 #3	450	1	\N	2025-05-11 12:12:14.978883
2702	Điểm hệ số 2 #1	450	2	\N	2025-05-11 12:12:14.978883
2703	Điểm hệ số 2 #2	450	2	\N	2025-05-11 12:12:14.978883
2704	Điểm hệ số 3	450	3	\N	2025-05-11 12:12:14.978883
2705	Điểm hệ số 1 #1	451	1	\N	2025-05-11 12:12:14.978883
2706	Điểm hệ số 1 #2	451	1	\N	2025-05-11 12:12:14.978883
2707	Điểm hệ số 1 #3	451	1	\N	2025-05-11 12:12:14.978883
2708	Điểm hệ số 2 #1	451	2	\N	2025-05-11 12:12:14.978883
2709	Điểm hệ số 2 #2	451	2	\N	2025-05-11 12:12:14.978883
2710	Điểm hệ số 3	451	3	\N	2025-05-11 12:12:14.978883
2711	Điểm hệ số 1 #1	452	1	\N	2025-05-11 12:12:14.978883
2712	Điểm hệ số 1 #2	452	1	\N	2025-05-11 12:12:14.978883
2713	Điểm hệ số 1 #3	452	1	\N	2025-05-11 12:12:14.978883
2714	Điểm hệ số 2 #1	452	2	\N	2025-05-11 12:12:14.978883
2715	Điểm hệ số 2 #2	452	2	\N	2025-05-11 12:12:14.978883
2716	Điểm hệ số 3	452	3	\N	2025-05-11 12:12:14.978883
2717	Điểm hệ số 1 #1	453	1	\N	2025-05-11 12:12:14.978883
2718	Điểm hệ số 1 #2	453	1	\N	2025-05-11 12:12:14.978883
2719	Điểm hệ số 1 #3	453	1	\N	2025-05-11 12:12:14.978883
2720	Điểm hệ số 2 #1	453	2	\N	2025-05-11 12:12:14.978883
2721	Điểm hệ số 2 #2	453	2	\N	2025-05-11 12:12:14.978883
2722	Điểm hệ số 3	453	3	\N	2025-05-11 12:12:14.978883
2723	Điểm hệ số 1 #1	454	1	\N	2025-05-11 12:12:14.978883
2724	Điểm hệ số 1 #2	454	1	\N	2025-05-11 12:12:14.978883
2725	Điểm hệ số 1 #3	454	1	\N	2025-05-11 12:12:14.978883
2726	Điểm hệ số 2 #1	454	2	\N	2025-05-11 12:12:14.978883
2727	Điểm hệ số 2 #2	454	2	\N	2025-05-11 12:12:14.978883
2728	Điểm hệ số 3	454	3	\N	2025-05-11 12:12:14.978883
2729	Điểm hệ số 1 #1	455	1	\N	2025-05-11 12:12:14.978883
2730	Điểm hệ số 1 #2	455	1	\N	2025-05-11 12:12:14.978883
2731	Điểm hệ số 1 #3	455	1	\N	2025-05-11 12:12:14.978883
2732	Điểm hệ số 2 #1	455	2	\N	2025-05-11 12:12:14.978883
2733	Điểm hệ số 2 #2	455	2	\N	2025-05-11 12:12:14.978883
2734	Điểm hệ số 3	455	3	\N	2025-05-11 12:12:14.978883
2735	Điểm hệ số 1 #1	456	1	\N	2025-05-11 12:12:14.978883
2736	Điểm hệ số 1 #2	456	1	\N	2025-05-11 12:12:14.978883
2737	Điểm hệ số 1 #3	456	1	\N	2025-05-11 12:12:14.978883
2738	Điểm hệ số 2 #1	456	2	\N	2025-05-11 12:12:14.978883
2739	Điểm hệ số 2 #2	456	2	\N	2025-05-11 12:12:14.978883
2740	Điểm hệ số 3	456	3	\N	2025-05-11 12:12:14.978883
2741	Điểm hệ số 1 #1	457	1	\N	2025-05-11 12:12:14.978883
2742	Điểm hệ số 1 #2	457	1	\N	2025-05-11 12:12:14.978883
2743	Điểm hệ số 1 #3	457	1	\N	2025-05-11 12:12:14.978883
2744	Điểm hệ số 2 #1	457	2	\N	2025-05-11 12:12:14.978883
2745	Điểm hệ số 2 #2	457	2	\N	2025-05-11 12:12:14.978883
2746	Điểm hệ số 3	457	3	\N	2025-05-11 12:12:14.979889
2747	Điểm hệ số 1 #1	458	1	\N	2025-05-11 12:12:14.979889
2748	Điểm hệ số 1 #2	458	1	\N	2025-05-11 12:12:14.979889
2749	Điểm hệ số 1 #3	458	1	\N	2025-05-11 12:12:14.979889
2750	Điểm hệ số 2 #1	458	2	\N	2025-05-11 12:12:14.979889
2751	Điểm hệ số 2 #2	458	2	\N	2025-05-11 12:12:14.979889
2752	Điểm hệ số 3	458	3	\N	2025-05-11 12:12:14.979889
2753	Điểm hệ số 1 #1	459	1	\N	2025-05-11 12:12:14.979889
2754	Điểm hệ số 1 #2	459	1	\N	2025-05-11 12:12:14.979889
2755	Điểm hệ số 1 #3	459	1	\N	2025-05-11 12:12:14.979889
2756	Điểm hệ số 2 #1	459	2	\N	2025-05-11 12:12:14.979889
2757	Điểm hệ số 2 #2	459	2	\N	2025-05-11 12:12:14.979889
2758	Điểm hệ số 3	459	3	\N	2025-05-11 12:12:14.979889
2759	Điểm hệ số 1 #1	460	1	\N	2025-05-11 12:12:14.979889
2760	Điểm hệ số 1 #2	460	1	\N	2025-05-11 12:12:14.979889
2761	Điểm hệ số 1 #3	460	1	\N	2025-05-11 12:12:14.979889
2762	Điểm hệ số 2 #1	460	2	\N	2025-05-11 12:12:14.979889
2763	Điểm hệ số 2 #2	460	2	\N	2025-05-11 12:12:14.979889
2764	Điểm hệ số 3	460	3	\N	2025-05-11 12:12:14.979889
2765	Điểm hệ số 1 #1	461	1	\N	2025-05-11 12:12:14.979889
2766	Điểm hệ số 1 #2	461	1	\N	2025-05-11 12:12:14.979889
2767	Điểm hệ số 1 #3	461	1	\N	2025-05-11 12:12:14.979889
2768	Điểm hệ số 2 #1	461	2	\N	2025-05-11 12:12:14.979889
2769	Điểm hệ số 2 #2	461	2	\N	2025-05-11 12:12:14.979889
2770	Điểm hệ số 3	461	3	\N	2025-05-11 12:12:14.979889
2771	Điểm hệ số 1 #1	462	1	\N	2025-05-11 12:12:14.979889
2772	Điểm hệ số 1 #2	462	1	\N	2025-05-11 12:12:14.979889
2773	Điểm hệ số 1 #3	462	1	\N	2025-05-11 12:12:14.979889
2774	Điểm hệ số 2 #1	462	2	\N	2025-05-11 12:12:14.979889
2775	Điểm hệ số 2 #2	462	2	\N	2025-05-11 12:12:14.979889
2776	Điểm hệ số 3	462	3	\N	2025-05-11 12:12:14.979889
2777	Điểm hệ số 1 #1	463	1	\N	2025-05-11 12:12:14.979889
2778	Điểm hệ số 1 #2	463	1	\N	2025-05-11 12:12:14.979889
2779	Điểm hệ số 1 #3	463	1	\N	2025-05-11 12:12:14.979889
2780	Điểm hệ số 2 #1	463	2	\N	2025-05-11 12:12:14.979889
2781	Điểm hệ số 2 #2	463	2	\N	2025-05-11 12:12:14.979889
2782	Điểm hệ số 3	463	3	\N	2025-05-11 12:12:14.979889
2783	Điểm hệ số 1 #1	464	1	\N	2025-05-11 12:12:14.979889
2784	Điểm hệ số 1 #2	464	1	\N	2025-05-11 12:12:14.979889
2785	Điểm hệ số 1 #3	464	1	\N	2025-05-11 12:12:14.979889
2786	Điểm hệ số 2 #1	464	2	\N	2025-05-11 12:12:14.979889
2787	Điểm hệ số 2 #2	464	2	\N	2025-05-11 12:12:14.979889
2788	Điểm hệ số 3	464	3	\N	2025-05-11 12:12:14.979889
2789	Điểm hệ số 1 #1	465	1	\N	2025-05-11 12:12:14.979889
2790	Điểm hệ số 1 #2	465	1	\N	2025-05-11 12:12:14.979889
2791	Điểm hệ số 1 #3	465	1	\N	2025-05-11 12:12:14.979889
2792	Điểm hệ số 2 #1	465	2	\N	2025-05-11 12:12:14.979889
2793	Điểm hệ số 2 #2	465	2	\N	2025-05-11 12:12:14.979889
2794	Điểm hệ số 3	465	3	\N	2025-05-11 12:12:14.979889
2795	Điểm hệ số 1 #1	466	1	\N	2025-05-11 12:12:14.979889
2796	Điểm hệ số 1 #2	466	1	\N	2025-05-11 12:12:14.979889
2797	Điểm hệ số 1 #3	466	1	\N	2025-05-11 12:12:14.979889
2798	Điểm hệ số 2 #1	466	2	\N	2025-05-11 12:12:14.979889
2799	Điểm hệ số 2 #2	466	2	\N	2025-05-11 12:12:14.979889
2800	Điểm hệ số 3	466	3	\N	2025-05-11 12:12:14.979889
2801	Điểm hệ số 1 #1	467	1	\N	2025-05-11 12:12:14.979889
2802	Điểm hệ số 1 #2	467	1	\N	2025-05-11 12:12:14.979889
2803	Điểm hệ số 1 #3	467	1	\N	2025-05-11 12:12:14.979889
2804	Điểm hệ số 2 #1	467	2	\N	2025-05-11 12:12:14.979889
2805	Điểm hệ số 2 #2	467	2	\N	2025-05-11 12:12:14.979889
2806	Điểm hệ số 3	467	3	\N	2025-05-11 12:12:14.979889
2807	Điểm hệ số 1 #1	468	1	\N	2025-05-11 12:12:14.979889
2808	Điểm hệ số 1 #2	468	1	\N	2025-05-11 12:12:14.979889
2809	Điểm hệ số 1 #3	468	1	\N	2025-05-11 12:12:14.979889
2810	Điểm hệ số 2 #1	468	2	\N	2025-05-11 12:12:14.979889
2811	Điểm hệ số 2 #2	468	2	\N	2025-05-11 12:12:14.979889
2812	Điểm hệ số 3	468	3	\N	2025-05-11 12:12:14.979889
2813	Điểm hệ số 1 #1	469	1	\N	2025-05-11 12:12:14.979889
2814	Điểm hệ số 1 #2	469	1	\N	2025-05-11 12:12:14.979889
2815	Điểm hệ số 1 #3	469	1	\N	2025-05-11 12:12:14.979889
2816	Điểm hệ số 2 #1	469	2	\N	2025-05-11 12:12:14.979889
2817	Điểm hệ số 2 #2	469	2	\N	2025-05-11 12:12:14.979889
2818	Điểm hệ số 3	469	3	\N	2025-05-11 12:12:14.979889
2819	Điểm hệ số 1 #1	470	1	\N	2025-05-11 12:12:14.979889
2820	Điểm hệ số 1 #2	470	1	\N	2025-05-11 12:12:14.979889
2821	Điểm hệ số 1 #3	470	1	\N	2025-05-11 12:12:14.979889
2822	Điểm hệ số 2 #1	470	2	\N	2025-05-11 12:12:14.979889
2823	Điểm hệ số 2 #2	470	2	\N	2025-05-11 12:12:14.979889
2824	Điểm hệ số 3	470	3	\N	2025-05-11 12:12:14.979889
2825	Điểm hệ số 1 #1	471	1	\N	2025-05-11 12:12:14.979889
2826	Điểm hệ số 1 #2	471	1	\N	2025-05-11 12:12:14.979889
2827	Điểm hệ số 1 #3	471	1	\N	2025-05-11 12:12:14.979889
2828	Điểm hệ số 2 #1	471	2	\N	2025-05-11 12:12:14.979889
2829	Điểm hệ số 2 #2	471	2	\N	2025-05-11 12:12:14.979889
2830	Điểm hệ số 3	471	3	\N	2025-05-11 12:12:14.979889
2831	Điểm hệ số 1 #1	472	1	\N	2025-05-11 12:12:14.979889
2832	Điểm hệ số 1 #2	472	1	\N	2025-05-11 12:12:14.979889
2833	Điểm hệ số 1 #3	472	1	\N	2025-05-11 12:12:14.979889
2834	Điểm hệ số 2 #1	472	2	\N	2025-05-11 12:12:14.979889
2835	Điểm hệ số 2 #2	472	2	\N	2025-05-11 12:12:14.979889
2836	Điểm hệ số 3	472	3	\N	2025-05-11 12:12:14.979889
2837	Điểm hệ số 1 #1	473	1	\N	2025-05-11 12:12:14.979889
2838	Điểm hệ số 1 #2	473	1	\N	2025-05-11 12:12:14.979889
2839	Điểm hệ số 1 #3	473	1	\N	2025-05-11 12:12:14.979889
2840	Điểm hệ số 2 #1	473	2	\N	2025-05-11 12:12:14.979889
2841	Điểm hệ số 2 #2	473	2	\N	2025-05-11 12:12:14.979889
2842	Điểm hệ số 3	473	3	\N	2025-05-11 12:12:14.979889
2843	Điểm hệ số 1 #1	474	1	\N	2025-05-11 12:12:14.979889
2844	Điểm hệ số 1 #2	474	1	\N	2025-05-11 12:12:14.979889
2845	Điểm hệ số 1 #3	474	1	\N	2025-05-11 12:12:14.979889
2846	Điểm hệ số 2 #1	474	2	\N	2025-05-11 12:12:14.979889
2847	Điểm hệ số 2 #2	474	2	\N	2025-05-11 12:12:14.979889
2848	Điểm hệ số 3	474	3	\N	2025-05-11 12:12:14.979889
2849	Điểm hệ số 1 #1	475	1	\N	2025-05-11 12:12:14.979889
2850	Điểm hệ số 1 #2	475	1	\N	2025-05-11 12:12:14.979889
2851	Điểm hệ số 1 #3	475	1	\N	2025-05-11 12:12:14.979889
2852	Điểm hệ số 2 #1	475	2	\N	2025-05-11 12:12:14.979889
2853	Điểm hệ số 2 #2	475	2	\N	2025-05-11 12:12:14.979889
2854	Điểm hệ số 3	475	3	\N	2025-05-11 12:12:14.979889
2855	Điểm hệ số 1 #1	476	1	\N	2025-05-11 12:12:14.979889
2856	Điểm hệ số 1 #2	476	1	\N	2025-05-11 12:12:14.979889
2857	Điểm hệ số 1 #3	476	1	\N	2025-05-11 12:12:14.979889
2858	Điểm hệ số 2 #1	476	2	\N	2025-05-11 12:12:14.979889
2859	Điểm hệ số 2 #2	476	2	\N	2025-05-11 12:12:14.979889
2860	Điểm hệ số 3	476	3	\N	2025-05-11 12:12:14.979889
2861	Điểm hệ số 1 #1	477	1	\N	2025-05-11 12:12:14.979889
2862	Điểm hệ số 1 #2	477	1	\N	2025-05-11 12:12:14.979889
2863	Điểm hệ số 1 #3	477	1	\N	2025-05-11 12:12:14.979889
2864	Điểm hệ số 2 #1	477	2	\N	2025-05-11 12:12:14.979889
2865	Điểm hệ số 2 #2	477	2	\N	2025-05-11 12:12:14.979889
2866	Điểm hệ số 3	477	3	\N	2025-05-11 12:12:14.979889
2867	Điểm hệ số 1 #1	478	1	\N	2025-05-11 12:12:14.979889
2868	Điểm hệ số 1 #2	478	1	\N	2025-05-11 12:12:14.979889
2869	Điểm hệ số 1 #3	478	1	\N	2025-05-11 12:12:14.979889
2870	Điểm hệ số 2 #1	478	2	\N	2025-05-11 12:12:14.979889
2871	Điểm hệ số 2 #2	478	2	\N	2025-05-11 12:12:14.979889
2872	Điểm hệ số 3	478	3	\N	2025-05-11 12:12:14.979889
2873	Điểm hệ số 1 #1	479	1	\N	2025-05-11 12:12:14.979889
2874	Điểm hệ số 1 #2	479	1	\N	2025-05-11 12:12:14.979889
2875	Điểm hệ số 1 #3	479	1	\N	2025-05-11 12:12:14.979889
2876	Điểm hệ số 2 #1	479	2	\N	2025-05-11 12:12:14.979889
2877	Điểm hệ số 2 #2	479	2	\N	2025-05-11 12:12:14.979889
2878	Điểm hệ số 3	479	3	\N	2025-05-11 12:12:14.979889
2879	Điểm hệ số 1 #1	480	1	\N	2025-05-11 12:12:14.979889
2880	Điểm hệ số 1 #2	480	1	\N	2025-05-11 12:12:14.979889
2881	Điểm hệ số 1 #3	480	1	\N	2025-05-11 12:12:14.979889
2882	Điểm hệ số 2 #1	480	2	\N	2025-05-11 12:12:14.979889
2883	Điểm hệ số 2 #2	480	2	\N	2025-05-11 12:12:14.979889
2884	Điểm hệ số 3	480	3	\N	2025-05-11 12:12:14.979889
2885	Điểm hệ số 1 #1	481	1	\N	2025-05-11 12:12:14.979889
2886	Điểm hệ số 1 #2	481	1	\N	2025-05-11 12:12:14.979889
2887	Điểm hệ số 1 #3	481	1	\N	2025-05-11 12:12:14.979889
2888	Điểm hệ số 2 #1	481	2	\N	2025-05-11 12:12:14.979889
2889	Điểm hệ số 2 #2	481	2	\N	2025-05-11 12:12:14.979889
2890	Điểm hệ số 3	481	3	\N	2025-05-11 12:12:14.979889
2891	Điểm hệ số 1 #1	482	1	\N	2025-05-11 12:12:14.979889
2892	Điểm hệ số 1 #2	482	1	\N	2025-05-11 12:12:14.979889
2893	Điểm hệ số 1 #3	482	1	\N	2025-05-11 12:12:14.979889
2894	Điểm hệ số 2 #1	482	2	\N	2025-05-11 12:12:14.979889
2895	Điểm hệ số 2 #2	482	2	\N	2025-05-11 12:12:14.979889
2896	Điểm hệ số 3	482	3	\N	2025-05-11 12:12:14.979889
2897	Điểm hệ số 1 #1	483	1	\N	2025-05-11 12:12:14.979889
2898	Điểm hệ số 1 #2	483	1	\N	2025-05-11 12:12:14.979889
2899	Điểm hệ số 1 #3	483	1	\N	2025-05-11 12:12:14.979889
2900	Điểm hệ số 2 #1	483	2	\N	2025-05-11 12:12:14.979889
2901	Điểm hệ số 2 #2	483	2	\N	2025-05-11 12:12:14.979889
2902	Điểm hệ số 3	483	3	\N	2025-05-11 12:12:14.979889
2903	Điểm hệ số 1 #1	484	1	\N	2025-05-11 12:12:14.979889
2904	Điểm hệ số 1 #2	484	1	\N	2025-05-11 12:12:14.979889
2905	Điểm hệ số 1 #3	484	1	\N	2025-05-11 12:12:14.979889
2906	Điểm hệ số 2 #1	484	2	\N	2025-05-11 12:12:14.979889
2907	Điểm hệ số 2 #2	484	2	\N	2025-05-11 12:12:14.979889
2908	Điểm hệ số 3	484	3	\N	2025-05-11 12:12:14.979889
2909	Điểm hệ số 1 #1	485	1	\N	2025-05-11 12:12:14.979889
2910	Điểm hệ số 1 #2	485	1	\N	2025-05-11 12:12:14.979889
2911	Điểm hệ số 1 #3	485	1	\N	2025-05-11 12:12:14.979889
2912	Điểm hệ số 2 #1	485	2	\N	2025-05-11 12:12:14.979889
2913	Điểm hệ số 2 #2	485	2	\N	2025-05-11 12:12:14.979889
2914	Điểm hệ số 3	485	3	\N	2025-05-11 12:12:14.979889
2915	Điểm hệ số 1 #1	486	1	\N	2025-05-11 12:12:14.979889
2916	Điểm hệ số 1 #2	486	1	\N	2025-05-11 12:12:14.979889
2917	Điểm hệ số 1 #3	486	1	\N	2025-05-11 12:12:14.979889
2918	Điểm hệ số 2 #1	486	2	\N	2025-05-11 12:12:14.979889
2919	Điểm hệ số 2 #2	486	2	\N	2025-05-11 12:12:14.979889
2920	Điểm hệ số 3	486	3	\N	2025-05-11 12:12:14.979889
2921	Điểm hệ số 1 #1	487	1	\N	2025-05-11 12:12:14.979889
2922	Điểm hệ số 1 #2	487	1	\N	2025-05-11 12:12:14.979889
2923	Điểm hệ số 1 #3	487	1	\N	2025-05-11 12:12:14.979889
2924	Điểm hệ số 2 #1	487	2	\N	2025-05-11 12:12:14.979889
2925	Điểm hệ số 2 #2	487	2	\N	2025-05-11 12:12:14.979889
2926	Điểm hệ số 3	487	3	\N	2025-05-11 12:12:14.979889
2927	Điểm hệ số 1 #1	488	1	\N	2025-05-11 12:12:14.979889
2928	Điểm hệ số 1 #2	488	1	\N	2025-05-11 12:12:14.979889
2929	Điểm hệ số 1 #3	488	1	\N	2025-05-11 12:12:14.979889
2930	Điểm hệ số 2 #1	488	2	\N	2025-05-11 12:12:14.979889
2931	Điểm hệ số 2 #2	488	2	\N	2025-05-11 12:12:14.979889
2932	Điểm hệ số 3	488	3	\N	2025-05-11 12:12:14.979889
2933	Điểm hệ số 1 #1	489	1	\N	2025-05-11 12:12:14.979889
2934	Điểm hệ số 1 #2	489	1	\N	2025-05-11 12:12:14.979889
2935	Điểm hệ số 1 #3	489	1	\N	2025-05-11 12:12:14.979889
2936	Điểm hệ số 2 #1	489	2	\N	2025-05-11 12:12:14.979889
2937	Điểm hệ số 2 #2	489	2	\N	2025-05-11 12:12:14.979889
2938	Điểm hệ số 3	489	3	\N	2025-05-11 12:12:14.979889
2939	Điểm hệ số 1 #1	490	1	\N	2025-05-11 12:12:14.979889
2940	Điểm hệ số 1 #2	490	1	\N	2025-05-11 12:12:14.979889
2941	Điểm hệ số 1 #3	490	1	\N	2025-05-11 12:12:14.979889
2942	Điểm hệ số 2 #1	490	2	\N	2025-05-11 12:12:14.979889
2943	Điểm hệ số 2 #2	490	2	\N	2025-05-11 12:12:14.979889
2944	Điểm hệ số 3	490	3	\N	2025-05-11 12:12:14.979889
2945	Điểm hệ số 1 #1	491	1	\N	2025-05-11 12:12:14.979889
2946	Điểm hệ số 1 #2	491	1	\N	2025-05-11 12:12:14.979889
2947	Điểm hệ số 1 #3	491	1	\N	2025-05-11 12:12:14.979889
2948	Điểm hệ số 2 #1	491	2	\N	2025-05-11 12:12:14.979889
2949	Điểm hệ số 2 #2	491	2	\N	2025-05-11 12:12:14.979889
2950	Điểm hệ số 3	491	3	\N	2025-05-11 12:12:14.979889
2951	Điểm hệ số 1 #1	492	1	\N	2025-05-11 12:12:14.979889
2952	Điểm hệ số 1 #2	492	1	\N	2025-05-11 12:12:14.979889
2953	Điểm hệ số 1 #3	492	1	\N	2025-05-11 12:12:14.979889
2954	Điểm hệ số 2 #1	492	2	\N	2025-05-11 12:12:14.979889
2955	Điểm hệ số 2 #2	492	2	\N	2025-05-11 12:12:14.979889
2956	Điểm hệ số 3	492	3	\N	2025-05-11 12:12:14.979889
2957	Điểm hệ số 1 #1	493	1	\N	2025-05-11 12:12:14.979889
2958	Điểm hệ số 1 #2	493	1	\N	2025-05-11 12:12:14.979889
2959	Điểm hệ số 1 #3	493	1	\N	2025-05-11 12:12:14.979889
2960	Điểm hệ số 2 #1	493	2	\N	2025-05-11 12:12:14.979889
2961	Điểm hệ số 2 #2	493	2	\N	2025-05-11 12:12:14.979889
2962	Điểm hệ số 3	493	3	\N	2025-05-11 12:12:14.979889
2963	Điểm hệ số 1 #1	494	1	\N	2025-05-11 12:12:14.979889
2964	Điểm hệ số 1 #2	494	1	\N	2025-05-11 12:12:14.979889
2965	Điểm hệ số 1 #3	494	1	\N	2025-05-11 12:12:14.979889
2966	Điểm hệ số 2 #1	494	2	\N	2025-05-11 12:12:14.979889
2967	Điểm hệ số 2 #2	494	2	\N	2025-05-11 12:12:14.979889
2968	Điểm hệ số 3	494	3	\N	2025-05-11 12:12:14.979889
2969	Điểm hệ số 1 #1	495	1	\N	2025-05-11 12:12:14.979889
2970	Điểm hệ số 1 #2	495	1	\N	2025-05-11 12:12:14.979889
2971	Điểm hệ số 1 #3	495	1	\N	2025-05-11 12:12:14.979889
2972	Điểm hệ số 2 #1	495	2	\N	2025-05-11 12:12:14.979889
2973	Điểm hệ số 2 #2	495	2	\N	2025-05-11 12:12:14.979889
2974	Điểm hệ số 3	495	3	\N	2025-05-11 12:12:14.980883
2975	Điểm hệ số 1 #1	496	1	\N	2025-05-11 12:12:14.980883
2976	Điểm hệ số 1 #2	496	1	\N	2025-05-11 12:12:14.980883
2977	Điểm hệ số 1 #3	496	1	\N	2025-05-11 12:12:14.980883
2978	Điểm hệ số 2 #1	496	2	\N	2025-05-11 12:12:14.980883
2979	Điểm hệ số 2 #2	496	2	\N	2025-05-11 12:12:14.980883
2980	Điểm hệ số 3	496	3	\N	2025-05-11 12:12:14.980883
2981	Điểm hệ số 1 #1	497	1	\N	2025-05-11 12:12:14.980883
2982	Điểm hệ số 1 #2	497	1	\N	2025-05-11 12:12:14.980883
2983	Điểm hệ số 1 #3	497	1	\N	2025-05-11 12:12:14.980883
2984	Điểm hệ số 2 #1	497	2	\N	2025-05-11 12:12:14.980883
2985	Điểm hệ số 2 #2	497	2	\N	2025-05-11 12:12:14.980883
2986	Điểm hệ số 3	497	3	\N	2025-05-11 12:12:14.980883
2987	Điểm hệ số 1 #1	498	1	\N	2025-05-11 12:12:14.980883
2988	Điểm hệ số 1 #2	498	1	\N	2025-05-11 12:12:14.980883
2989	Điểm hệ số 1 #3	498	1	\N	2025-05-11 12:12:14.980883
2990	Điểm hệ số 2 #1	498	2	\N	2025-05-11 12:12:14.980883
2991	Điểm hệ số 2 #2	498	2	\N	2025-05-11 12:12:14.980883
2992	Điểm hệ số 3	498	3	\N	2025-05-11 12:12:14.980883
2993	Điểm hệ số 1 #1	499	1	\N	2025-05-11 12:12:14.980883
2994	Điểm hệ số 1 #2	499	1	\N	2025-05-11 12:12:14.980883
2995	Điểm hệ số 1 #3	499	1	\N	2025-05-11 12:12:14.980883
2996	Điểm hệ số 2 #1	499	2	\N	2025-05-11 12:12:14.980883
2997	Điểm hệ số 2 #2	499	2	\N	2025-05-11 12:12:14.980883
2998	Điểm hệ số 3	499	3	\N	2025-05-11 12:12:14.980883
2999	Điểm hệ số 1 #1	500	1	\N	2025-05-11 12:12:14.980883
3000	Điểm hệ số 1 #2	500	1	\N	2025-05-11 12:12:14.980883
3001	Điểm hệ số 1 #3	500	1	\N	2025-05-11 12:12:14.980883
3002	Điểm hệ số 2 #1	500	2	\N	2025-05-11 12:12:14.980883
3003	Điểm hệ số 2 #2	500	2	\N	2025-05-11 12:12:14.980883
3004	Điểm hệ số 3	500	3	\N	2025-05-11 12:12:14.980883
3005	Điểm hệ số 1 #1	501	1	\N	2025-05-11 12:12:14.980883
3006	Điểm hệ số 1 #2	501	1	\N	2025-05-11 12:12:14.980883
3007	Điểm hệ số 1 #3	501	1	\N	2025-05-11 12:12:14.980883
3008	Điểm hệ số 2 #1	501	2	\N	2025-05-11 12:12:14.980883
3009	Điểm hệ số 2 #2	501	2	\N	2025-05-11 12:12:14.980883
3010	Điểm hệ số 3	501	3	\N	2025-05-11 12:12:14.980883
3011	Điểm hệ số 1 #1	502	1	\N	2025-05-11 12:12:14.980883
3012	Điểm hệ số 1 #2	502	1	\N	2025-05-11 12:12:14.980883
3013	Điểm hệ số 1 #3	502	1	\N	2025-05-11 12:12:14.980883
3014	Điểm hệ số 2 #1	502	2	\N	2025-05-11 12:12:14.980883
3015	Điểm hệ số 2 #2	502	2	\N	2025-05-11 12:12:14.980883
3016	Điểm hệ số 3	502	3	\N	2025-05-11 12:12:14.980883
3017	Điểm hệ số 1 #1	503	1	\N	2025-05-11 12:12:14.980883
3018	Điểm hệ số 1 #2	503	1	\N	2025-05-11 12:12:14.980883
3019	Điểm hệ số 1 #3	503	1	\N	2025-05-11 12:12:14.980883
3020	Điểm hệ số 2 #1	503	2	\N	2025-05-11 12:12:14.980883
3021	Điểm hệ số 2 #2	503	2	\N	2025-05-11 12:12:14.980883
3022	Điểm hệ số 3	503	3	\N	2025-05-11 12:12:14.980883
3023	Điểm hệ số 1 #1	504	1	\N	2025-05-11 12:12:14.980883
3024	Điểm hệ số 1 #2	504	1	\N	2025-05-11 12:12:14.980883
3025	Điểm hệ số 1 #3	504	1	\N	2025-05-11 12:12:14.980883
3026	Điểm hệ số 2 #1	504	2	\N	2025-05-11 12:12:14.980883
3027	Điểm hệ số 2 #2	504	2	\N	2025-05-11 12:12:14.980883
3028	Điểm hệ số 3	504	3	\N	2025-05-11 12:12:14.980883
3029	Điểm hệ số 1 #1	505	1	\N	2025-05-11 12:12:14.980883
3030	Điểm hệ số 1 #2	505	1	\N	2025-05-11 12:12:14.980883
3031	Điểm hệ số 1 #3	505	1	\N	2025-05-11 12:12:14.980883
3032	Điểm hệ số 2 #1	505	2	\N	2025-05-11 12:12:14.980883
3033	Điểm hệ số 2 #2	505	2	\N	2025-05-11 12:12:14.980883
3034	Điểm hệ số 3	505	3	\N	2025-05-11 12:12:14.980883
3035	Điểm hệ số 1 #1	506	1	\N	2025-05-11 12:12:14.980883
3036	Điểm hệ số 1 #2	506	1	\N	2025-05-11 12:12:14.980883
3037	Điểm hệ số 1 #3	506	1	\N	2025-05-11 12:12:14.980883
3038	Điểm hệ số 2 #1	506	2	\N	2025-05-11 12:12:14.980883
3039	Điểm hệ số 2 #2	506	2	\N	2025-05-11 12:12:14.980883
3040	Điểm hệ số 3	506	3	\N	2025-05-11 12:12:14.980883
3041	Điểm hệ số 1 #1	507	1	\N	2025-05-11 12:12:14.980883
3042	Điểm hệ số 1 #2	507	1	\N	2025-05-11 12:12:14.980883
3043	Điểm hệ số 1 #3	507	1	\N	2025-05-11 12:12:14.980883
3044	Điểm hệ số 2 #1	507	2	\N	2025-05-11 12:12:14.980883
3045	Điểm hệ số 2 #2	507	2	\N	2025-05-11 12:12:14.980883
3046	Điểm hệ số 3	507	3	\N	2025-05-11 12:12:14.980883
3047	Điểm hệ số 1 #1	508	1	\N	2025-05-11 12:12:14.980883
3048	Điểm hệ số 1 #2	508	1	\N	2025-05-11 12:12:14.980883
3049	Điểm hệ số 1 #3	508	1	\N	2025-05-11 12:12:14.980883
3050	Điểm hệ số 2 #1	508	2	\N	2025-05-11 12:12:14.980883
3051	Điểm hệ số 2 #2	508	2	\N	2025-05-11 12:12:14.980883
3052	Điểm hệ số 3	508	3	\N	2025-05-11 12:12:14.980883
3053	Điểm hệ số 1 #1	509	1	\N	2025-05-11 12:12:14.980883
3054	Điểm hệ số 1 #2	509	1	\N	2025-05-11 12:12:14.980883
3055	Điểm hệ số 1 #3	509	1	\N	2025-05-11 12:12:14.980883
3056	Điểm hệ số 2 #1	509	2	\N	2025-05-11 12:12:14.980883
3057	Điểm hệ số 2 #2	509	2	\N	2025-05-11 12:12:14.980883
3058	Điểm hệ số 3	509	3	\N	2025-05-11 12:12:14.980883
3059	Điểm hệ số 1 #1	510	1	\N	2025-05-11 12:12:14.980883
3060	Điểm hệ số 1 #2	510	1	\N	2025-05-11 12:12:14.980883
3061	Điểm hệ số 1 #3	510	1	\N	2025-05-11 12:12:14.980883
3062	Điểm hệ số 2 #1	510	2	\N	2025-05-11 12:12:14.980883
3063	Điểm hệ số 2 #2	510	2	\N	2025-05-11 12:12:14.980883
3064	Điểm hệ số 3	510	3	\N	2025-05-11 12:12:14.980883
3065	Điểm hệ số 1 #1	511	1	\N	2025-05-11 12:12:14.980883
3066	Điểm hệ số 1 #2	511	1	\N	2025-05-11 12:12:14.980883
3067	Điểm hệ số 1 #3	511	1	\N	2025-05-11 12:12:14.980883
3068	Điểm hệ số 2 #1	511	2	\N	2025-05-11 12:12:14.980883
3069	Điểm hệ số 2 #2	511	2	\N	2025-05-11 12:12:14.980883
3070	Điểm hệ số 3	511	3	\N	2025-05-11 12:12:14.980883
3071	Điểm hệ số 1 #1	512	1	\N	2025-05-11 12:12:14.980883
3072	Điểm hệ số 1 #2	512	1	\N	2025-05-11 12:12:14.980883
3073	Điểm hệ số 1 #3	512	1	\N	2025-05-11 12:12:14.980883
3074	Điểm hệ số 2 #1	512	2	\N	2025-05-11 12:12:14.980883
3075	Điểm hệ số 2 #2	512	2	\N	2025-05-11 12:12:14.980883
3076	Điểm hệ số 3	512	3	\N	2025-05-11 12:12:14.980883
3077	Điểm hệ số 1 #1	513	1	\N	2025-05-11 12:12:14.980883
3078	Điểm hệ số 1 #2	513	1	\N	2025-05-11 12:12:14.980883
3079	Điểm hệ số 1 #3	513	1	\N	2025-05-11 12:12:14.980883
3080	Điểm hệ số 2 #1	513	2	\N	2025-05-11 12:12:14.980883
3081	Điểm hệ số 2 #2	513	2	\N	2025-05-11 12:12:14.980883
3082	Điểm hệ số 3	513	3	\N	2025-05-11 12:12:14.980883
3083	Điểm hệ số 1 #1	514	1	\N	2025-05-11 12:12:14.980883
3084	Điểm hệ số 1 #2	514	1	\N	2025-05-11 12:12:14.980883
3085	Điểm hệ số 1 #3	514	1	\N	2025-05-11 12:12:14.980883
3086	Điểm hệ số 2 #1	514	2	\N	2025-05-11 12:12:14.980883
3087	Điểm hệ số 2 #2	514	2	\N	2025-05-11 12:12:14.980883
3088	Điểm hệ số 3	514	3	\N	2025-05-11 12:12:14.980883
3089	Điểm hệ số 1 #1	515	1	\N	2025-05-11 12:12:14.980883
3090	Điểm hệ số 1 #2	515	1	\N	2025-05-11 12:12:14.980883
3091	Điểm hệ số 1 #3	515	1	\N	2025-05-11 12:12:14.980883
3092	Điểm hệ số 2 #1	515	2	\N	2025-05-11 12:12:14.980883
3093	Điểm hệ số 2 #2	515	2	\N	2025-05-11 12:12:14.980883
3094	Điểm hệ số 3	515	3	\N	2025-05-11 12:12:14.980883
3095	Điểm hệ số 1 #1	516	1	\N	2025-05-11 12:12:14.980883
3096	Điểm hệ số 1 #2	516	1	\N	2025-05-11 12:12:14.980883
3097	Điểm hệ số 1 #3	516	1	\N	2025-05-11 12:12:14.980883
3098	Điểm hệ số 2 #1	516	2	\N	2025-05-11 12:12:14.980883
3099	Điểm hệ số 2 #2	516	2	\N	2025-05-11 12:12:14.980883
3100	Điểm hệ số 3	516	3	\N	2025-05-11 12:12:14.980883
3101	Điểm hệ số 1 #1	517	1	\N	2025-05-11 12:12:14.980883
3102	Điểm hệ số 1 #2	517	1	\N	2025-05-11 12:12:14.980883
3103	Điểm hệ số 1 #3	517	1	\N	2025-05-11 12:12:14.980883
3104	Điểm hệ số 2 #1	517	2	\N	2025-05-11 12:12:14.980883
3105	Điểm hệ số 2 #2	517	2	\N	2025-05-11 12:12:14.980883
3106	Điểm hệ số 3	517	3	\N	2025-05-11 12:12:14.980883
3107	Điểm hệ số 1 #1	518	1	\N	2025-05-11 12:12:14.980883
3108	Điểm hệ số 1 #2	518	1	\N	2025-05-11 12:12:14.980883
3109	Điểm hệ số 1 #3	518	1	\N	2025-05-11 12:12:14.980883
3110	Điểm hệ số 2 #1	518	2	\N	2025-05-11 12:12:14.980883
3111	Điểm hệ số 2 #2	518	2	\N	2025-05-11 12:12:14.980883
3112	Điểm hệ số 3	518	3	\N	2025-05-11 12:12:14.980883
3113	Điểm hệ số 1 #1	519	1	\N	2025-05-11 12:12:14.980883
3114	Điểm hệ số 1 #2	519	1	\N	2025-05-11 12:12:14.980883
3115	Điểm hệ số 1 #3	519	1	\N	2025-05-11 12:12:14.980883
3116	Điểm hệ số 2 #1	519	2	\N	2025-05-11 12:12:14.980883
3117	Điểm hệ số 2 #2	519	2	\N	2025-05-11 12:12:14.980883
3118	Điểm hệ số 3	519	3	\N	2025-05-11 12:12:14.980883
3119	Điểm hệ số 1 #1	520	1	\N	2025-05-11 12:12:14.980883
3120	Điểm hệ số 1 #2	520	1	\N	2025-05-11 12:12:14.980883
3121	Điểm hệ số 1 #3	520	1	\N	2025-05-11 12:12:14.980883
3122	Điểm hệ số 2 #1	520	2	\N	2025-05-11 12:12:14.980883
3123	Điểm hệ số 2 #2	520	2	\N	2025-05-11 12:12:14.980883
3124	Điểm hệ số 3	520	3	\N	2025-05-11 12:12:14.980883
3125	Điểm hệ số 1 #1	521	1	\N	2025-05-11 12:12:14.980883
3126	Điểm hệ số 1 #2	521	1	\N	2025-05-11 12:12:14.980883
3127	Điểm hệ số 1 #3	521	1	\N	2025-05-11 12:12:14.980883
3128	Điểm hệ số 2 #1	521	2	\N	2025-05-11 12:12:14.980883
3129	Điểm hệ số 2 #2	521	2	\N	2025-05-11 12:12:14.980883
3130	Điểm hệ số 3	521	3	\N	2025-05-11 12:12:14.980883
3131	Điểm hệ số 1 #1	522	1	\N	2025-05-11 12:12:14.980883
3132	Điểm hệ số 1 #2	522	1	\N	2025-05-11 12:12:14.980883
3133	Điểm hệ số 1 #3	522	1	\N	2025-05-11 12:12:14.980883
3134	Điểm hệ số 2 #1	522	2	\N	2025-05-11 12:12:14.980883
3135	Điểm hệ số 2 #2	522	2	\N	2025-05-11 12:12:14.980883
3136	Điểm hệ số 3	522	3	\N	2025-05-11 12:12:14.980883
3137	Điểm hệ số 1 #1	523	1	\N	2025-05-11 12:12:14.980883
3138	Điểm hệ số 1 #2	523	1	\N	2025-05-11 12:12:14.980883
3139	Điểm hệ số 1 #3	523	1	\N	2025-05-11 12:12:14.980883
3140	Điểm hệ số 2 #1	523	2	\N	2025-05-11 12:12:14.980883
3141	Điểm hệ số 2 #2	523	2	\N	2025-05-11 12:12:14.980883
3142	Điểm hệ số 3	523	3	\N	2025-05-11 12:12:14.980883
3143	Điểm hệ số 1 #1	524	1	\N	2025-05-11 12:12:16.045204
3144	Điểm hệ số 1 #2	524	1	\N	2025-05-11 12:12:16.045204
3145	Điểm hệ số 1 #3	524	1	\N	2025-05-11 12:12:16.045204
3146	Điểm hệ số 2 #1	524	2	\N	2025-05-11 12:12:16.045204
3147	Điểm hệ số 2 #2	524	2	\N	2025-05-11 12:12:16.045204
3148	Điểm hệ số 3	524	3	\N	2025-05-11 12:12:16.045204
3149	Điểm hệ số 1 #1	525	1	\N	2025-05-11 12:12:16.045204
3150	Điểm hệ số 1 #2	525	1	\N	2025-05-11 12:12:16.045204
3151	Điểm hệ số 1 #3	525	1	\N	2025-05-11 12:12:16.045204
3152	Điểm hệ số 2 #1	525	2	\N	2025-05-11 12:12:16.045204
3153	Điểm hệ số 2 #2	525	2	\N	2025-05-11 12:12:16.045204
3154	Điểm hệ số 3	525	3	\N	2025-05-11 12:12:16.045204
3155	Điểm hệ số 1 #1	526	1	\N	2025-05-11 12:12:16.045204
3156	Điểm hệ số 1 #2	526	1	\N	2025-05-11 12:12:16.045204
3157	Điểm hệ số 1 #3	526	1	\N	2025-05-11 12:12:16.045204
3158	Điểm hệ số 2 #1	526	2	\N	2025-05-11 12:12:16.045204
3159	Điểm hệ số 2 #2	526	2	\N	2025-05-11 12:12:16.045204
3160	Điểm hệ số 3	526	3	\N	2025-05-11 12:12:16.045204
3161	Điểm hệ số 1 #1	527	1	\N	2025-05-11 12:12:16.045204
3162	Điểm hệ số 1 #2	527	1	\N	2025-05-11 12:12:16.045204
3163	Điểm hệ số 1 #3	527	1	\N	2025-05-11 12:12:16.045204
3164	Điểm hệ số 2 #1	527	2	\N	2025-05-11 12:12:16.045204
3165	Điểm hệ số 2 #2	527	2	\N	2025-05-11 12:12:16.045204
3166	Điểm hệ số 3	527	3	\N	2025-05-11 12:12:16.045204
3167	Điểm hệ số 1 #1	528	1	\N	2025-05-11 12:12:16.045204
3168	Điểm hệ số 1 #2	528	1	\N	2025-05-11 12:12:16.045204
3169	Điểm hệ số 1 #3	528	1	\N	2025-05-11 12:12:16.045204
3170	Điểm hệ số 2 #1	528	2	\N	2025-05-11 12:12:16.045204
3171	Điểm hệ số 2 #2	528	2	\N	2025-05-11 12:12:16.045204
3172	Điểm hệ số 3	528	3	\N	2025-05-11 12:12:16.045204
3173	Điểm hệ số 1 #1	529	1	\N	2025-05-11 12:12:16.045204
3174	Điểm hệ số 1 #2	529	1	\N	2025-05-11 12:12:16.045204
3175	Điểm hệ số 1 #3	529	1	\N	2025-05-11 12:12:16.045204
3176	Điểm hệ số 2 #1	529	2	\N	2025-05-11 12:12:16.045204
3177	Điểm hệ số 2 #2	529	2	\N	2025-05-11 12:12:16.045204
3178	Điểm hệ số 3	529	3	\N	2025-05-11 12:12:16.045204
3179	Điểm hệ số 1 #1	530	1	\N	2025-05-11 12:12:16.045204
3180	Điểm hệ số 1 #2	530	1	\N	2025-05-11 12:12:16.046212
3181	Điểm hệ số 1 #3	530	1	\N	2025-05-11 12:12:16.046212
3182	Điểm hệ số 2 #1	530	2	\N	2025-05-11 12:12:16.046212
3183	Điểm hệ số 2 #2	530	2	\N	2025-05-11 12:12:16.046212
3184	Điểm hệ số 3	530	3	\N	2025-05-11 12:12:16.046212
3185	Điểm hệ số 1 #1	531	1	\N	2025-05-11 12:12:16.046212
3186	Điểm hệ số 1 #2	531	1	\N	2025-05-11 12:12:16.046212
3187	Điểm hệ số 1 #3	531	1	\N	2025-05-11 12:12:16.046212
3188	Điểm hệ số 2 #1	531	2	\N	2025-05-11 12:12:16.046212
3189	Điểm hệ số 2 #2	531	2	\N	2025-05-11 12:12:16.046212
3190	Điểm hệ số 3	531	3	\N	2025-05-11 12:12:16.046212
3191	Điểm hệ số 1 #1	532	1	\N	2025-05-11 12:12:16.046212
3192	Điểm hệ số 1 #2	532	1	\N	2025-05-11 12:12:16.046212
3193	Điểm hệ số 1 #3	532	1	\N	2025-05-11 12:12:16.046212
3194	Điểm hệ số 2 #1	532	2	\N	2025-05-11 12:12:16.046212
3195	Điểm hệ số 2 #2	532	2	\N	2025-05-11 12:12:16.046212
3196	Điểm hệ số 3	532	3	\N	2025-05-11 12:12:16.046212
3197	Điểm hệ số 1 #1	533	1	\N	2025-05-11 12:12:16.046212
3198	Điểm hệ số 1 #2	533	1	\N	2025-05-11 12:12:16.046212
3199	Điểm hệ số 1 #3	533	1	\N	2025-05-11 12:12:16.046212
3200	Điểm hệ số 2 #1	533	2	\N	2025-05-11 12:12:16.046212
3201	Điểm hệ số 2 #2	533	2	\N	2025-05-11 12:12:16.046212
3202	Điểm hệ số 3	533	3	\N	2025-05-11 12:12:16.046212
3203	Điểm hệ số 1 #1	534	1	\N	2025-05-11 12:12:16.046212
3204	Điểm hệ số 1 #2	534	1	\N	2025-05-11 12:12:16.046212
3205	Điểm hệ số 1 #3	534	1	\N	2025-05-11 12:12:16.046212
3206	Điểm hệ số 2 #1	534	2	\N	2025-05-11 12:12:16.046212
3207	Điểm hệ số 2 #2	534	2	\N	2025-05-11 12:12:16.046212
3208	Điểm hệ số 3	534	3	\N	2025-05-11 12:12:16.046212
3209	Điểm hệ số 1 #1	535	1	\N	2025-05-11 12:12:16.046212
3210	Điểm hệ số 1 #2	535	1	\N	2025-05-11 12:12:16.046212
3211	Điểm hệ số 1 #3	535	1	\N	2025-05-11 12:12:16.046212
3212	Điểm hệ số 2 #1	535	2	\N	2025-05-11 12:12:16.046212
3213	Điểm hệ số 2 #2	535	2	\N	2025-05-11 12:12:16.046212
3214	Điểm hệ số 3	535	3	\N	2025-05-11 12:12:16.046212
3215	Điểm hệ số 1 #1	536	1	\N	2025-05-11 12:12:16.046212
3216	Điểm hệ số 1 #2	536	1	\N	2025-05-11 12:12:16.046212
3217	Điểm hệ số 1 #3	536	1	\N	2025-05-11 12:12:16.046212
3218	Điểm hệ số 2 #1	536	2	\N	2025-05-11 12:12:16.046212
3219	Điểm hệ số 2 #2	536	2	\N	2025-05-11 12:12:16.046212
3220	Điểm hệ số 3	536	3	\N	2025-05-11 12:12:16.046212
3221	Điểm hệ số 1 #1	537	1	\N	2025-05-11 12:12:16.046212
3222	Điểm hệ số 1 #2	537	1	\N	2025-05-11 12:12:16.046212
3223	Điểm hệ số 1 #3	537	1	\N	2025-05-11 12:12:16.046212
3224	Điểm hệ số 2 #1	537	2	\N	2025-05-11 12:12:16.046212
3225	Điểm hệ số 2 #2	537	2	\N	2025-05-11 12:12:16.046212
3226	Điểm hệ số 3	537	3	\N	2025-05-11 12:12:16.046212
3227	Điểm hệ số 1 #1	538	1	\N	2025-05-11 12:12:16.046212
3228	Điểm hệ số 1 #2	538	1	\N	2025-05-11 12:12:16.046212
3229	Điểm hệ số 1 #3	538	1	\N	2025-05-11 12:12:16.046212
3230	Điểm hệ số 2 #1	538	2	\N	2025-05-11 12:12:16.046212
3231	Điểm hệ số 2 #2	538	2	\N	2025-05-11 12:12:16.046212
3232	Điểm hệ số 3	538	3	\N	2025-05-11 12:12:16.046212
3233	Điểm hệ số 1 #1	539	1	\N	2025-05-11 12:12:16.046212
3234	Điểm hệ số 1 #2	539	1	\N	2025-05-11 12:12:16.046212
3235	Điểm hệ số 1 #3	539	1	\N	2025-05-11 12:12:16.046212
3236	Điểm hệ số 2 #1	539	2	\N	2025-05-11 12:12:16.046212
3237	Điểm hệ số 2 #2	539	2	\N	2025-05-11 12:12:16.046212
3238	Điểm hệ số 3	539	3	\N	2025-05-11 12:12:16.046212
3239	Điểm hệ số 1 #1	540	1	\N	2025-05-11 12:12:16.046212
3240	Điểm hệ số 1 #2	540	1	\N	2025-05-11 12:12:16.046212
3241	Điểm hệ số 1 #3	540	1	\N	2025-05-11 12:12:16.046212
3242	Điểm hệ số 2 #1	540	2	\N	2025-05-11 12:12:16.046212
3243	Điểm hệ số 2 #2	540	2	\N	2025-05-11 12:12:16.046212
3244	Điểm hệ số 3	540	3	\N	2025-05-11 12:12:16.046212
3245	Điểm hệ số 1 #1	541	1	\N	2025-05-11 12:12:16.046212
3246	Điểm hệ số 1 #2	541	1	\N	2025-05-11 12:12:16.046212
3247	Điểm hệ số 1 #3	541	1	\N	2025-05-11 12:12:16.046212
3248	Điểm hệ số 2 #1	541	2	\N	2025-05-11 12:12:16.046212
3249	Điểm hệ số 2 #2	541	2	\N	2025-05-11 12:12:16.046212
3250	Điểm hệ số 3	541	3	\N	2025-05-11 12:12:16.046212
3251	Điểm hệ số 1 #1	542	1	\N	2025-05-11 12:12:16.046212
3252	Điểm hệ số 1 #2	542	1	\N	2025-05-11 12:12:16.046212
3253	Điểm hệ số 1 #3	542	1	\N	2025-05-11 12:12:16.046212
3254	Điểm hệ số 2 #1	542	2	\N	2025-05-11 12:12:16.046212
3255	Điểm hệ số 2 #2	542	2	\N	2025-05-11 12:12:16.046212
3256	Điểm hệ số 3	542	3	\N	2025-05-11 12:12:16.046212
3257	Điểm hệ số 1 #1	543	1	\N	2025-05-11 12:12:16.046212
3258	Điểm hệ số 1 #2	543	1	\N	2025-05-11 12:12:16.046212
3259	Điểm hệ số 1 #3	543	1	\N	2025-05-11 12:12:16.046212
3260	Điểm hệ số 2 #1	543	2	\N	2025-05-11 12:12:16.046212
3261	Điểm hệ số 2 #2	543	2	\N	2025-05-11 12:12:16.046212
3262	Điểm hệ số 3	543	3	\N	2025-05-11 12:12:16.046212
3263	Điểm hệ số 1 #1	544	1	\N	2025-05-11 12:12:16.046212
3264	Điểm hệ số 1 #2	544	1	\N	2025-05-11 12:12:16.046212
3265	Điểm hệ số 1 #3	544	1	\N	2025-05-11 12:12:16.046212
3266	Điểm hệ số 2 #1	544	2	\N	2025-05-11 12:12:16.046212
3267	Điểm hệ số 2 #2	544	2	\N	2025-05-11 12:12:16.046212
3268	Điểm hệ số 3	544	3	\N	2025-05-11 12:12:16.046212
3269	Điểm hệ số 1 #1	545	1	\N	2025-05-11 12:12:16.046212
3270	Điểm hệ số 1 #2	545	1	\N	2025-05-11 12:12:16.046212
3271	Điểm hệ số 1 #3	545	1	\N	2025-05-11 12:12:16.046212
3272	Điểm hệ số 2 #1	545	2	\N	2025-05-11 12:12:16.046212
3273	Điểm hệ số 2 #2	545	2	\N	2025-05-11 12:12:16.046212
3274	Điểm hệ số 3	545	3	\N	2025-05-11 12:12:16.046212
3275	Điểm hệ số 1 #1	546	1	\N	2025-05-11 12:12:16.046212
3276	Điểm hệ số 1 #2	546	1	\N	2025-05-11 12:12:16.046212
3277	Điểm hệ số 1 #3	546	1	\N	2025-05-11 12:12:16.046212
3278	Điểm hệ số 2 #1	546	2	\N	2025-05-11 12:12:16.046212
3279	Điểm hệ số 2 #2	546	2	\N	2025-05-11 12:12:16.046212
3280	Điểm hệ số 3	546	3	\N	2025-05-11 12:12:16.046212
3281	Điểm hệ số 1 #1	547	1	\N	2025-05-11 12:12:16.046212
3282	Điểm hệ số 1 #2	547	1	\N	2025-05-11 12:12:16.046212
3283	Điểm hệ số 1 #3	547	1	\N	2025-05-11 12:12:16.046212
3284	Điểm hệ số 2 #1	547	2	\N	2025-05-11 12:12:16.046212
3285	Điểm hệ số 2 #2	547	2	\N	2025-05-11 12:12:16.046212
3286	Điểm hệ số 3	547	3	\N	2025-05-11 12:12:16.046212
3287	Điểm hệ số 1 #1	548	1	\N	2025-05-11 12:12:16.046212
3288	Điểm hệ số 1 #2	548	1	\N	2025-05-11 12:12:16.046212
3289	Điểm hệ số 1 #3	548	1	\N	2025-05-11 12:12:16.046212
3290	Điểm hệ số 2 #1	548	2	\N	2025-05-11 12:12:16.046212
3291	Điểm hệ số 2 #2	548	2	\N	2025-05-11 12:12:16.046212
3292	Điểm hệ số 3	548	3	\N	2025-05-11 12:12:16.046212
3293	Điểm hệ số 1 #1	549	1	\N	2025-05-11 12:12:16.046212
3294	Điểm hệ số 1 #2	549	1	\N	2025-05-11 12:12:16.046212
3295	Điểm hệ số 1 #3	549	1	\N	2025-05-11 12:12:16.046212
3296	Điểm hệ số 2 #1	549	2	\N	2025-05-11 12:12:16.046212
3297	Điểm hệ số 2 #2	549	2	\N	2025-05-11 12:12:16.046212
3298	Điểm hệ số 3	549	3	\N	2025-05-11 12:12:16.046212
3299	Điểm hệ số 1 #1	550	1	\N	2025-05-11 12:12:16.046212
3300	Điểm hệ số 1 #2	550	1	\N	2025-05-11 12:12:16.046212
3301	Điểm hệ số 1 #3	550	1	\N	2025-05-11 12:12:16.046212
3302	Điểm hệ số 2 #1	550	2	\N	2025-05-11 12:12:16.046212
3303	Điểm hệ số 2 #2	550	2	\N	2025-05-11 12:12:16.046212
3304	Điểm hệ số 3	550	3	\N	2025-05-11 12:12:16.046212
3305	Điểm hệ số 1 #1	551	1	\N	2025-05-11 12:12:16.046212
3306	Điểm hệ số 1 #2	551	1	\N	2025-05-11 12:12:16.046212
3307	Điểm hệ số 1 #3	551	1	\N	2025-05-11 12:12:16.046212
3308	Điểm hệ số 2 #1	551	2	\N	2025-05-11 12:12:16.046212
3309	Điểm hệ số 2 #2	551	2	\N	2025-05-11 12:12:16.046212
3310	Điểm hệ số 3	551	3	\N	2025-05-11 12:12:16.046212
3311	Điểm hệ số 1 #1	552	1	\N	2025-05-11 12:12:16.046212
3312	Điểm hệ số 1 #2	552	1	\N	2025-05-11 12:12:16.046212
3313	Điểm hệ số 1 #3	552	1	\N	2025-05-11 12:12:16.046212
3314	Điểm hệ số 2 #1	552	2	\N	2025-05-11 12:12:16.046212
3315	Điểm hệ số 2 #2	552	2	\N	2025-05-11 12:12:16.046212
3316	Điểm hệ số 3	552	3	\N	2025-05-11 12:12:16.046212
3317	Điểm hệ số 1 #1	553	1	\N	2025-05-11 12:12:16.046212
3318	Điểm hệ số 1 #2	553	1	\N	2025-05-11 12:12:16.046212
3319	Điểm hệ số 1 #3	553	1	\N	2025-05-11 12:12:16.046212
3320	Điểm hệ số 2 #1	553	2	\N	2025-05-11 12:12:16.046212
3321	Điểm hệ số 2 #2	553	2	\N	2025-05-11 12:12:16.046212
3322	Điểm hệ số 3	553	3	\N	2025-05-11 12:12:16.046212
3323	Điểm hệ số 1 #1	554	1	\N	2025-05-11 12:12:16.046212
3324	Điểm hệ số 1 #2	554	1	\N	2025-05-11 12:12:16.046212
3325	Điểm hệ số 1 #3	554	1	\N	2025-05-11 12:12:16.046212
3326	Điểm hệ số 2 #1	554	2	\N	2025-05-11 12:12:16.046212
3327	Điểm hệ số 2 #2	554	2	\N	2025-05-11 12:12:16.046212
3328	Điểm hệ số 3	554	3	\N	2025-05-11 12:12:16.046212
3329	Điểm hệ số 1 #1	555	1	\N	2025-05-11 12:12:16.046212
3330	Điểm hệ số 1 #2	555	1	\N	2025-05-11 12:12:16.046212
3331	Điểm hệ số 1 #3	555	1	\N	2025-05-11 12:12:16.046212
3332	Điểm hệ số 2 #1	555	2	\N	2025-05-11 12:12:16.046212
3333	Điểm hệ số 2 #2	555	2	\N	2025-05-11 12:12:16.046212
3334	Điểm hệ số 3	555	3	\N	2025-05-11 12:12:16.046212
3335	Điểm hệ số 1 #1	556	1	\N	2025-05-11 12:12:16.046212
3336	Điểm hệ số 1 #2	556	1	\N	2025-05-11 12:12:16.046212
3337	Điểm hệ số 1 #3	556	1	\N	2025-05-11 12:12:16.046212
3338	Điểm hệ số 2 #1	556	2	\N	2025-05-11 12:12:16.046212
3339	Điểm hệ số 2 #2	556	2	\N	2025-05-11 12:12:16.046212
3340	Điểm hệ số 3	556	3	\N	2025-05-11 12:12:16.046212
3341	Điểm hệ số 1 #1	557	1	\N	2025-05-11 12:12:16.046212
3342	Điểm hệ số 1 #2	557	1	\N	2025-05-11 12:12:16.046212
3343	Điểm hệ số 1 #3	557	1	\N	2025-05-11 12:12:16.046212
3344	Điểm hệ số 2 #1	557	2	\N	2025-05-11 12:12:16.046212
3345	Điểm hệ số 2 #2	557	2	\N	2025-05-11 12:12:16.046212
3346	Điểm hệ số 3	557	3	\N	2025-05-11 12:12:16.046212
3347	Điểm hệ số 1 #1	558	1	\N	2025-05-11 12:12:16.046212
3348	Điểm hệ số 1 #2	558	1	\N	2025-05-11 12:12:16.046212
3349	Điểm hệ số 1 #3	558	1	\N	2025-05-11 12:12:16.046212
3350	Điểm hệ số 2 #1	558	2	\N	2025-05-11 12:12:16.046212
3351	Điểm hệ số 2 #2	558	2	\N	2025-05-11 12:12:16.046212
3352	Điểm hệ số 3	558	3	\N	2025-05-11 12:12:16.046212
3353	Điểm hệ số 1 #1	559	1	\N	2025-05-11 12:12:16.046212
3354	Điểm hệ số 1 #2	559	1	\N	2025-05-11 12:12:16.046212
3355	Điểm hệ số 1 #3	559	1	\N	2025-05-11 12:12:16.046212
3356	Điểm hệ số 2 #1	559	2	\N	2025-05-11 12:12:16.046212
3357	Điểm hệ số 2 #2	559	2	\N	2025-05-11 12:12:16.046212
3358	Điểm hệ số 3	559	3	\N	2025-05-11 12:12:16.046212
3359	Điểm hệ số 1 #1	560	1	\N	2025-05-11 12:12:16.046212
3360	Điểm hệ số 1 #2	560	1	\N	2025-05-11 12:12:16.046212
3361	Điểm hệ số 1 #3	560	1	\N	2025-05-11 12:12:16.046212
3362	Điểm hệ số 2 #1	560	2	\N	2025-05-11 12:12:16.046212
3363	Điểm hệ số 2 #2	560	2	\N	2025-05-11 12:12:16.046212
3364	Điểm hệ số 3	560	3	\N	2025-05-11 12:12:16.046212
3365	Điểm hệ số 1 #1	561	1	\N	2025-05-11 12:12:16.046212
3366	Điểm hệ số 1 #2	561	1	\N	2025-05-11 12:12:16.046212
3367	Điểm hệ số 1 #3	561	1	\N	2025-05-11 12:12:16.046212
3368	Điểm hệ số 2 #1	561	2	\N	2025-05-11 12:12:16.046212
3369	Điểm hệ số 2 #2	561	2	\N	2025-05-11 12:12:16.046212
3370	Điểm hệ số 3	561	3	\N	2025-05-11 12:12:16.046212
3371	Điểm hệ số 1 #1	562	1	\N	2025-05-11 12:12:16.046212
3372	Điểm hệ số 1 #2	562	1	\N	2025-05-11 12:12:16.046212
3373	Điểm hệ số 1 #3	562	1	\N	2025-05-11 12:12:16.046212
3374	Điểm hệ số 2 #1	562	2	\N	2025-05-11 12:12:16.046212
3375	Điểm hệ số 2 #2	562	2	\N	2025-05-11 12:12:16.046212
3376	Điểm hệ số 3	562	3	\N	2025-05-11 12:12:16.046212
3377	Điểm hệ số 1 #1	563	1	\N	2025-05-11 12:12:16.046212
3378	Điểm hệ số 1 #2	563	1	\N	2025-05-11 12:12:16.046212
3379	Điểm hệ số 1 #3	563	1	\N	2025-05-11 12:12:16.046212
3380	Điểm hệ số 2 #1	563	2	\N	2025-05-11 12:12:16.046212
3381	Điểm hệ số 2 #2	563	2	\N	2025-05-11 12:12:16.046212
3382	Điểm hệ số 3	563	3	\N	2025-05-11 12:12:16.046212
3383	Điểm hệ số 1 #1	564	1	\N	2025-05-11 12:12:16.046212
3384	Điểm hệ số 1 #2	564	1	\N	2025-05-11 12:12:16.046212
3385	Điểm hệ số 1 #3	564	1	\N	2025-05-11 12:12:16.046212
3386	Điểm hệ số 2 #1	564	2	\N	2025-05-11 12:12:16.046212
3387	Điểm hệ số 2 #2	564	2	\N	2025-05-11 12:12:16.046212
3388	Điểm hệ số 3	564	3	\N	2025-05-11 12:12:16.046212
3389	Điểm hệ số 1 #1	565	1	\N	2025-05-11 12:12:16.046212
3390	Điểm hệ số 1 #2	565	1	\N	2025-05-11 12:12:16.046212
3391	Điểm hệ số 1 #3	565	1	\N	2025-05-11 12:12:16.046212
3392	Điểm hệ số 2 #1	565	2	\N	2025-05-11 12:12:16.046212
3393	Điểm hệ số 2 #2	565	2	\N	2025-05-11 12:12:16.046212
3394	Điểm hệ số 3	565	3	\N	2025-05-11 12:12:16.046212
3395	Điểm hệ số 1 #1	566	1	\N	2025-05-11 12:12:16.046212
3396	Điểm hệ số 1 #2	566	1	\N	2025-05-11 12:12:16.046212
3397	Điểm hệ số 1 #3	566	1	\N	2025-05-11 12:12:16.046212
3398	Điểm hệ số 2 #1	566	2	\N	2025-05-11 12:12:16.046212
3399	Điểm hệ số 2 #2	566	2	\N	2025-05-11 12:12:16.046212
3400	Điểm hệ số 3	566	3	\N	2025-05-11 12:12:16.046212
3401	Điểm hệ số 1 #1	567	1	\N	2025-05-11 12:12:16.046212
3402	Điểm hệ số 1 #2	567	1	\N	2025-05-11 12:12:16.046212
3403	Điểm hệ số 1 #3	567	1	\N	2025-05-11 12:12:16.046212
3404	Điểm hệ số 2 #1	567	2	\N	2025-05-11 12:12:16.046212
3405	Điểm hệ số 2 #2	567	2	\N	2025-05-11 12:12:16.046212
3406	Điểm hệ số 3	567	3	\N	2025-05-11 12:12:16.046212
3407	Điểm hệ số 1 #1	568	1	\N	2025-05-11 12:12:16.046212
3408	Điểm hệ số 1 #2	568	1	\N	2025-05-11 12:12:16.046212
3409	Điểm hệ số 1 #3	568	1	\N	2025-05-11 12:12:16.046212
3410	Điểm hệ số 2 #1	568	2	\N	2025-05-11 12:12:16.046212
3411	Điểm hệ số 2 #2	568	2	\N	2025-05-11 12:12:16.046212
3412	Điểm hệ số 3	568	3	\N	2025-05-11 12:12:16.046212
3413	Điểm hệ số 1 #1	569	1	\N	2025-05-11 12:12:16.046212
3414	Điểm hệ số 1 #2	569	1	\N	2025-05-11 12:12:16.047235
3415	Điểm hệ số 1 #3	569	1	\N	2025-05-11 12:12:16.047235
3416	Điểm hệ số 2 #1	569	2	\N	2025-05-11 12:12:16.047235
3417	Điểm hệ số 2 #2	569	2	\N	2025-05-11 12:12:16.047235
3418	Điểm hệ số 3	569	3	\N	2025-05-11 12:12:16.047235
3419	Điểm hệ số 1 #1	570	1	\N	2025-05-11 12:12:16.047235
3420	Điểm hệ số 1 #2	570	1	\N	2025-05-11 12:12:16.047235
3421	Điểm hệ số 1 #3	570	1	\N	2025-05-11 12:12:16.047235
3422	Điểm hệ số 2 #1	570	2	\N	2025-05-11 12:12:16.047235
3423	Điểm hệ số 2 #2	570	2	\N	2025-05-11 12:12:16.047235
3424	Điểm hệ số 3	570	3	\N	2025-05-11 12:12:16.047235
3425	Điểm hệ số 1 #1	571	1	\N	2025-05-11 12:12:16.047235
3426	Điểm hệ số 1 #2	571	1	\N	2025-05-11 12:12:16.047235
3427	Điểm hệ số 1 #3	571	1	\N	2025-05-11 12:12:16.047235
3428	Điểm hệ số 2 #1	571	2	\N	2025-05-11 12:12:16.047235
3429	Điểm hệ số 2 #2	571	2	\N	2025-05-11 12:12:16.047235
3430	Điểm hệ số 3	571	3	\N	2025-05-11 12:12:16.047235
3431	Điểm hệ số 1 #1	572	1	\N	2025-05-11 12:12:16.047235
3432	Điểm hệ số 1 #2	572	1	\N	2025-05-11 12:12:16.047235
3433	Điểm hệ số 1 #3	572	1	\N	2025-05-11 12:12:16.047235
3434	Điểm hệ số 2 #1	572	2	\N	2025-05-11 12:12:16.047235
3435	Điểm hệ số 2 #2	572	2	\N	2025-05-11 12:12:16.047235
3436	Điểm hệ số 3	572	3	\N	2025-05-11 12:12:16.047235
3437	Điểm hệ số 1 #1	573	1	\N	2025-05-11 12:12:16.047235
3438	Điểm hệ số 1 #2	573	1	\N	2025-05-11 12:12:16.047235
3439	Điểm hệ số 1 #3	573	1	\N	2025-05-11 12:12:16.047235
3440	Điểm hệ số 2 #1	573	2	\N	2025-05-11 12:12:16.047235
3441	Điểm hệ số 2 #2	573	2	\N	2025-05-11 12:12:16.047235
3442	Điểm hệ số 3	573	3	\N	2025-05-11 12:12:16.047235
3443	Điểm hệ số 1 #1	574	1	\N	2025-05-11 12:12:16.047235
3444	Điểm hệ số 1 #2	574	1	\N	2025-05-11 12:12:16.047235
3445	Điểm hệ số 1 #3	574	1	\N	2025-05-11 12:12:16.047235
3446	Điểm hệ số 2 #1	574	2	\N	2025-05-11 12:12:16.047235
3447	Điểm hệ số 2 #2	574	2	\N	2025-05-11 12:12:16.047235
3448	Điểm hệ số 3	574	3	\N	2025-05-11 12:12:16.047235
3449	Điểm hệ số 1 #1	575	1	\N	2025-05-11 12:12:16.047235
3450	Điểm hệ số 1 #2	575	1	\N	2025-05-11 12:12:16.047235
3451	Điểm hệ số 1 #3	575	1	\N	2025-05-11 12:12:16.047235
3452	Điểm hệ số 2 #1	575	2	\N	2025-05-11 12:12:16.047235
3453	Điểm hệ số 2 #2	575	2	\N	2025-05-11 12:12:16.047235
3454	Điểm hệ số 3	575	3	\N	2025-05-11 12:12:16.047235
3455	Điểm hệ số 1 #1	576	1	\N	2025-05-11 12:12:16.047235
3456	Điểm hệ số 1 #2	576	1	\N	2025-05-11 12:12:16.047235
3457	Điểm hệ số 1 #3	576	1	\N	2025-05-11 12:12:16.047235
3458	Điểm hệ số 2 #1	576	2	\N	2025-05-11 12:12:16.047235
3459	Điểm hệ số 2 #2	576	2	\N	2025-05-11 12:12:16.047235
3460	Điểm hệ số 3	576	3	\N	2025-05-11 12:12:16.047235
3461	Điểm hệ số 1 #1	577	1	\N	2025-05-11 12:12:16.047235
3462	Điểm hệ số 1 #2	577	1	\N	2025-05-11 12:12:16.047235
3463	Điểm hệ số 1 #3	577	1	\N	2025-05-11 12:12:16.047235
3464	Điểm hệ số 2 #1	577	2	\N	2025-05-11 12:12:16.047235
3465	Điểm hệ số 2 #2	577	2	\N	2025-05-11 12:12:16.047235
3466	Điểm hệ số 3	577	3	\N	2025-05-11 12:12:16.047235
3467	Điểm hệ số 1 #1	578	1	\N	2025-05-11 12:12:16.047235
3468	Điểm hệ số 1 #2	578	1	\N	2025-05-11 12:12:16.047235
3469	Điểm hệ số 1 #3	578	1	\N	2025-05-11 12:12:16.047235
3470	Điểm hệ số 2 #1	578	2	\N	2025-05-11 12:12:16.047235
3471	Điểm hệ số 2 #2	578	2	\N	2025-05-11 12:12:16.047235
3472	Điểm hệ số 3	578	3	\N	2025-05-11 12:12:16.047235
3473	Điểm hệ số 1 #1	579	1	\N	2025-05-11 12:12:16.047235
3474	Điểm hệ số 1 #2	579	1	\N	2025-05-11 12:12:16.047235
3475	Điểm hệ số 1 #3	579	1	\N	2025-05-11 12:12:16.047235
3476	Điểm hệ số 2 #1	579	2	\N	2025-05-11 12:12:16.047235
3477	Điểm hệ số 2 #2	579	2	\N	2025-05-11 12:12:16.047235
3478	Điểm hệ số 3	579	3	\N	2025-05-11 12:12:16.047235
3479	Điểm hệ số 1 #1	580	1	\N	2025-05-11 12:12:16.047235
3480	Điểm hệ số 1 #2	580	1	\N	2025-05-11 12:12:16.047235
3481	Điểm hệ số 1 #3	580	1	\N	2025-05-11 12:12:16.047235
3482	Điểm hệ số 2 #1	580	2	\N	2025-05-11 12:12:16.047235
3483	Điểm hệ số 2 #2	580	2	\N	2025-05-11 12:12:16.047235
3484	Điểm hệ số 3	580	3	\N	2025-05-11 12:12:16.047235
3485	Điểm hệ số 1 #1	581	1	\N	2025-05-11 12:12:16.047235
3486	Điểm hệ số 1 #2	581	1	\N	2025-05-11 12:12:16.047235
3487	Điểm hệ số 1 #3	581	1	\N	2025-05-11 12:12:16.047235
3488	Điểm hệ số 2 #1	581	2	\N	2025-05-11 12:12:16.047235
3489	Điểm hệ số 2 #2	581	2	\N	2025-05-11 12:12:16.047235
3490	Điểm hệ số 3	581	3	\N	2025-05-11 12:12:16.047235
3491	Điểm hệ số 1 #1	582	1	\N	2025-05-11 12:12:16.047235
3492	Điểm hệ số 1 #2	582	1	\N	2025-05-11 12:12:16.047235
3493	Điểm hệ số 1 #3	582	1	\N	2025-05-11 12:12:16.047235
3494	Điểm hệ số 2 #1	582	2	\N	2025-05-11 12:12:16.047235
3495	Điểm hệ số 2 #2	582	2	\N	2025-05-11 12:12:16.047235
3496	Điểm hệ số 3	582	3	\N	2025-05-11 12:12:16.047235
3497	Điểm hệ số 1 #1	583	1	\N	2025-05-11 12:12:16.047235
3498	Điểm hệ số 1 #2	583	1	\N	2025-05-11 12:12:16.047235
3499	Điểm hệ số 1 #3	583	1	\N	2025-05-11 12:12:16.047235
3500	Điểm hệ số 2 #1	583	2	\N	2025-05-11 12:12:16.047235
3501	Điểm hệ số 2 #2	583	2	\N	2025-05-11 12:12:16.047235
3502	Điểm hệ số 3	583	3	\N	2025-05-11 12:12:16.047235
3503	Điểm hệ số 1 #1	584	1	\N	2025-05-11 12:12:16.047235
3504	Điểm hệ số 1 #2	584	1	\N	2025-05-11 12:12:16.047235
3505	Điểm hệ số 1 #3	584	1	\N	2025-05-11 12:12:16.047235
3506	Điểm hệ số 2 #1	584	2	\N	2025-05-11 12:12:16.047235
3507	Điểm hệ số 2 #2	584	2	\N	2025-05-11 12:12:16.047235
3508	Điểm hệ số 3	584	3	\N	2025-05-11 12:12:16.047235
3509	Điểm hệ số 1 #1	585	1	\N	2025-05-11 12:12:16.047235
3510	Điểm hệ số 1 #2	585	1	\N	2025-05-11 12:12:16.047235
3511	Điểm hệ số 1 #3	585	1	\N	2025-05-11 12:12:16.047235
3512	Điểm hệ số 2 #1	585	2	\N	2025-05-11 12:12:16.047235
3513	Điểm hệ số 2 #2	585	2	\N	2025-05-11 12:12:16.047235
3514	Điểm hệ số 3	585	3	\N	2025-05-11 12:12:16.047235
3515	Điểm hệ số 1 #1	586	1	\N	2025-05-11 12:12:16.047235
3516	Điểm hệ số 1 #2	586	1	\N	2025-05-11 12:12:16.047235
3517	Điểm hệ số 1 #3	586	1	\N	2025-05-11 12:12:16.047235
3518	Điểm hệ số 2 #1	586	2	\N	2025-05-11 12:12:16.047235
3519	Điểm hệ số 2 #2	586	2	\N	2025-05-11 12:12:16.047235
3520	Điểm hệ số 3	586	3	\N	2025-05-11 12:12:16.047235
3521	Điểm hệ số 1 #1	587	1	\N	2025-05-11 12:12:16.047235
3522	Điểm hệ số 1 #2	587	1	\N	2025-05-11 12:12:16.047235
3523	Điểm hệ số 1 #3	587	1	\N	2025-05-11 12:12:16.047235
3524	Điểm hệ số 2 #1	587	2	\N	2025-05-11 12:12:16.047235
3525	Điểm hệ số 2 #2	587	2	\N	2025-05-11 12:12:16.047235
3526	Điểm hệ số 3	587	3	\N	2025-05-11 12:12:16.047235
3527	Điểm hệ số 1 #1	588	1	\N	2025-05-11 12:12:16.047235
3528	Điểm hệ số 1 #2	588	1	\N	2025-05-11 12:12:16.047235
3529	Điểm hệ số 1 #3	588	1	\N	2025-05-11 12:12:16.047235
3530	Điểm hệ số 2 #1	588	2	\N	2025-05-11 12:12:16.047235
3531	Điểm hệ số 2 #2	588	2	\N	2025-05-11 12:12:16.047235
3532	Điểm hệ số 3	588	3	\N	2025-05-11 12:12:16.047235
3533	Điểm hệ số 1 #1	589	1	\N	2025-05-11 12:12:16.047235
3534	Điểm hệ số 1 #2	589	1	\N	2025-05-11 12:12:16.047235
3535	Điểm hệ số 1 #3	589	1	\N	2025-05-11 12:12:16.047235
3536	Điểm hệ số 2 #1	589	2	\N	2025-05-11 12:12:16.047235
3537	Điểm hệ số 2 #2	589	2	\N	2025-05-11 12:12:16.047235
3538	Điểm hệ số 3	589	3	\N	2025-05-11 12:12:16.047235
3539	Điểm hệ số 1 #1	590	1	\N	2025-05-11 12:12:16.047235
3540	Điểm hệ số 1 #2	590	1	\N	2025-05-11 12:12:16.047235
3541	Điểm hệ số 1 #3	590	1	\N	2025-05-11 12:12:16.047235
3542	Điểm hệ số 2 #1	590	2	\N	2025-05-11 12:12:16.047235
3543	Điểm hệ số 2 #2	590	2	\N	2025-05-11 12:12:16.047235
3544	Điểm hệ số 3	590	3	\N	2025-05-11 12:12:16.047235
3545	Điểm hệ số 1 #1	591	1	\N	2025-05-11 12:12:16.047235
3546	Điểm hệ số 1 #2	591	1	\N	2025-05-11 12:12:16.047235
3547	Điểm hệ số 1 #3	591	1	\N	2025-05-11 12:12:16.047235
3548	Điểm hệ số 2 #1	591	2	\N	2025-05-11 12:12:16.047235
3549	Điểm hệ số 2 #2	591	2	\N	2025-05-11 12:12:16.047235
3550	Điểm hệ số 3	591	3	\N	2025-05-11 12:12:16.047235
3551	Điểm hệ số 1 #1	592	1	\N	2025-05-11 12:12:16.047235
3552	Điểm hệ số 1 #2	592	1	\N	2025-05-11 12:12:16.047235
3553	Điểm hệ số 1 #3	592	1	\N	2025-05-11 12:12:16.047235
3554	Điểm hệ số 2 #1	592	2	\N	2025-05-11 12:12:16.047235
3555	Điểm hệ số 2 #2	592	2	\N	2025-05-11 12:12:16.047235
3556	Điểm hệ số 3	592	3	\N	2025-05-11 12:12:16.047235
3557	Điểm hệ số 1 #1	593	1	\N	2025-05-11 12:12:16.047235
3558	Điểm hệ số 1 #2	593	1	\N	2025-05-11 12:12:16.047235
3559	Điểm hệ số 1 #3	593	1	\N	2025-05-11 12:12:16.047235
3560	Điểm hệ số 2 #1	593	2	\N	2025-05-11 12:12:16.047235
3561	Điểm hệ số 2 #2	593	2	\N	2025-05-11 12:12:16.047235
3562	Điểm hệ số 3	593	3	\N	2025-05-11 12:12:16.047235
3563	Điểm hệ số 1 #1	594	1	\N	2025-05-11 12:12:16.047235
3564	Điểm hệ số 1 #2	594	1	\N	2025-05-11 12:12:16.047235
3565	Điểm hệ số 1 #3	594	1	\N	2025-05-11 12:12:16.047235
3566	Điểm hệ số 2 #1	594	2	\N	2025-05-11 12:12:16.047235
3567	Điểm hệ số 2 #2	594	2	\N	2025-05-11 12:12:16.047235
3568	Điểm hệ số 3	594	3	\N	2025-05-11 12:12:16.047235
3569	Điểm hệ số 1 #1	595	1	\N	2025-05-11 12:12:16.047235
3570	Điểm hệ số 1 #2	595	1	\N	2025-05-11 12:12:16.047235
3571	Điểm hệ số 1 #3	595	1	\N	2025-05-11 12:12:16.047235
3572	Điểm hệ số 2 #1	595	2	\N	2025-05-11 12:12:16.047235
3573	Điểm hệ số 2 #2	595	2	\N	2025-05-11 12:12:16.047235
3574	Điểm hệ số 3	595	3	\N	2025-05-11 12:12:16.047235
3575	Điểm hệ số 1 #1	596	1	\N	2025-05-11 12:12:16.047235
3576	Điểm hệ số 1 #2	596	1	\N	2025-05-11 12:12:16.047235
3577	Điểm hệ số 1 #3	596	1	\N	2025-05-11 12:12:16.047235
3578	Điểm hệ số 2 #1	596	2	\N	2025-05-11 12:12:16.047235
3579	Điểm hệ số 2 #2	596	2	\N	2025-05-11 12:12:16.047235
3580	Điểm hệ số 3	596	3	\N	2025-05-11 12:12:16.047235
3581	Điểm hệ số 1 #1	597	1	\N	2025-05-11 12:12:16.047235
3582	Điểm hệ số 1 #2	597	1	\N	2025-05-11 12:12:16.047235
3583	Điểm hệ số 1 #3	597	1	\N	2025-05-11 12:12:16.047235
3584	Điểm hệ số 2 #1	597	2	\N	2025-05-11 12:12:16.047235
3585	Điểm hệ số 2 #2	597	2	\N	2025-05-11 12:12:16.047235
3586	Điểm hệ số 3	597	3	\N	2025-05-11 12:12:16.047235
3587	Điểm hệ số 1 #1	598	1	\N	2025-05-11 12:12:16.047235
3588	Điểm hệ số 1 #2	598	1	\N	2025-05-11 12:12:16.047235
3589	Điểm hệ số 1 #3	598	1	\N	2025-05-11 12:12:16.047235
3590	Điểm hệ số 2 #1	598	2	\N	2025-05-11 12:12:16.047235
3591	Điểm hệ số 2 #2	598	2	\N	2025-05-11 12:12:16.047235
3592	Điểm hệ số 3	598	3	\N	2025-05-11 12:12:16.047235
3593	Điểm hệ số 1 #1	599	1	\N	2025-05-11 12:12:16.047235
3594	Điểm hệ số 1 #2	599	1	\N	2025-05-11 12:12:16.047235
3595	Điểm hệ số 1 #3	599	1	\N	2025-05-11 12:12:16.047235
3596	Điểm hệ số 2 #1	599	2	\N	2025-05-11 12:12:16.047235
3597	Điểm hệ số 2 #2	599	2	\N	2025-05-11 12:12:16.047235
3598	Điểm hệ số 3	599	3	\N	2025-05-11 12:12:16.047235
3599	Điểm hệ số 1 #1	600	1	\N	2025-05-11 12:12:16.047235
3600	Điểm hệ số 1 #2	600	1	\N	2025-05-11 12:12:16.047235
3601	Điểm hệ số 1 #3	600	1	\N	2025-05-11 12:12:16.047235
3602	Điểm hệ số 2 #1	600	2	\N	2025-05-11 12:12:16.047235
3603	Điểm hệ số 2 #2	600	2	\N	2025-05-11 12:12:16.047235
3604	Điểm hệ số 3	600	3	\N	2025-05-11 12:12:16.047235
3605	Điểm hệ số 1 #1	601	1	\N	2025-05-11 12:12:16.047235
3606	Điểm hệ số 1 #2	601	1	\N	2025-05-11 12:12:16.047235
3607	Điểm hệ số 1 #3	601	1	\N	2025-05-11 12:12:16.047235
3608	Điểm hệ số 2 #1	601	2	\N	2025-05-11 12:12:16.047235
3609	Điểm hệ số 2 #2	601	2	\N	2025-05-11 12:12:16.047235
3610	Điểm hệ số 3	601	3	\N	2025-05-11 12:12:16.047235
3611	Điểm hệ số 1 #1	602	1	\N	2025-05-11 12:12:16.047235
3612	Điểm hệ số 1 #2	602	1	\N	2025-05-11 12:12:16.047235
3613	Điểm hệ số 1 #3	602	1	\N	2025-05-11 12:12:16.047235
3614	Điểm hệ số 2 #1	602	2	\N	2025-05-11 12:12:16.047235
3615	Điểm hệ số 2 #2	602	2	\N	2025-05-11 12:12:16.047235
3616	Điểm hệ số 3	602	3	\N	2025-05-11 12:12:16.047235
3617	Điểm hệ số 1 #1	603	1	\N	2025-05-11 12:12:16.047235
3618	Điểm hệ số 1 #2	603	1	\N	2025-05-11 12:12:16.047235
3619	Điểm hệ số 1 #3	603	1	\N	2025-05-11 12:12:16.047235
3620	Điểm hệ số 2 #1	603	2	\N	2025-05-11 12:12:16.047235
3621	Điểm hệ số 2 #2	603	2	\N	2025-05-11 12:12:16.047235
3622	Điểm hệ số 3	603	3	\N	2025-05-11 12:12:16.047235
3623	Điểm hệ số 1 #1	604	1	\N	2025-05-11 12:12:16.047235
3624	Điểm hệ số 1 #2	604	1	\N	2025-05-11 12:12:16.047235
3625	Điểm hệ số 1 #3	604	1	\N	2025-05-11 12:12:16.047235
3626	Điểm hệ số 2 #1	604	2	\N	2025-05-11 12:12:16.047235
3627	Điểm hệ số 2 #2	604	2	\N	2025-05-11 12:12:16.047235
3628	Điểm hệ số 3	604	3	\N	2025-05-11 12:12:16.047235
3629	Điểm hệ số 1 #1	605	1	\N	2025-05-11 12:12:16.047235
3630	Điểm hệ số 1 #2	605	1	\N	2025-05-11 12:12:16.047235
3631	Điểm hệ số 1 #3	605	1	\N	2025-05-11 12:12:16.047235
3632	Điểm hệ số 2 #1	605	2	\N	2025-05-11 12:12:16.047235
3633	Điểm hệ số 2 #2	605	2	\N	2025-05-11 12:12:16.047235
3634	Điểm hệ số 3	605	3	\N	2025-05-11 12:12:16.047235
3635	Điểm hệ số 1 #1	606	1	\N	2025-05-11 12:12:16.047235
3636	Điểm hệ số 1 #2	606	1	\N	2025-05-11 12:12:16.047235
3637	Điểm hệ số 1 #3	606	1	\N	2025-05-11 12:12:16.047235
3638	Điểm hệ số 2 #1	606	2	\N	2025-05-11 12:12:16.048214
3639	Điểm hệ số 2 #2	606	2	\N	2025-05-11 12:12:16.048214
3640	Điểm hệ số 3	606	3	\N	2025-05-11 12:12:16.048214
3641	Điểm hệ số 1 #1	607	1	\N	2025-05-11 12:12:16.048214
3642	Điểm hệ số 1 #2	607	1	\N	2025-05-11 12:12:16.048214
3643	Điểm hệ số 1 #3	607	1	\N	2025-05-11 12:12:16.048214
3644	Điểm hệ số 2 #1	607	2	\N	2025-05-11 12:12:16.048214
3645	Điểm hệ số 2 #2	607	2	\N	2025-05-11 12:12:16.048214
3646	Điểm hệ số 3	607	3	\N	2025-05-11 12:12:16.048214
3647	Điểm hệ số 1 #1	608	1	\N	2025-05-11 12:12:16.048214
3648	Điểm hệ số 1 #2	608	1	\N	2025-05-11 12:12:16.048214
3649	Điểm hệ số 1 #3	608	1	\N	2025-05-11 12:12:16.048214
3650	Điểm hệ số 2 #1	608	2	\N	2025-05-11 12:12:16.048214
3651	Điểm hệ số 2 #2	608	2	\N	2025-05-11 12:12:16.048214
3652	Điểm hệ số 3	608	3	\N	2025-05-11 12:12:16.048214
3653	Điểm hệ số 1 #1	609	1	\N	2025-05-11 12:12:16.048214
3654	Điểm hệ số 1 #2	609	1	\N	2025-05-11 12:12:16.048214
3655	Điểm hệ số 1 #3	609	1	\N	2025-05-11 12:12:16.048214
3656	Điểm hệ số 2 #1	609	2	\N	2025-05-11 12:12:16.048214
3657	Điểm hệ số 2 #2	609	2	\N	2025-05-11 12:12:16.048214
3658	Điểm hệ số 3	609	3	\N	2025-05-11 12:12:16.048214
3659	Điểm hệ số 1 #1	610	1	\N	2025-05-11 12:12:16.048214
3660	Điểm hệ số 1 #2	610	1	\N	2025-05-11 12:12:16.048214
3661	Điểm hệ số 1 #3	610	1	\N	2025-05-11 12:12:16.048214
3662	Điểm hệ số 2 #1	610	2	\N	2025-05-11 12:12:16.048214
3663	Điểm hệ số 2 #2	610	2	\N	2025-05-11 12:12:16.048214
3664	Điểm hệ số 3	610	3	\N	2025-05-11 12:12:16.048214
3665	Điểm hệ số 1 #1	611	1	\N	2025-05-11 12:12:16.048214
3666	Điểm hệ số 1 #2	611	1	\N	2025-05-11 12:12:16.048214
3667	Điểm hệ số 1 #3	611	1	\N	2025-05-11 12:12:16.048214
3668	Điểm hệ số 2 #1	611	2	\N	2025-05-11 12:12:16.048214
3669	Điểm hệ số 2 #2	611	2	\N	2025-05-11 12:12:16.048214
3670	Điểm hệ số 3	611	3	\N	2025-05-11 12:12:16.048214
3671	Điểm hệ số 1 #1	612	1	\N	2025-05-11 12:12:16.048214
3672	Điểm hệ số 1 #2	612	1	\N	2025-05-11 12:12:16.048214
3673	Điểm hệ số 1 #3	612	1	\N	2025-05-11 12:12:16.048214
3674	Điểm hệ số 2 #1	612	2	\N	2025-05-11 12:12:16.048214
3675	Điểm hệ số 2 #2	612	2	\N	2025-05-11 12:12:16.048214
3676	Điểm hệ số 3	612	3	\N	2025-05-11 12:12:16.048214
3677	Điểm hệ số 1 #1	613	1	\N	2025-05-11 12:12:16.048214
3678	Điểm hệ số 1 #2	613	1	\N	2025-05-11 12:12:16.048214
3679	Điểm hệ số 1 #3	613	1	\N	2025-05-11 12:12:16.048214
3680	Điểm hệ số 2 #1	613	2	\N	2025-05-11 12:12:16.048214
3681	Điểm hệ số 2 #2	613	2	\N	2025-05-11 12:12:16.048214
3682	Điểm hệ số 3	613	3	\N	2025-05-11 12:12:16.048214
3683	Điểm hệ số 1 #1	614	1	\N	2025-05-11 12:12:16.048214
3684	Điểm hệ số 1 #2	614	1	\N	2025-05-11 12:12:16.048214
3685	Điểm hệ số 1 #3	614	1	\N	2025-05-11 12:12:16.048214
3686	Điểm hệ số 2 #1	614	2	\N	2025-05-11 12:12:16.048214
3687	Điểm hệ số 2 #2	614	2	\N	2025-05-11 12:12:16.048214
3688	Điểm hệ số 3	614	3	\N	2025-05-11 12:12:16.048214
3689	Điểm hệ số 1 #1	615	1	\N	2025-05-11 12:12:16.048214
3690	Điểm hệ số 1 #2	615	1	\N	2025-05-11 12:12:16.048214
3691	Điểm hệ số 1 #3	615	1	\N	2025-05-11 12:12:16.048214
3692	Điểm hệ số 2 #1	615	2	\N	2025-05-11 12:12:16.048214
3693	Điểm hệ số 2 #2	615	2	\N	2025-05-11 12:12:16.048214
3694	Điểm hệ số 3	615	3	\N	2025-05-11 12:12:16.048214
3695	Điểm hệ số 1 #1	616	1	\N	2025-05-11 12:12:16.974677
3696	Điểm hệ số 1 #2	616	1	\N	2025-05-11 12:12:16.974677
3697	Điểm hệ số 1 #3	616	1	\N	2025-05-11 12:12:16.974677
3698	Điểm hệ số 2 #1	616	2	\N	2025-05-11 12:12:16.974677
3699	Điểm hệ số 2 #2	616	2	\N	2025-05-11 12:12:16.974677
3700	Điểm hệ số 3	616	3	\N	2025-05-11 12:12:16.974677
3701	Điểm hệ số 1 #1	617	1	\N	2025-05-11 12:12:16.974677
3702	Điểm hệ số 1 #2	617	1	\N	2025-05-11 12:12:16.974677
3703	Điểm hệ số 1 #3	617	1	\N	2025-05-11 12:12:16.974677
3704	Điểm hệ số 2 #1	617	2	\N	2025-05-11 12:12:16.974677
3705	Điểm hệ số 2 #2	617	2	\N	2025-05-11 12:12:16.974677
3706	Điểm hệ số 3	617	3	\N	2025-05-11 12:12:16.974677
3707	Điểm hệ số 1 #1	618	1	\N	2025-05-11 12:12:16.974677
3708	Điểm hệ số 1 #2	618	1	\N	2025-05-11 12:12:16.974677
3709	Điểm hệ số 1 #3	618	1	\N	2025-05-11 12:12:16.974677
3710	Điểm hệ số 2 #1	618	2	\N	2025-05-11 12:12:16.974677
3711	Điểm hệ số 2 #2	618	2	\N	2025-05-11 12:12:16.974677
3712	Điểm hệ số 3	618	3	\N	2025-05-11 12:12:16.974677
3713	Điểm hệ số 1 #1	619	1	\N	2025-05-11 12:12:16.974677
3714	Điểm hệ số 1 #2	619	1	\N	2025-05-11 12:12:16.974677
3715	Điểm hệ số 1 #3	619	1	\N	2025-05-11 12:12:16.974677
3716	Điểm hệ số 2 #1	619	2	\N	2025-05-11 12:12:16.974677
3717	Điểm hệ số 2 #2	619	2	\N	2025-05-11 12:12:16.974677
3718	Điểm hệ số 3	619	3	\N	2025-05-11 12:12:16.974677
3719	Điểm hệ số 1 #1	620	1	\N	2025-05-11 12:12:16.974677
3720	Điểm hệ số 1 #2	620	1	\N	2025-05-11 12:12:16.974677
3721	Điểm hệ số 1 #3	620	1	\N	2025-05-11 12:12:16.974677
3722	Điểm hệ số 2 #1	620	2	\N	2025-05-11 12:12:16.974677
3723	Điểm hệ số 2 #2	620	2	\N	2025-05-11 12:12:16.974677
3724	Điểm hệ số 3	620	3	\N	2025-05-11 12:12:16.974677
3725	Điểm hệ số 1 #1	621	1	\N	2025-05-11 12:12:16.974677
3726	Điểm hệ số 1 #2	621	1	\N	2025-05-11 12:12:16.974677
3727	Điểm hệ số 1 #3	621	1	\N	2025-05-11 12:12:16.974677
3728	Điểm hệ số 2 #1	621	2	\N	2025-05-11 12:12:16.974677
3729	Điểm hệ số 2 #2	621	2	\N	2025-05-11 12:12:16.974677
3730	Điểm hệ số 3	621	3	\N	2025-05-11 12:12:16.974677
3731	Điểm hệ số 1 #1	622	1	\N	2025-05-11 12:12:16.974677
3732	Điểm hệ số 1 #2	622	1	\N	2025-05-11 12:12:16.974677
3733	Điểm hệ số 1 #3	622	1	\N	2025-05-11 12:12:16.974677
3734	Điểm hệ số 2 #1	622	2	\N	2025-05-11 12:12:16.974677
3735	Điểm hệ số 2 #2	622	2	\N	2025-05-11 12:12:16.974677
3736	Điểm hệ số 3	622	3	\N	2025-05-11 12:12:16.974677
3737	Điểm hệ số 1 #1	623	1	\N	2025-05-11 12:12:16.974677
3738	Điểm hệ số 1 #2	623	1	\N	2025-05-11 12:12:16.974677
3739	Điểm hệ số 1 #3	623	1	\N	2025-05-11 12:12:16.974677
3740	Điểm hệ số 2 #1	623	2	\N	2025-05-11 12:12:16.974677
3741	Điểm hệ số 2 #2	623	2	\N	2025-05-11 12:12:16.974677
3742	Điểm hệ số 3	623	3	\N	2025-05-11 12:12:16.974677
3743	Điểm hệ số 1 #1	624	1	\N	2025-05-11 12:12:16.974677
3744	Điểm hệ số 1 #2	624	1	\N	2025-05-11 12:12:16.974677
3745	Điểm hệ số 1 #3	624	1	\N	2025-05-11 12:12:16.974677
3746	Điểm hệ số 2 #1	624	2	\N	2025-05-11 12:12:16.974677
3747	Điểm hệ số 2 #2	624	2	\N	2025-05-11 12:12:16.974677
3748	Điểm hệ số 3	624	3	\N	2025-05-11 12:12:16.974677
3749	Điểm hệ số 1 #1	625	1	\N	2025-05-11 12:12:16.974677
3750	Điểm hệ số 1 #2	625	1	\N	2025-05-11 12:12:16.974677
3751	Điểm hệ số 1 #3	625	1	\N	2025-05-11 12:12:16.974677
3752	Điểm hệ số 2 #1	625	2	\N	2025-05-11 12:12:16.974677
3753	Điểm hệ số 2 #2	625	2	\N	2025-05-11 12:12:16.974677
3754	Điểm hệ số 3	625	3	\N	2025-05-11 12:12:16.974677
3755	Điểm hệ số 1 #1	626	1	\N	2025-05-11 12:12:16.974677
3756	Điểm hệ số 1 #2	626	1	\N	2025-05-11 12:12:16.974677
3757	Điểm hệ số 1 #3	626	1	\N	2025-05-11 12:12:16.974677
3758	Điểm hệ số 2 #1	626	2	\N	2025-05-11 12:12:16.974677
3759	Điểm hệ số 2 #2	626	2	\N	2025-05-11 12:12:16.974677
3760	Điểm hệ số 3	626	3	\N	2025-05-11 12:12:16.974677
3761	Điểm hệ số 1 #1	627	1	\N	2025-05-11 12:12:16.974677
3762	Điểm hệ số 1 #2	627	1	\N	2025-05-11 12:12:16.974677
3763	Điểm hệ số 1 #3	627	1	\N	2025-05-11 12:12:16.974677
3764	Điểm hệ số 2 #1	627	2	\N	2025-05-11 12:12:16.974677
3765	Điểm hệ số 2 #2	627	2	\N	2025-05-11 12:12:16.974677
3766	Điểm hệ số 3	627	3	\N	2025-05-11 12:12:16.974677
3767	Điểm hệ số 1 #1	628	1	\N	2025-05-11 12:12:16.974677
3768	Điểm hệ số 1 #2	628	1	\N	2025-05-11 12:12:16.974677
3769	Điểm hệ số 1 #3	628	1	\N	2025-05-11 12:12:16.974677
3770	Điểm hệ số 2 #1	628	2	\N	2025-05-11 12:12:16.974677
3771	Điểm hệ số 2 #2	628	2	\N	2025-05-11 12:12:16.974677
3772	Điểm hệ số 3	628	3	\N	2025-05-11 12:12:16.974677
3773	Điểm hệ số 1 #1	629	1	\N	2025-05-11 12:12:16.974677
3774	Điểm hệ số 1 #2	629	1	\N	2025-05-11 12:12:16.974677
3775	Điểm hệ số 1 #3	629	1	\N	2025-05-11 12:12:16.974677
3776	Điểm hệ số 2 #1	629	2	\N	2025-05-11 12:12:16.974677
3777	Điểm hệ số 2 #2	629	2	\N	2025-05-11 12:12:16.974677
3778	Điểm hệ số 3	629	3	\N	2025-05-11 12:12:16.974677
3779	Điểm hệ số 1 #1	630	1	\N	2025-05-11 12:12:16.974677
3780	Điểm hệ số 1 #2	630	1	\N	2025-05-11 12:12:16.974677
3781	Điểm hệ số 1 #3	630	1	\N	2025-05-11 12:12:16.974677
3782	Điểm hệ số 2 #1	630	2	\N	2025-05-11 12:12:16.974677
3783	Điểm hệ số 2 #2	630	2	\N	2025-05-11 12:12:16.974677
3784	Điểm hệ số 3	630	3	\N	2025-05-11 12:12:16.974677
3785	Điểm hệ số 1 #1	631	1	\N	2025-05-11 12:12:16.974677
3786	Điểm hệ số 1 #2	631	1	\N	2025-05-11 12:12:16.974677
3787	Điểm hệ số 1 #3	631	1	\N	2025-05-11 12:12:16.974677
3788	Điểm hệ số 2 #1	631	2	\N	2025-05-11 12:12:16.974677
3789	Điểm hệ số 2 #2	631	2	\N	2025-05-11 12:12:16.974677
3790	Điểm hệ số 3	631	3	\N	2025-05-11 12:12:16.974677
3791	Điểm hệ số 1 #1	632	1	\N	2025-05-11 12:12:16.974677
3792	Điểm hệ số 1 #2	632	1	\N	2025-05-11 12:12:16.974677
3793	Điểm hệ số 1 #3	632	1	\N	2025-05-11 12:12:16.974677
3794	Điểm hệ số 2 #1	632	2	\N	2025-05-11 12:12:16.974677
3795	Điểm hệ số 2 #2	632	2	\N	2025-05-11 12:12:16.974677
3796	Điểm hệ số 3	632	3	\N	2025-05-11 12:12:16.974677
3797	Điểm hệ số 1 #1	633	1	\N	2025-05-11 12:12:16.974677
3798	Điểm hệ số 1 #2	633	1	\N	2025-05-11 12:12:16.974677
3799	Điểm hệ số 1 #3	633	1	\N	2025-05-11 12:12:16.974677
3800	Điểm hệ số 2 #1	633	2	\N	2025-05-11 12:12:16.974677
3801	Điểm hệ số 2 #2	633	2	\N	2025-05-11 12:12:16.974677
3802	Điểm hệ số 3	633	3	\N	2025-05-11 12:12:16.974677
3803	Điểm hệ số 1 #1	634	1	\N	2025-05-11 12:12:16.974677
3804	Điểm hệ số 1 #2	634	1	\N	2025-05-11 12:12:16.974677
3805	Điểm hệ số 1 #3	634	1	\N	2025-05-11 12:12:16.974677
3806	Điểm hệ số 2 #1	634	2	\N	2025-05-11 12:12:16.974677
3807	Điểm hệ số 2 #2	634	2	\N	2025-05-11 12:12:16.974677
3808	Điểm hệ số 3	634	3	\N	2025-05-11 12:12:16.974677
3809	Điểm hệ số 1 #1	635	1	\N	2025-05-11 12:12:16.974677
3810	Điểm hệ số 1 #2	635	1	\N	2025-05-11 12:12:16.974677
3811	Điểm hệ số 1 #3	635	1	\N	2025-05-11 12:12:16.974677
3812	Điểm hệ số 2 #1	635	2	\N	2025-05-11 12:12:16.974677
3813	Điểm hệ số 2 #2	635	2	\N	2025-05-11 12:12:16.974677
3814	Điểm hệ số 3	635	3	\N	2025-05-11 12:12:16.974677
3815	Điểm hệ số 1 #1	636	1	\N	2025-05-11 12:12:16.974677
3816	Điểm hệ số 1 #2	636	1	\N	2025-05-11 12:12:16.974677
3817	Điểm hệ số 1 #3	636	1	\N	2025-05-11 12:12:16.974677
3818	Điểm hệ số 2 #1	636	2	\N	2025-05-11 12:12:16.974677
3819	Điểm hệ số 2 #2	636	2	\N	2025-05-11 12:12:16.974677
3820	Điểm hệ số 3	636	3	\N	2025-05-11 12:12:16.974677
3821	Điểm hệ số 1 #1	637	1	\N	2025-05-11 12:12:16.974677
3822	Điểm hệ số 1 #2	637	1	\N	2025-05-11 12:12:16.974677
3823	Điểm hệ số 1 #3	637	1	\N	2025-05-11 12:12:16.974677
3824	Điểm hệ số 2 #1	637	2	\N	2025-05-11 12:12:16.974677
3825	Điểm hệ số 2 #2	637	2	\N	2025-05-11 12:12:16.974677
3826	Điểm hệ số 3	637	3	\N	2025-05-11 12:12:16.974677
3827	Điểm hệ số 1 #1	638	1	\N	2025-05-11 12:12:16.974677
3828	Điểm hệ số 1 #2	638	1	\N	2025-05-11 12:12:16.974677
3829	Điểm hệ số 1 #3	638	1	\N	2025-05-11 12:12:16.974677
3830	Điểm hệ số 2 #1	638	2	\N	2025-05-11 12:12:16.974677
3831	Điểm hệ số 2 #2	638	2	\N	2025-05-11 12:12:16.974677
3832	Điểm hệ số 3	638	3	\N	2025-05-11 12:12:16.974677
3833	Điểm hệ số 1 #1	639	1	\N	2025-05-11 12:12:16.974677
3834	Điểm hệ số 1 #2	639	1	\N	2025-05-11 12:12:16.974677
3835	Điểm hệ số 1 #3	639	1	\N	2025-05-11 12:12:16.974677
3836	Điểm hệ số 2 #1	639	2	\N	2025-05-11 12:12:16.974677
3837	Điểm hệ số 2 #2	639	2	\N	2025-05-11 12:12:16.974677
3838	Điểm hệ số 3	639	3	\N	2025-05-11 12:12:16.974677
3839	Điểm hệ số 1 #1	640	1	\N	2025-05-11 12:12:16.974677
3840	Điểm hệ số 1 #2	640	1	\N	2025-05-11 12:12:16.974677
3841	Điểm hệ số 1 #3	640	1	\N	2025-05-11 12:12:16.974677
3842	Điểm hệ số 2 #1	640	2	\N	2025-05-11 12:12:16.974677
3843	Điểm hệ số 2 #2	640	2	\N	2025-05-11 12:12:16.974677
3844	Điểm hệ số 3	640	3	\N	2025-05-11 12:12:16.974677
3845	Điểm hệ số 1 #1	641	1	\N	2025-05-11 12:12:16.975668
3846	Điểm hệ số 1 #2	641	1	\N	2025-05-11 12:12:16.975668
3847	Điểm hệ số 1 #3	641	1	\N	2025-05-11 12:12:16.975668
3848	Điểm hệ số 2 #1	641	2	\N	2025-05-11 12:12:16.975668
3849	Điểm hệ số 2 #2	641	2	\N	2025-05-11 12:12:16.975668
3850	Điểm hệ số 3	641	3	\N	2025-05-11 12:12:16.975668
3851	Điểm hệ số 1 #1	642	1	\N	2025-05-11 12:12:16.975668
3852	Điểm hệ số 1 #2	642	1	\N	2025-05-11 12:12:16.975668
3853	Điểm hệ số 1 #3	642	1	\N	2025-05-11 12:12:16.975668
3854	Điểm hệ số 2 #1	642	2	\N	2025-05-11 12:12:16.975668
3855	Điểm hệ số 2 #2	642	2	\N	2025-05-11 12:12:16.975668
3856	Điểm hệ số 3	642	3	\N	2025-05-11 12:12:16.975668
3857	Điểm hệ số 1 #1	643	1	\N	2025-05-11 12:12:16.975668
3858	Điểm hệ số 1 #2	643	1	\N	2025-05-11 12:12:16.975668
3859	Điểm hệ số 1 #3	643	1	\N	2025-05-11 12:12:16.975668
3860	Điểm hệ số 2 #1	643	2	\N	2025-05-11 12:12:16.975668
3861	Điểm hệ số 2 #2	643	2	\N	2025-05-11 12:12:16.975668
3862	Điểm hệ số 3	643	3	\N	2025-05-11 12:12:16.975668
3863	Điểm hệ số 1 #1	644	1	\N	2025-05-11 12:12:16.975668
3864	Điểm hệ số 1 #2	644	1	\N	2025-05-11 12:12:16.975668
3865	Điểm hệ số 1 #3	644	1	\N	2025-05-11 12:12:16.975668
3866	Điểm hệ số 2 #1	644	2	\N	2025-05-11 12:12:16.975668
3867	Điểm hệ số 2 #2	644	2	\N	2025-05-11 12:12:16.975668
3868	Điểm hệ số 3	644	3	\N	2025-05-11 12:12:16.975668
3869	Điểm hệ số 1 #1	645	1	\N	2025-05-11 12:12:16.975668
3870	Điểm hệ số 1 #2	645	1	\N	2025-05-11 12:12:16.975668
3871	Điểm hệ số 1 #3	645	1	\N	2025-05-11 12:12:16.975668
3872	Điểm hệ số 2 #1	645	2	\N	2025-05-11 12:12:16.975668
3873	Điểm hệ số 2 #2	645	2	\N	2025-05-11 12:12:16.975668
3874	Điểm hệ số 3	645	3	\N	2025-05-11 12:12:16.975668
3875	Điểm hệ số 1 #1	646	1	\N	2025-05-11 12:12:16.975668
3876	Điểm hệ số 1 #2	646	1	\N	2025-05-11 12:12:16.975668
3877	Điểm hệ số 1 #3	646	1	\N	2025-05-11 12:12:16.975668
3878	Điểm hệ số 2 #1	646	2	\N	2025-05-11 12:12:16.975668
3879	Điểm hệ số 2 #2	646	2	\N	2025-05-11 12:12:16.975668
3880	Điểm hệ số 3	646	3	\N	2025-05-11 12:12:16.975668
3881	Điểm hệ số 1 #1	647	1	\N	2025-05-11 12:12:16.975668
3882	Điểm hệ số 1 #2	647	1	\N	2025-05-11 12:12:16.975668
3883	Điểm hệ số 1 #3	647	1	\N	2025-05-11 12:12:16.975668
3884	Điểm hệ số 2 #1	647	2	\N	2025-05-11 12:12:16.975668
3885	Điểm hệ số 2 #2	647	2	\N	2025-05-11 12:12:16.975668
3886	Điểm hệ số 3	647	3	\N	2025-05-11 12:12:16.975668
3887	Điểm hệ số 1 #1	648	1	\N	2025-05-11 12:12:16.975668
3888	Điểm hệ số 1 #2	648	1	\N	2025-05-11 12:12:16.975668
3889	Điểm hệ số 1 #3	648	1	\N	2025-05-11 12:12:16.975668
3890	Điểm hệ số 2 #1	648	2	\N	2025-05-11 12:12:16.975668
3891	Điểm hệ số 2 #2	648	2	\N	2025-05-11 12:12:16.975668
3892	Điểm hệ số 3	648	3	\N	2025-05-11 12:12:16.975668
3893	Điểm hệ số 1 #1	649	1	\N	2025-05-11 12:12:16.975668
3894	Điểm hệ số 1 #2	649	1	\N	2025-05-11 12:12:16.975668
3895	Điểm hệ số 1 #3	649	1	\N	2025-05-11 12:12:16.975668
3896	Điểm hệ số 2 #1	649	2	\N	2025-05-11 12:12:16.975668
3897	Điểm hệ số 2 #2	649	2	\N	2025-05-11 12:12:16.975668
3898	Điểm hệ số 3	649	3	\N	2025-05-11 12:12:16.975668
3899	Điểm hệ số 1 #1	650	1	\N	2025-05-11 12:12:16.975668
3900	Điểm hệ số 1 #2	650	1	\N	2025-05-11 12:12:16.975668
3901	Điểm hệ số 1 #3	650	1	\N	2025-05-11 12:12:16.975668
3902	Điểm hệ số 2 #1	650	2	\N	2025-05-11 12:12:16.975668
3903	Điểm hệ số 2 #2	650	2	\N	2025-05-11 12:12:16.975668
3904	Điểm hệ số 3	650	3	\N	2025-05-11 12:12:16.975668
3905	Điểm hệ số 1 #1	651	1	\N	2025-05-11 12:12:16.975668
3906	Điểm hệ số 1 #2	651	1	\N	2025-05-11 12:12:16.975668
3907	Điểm hệ số 1 #3	651	1	\N	2025-05-11 12:12:16.975668
3908	Điểm hệ số 2 #1	651	2	\N	2025-05-11 12:12:16.975668
3909	Điểm hệ số 2 #2	651	2	\N	2025-05-11 12:12:16.975668
3910	Điểm hệ số 3	651	3	\N	2025-05-11 12:12:16.975668
3911	Điểm hệ số 1 #1	652	1	\N	2025-05-11 12:12:16.975668
3912	Điểm hệ số 1 #2	652	1	\N	2025-05-11 12:12:16.975668
3913	Điểm hệ số 1 #3	652	1	\N	2025-05-11 12:12:16.975668
3914	Điểm hệ số 2 #1	652	2	\N	2025-05-11 12:12:16.975668
3915	Điểm hệ số 2 #2	652	2	\N	2025-05-11 12:12:16.975668
3916	Điểm hệ số 3	652	3	\N	2025-05-11 12:12:16.975668
3917	Điểm hệ số 1 #1	653	1	\N	2025-05-11 12:12:16.975668
3918	Điểm hệ số 1 #2	653	1	\N	2025-05-11 12:12:16.975668
3919	Điểm hệ số 1 #3	653	1	\N	2025-05-11 12:12:16.975668
3920	Điểm hệ số 2 #1	653	2	\N	2025-05-11 12:12:16.975668
3921	Điểm hệ số 2 #2	653	2	\N	2025-05-11 12:12:16.975668
3922	Điểm hệ số 3	653	3	\N	2025-05-11 12:12:16.975668
3923	Điểm hệ số 1 #1	654	1	\N	2025-05-11 12:12:16.975668
3924	Điểm hệ số 1 #2	654	1	\N	2025-05-11 12:12:16.975668
3925	Điểm hệ số 1 #3	654	1	\N	2025-05-11 12:12:16.975668
3926	Điểm hệ số 2 #1	654	2	\N	2025-05-11 12:12:16.975668
3927	Điểm hệ số 2 #2	654	2	\N	2025-05-11 12:12:16.975668
3928	Điểm hệ số 3	654	3	\N	2025-05-11 12:12:16.975668
3929	Điểm hệ số 1 #1	655	1	\N	2025-05-11 12:12:16.975668
3930	Điểm hệ số 1 #2	655	1	\N	2025-05-11 12:12:16.975668
3931	Điểm hệ số 1 #3	655	1	\N	2025-05-11 12:12:16.975668
3932	Điểm hệ số 2 #1	655	2	\N	2025-05-11 12:12:16.975668
3933	Điểm hệ số 2 #2	655	2	\N	2025-05-11 12:12:16.975668
3934	Điểm hệ số 3	655	3	\N	2025-05-11 12:12:16.975668
3935	Điểm hệ số 1 #1	656	1	\N	2025-05-11 12:12:16.975668
3936	Điểm hệ số 1 #2	656	1	\N	2025-05-11 12:12:16.975668
3937	Điểm hệ số 1 #3	656	1	\N	2025-05-11 12:12:16.975668
3938	Điểm hệ số 2 #1	656	2	\N	2025-05-11 12:12:16.975668
3939	Điểm hệ số 2 #2	656	2	\N	2025-05-11 12:12:16.975668
3940	Điểm hệ số 3	656	3	\N	2025-05-11 12:12:16.975668
3941	Điểm hệ số 1 #1	657	1	\N	2025-05-11 12:12:16.975668
3942	Điểm hệ số 1 #2	657	1	\N	2025-05-11 12:12:16.975668
3943	Điểm hệ số 1 #3	657	1	\N	2025-05-11 12:12:16.975668
3944	Điểm hệ số 2 #1	657	2	\N	2025-05-11 12:12:16.975668
3945	Điểm hệ số 2 #2	657	2	\N	2025-05-11 12:12:16.975668
3946	Điểm hệ số 3	657	3	\N	2025-05-11 12:12:16.975668
3947	Điểm hệ số 1 #1	658	1	\N	2025-05-11 12:12:16.975668
3948	Điểm hệ số 1 #2	658	1	\N	2025-05-11 12:12:16.975668
3949	Điểm hệ số 1 #3	658	1	\N	2025-05-11 12:12:16.975668
3950	Điểm hệ số 2 #1	658	2	\N	2025-05-11 12:12:16.975668
3951	Điểm hệ số 2 #2	658	2	\N	2025-05-11 12:12:16.975668
3952	Điểm hệ số 3	658	3	\N	2025-05-11 12:12:16.975668
3953	Điểm hệ số 1 #1	659	1	\N	2025-05-11 12:12:16.975668
3954	Điểm hệ số 1 #2	659	1	\N	2025-05-11 12:12:16.975668
3955	Điểm hệ số 1 #3	659	1	\N	2025-05-11 12:12:16.975668
3956	Điểm hệ số 2 #1	659	2	\N	2025-05-11 12:12:16.975668
3957	Điểm hệ số 2 #2	659	2	\N	2025-05-11 12:12:16.975668
3958	Điểm hệ số 3	659	3	\N	2025-05-11 12:12:16.975668
3959	Điểm hệ số 1 #1	660	1	\N	2025-05-11 12:12:16.975668
3960	Điểm hệ số 1 #2	660	1	\N	2025-05-11 12:12:16.975668
3961	Điểm hệ số 1 #3	660	1	\N	2025-05-11 12:12:16.975668
3962	Điểm hệ số 2 #1	660	2	\N	2025-05-11 12:12:16.975668
3963	Điểm hệ số 2 #2	660	2	\N	2025-05-11 12:12:16.975668
3964	Điểm hệ số 3	660	3	\N	2025-05-11 12:12:16.975668
3965	Điểm hệ số 1 #1	661	1	\N	2025-05-11 12:12:16.975668
3966	Điểm hệ số 1 #2	661	1	\N	2025-05-11 12:12:16.975668
3967	Điểm hệ số 1 #3	661	1	\N	2025-05-11 12:12:16.975668
3968	Điểm hệ số 2 #1	661	2	\N	2025-05-11 12:12:16.975668
3969	Điểm hệ số 2 #2	661	2	\N	2025-05-11 12:12:16.975668
3970	Điểm hệ số 3	661	3	\N	2025-05-11 12:12:16.975668
3971	Điểm hệ số 1 #1	662	1	\N	2025-05-11 12:12:16.975668
3972	Điểm hệ số 1 #2	662	1	\N	2025-05-11 12:12:16.975668
3973	Điểm hệ số 1 #3	662	1	\N	2025-05-11 12:12:16.975668
3974	Điểm hệ số 2 #1	662	2	\N	2025-05-11 12:12:16.975668
3975	Điểm hệ số 2 #2	662	2	\N	2025-05-11 12:12:16.975668
3976	Điểm hệ số 3	662	3	\N	2025-05-11 12:12:16.975668
3977	Điểm hệ số 1 #1	663	1	\N	2025-05-11 12:12:16.975668
3978	Điểm hệ số 1 #2	663	1	\N	2025-05-11 12:12:16.975668
3979	Điểm hệ số 1 #3	663	1	\N	2025-05-11 12:12:16.975668
3980	Điểm hệ số 2 #1	663	2	\N	2025-05-11 12:12:16.975668
3981	Điểm hệ số 2 #2	663	2	\N	2025-05-11 12:12:16.975668
3982	Điểm hệ số 3	663	3	\N	2025-05-11 12:12:16.975668
3983	Điểm hệ số 1 #1	664	1	\N	2025-05-11 12:12:16.975668
3984	Điểm hệ số 1 #2	664	1	\N	2025-05-11 12:12:16.975668
3985	Điểm hệ số 1 #3	664	1	\N	2025-05-11 12:12:16.975668
3986	Điểm hệ số 2 #1	664	2	\N	2025-05-11 12:12:16.975668
3987	Điểm hệ số 2 #2	664	2	\N	2025-05-11 12:12:16.975668
3988	Điểm hệ số 3	664	3	\N	2025-05-11 12:12:16.975668
3989	Điểm hệ số 1 #1	665	1	\N	2025-05-11 12:12:16.975668
3990	Điểm hệ số 1 #2	665	1	\N	2025-05-11 12:12:16.975668
3991	Điểm hệ số 1 #3	665	1	\N	2025-05-11 12:12:16.975668
3992	Điểm hệ số 2 #1	665	2	\N	2025-05-11 12:12:16.975668
3993	Điểm hệ số 2 #2	665	2	\N	2025-05-11 12:12:16.975668
3994	Điểm hệ số 3	665	3	\N	2025-05-11 12:12:16.975668
3995	Điểm hệ số 1 #1	666	1	\N	2025-05-11 12:12:16.975668
3996	Điểm hệ số 1 #2	666	1	\N	2025-05-11 12:12:16.975668
3997	Điểm hệ số 1 #3	666	1	\N	2025-05-11 12:12:16.975668
3998	Điểm hệ số 2 #1	666	2	\N	2025-05-11 12:12:16.975668
3999	Điểm hệ số 2 #2	666	2	\N	2025-05-11 12:12:16.975668
4000	Điểm hệ số 3	666	3	\N	2025-05-11 12:12:16.975668
4001	Điểm hệ số 1 #1	667	1	\N	2025-05-11 12:12:16.975668
4002	Điểm hệ số 1 #2	667	1	\N	2025-05-11 12:12:16.975668
4003	Điểm hệ số 1 #3	667	1	\N	2025-05-11 12:12:16.975668
4004	Điểm hệ số 2 #1	667	2	\N	2025-05-11 12:12:16.975668
4005	Điểm hệ số 2 #2	667	2	\N	2025-05-11 12:12:16.975668
4006	Điểm hệ số 3	667	3	\N	2025-05-11 12:12:16.975668
4007	Điểm hệ số 1 #1	668	1	\N	2025-05-11 12:12:16.975668
4008	Điểm hệ số 1 #2	668	1	\N	2025-05-11 12:12:16.975668
4009	Điểm hệ số 1 #3	668	1	\N	2025-05-11 12:12:16.975668
4010	Điểm hệ số 2 #1	668	2	\N	2025-05-11 12:12:16.975668
4011	Điểm hệ số 2 #2	668	2	\N	2025-05-11 12:12:16.975668
4012	Điểm hệ số 3	668	3	\N	2025-05-11 12:12:16.975668
4013	Điểm hệ số 1 #1	669	1	\N	2025-05-11 12:12:16.975668
4014	Điểm hệ số 1 #2	669	1	\N	2025-05-11 12:12:16.975668
4015	Điểm hệ số 1 #3	669	1	\N	2025-05-11 12:12:16.975668
4016	Điểm hệ số 2 #1	669	2	\N	2025-05-11 12:12:16.975668
4017	Điểm hệ số 2 #2	669	2	\N	2025-05-11 12:12:16.975668
4018	Điểm hệ số 3	669	3	\N	2025-05-11 12:12:16.975668
4019	Điểm hệ số 1 #1	670	1	\N	2025-05-11 12:12:16.975668
4020	Điểm hệ số 1 #2	670	1	\N	2025-05-11 12:12:16.975668
4021	Điểm hệ số 1 #3	670	1	\N	2025-05-11 12:12:16.975668
4022	Điểm hệ số 2 #1	670	2	\N	2025-05-11 12:12:16.975668
4023	Điểm hệ số 2 #2	670	2	\N	2025-05-11 12:12:16.975668
4024	Điểm hệ số 3	670	3	\N	2025-05-11 12:12:16.975668
4025	Điểm hệ số 1 #1	671	1	\N	2025-05-11 12:12:16.975668
4026	Điểm hệ số 1 #2	671	1	\N	2025-05-11 12:12:16.975668
4027	Điểm hệ số 1 #3	671	1	\N	2025-05-11 12:12:16.975668
4028	Điểm hệ số 2 #1	671	2	\N	2025-05-11 12:12:16.975668
4029	Điểm hệ số 2 #2	671	2	\N	2025-05-11 12:12:16.975668
4030	Điểm hệ số 3	671	3	\N	2025-05-11 12:12:16.975668
4031	Điểm hệ số 1 #1	672	1	\N	2025-05-11 12:12:16.975668
4032	Điểm hệ số 1 #2	672	1	\N	2025-05-11 12:12:16.975668
4033	Điểm hệ số 1 #3	672	1	\N	2025-05-11 12:12:16.975668
4034	Điểm hệ số 2 #1	672	2	\N	2025-05-11 12:12:16.975668
4035	Điểm hệ số 2 #2	672	2	\N	2025-05-11 12:12:16.975668
4036	Điểm hệ số 3	672	3	\N	2025-05-11 12:12:16.975668
4037	Điểm hệ số 1 #1	673	1	\N	2025-05-11 12:12:16.975668
4038	Điểm hệ số 1 #2	673	1	\N	2025-05-11 12:12:16.975668
4039	Điểm hệ số 1 #3	673	1	\N	2025-05-11 12:12:16.975668
4040	Điểm hệ số 2 #1	673	2	\N	2025-05-11 12:12:16.975668
4041	Điểm hệ số 2 #2	673	2	\N	2025-05-11 12:12:16.975668
4042	Điểm hệ số 3	673	3	\N	2025-05-11 12:12:16.975668
4043	Điểm hệ số 1 #1	674	1	\N	2025-05-11 12:12:16.975668
4044	Điểm hệ số 1 #2	674	1	\N	2025-05-11 12:12:16.975668
4045	Điểm hệ số 1 #3	674	1	\N	2025-05-11 12:12:16.975668
4046	Điểm hệ số 2 #1	674	2	\N	2025-05-11 12:12:16.975668
4047	Điểm hệ số 2 #2	674	2	\N	2025-05-11 12:12:16.975668
4048	Điểm hệ số 3	674	3	\N	2025-05-11 12:12:16.975668
4049	Điểm hệ số 1 #1	675	1	\N	2025-05-11 12:12:16.975668
4050	Điểm hệ số 1 #2	675	1	\N	2025-05-11 12:12:16.975668
4051	Điểm hệ số 1 #3	675	1	\N	2025-05-11 12:12:16.975668
4052	Điểm hệ số 2 #1	675	2	\N	2025-05-11 12:12:16.975668
4053	Điểm hệ số 2 #2	675	2	\N	2025-05-11 12:12:16.975668
4054	Điểm hệ số 3	675	3	\N	2025-05-11 12:12:16.975668
4055	Điểm hệ số 1 #1	676	1	\N	2025-05-11 12:12:16.975668
4056	Điểm hệ số 1 #2	676	1	\N	2025-05-11 12:12:16.975668
4057	Điểm hệ số 1 #3	676	1	\N	2025-05-11 12:12:16.975668
4058	Điểm hệ số 2 #1	676	2	\N	2025-05-11 12:12:16.975668
4059	Điểm hệ số 2 #2	676	2	\N	2025-05-11 12:12:16.975668
4060	Điểm hệ số 3	676	3	\N	2025-05-11 12:12:16.975668
4061	Điểm hệ số 1 #1	677	1	\N	2025-05-11 12:12:16.975668
4062	Điểm hệ số 1 #2	677	1	\N	2025-05-11 12:12:16.975668
4063	Điểm hệ số 1 #3	677	1	\N	2025-05-11 12:12:16.975668
4064	Điểm hệ số 2 #1	677	2	\N	2025-05-11 12:12:16.975668
4065	Điểm hệ số 2 #2	677	2	\N	2025-05-11 12:12:16.975668
4066	Điểm hệ số 3	677	3	\N	2025-05-11 12:12:16.975668
4067	Điểm hệ số 1 #1	678	1	\N	2025-05-11 12:12:16.975668
4068	Điểm hệ số 1 #2	678	1	\N	2025-05-11 12:12:16.975668
4069	Điểm hệ số 1 #3	678	1	\N	2025-05-11 12:12:16.975668
4070	Điểm hệ số 2 #1	678	2	\N	2025-05-11 12:12:16.975668
4071	Điểm hệ số 2 #2	678	2	\N	2025-05-11 12:12:16.975668
4072	Điểm hệ số 3	678	3	\N	2025-05-11 12:12:16.975668
4073	Điểm hệ số 1 #1	679	1	\N	2025-05-11 12:12:16.975668
4074	Điểm hệ số 1 #2	679	1	\N	2025-05-11 12:12:16.975668
4075	Điểm hệ số 1 #3	679	1	\N	2025-05-11 12:12:16.975668
4076	Điểm hệ số 2 #1	679	2	\N	2025-05-11 12:12:16.976677
4077	Điểm hệ số 2 #2	679	2	\N	2025-05-11 12:12:16.976677
4078	Điểm hệ số 3	679	3	\N	2025-05-11 12:12:16.976677
4079	Điểm hệ số 1 #1	680	1	\N	2025-05-11 12:12:16.976677
4080	Điểm hệ số 1 #2	680	1	\N	2025-05-11 12:12:16.976677
4081	Điểm hệ số 1 #3	680	1	\N	2025-05-11 12:12:16.976677
4082	Điểm hệ số 2 #1	680	2	\N	2025-05-11 12:12:16.976677
4083	Điểm hệ số 2 #2	680	2	\N	2025-05-11 12:12:16.976677
4084	Điểm hệ số 3	680	3	\N	2025-05-11 12:12:16.976677
4085	Điểm hệ số 1 #1	681	1	\N	2025-05-11 12:12:16.976677
4086	Điểm hệ số 1 #2	681	1	\N	2025-05-11 12:12:16.976677
4087	Điểm hệ số 1 #3	681	1	\N	2025-05-11 12:12:16.976677
4088	Điểm hệ số 2 #1	681	2	\N	2025-05-11 12:12:16.976677
4089	Điểm hệ số 2 #2	681	2	\N	2025-05-11 12:12:16.976677
4090	Điểm hệ số 3	681	3	\N	2025-05-11 12:12:16.976677
4091	Điểm hệ số 1 #1	682	1	\N	2025-05-11 12:12:16.976677
4092	Điểm hệ số 1 #2	682	1	\N	2025-05-11 12:12:16.976677
4093	Điểm hệ số 1 #3	682	1	\N	2025-05-11 12:12:16.976677
4094	Điểm hệ số 2 #1	682	2	\N	2025-05-11 12:12:16.976677
4095	Điểm hệ số 2 #2	682	2	\N	2025-05-11 12:12:16.976677
4096	Điểm hệ số 3	682	3	\N	2025-05-11 12:12:16.976677
4097	Điểm hệ số 1 #1	683	1	\N	2025-05-11 12:12:16.976677
4098	Điểm hệ số 1 #2	683	1	\N	2025-05-11 12:12:16.976677
4099	Điểm hệ số 1 #3	683	1	\N	2025-05-11 12:12:16.976677
4100	Điểm hệ số 2 #1	683	2	\N	2025-05-11 12:12:16.976677
4101	Điểm hệ số 2 #2	683	2	\N	2025-05-11 12:12:16.976677
4102	Điểm hệ số 3	683	3	\N	2025-05-11 12:12:16.976677
4103	Điểm hệ số 1 #1	684	1	\N	2025-05-11 12:12:16.976677
4104	Điểm hệ số 1 #2	684	1	\N	2025-05-11 12:12:16.976677
4105	Điểm hệ số 1 #3	684	1	\N	2025-05-11 12:12:16.976677
4106	Điểm hệ số 2 #1	684	2	\N	2025-05-11 12:12:16.976677
4107	Điểm hệ số 2 #2	684	2	\N	2025-05-11 12:12:16.976677
4108	Điểm hệ số 3	684	3	\N	2025-05-11 12:12:16.976677
4109	Điểm hệ số 1 #1	685	1	\N	2025-05-11 12:12:16.976677
4110	Điểm hệ số 1 #2	685	1	\N	2025-05-11 12:12:16.976677
4111	Điểm hệ số 1 #3	685	1	\N	2025-05-11 12:12:16.976677
4112	Điểm hệ số 2 #1	685	2	\N	2025-05-11 12:12:16.976677
4113	Điểm hệ số 2 #2	685	2	\N	2025-05-11 12:12:16.976677
4114	Điểm hệ số 3	685	3	\N	2025-05-11 12:12:16.976677
4115	Điểm hệ số 1 #1	686	1	\N	2025-05-11 12:12:16.976677
4116	Điểm hệ số 1 #2	686	1	\N	2025-05-11 12:12:16.976677
4117	Điểm hệ số 1 #3	686	1	\N	2025-05-11 12:12:16.976677
4118	Điểm hệ số 2 #1	686	2	\N	2025-05-11 12:12:16.976677
4119	Điểm hệ số 2 #2	686	2	\N	2025-05-11 12:12:16.976677
4120	Điểm hệ số 3	686	3	\N	2025-05-11 12:12:16.976677
4121	Điểm hệ số 1 #1	687	1	\N	2025-05-11 12:12:16.976677
4122	Điểm hệ số 1 #2	687	1	\N	2025-05-11 12:12:16.976677
4123	Điểm hệ số 1 #3	687	1	\N	2025-05-11 12:12:16.976677
4124	Điểm hệ số 2 #1	687	2	\N	2025-05-11 12:12:16.976677
4125	Điểm hệ số 2 #2	687	2	\N	2025-05-11 12:12:16.976677
4126	Điểm hệ số 3	687	3	\N	2025-05-11 12:12:16.976677
4127	Điểm hệ số 1 #1	688	1	\N	2025-05-11 12:12:16.976677
4128	Điểm hệ số 1 #2	688	1	\N	2025-05-11 12:12:16.976677
4129	Điểm hệ số 1 #3	688	1	\N	2025-05-11 12:12:16.976677
4130	Điểm hệ số 2 #1	688	2	\N	2025-05-11 12:12:16.976677
4131	Điểm hệ số 2 #2	688	2	\N	2025-05-11 12:12:16.976677
4132	Điểm hệ số 3	688	3	\N	2025-05-11 12:12:16.976677
4133	Điểm hệ số 1 #1	689	1	\N	2025-05-11 12:12:16.976677
4134	Điểm hệ số 1 #2	689	1	\N	2025-05-11 12:12:16.976677
4135	Điểm hệ số 1 #3	689	1	\N	2025-05-11 12:12:16.976677
4136	Điểm hệ số 2 #1	689	2	\N	2025-05-11 12:12:16.976677
4137	Điểm hệ số 2 #2	689	2	\N	2025-05-11 12:12:16.976677
4138	Điểm hệ số 3	689	3	\N	2025-05-11 12:12:16.976677
4139	Điểm hệ số 1 #1	690	1	\N	2025-05-11 12:12:16.976677
4140	Điểm hệ số 1 #2	690	1	\N	2025-05-11 12:12:16.976677
4141	Điểm hệ số 1 #3	690	1	\N	2025-05-11 12:12:16.976677
4142	Điểm hệ số 2 #1	690	2	\N	2025-05-11 12:12:16.976677
4143	Điểm hệ số 2 #2	690	2	\N	2025-05-11 12:12:16.976677
4144	Điểm hệ số 3	690	3	\N	2025-05-11 12:12:16.976677
4145	Điểm hệ số 1 #1	691	1	\N	2025-05-11 12:12:16.976677
4146	Điểm hệ số 1 #2	691	1	\N	2025-05-11 12:12:16.976677
4147	Điểm hệ số 1 #3	691	1	\N	2025-05-11 12:12:16.976677
4148	Điểm hệ số 2 #1	691	2	\N	2025-05-11 12:12:16.976677
4149	Điểm hệ số 2 #2	691	2	\N	2025-05-11 12:12:16.976677
4150	Điểm hệ số 3	691	3	\N	2025-05-11 12:12:16.976677
4151	Điểm hệ số 1 #1	692	1	\N	2025-05-11 12:12:16.976677
4152	Điểm hệ số 1 #2	692	1	\N	2025-05-11 12:12:16.976677
4153	Điểm hệ số 1 #3	692	1	\N	2025-05-11 12:12:16.976677
4154	Điểm hệ số 2 #1	692	2	\N	2025-05-11 12:12:16.976677
4155	Điểm hệ số 2 #2	692	2	\N	2025-05-11 12:12:16.976677
4156	Điểm hệ số 3	692	3	\N	2025-05-11 12:12:16.976677
4157	Điểm hệ số 1 #1	693	1	\N	2025-05-11 12:12:16.976677
4158	Điểm hệ số 1 #2	693	1	\N	2025-05-11 12:12:16.976677
4159	Điểm hệ số 1 #3	693	1	\N	2025-05-11 12:12:16.976677
4160	Điểm hệ số 2 #1	693	2	\N	2025-05-11 12:12:16.976677
4161	Điểm hệ số 2 #2	693	2	\N	2025-05-11 12:12:16.976677
4162	Điểm hệ số 3	693	3	\N	2025-05-11 12:12:16.976677
4163	Điểm hệ số 1 #1	694	1	\N	2025-05-11 12:12:16.976677
4164	Điểm hệ số 1 #2	694	1	\N	2025-05-11 12:12:16.976677
4165	Điểm hệ số 1 #3	694	1	\N	2025-05-11 12:12:16.976677
4166	Điểm hệ số 2 #1	694	2	\N	2025-05-11 12:12:16.976677
4167	Điểm hệ số 2 #2	694	2	\N	2025-05-11 12:12:16.976677
4168	Điểm hệ số 3	694	3	\N	2025-05-11 12:12:16.976677
4169	Điểm hệ số 1 #1	695	1	\N	2025-05-11 12:12:16.976677
4170	Điểm hệ số 1 #2	695	1	\N	2025-05-11 12:12:16.976677
4171	Điểm hệ số 1 #3	695	1	\N	2025-05-11 12:12:16.976677
4172	Điểm hệ số 2 #1	695	2	\N	2025-05-11 12:12:16.976677
4173	Điểm hệ số 2 #2	695	2	\N	2025-05-11 12:12:16.976677
4174	Điểm hệ số 3	695	3	\N	2025-05-11 12:12:16.976677
4175	Điểm hệ số 1 #1	696	1	\N	2025-05-11 12:12:16.976677
4176	Điểm hệ số 1 #2	696	1	\N	2025-05-11 12:12:16.976677
4177	Điểm hệ số 1 #3	696	1	\N	2025-05-11 12:12:16.976677
4178	Điểm hệ số 2 #1	696	2	\N	2025-05-11 12:12:16.976677
4179	Điểm hệ số 2 #2	696	2	\N	2025-05-11 12:12:16.976677
4180	Điểm hệ số 3	696	3	\N	2025-05-11 12:12:16.976677
4181	Điểm hệ số 1 #1	697	1	\N	2025-05-11 12:12:16.976677
4182	Điểm hệ số 1 #2	697	1	\N	2025-05-11 12:12:16.976677
4183	Điểm hệ số 1 #3	697	1	\N	2025-05-11 12:12:16.976677
4184	Điểm hệ số 2 #1	697	2	\N	2025-05-11 12:12:16.976677
4185	Điểm hệ số 2 #2	697	2	\N	2025-05-11 12:12:16.976677
4186	Điểm hệ số 3	697	3	\N	2025-05-11 12:12:16.976677
4187	Điểm hệ số 1 #1	698	1	\N	2025-05-11 12:12:16.976677
4188	Điểm hệ số 1 #2	698	1	\N	2025-05-11 12:12:16.976677
4189	Điểm hệ số 1 #3	698	1	\N	2025-05-11 12:12:16.976677
4190	Điểm hệ số 2 #1	698	2	\N	2025-05-11 12:12:16.976677
4191	Điểm hệ số 2 #2	698	2	\N	2025-05-11 12:12:16.976677
4192	Điểm hệ số 3	698	3	\N	2025-05-11 12:12:16.976677
4193	Điểm hệ số 1 #1	699	1	\N	2025-05-11 12:12:16.976677
4194	Điểm hệ số 1 #2	699	1	\N	2025-05-11 12:12:16.976677
4195	Điểm hệ số 1 #3	699	1	\N	2025-05-11 12:12:16.976677
4196	Điểm hệ số 2 #1	699	2	\N	2025-05-11 12:12:16.976677
4197	Điểm hệ số 2 #2	699	2	\N	2025-05-11 12:12:16.976677
4198	Điểm hệ số 3	699	3	\N	2025-05-11 12:12:16.976677
4199	Điểm hệ số 1 #1	700	1	\N	2025-05-11 12:12:16.976677
4200	Điểm hệ số 1 #2	700	1	\N	2025-05-11 12:12:16.976677
4201	Điểm hệ số 1 #3	700	1	\N	2025-05-11 12:12:16.976677
4202	Điểm hệ số 2 #1	700	2	\N	2025-05-11 12:12:16.976677
4203	Điểm hệ số 2 #2	700	2	\N	2025-05-11 12:12:16.976677
4204	Điểm hệ số 3	700	3	\N	2025-05-11 12:12:16.976677
4205	Điểm hệ số 1 #1	701	1	\N	2025-05-11 12:12:16.976677
4206	Điểm hệ số 1 #2	701	1	\N	2025-05-11 12:12:16.976677
4207	Điểm hệ số 1 #3	701	1	\N	2025-05-11 12:12:16.976677
4208	Điểm hệ số 2 #1	701	2	\N	2025-05-11 12:12:16.976677
4209	Điểm hệ số 2 #2	701	2	\N	2025-05-11 12:12:16.976677
4210	Điểm hệ số 3	701	3	\N	2025-05-11 12:12:16.976677
4211	Điểm hệ số 1 #1	702	1	\N	2025-05-11 12:12:16.976677
4212	Điểm hệ số 1 #2	702	1	\N	2025-05-11 12:12:16.976677
4213	Điểm hệ số 1 #3	702	1	\N	2025-05-11 12:12:16.976677
4214	Điểm hệ số 2 #1	702	2	\N	2025-05-11 12:12:16.976677
4215	Điểm hệ số 2 #2	702	2	\N	2025-05-11 12:12:16.976677
4216	Điểm hệ số 3	702	3	\N	2025-05-11 12:12:16.976677
4217	Điểm hệ số 1 #1	703	1	\N	2025-05-11 12:12:16.976677
4218	Điểm hệ số 1 #2	703	1	\N	2025-05-11 12:12:16.976677
4219	Điểm hệ số 1 #3	703	1	\N	2025-05-11 12:12:16.976677
4220	Điểm hệ số 2 #1	703	2	\N	2025-05-11 12:12:16.976677
4221	Điểm hệ số 2 #2	703	2	\N	2025-05-11 12:12:16.976677
4222	Điểm hệ số 3	703	3	\N	2025-05-11 12:12:16.976677
4223	Điểm hệ số 1 #1	704	1	\N	2025-05-11 12:12:16.976677
4224	Điểm hệ số 1 #2	704	1	\N	2025-05-11 12:12:16.976677
4225	Điểm hệ số 1 #3	704	1	\N	2025-05-11 12:12:16.976677
4226	Điểm hệ số 2 #1	704	2	\N	2025-05-11 12:12:16.976677
4227	Điểm hệ số 2 #2	704	2	\N	2025-05-11 12:12:16.976677
4228	Điểm hệ số 3	704	3	\N	2025-05-11 12:12:16.976677
4229	Điểm hệ số 1 #1	705	1	\N	2025-05-11 12:12:16.976677
4230	Điểm hệ số 1 #2	705	1	\N	2025-05-11 12:12:16.976677
4231	Điểm hệ số 1 #3	705	1	\N	2025-05-11 12:12:16.976677
4232	Điểm hệ số 2 #1	705	2	\N	2025-05-11 12:12:16.976677
4233	Điểm hệ số 2 #2	705	2	\N	2025-05-11 12:12:16.976677
4234	Điểm hệ số 3	705	3	\N	2025-05-11 12:12:16.976677
4235	Điểm hệ số 1 #1	706	1	\N	2025-05-11 12:12:16.976677
4236	Điểm hệ số 1 #2	706	1	\N	2025-05-11 12:12:16.976677
4237	Điểm hệ số 1 #3	706	1	\N	2025-05-11 12:12:16.976677
4238	Điểm hệ số 2 #1	706	2	\N	2025-05-11 12:12:16.976677
4239	Điểm hệ số 2 #2	706	2	\N	2025-05-11 12:12:16.976677
4240	Điểm hệ số 3	706	3	\N	2025-05-11 12:12:16.976677
4241	Điểm hệ số 1 #1	707	1	\N	2025-05-11 12:12:16.976677
4242	Điểm hệ số 1 #2	707	1	\N	2025-05-11 12:12:16.976677
4243	Điểm hệ số 1 #3	707	1	\N	2025-05-11 12:12:16.976677
4244	Điểm hệ số 2 #1	707	2	\N	2025-05-11 12:12:16.976677
4245	Điểm hệ số 2 #2	707	2	\N	2025-05-11 12:12:16.976677
4246	Điểm hệ số 3	707	3	\N	2025-05-11 12:12:16.976677
4247	Điểm hệ số 1 #1	708	1	\N	2025-05-11 12:12:17.872686
4248	Điểm hệ số 1 #2	708	1	\N	2025-05-11 12:12:17.872686
4249	Điểm hệ số 1 #3	708	1	\N	2025-05-11 12:12:17.872686
4250	Điểm hệ số 2 #1	708	2	\N	2025-05-11 12:12:17.872686
4251	Điểm hệ số 2 #2	708	2	\N	2025-05-11 12:12:17.872686
4252	Điểm hệ số 3	708	3	\N	2025-05-11 12:12:17.872686
4253	Điểm hệ số 1 #1	709	1	\N	2025-05-11 12:12:17.872686
4254	Điểm hệ số 1 #2	709	1	\N	2025-05-11 12:12:17.872686
4255	Điểm hệ số 1 #3	709	1	\N	2025-05-11 12:12:17.872686
4256	Điểm hệ số 2 #1	709	2	\N	2025-05-11 12:12:17.872686
4257	Điểm hệ số 2 #2	709	2	\N	2025-05-11 12:12:17.872686
4258	Điểm hệ số 3	709	3	\N	2025-05-11 12:12:17.872686
4259	Điểm hệ số 1 #1	710	1	\N	2025-05-11 12:12:17.872686
4260	Điểm hệ số 1 #2	710	1	\N	2025-05-11 12:12:17.872686
4261	Điểm hệ số 1 #3	710	1	\N	2025-05-11 12:12:17.872686
4262	Điểm hệ số 2 #1	710	2	\N	2025-05-11 12:12:17.872686
4263	Điểm hệ số 2 #2	710	2	\N	2025-05-11 12:12:17.872686
4264	Điểm hệ số 3	710	3	\N	2025-05-11 12:12:17.872686
4265	Điểm hệ số 1 #1	711	1	\N	2025-05-11 12:12:17.872686
4266	Điểm hệ số 1 #2	711	1	\N	2025-05-11 12:12:17.872686
4267	Điểm hệ số 1 #3	711	1	\N	2025-05-11 12:12:17.872686
4268	Điểm hệ số 2 #1	711	2	\N	2025-05-11 12:12:17.872686
4269	Điểm hệ số 2 #2	711	2	\N	2025-05-11 12:12:17.872686
4270	Điểm hệ số 3	711	3	\N	2025-05-11 12:12:17.872686
4271	Điểm hệ số 1 #1	712	1	\N	2025-05-11 12:12:17.872686
4272	Điểm hệ số 1 #2	712	1	\N	2025-05-11 12:12:17.872686
4273	Điểm hệ số 1 #3	712	1	\N	2025-05-11 12:12:17.872686
4274	Điểm hệ số 2 #1	712	2	\N	2025-05-11 12:12:17.872686
4275	Điểm hệ số 2 #2	712	2	\N	2025-05-11 12:12:17.872686
4276	Điểm hệ số 3	712	3	\N	2025-05-11 12:12:17.872686
4277	Điểm hệ số 1 #1	713	1	\N	2025-05-11 12:12:17.872686
4278	Điểm hệ số 1 #2	713	1	\N	2025-05-11 12:12:17.872686
4279	Điểm hệ số 1 #3	713	1	\N	2025-05-11 12:12:17.872686
4280	Điểm hệ số 2 #1	713	2	\N	2025-05-11 12:12:17.872686
4281	Điểm hệ số 2 #2	713	2	\N	2025-05-11 12:12:17.872686
4282	Điểm hệ số 3	713	3	\N	2025-05-11 12:12:17.872686
4283	Điểm hệ số 1 #1	714	1	\N	2025-05-11 12:12:17.872686
4284	Điểm hệ số 1 #2	714	1	\N	2025-05-11 12:12:17.872686
4285	Điểm hệ số 1 #3	714	1	\N	2025-05-11 12:12:17.872686
4286	Điểm hệ số 2 #1	714	2	\N	2025-05-11 12:12:17.872686
4287	Điểm hệ số 2 #2	714	2	\N	2025-05-11 12:12:17.872686
4288	Điểm hệ số 3	714	3	\N	2025-05-11 12:12:17.872686
4289	Điểm hệ số 1 #1	715	1	\N	2025-05-11 12:12:17.872686
4290	Điểm hệ số 1 #2	715	1	\N	2025-05-11 12:12:17.872686
4291	Điểm hệ số 1 #3	715	1	\N	2025-05-11 12:12:17.872686
4292	Điểm hệ số 2 #1	715	2	\N	2025-05-11 12:12:17.872686
4293	Điểm hệ số 2 #2	715	2	\N	2025-05-11 12:12:17.873122
4294	Điểm hệ số 3	715	3	\N	2025-05-11 12:12:17.873122
4295	Điểm hệ số 1 #1	716	1	\N	2025-05-11 12:12:17.873122
4296	Điểm hệ số 1 #2	716	1	\N	2025-05-11 12:12:17.873122
4297	Điểm hệ số 1 #3	716	1	\N	2025-05-11 12:12:17.873122
4298	Điểm hệ số 2 #1	716	2	\N	2025-05-11 12:12:17.873122
4299	Điểm hệ số 2 #2	716	2	\N	2025-05-11 12:12:17.873122
4300	Điểm hệ số 3	716	3	\N	2025-05-11 12:12:17.873122
4301	Điểm hệ số 1 #1	717	1	\N	2025-05-11 12:12:17.873122
4302	Điểm hệ số 1 #2	717	1	\N	2025-05-11 12:12:17.873122
4303	Điểm hệ số 1 #3	717	1	\N	2025-05-11 12:12:17.873122
4304	Điểm hệ số 2 #1	717	2	\N	2025-05-11 12:12:17.873122
4305	Điểm hệ số 2 #2	717	2	\N	2025-05-11 12:12:17.873122
4306	Điểm hệ số 3	717	3	\N	2025-05-11 12:12:17.873122
4307	Điểm hệ số 1 #1	718	1	\N	2025-05-11 12:12:17.873122
4308	Điểm hệ số 1 #2	718	1	\N	2025-05-11 12:12:17.873122
4309	Điểm hệ số 1 #3	718	1	\N	2025-05-11 12:12:17.873122
4310	Điểm hệ số 2 #1	718	2	\N	2025-05-11 12:12:17.873122
4311	Điểm hệ số 2 #2	718	2	\N	2025-05-11 12:12:17.873122
4312	Điểm hệ số 3	718	3	\N	2025-05-11 12:12:17.873122
4313	Điểm hệ số 1 #1	719	1	\N	2025-05-11 12:12:17.873122
4314	Điểm hệ số 1 #2	719	1	\N	2025-05-11 12:12:17.873122
4315	Điểm hệ số 1 #3	719	1	\N	2025-05-11 12:12:17.873122
4316	Điểm hệ số 2 #1	719	2	\N	2025-05-11 12:12:17.873122
4317	Điểm hệ số 2 #2	719	2	\N	2025-05-11 12:12:17.873122
4318	Điểm hệ số 3	719	3	\N	2025-05-11 12:12:17.873122
4319	Điểm hệ số 1 #1	720	1	\N	2025-05-11 12:12:17.873122
4320	Điểm hệ số 1 #2	720	1	\N	2025-05-11 12:12:17.873122
4321	Điểm hệ số 1 #3	720	1	\N	2025-05-11 12:12:17.873122
4322	Điểm hệ số 2 #1	720	2	\N	2025-05-11 12:12:17.873122
4323	Điểm hệ số 2 #2	720	2	\N	2025-05-11 12:12:17.873122
4324	Điểm hệ số 3	720	3	\N	2025-05-11 12:12:17.873122
4325	Điểm hệ số 1 #1	721	1	\N	2025-05-11 12:12:17.873122
4326	Điểm hệ số 1 #2	721	1	\N	2025-05-11 12:12:17.873122
4327	Điểm hệ số 1 #3	721	1	\N	2025-05-11 12:12:17.873122
4328	Điểm hệ số 2 #1	721	2	\N	2025-05-11 12:12:17.873122
4329	Điểm hệ số 2 #2	721	2	\N	2025-05-11 12:12:17.873122
4330	Điểm hệ số 3	721	3	\N	2025-05-11 12:12:17.873122
4331	Điểm hệ số 1 #1	722	1	\N	2025-05-11 12:12:17.873122
4332	Điểm hệ số 1 #2	722	1	\N	2025-05-11 12:12:17.873122
4333	Điểm hệ số 1 #3	722	1	\N	2025-05-11 12:12:17.873122
4334	Điểm hệ số 2 #1	722	2	\N	2025-05-11 12:12:17.873122
4335	Điểm hệ số 2 #2	722	2	\N	2025-05-11 12:12:17.873122
4336	Điểm hệ số 3	722	3	\N	2025-05-11 12:12:17.873122
4337	Điểm hệ số 1 #1	723	1	\N	2025-05-11 12:12:17.873122
4338	Điểm hệ số 1 #2	723	1	\N	2025-05-11 12:12:17.873122
4339	Điểm hệ số 1 #3	723	1	\N	2025-05-11 12:12:17.873122
4340	Điểm hệ số 2 #1	723	2	\N	2025-05-11 12:12:17.873122
4341	Điểm hệ số 2 #2	723	2	\N	2025-05-11 12:12:17.873122
4342	Điểm hệ số 3	723	3	\N	2025-05-11 12:12:17.873122
4343	Điểm hệ số 1 #1	724	1	\N	2025-05-11 12:12:17.873122
4344	Điểm hệ số 1 #2	724	1	\N	2025-05-11 12:12:17.873122
4345	Điểm hệ số 1 #3	724	1	\N	2025-05-11 12:12:17.873122
4346	Điểm hệ số 2 #1	724	2	\N	2025-05-11 12:12:17.873122
4347	Điểm hệ số 2 #2	724	2	\N	2025-05-11 12:12:17.873122
4348	Điểm hệ số 3	724	3	\N	2025-05-11 12:12:17.873122
4349	Điểm hệ số 1 #1	725	1	\N	2025-05-11 12:12:17.873122
4350	Điểm hệ số 1 #2	725	1	\N	2025-05-11 12:12:17.873122
4351	Điểm hệ số 1 #3	725	1	\N	2025-05-11 12:12:17.873122
4352	Điểm hệ số 2 #1	725	2	\N	2025-05-11 12:12:17.873122
4353	Điểm hệ số 2 #2	725	2	\N	2025-05-11 12:12:17.873122
4354	Điểm hệ số 3	725	3	\N	2025-05-11 12:12:17.873122
4355	Điểm hệ số 1 #1	726	1	\N	2025-05-11 12:12:17.873122
4356	Điểm hệ số 1 #2	726	1	\N	2025-05-11 12:12:17.873122
4357	Điểm hệ số 1 #3	726	1	\N	2025-05-11 12:12:17.873122
4358	Điểm hệ số 2 #1	726	2	\N	2025-05-11 12:12:17.873122
4359	Điểm hệ số 2 #2	726	2	\N	2025-05-11 12:12:17.873122
4360	Điểm hệ số 3	726	3	\N	2025-05-11 12:12:17.873122
4361	Điểm hệ số 1 #1	727	1	\N	2025-05-11 12:12:17.873122
4362	Điểm hệ số 1 #2	727	1	\N	2025-05-11 12:12:17.873122
4363	Điểm hệ số 1 #3	727	1	\N	2025-05-11 12:12:17.873122
4364	Điểm hệ số 2 #1	727	2	\N	2025-05-11 12:12:17.873122
4365	Điểm hệ số 2 #2	727	2	\N	2025-05-11 12:12:17.873122
4366	Điểm hệ số 3	727	3	\N	2025-05-11 12:12:17.873122
4367	Điểm hệ số 1 #1	728	1	\N	2025-05-11 12:12:17.873122
4368	Điểm hệ số 1 #2	728	1	\N	2025-05-11 12:12:17.873122
4369	Điểm hệ số 1 #3	728	1	\N	2025-05-11 12:12:17.873122
4370	Điểm hệ số 2 #1	728	2	\N	2025-05-11 12:12:17.873122
4371	Điểm hệ số 2 #2	728	2	\N	2025-05-11 12:12:17.873122
4372	Điểm hệ số 3	728	3	\N	2025-05-11 12:12:17.873122
4373	Điểm hệ số 1 #1	729	1	\N	2025-05-11 12:12:17.873122
4374	Điểm hệ số 1 #2	729	1	\N	2025-05-11 12:12:17.873122
4375	Điểm hệ số 1 #3	729	1	\N	2025-05-11 12:12:17.873122
4376	Điểm hệ số 2 #1	729	2	\N	2025-05-11 12:12:17.873122
4377	Điểm hệ số 2 #2	729	2	\N	2025-05-11 12:12:17.873122
4378	Điểm hệ số 3	729	3	\N	2025-05-11 12:12:17.873122
4379	Điểm hệ số 1 #1	730	1	\N	2025-05-11 12:12:17.873122
4380	Điểm hệ số 1 #2	730	1	\N	2025-05-11 12:12:17.873122
4381	Điểm hệ số 1 #3	730	1	\N	2025-05-11 12:12:17.873122
4382	Điểm hệ số 2 #1	730	2	\N	2025-05-11 12:12:17.873122
4383	Điểm hệ số 2 #2	730	2	\N	2025-05-11 12:12:17.873122
4384	Điểm hệ số 3	730	3	\N	2025-05-11 12:12:17.873122
4385	Điểm hệ số 1 #1	731	1	\N	2025-05-11 12:12:17.873122
4386	Điểm hệ số 1 #2	731	1	\N	2025-05-11 12:12:17.873122
4387	Điểm hệ số 1 #3	731	1	\N	2025-05-11 12:12:17.873122
4388	Điểm hệ số 2 #1	731	2	\N	2025-05-11 12:12:17.873122
4389	Điểm hệ số 2 #2	731	2	\N	2025-05-11 12:12:17.873122
4390	Điểm hệ số 3	731	3	\N	2025-05-11 12:12:17.873122
4391	Điểm hệ số 1 #1	732	1	\N	2025-05-11 12:12:17.873122
4392	Điểm hệ số 1 #2	732	1	\N	2025-05-11 12:12:17.873122
4393	Điểm hệ số 1 #3	732	1	\N	2025-05-11 12:12:17.873122
4394	Điểm hệ số 2 #1	732	2	\N	2025-05-11 12:12:17.873122
4395	Điểm hệ số 2 #2	732	2	\N	2025-05-11 12:12:17.873122
4396	Điểm hệ số 3	732	3	\N	2025-05-11 12:12:17.873122
4397	Điểm hệ số 1 #1	733	1	\N	2025-05-11 12:12:17.873122
4398	Điểm hệ số 1 #2	733	1	\N	2025-05-11 12:12:17.873122
4399	Điểm hệ số 1 #3	733	1	\N	2025-05-11 12:12:17.873122
4400	Điểm hệ số 2 #1	733	2	\N	2025-05-11 12:12:17.873122
4401	Điểm hệ số 2 #2	733	2	\N	2025-05-11 12:12:17.873122
4402	Điểm hệ số 3	733	3	\N	2025-05-11 12:12:17.873122
4403	Điểm hệ số 1 #1	734	1	\N	2025-05-11 12:12:17.873122
4404	Điểm hệ số 1 #2	734	1	\N	2025-05-11 12:12:17.873122
4405	Điểm hệ số 1 #3	734	1	\N	2025-05-11 12:12:17.873122
4406	Điểm hệ số 2 #1	734	2	\N	2025-05-11 12:12:17.873122
4407	Điểm hệ số 2 #2	734	2	\N	2025-05-11 12:12:17.873122
4408	Điểm hệ số 3	734	3	\N	2025-05-11 12:12:17.873122
4409	Điểm hệ số 1 #1	735	1	\N	2025-05-11 12:12:17.873122
4410	Điểm hệ số 1 #2	735	1	\N	2025-05-11 12:12:17.873122
4411	Điểm hệ số 1 #3	735	1	\N	2025-05-11 12:12:17.873122
4412	Điểm hệ số 2 #1	735	2	\N	2025-05-11 12:12:17.873122
4413	Điểm hệ số 2 #2	735	2	\N	2025-05-11 12:12:17.873122
4414	Điểm hệ số 3	735	3	\N	2025-05-11 12:12:17.873122
4415	Điểm hệ số 1 #1	736	1	\N	2025-05-11 12:12:17.873122
4416	Điểm hệ số 1 #2	736	1	\N	2025-05-11 12:12:17.873122
4417	Điểm hệ số 1 #3	736	1	\N	2025-05-11 12:12:17.873122
4418	Điểm hệ số 2 #1	736	2	\N	2025-05-11 12:12:17.87366
4419	Điểm hệ số 2 #2	736	2	\N	2025-05-11 12:12:17.87366
4420	Điểm hệ số 3	736	3	\N	2025-05-11 12:12:17.87366
4421	Điểm hệ số 1 #1	737	1	\N	2025-05-11 12:12:17.87366
4422	Điểm hệ số 1 #2	737	1	\N	2025-05-11 12:12:17.87366
4423	Điểm hệ số 1 #3	737	1	\N	2025-05-11 12:12:17.87366
4424	Điểm hệ số 2 #1	737	2	\N	2025-05-11 12:12:17.87366
4425	Điểm hệ số 2 #2	737	2	\N	2025-05-11 12:12:17.87366
4426	Điểm hệ số 3	737	3	\N	2025-05-11 12:12:17.87366
4427	Điểm hệ số 1 #1	738	1	\N	2025-05-11 12:12:17.87366
4428	Điểm hệ số 1 #2	738	1	\N	2025-05-11 12:12:17.87366
4429	Điểm hệ số 1 #3	738	1	\N	2025-05-11 12:12:17.87366
4430	Điểm hệ số 2 #1	738	2	\N	2025-05-11 12:12:17.87366
4431	Điểm hệ số 2 #2	738	2	\N	2025-05-11 12:12:17.87366
4432	Điểm hệ số 3	738	3	\N	2025-05-11 12:12:17.87366
4433	Điểm hệ số 1 #1	739	1	\N	2025-05-11 12:12:17.87366
4434	Điểm hệ số 1 #2	739	1	\N	2025-05-11 12:12:17.87366
4435	Điểm hệ số 1 #3	739	1	\N	2025-05-11 12:12:17.87366
4436	Điểm hệ số 2 #1	739	2	\N	2025-05-11 12:12:17.87366
4437	Điểm hệ số 2 #2	739	2	\N	2025-05-11 12:12:17.87366
4438	Điểm hệ số 3	739	3	\N	2025-05-11 12:12:17.87366
4439	Điểm hệ số 1 #1	740	1	\N	2025-05-11 12:12:17.87366
4440	Điểm hệ số 1 #2	740	1	\N	2025-05-11 12:12:17.87366
4441	Điểm hệ số 1 #3	740	1	\N	2025-05-11 12:12:17.87366
4442	Điểm hệ số 2 #1	740	2	\N	2025-05-11 12:12:17.87366
4443	Điểm hệ số 2 #2	740	2	\N	2025-05-11 12:12:17.87366
4444	Điểm hệ số 3	740	3	\N	2025-05-11 12:12:17.87366
4445	Điểm hệ số 1 #1	741	1	\N	2025-05-11 12:12:17.87366
4446	Điểm hệ số 1 #2	741	1	\N	2025-05-11 12:12:17.87366
4447	Điểm hệ số 1 #3	741	1	\N	2025-05-11 12:12:17.87366
4448	Điểm hệ số 2 #1	741	2	\N	2025-05-11 12:12:17.87366
4449	Điểm hệ số 2 #2	741	2	\N	2025-05-11 12:12:17.87366
4450	Điểm hệ số 3	741	3	\N	2025-05-11 12:12:17.87366
4451	Điểm hệ số 1 #1	742	1	\N	2025-05-11 12:12:17.87366
4452	Điểm hệ số 1 #2	742	1	\N	2025-05-11 12:12:17.87366
4453	Điểm hệ số 1 #3	742	1	\N	2025-05-11 12:12:17.87366
4454	Điểm hệ số 2 #1	742	2	\N	2025-05-11 12:12:17.87366
4455	Điểm hệ số 2 #2	742	2	\N	2025-05-11 12:12:17.87366
4456	Điểm hệ số 3	742	3	\N	2025-05-11 12:12:17.87366
4457	Điểm hệ số 1 #1	743	1	\N	2025-05-11 12:12:17.87366
4458	Điểm hệ số 1 #2	743	1	\N	2025-05-11 12:12:17.87366
4459	Điểm hệ số 1 #3	743	1	\N	2025-05-11 12:12:17.87366
4460	Điểm hệ số 2 #1	743	2	\N	2025-05-11 12:12:17.87366
4461	Điểm hệ số 2 #2	743	2	\N	2025-05-11 12:12:17.87366
4462	Điểm hệ số 3	743	3	\N	2025-05-11 12:12:17.87366
4463	Điểm hệ số 1 #1	744	1	\N	2025-05-11 12:12:17.87366
4464	Điểm hệ số 1 #2	744	1	\N	2025-05-11 12:12:17.87366
4465	Điểm hệ số 1 #3	744	1	\N	2025-05-11 12:12:17.87366
4466	Điểm hệ số 2 #1	744	2	\N	2025-05-11 12:12:17.87366
4467	Điểm hệ số 2 #2	744	2	\N	2025-05-11 12:12:17.87366
4468	Điểm hệ số 3	744	3	\N	2025-05-11 12:12:17.87366
4469	Điểm hệ số 1 #1	745	1	\N	2025-05-11 12:12:17.87366
4470	Điểm hệ số 1 #2	745	1	\N	2025-05-11 12:12:17.87366
4471	Điểm hệ số 1 #3	745	1	\N	2025-05-11 12:12:17.87366
4472	Điểm hệ số 2 #1	745	2	\N	2025-05-11 12:12:17.87366
4473	Điểm hệ số 2 #2	745	2	\N	2025-05-11 12:12:17.87366
4474	Điểm hệ số 3	745	3	\N	2025-05-11 12:12:17.87366
4475	Điểm hệ số 1 #1	746	1	\N	2025-05-11 12:12:17.87366
4476	Điểm hệ số 1 #2	746	1	\N	2025-05-11 12:12:17.87366
4477	Điểm hệ số 1 #3	746	1	\N	2025-05-11 12:12:17.87366
4478	Điểm hệ số 2 #1	746	2	\N	2025-05-11 12:12:17.87366
4479	Điểm hệ số 2 #2	746	2	\N	2025-05-11 12:12:17.87366
4480	Điểm hệ số 3	746	3	\N	2025-05-11 12:12:17.87366
4481	Điểm hệ số 1 #1	747	1	\N	2025-05-11 12:12:17.87366
4482	Điểm hệ số 1 #2	747	1	\N	2025-05-11 12:12:17.87366
4483	Điểm hệ số 1 #3	747	1	\N	2025-05-11 12:12:17.87366
4484	Điểm hệ số 2 #1	747	2	\N	2025-05-11 12:12:17.87366
4485	Điểm hệ số 2 #2	747	2	\N	2025-05-11 12:12:17.87366
4486	Điểm hệ số 3	747	3	\N	2025-05-11 12:12:17.87366
4487	Điểm hệ số 1 #1	748	1	\N	2025-05-11 12:12:17.87366
4488	Điểm hệ số 1 #2	748	1	\N	2025-05-11 12:12:17.87366
4489	Điểm hệ số 1 #3	748	1	\N	2025-05-11 12:12:17.87366
4490	Điểm hệ số 2 #1	748	2	\N	2025-05-11 12:12:17.87366
4491	Điểm hệ số 2 #2	748	2	\N	2025-05-11 12:12:17.87366
4492	Điểm hệ số 3	748	3	\N	2025-05-11 12:12:17.87366
4493	Điểm hệ số 1 #1	749	1	\N	2025-05-11 12:12:17.87366
4494	Điểm hệ số 1 #2	749	1	\N	2025-05-11 12:12:17.87366
4495	Điểm hệ số 1 #3	749	1	\N	2025-05-11 12:12:17.87366
4496	Điểm hệ số 2 #1	749	2	\N	2025-05-11 12:12:17.87366
4497	Điểm hệ số 2 #2	749	2	\N	2025-05-11 12:12:17.87366
4498	Điểm hệ số 3	749	3	\N	2025-05-11 12:12:17.87366
4499	Điểm hệ số 1 #1	750	1	\N	2025-05-11 12:12:17.87366
4500	Điểm hệ số 1 #2	750	1	\N	2025-05-11 12:12:17.87366
4501	Điểm hệ số 1 #3	750	1	\N	2025-05-11 12:12:17.87366
4502	Điểm hệ số 2 #1	750	2	\N	2025-05-11 12:12:17.87366
4503	Điểm hệ số 2 #2	750	2	\N	2025-05-11 12:12:17.87366
4504	Điểm hệ số 3	750	3	\N	2025-05-11 12:12:17.87366
4505	Điểm hệ số 1 #1	751	1	\N	2025-05-11 12:12:17.87366
4506	Điểm hệ số 1 #2	751	1	\N	2025-05-11 12:12:17.87366
4507	Điểm hệ số 1 #3	751	1	\N	2025-05-11 12:12:17.87366
4508	Điểm hệ số 2 #1	751	2	\N	2025-05-11 12:12:17.87366
4509	Điểm hệ số 2 #2	751	2	\N	2025-05-11 12:12:17.87366
4510	Điểm hệ số 3	751	3	\N	2025-05-11 12:12:17.87366
4511	Điểm hệ số 1 #1	752	1	\N	2025-05-11 12:12:17.87366
4512	Điểm hệ số 1 #2	752	1	\N	2025-05-11 12:12:17.87366
4513	Điểm hệ số 1 #3	752	1	\N	2025-05-11 12:12:17.87366
4514	Điểm hệ số 2 #1	752	2	\N	2025-05-11 12:12:17.87366
4515	Điểm hệ số 2 #2	752	2	\N	2025-05-11 12:12:17.87366
4516	Điểm hệ số 3	752	3	\N	2025-05-11 12:12:17.87366
4517	Điểm hệ số 1 #1	753	1	\N	2025-05-11 12:12:17.87366
4518	Điểm hệ số 1 #2	753	1	\N	2025-05-11 12:12:17.87366
4519	Điểm hệ số 1 #3	753	1	\N	2025-05-11 12:12:17.87366
4520	Điểm hệ số 2 #1	753	2	\N	2025-05-11 12:12:17.87366
4521	Điểm hệ số 2 #2	753	2	\N	2025-05-11 12:12:17.87366
4522	Điểm hệ số 3	753	3	\N	2025-05-11 12:12:17.87366
4523	Điểm hệ số 1 #1	754	1	\N	2025-05-11 12:12:17.87366
4524	Điểm hệ số 1 #2	754	1	\N	2025-05-11 12:12:17.87366
4525	Điểm hệ số 1 #3	754	1	\N	2025-05-11 12:12:17.87366
4526	Điểm hệ số 2 #1	754	2	\N	2025-05-11 12:12:17.87366
4527	Điểm hệ số 2 #2	754	2	\N	2025-05-11 12:12:17.87366
4528	Điểm hệ số 3	754	3	\N	2025-05-11 12:12:17.87366
4529	Điểm hệ số 1 #1	755	1	\N	2025-05-11 12:12:17.87366
4530	Điểm hệ số 1 #2	755	1	\N	2025-05-11 12:12:17.87366
4531	Điểm hệ số 1 #3	755	1	\N	2025-05-11 12:12:17.87366
4532	Điểm hệ số 2 #1	755	2	\N	2025-05-11 12:12:17.87366
4533	Điểm hệ số 2 #2	755	2	\N	2025-05-11 12:12:17.87366
4534	Điểm hệ số 3	755	3	\N	2025-05-11 12:12:17.87366
4535	Điểm hệ số 1 #1	756	1	\N	2025-05-11 12:12:17.87366
4536	Điểm hệ số 1 #2	756	1	\N	2025-05-11 12:12:17.87366
4537	Điểm hệ số 1 #3	756	1	\N	2025-05-11 12:12:17.87366
4538	Điểm hệ số 2 #1	756	2	\N	2025-05-11 12:12:17.87366
4539	Điểm hệ số 2 #2	756	2	\N	2025-05-11 12:12:17.87366
4540	Điểm hệ số 3	756	3	\N	2025-05-11 12:12:17.87366
4541	Điểm hệ số 1 #1	757	1	\N	2025-05-11 12:12:17.87366
4542	Điểm hệ số 1 #2	757	1	\N	2025-05-11 12:12:17.87366
4543	Điểm hệ số 1 #3	757	1	\N	2025-05-11 12:12:17.87366
4544	Điểm hệ số 2 #1	757	2	\N	2025-05-11 12:12:17.87366
4545	Điểm hệ số 2 #2	757	2	\N	2025-05-11 12:12:17.87366
4546	Điểm hệ số 3	757	3	\N	2025-05-11 12:12:17.87366
4547	Điểm hệ số 1 #1	758	1	\N	2025-05-11 12:12:17.87366
4548	Điểm hệ số 1 #2	758	1	\N	2025-05-11 12:12:17.87366
4549	Điểm hệ số 1 #3	758	1	\N	2025-05-11 12:12:17.87366
4550	Điểm hệ số 2 #1	758	2	\N	2025-05-11 12:12:17.87366
4551	Điểm hệ số 2 #2	758	2	\N	2025-05-11 12:12:17.87366
4552	Điểm hệ số 3	758	3	\N	2025-05-11 12:12:17.87366
4553	Điểm hệ số 1 #1	759	1	\N	2025-05-11 12:12:17.87366
4554	Điểm hệ số 1 #2	759	1	\N	2025-05-11 12:12:17.87366
4555	Điểm hệ số 1 #3	759	1	\N	2025-05-11 12:12:17.87366
4556	Điểm hệ số 2 #1	759	2	\N	2025-05-11 12:12:17.87366
4557	Điểm hệ số 2 #2	759	2	\N	2025-05-11 12:12:17.87366
4558	Điểm hệ số 3	759	3	\N	2025-05-11 12:12:17.87366
4559	Điểm hệ số 1 #1	760	1	\N	2025-05-11 12:12:17.87366
4560	Điểm hệ số 1 #2	760	1	\N	2025-05-11 12:12:17.87366
4561	Điểm hệ số 1 #3	760	1	\N	2025-05-11 12:12:17.87366
4562	Điểm hệ số 2 #1	760	2	\N	2025-05-11 12:12:17.87366
4563	Điểm hệ số 2 #2	760	2	\N	2025-05-11 12:12:17.87366
4564	Điểm hệ số 3	760	3	\N	2025-05-11 12:12:17.87366
4565	Điểm hệ số 1 #1	761	1	\N	2025-05-11 12:12:17.87366
4566	Điểm hệ số 1 #2	761	1	\N	2025-05-11 12:12:17.87366
4567	Điểm hệ số 1 #3	761	1	\N	2025-05-11 12:12:17.87366
4568	Điểm hệ số 2 #1	761	2	\N	2025-05-11 12:12:17.87366
4569	Điểm hệ số 2 #2	761	2	\N	2025-05-11 12:12:17.87366
4570	Điểm hệ số 3	761	3	\N	2025-05-11 12:12:17.87366
4571	Điểm hệ số 1 #1	762	1	\N	2025-05-11 12:12:17.87366
4572	Điểm hệ số 1 #2	762	1	\N	2025-05-11 12:12:17.87366
4573	Điểm hệ số 1 #3	762	1	\N	2025-05-11 12:12:17.87366
4574	Điểm hệ số 2 #1	762	2	\N	2025-05-11 12:12:17.87366
4575	Điểm hệ số 2 #2	762	2	\N	2025-05-11 12:12:17.87366
4576	Điểm hệ số 3	762	3	\N	2025-05-11 12:12:17.87366
4577	Điểm hệ số 1 #1	763	1	\N	2025-05-11 12:12:17.87366
4578	Điểm hệ số 1 #2	763	1	\N	2025-05-11 12:12:17.87366
4579	Điểm hệ số 1 #3	763	1	\N	2025-05-11 12:12:17.87366
4580	Điểm hệ số 2 #1	763	2	\N	2025-05-11 12:12:17.87366
4581	Điểm hệ số 2 #2	763	2	\N	2025-05-11 12:12:17.87366
4582	Điểm hệ số 3	763	3	\N	2025-05-11 12:12:17.87366
4583	Điểm hệ số 1 #1	764	1	\N	2025-05-11 12:12:17.87366
4584	Điểm hệ số 1 #2	764	1	\N	2025-05-11 12:12:17.87366
4585	Điểm hệ số 1 #3	764	1	\N	2025-05-11 12:12:17.87366
4586	Điểm hệ số 2 #1	764	2	\N	2025-05-11 12:12:17.87366
4587	Điểm hệ số 2 #2	764	2	\N	2025-05-11 12:12:17.87366
4588	Điểm hệ số 3	764	3	\N	2025-05-11 12:12:17.87366
4589	Điểm hệ số 1 #1	765	1	\N	2025-05-11 12:12:17.87366
4590	Điểm hệ số 1 #2	765	1	\N	2025-05-11 12:12:17.87366
4591	Điểm hệ số 1 #3	765	1	\N	2025-05-11 12:12:17.87366
4592	Điểm hệ số 2 #1	765	2	\N	2025-05-11 12:12:17.87366
4593	Điểm hệ số 2 #2	765	2	\N	2025-05-11 12:12:17.87366
4594	Điểm hệ số 3	765	3	\N	2025-05-11 12:12:17.87366
4595	Điểm hệ số 1 #1	766	1	\N	2025-05-11 12:12:17.87366
4596	Điểm hệ số 1 #2	766	1	\N	2025-05-11 12:12:17.87366
4597	Điểm hệ số 1 #3	766	1	\N	2025-05-11 12:12:17.87366
4598	Điểm hệ số 2 #1	766	2	\N	2025-05-11 12:12:17.87366
4599	Điểm hệ số 2 #2	766	2	\N	2025-05-11 12:12:17.87366
4600	Điểm hệ số 3	766	3	\N	2025-05-11 12:12:17.87366
4601	Điểm hệ số 1 #1	767	1	\N	2025-05-11 12:12:17.87366
4602	Điểm hệ số 1 #2	767	1	\N	2025-05-11 12:12:17.87366
4603	Điểm hệ số 1 #3	767	1	\N	2025-05-11 12:12:17.87366
4604	Điểm hệ số 2 #1	767	2	\N	2025-05-11 12:12:17.87366
4605	Điểm hệ số 2 #2	767	2	\N	2025-05-11 12:12:17.87366
4606	Điểm hệ số 3	767	3	\N	2025-05-11 12:12:17.87366
4607	Điểm hệ số 1 #1	768	1	\N	2025-05-11 12:12:17.87366
4608	Điểm hệ số 1 #2	768	1	\N	2025-05-11 12:12:17.87366
4609	Điểm hệ số 1 #3	768	1	\N	2025-05-11 12:12:17.87366
4610	Điểm hệ số 2 #1	768	2	\N	2025-05-11 12:12:17.87366
4611	Điểm hệ số 2 #2	768	2	\N	2025-05-11 12:12:17.87366
4612	Điểm hệ số 3	768	3	\N	2025-05-11 12:12:17.87366
4613	Điểm hệ số 1 #1	769	1	\N	2025-05-11 12:12:17.87366
4614	Điểm hệ số 1 #2	769	1	\N	2025-05-11 12:12:17.87366
4615	Điểm hệ số 1 #3	769	1	\N	2025-05-11 12:12:17.87366
4616	Điểm hệ số 2 #1	769	2	\N	2025-05-11 12:12:17.87366
4617	Điểm hệ số 2 #2	769	2	\N	2025-05-11 12:12:17.87366
4618	Điểm hệ số 3	769	3	\N	2025-05-11 12:12:17.87366
4619	Điểm hệ số 1 #1	770	1	\N	2025-05-11 12:12:17.87366
4620	Điểm hệ số 1 #2	770	1	\N	2025-05-11 12:12:17.87366
4621	Điểm hệ số 1 #3	770	1	\N	2025-05-11 12:12:17.87366
4622	Điểm hệ số 2 #1	770	2	\N	2025-05-11 12:12:17.87366
4623	Điểm hệ số 2 #2	770	2	\N	2025-05-11 12:12:17.87366
4624	Điểm hệ số 3	770	3	\N	2025-05-11 12:12:17.87366
4625	Điểm hệ số 1 #1	771	1	\N	2025-05-11 12:12:17.87366
4626	Điểm hệ số 1 #2	771	1	\N	2025-05-11 12:12:17.87366
4627	Điểm hệ số 1 #3	771	1	\N	2025-05-11 12:12:17.87366
4628	Điểm hệ số 2 #1	771	2	\N	2025-05-11 12:12:17.87366
4629	Điểm hệ số 2 #2	771	2	\N	2025-05-11 12:12:17.87366
4630	Điểm hệ số 3	771	3	\N	2025-05-11 12:12:17.87366
4631	Điểm hệ số 1 #1	772	1	\N	2025-05-11 12:12:17.87366
4632	Điểm hệ số 1 #2	772	1	\N	2025-05-11 12:12:17.87366
4633	Điểm hệ số 1 #3	772	1	\N	2025-05-11 12:12:17.87366
4634	Điểm hệ số 2 #1	772	2	\N	2025-05-11 12:12:17.87366
4635	Điểm hệ số 2 #2	772	2	\N	2025-05-11 12:12:17.87366
4636	Điểm hệ số 3	772	3	\N	2025-05-11 12:12:17.87366
4637	Điểm hệ số 1 #1	773	1	\N	2025-05-11 12:12:17.87366
4638	Điểm hệ số 1 #2	773	1	\N	2025-05-11 12:12:17.87366
4639	Điểm hệ số 1 #3	773	1	\N	2025-05-11 12:12:17.87366
4640	Điểm hệ số 2 #1	773	2	\N	2025-05-11 12:12:17.87366
4641	Điểm hệ số 2 #2	773	2	\N	2025-05-11 12:12:17.87366
4642	Điểm hệ số 3	773	3	\N	2025-05-11 12:12:17.87366
4643	Điểm hệ số 1 #1	774	1	\N	2025-05-11 12:12:17.87366
4644	Điểm hệ số 1 #2	774	1	\N	2025-05-11 12:12:17.87366
4645	Điểm hệ số 1 #3	774	1	\N	2025-05-11 12:12:17.87366
4646	Điểm hệ số 2 #1	774	2	\N	2025-05-11 12:12:17.87366
4647	Điểm hệ số 2 #2	774	2	\N	2025-05-11 12:12:17.87366
4648	Điểm hệ số 3	774	3	\N	2025-05-11 12:12:17.87366
4649	Điểm hệ số 1 #1	775	1	\N	2025-05-11 12:12:17.87366
4650	Điểm hệ số 1 #2	775	1	\N	2025-05-11 12:12:17.87366
4651	Điểm hệ số 1 #3	775	1	\N	2025-05-11 12:12:17.87366
4652	Điểm hệ số 2 #1	775	2	\N	2025-05-11 12:12:17.87366
4653	Điểm hệ số 2 #2	775	2	\N	2025-05-11 12:12:17.874692
4654	Điểm hệ số 3	775	3	\N	2025-05-11 12:12:17.874692
4655	Điểm hệ số 1 #1	776	1	\N	2025-05-11 12:12:17.874692
4656	Điểm hệ số 1 #2	776	1	\N	2025-05-11 12:12:17.874692
4657	Điểm hệ số 1 #3	776	1	\N	2025-05-11 12:12:17.874692
4658	Điểm hệ số 2 #1	776	2	\N	2025-05-11 12:12:17.874692
4659	Điểm hệ số 2 #2	776	2	\N	2025-05-11 12:12:17.874692
4660	Điểm hệ số 3	776	3	\N	2025-05-11 12:12:17.874692
4661	Điểm hệ số 1 #1	777	1	\N	2025-05-11 12:12:17.874692
4662	Điểm hệ số 1 #2	777	1	\N	2025-05-11 12:12:17.874692
4663	Điểm hệ số 1 #3	777	1	\N	2025-05-11 12:12:17.874692
4664	Điểm hệ số 2 #1	777	2	\N	2025-05-11 12:12:17.874692
4665	Điểm hệ số 2 #2	777	2	\N	2025-05-11 12:12:17.874692
4666	Điểm hệ số 3	777	3	\N	2025-05-11 12:12:17.874692
4667	Điểm hệ số 1 #1	778	1	\N	2025-05-11 12:12:17.874692
4668	Điểm hệ số 1 #2	778	1	\N	2025-05-11 12:12:17.874692
4669	Điểm hệ số 1 #3	778	1	\N	2025-05-11 12:12:17.874692
4670	Điểm hệ số 2 #1	778	2	\N	2025-05-11 12:12:17.874692
4671	Điểm hệ số 2 #2	778	2	\N	2025-05-11 12:12:17.874692
4672	Điểm hệ số 3	778	3	\N	2025-05-11 12:12:17.874692
4673	Điểm hệ số 1 #1	779	1	\N	2025-05-11 12:12:17.874692
4674	Điểm hệ số 1 #2	779	1	\N	2025-05-11 12:12:17.874692
4675	Điểm hệ số 1 #3	779	1	\N	2025-05-11 12:12:17.874692
4676	Điểm hệ số 2 #1	779	2	\N	2025-05-11 12:12:17.874692
4677	Điểm hệ số 2 #2	779	2	\N	2025-05-11 12:12:17.874692
4678	Điểm hệ số 3	779	3	\N	2025-05-11 12:12:17.874692
4679	Điểm hệ số 1 #1	780	1	\N	2025-05-11 12:12:17.874692
4680	Điểm hệ số 1 #2	780	1	\N	2025-05-11 12:12:17.874692
4681	Điểm hệ số 1 #3	780	1	\N	2025-05-11 12:12:17.874692
4682	Điểm hệ số 2 #1	780	2	\N	2025-05-11 12:12:17.874692
4683	Điểm hệ số 2 #2	780	2	\N	2025-05-11 12:12:17.874692
4684	Điểm hệ số 3	780	3	\N	2025-05-11 12:12:17.874692
4685	Điểm hệ số 1 #1	781	1	\N	2025-05-11 12:12:17.874692
4686	Điểm hệ số 1 #2	781	1	\N	2025-05-11 12:12:17.874692
4687	Điểm hệ số 1 #3	781	1	\N	2025-05-11 12:12:17.874692
4688	Điểm hệ số 2 #1	781	2	\N	2025-05-11 12:12:17.874692
4689	Điểm hệ số 2 #2	781	2	\N	2025-05-11 12:12:17.874692
4690	Điểm hệ số 3	781	3	\N	2025-05-11 12:12:17.874692
4691	Điểm hệ số 1 #1	782	1	\N	2025-05-11 12:12:17.874692
4692	Điểm hệ số 1 #2	782	1	\N	2025-05-11 12:12:17.874692
4693	Điểm hệ số 1 #3	782	1	\N	2025-05-11 12:12:17.874692
4694	Điểm hệ số 2 #1	782	2	\N	2025-05-11 12:12:17.874692
4695	Điểm hệ số 2 #2	782	2	\N	2025-05-11 12:12:17.874692
4696	Điểm hệ số 3	782	3	\N	2025-05-11 12:12:17.874692
4697	Điểm hệ số 1 #1	783	1	\N	2025-05-11 12:12:17.874692
4698	Điểm hệ số 1 #2	783	1	\N	2025-05-11 12:12:17.874692
4699	Điểm hệ số 1 #3	783	1	\N	2025-05-11 12:12:17.874692
4700	Điểm hệ số 2 #1	783	2	\N	2025-05-11 12:12:17.874692
4701	Điểm hệ số 2 #2	783	2	\N	2025-05-11 12:12:17.874692
4702	Điểm hệ số 3	783	3	\N	2025-05-11 12:12:17.874692
4703	Điểm hệ số 1 #1	784	1	\N	2025-05-11 12:12:17.874692
4704	Điểm hệ số 1 #2	784	1	\N	2025-05-11 12:12:17.874692
4705	Điểm hệ số 1 #3	784	1	\N	2025-05-11 12:12:17.874692
4706	Điểm hệ số 2 #1	784	2	\N	2025-05-11 12:12:17.874692
4707	Điểm hệ số 2 #2	784	2	\N	2025-05-11 12:12:17.874692
4708	Điểm hệ số 3	784	3	\N	2025-05-11 12:12:17.874692
4709	Điểm hệ số 1 #1	785	1	\N	2025-05-11 12:12:17.874692
4710	Điểm hệ số 1 #2	785	1	\N	2025-05-11 12:12:17.874692
4711	Điểm hệ số 1 #3	785	1	\N	2025-05-11 12:12:17.874692
4712	Điểm hệ số 2 #1	785	2	\N	2025-05-11 12:12:17.874692
4713	Điểm hệ số 2 #2	785	2	\N	2025-05-11 12:12:17.874692
4714	Điểm hệ số 3	785	3	\N	2025-05-11 12:12:17.874692
4715	Điểm hệ số 1 #1	786	1	\N	2025-05-11 12:12:17.874692
4716	Điểm hệ số 1 #2	786	1	\N	2025-05-11 12:12:17.874692
4717	Điểm hệ số 1 #3	786	1	\N	2025-05-11 12:12:17.874692
4718	Điểm hệ số 2 #1	786	2	\N	2025-05-11 12:12:17.874692
4719	Điểm hệ số 2 #2	786	2	\N	2025-05-11 12:12:17.874692
4720	Điểm hệ số 3	786	3	\N	2025-05-11 12:12:17.874692
4721	Điểm hệ số 1 #1	787	1	\N	2025-05-11 12:12:17.874692
4722	Điểm hệ số 1 #2	787	1	\N	2025-05-11 12:12:17.874692
4723	Điểm hệ số 1 #3	787	1	\N	2025-05-11 12:12:17.874692
4724	Điểm hệ số 2 #1	787	2	\N	2025-05-11 12:12:17.874692
4725	Điểm hệ số 2 #2	787	2	\N	2025-05-11 12:12:17.874692
4726	Điểm hệ số 3	787	3	\N	2025-05-11 12:12:17.874692
4727	Điểm hệ số 1 #1	788	1	\N	2025-05-11 12:12:17.874692
4728	Điểm hệ số 1 #2	788	1	\N	2025-05-11 12:12:17.874692
4729	Điểm hệ số 1 #3	788	1	\N	2025-05-11 12:12:17.874692
4730	Điểm hệ số 2 #1	788	2	\N	2025-05-11 12:12:17.874692
4731	Điểm hệ số 2 #2	788	2	\N	2025-05-11 12:12:17.874692
4732	Điểm hệ số 3	788	3	\N	2025-05-11 12:12:17.874692
4733	Điểm hệ số 1 #1	789	1	\N	2025-05-11 12:12:17.874692
4734	Điểm hệ số 1 #2	789	1	\N	2025-05-11 12:12:17.874692
4735	Điểm hệ số 1 #3	789	1	\N	2025-05-11 12:12:17.874692
4736	Điểm hệ số 2 #1	789	2	\N	2025-05-11 12:12:17.874692
4737	Điểm hệ số 2 #2	789	2	\N	2025-05-11 12:12:17.874692
4738	Điểm hệ số 3	789	3	\N	2025-05-11 12:12:17.874692
4739	Điểm hệ số 1 #1	790	1	\N	2025-05-11 12:12:17.874692
4740	Điểm hệ số 1 #2	790	1	\N	2025-05-11 12:12:17.874692
4741	Điểm hệ số 1 #3	790	1	\N	2025-05-11 12:12:17.874692
4742	Điểm hệ số 2 #1	790	2	\N	2025-05-11 12:12:17.874692
4743	Điểm hệ số 2 #2	790	2	\N	2025-05-11 12:12:17.874692
4744	Điểm hệ số 3	790	3	\N	2025-05-11 12:12:17.874692
4745	Điểm hệ số 1 #1	791	1	\N	2025-05-11 12:12:17.874692
4746	Điểm hệ số 1 #2	791	1	\N	2025-05-11 12:12:17.874692
4747	Điểm hệ số 1 #3	791	1	\N	2025-05-11 12:12:17.874692
4748	Điểm hệ số 2 #1	791	2	\N	2025-05-11 12:12:17.874692
4749	Điểm hệ số 2 #2	791	2	\N	2025-05-11 12:12:17.874692
4750	Điểm hệ số 3	791	3	\N	2025-05-11 12:12:17.874692
4751	Điểm hệ số 1 #1	792	1	\N	2025-05-11 12:12:17.874692
4752	Điểm hệ số 1 #2	792	1	\N	2025-05-11 12:12:17.874692
4753	Điểm hệ số 1 #3	792	1	\N	2025-05-11 12:12:17.874692
4754	Điểm hệ số 2 #1	792	2	\N	2025-05-11 12:12:17.874692
4755	Điểm hệ số 2 #2	792	2	\N	2025-05-11 12:12:17.874692
4756	Điểm hệ số 3	792	3	\N	2025-05-11 12:12:17.874692
4757	Điểm hệ số 1 #1	793	1	\N	2025-05-11 12:12:17.874692
4758	Điểm hệ số 1 #2	793	1	\N	2025-05-11 12:12:17.874692
4759	Điểm hệ số 1 #3	793	1	\N	2025-05-11 12:12:17.874692
4760	Điểm hệ số 2 #1	793	2	\N	2025-05-11 12:12:17.874692
4761	Điểm hệ số 2 #2	793	2	\N	2025-05-11 12:12:17.874692
4762	Điểm hệ số 3	793	3	\N	2025-05-11 12:12:17.874692
4763	Điểm hệ số 1 #1	794	1	\N	2025-05-11 12:12:17.874692
4764	Điểm hệ số 1 #2	794	1	\N	2025-05-11 12:12:17.874692
4765	Điểm hệ số 1 #3	794	1	\N	2025-05-11 12:12:17.874692
4766	Điểm hệ số 2 #1	794	2	\N	2025-05-11 12:12:17.874692
4767	Điểm hệ số 2 #2	794	2	\N	2025-05-11 12:12:17.874692
4768	Điểm hệ số 3	794	3	\N	2025-05-11 12:12:17.874692
4769	Điểm hệ số 1 #1	795	1	\N	2025-05-11 12:12:17.874692
4770	Điểm hệ số 1 #2	795	1	\N	2025-05-11 12:12:17.874692
4771	Điểm hệ số 1 #3	795	1	\N	2025-05-11 12:12:17.874692
4772	Điểm hệ số 2 #1	795	2	\N	2025-05-11 12:12:17.874692
4773	Điểm hệ số 2 #2	795	2	\N	2025-05-11 12:12:17.874692
4774	Điểm hệ số 3	795	3	\N	2025-05-11 12:12:17.874692
4775	Điểm hệ số 1 #1	796	1	\N	2025-05-11 12:12:17.874692
4776	Điểm hệ số 1 #2	796	1	\N	2025-05-11 12:12:17.874692
4777	Điểm hệ số 1 #3	796	1	\N	2025-05-11 12:12:17.874692
4778	Điểm hệ số 2 #1	796	2	\N	2025-05-11 12:12:17.874692
4779	Điểm hệ số 2 #2	796	2	\N	2025-05-11 12:12:17.874692
4780	Điểm hệ số 3	796	3	\N	2025-05-11 12:12:17.874692
4781	Điểm hệ số 1 #1	797	1	\N	2025-05-11 12:12:17.874692
4782	Điểm hệ số 1 #2	797	1	\N	2025-05-11 12:12:17.874692
4783	Điểm hệ số 1 #3	797	1	\N	2025-05-11 12:12:17.874692
4784	Điểm hệ số 2 #1	797	2	\N	2025-05-11 12:12:17.874692
4785	Điểm hệ số 2 #2	797	2	\N	2025-05-11 12:12:17.874692
4786	Điểm hệ số 3	797	3	\N	2025-05-11 12:12:17.874692
4787	Điểm hệ số 1 #1	798	1	\N	2025-05-11 12:12:17.874692
4788	Điểm hệ số 1 #2	798	1	\N	2025-05-11 12:12:17.874692
4789	Điểm hệ số 1 #3	798	1	\N	2025-05-11 12:12:17.874692
4790	Điểm hệ số 2 #1	798	2	\N	2025-05-11 12:12:17.874692
4791	Điểm hệ số 2 #2	798	2	\N	2025-05-11 12:12:17.874692
4792	Điểm hệ số 3	798	3	\N	2025-05-11 12:12:17.874692
4793	Điểm hệ số 1 #1	799	1	\N	2025-05-11 12:12:17.874692
4794	Điểm hệ số 1 #2	799	1	\N	2025-05-11 12:12:17.874692
4795	Điểm hệ số 1 #3	799	1	\N	2025-05-11 12:12:17.874692
4796	Điểm hệ số 2 #1	799	2	\N	2025-05-11 12:12:17.874692
4797	Điểm hệ số 2 #2	799	2	\N	2025-05-11 12:12:17.874692
4798	Điểm hệ số 3	799	3	\N	2025-05-11 12:12:17.874692
4799	Điểm hệ số 1 #1	800	1	\N	2025-05-11 12:12:18.931535
4800	Điểm hệ số 1 #2	800	1	\N	2025-05-11 12:12:18.931535
4801	Điểm hệ số 1 #3	800	1	\N	2025-05-11 12:12:18.931535
4802	Điểm hệ số 2 #1	800	2	\N	2025-05-11 12:12:18.931535
4803	Điểm hệ số 2 #2	800	2	\N	2025-05-11 12:12:18.931535
4804	Điểm hệ số 3	800	3	\N	2025-05-11 12:12:18.931535
4805	Điểm hệ số 1 #1	801	1	\N	2025-05-11 12:12:18.931535
4806	Điểm hệ số 1 #2	801	1	\N	2025-05-11 12:12:18.931535
4807	Điểm hệ số 1 #3	801	1	\N	2025-05-11 12:12:18.931535
4808	Điểm hệ số 2 #1	801	2	\N	2025-05-11 12:12:18.931535
4809	Điểm hệ số 2 #2	801	2	\N	2025-05-11 12:12:18.931535
4810	Điểm hệ số 3	801	3	\N	2025-05-11 12:12:18.931535
4811	Điểm hệ số 1 #1	802	1	\N	2025-05-11 12:12:18.931535
4812	Điểm hệ số 1 #2	802	1	\N	2025-05-11 12:12:18.931535
4813	Điểm hệ số 1 #3	802	1	\N	2025-05-11 12:12:18.931535
4814	Điểm hệ số 2 #1	802	2	\N	2025-05-11 12:12:18.931535
4815	Điểm hệ số 2 #2	802	2	\N	2025-05-11 12:12:18.931535
4816	Điểm hệ số 3	802	3	\N	2025-05-11 12:12:18.931535
4817	Điểm hệ số 1 #1	803	1	\N	2025-05-11 12:12:18.931535
4818	Điểm hệ số 1 #2	803	1	\N	2025-05-11 12:12:18.931535
4819	Điểm hệ số 1 #3	803	1	\N	2025-05-11 12:12:18.931535
4820	Điểm hệ số 2 #1	803	2	\N	2025-05-11 12:12:18.931535
4821	Điểm hệ số 2 #2	803	2	\N	2025-05-11 12:12:18.931535
4822	Điểm hệ số 3	803	3	\N	2025-05-11 12:12:18.931535
4823	Điểm hệ số 1 #1	804	1	\N	2025-05-11 12:12:18.931535
4824	Điểm hệ số 1 #2	804	1	\N	2025-05-11 12:12:18.931535
4825	Điểm hệ số 1 #3	804	1	\N	2025-05-11 12:12:18.931535
4826	Điểm hệ số 2 #1	804	2	\N	2025-05-11 12:12:18.931535
4827	Điểm hệ số 2 #2	804	2	\N	2025-05-11 12:12:18.931535
4828	Điểm hệ số 3	804	3	\N	2025-05-11 12:12:18.931535
4829	Điểm hệ số 1 #1	805	1	\N	2025-05-11 12:12:18.931535
4830	Điểm hệ số 1 #2	805	1	\N	2025-05-11 12:12:18.931535
4831	Điểm hệ số 1 #3	805	1	\N	2025-05-11 12:12:18.931535
4832	Điểm hệ số 2 #1	805	2	\N	2025-05-11 12:12:18.931535
4833	Điểm hệ số 2 #2	805	2	\N	2025-05-11 12:12:18.931535
4834	Điểm hệ số 3	805	3	\N	2025-05-11 12:12:18.931535
4835	Điểm hệ số 1 #1	806	1	\N	2025-05-11 12:12:18.931535
4836	Điểm hệ số 1 #2	806	1	\N	2025-05-11 12:12:18.931535
4837	Điểm hệ số 1 #3	806	1	\N	2025-05-11 12:12:18.931535
4838	Điểm hệ số 2 #1	806	2	\N	2025-05-11 12:12:18.931535
4839	Điểm hệ số 2 #2	806	2	\N	2025-05-11 12:12:18.931535
4840	Điểm hệ số 3	806	3	\N	2025-05-11 12:12:18.931535
4841	Điểm hệ số 1 #1	807	1	\N	2025-05-11 12:12:18.931535
4842	Điểm hệ số 1 #2	807	1	\N	2025-05-11 12:12:18.931535
4843	Điểm hệ số 1 #3	807	1	\N	2025-05-11 12:12:18.931535
4844	Điểm hệ số 2 #1	807	2	\N	2025-05-11 12:12:18.931535
4845	Điểm hệ số 2 #2	807	2	\N	2025-05-11 12:12:18.931535
4846	Điểm hệ số 3	807	3	\N	2025-05-11 12:12:18.931535
4847	Điểm hệ số 1 #1	808	1	\N	2025-05-11 12:12:18.931535
4848	Điểm hệ số 1 #2	808	1	\N	2025-05-11 12:12:18.931535
4849	Điểm hệ số 1 #3	808	1	\N	2025-05-11 12:12:18.931535
4850	Điểm hệ số 2 #1	808	2	\N	2025-05-11 12:12:18.931535
4851	Điểm hệ số 2 #2	808	2	\N	2025-05-11 12:12:18.931535
4852	Điểm hệ số 3	808	3	\N	2025-05-11 12:12:18.931535
4853	Điểm hệ số 1 #1	809	1	\N	2025-05-11 12:12:18.931535
4854	Điểm hệ số 1 #2	809	1	\N	2025-05-11 12:12:18.931535
4855	Điểm hệ số 1 #3	809	1	\N	2025-05-11 12:12:18.931535
4856	Điểm hệ số 2 #1	809	2	\N	2025-05-11 12:12:18.931535
4857	Điểm hệ số 2 #2	809	2	\N	2025-05-11 12:12:18.931535
4858	Điểm hệ số 3	809	3	\N	2025-05-11 12:12:18.931535
4859	Điểm hệ số 1 #1	810	1	\N	2025-05-11 12:12:18.931535
4860	Điểm hệ số 1 #2	810	1	\N	2025-05-11 12:12:18.931535
4861	Điểm hệ số 1 #3	810	1	\N	2025-05-11 12:12:18.931535
4862	Điểm hệ số 2 #1	810	2	\N	2025-05-11 12:12:18.931535
4863	Điểm hệ số 2 #2	810	2	\N	2025-05-11 12:12:18.931535
4864	Điểm hệ số 3	810	3	\N	2025-05-11 12:12:18.931535
4865	Điểm hệ số 1 #1	811	1	\N	2025-05-11 12:12:18.931535
4866	Điểm hệ số 1 #2	811	1	\N	2025-05-11 12:12:18.931535
4867	Điểm hệ số 1 #3	811	1	\N	2025-05-11 12:12:18.931535
4868	Điểm hệ số 2 #1	811	2	\N	2025-05-11 12:12:18.931535
4869	Điểm hệ số 2 #2	811	2	\N	2025-05-11 12:12:18.931535
4870	Điểm hệ số 3	811	3	\N	2025-05-11 12:12:18.931535
4871	Điểm hệ số 1 #1	812	1	\N	2025-05-11 12:12:18.931535
4872	Điểm hệ số 1 #2	812	1	\N	2025-05-11 12:12:18.931535
4873	Điểm hệ số 1 #3	812	1	\N	2025-05-11 12:12:18.931535
4874	Điểm hệ số 2 #1	812	2	\N	2025-05-11 12:12:18.931535
4875	Điểm hệ số 2 #2	812	2	\N	2025-05-11 12:12:18.931535
4876	Điểm hệ số 3	812	3	\N	2025-05-11 12:12:18.931535
4877	Điểm hệ số 1 #1	813	1	\N	2025-05-11 12:12:18.931535
4878	Điểm hệ số 1 #2	813	1	\N	2025-05-11 12:12:18.931535
4879	Điểm hệ số 1 #3	813	1	\N	2025-05-11 12:12:18.931535
4880	Điểm hệ số 2 #1	813	2	\N	2025-05-11 12:12:18.931535
4881	Điểm hệ số 2 #2	813	2	\N	2025-05-11 12:12:18.931535
4882	Điểm hệ số 3	813	3	\N	2025-05-11 12:12:18.931535
4883	Điểm hệ số 1 #1	814	1	\N	2025-05-11 12:12:18.931535
4884	Điểm hệ số 1 #2	814	1	\N	2025-05-11 12:12:18.931535
4885	Điểm hệ số 1 #3	814	1	\N	2025-05-11 12:12:18.931535
4886	Điểm hệ số 2 #1	814	2	\N	2025-05-11 12:12:18.931535
4887	Điểm hệ số 2 #2	814	2	\N	2025-05-11 12:12:18.931535
4888	Điểm hệ số 3	814	3	\N	2025-05-11 12:12:18.931535
4889	Điểm hệ số 1 #1	815	1	\N	2025-05-11 12:12:18.931535
4890	Điểm hệ số 1 #2	815	1	\N	2025-05-11 12:12:18.931535
4891	Điểm hệ số 1 #3	815	1	\N	2025-05-11 12:12:18.931535
4892	Điểm hệ số 2 #1	815	2	\N	2025-05-11 12:12:18.931535
4893	Điểm hệ số 2 #2	815	2	\N	2025-05-11 12:12:18.931535
4894	Điểm hệ số 3	815	3	\N	2025-05-11 12:12:18.931535
4895	Điểm hệ số 1 #1	816	1	\N	2025-05-11 12:12:18.931535
4896	Điểm hệ số 1 #2	816	1	\N	2025-05-11 12:12:18.931535
4897	Điểm hệ số 1 #3	816	1	\N	2025-05-11 12:12:18.931535
4898	Điểm hệ số 2 #1	816	2	\N	2025-05-11 12:12:18.931535
4899	Điểm hệ số 2 #2	816	2	\N	2025-05-11 12:12:18.931535
4900	Điểm hệ số 3	816	3	\N	2025-05-11 12:12:18.931535
4901	Điểm hệ số 1 #1	817	1	\N	2025-05-11 12:12:18.931535
4902	Điểm hệ số 1 #2	817	1	\N	2025-05-11 12:12:18.931535
4903	Điểm hệ số 1 #3	817	1	\N	2025-05-11 12:12:18.931535
4904	Điểm hệ số 2 #1	817	2	\N	2025-05-11 12:12:18.931535
4905	Điểm hệ số 2 #2	817	2	\N	2025-05-11 12:12:18.931535
4906	Điểm hệ số 3	817	3	\N	2025-05-11 12:12:18.931535
4907	Điểm hệ số 1 #1	818	1	\N	2025-05-11 12:12:18.931535
4908	Điểm hệ số 1 #2	818	1	\N	2025-05-11 12:12:18.931535
4909	Điểm hệ số 1 #3	818	1	\N	2025-05-11 12:12:18.931535
4910	Điểm hệ số 2 #1	818	2	\N	2025-05-11 12:12:18.931535
4911	Điểm hệ số 2 #2	818	2	\N	2025-05-11 12:12:18.931535
4912	Điểm hệ số 3	818	3	\N	2025-05-11 12:12:18.931535
4913	Điểm hệ số 1 #1	819	1	\N	2025-05-11 12:12:18.931535
4914	Điểm hệ số 1 #2	819	1	\N	2025-05-11 12:12:18.931535
4915	Điểm hệ số 1 #3	819	1	\N	2025-05-11 12:12:18.931535
4916	Điểm hệ số 2 #1	819	2	\N	2025-05-11 12:12:18.931535
4917	Điểm hệ số 2 #2	819	2	\N	2025-05-11 12:12:18.931535
4918	Điểm hệ số 3	819	3	\N	2025-05-11 12:12:18.931535
4919	Điểm hệ số 1 #1	820	1	\N	2025-05-11 12:12:18.931535
4920	Điểm hệ số 1 #2	820	1	\N	2025-05-11 12:12:18.931535
4921	Điểm hệ số 1 #3	820	1	\N	2025-05-11 12:12:18.931535
4922	Điểm hệ số 2 #1	820	2	\N	2025-05-11 12:12:18.931535
4923	Điểm hệ số 2 #2	820	2	\N	2025-05-11 12:12:18.931535
4924	Điểm hệ số 3	820	3	\N	2025-05-11 12:12:18.931535
4925	Điểm hệ số 1 #1	821	1	\N	2025-05-11 12:12:18.931535
4926	Điểm hệ số 1 #2	821	1	\N	2025-05-11 12:12:18.931535
4927	Điểm hệ số 1 #3	821	1	\N	2025-05-11 12:12:18.931535
4928	Điểm hệ số 2 #1	821	2	\N	2025-05-11 12:12:18.931535
4929	Điểm hệ số 2 #2	821	2	\N	2025-05-11 12:12:18.931535
4930	Điểm hệ số 3	821	3	\N	2025-05-11 12:12:18.931535
4931	Điểm hệ số 1 #1	822	1	\N	2025-05-11 12:12:18.931535
4932	Điểm hệ số 1 #2	822	1	\N	2025-05-11 12:12:18.931535
4933	Điểm hệ số 1 #3	822	1	\N	2025-05-11 12:12:18.931535
4934	Điểm hệ số 2 #1	822	2	\N	2025-05-11 12:12:18.931535
4935	Điểm hệ số 2 #2	822	2	\N	2025-05-11 12:12:18.931535
4936	Điểm hệ số 3	822	3	\N	2025-05-11 12:12:18.931535
4937	Điểm hệ số 1 #1	823	1	\N	2025-05-11 12:12:18.931535
4938	Điểm hệ số 1 #2	823	1	\N	2025-05-11 12:12:18.931535
4939	Điểm hệ số 1 #3	823	1	\N	2025-05-11 12:12:18.931535
4940	Điểm hệ số 2 #1	823	2	\N	2025-05-11 12:12:18.931535
4941	Điểm hệ số 2 #2	823	2	\N	2025-05-11 12:12:18.931535
4942	Điểm hệ số 3	823	3	\N	2025-05-11 12:12:18.931535
4943	Điểm hệ số 1 #1	824	1	\N	2025-05-11 12:12:18.931535
4944	Điểm hệ số 1 #2	824	1	\N	2025-05-11 12:12:18.931535
4945	Điểm hệ số 1 #3	824	1	\N	2025-05-11 12:12:18.931535
4946	Điểm hệ số 2 #1	824	2	\N	2025-05-11 12:12:18.931535
4947	Điểm hệ số 2 #2	824	2	\N	2025-05-11 12:12:18.931535
4948	Điểm hệ số 3	824	3	\N	2025-05-11 12:12:18.931535
4949	Điểm hệ số 1 #1	825	1	\N	2025-05-11 12:12:18.931535
4950	Điểm hệ số 1 #2	825	1	\N	2025-05-11 12:12:18.931535
4951	Điểm hệ số 1 #3	825	1	\N	2025-05-11 12:12:18.932496
4952	Điểm hệ số 2 #1	825	2	\N	2025-05-11 12:12:18.932496
4953	Điểm hệ số 2 #2	825	2	\N	2025-05-11 12:12:18.932496
4954	Điểm hệ số 3	825	3	\N	2025-05-11 12:12:18.932496
4955	Điểm hệ số 1 #1	826	1	\N	2025-05-11 12:12:18.932496
4956	Điểm hệ số 1 #2	826	1	\N	2025-05-11 12:12:18.932496
4957	Điểm hệ số 1 #3	826	1	\N	2025-05-11 12:12:18.932496
4958	Điểm hệ số 2 #1	826	2	\N	2025-05-11 12:12:18.932496
4959	Điểm hệ số 2 #2	826	2	\N	2025-05-11 12:12:18.932496
4960	Điểm hệ số 3	826	3	\N	2025-05-11 12:12:18.932496
4961	Điểm hệ số 1 #1	827	1	\N	2025-05-11 12:12:18.932496
4962	Điểm hệ số 1 #2	827	1	\N	2025-05-11 12:12:18.932496
4963	Điểm hệ số 1 #3	827	1	\N	2025-05-11 12:12:18.932496
4964	Điểm hệ số 2 #1	827	2	\N	2025-05-11 12:12:18.932496
4965	Điểm hệ số 2 #2	827	2	\N	2025-05-11 12:12:18.932496
4966	Điểm hệ số 3	827	3	\N	2025-05-11 12:12:18.932496
4967	Điểm hệ số 1 #1	828	1	\N	2025-05-11 12:12:18.932496
4968	Điểm hệ số 1 #2	828	1	\N	2025-05-11 12:12:18.932496
4969	Điểm hệ số 1 #3	828	1	\N	2025-05-11 12:12:18.932496
4970	Điểm hệ số 2 #1	828	2	\N	2025-05-11 12:12:18.932496
4971	Điểm hệ số 2 #2	828	2	\N	2025-05-11 12:12:18.932496
4972	Điểm hệ số 3	828	3	\N	2025-05-11 12:12:18.932496
4973	Điểm hệ số 1 #1	829	1	\N	2025-05-11 12:12:18.932496
4974	Điểm hệ số 1 #2	829	1	\N	2025-05-11 12:12:18.932496
4975	Điểm hệ số 1 #3	829	1	\N	2025-05-11 12:12:18.932496
4976	Điểm hệ số 2 #1	829	2	\N	2025-05-11 12:12:18.932496
4977	Điểm hệ số 2 #2	829	2	\N	2025-05-11 12:12:18.932496
4978	Điểm hệ số 3	829	3	\N	2025-05-11 12:12:18.932496
4979	Điểm hệ số 1 #1	830	1	\N	2025-05-11 12:12:18.932496
4980	Điểm hệ số 1 #2	830	1	\N	2025-05-11 12:12:18.932496
4981	Điểm hệ số 1 #3	830	1	\N	2025-05-11 12:12:18.932496
4982	Điểm hệ số 2 #1	830	2	\N	2025-05-11 12:12:18.932496
4983	Điểm hệ số 2 #2	830	2	\N	2025-05-11 12:12:18.932496
4984	Điểm hệ số 3	830	3	\N	2025-05-11 12:12:18.932496
4985	Điểm hệ số 1 #1	831	1	\N	2025-05-11 12:12:18.932496
4986	Điểm hệ số 1 #2	831	1	\N	2025-05-11 12:12:18.932496
4987	Điểm hệ số 1 #3	831	1	\N	2025-05-11 12:12:18.932496
4988	Điểm hệ số 2 #1	831	2	\N	2025-05-11 12:12:18.932496
4989	Điểm hệ số 2 #2	831	2	\N	2025-05-11 12:12:18.932496
4990	Điểm hệ số 3	831	3	\N	2025-05-11 12:12:18.932496
4991	Điểm hệ số 1 #1	832	1	\N	2025-05-11 12:12:18.932496
4992	Điểm hệ số 1 #2	832	1	\N	2025-05-11 12:12:18.932496
4993	Điểm hệ số 1 #3	832	1	\N	2025-05-11 12:12:18.932496
4994	Điểm hệ số 2 #1	832	2	\N	2025-05-11 12:12:18.932496
4995	Điểm hệ số 2 #2	832	2	\N	2025-05-11 12:12:18.932496
4996	Điểm hệ số 3	832	3	\N	2025-05-11 12:12:18.932496
4997	Điểm hệ số 1 #1	833	1	\N	2025-05-11 12:12:18.932496
4998	Điểm hệ số 1 #2	833	1	\N	2025-05-11 12:12:18.932496
4999	Điểm hệ số 1 #3	833	1	\N	2025-05-11 12:12:18.932496
5000	Điểm hệ số 2 #1	833	2	\N	2025-05-11 12:12:18.932496
5001	Điểm hệ số 2 #2	833	2	\N	2025-05-11 12:12:18.932496
5002	Điểm hệ số 3	833	3	\N	2025-05-11 12:12:18.932496
5003	Điểm hệ số 1 #1	834	1	\N	2025-05-11 12:12:18.932496
5004	Điểm hệ số 1 #2	834	1	\N	2025-05-11 12:12:18.932496
5005	Điểm hệ số 1 #3	834	1	\N	2025-05-11 12:12:18.932496
5006	Điểm hệ số 2 #1	834	2	\N	2025-05-11 12:12:18.932496
5007	Điểm hệ số 2 #2	834	2	\N	2025-05-11 12:12:18.932496
5008	Điểm hệ số 3	834	3	\N	2025-05-11 12:12:18.932496
5009	Điểm hệ số 1 #1	835	1	\N	2025-05-11 12:12:18.932496
5010	Điểm hệ số 1 #2	835	1	\N	2025-05-11 12:12:18.932496
5011	Điểm hệ số 1 #3	835	1	\N	2025-05-11 12:12:18.932496
5012	Điểm hệ số 2 #1	835	2	\N	2025-05-11 12:12:18.932496
5013	Điểm hệ số 2 #2	835	2	\N	2025-05-11 12:12:18.932496
5014	Điểm hệ số 3	835	3	\N	2025-05-11 12:12:18.932496
5015	Điểm hệ số 1 #1	836	1	\N	2025-05-11 12:12:18.932496
5016	Điểm hệ số 1 #2	836	1	\N	2025-05-11 12:12:18.932496
5017	Điểm hệ số 1 #3	836	1	\N	2025-05-11 12:12:18.932496
5018	Điểm hệ số 2 #1	836	2	\N	2025-05-11 12:12:18.932496
5019	Điểm hệ số 2 #2	836	2	\N	2025-05-11 12:12:18.932496
5020	Điểm hệ số 3	836	3	\N	2025-05-11 12:12:18.932496
5021	Điểm hệ số 1 #1	837	1	\N	2025-05-11 12:12:18.932496
5022	Điểm hệ số 1 #2	837	1	\N	2025-05-11 12:12:18.932496
5023	Điểm hệ số 1 #3	837	1	\N	2025-05-11 12:12:18.932496
5024	Điểm hệ số 2 #1	837	2	\N	2025-05-11 12:12:18.932496
5025	Điểm hệ số 2 #2	837	2	\N	2025-05-11 12:12:18.932496
5026	Điểm hệ số 3	837	3	\N	2025-05-11 12:12:18.932496
5027	Điểm hệ số 1 #1	838	1	\N	2025-05-11 12:12:18.932496
5028	Điểm hệ số 1 #2	838	1	\N	2025-05-11 12:12:18.932496
5029	Điểm hệ số 1 #3	838	1	\N	2025-05-11 12:12:18.932496
5030	Điểm hệ số 2 #1	838	2	\N	2025-05-11 12:12:18.932496
5031	Điểm hệ số 2 #2	838	2	\N	2025-05-11 12:12:18.932496
5032	Điểm hệ số 3	838	3	\N	2025-05-11 12:12:18.932496
5033	Điểm hệ số 1 #1	839	1	\N	2025-05-11 12:12:18.932496
5034	Điểm hệ số 1 #2	839	1	\N	2025-05-11 12:12:18.932496
5035	Điểm hệ số 1 #3	839	1	\N	2025-05-11 12:12:18.932496
5036	Điểm hệ số 2 #1	839	2	\N	2025-05-11 12:12:18.932496
5037	Điểm hệ số 2 #2	839	2	\N	2025-05-11 12:12:18.932496
5038	Điểm hệ số 3	839	3	\N	2025-05-11 12:12:18.932496
5039	Điểm hệ số 1 #1	840	1	\N	2025-05-11 12:12:18.932496
5040	Điểm hệ số 1 #2	840	1	\N	2025-05-11 12:12:18.932496
5041	Điểm hệ số 1 #3	840	1	\N	2025-05-11 12:12:18.932496
5042	Điểm hệ số 2 #1	840	2	\N	2025-05-11 12:12:18.932496
5043	Điểm hệ số 2 #2	840	2	\N	2025-05-11 12:12:18.932496
5044	Điểm hệ số 3	840	3	\N	2025-05-11 12:12:18.932496
5045	Điểm hệ số 1 #1	841	1	\N	2025-05-11 12:12:18.932496
5046	Điểm hệ số 1 #2	841	1	\N	2025-05-11 12:12:18.932496
5047	Điểm hệ số 1 #3	841	1	\N	2025-05-11 12:12:18.932496
5048	Điểm hệ số 2 #1	841	2	\N	2025-05-11 12:12:18.932496
5049	Điểm hệ số 2 #2	841	2	\N	2025-05-11 12:12:18.932496
5050	Điểm hệ số 3	841	3	\N	2025-05-11 12:12:18.932496
5051	Điểm hệ số 1 #1	842	1	\N	2025-05-11 12:12:18.932496
5052	Điểm hệ số 1 #2	842	1	\N	2025-05-11 12:12:18.932496
5053	Điểm hệ số 1 #3	842	1	\N	2025-05-11 12:12:18.932496
5054	Điểm hệ số 2 #1	842	2	\N	2025-05-11 12:12:18.932496
5055	Điểm hệ số 2 #2	842	2	\N	2025-05-11 12:12:18.932496
5056	Điểm hệ số 3	842	3	\N	2025-05-11 12:12:18.932496
5057	Điểm hệ số 1 #1	843	1	\N	2025-05-11 12:12:18.932496
5058	Điểm hệ số 1 #2	843	1	\N	2025-05-11 12:12:18.932496
5059	Điểm hệ số 1 #3	843	1	\N	2025-05-11 12:12:18.932496
5060	Điểm hệ số 2 #1	843	2	\N	2025-05-11 12:12:18.932496
5061	Điểm hệ số 2 #2	843	2	\N	2025-05-11 12:12:18.932496
5062	Điểm hệ số 3	843	3	\N	2025-05-11 12:12:18.932496
5063	Điểm hệ số 1 #1	844	1	\N	2025-05-11 12:12:18.932496
5064	Điểm hệ số 1 #2	844	1	\N	2025-05-11 12:12:18.932496
5065	Điểm hệ số 1 #3	844	1	\N	2025-05-11 12:12:18.932496
5066	Điểm hệ số 2 #1	844	2	\N	2025-05-11 12:12:18.932496
5067	Điểm hệ số 2 #2	844	2	\N	2025-05-11 12:12:18.932496
5068	Điểm hệ số 3	844	3	\N	2025-05-11 12:12:18.932496
5069	Điểm hệ số 1 #1	845	1	\N	2025-05-11 12:12:18.932496
5070	Điểm hệ số 1 #2	845	1	\N	2025-05-11 12:12:18.932496
5071	Điểm hệ số 1 #3	845	1	\N	2025-05-11 12:12:18.932496
5072	Điểm hệ số 2 #1	845	2	\N	2025-05-11 12:12:18.932496
5073	Điểm hệ số 2 #2	845	2	\N	2025-05-11 12:12:18.932496
5074	Điểm hệ số 3	845	3	\N	2025-05-11 12:12:18.932496
5075	Điểm hệ số 1 #1	846	1	\N	2025-05-11 12:12:18.932496
5076	Điểm hệ số 1 #2	846	1	\N	2025-05-11 12:12:18.932496
5077	Điểm hệ số 1 #3	846	1	\N	2025-05-11 12:12:18.932496
5078	Điểm hệ số 2 #1	846	2	\N	2025-05-11 12:12:18.932496
5079	Điểm hệ số 2 #2	846	2	\N	2025-05-11 12:12:18.932496
5080	Điểm hệ số 3	846	3	\N	2025-05-11 12:12:18.932496
5081	Điểm hệ số 1 #1	847	1	\N	2025-05-11 12:12:18.932496
5082	Điểm hệ số 1 #2	847	1	\N	2025-05-11 12:12:18.932496
5083	Điểm hệ số 1 #3	847	1	\N	2025-05-11 12:12:18.932496
5084	Điểm hệ số 2 #1	847	2	\N	2025-05-11 12:12:18.932496
5085	Điểm hệ số 2 #2	847	2	\N	2025-05-11 12:12:18.932496
5086	Điểm hệ số 3	847	3	\N	2025-05-11 12:12:18.932496
5087	Điểm hệ số 1 #1	848	1	\N	2025-05-11 12:12:18.932496
5088	Điểm hệ số 1 #2	848	1	\N	2025-05-11 12:12:18.932496
5089	Điểm hệ số 1 #3	848	1	\N	2025-05-11 12:12:18.932496
5090	Điểm hệ số 2 #1	848	2	\N	2025-05-11 12:12:18.932496
5091	Điểm hệ số 2 #2	848	2	\N	2025-05-11 12:12:18.932496
5092	Điểm hệ số 3	848	3	\N	2025-05-11 12:12:18.932496
5093	Điểm hệ số 1 #1	849	1	\N	2025-05-11 12:12:18.932496
5094	Điểm hệ số 1 #2	849	1	\N	2025-05-11 12:12:18.932496
5095	Điểm hệ số 1 #3	849	1	\N	2025-05-11 12:12:18.932496
5096	Điểm hệ số 2 #1	849	2	\N	2025-05-11 12:12:18.932496
5097	Điểm hệ số 2 #2	849	2	\N	2025-05-11 12:12:18.932496
5098	Điểm hệ số 3	849	3	\N	2025-05-11 12:12:18.932496
5099	Điểm hệ số 1 #1	850	1	\N	2025-05-11 12:12:18.932496
5100	Điểm hệ số 1 #2	850	1	\N	2025-05-11 12:12:18.932496
5101	Điểm hệ số 1 #3	850	1	\N	2025-05-11 12:12:18.932496
5102	Điểm hệ số 2 #1	850	2	\N	2025-05-11 12:12:18.932496
5103	Điểm hệ số 2 #2	850	2	\N	2025-05-11 12:12:18.932496
5104	Điểm hệ số 3	850	3	\N	2025-05-11 12:12:18.932496
5105	Điểm hệ số 1 #1	851	1	\N	2025-05-11 12:12:18.932496
5106	Điểm hệ số 1 #2	851	1	\N	2025-05-11 12:12:18.932496
5107	Điểm hệ số 1 #3	851	1	\N	2025-05-11 12:12:18.932496
5108	Điểm hệ số 2 #1	851	2	\N	2025-05-11 12:12:18.932496
5109	Điểm hệ số 2 #2	851	2	\N	2025-05-11 12:12:18.932496
5110	Điểm hệ số 3	851	3	\N	2025-05-11 12:12:18.932496
5111	Điểm hệ số 1 #1	852	1	\N	2025-05-11 12:12:18.932496
5112	Điểm hệ số 1 #2	852	1	\N	2025-05-11 12:12:18.932496
5113	Điểm hệ số 1 #3	852	1	\N	2025-05-11 12:12:18.932496
5114	Điểm hệ số 2 #1	852	2	\N	2025-05-11 12:12:18.932496
5115	Điểm hệ số 2 #2	852	2	\N	2025-05-11 12:12:18.932496
5116	Điểm hệ số 3	852	3	\N	2025-05-11 12:12:18.932496
5117	Điểm hệ số 1 #1	853	1	\N	2025-05-11 12:12:18.932496
5118	Điểm hệ số 1 #2	853	1	\N	2025-05-11 12:12:18.932496
5119	Điểm hệ số 1 #3	853	1	\N	2025-05-11 12:12:18.932496
5120	Điểm hệ số 2 #1	853	2	\N	2025-05-11 12:12:18.932496
5121	Điểm hệ số 2 #2	853	2	\N	2025-05-11 12:12:18.932496
5122	Điểm hệ số 3	853	3	\N	2025-05-11 12:12:18.932496
5123	Điểm hệ số 1 #1	854	1	\N	2025-05-11 12:12:18.932496
5124	Điểm hệ số 1 #2	854	1	\N	2025-05-11 12:12:18.932496
5125	Điểm hệ số 1 #3	854	1	\N	2025-05-11 12:12:18.932496
5126	Điểm hệ số 2 #1	854	2	\N	2025-05-11 12:12:18.932496
5127	Điểm hệ số 2 #2	854	2	\N	2025-05-11 12:12:18.932496
5128	Điểm hệ số 3	854	3	\N	2025-05-11 12:12:18.932496
5129	Điểm hệ số 1 #1	855	1	\N	2025-05-11 12:12:18.932496
5130	Điểm hệ số 1 #2	855	1	\N	2025-05-11 12:12:18.932496
5131	Điểm hệ số 1 #3	855	1	\N	2025-05-11 12:12:18.932496
5132	Điểm hệ số 2 #1	855	2	\N	2025-05-11 12:12:18.932496
5133	Điểm hệ số 2 #2	855	2	\N	2025-05-11 12:12:18.932496
5134	Điểm hệ số 3	855	3	\N	2025-05-11 12:12:18.932496
5135	Điểm hệ số 1 #1	856	1	\N	2025-05-11 12:12:18.932496
5136	Điểm hệ số 1 #2	856	1	\N	2025-05-11 12:12:18.932496
5137	Điểm hệ số 1 #3	856	1	\N	2025-05-11 12:12:18.932496
5138	Điểm hệ số 2 #1	856	2	\N	2025-05-11 12:12:18.932496
5139	Điểm hệ số 2 #2	856	2	\N	2025-05-11 12:12:18.932496
5140	Điểm hệ số 3	856	3	\N	2025-05-11 12:12:18.932496
5141	Điểm hệ số 1 #1	857	1	\N	2025-05-11 12:12:18.932496
5142	Điểm hệ số 1 #2	857	1	\N	2025-05-11 12:12:18.932496
5143	Điểm hệ số 1 #3	857	1	\N	2025-05-11 12:12:18.932496
5144	Điểm hệ số 2 #1	857	2	\N	2025-05-11 12:12:18.932496
5145	Điểm hệ số 2 #2	857	2	\N	2025-05-11 12:12:18.932496
5146	Điểm hệ số 3	857	3	\N	2025-05-11 12:12:18.932496
5147	Điểm hệ số 1 #1	858	1	\N	2025-05-11 12:12:18.932496
5148	Điểm hệ số 1 #2	858	1	\N	2025-05-11 12:12:18.932496
5149	Điểm hệ số 1 #3	858	1	\N	2025-05-11 12:12:18.932496
5150	Điểm hệ số 2 #1	858	2	\N	2025-05-11 12:12:18.932496
5151	Điểm hệ số 2 #2	858	2	\N	2025-05-11 12:12:18.932496
5152	Điểm hệ số 3	858	3	\N	2025-05-11 12:12:18.932496
5153	Điểm hệ số 1 #1	859	1	\N	2025-05-11 12:12:18.932496
5154	Điểm hệ số 1 #2	859	1	\N	2025-05-11 12:12:18.932496
5155	Điểm hệ số 1 #3	859	1	\N	2025-05-11 12:12:18.932496
5156	Điểm hệ số 2 #1	859	2	\N	2025-05-11 12:12:18.932496
5157	Điểm hệ số 2 #2	859	2	\N	2025-05-11 12:12:18.932496
5158	Điểm hệ số 3	859	3	\N	2025-05-11 12:12:18.932496
5159	Điểm hệ số 1 #1	860	1	\N	2025-05-11 12:12:18.932496
5160	Điểm hệ số 1 #2	860	1	\N	2025-05-11 12:12:18.932496
5161	Điểm hệ số 1 #3	860	1	\N	2025-05-11 12:12:18.932496
5162	Điểm hệ số 2 #1	860	2	\N	2025-05-11 12:12:18.932496
5163	Điểm hệ số 2 #2	860	2	\N	2025-05-11 12:12:18.932496
5164	Điểm hệ số 3	860	3	\N	2025-05-11 12:12:18.932496
5165	Điểm hệ số 1 #1	861	1	\N	2025-05-11 12:12:18.932496
5166	Điểm hệ số 1 #2	861	1	\N	2025-05-11 12:12:18.932496
5167	Điểm hệ số 1 #3	861	1	\N	2025-05-11 12:12:18.932496
5168	Điểm hệ số 2 #1	861	2	\N	2025-05-11 12:12:18.932496
5169	Điểm hệ số 2 #2	861	2	\N	2025-05-11 12:12:18.932496
5170	Điểm hệ số 3	861	3	\N	2025-05-11 12:12:18.932496
5171	Điểm hệ số 1 #1	862	1	\N	2025-05-11 12:12:18.932496
5172	Điểm hệ số 1 #2	862	1	\N	2025-05-11 12:12:18.932496
5173	Điểm hệ số 1 #3	862	1	\N	2025-05-11 12:12:18.932496
5174	Điểm hệ số 2 #1	862	2	\N	2025-05-11 12:12:18.932496
5175	Điểm hệ số 2 #2	862	2	\N	2025-05-11 12:12:18.932496
5176	Điểm hệ số 3	862	3	\N	2025-05-11 12:12:18.932496
5177	Điểm hệ số 1 #1	863	1	\N	2025-05-11 12:12:18.932496
5178	Điểm hệ số 1 #2	863	1	\N	2025-05-11 12:12:18.932496
5179	Điểm hệ số 1 #3	863	1	\N	2025-05-11 12:12:18.932496
5180	Điểm hệ số 2 #1	863	2	\N	2025-05-11 12:12:18.932496
5181	Điểm hệ số 2 #2	863	2	\N	2025-05-11 12:12:18.932496
5182	Điểm hệ số 3	863	3	\N	2025-05-11 12:12:18.932496
5183	Điểm hệ số 1 #1	864	1	\N	2025-05-11 12:12:18.933517
5184	Điểm hệ số 1 #2	864	1	\N	2025-05-11 12:12:18.933517
5185	Điểm hệ số 1 #3	864	1	\N	2025-05-11 12:12:18.933517
5186	Điểm hệ số 2 #1	864	2	\N	2025-05-11 12:12:18.933517
5187	Điểm hệ số 2 #2	864	2	\N	2025-05-11 12:12:18.933517
5188	Điểm hệ số 3	864	3	\N	2025-05-11 12:12:18.933517
5189	Điểm hệ số 1 #1	865	1	\N	2025-05-11 12:12:18.933517
5190	Điểm hệ số 1 #2	865	1	\N	2025-05-11 12:12:18.933517
5191	Điểm hệ số 1 #3	865	1	\N	2025-05-11 12:12:18.933517
5192	Điểm hệ số 2 #1	865	2	\N	2025-05-11 12:12:18.933517
5193	Điểm hệ số 2 #2	865	2	\N	2025-05-11 12:12:18.933517
5194	Điểm hệ số 3	865	3	\N	2025-05-11 12:12:18.933517
5195	Điểm hệ số 1 #1	866	1	\N	2025-05-11 12:12:18.933517
5196	Điểm hệ số 1 #2	866	1	\N	2025-05-11 12:12:18.933517
5197	Điểm hệ số 1 #3	866	1	\N	2025-05-11 12:12:18.933517
5198	Điểm hệ số 2 #1	866	2	\N	2025-05-11 12:12:18.933517
5199	Điểm hệ số 2 #2	866	2	\N	2025-05-11 12:12:18.933517
5200	Điểm hệ số 3	866	3	\N	2025-05-11 12:12:18.933517
5201	Điểm hệ số 1 #1	867	1	\N	2025-05-11 12:12:18.933517
5202	Điểm hệ số 1 #2	867	1	\N	2025-05-11 12:12:18.933517
5203	Điểm hệ số 1 #3	867	1	\N	2025-05-11 12:12:18.933517
5204	Điểm hệ số 2 #1	867	2	\N	2025-05-11 12:12:18.933517
5205	Điểm hệ số 2 #2	867	2	\N	2025-05-11 12:12:18.933517
5206	Điểm hệ số 3	867	3	\N	2025-05-11 12:12:18.933517
5207	Điểm hệ số 1 #1	868	1	\N	2025-05-11 12:12:18.933517
5208	Điểm hệ số 1 #2	868	1	\N	2025-05-11 12:12:18.933517
5209	Điểm hệ số 1 #3	868	1	\N	2025-05-11 12:12:18.933517
5210	Điểm hệ số 2 #1	868	2	\N	2025-05-11 12:12:18.933517
5211	Điểm hệ số 2 #2	868	2	\N	2025-05-11 12:12:18.933517
5212	Điểm hệ số 3	868	3	\N	2025-05-11 12:12:18.933517
5213	Điểm hệ số 1 #1	869	1	\N	2025-05-11 12:12:18.933517
5214	Điểm hệ số 1 #2	869	1	\N	2025-05-11 12:12:18.933517
5215	Điểm hệ số 1 #3	869	1	\N	2025-05-11 12:12:18.933517
5216	Điểm hệ số 2 #1	869	2	\N	2025-05-11 12:12:18.933517
5217	Điểm hệ số 2 #2	869	2	\N	2025-05-11 12:12:18.933517
5218	Điểm hệ số 3	869	3	\N	2025-05-11 12:12:18.933517
5219	Điểm hệ số 1 #1	870	1	\N	2025-05-11 12:12:18.933517
5220	Điểm hệ số 1 #2	870	1	\N	2025-05-11 12:12:18.933517
5221	Điểm hệ số 1 #3	870	1	\N	2025-05-11 12:12:18.933517
5222	Điểm hệ số 2 #1	870	2	\N	2025-05-11 12:12:18.933517
5223	Điểm hệ số 2 #2	870	2	\N	2025-05-11 12:12:18.933517
5224	Điểm hệ số 3	870	3	\N	2025-05-11 12:12:18.933517
5225	Điểm hệ số 1 #1	871	1	\N	2025-05-11 12:12:18.933517
5226	Điểm hệ số 1 #2	871	1	\N	2025-05-11 12:12:18.933517
5227	Điểm hệ số 1 #3	871	1	\N	2025-05-11 12:12:18.933517
5228	Điểm hệ số 2 #1	871	2	\N	2025-05-11 12:12:18.933517
5229	Điểm hệ số 2 #2	871	2	\N	2025-05-11 12:12:18.933517
5230	Điểm hệ số 3	871	3	\N	2025-05-11 12:12:18.933517
5231	Điểm hệ số 1 #1	872	1	\N	2025-05-11 12:12:18.933517
5232	Điểm hệ số 1 #2	872	1	\N	2025-05-11 12:12:18.933517
5233	Điểm hệ số 1 #3	872	1	\N	2025-05-11 12:12:18.933517
5234	Điểm hệ số 2 #1	872	2	\N	2025-05-11 12:12:18.933517
5235	Điểm hệ số 2 #2	872	2	\N	2025-05-11 12:12:18.933517
5236	Điểm hệ số 3	872	3	\N	2025-05-11 12:12:18.933517
5237	Điểm hệ số 1 #1	873	1	\N	2025-05-11 12:12:18.933517
5238	Điểm hệ số 1 #2	873	1	\N	2025-05-11 12:12:18.933517
5239	Điểm hệ số 1 #3	873	1	\N	2025-05-11 12:12:18.933517
5240	Điểm hệ số 2 #1	873	2	\N	2025-05-11 12:12:18.933517
5241	Điểm hệ số 2 #2	873	2	\N	2025-05-11 12:12:18.933517
5242	Điểm hệ số 3	873	3	\N	2025-05-11 12:12:18.933517
5243	Điểm hệ số 1 #1	874	1	\N	2025-05-11 12:12:18.933517
5244	Điểm hệ số 1 #2	874	1	\N	2025-05-11 12:12:18.933517
5245	Điểm hệ số 1 #3	874	1	\N	2025-05-11 12:12:18.933517
5246	Điểm hệ số 2 #1	874	2	\N	2025-05-11 12:12:18.933517
5247	Điểm hệ số 2 #2	874	2	\N	2025-05-11 12:12:18.933517
5248	Điểm hệ số 3	874	3	\N	2025-05-11 12:12:18.933517
5249	Điểm hệ số 1 #1	875	1	\N	2025-05-11 12:12:18.933517
5250	Điểm hệ số 1 #2	875	1	\N	2025-05-11 12:12:18.933517
5251	Điểm hệ số 1 #3	875	1	\N	2025-05-11 12:12:18.933517
5252	Điểm hệ số 2 #1	875	2	\N	2025-05-11 12:12:18.933517
5253	Điểm hệ số 2 #2	875	2	\N	2025-05-11 12:12:18.933517
5254	Điểm hệ số 3	875	3	\N	2025-05-11 12:12:18.933517
5255	Điểm hệ số 1 #1	876	1	\N	2025-05-11 12:12:18.933517
5256	Điểm hệ số 1 #2	876	1	\N	2025-05-11 12:12:18.933517
5257	Điểm hệ số 1 #3	876	1	\N	2025-05-11 12:12:18.933517
5258	Điểm hệ số 2 #1	876	2	\N	2025-05-11 12:12:18.933517
5259	Điểm hệ số 2 #2	876	2	\N	2025-05-11 12:12:18.933517
5260	Điểm hệ số 3	876	3	\N	2025-05-11 12:12:18.933517
5261	Điểm hệ số 1 #1	877	1	\N	2025-05-11 12:12:18.933517
5262	Điểm hệ số 1 #2	877	1	\N	2025-05-11 12:12:18.933517
5263	Điểm hệ số 1 #3	877	1	\N	2025-05-11 12:12:18.933517
5264	Điểm hệ số 2 #1	877	2	\N	2025-05-11 12:12:18.933517
5265	Điểm hệ số 2 #2	877	2	\N	2025-05-11 12:12:18.933517
5266	Điểm hệ số 3	877	3	\N	2025-05-11 12:12:18.933517
5267	Điểm hệ số 1 #1	878	1	\N	2025-05-11 12:12:18.933517
5268	Điểm hệ số 1 #2	878	1	\N	2025-05-11 12:12:18.933517
5269	Điểm hệ số 1 #3	878	1	\N	2025-05-11 12:12:18.933517
5270	Điểm hệ số 2 #1	878	2	\N	2025-05-11 12:12:18.933517
5271	Điểm hệ số 2 #2	878	2	\N	2025-05-11 12:12:18.933517
5272	Điểm hệ số 3	878	3	\N	2025-05-11 12:12:18.933517
5273	Điểm hệ số 1 #1	879	1	\N	2025-05-11 12:12:18.933517
5274	Điểm hệ số 1 #2	879	1	\N	2025-05-11 12:12:18.933517
5275	Điểm hệ số 1 #3	879	1	\N	2025-05-11 12:12:18.933517
5276	Điểm hệ số 2 #1	879	2	\N	2025-05-11 12:12:18.933517
5277	Điểm hệ số 2 #2	879	2	\N	2025-05-11 12:12:18.933517
5278	Điểm hệ số 3	879	3	\N	2025-05-11 12:12:18.933517
5279	Điểm hệ số 1 #1	880	1	\N	2025-05-11 12:12:18.933517
5280	Điểm hệ số 1 #2	880	1	\N	2025-05-11 12:12:18.933517
5281	Điểm hệ số 1 #3	880	1	\N	2025-05-11 12:12:18.933517
5282	Điểm hệ số 2 #1	880	2	\N	2025-05-11 12:12:18.933517
5283	Điểm hệ số 2 #2	880	2	\N	2025-05-11 12:12:18.933517
5284	Điểm hệ số 3	880	3	\N	2025-05-11 12:12:18.933517
5285	Điểm hệ số 1 #1	881	1	\N	2025-05-11 12:12:18.933517
5286	Điểm hệ số 1 #2	881	1	\N	2025-05-11 12:12:18.933517
5287	Điểm hệ số 1 #3	881	1	\N	2025-05-11 12:12:18.933517
5288	Điểm hệ số 2 #1	881	2	\N	2025-05-11 12:12:18.933517
5289	Điểm hệ số 2 #2	881	2	\N	2025-05-11 12:12:18.933517
5290	Điểm hệ số 3	881	3	\N	2025-05-11 12:12:18.933517
5291	Điểm hệ số 1 #1	882	1	\N	2025-05-11 12:12:18.933517
5292	Điểm hệ số 1 #2	882	1	\N	2025-05-11 12:12:18.933517
5293	Điểm hệ số 1 #3	882	1	\N	2025-05-11 12:12:18.933517
5294	Điểm hệ số 2 #1	882	2	\N	2025-05-11 12:12:18.933517
5295	Điểm hệ số 2 #2	882	2	\N	2025-05-11 12:12:18.933517
5296	Điểm hệ số 3	882	3	\N	2025-05-11 12:12:18.933517
5297	Điểm hệ số 1 #1	883	1	\N	2025-05-11 12:12:18.933517
5298	Điểm hệ số 1 #2	883	1	\N	2025-05-11 12:12:18.933517
5299	Điểm hệ số 1 #3	883	1	\N	2025-05-11 12:12:18.933517
5300	Điểm hệ số 2 #1	883	2	\N	2025-05-11 12:12:18.933517
5301	Điểm hệ số 2 #2	883	2	\N	2025-05-11 12:12:18.933517
5302	Điểm hệ số 3	883	3	\N	2025-05-11 12:12:18.933517
5303	Điểm hệ số 1 #1	884	1	\N	2025-05-11 12:12:18.933517
5304	Điểm hệ số 1 #2	884	1	\N	2025-05-11 12:12:18.933517
5305	Điểm hệ số 1 #3	884	1	\N	2025-05-11 12:12:18.933517
5306	Điểm hệ số 2 #1	884	2	\N	2025-05-11 12:12:18.933517
5307	Điểm hệ số 2 #2	884	2	\N	2025-05-11 12:12:18.933517
5308	Điểm hệ số 3	884	3	\N	2025-05-11 12:12:18.933517
5309	Điểm hệ số 1 #1	885	1	\N	2025-05-11 12:12:18.933517
5310	Điểm hệ số 1 #2	885	1	\N	2025-05-11 12:12:18.933517
5311	Điểm hệ số 1 #3	885	1	\N	2025-05-11 12:12:18.933517
5312	Điểm hệ số 2 #1	885	2	\N	2025-05-11 12:12:18.933517
5313	Điểm hệ số 2 #2	885	2	\N	2025-05-11 12:12:18.933517
5314	Điểm hệ số 3	885	3	\N	2025-05-11 12:12:18.933517
5315	Điểm hệ số 1 #1	886	1	\N	2025-05-11 12:12:18.933517
5316	Điểm hệ số 1 #2	886	1	\N	2025-05-11 12:12:18.933517
5317	Điểm hệ số 1 #3	886	1	\N	2025-05-11 12:12:18.933517
5318	Điểm hệ số 2 #1	886	2	\N	2025-05-11 12:12:18.933517
5319	Điểm hệ số 2 #2	886	2	\N	2025-05-11 12:12:18.933517
5320	Điểm hệ số 3	886	3	\N	2025-05-11 12:12:18.933517
5321	Điểm hệ số 1 #1	887	1	\N	2025-05-11 12:12:18.933517
5322	Điểm hệ số 1 #2	887	1	\N	2025-05-11 12:12:18.933517
5323	Điểm hệ số 1 #3	887	1	\N	2025-05-11 12:12:18.933517
5324	Điểm hệ số 2 #1	887	2	\N	2025-05-11 12:12:18.933517
5325	Điểm hệ số 2 #2	887	2	\N	2025-05-11 12:12:18.933517
5326	Điểm hệ số 3	887	3	\N	2025-05-11 12:12:18.933517
5327	Điểm hệ số 1 #1	888	1	\N	2025-05-11 12:12:18.933517
5328	Điểm hệ số 1 #2	888	1	\N	2025-05-11 12:12:18.933517
5329	Điểm hệ số 1 #3	888	1	\N	2025-05-11 12:12:18.933517
5330	Điểm hệ số 2 #1	888	2	\N	2025-05-11 12:12:18.933517
5331	Điểm hệ số 2 #2	888	2	\N	2025-05-11 12:12:18.933517
5332	Điểm hệ số 3	888	3	\N	2025-05-11 12:12:18.933517
5333	Điểm hệ số 1 #1	889	1	\N	2025-05-11 12:12:18.933517
5334	Điểm hệ số 1 #2	889	1	\N	2025-05-11 12:12:18.933517
5335	Điểm hệ số 1 #3	889	1	\N	2025-05-11 12:12:18.933517
5336	Điểm hệ số 2 #1	889	2	\N	2025-05-11 12:12:18.933517
5337	Điểm hệ số 2 #2	889	2	\N	2025-05-11 12:12:18.933517
5338	Điểm hệ số 3	889	3	\N	2025-05-11 12:12:18.933517
5339	Điểm hệ số 1 #1	890	1	\N	2025-05-11 12:12:18.933517
5340	Điểm hệ số 1 #2	890	1	\N	2025-05-11 12:12:18.933517
5341	Điểm hệ số 1 #3	890	1	\N	2025-05-11 12:12:18.933517
5342	Điểm hệ số 2 #1	890	2	\N	2025-05-11 12:12:18.933517
5343	Điểm hệ số 2 #2	890	2	\N	2025-05-11 12:12:18.933517
5344	Điểm hệ số 3	890	3	\N	2025-05-11 12:12:18.933517
5345	Điểm hệ số 1 #1	891	1	\N	2025-05-11 12:12:18.933517
5346	Điểm hệ số 1 #2	891	1	\N	2025-05-11 12:12:18.933517
5347	Điểm hệ số 1 #3	891	1	\N	2025-05-11 12:12:18.933517
5348	Điểm hệ số 2 #1	891	2	\N	2025-05-11 12:12:18.933517
5349	Điểm hệ số 2 #2	891	2	\N	2025-05-11 12:12:18.933517
5350	Điểm hệ số 3	891	3	\N	2025-05-11 12:12:18.933517
5351	Điểm hệ số 1 #1	892	1	\N	2025-05-11 12:12:19.929432
5352	Điểm hệ số 1 #2	892	1	\N	2025-05-11 12:12:19.929432
5353	Điểm hệ số 1 #3	892	1	\N	2025-05-11 12:12:19.929432
5354	Điểm hệ số 2 #1	892	2	\N	2025-05-11 12:12:19.929432
5355	Điểm hệ số 2 #2	892	2	\N	2025-05-11 12:12:19.929432
5356	Điểm hệ số 3	892	3	\N	2025-05-11 12:12:19.929432
5357	Điểm hệ số 1 #1	893	1	\N	2025-05-11 12:12:19.929432
5358	Điểm hệ số 1 #2	893	1	\N	2025-05-11 12:12:19.929432
5359	Điểm hệ số 1 #3	893	1	\N	2025-05-11 12:12:19.929432
5360	Điểm hệ số 2 #1	893	2	\N	2025-05-11 12:12:19.929432
5361	Điểm hệ số 2 #2	893	2	\N	2025-05-11 12:12:19.929432
5362	Điểm hệ số 3	893	3	\N	2025-05-11 12:12:19.929432
5363	Điểm hệ số 1 #1	894	1	\N	2025-05-11 12:12:19.929432
5364	Điểm hệ số 1 #2	894	1	\N	2025-05-11 12:12:19.929432
5365	Điểm hệ số 1 #3	894	1	\N	2025-05-11 12:12:19.929432
5366	Điểm hệ số 2 #1	894	2	\N	2025-05-11 12:12:19.929432
5367	Điểm hệ số 2 #2	894	2	\N	2025-05-11 12:12:19.929432
5368	Điểm hệ số 3	894	3	\N	2025-05-11 12:12:19.929432
5369	Điểm hệ số 1 #1	895	1	\N	2025-05-11 12:12:19.929432
5370	Điểm hệ số 1 #2	895	1	\N	2025-05-11 12:12:19.929432
5371	Điểm hệ số 1 #3	895	1	\N	2025-05-11 12:12:19.929432
5372	Điểm hệ số 2 #1	895	2	\N	2025-05-11 12:12:19.929432
5373	Điểm hệ số 2 #2	895	2	\N	2025-05-11 12:12:19.929432
5374	Điểm hệ số 3	895	3	\N	2025-05-11 12:12:19.929432
5375	Điểm hệ số 1 #1	896	1	\N	2025-05-11 12:12:19.929432
5376	Điểm hệ số 1 #2	896	1	\N	2025-05-11 12:12:19.929432
5377	Điểm hệ số 1 #3	896	1	\N	2025-05-11 12:12:19.929432
5378	Điểm hệ số 2 #1	896	2	\N	2025-05-11 12:12:19.929432
5379	Điểm hệ số 2 #2	896	2	\N	2025-05-11 12:12:19.929432
5380	Điểm hệ số 3	896	3	\N	2025-05-11 12:12:19.929432
5381	Điểm hệ số 1 #1	897	1	\N	2025-05-11 12:12:19.929432
5382	Điểm hệ số 1 #2	897	1	\N	2025-05-11 12:12:19.929432
5383	Điểm hệ số 1 #3	897	1	\N	2025-05-11 12:12:19.929432
5384	Điểm hệ số 2 #1	897	2	\N	2025-05-11 12:12:19.929432
5385	Điểm hệ số 2 #2	897	2	\N	2025-05-11 12:12:19.929432
5386	Điểm hệ số 3	897	3	\N	2025-05-11 12:12:19.929432
5387	Điểm hệ số 1 #1	898	1	\N	2025-05-11 12:12:19.929432
5388	Điểm hệ số 1 #2	898	1	\N	2025-05-11 12:12:19.929432
5389	Điểm hệ số 1 #3	898	1	\N	2025-05-11 12:12:19.929432
5390	Điểm hệ số 2 #1	898	2	\N	2025-05-11 12:12:19.929432
5391	Điểm hệ số 2 #2	898	2	\N	2025-05-11 12:12:19.929432
5392	Điểm hệ số 3	898	3	\N	2025-05-11 12:12:19.929432
5393	Điểm hệ số 1 #1	899	1	\N	2025-05-11 12:12:19.929432
5394	Điểm hệ số 1 #2	899	1	\N	2025-05-11 12:12:19.929432
5395	Điểm hệ số 1 #3	899	1	\N	2025-05-11 12:12:19.929432
5396	Điểm hệ số 2 #1	899	2	\N	2025-05-11 12:12:19.929432
5397	Điểm hệ số 2 #2	899	2	\N	2025-05-11 12:12:19.929432
5398	Điểm hệ số 3	899	3	\N	2025-05-11 12:12:19.929432
5399	Điểm hệ số 1 #1	900	1	\N	2025-05-11 12:12:19.929432
5400	Điểm hệ số 1 #2	900	1	\N	2025-05-11 12:12:19.929432
5401	Điểm hệ số 1 #3	900	1	\N	2025-05-11 12:12:19.929432
5402	Điểm hệ số 2 #1	900	2	\N	2025-05-11 12:12:19.929432
5403	Điểm hệ số 2 #2	900	2	\N	2025-05-11 12:12:19.929432
5404	Điểm hệ số 3	900	3	\N	2025-05-11 12:12:19.929432
5405	Điểm hệ số 1 #1	901	1	\N	2025-05-11 12:12:19.929432
5406	Điểm hệ số 1 #2	901	1	\N	2025-05-11 12:12:19.929432
5407	Điểm hệ số 1 #3	901	1	\N	2025-05-11 12:12:19.929432
5408	Điểm hệ số 2 #1	901	2	\N	2025-05-11 12:12:19.929432
5409	Điểm hệ số 2 #2	901	2	\N	2025-05-11 12:12:19.929432
5410	Điểm hệ số 3	901	3	\N	2025-05-11 12:12:19.929432
5411	Điểm hệ số 1 #1	902	1	\N	2025-05-11 12:12:19.929432
5412	Điểm hệ số 1 #2	902	1	\N	2025-05-11 12:12:19.929432
5413	Điểm hệ số 1 #3	902	1	\N	2025-05-11 12:12:19.929432
5414	Điểm hệ số 2 #1	902	2	\N	2025-05-11 12:12:19.929432
5415	Điểm hệ số 2 #2	902	2	\N	2025-05-11 12:12:19.929432
5416	Điểm hệ số 3	902	3	\N	2025-05-11 12:12:19.929432
5417	Điểm hệ số 1 #1	903	1	\N	2025-05-11 12:12:19.929432
5418	Điểm hệ số 1 #2	903	1	\N	2025-05-11 12:12:19.929432
5419	Điểm hệ số 1 #3	903	1	\N	2025-05-11 12:12:19.929432
5420	Điểm hệ số 2 #1	903	2	\N	2025-05-11 12:12:19.929432
5421	Điểm hệ số 2 #2	903	2	\N	2025-05-11 12:12:19.929432
5422	Điểm hệ số 3	903	3	\N	2025-05-11 12:12:19.929432
5423	Điểm hệ số 1 #1	904	1	\N	2025-05-11 12:12:19.929432
5424	Điểm hệ số 1 #2	904	1	\N	2025-05-11 12:12:19.929432
5425	Điểm hệ số 1 #3	904	1	\N	2025-05-11 12:12:19.929432
5426	Điểm hệ số 2 #1	904	2	\N	2025-05-11 12:12:19.929432
5427	Điểm hệ số 2 #2	904	2	\N	2025-05-11 12:12:19.929432
5428	Điểm hệ số 3	904	3	\N	2025-05-11 12:12:19.929432
5429	Điểm hệ số 1 #1	905	1	\N	2025-05-11 12:12:19.929432
5430	Điểm hệ số 1 #2	905	1	\N	2025-05-11 12:12:19.929432
5431	Điểm hệ số 1 #3	905	1	\N	2025-05-11 12:12:19.929432
5432	Điểm hệ số 2 #1	905	2	\N	2025-05-11 12:12:19.929432
5433	Điểm hệ số 2 #2	905	2	\N	2025-05-11 12:12:19.929432
5434	Điểm hệ số 3	905	3	\N	2025-05-11 12:12:19.929432
5435	Điểm hệ số 1 #1	906	1	\N	2025-05-11 12:12:19.929432
5436	Điểm hệ số 1 #2	906	1	\N	2025-05-11 12:12:19.929432
5437	Điểm hệ số 1 #3	906	1	\N	2025-05-11 12:12:19.929432
5438	Điểm hệ số 2 #1	906	2	\N	2025-05-11 12:12:19.929432
5439	Điểm hệ số 2 #2	906	2	\N	2025-05-11 12:12:19.929432
5440	Điểm hệ số 3	906	3	\N	2025-05-11 12:12:19.929432
5441	Điểm hệ số 1 #1	907	1	\N	2025-05-11 12:12:19.929432
5442	Điểm hệ số 1 #2	907	1	\N	2025-05-11 12:12:19.929432
5443	Điểm hệ số 1 #3	907	1	\N	2025-05-11 12:12:19.929432
5444	Điểm hệ số 2 #1	907	2	\N	2025-05-11 12:12:19.929432
5445	Điểm hệ số 2 #2	907	2	\N	2025-05-11 12:12:19.929432
5446	Điểm hệ số 3	907	3	\N	2025-05-11 12:12:19.929432
5447	Điểm hệ số 1 #1	908	1	\N	2025-05-11 12:12:19.929432
5448	Điểm hệ số 1 #2	908	1	\N	2025-05-11 12:12:19.929432
5449	Điểm hệ số 1 #3	908	1	\N	2025-05-11 12:12:19.929432
5450	Điểm hệ số 2 #1	908	2	\N	2025-05-11 12:12:19.929432
5451	Điểm hệ số 2 #2	908	2	\N	2025-05-11 12:12:19.929432
5452	Điểm hệ số 3	908	3	\N	2025-05-11 12:12:19.929432
5453	Điểm hệ số 1 #1	909	1	\N	2025-05-11 12:12:19.929432
5454	Điểm hệ số 1 #2	909	1	\N	2025-05-11 12:12:19.929432
5455	Điểm hệ số 1 #3	909	1	\N	2025-05-11 12:12:19.929432
5456	Điểm hệ số 2 #1	909	2	\N	2025-05-11 12:12:19.929432
5457	Điểm hệ số 2 #2	909	2	\N	2025-05-11 12:12:19.929432
5458	Điểm hệ số 3	909	3	\N	2025-05-11 12:12:19.929432
5459	Điểm hệ số 1 #1	910	1	\N	2025-05-11 12:12:19.929432
5460	Điểm hệ số 1 #2	910	1	\N	2025-05-11 12:12:19.929432
5461	Điểm hệ số 1 #3	910	1	\N	2025-05-11 12:12:19.929432
5462	Điểm hệ số 2 #1	910	2	\N	2025-05-11 12:12:19.929432
5463	Điểm hệ số 2 #2	910	2	\N	2025-05-11 12:12:19.929432
5464	Điểm hệ số 3	910	3	\N	2025-05-11 12:12:19.929432
5465	Điểm hệ số 1 #1	911	1	\N	2025-05-11 12:12:19.929432
5466	Điểm hệ số 1 #2	911	1	\N	2025-05-11 12:12:19.929432
5467	Điểm hệ số 1 #3	911	1	\N	2025-05-11 12:12:19.929432
5468	Điểm hệ số 2 #1	911	2	\N	2025-05-11 12:12:19.929432
5469	Điểm hệ số 2 #2	911	2	\N	2025-05-11 12:12:19.929432
5470	Điểm hệ số 3	911	3	\N	2025-05-11 12:12:19.929432
5471	Điểm hệ số 1 #1	912	1	\N	2025-05-11 12:12:19.929432
5472	Điểm hệ số 1 #2	912	1	\N	2025-05-11 12:12:19.929432
5473	Điểm hệ số 1 #3	912	1	\N	2025-05-11 12:12:19.930433
5474	Điểm hệ số 2 #1	912	2	\N	2025-05-11 12:12:19.930433
5475	Điểm hệ số 2 #2	912	2	\N	2025-05-11 12:12:19.930433
5476	Điểm hệ số 3	912	3	\N	2025-05-11 12:12:19.930433
5477	Điểm hệ số 1 #1	913	1	\N	2025-05-11 12:12:19.930433
5478	Điểm hệ số 1 #2	913	1	\N	2025-05-11 12:12:19.930433
5479	Điểm hệ số 1 #3	913	1	\N	2025-05-11 12:12:19.930433
5480	Điểm hệ số 2 #1	913	2	\N	2025-05-11 12:12:19.930433
5481	Điểm hệ số 2 #2	913	2	\N	2025-05-11 12:12:19.930433
5482	Điểm hệ số 3	913	3	\N	2025-05-11 12:12:19.930433
5483	Điểm hệ số 1 #1	914	1	\N	2025-05-11 12:12:19.930433
5484	Điểm hệ số 1 #2	914	1	\N	2025-05-11 12:12:19.930433
5485	Điểm hệ số 1 #3	914	1	\N	2025-05-11 12:12:19.930433
5486	Điểm hệ số 2 #1	914	2	\N	2025-05-11 12:12:19.930433
5487	Điểm hệ số 2 #2	914	2	\N	2025-05-11 12:12:19.930433
5488	Điểm hệ số 3	914	3	\N	2025-05-11 12:12:19.930433
5489	Điểm hệ số 1 #1	915	1	\N	2025-05-11 12:12:19.930433
5490	Điểm hệ số 1 #2	915	1	\N	2025-05-11 12:12:19.930433
5491	Điểm hệ số 1 #3	915	1	\N	2025-05-11 12:12:19.930433
5492	Điểm hệ số 2 #1	915	2	\N	2025-05-11 12:12:19.930433
5493	Điểm hệ số 2 #2	915	2	\N	2025-05-11 12:12:19.930433
5494	Điểm hệ số 3	915	3	\N	2025-05-11 12:12:19.930433
5495	Điểm hệ số 1 #1	916	1	\N	2025-05-11 12:12:19.930433
5496	Điểm hệ số 1 #2	916	1	\N	2025-05-11 12:12:19.930433
5497	Điểm hệ số 1 #3	916	1	\N	2025-05-11 12:12:19.930433
5498	Điểm hệ số 2 #1	916	2	\N	2025-05-11 12:12:19.930433
5499	Điểm hệ số 2 #2	916	2	\N	2025-05-11 12:12:19.930433
5500	Điểm hệ số 3	916	3	\N	2025-05-11 12:12:19.930433
5501	Điểm hệ số 1 #1	917	1	\N	2025-05-11 12:12:19.930433
5502	Điểm hệ số 1 #2	917	1	\N	2025-05-11 12:12:19.930433
5503	Điểm hệ số 1 #3	917	1	\N	2025-05-11 12:12:19.930433
5504	Điểm hệ số 2 #1	917	2	\N	2025-05-11 12:12:19.930433
5505	Điểm hệ số 2 #2	917	2	\N	2025-05-11 12:12:19.930433
5506	Điểm hệ số 3	917	3	\N	2025-05-11 12:12:19.930433
5507	Điểm hệ số 1 #1	918	1	\N	2025-05-11 12:12:19.930433
5508	Điểm hệ số 1 #2	918	1	\N	2025-05-11 12:12:19.930433
5509	Điểm hệ số 1 #3	918	1	\N	2025-05-11 12:12:19.930433
5510	Điểm hệ số 2 #1	918	2	\N	2025-05-11 12:12:19.930433
5511	Điểm hệ số 2 #2	918	2	\N	2025-05-11 12:12:19.930433
5512	Điểm hệ số 3	918	3	\N	2025-05-11 12:12:19.930433
5513	Điểm hệ số 1 #1	919	1	\N	2025-05-11 12:12:19.930433
5514	Điểm hệ số 1 #2	919	1	\N	2025-05-11 12:12:19.930433
5515	Điểm hệ số 1 #3	919	1	\N	2025-05-11 12:12:19.930433
5516	Điểm hệ số 2 #1	919	2	\N	2025-05-11 12:12:19.930433
5517	Điểm hệ số 2 #2	919	2	\N	2025-05-11 12:12:19.930433
5518	Điểm hệ số 3	919	3	\N	2025-05-11 12:12:19.930433
5519	Điểm hệ số 1 #1	920	1	\N	2025-05-11 12:12:19.930433
5520	Điểm hệ số 1 #2	920	1	\N	2025-05-11 12:12:19.930433
5521	Điểm hệ số 1 #3	920	1	\N	2025-05-11 12:12:19.930433
5522	Điểm hệ số 2 #1	920	2	\N	2025-05-11 12:12:19.930433
5523	Điểm hệ số 2 #2	920	2	\N	2025-05-11 12:12:19.930433
5524	Điểm hệ số 3	920	3	\N	2025-05-11 12:12:19.930433
5525	Điểm hệ số 1 #1	921	1	\N	2025-05-11 12:12:19.930433
5526	Điểm hệ số 1 #2	921	1	\N	2025-05-11 12:12:19.930433
5527	Điểm hệ số 1 #3	921	1	\N	2025-05-11 12:12:19.930433
5528	Điểm hệ số 2 #1	921	2	\N	2025-05-11 12:12:19.930433
5529	Điểm hệ số 2 #2	921	2	\N	2025-05-11 12:12:19.930433
5530	Điểm hệ số 3	921	3	\N	2025-05-11 12:12:19.930433
5531	Điểm hệ số 1 #1	922	1	\N	2025-05-11 12:12:19.930433
5532	Điểm hệ số 1 #2	922	1	\N	2025-05-11 12:12:19.930433
5533	Điểm hệ số 1 #3	922	1	\N	2025-05-11 12:12:19.930433
5534	Điểm hệ số 2 #1	922	2	\N	2025-05-11 12:12:19.930433
5535	Điểm hệ số 2 #2	922	2	\N	2025-05-11 12:12:19.930433
5536	Điểm hệ số 3	922	3	\N	2025-05-11 12:12:19.930433
5537	Điểm hệ số 1 #1	923	1	\N	2025-05-11 12:12:19.930433
5538	Điểm hệ số 1 #2	923	1	\N	2025-05-11 12:12:19.930433
5539	Điểm hệ số 1 #3	923	1	\N	2025-05-11 12:12:19.930433
5540	Điểm hệ số 2 #1	923	2	\N	2025-05-11 12:12:19.930433
5541	Điểm hệ số 2 #2	923	2	\N	2025-05-11 12:12:19.930433
5542	Điểm hệ số 3	923	3	\N	2025-05-11 12:12:19.930433
5543	Điểm hệ số 1 #1	924	1	\N	2025-05-11 12:12:19.930433
5544	Điểm hệ số 1 #2	924	1	\N	2025-05-11 12:12:19.930433
5545	Điểm hệ số 1 #3	924	1	\N	2025-05-11 12:12:19.930433
5546	Điểm hệ số 2 #1	924	2	\N	2025-05-11 12:12:19.930433
5547	Điểm hệ số 2 #2	924	2	\N	2025-05-11 12:12:19.930433
5548	Điểm hệ số 3	924	3	\N	2025-05-11 12:12:19.930433
5549	Điểm hệ số 1 #1	925	1	\N	2025-05-11 12:12:19.930433
5550	Điểm hệ số 1 #2	925	1	\N	2025-05-11 12:12:19.930433
5551	Điểm hệ số 1 #3	925	1	\N	2025-05-11 12:12:19.930433
5552	Điểm hệ số 2 #1	925	2	\N	2025-05-11 12:12:19.930433
5553	Điểm hệ số 2 #2	925	2	\N	2025-05-11 12:12:19.930433
5554	Điểm hệ số 3	925	3	\N	2025-05-11 12:12:19.930433
5555	Điểm hệ số 1 #1	926	1	\N	2025-05-11 12:12:19.930433
5556	Điểm hệ số 1 #2	926	1	\N	2025-05-11 12:12:19.930433
5557	Điểm hệ số 1 #3	926	1	\N	2025-05-11 12:12:19.930433
5558	Điểm hệ số 2 #1	926	2	\N	2025-05-11 12:12:19.930433
5559	Điểm hệ số 2 #2	926	2	\N	2025-05-11 12:12:19.930433
5560	Điểm hệ số 3	926	3	\N	2025-05-11 12:12:19.930433
5561	Điểm hệ số 1 #1	927	1	\N	2025-05-11 12:12:19.930433
5562	Điểm hệ số 1 #2	927	1	\N	2025-05-11 12:12:19.930433
5563	Điểm hệ số 1 #3	927	1	\N	2025-05-11 12:12:19.930433
5564	Điểm hệ số 2 #1	927	2	\N	2025-05-11 12:12:19.930433
5565	Điểm hệ số 2 #2	927	2	\N	2025-05-11 12:12:19.930433
5566	Điểm hệ số 3	927	3	\N	2025-05-11 12:12:19.930433
5567	Điểm hệ số 1 #1	928	1	\N	2025-05-11 12:12:19.930433
5568	Điểm hệ số 1 #2	928	1	\N	2025-05-11 12:12:19.930433
5569	Điểm hệ số 1 #3	928	1	\N	2025-05-11 12:12:19.930433
5570	Điểm hệ số 2 #1	928	2	\N	2025-05-11 12:12:19.930433
5571	Điểm hệ số 2 #2	928	2	\N	2025-05-11 12:12:19.930433
5572	Điểm hệ số 3	928	3	\N	2025-05-11 12:12:19.930433
5573	Điểm hệ số 1 #1	929	1	\N	2025-05-11 12:12:19.930433
5574	Điểm hệ số 1 #2	929	1	\N	2025-05-11 12:12:19.930433
5575	Điểm hệ số 1 #3	929	1	\N	2025-05-11 12:12:19.930433
5576	Điểm hệ số 2 #1	929	2	\N	2025-05-11 12:12:19.930433
5577	Điểm hệ số 2 #2	929	2	\N	2025-05-11 12:12:19.930433
5578	Điểm hệ số 3	929	3	\N	2025-05-11 12:12:19.930433
5579	Điểm hệ số 1 #1	930	1	\N	2025-05-11 12:12:19.930433
5580	Điểm hệ số 1 #2	930	1	\N	2025-05-11 12:12:19.930433
5581	Điểm hệ số 1 #3	930	1	\N	2025-05-11 12:12:19.930433
5582	Điểm hệ số 2 #1	930	2	\N	2025-05-11 12:12:19.930433
5583	Điểm hệ số 2 #2	930	2	\N	2025-05-11 12:12:19.930433
5584	Điểm hệ số 3	930	3	\N	2025-05-11 12:12:19.930433
5585	Điểm hệ số 1 #1	931	1	\N	2025-05-11 12:12:19.930433
5586	Điểm hệ số 1 #2	931	1	\N	2025-05-11 12:12:19.930433
5587	Điểm hệ số 1 #3	931	1	\N	2025-05-11 12:12:19.930433
5588	Điểm hệ số 2 #1	931	2	\N	2025-05-11 12:12:19.930433
5589	Điểm hệ số 2 #2	931	2	\N	2025-05-11 12:12:19.930433
5590	Điểm hệ số 3	931	3	\N	2025-05-11 12:12:19.930433
5591	Điểm hệ số 1 #1	932	1	\N	2025-05-11 12:12:19.930433
5592	Điểm hệ số 1 #2	932	1	\N	2025-05-11 12:12:19.930433
5593	Điểm hệ số 1 #3	932	1	\N	2025-05-11 12:12:19.930433
5594	Điểm hệ số 2 #1	932	2	\N	2025-05-11 12:12:19.930433
5595	Điểm hệ số 2 #2	932	2	\N	2025-05-11 12:12:19.930433
5596	Điểm hệ số 3	932	3	\N	2025-05-11 12:12:19.930433
5597	Điểm hệ số 1 #1	933	1	\N	2025-05-11 12:12:19.930433
5598	Điểm hệ số 1 #2	933	1	\N	2025-05-11 12:12:19.930433
5599	Điểm hệ số 1 #3	933	1	\N	2025-05-11 12:12:19.930433
5600	Điểm hệ số 2 #1	933	2	\N	2025-05-11 12:12:19.930433
5601	Điểm hệ số 2 #2	933	2	\N	2025-05-11 12:12:19.930433
5602	Điểm hệ số 3	933	3	\N	2025-05-11 12:12:19.930433
5603	Điểm hệ số 1 #1	934	1	\N	2025-05-11 12:12:19.930433
5604	Điểm hệ số 1 #2	934	1	\N	2025-05-11 12:12:19.930433
5605	Điểm hệ số 1 #3	934	1	\N	2025-05-11 12:12:19.930433
5606	Điểm hệ số 2 #1	934	2	\N	2025-05-11 12:12:19.930433
5607	Điểm hệ số 2 #2	934	2	\N	2025-05-11 12:12:19.930433
5608	Điểm hệ số 3	934	3	\N	2025-05-11 12:12:19.930433
5609	Điểm hệ số 1 #1	935	1	\N	2025-05-11 12:12:19.930433
5610	Điểm hệ số 1 #2	935	1	\N	2025-05-11 12:12:19.930433
5611	Điểm hệ số 1 #3	935	1	\N	2025-05-11 12:12:19.930433
5612	Điểm hệ số 2 #1	935	2	\N	2025-05-11 12:12:19.930433
5613	Điểm hệ số 2 #2	935	2	\N	2025-05-11 12:12:19.930433
5614	Điểm hệ số 3	935	3	\N	2025-05-11 12:12:19.930433
5615	Điểm hệ số 1 #1	936	1	\N	2025-05-11 12:12:19.930433
5616	Điểm hệ số 1 #2	936	1	\N	2025-05-11 12:12:19.930433
5617	Điểm hệ số 1 #3	936	1	\N	2025-05-11 12:12:19.930433
5618	Điểm hệ số 2 #1	936	2	\N	2025-05-11 12:12:19.930433
5619	Điểm hệ số 2 #2	936	2	\N	2025-05-11 12:12:19.930433
5620	Điểm hệ số 3	936	3	\N	2025-05-11 12:12:19.930433
5621	Điểm hệ số 1 #1	937	1	\N	2025-05-11 12:12:19.930433
5622	Điểm hệ số 1 #2	937	1	\N	2025-05-11 12:12:19.930433
5623	Điểm hệ số 1 #3	937	1	\N	2025-05-11 12:12:19.930433
5624	Điểm hệ số 2 #1	937	2	\N	2025-05-11 12:12:19.930433
5625	Điểm hệ số 2 #2	937	2	\N	2025-05-11 12:12:19.930433
5626	Điểm hệ số 3	937	3	\N	2025-05-11 12:12:19.930433
5627	Điểm hệ số 1 #1	938	1	\N	2025-05-11 12:12:19.930433
5628	Điểm hệ số 1 #2	938	1	\N	2025-05-11 12:12:19.930433
5629	Điểm hệ số 1 #3	938	1	\N	2025-05-11 12:12:19.930433
5630	Điểm hệ số 2 #1	938	2	\N	2025-05-11 12:12:19.930433
5631	Điểm hệ số 2 #2	938	2	\N	2025-05-11 12:12:19.930433
5632	Điểm hệ số 3	938	3	\N	2025-05-11 12:12:19.930433
5633	Điểm hệ số 1 #1	939	1	\N	2025-05-11 12:12:19.930433
5634	Điểm hệ số 1 #2	939	1	\N	2025-05-11 12:12:19.930433
5635	Điểm hệ số 1 #3	939	1	\N	2025-05-11 12:12:19.930433
5636	Điểm hệ số 2 #1	939	2	\N	2025-05-11 12:12:19.930433
5637	Điểm hệ số 2 #2	939	2	\N	2025-05-11 12:12:19.930433
5638	Điểm hệ số 3	939	3	\N	2025-05-11 12:12:19.930433
5639	Điểm hệ số 1 #1	940	1	\N	2025-05-11 12:12:19.930433
5640	Điểm hệ số 1 #2	940	1	\N	2025-05-11 12:12:19.930433
5641	Điểm hệ số 1 #3	940	1	\N	2025-05-11 12:12:19.930433
5642	Điểm hệ số 2 #1	940	2	\N	2025-05-11 12:12:19.930433
5643	Điểm hệ số 2 #2	940	2	\N	2025-05-11 12:12:19.930433
5644	Điểm hệ số 3	940	3	\N	2025-05-11 12:12:19.930433
5645	Điểm hệ số 1 #1	941	1	\N	2025-05-11 12:12:19.930433
5646	Điểm hệ số 1 #2	941	1	\N	2025-05-11 12:12:19.930433
5647	Điểm hệ số 1 #3	941	1	\N	2025-05-11 12:12:19.930433
5648	Điểm hệ số 2 #1	941	2	\N	2025-05-11 12:12:19.930433
5649	Điểm hệ số 2 #2	941	2	\N	2025-05-11 12:12:19.930433
5650	Điểm hệ số 3	941	3	\N	2025-05-11 12:12:19.930433
5651	Điểm hệ số 1 #1	942	1	\N	2025-05-11 12:12:19.930433
5652	Điểm hệ số 1 #2	942	1	\N	2025-05-11 12:12:19.930433
5653	Điểm hệ số 1 #3	942	1	\N	2025-05-11 12:12:19.930433
5654	Điểm hệ số 2 #1	942	2	\N	2025-05-11 12:12:19.930433
5655	Điểm hệ số 2 #2	942	2	\N	2025-05-11 12:12:19.930433
5656	Điểm hệ số 3	942	3	\N	2025-05-11 12:12:19.930433
5657	Điểm hệ số 1 #1	943	1	\N	2025-05-11 12:12:19.930433
5658	Điểm hệ số 1 #2	943	1	\N	2025-05-11 12:12:19.930433
5659	Điểm hệ số 1 #3	943	1	\N	2025-05-11 12:12:19.930433
5660	Điểm hệ số 2 #1	943	2	\N	2025-05-11 12:12:19.930433
5661	Điểm hệ số 2 #2	943	2	\N	2025-05-11 12:12:19.930433
5662	Điểm hệ số 3	943	3	\N	2025-05-11 12:12:19.930433
5663	Điểm hệ số 1 #1	944	1	\N	2025-05-11 12:12:19.930433
5664	Điểm hệ số 1 #2	944	1	\N	2025-05-11 12:12:19.930433
5665	Điểm hệ số 1 #3	944	1	\N	2025-05-11 12:12:19.930433
5666	Điểm hệ số 2 #1	944	2	\N	2025-05-11 12:12:19.930433
5667	Điểm hệ số 2 #2	944	2	\N	2025-05-11 12:12:19.930433
5668	Điểm hệ số 3	944	3	\N	2025-05-11 12:12:19.930433
5669	Điểm hệ số 1 #1	945	1	\N	2025-05-11 12:12:19.930433
5670	Điểm hệ số 1 #2	945	1	\N	2025-05-11 12:12:19.930433
5671	Điểm hệ số 1 #3	945	1	\N	2025-05-11 12:12:19.930433
5672	Điểm hệ số 2 #1	945	2	\N	2025-05-11 12:12:19.930433
5673	Điểm hệ số 2 #2	945	2	\N	2025-05-11 12:12:19.930433
5674	Điểm hệ số 3	945	3	\N	2025-05-11 12:12:19.930433
5675	Điểm hệ số 1 #1	946	1	\N	2025-05-11 12:12:19.930433
5676	Điểm hệ số 1 #2	946	1	\N	2025-05-11 12:12:19.930433
5677	Điểm hệ số 1 #3	946	1	\N	2025-05-11 12:12:19.930433
5678	Điểm hệ số 2 #1	946	2	\N	2025-05-11 12:12:19.930433
5679	Điểm hệ số 2 #2	946	2	\N	2025-05-11 12:12:19.930433
5680	Điểm hệ số 3	946	3	\N	2025-05-11 12:12:19.930433
5681	Điểm hệ số 1 #1	947	1	\N	2025-05-11 12:12:19.930433
5682	Điểm hệ số 1 #2	947	1	\N	2025-05-11 12:12:19.930433
5683	Điểm hệ số 1 #3	947	1	\N	2025-05-11 12:12:19.930433
5684	Điểm hệ số 2 #1	947	2	\N	2025-05-11 12:12:19.930433
5685	Điểm hệ số 2 #2	947	2	\N	2025-05-11 12:12:19.930433
5686	Điểm hệ số 3	947	3	\N	2025-05-11 12:12:19.930433
5687	Điểm hệ số 1 #1	948	1	\N	2025-05-11 12:12:19.930433
5688	Điểm hệ số 1 #2	948	1	\N	2025-05-11 12:12:19.930433
5689	Điểm hệ số 1 #3	948	1	\N	2025-05-11 12:12:19.930433
5690	Điểm hệ số 2 #1	948	2	\N	2025-05-11 12:12:19.930433
5691	Điểm hệ số 2 #2	948	2	\N	2025-05-11 12:12:19.930433
5692	Điểm hệ số 3	948	3	\N	2025-05-11 12:12:19.930433
5693	Điểm hệ số 1 #1	949	1	\N	2025-05-11 12:12:19.930433
5694	Điểm hệ số 1 #2	949	1	\N	2025-05-11 12:12:19.931435
5695	Điểm hệ số 1 #3	949	1	\N	2025-05-11 12:12:19.931435
5696	Điểm hệ số 2 #1	949	2	\N	2025-05-11 12:12:19.931435
5697	Điểm hệ số 2 #2	949	2	\N	2025-05-11 12:12:19.931435
5698	Điểm hệ số 3	949	3	\N	2025-05-11 12:12:19.931435
5699	Điểm hệ số 1 #1	950	1	\N	2025-05-11 12:12:19.931435
5700	Điểm hệ số 1 #2	950	1	\N	2025-05-11 12:12:19.931435
5701	Điểm hệ số 1 #3	950	1	\N	2025-05-11 12:12:19.931435
5702	Điểm hệ số 2 #1	950	2	\N	2025-05-11 12:12:19.931435
5703	Điểm hệ số 2 #2	950	2	\N	2025-05-11 12:12:19.931435
5704	Điểm hệ số 3	950	3	\N	2025-05-11 12:12:19.931435
5705	Điểm hệ số 1 #1	951	1	\N	2025-05-11 12:12:19.931435
5706	Điểm hệ số 1 #2	951	1	\N	2025-05-11 12:12:19.931435
5707	Điểm hệ số 1 #3	951	1	\N	2025-05-11 12:12:19.931435
5708	Điểm hệ số 2 #1	951	2	\N	2025-05-11 12:12:19.931435
5709	Điểm hệ số 2 #2	951	2	\N	2025-05-11 12:12:19.931435
5710	Điểm hệ số 3	951	3	\N	2025-05-11 12:12:19.931435
5711	Điểm hệ số 1 #1	952	1	\N	2025-05-11 12:12:19.931435
5712	Điểm hệ số 1 #2	952	1	\N	2025-05-11 12:12:19.931435
5713	Điểm hệ số 1 #3	952	1	\N	2025-05-11 12:12:19.931435
5714	Điểm hệ số 2 #1	952	2	\N	2025-05-11 12:12:19.931435
5715	Điểm hệ số 2 #2	952	2	\N	2025-05-11 12:12:19.931435
5716	Điểm hệ số 3	952	3	\N	2025-05-11 12:12:19.931435
5717	Điểm hệ số 1 #1	953	1	\N	2025-05-11 12:12:19.931435
5718	Điểm hệ số 1 #2	953	1	\N	2025-05-11 12:12:19.931435
5719	Điểm hệ số 1 #3	953	1	\N	2025-05-11 12:12:19.931435
5720	Điểm hệ số 2 #1	953	2	\N	2025-05-11 12:12:19.931435
5721	Điểm hệ số 2 #2	953	2	\N	2025-05-11 12:12:19.931435
5722	Điểm hệ số 3	953	3	\N	2025-05-11 12:12:19.931435
5723	Điểm hệ số 1 #1	954	1	\N	2025-05-11 12:12:19.931435
5724	Điểm hệ số 1 #2	954	1	\N	2025-05-11 12:12:19.931435
5725	Điểm hệ số 1 #3	954	1	\N	2025-05-11 12:12:19.931435
5726	Điểm hệ số 2 #1	954	2	\N	2025-05-11 12:12:19.931435
5727	Điểm hệ số 2 #2	954	2	\N	2025-05-11 12:12:19.931435
5728	Điểm hệ số 3	954	3	\N	2025-05-11 12:12:19.931435
5729	Điểm hệ số 1 #1	955	1	\N	2025-05-11 12:12:19.931435
5730	Điểm hệ số 1 #2	955	1	\N	2025-05-11 12:12:19.931435
5731	Điểm hệ số 1 #3	955	1	\N	2025-05-11 12:12:19.931435
5732	Điểm hệ số 2 #1	955	2	\N	2025-05-11 12:12:19.931435
5733	Điểm hệ số 2 #2	955	2	\N	2025-05-11 12:12:19.931435
5734	Điểm hệ số 3	955	3	\N	2025-05-11 12:12:19.931435
5735	Điểm hệ số 1 #1	956	1	\N	2025-05-11 12:12:19.931435
5736	Điểm hệ số 1 #2	956	1	\N	2025-05-11 12:12:19.931435
5737	Điểm hệ số 1 #3	956	1	\N	2025-05-11 12:12:19.931435
5738	Điểm hệ số 2 #1	956	2	\N	2025-05-11 12:12:19.931435
5739	Điểm hệ số 2 #2	956	2	\N	2025-05-11 12:12:19.931435
5740	Điểm hệ số 3	956	3	\N	2025-05-11 12:12:19.931435
5741	Điểm hệ số 1 #1	957	1	\N	2025-05-11 12:12:19.931435
5742	Điểm hệ số 1 #2	957	1	\N	2025-05-11 12:12:19.931435
5743	Điểm hệ số 1 #3	957	1	\N	2025-05-11 12:12:19.931435
5744	Điểm hệ số 2 #1	957	2	\N	2025-05-11 12:12:19.931435
5745	Điểm hệ số 2 #2	957	2	\N	2025-05-11 12:12:19.931435
5746	Điểm hệ số 3	957	3	\N	2025-05-11 12:12:19.931435
5747	Điểm hệ số 1 #1	958	1	\N	2025-05-11 12:12:19.931435
5748	Điểm hệ số 1 #2	958	1	\N	2025-05-11 12:12:19.931435
5749	Điểm hệ số 1 #3	958	1	\N	2025-05-11 12:12:19.931435
5750	Điểm hệ số 2 #1	958	2	\N	2025-05-11 12:12:19.931435
5751	Điểm hệ số 2 #2	958	2	\N	2025-05-11 12:12:19.931435
5752	Điểm hệ số 3	958	3	\N	2025-05-11 12:12:19.931435
5753	Điểm hệ số 1 #1	959	1	\N	2025-05-11 12:12:19.931435
5754	Điểm hệ số 1 #2	959	1	\N	2025-05-11 12:12:19.931435
5755	Điểm hệ số 1 #3	959	1	\N	2025-05-11 12:12:19.931435
5756	Điểm hệ số 2 #1	959	2	\N	2025-05-11 12:12:19.931435
5757	Điểm hệ số 2 #2	959	2	\N	2025-05-11 12:12:19.931435
5758	Điểm hệ số 3	959	3	\N	2025-05-11 12:12:19.931435
5759	Điểm hệ số 1 #1	960	1	\N	2025-05-11 12:12:19.931435
5760	Điểm hệ số 1 #2	960	1	\N	2025-05-11 12:12:19.931435
5761	Điểm hệ số 1 #3	960	1	\N	2025-05-11 12:12:19.931435
5762	Điểm hệ số 2 #1	960	2	\N	2025-05-11 12:12:19.931435
5763	Điểm hệ số 2 #2	960	2	\N	2025-05-11 12:12:19.931435
5764	Điểm hệ số 3	960	3	\N	2025-05-11 12:12:19.931435
5765	Điểm hệ số 1 #1	961	1	\N	2025-05-11 12:12:19.931435
5766	Điểm hệ số 1 #2	961	1	\N	2025-05-11 12:12:19.931435
5767	Điểm hệ số 1 #3	961	1	\N	2025-05-11 12:12:19.931435
5768	Điểm hệ số 2 #1	961	2	\N	2025-05-11 12:12:19.931435
5769	Điểm hệ số 2 #2	961	2	\N	2025-05-11 12:12:19.931435
5770	Điểm hệ số 3	961	3	\N	2025-05-11 12:12:19.931435
5771	Điểm hệ số 1 #1	962	1	\N	2025-05-11 12:12:19.931435
5772	Điểm hệ số 1 #2	962	1	\N	2025-05-11 12:12:19.931435
5773	Điểm hệ số 1 #3	962	1	\N	2025-05-11 12:12:19.931435
5774	Điểm hệ số 2 #1	962	2	\N	2025-05-11 12:12:19.931435
5775	Điểm hệ số 2 #2	962	2	\N	2025-05-11 12:12:19.931435
5776	Điểm hệ số 3	962	3	\N	2025-05-11 12:12:19.931435
5777	Điểm hệ số 1 #1	963	1	\N	2025-05-11 12:12:19.931435
5778	Điểm hệ số 1 #2	963	1	\N	2025-05-11 12:12:19.931435
5779	Điểm hệ số 1 #3	963	1	\N	2025-05-11 12:12:19.931435
5780	Điểm hệ số 2 #1	963	2	\N	2025-05-11 12:12:19.931435
5781	Điểm hệ số 2 #2	963	2	\N	2025-05-11 12:12:19.931435
5782	Điểm hệ số 3	963	3	\N	2025-05-11 12:12:19.931435
5783	Điểm hệ số 1 #1	964	1	\N	2025-05-11 12:12:19.931435
5784	Điểm hệ số 1 #2	964	1	\N	2025-05-11 12:12:19.931435
5785	Điểm hệ số 1 #3	964	1	\N	2025-05-11 12:12:19.931435
5786	Điểm hệ số 2 #1	964	2	\N	2025-05-11 12:12:19.931435
5787	Điểm hệ số 2 #2	964	2	\N	2025-05-11 12:12:19.931435
5788	Điểm hệ số 3	964	3	\N	2025-05-11 12:12:19.931435
5789	Điểm hệ số 1 #1	965	1	\N	2025-05-11 12:12:19.931435
5790	Điểm hệ số 1 #2	965	1	\N	2025-05-11 12:12:19.931435
5791	Điểm hệ số 1 #3	965	1	\N	2025-05-11 12:12:19.931435
5792	Điểm hệ số 2 #1	965	2	\N	2025-05-11 12:12:19.931435
5793	Điểm hệ số 2 #2	965	2	\N	2025-05-11 12:12:19.931435
5794	Điểm hệ số 3	965	3	\N	2025-05-11 12:12:19.931435
5795	Điểm hệ số 1 #1	966	1	\N	2025-05-11 12:12:19.931435
5796	Điểm hệ số 1 #2	966	1	\N	2025-05-11 12:12:19.931435
5797	Điểm hệ số 1 #3	966	1	\N	2025-05-11 12:12:19.931435
5798	Điểm hệ số 2 #1	966	2	\N	2025-05-11 12:12:19.931435
5799	Điểm hệ số 2 #2	966	2	\N	2025-05-11 12:12:19.931435
5800	Điểm hệ số 3	966	3	\N	2025-05-11 12:12:19.931435
5801	Điểm hệ số 1 #1	967	1	\N	2025-05-11 12:12:19.931435
5802	Điểm hệ số 1 #2	967	1	\N	2025-05-11 12:12:19.931435
5803	Điểm hệ số 1 #3	967	1	\N	2025-05-11 12:12:19.931435
5804	Điểm hệ số 2 #1	967	2	\N	2025-05-11 12:12:19.931435
5805	Điểm hệ số 2 #2	967	2	\N	2025-05-11 12:12:19.931435
5806	Điểm hệ số 3	967	3	\N	2025-05-11 12:12:19.931435
5807	Điểm hệ số 1 #1	968	1	\N	2025-05-11 12:12:19.931435
5808	Điểm hệ số 1 #2	968	1	\N	2025-05-11 12:12:19.931435
5809	Điểm hệ số 1 #3	968	1	\N	2025-05-11 12:12:19.931435
5810	Điểm hệ số 2 #1	968	2	\N	2025-05-11 12:12:19.931435
5811	Điểm hệ số 2 #2	968	2	\N	2025-05-11 12:12:19.931435
5812	Điểm hệ số 3	968	3	\N	2025-05-11 12:12:19.931435
5813	Điểm hệ số 1 #1	969	1	\N	2025-05-11 12:12:19.931435
5814	Điểm hệ số 1 #2	969	1	\N	2025-05-11 12:12:19.931435
5815	Điểm hệ số 1 #3	969	1	\N	2025-05-11 12:12:19.931435
5816	Điểm hệ số 2 #1	969	2	\N	2025-05-11 12:12:19.931435
5817	Điểm hệ số 2 #2	969	2	\N	2025-05-11 12:12:19.931435
5818	Điểm hệ số 3	969	3	\N	2025-05-11 12:12:19.931435
5819	Điểm hệ số 1 #1	970	1	\N	2025-05-11 12:12:19.931435
5820	Điểm hệ số 1 #2	970	1	\N	2025-05-11 12:12:19.931435
5821	Điểm hệ số 1 #3	970	1	\N	2025-05-11 12:12:19.931435
5822	Điểm hệ số 2 #1	970	2	\N	2025-05-11 12:12:19.931435
5823	Điểm hệ số 2 #2	970	2	\N	2025-05-11 12:12:19.931435
5824	Điểm hệ số 3	970	3	\N	2025-05-11 12:12:19.931435
5825	Điểm hệ số 1 #1	971	1	\N	2025-05-11 12:12:19.931435
5826	Điểm hệ số 1 #2	971	1	\N	2025-05-11 12:12:19.931435
5827	Điểm hệ số 1 #3	971	1	\N	2025-05-11 12:12:19.931435
5828	Điểm hệ số 2 #1	971	2	\N	2025-05-11 12:12:19.931435
5829	Điểm hệ số 2 #2	971	2	\N	2025-05-11 12:12:19.931435
5830	Điểm hệ số 3	971	3	\N	2025-05-11 12:12:19.931435
5831	Điểm hệ số 1 #1	972	1	\N	2025-05-11 12:12:19.931435
5832	Điểm hệ số 1 #2	972	1	\N	2025-05-11 12:12:19.931435
5833	Điểm hệ số 1 #3	972	1	\N	2025-05-11 12:12:19.931435
5834	Điểm hệ số 2 #1	972	2	\N	2025-05-11 12:12:19.931435
5835	Điểm hệ số 2 #2	972	2	\N	2025-05-11 12:12:19.931435
5836	Điểm hệ số 3	972	3	\N	2025-05-11 12:12:19.931435
5837	Điểm hệ số 1 #1	973	1	\N	2025-05-11 12:12:19.931435
5838	Điểm hệ số 1 #2	973	1	\N	2025-05-11 12:12:19.931435
5839	Điểm hệ số 1 #3	973	1	\N	2025-05-11 12:12:19.931435
5840	Điểm hệ số 2 #1	973	2	\N	2025-05-11 12:12:19.931435
5841	Điểm hệ số 2 #2	973	2	\N	2025-05-11 12:12:19.931435
5842	Điểm hệ số 3	973	3	\N	2025-05-11 12:12:19.931435
5843	Điểm hệ số 1 #1	974	1	\N	2025-05-11 12:12:19.931435
5844	Điểm hệ số 1 #2	974	1	\N	2025-05-11 12:12:19.931435
5845	Điểm hệ số 1 #3	974	1	\N	2025-05-11 12:12:19.931435
5846	Điểm hệ số 2 #1	974	2	\N	2025-05-11 12:12:19.931435
5847	Điểm hệ số 2 #2	974	2	\N	2025-05-11 12:12:19.931435
5848	Điểm hệ số 3	974	3	\N	2025-05-11 12:12:19.931435
5849	Điểm hệ số 1 #1	975	1	\N	2025-05-11 12:12:19.931435
5850	Điểm hệ số 1 #2	975	1	\N	2025-05-11 12:12:19.931435
5851	Điểm hệ số 1 #3	975	1	\N	2025-05-11 12:12:19.931435
5852	Điểm hệ số 2 #1	975	2	\N	2025-05-11 12:12:19.931435
5853	Điểm hệ số 2 #2	975	2	\N	2025-05-11 12:12:19.931435
5854	Điểm hệ số 3	975	3	\N	2025-05-11 12:12:19.931435
5855	Điểm hệ số 1 #1	976	1	\N	2025-05-11 12:12:19.931435
5856	Điểm hệ số 1 #2	976	1	\N	2025-05-11 12:12:19.931435
5857	Điểm hệ số 1 #3	976	1	\N	2025-05-11 12:12:19.931435
5858	Điểm hệ số 2 #1	976	2	\N	2025-05-11 12:12:19.931435
5859	Điểm hệ số 2 #2	976	2	\N	2025-05-11 12:12:19.931435
5860	Điểm hệ số 3	976	3	\N	2025-05-11 12:12:19.931435
5861	Điểm hệ số 1 #1	977	1	\N	2025-05-11 12:12:19.931435
5862	Điểm hệ số 1 #2	977	1	\N	2025-05-11 12:12:19.931435
5863	Điểm hệ số 1 #3	977	1	\N	2025-05-11 12:12:19.931435
5864	Điểm hệ số 2 #1	977	2	\N	2025-05-11 12:12:19.931435
5865	Điểm hệ số 2 #2	977	2	\N	2025-05-11 12:12:19.931435
5866	Điểm hệ số 3	977	3	\N	2025-05-11 12:12:19.931435
5867	Điểm hệ số 1 #1	978	1	\N	2025-05-11 12:12:19.931435
5868	Điểm hệ số 1 #2	978	1	\N	2025-05-11 12:12:19.931435
5869	Điểm hệ số 1 #3	978	1	\N	2025-05-11 12:12:19.931435
5870	Điểm hệ số 2 #1	978	2	\N	2025-05-11 12:12:19.931435
5871	Điểm hệ số 2 #2	978	2	\N	2025-05-11 12:12:19.931435
5872	Điểm hệ số 3	978	3	\N	2025-05-11 12:12:19.931435
5873	Điểm hệ số 1 #1	979	1	\N	2025-05-11 12:12:19.931435
5874	Điểm hệ số 1 #2	979	1	\N	2025-05-11 12:12:19.931435
5875	Điểm hệ số 1 #3	979	1	\N	2025-05-11 12:12:19.931435
5876	Điểm hệ số 2 #1	979	2	\N	2025-05-11 12:12:19.931435
5877	Điểm hệ số 2 #2	979	2	\N	2025-05-11 12:12:19.931435
5878	Điểm hệ số 3	979	3	\N	2025-05-11 12:12:19.931435
5879	Điểm hệ số 1 #1	980	1	\N	2025-05-11 12:12:19.931435
5880	Điểm hệ số 1 #2	980	1	\N	2025-05-11 12:12:19.931435
5881	Điểm hệ số 1 #3	980	1	\N	2025-05-11 12:12:19.931435
5882	Điểm hệ số 2 #1	980	2	\N	2025-05-11 12:12:19.931435
5883	Điểm hệ số 2 #2	980	2	\N	2025-05-11 12:12:19.931435
5884	Điểm hệ số 3	980	3	\N	2025-05-11 12:12:19.931435
5885	Điểm hệ số 1 #1	981	1	\N	2025-05-11 12:12:19.931435
5886	Điểm hệ số 1 #2	981	1	\N	2025-05-11 12:12:19.931435
5887	Điểm hệ số 1 #3	981	1	\N	2025-05-11 12:12:19.931435
5888	Điểm hệ số 2 #1	981	2	\N	2025-05-11 12:12:19.931435
5889	Điểm hệ số 2 #2	981	2	\N	2025-05-11 12:12:19.931435
5890	Điểm hệ số 3	981	3	\N	2025-05-11 12:12:19.931435
5891	Điểm hệ số 1 #1	982	1	\N	2025-05-11 12:12:19.931435
5892	Điểm hệ số 1 #2	982	1	\N	2025-05-11 12:12:19.931435
5893	Điểm hệ số 1 #3	982	1	\N	2025-05-11 12:12:19.931435
5894	Điểm hệ số 2 #1	982	2	\N	2025-05-11 12:12:19.931435
5895	Điểm hệ số 2 #2	982	2	\N	2025-05-11 12:12:19.931435
5896	Điểm hệ số 3	982	3	\N	2025-05-11 12:12:19.931435
5897	Điểm hệ số 1 #1	983	1	\N	2025-05-11 12:12:19.931435
5898	Điểm hệ số 1 #2	983	1	\N	2025-05-11 12:12:19.931435
5899	Điểm hệ số 1 #3	983	1	\N	2025-05-11 12:12:19.931435
5900	Điểm hệ số 2 #1	983	2	\N	2025-05-11 12:12:19.931435
5901	Điểm hệ số 2 #2	983	2	\N	2025-05-11 12:12:19.931435
5902	Điểm hệ số 3	983	3	\N	2025-05-11 12:12:19.931435
5903	Điểm hệ số 1 #1	984	1	\N	2025-05-11 12:12:21.053764
5904	Điểm hệ số 1 #2	984	1	\N	2025-05-11 12:12:21.053764
5905	Điểm hệ số 1 #3	984	1	\N	2025-05-11 12:12:21.053764
5906	Điểm hệ số 2 #1	984	2	\N	2025-05-11 12:12:21.053764
5907	Điểm hệ số 2 #2	984	2	\N	2025-05-11 12:12:21.053764
5908	Điểm hệ số 3	984	3	\N	2025-05-11 12:12:21.053764
5909	Điểm hệ số 1 #1	985	1	\N	2025-05-11 12:12:21.053764
5910	Điểm hệ số 1 #2	985	1	\N	2025-05-11 12:12:21.053764
5911	Điểm hệ số 1 #3	985	1	\N	2025-05-11 12:12:21.053764
5912	Điểm hệ số 2 #1	985	2	\N	2025-05-11 12:12:21.053764
5913	Điểm hệ số 2 #2	985	2	\N	2025-05-11 12:12:21.053764
5914	Điểm hệ số 3	985	3	\N	2025-05-11 12:12:21.053764
5915	Điểm hệ số 1 #1	986	1	\N	2025-05-11 12:12:21.053764
5916	Điểm hệ số 1 #2	986	1	\N	2025-05-11 12:12:21.053764
5917	Điểm hệ số 1 #3	986	1	\N	2025-05-11 12:12:21.053764
5918	Điểm hệ số 2 #1	986	2	\N	2025-05-11 12:12:21.053764
5919	Điểm hệ số 2 #2	986	2	\N	2025-05-11 12:12:21.053764
5920	Điểm hệ số 3	986	3	\N	2025-05-11 12:12:21.053764
5921	Điểm hệ số 1 #1	987	1	\N	2025-05-11 12:12:21.053764
5922	Điểm hệ số 1 #2	987	1	\N	2025-05-11 12:12:21.053764
5923	Điểm hệ số 1 #3	987	1	\N	2025-05-11 12:12:21.053764
5924	Điểm hệ số 2 #1	987	2	\N	2025-05-11 12:12:21.053764
5925	Điểm hệ số 2 #2	987	2	\N	2025-05-11 12:12:21.053764
5926	Điểm hệ số 3	987	3	\N	2025-05-11 12:12:21.053764
5927	Điểm hệ số 1 #1	988	1	\N	2025-05-11 12:12:21.053764
5928	Điểm hệ số 1 #2	988	1	\N	2025-05-11 12:12:21.053764
5929	Điểm hệ số 1 #3	988	1	\N	2025-05-11 12:12:21.053764
5930	Điểm hệ số 2 #1	988	2	\N	2025-05-11 12:12:21.053764
5931	Điểm hệ số 2 #2	988	2	\N	2025-05-11 12:12:21.053764
5932	Điểm hệ số 3	988	3	\N	2025-05-11 12:12:21.053764
5933	Điểm hệ số 1 #1	989	1	\N	2025-05-11 12:12:21.053764
5934	Điểm hệ số 1 #2	989	1	\N	2025-05-11 12:12:21.053764
5935	Điểm hệ số 1 #3	989	1	\N	2025-05-11 12:12:21.053764
5936	Điểm hệ số 2 #1	989	2	\N	2025-05-11 12:12:21.053764
5937	Điểm hệ số 2 #2	989	2	\N	2025-05-11 12:12:21.053764
5938	Điểm hệ số 3	989	3	\N	2025-05-11 12:12:21.053764
5939	Điểm hệ số 1 #1	990	1	\N	2025-05-11 12:12:21.053764
5940	Điểm hệ số 1 #2	990	1	\N	2025-05-11 12:12:21.053764
5941	Điểm hệ số 1 #3	990	1	\N	2025-05-11 12:12:21.053764
5942	Điểm hệ số 2 #1	990	2	\N	2025-05-11 12:12:21.053764
5943	Điểm hệ số 2 #2	990	2	\N	2025-05-11 12:12:21.053764
5944	Điểm hệ số 3	990	3	\N	2025-05-11 12:12:21.053764
5945	Điểm hệ số 1 #1	991	1	\N	2025-05-11 12:12:21.053764
5946	Điểm hệ số 1 #2	991	1	\N	2025-05-11 12:12:21.053764
5947	Điểm hệ số 1 #3	991	1	\N	2025-05-11 12:12:21.053764
5948	Điểm hệ số 2 #1	991	2	\N	2025-05-11 12:12:21.053764
5949	Điểm hệ số 2 #2	991	2	\N	2025-05-11 12:12:21.053764
5950	Điểm hệ số 3	991	3	\N	2025-05-11 12:12:21.053764
5951	Điểm hệ số 1 #1	992	1	\N	2025-05-11 12:12:21.053764
5952	Điểm hệ số 1 #2	992	1	\N	2025-05-11 12:12:21.053764
5953	Điểm hệ số 1 #3	992	1	\N	2025-05-11 12:12:21.053764
5954	Điểm hệ số 2 #1	992	2	\N	2025-05-11 12:12:21.053764
5955	Điểm hệ số 2 #2	992	2	\N	2025-05-11 12:12:21.053764
5956	Điểm hệ số 3	992	3	\N	2025-05-11 12:12:21.053764
5957	Điểm hệ số 1 #1	993	1	\N	2025-05-11 12:12:21.053764
5958	Điểm hệ số 1 #2	993	1	\N	2025-05-11 12:12:21.053764
5959	Điểm hệ số 1 #3	993	1	\N	2025-05-11 12:12:21.053764
5960	Điểm hệ số 2 #1	993	2	\N	2025-05-11 12:12:21.053764
5961	Điểm hệ số 2 #2	993	2	\N	2025-05-11 12:12:21.053764
5962	Điểm hệ số 3	993	3	\N	2025-05-11 12:12:21.053764
5963	Điểm hệ số 1 #1	994	1	\N	2025-05-11 12:12:21.053764
5964	Điểm hệ số 1 #2	994	1	\N	2025-05-11 12:12:21.053764
5965	Điểm hệ số 1 #3	994	1	\N	2025-05-11 12:12:21.053764
5966	Điểm hệ số 2 #1	994	2	\N	2025-05-11 12:12:21.053764
5967	Điểm hệ số 2 #2	994	2	\N	2025-05-11 12:12:21.053764
5968	Điểm hệ số 3	994	3	\N	2025-05-11 12:12:21.053764
5969	Điểm hệ số 1 #1	995	1	\N	2025-05-11 12:12:21.053764
5970	Điểm hệ số 1 #2	995	1	\N	2025-05-11 12:12:21.053764
5971	Điểm hệ số 1 #3	995	1	\N	2025-05-11 12:12:21.053764
5972	Điểm hệ số 2 #1	995	2	\N	2025-05-11 12:12:21.053764
5973	Điểm hệ số 2 #2	995	2	\N	2025-05-11 12:12:21.053764
5974	Điểm hệ số 3	995	3	\N	2025-05-11 12:12:21.053764
5975	Điểm hệ số 1 #1	996	1	\N	2025-05-11 12:12:21.053764
5976	Điểm hệ số 1 #2	996	1	\N	2025-05-11 12:12:21.053764
5977	Điểm hệ số 1 #3	996	1	\N	2025-05-11 12:12:21.053764
5978	Điểm hệ số 2 #1	996	2	\N	2025-05-11 12:12:21.053764
5979	Điểm hệ số 2 #2	996	2	\N	2025-05-11 12:12:21.053764
5980	Điểm hệ số 3	996	3	\N	2025-05-11 12:12:21.053764
5981	Điểm hệ số 1 #1	997	1	\N	2025-05-11 12:12:21.053764
5982	Điểm hệ số 1 #2	997	1	\N	2025-05-11 12:12:21.053764
5983	Điểm hệ số 1 #3	997	1	\N	2025-05-11 12:12:21.053764
5984	Điểm hệ số 2 #1	997	2	\N	2025-05-11 12:12:21.053764
5985	Điểm hệ số 2 #2	997	2	\N	2025-05-11 12:12:21.053764
5986	Điểm hệ số 3	997	3	\N	2025-05-11 12:12:21.053764
5987	Điểm hệ số 1 #1	998	1	\N	2025-05-11 12:12:21.053764
5988	Điểm hệ số 1 #2	998	1	\N	2025-05-11 12:12:21.053764
5989	Điểm hệ số 1 #3	998	1	\N	2025-05-11 12:12:21.053764
5990	Điểm hệ số 2 #1	998	2	\N	2025-05-11 12:12:21.053764
5991	Điểm hệ số 2 #2	998	2	\N	2025-05-11 12:12:21.053764
5992	Điểm hệ số 3	998	3	\N	2025-05-11 12:12:21.053764
5993	Điểm hệ số 1 #1	999	1	\N	2025-05-11 12:12:21.053764
5994	Điểm hệ số 1 #2	999	1	\N	2025-05-11 12:12:21.053764
5995	Điểm hệ số 1 #3	999	1	\N	2025-05-11 12:12:21.053764
5996	Điểm hệ số 2 #1	999	2	\N	2025-05-11 12:12:21.053764
5997	Điểm hệ số 2 #2	999	2	\N	2025-05-11 12:12:21.053764
5998	Điểm hệ số 3	999	3	\N	2025-05-11 12:12:21.053764
5999	Điểm hệ số 1 #1	1000	1	\N	2025-05-11 12:12:21.053764
6000	Điểm hệ số 1 #2	1000	1	\N	2025-05-11 12:12:21.053764
6001	Điểm hệ số 1 #3	1000	1	\N	2025-05-11 12:12:21.053764
6002	Điểm hệ số 2 #1	1000	2	\N	2025-05-11 12:12:21.053764
6003	Điểm hệ số 2 #2	1000	2	\N	2025-05-11 12:12:21.053764
6004	Điểm hệ số 3	1000	3	\N	2025-05-11 12:12:21.053764
6005	Điểm hệ số 1 #1	1001	1	\N	2025-05-11 12:12:21.053764
6006	Điểm hệ số 1 #2	1001	1	\N	2025-05-11 12:12:21.053764
6007	Điểm hệ số 1 #3	1001	1	\N	2025-05-11 12:12:21.053764
6008	Điểm hệ số 2 #1	1001	2	\N	2025-05-11 12:12:21.053764
6009	Điểm hệ số 2 #2	1001	2	\N	2025-05-11 12:12:21.053764
6010	Điểm hệ số 3	1001	3	\N	2025-05-11 12:12:21.053764
6011	Điểm hệ số 1 #1	1002	1	\N	2025-05-11 12:12:21.053764
6012	Điểm hệ số 1 #2	1002	1	\N	2025-05-11 12:12:21.053764
6013	Điểm hệ số 1 #3	1002	1	\N	2025-05-11 12:12:21.053764
6014	Điểm hệ số 2 #1	1002	2	\N	2025-05-11 12:12:21.053764
6015	Điểm hệ số 2 #2	1002	2	\N	2025-05-11 12:12:21.053764
6016	Điểm hệ số 3	1002	3	\N	2025-05-11 12:12:21.053764
6017	Điểm hệ số 1 #1	1003	1	\N	2025-05-11 12:12:21.053764
6018	Điểm hệ số 1 #2	1003	1	\N	2025-05-11 12:12:21.053764
6019	Điểm hệ số 1 #3	1003	1	\N	2025-05-11 12:12:21.054764
6020	Điểm hệ số 2 #1	1003	2	\N	2025-05-11 12:12:21.054764
6021	Điểm hệ số 2 #2	1003	2	\N	2025-05-11 12:12:21.054764
6022	Điểm hệ số 3	1003	3	\N	2025-05-11 12:12:21.054764
6023	Điểm hệ số 1 #1	1004	1	\N	2025-05-11 12:12:21.054764
6024	Điểm hệ số 1 #2	1004	1	\N	2025-05-11 12:12:21.054764
6025	Điểm hệ số 1 #3	1004	1	\N	2025-05-11 12:12:21.054764
6026	Điểm hệ số 2 #1	1004	2	\N	2025-05-11 12:12:21.054764
6027	Điểm hệ số 2 #2	1004	2	\N	2025-05-11 12:12:21.054764
6028	Điểm hệ số 3	1004	3	\N	2025-05-11 12:12:21.054764
6029	Điểm hệ số 1 #1	1005	1	\N	2025-05-11 12:12:21.054764
6030	Điểm hệ số 1 #2	1005	1	\N	2025-05-11 12:12:21.054764
6031	Điểm hệ số 1 #3	1005	1	\N	2025-05-11 12:12:21.054764
6032	Điểm hệ số 2 #1	1005	2	\N	2025-05-11 12:12:21.054764
6033	Điểm hệ số 2 #2	1005	2	\N	2025-05-11 12:12:21.054764
6034	Điểm hệ số 3	1005	3	\N	2025-05-11 12:12:21.054764
6035	Điểm hệ số 1 #1	1006	1	\N	2025-05-11 12:12:21.054764
6036	Điểm hệ số 1 #2	1006	1	\N	2025-05-11 12:12:21.054764
6037	Điểm hệ số 1 #3	1006	1	\N	2025-05-11 12:12:21.054764
6038	Điểm hệ số 2 #1	1006	2	\N	2025-05-11 12:12:21.054764
6039	Điểm hệ số 2 #2	1006	2	\N	2025-05-11 12:12:21.054764
6040	Điểm hệ số 3	1006	3	\N	2025-05-11 12:12:21.054764
6041	Điểm hệ số 1 #1	1007	1	\N	2025-05-11 12:12:21.054764
6042	Điểm hệ số 1 #2	1007	1	\N	2025-05-11 12:12:21.054764
6043	Điểm hệ số 1 #3	1007	1	\N	2025-05-11 12:12:21.054764
6044	Điểm hệ số 2 #1	1007	2	\N	2025-05-11 12:12:21.054764
6045	Điểm hệ số 2 #2	1007	2	\N	2025-05-11 12:12:21.054764
6046	Điểm hệ số 3	1007	3	\N	2025-05-11 12:12:21.054764
6047	Điểm hệ số 1 #1	1008	1	\N	2025-05-11 12:12:21.054764
6048	Điểm hệ số 1 #2	1008	1	\N	2025-05-11 12:12:21.054764
6049	Điểm hệ số 1 #3	1008	1	\N	2025-05-11 12:12:21.054764
6050	Điểm hệ số 2 #1	1008	2	\N	2025-05-11 12:12:21.054764
6051	Điểm hệ số 2 #2	1008	2	\N	2025-05-11 12:12:21.054764
6052	Điểm hệ số 3	1008	3	\N	2025-05-11 12:12:21.054764
6053	Điểm hệ số 1 #1	1009	1	\N	2025-05-11 12:12:21.054764
6054	Điểm hệ số 1 #2	1009	1	\N	2025-05-11 12:12:21.054764
6055	Điểm hệ số 1 #3	1009	1	\N	2025-05-11 12:12:21.054764
6056	Điểm hệ số 2 #1	1009	2	\N	2025-05-11 12:12:21.054764
6057	Điểm hệ số 2 #2	1009	2	\N	2025-05-11 12:12:21.054764
6058	Điểm hệ số 3	1009	3	\N	2025-05-11 12:12:21.054764
6059	Điểm hệ số 1 #1	1010	1	\N	2025-05-11 12:12:21.054764
6060	Điểm hệ số 1 #2	1010	1	\N	2025-05-11 12:12:21.054764
6061	Điểm hệ số 1 #3	1010	1	\N	2025-05-11 12:12:21.054764
6062	Điểm hệ số 2 #1	1010	2	\N	2025-05-11 12:12:21.054764
6063	Điểm hệ số 2 #2	1010	2	\N	2025-05-11 12:12:21.054764
6064	Điểm hệ số 3	1010	3	\N	2025-05-11 12:12:21.054764
6065	Điểm hệ số 1 #1	1011	1	\N	2025-05-11 12:12:21.054764
6066	Điểm hệ số 1 #2	1011	1	\N	2025-05-11 12:12:21.054764
6067	Điểm hệ số 1 #3	1011	1	\N	2025-05-11 12:12:21.054764
6068	Điểm hệ số 2 #1	1011	2	\N	2025-05-11 12:12:21.054764
6069	Điểm hệ số 2 #2	1011	2	\N	2025-05-11 12:12:21.054764
6070	Điểm hệ số 3	1011	3	\N	2025-05-11 12:12:21.054764
6071	Điểm hệ số 1 #1	1012	1	\N	2025-05-11 12:12:21.054764
6072	Điểm hệ số 1 #2	1012	1	\N	2025-05-11 12:12:21.054764
6073	Điểm hệ số 1 #3	1012	1	\N	2025-05-11 12:12:21.054764
6074	Điểm hệ số 2 #1	1012	2	\N	2025-05-11 12:12:21.054764
6075	Điểm hệ số 2 #2	1012	2	\N	2025-05-11 12:12:21.054764
6076	Điểm hệ số 3	1012	3	\N	2025-05-11 12:12:21.054764
6077	Điểm hệ số 1 #1	1013	1	\N	2025-05-11 12:12:21.054764
6078	Điểm hệ số 1 #2	1013	1	\N	2025-05-11 12:12:21.054764
6079	Điểm hệ số 1 #3	1013	1	\N	2025-05-11 12:12:21.054764
6080	Điểm hệ số 2 #1	1013	2	\N	2025-05-11 12:12:21.054764
6081	Điểm hệ số 2 #2	1013	2	\N	2025-05-11 12:12:21.054764
6082	Điểm hệ số 3	1013	3	\N	2025-05-11 12:12:21.054764
6083	Điểm hệ số 1 #1	1014	1	\N	2025-05-11 12:12:21.054764
6084	Điểm hệ số 1 #2	1014	1	\N	2025-05-11 12:12:21.054764
6085	Điểm hệ số 1 #3	1014	1	\N	2025-05-11 12:12:21.054764
6086	Điểm hệ số 2 #1	1014	2	\N	2025-05-11 12:12:21.054764
6087	Điểm hệ số 2 #2	1014	2	\N	2025-05-11 12:12:21.054764
6088	Điểm hệ số 3	1014	3	\N	2025-05-11 12:12:21.054764
6089	Điểm hệ số 1 #1	1015	1	\N	2025-05-11 12:12:21.054764
6090	Điểm hệ số 1 #2	1015	1	\N	2025-05-11 12:12:21.054764
6091	Điểm hệ số 1 #3	1015	1	\N	2025-05-11 12:12:21.054764
6092	Điểm hệ số 2 #1	1015	2	\N	2025-05-11 12:12:21.054764
6093	Điểm hệ số 2 #2	1015	2	\N	2025-05-11 12:12:21.054764
6094	Điểm hệ số 3	1015	3	\N	2025-05-11 12:12:21.054764
6095	Điểm hệ số 1 #1	1016	1	\N	2025-05-11 12:12:21.054764
6096	Điểm hệ số 1 #2	1016	1	\N	2025-05-11 12:12:21.054764
6097	Điểm hệ số 1 #3	1016	1	\N	2025-05-11 12:12:21.054764
6098	Điểm hệ số 2 #1	1016	2	\N	2025-05-11 12:12:21.054764
6099	Điểm hệ số 2 #2	1016	2	\N	2025-05-11 12:12:21.054764
6100	Điểm hệ số 3	1016	3	\N	2025-05-11 12:12:21.054764
6101	Điểm hệ số 1 #1	1017	1	\N	2025-05-11 12:12:21.054764
6102	Điểm hệ số 1 #2	1017	1	\N	2025-05-11 12:12:21.054764
6103	Điểm hệ số 1 #3	1017	1	\N	2025-05-11 12:12:21.054764
6104	Điểm hệ số 2 #1	1017	2	\N	2025-05-11 12:12:21.054764
6105	Điểm hệ số 2 #2	1017	2	\N	2025-05-11 12:12:21.054764
6106	Điểm hệ số 3	1017	3	\N	2025-05-11 12:12:21.054764
6107	Điểm hệ số 1 #1	1018	1	\N	2025-05-11 12:12:21.054764
6108	Điểm hệ số 1 #2	1018	1	\N	2025-05-11 12:12:21.054764
6109	Điểm hệ số 1 #3	1018	1	\N	2025-05-11 12:12:21.054764
6110	Điểm hệ số 2 #1	1018	2	\N	2025-05-11 12:12:21.054764
6111	Điểm hệ số 2 #2	1018	2	\N	2025-05-11 12:12:21.054764
6112	Điểm hệ số 3	1018	3	\N	2025-05-11 12:12:21.054764
6113	Điểm hệ số 1 #1	1019	1	\N	2025-05-11 12:12:21.054764
6114	Điểm hệ số 1 #2	1019	1	\N	2025-05-11 12:12:21.054764
6115	Điểm hệ số 1 #3	1019	1	\N	2025-05-11 12:12:21.054764
6116	Điểm hệ số 2 #1	1019	2	\N	2025-05-11 12:12:21.054764
6117	Điểm hệ số 2 #2	1019	2	\N	2025-05-11 12:12:21.054764
6118	Điểm hệ số 3	1019	3	\N	2025-05-11 12:12:21.054764
6119	Điểm hệ số 1 #1	1020	1	\N	2025-05-11 12:12:21.054764
6120	Điểm hệ số 1 #2	1020	1	\N	2025-05-11 12:12:21.054764
6121	Điểm hệ số 1 #3	1020	1	\N	2025-05-11 12:12:21.054764
6122	Điểm hệ số 2 #1	1020	2	\N	2025-05-11 12:12:21.054764
6123	Điểm hệ số 2 #2	1020	2	\N	2025-05-11 12:12:21.054764
6124	Điểm hệ số 3	1020	3	\N	2025-05-11 12:12:21.054764
6125	Điểm hệ số 1 #1	1021	1	\N	2025-05-11 12:12:21.054764
6126	Điểm hệ số 1 #2	1021	1	\N	2025-05-11 12:12:21.054764
6127	Điểm hệ số 1 #3	1021	1	\N	2025-05-11 12:12:21.054764
6128	Điểm hệ số 2 #1	1021	2	\N	2025-05-11 12:12:21.054764
6129	Điểm hệ số 2 #2	1021	2	\N	2025-05-11 12:12:21.054764
6130	Điểm hệ số 3	1021	3	\N	2025-05-11 12:12:21.054764
6131	Điểm hệ số 1 #1	1022	1	\N	2025-05-11 12:12:21.054764
6132	Điểm hệ số 1 #2	1022	1	\N	2025-05-11 12:12:21.054764
6133	Điểm hệ số 1 #3	1022	1	\N	2025-05-11 12:12:21.054764
6134	Điểm hệ số 2 #1	1022	2	\N	2025-05-11 12:12:21.054764
6135	Điểm hệ số 2 #2	1022	2	\N	2025-05-11 12:12:21.054764
6136	Điểm hệ số 3	1022	3	\N	2025-05-11 12:12:21.054764
6137	Điểm hệ số 1 #1	1023	1	\N	2025-05-11 12:12:21.054764
6138	Điểm hệ số 1 #2	1023	1	\N	2025-05-11 12:12:21.054764
6139	Điểm hệ số 1 #3	1023	1	\N	2025-05-11 12:12:21.054764
6140	Điểm hệ số 2 #1	1023	2	\N	2025-05-11 12:12:21.054764
6141	Điểm hệ số 2 #2	1023	2	\N	2025-05-11 12:12:21.054764
6142	Điểm hệ số 3	1023	3	\N	2025-05-11 12:12:21.054764
6143	Điểm hệ số 1 #1	1024	1	\N	2025-05-11 12:12:21.054764
6144	Điểm hệ số 1 #2	1024	1	\N	2025-05-11 12:12:21.054764
6145	Điểm hệ số 1 #3	1024	1	\N	2025-05-11 12:12:21.054764
6146	Điểm hệ số 2 #1	1024	2	\N	2025-05-11 12:12:21.054764
6147	Điểm hệ số 2 #2	1024	2	\N	2025-05-11 12:12:21.054764
6148	Điểm hệ số 3	1024	3	\N	2025-05-11 12:12:21.054764
6149	Điểm hệ số 1 #1	1025	1	\N	2025-05-11 12:12:21.054764
6150	Điểm hệ số 1 #2	1025	1	\N	2025-05-11 12:12:21.054764
6151	Điểm hệ số 1 #3	1025	1	\N	2025-05-11 12:12:21.054764
6152	Điểm hệ số 2 #1	1025	2	\N	2025-05-11 12:12:21.054764
6153	Điểm hệ số 2 #2	1025	2	\N	2025-05-11 12:12:21.054764
6154	Điểm hệ số 3	1025	3	\N	2025-05-11 12:12:21.054764
6155	Điểm hệ số 1 #1	1026	1	\N	2025-05-11 12:12:21.054764
6156	Điểm hệ số 1 #2	1026	1	\N	2025-05-11 12:12:21.054764
6157	Điểm hệ số 1 #3	1026	1	\N	2025-05-11 12:12:21.054764
6158	Điểm hệ số 2 #1	1026	2	\N	2025-05-11 12:12:21.054764
6159	Điểm hệ số 2 #2	1026	2	\N	2025-05-11 12:12:21.054764
6160	Điểm hệ số 3	1026	3	\N	2025-05-11 12:12:21.054764
6161	Điểm hệ số 1 #1	1027	1	\N	2025-05-11 12:12:21.054764
6162	Điểm hệ số 1 #2	1027	1	\N	2025-05-11 12:12:21.054764
6163	Điểm hệ số 1 #3	1027	1	\N	2025-05-11 12:12:21.054764
6164	Điểm hệ số 2 #1	1027	2	\N	2025-05-11 12:12:21.054764
6165	Điểm hệ số 2 #2	1027	2	\N	2025-05-11 12:12:21.054764
6166	Điểm hệ số 3	1027	3	\N	2025-05-11 12:12:21.054764
6167	Điểm hệ số 1 #1	1028	1	\N	2025-05-11 12:12:21.054764
6168	Điểm hệ số 1 #2	1028	1	\N	2025-05-11 12:12:21.054764
6169	Điểm hệ số 1 #3	1028	1	\N	2025-05-11 12:12:21.054764
6170	Điểm hệ số 2 #1	1028	2	\N	2025-05-11 12:12:21.054764
6171	Điểm hệ số 2 #2	1028	2	\N	2025-05-11 12:12:21.054764
6172	Điểm hệ số 3	1028	3	\N	2025-05-11 12:12:21.054764
6173	Điểm hệ số 1 #1	1029	1	\N	2025-05-11 12:12:21.054764
6174	Điểm hệ số 1 #2	1029	1	\N	2025-05-11 12:12:21.054764
6175	Điểm hệ số 1 #3	1029	1	\N	2025-05-11 12:12:21.054764
6176	Điểm hệ số 2 #1	1029	2	\N	2025-05-11 12:12:21.054764
6177	Điểm hệ số 2 #2	1029	2	\N	2025-05-11 12:12:21.054764
6178	Điểm hệ số 3	1029	3	\N	2025-05-11 12:12:21.054764
6179	Điểm hệ số 1 #1	1030	1	\N	2025-05-11 12:12:21.054764
6180	Điểm hệ số 1 #2	1030	1	\N	2025-05-11 12:12:21.054764
6181	Điểm hệ số 1 #3	1030	1	\N	2025-05-11 12:12:21.054764
6182	Điểm hệ số 2 #1	1030	2	\N	2025-05-11 12:12:21.054764
6183	Điểm hệ số 2 #2	1030	2	\N	2025-05-11 12:12:21.054764
6184	Điểm hệ số 3	1030	3	\N	2025-05-11 12:12:21.054764
6185	Điểm hệ số 1 #1	1031	1	\N	2025-05-11 12:12:21.054764
6186	Điểm hệ số 1 #2	1031	1	\N	2025-05-11 12:12:21.054764
6187	Điểm hệ số 1 #3	1031	1	\N	2025-05-11 12:12:21.054764
6188	Điểm hệ số 2 #1	1031	2	\N	2025-05-11 12:12:21.054764
6189	Điểm hệ số 2 #2	1031	2	\N	2025-05-11 12:12:21.054764
6190	Điểm hệ số 3	1031	3	\N	2025-05-11 12:12:21.054764
6191	Điểm hệ số 1 #1	1032	1	\N	2025-05-11 12:12:21.054764
6192	Điểm hệ số 1 #2	1032	1	\N	2025-05-11 12:12:21.054764
6193	Điểm hệ số 1 #3	1032	1	\N	2025-05-11 12:12:21.054764
6194	Điểm hệ số 2 #1	1032	2	\N	2025-05-11 12:12:21.054764
6195	Điểm hệ số 2 #2	1032	2	\N	2025-05-11 12:12:21.054764
6196	Điểm hệ số 3	1032	3	\N	2025-05-11 12:12:21.054764
6197	Điểm hệ số 1 #1	1033	1	\N	2025-05-11 12:12:21.054764
6198	Điểm hệ số 1 #2	1033	1	\N	2025-05-11 12:12:21.054764
6199	Điểm hệ số 1 #3	1033	1	\N	2025-05-11 12:12:21.054764
6200	Điểm hệ số 2 #1	1033	2	\N	2025-05-11 12:12:21.054764
6201	Điểm hệ số 2 #2	1033	2	\N	2025-05-11 12:12:21.054764
6202	Điểm hệ số 3	1033	3	\N	2025-05-11 12:12:21.054764
6203	Điểm hệ số 1 #1	1034	1	\N	2025-05-11 12:12:21.054764
6204	Điểm hệ số 1 #2	1034	1	\N	2025-05-11 12:12:21.054764
6205	Điểm hệ số 1 #3	1034	1	\N	2025-05-11 12:12:21.054764
6206	Điểm hệ số 2 #1	1034	2	\N	2025-05-11 12:12:21.054764
6207	Điểm hệ số 2 #2	1034	2	\N	2025-05-11 12:12:21.054764
6208	Điểm hệ số 3	1034	3	\N	2025-05-11 12:12:21.054764
6209	Điểm hệ số 1 #1	1035	1	\N	2025-05-11 12:12:21.054764
6210	Điểm hệ số 1 #2	1035	1	\N	2025-05-11 12:12:21.054764
6211	Điểm hệ số 1 #3	1035	1	\N	2025-05-11 12:12:21.054764
6212	Điểm hệ số 2 #1	1035	2	\N	2025-05-11 12:12:21.054764
6213	Điểm hệ số 2 #2	1035	2	\N	2025-05-11 12:12:21.054764
6214	Điểm hệ số 3	1035	3	\N	2025-05-11 12:12:21.054764
6215	Điểm hệ số 1 #1	1036	1	\N	2025-05-11 12:12:21.054764
6216	Điểm hệ số 1 #2	1036	1	\N	2025-05-11 12:12:21.054764
6217	Điểm hệ số 1 #3	1036	1	\N	2025-05-11 12:12:21.054764
6218	Điểm hệ số 2 #1	1036	2	\N	2025-05-11 12:12:21.054764
6219	Điểm hệ số 2 #2	1036	2	\N	2025-05-11 12:12:21.054764
6220	Điểm hệ số 3	1036	3	\N	2025-05-11 12:12:21.054764
6221	Điểm hệ số 1 #1	1037	1	\N	2025-05-11 12:12:21.054764
6222	Điểm hệ số 1 #2	1037	1	\N	2025-05-11 12:12:21.054764
6223	Điểm hệ số 1 #3	1037	1	\N	2025-05-11 12:12:21.054764
6224	Điểm hệ số 2 #1	1037	2	\N	2025-05-11 12:12:21.054764
6225	Điểm hệ số 2 #2	1037	2	\N	2025-05-11 12:12:21.054764
6226	Điểm hệ số 3	1037	3	\N	2025-05-11 12:12:21.054764
6227	Điểm hệ số 1 #1	1038	1	\N	2025-05-11 12:12:21.054764
6228	Điểm hệ số 1 #2	1038	1	\N	2025-05-11 12:12:21.054764
6229	Điểm hệ số 1 #3	1038	1	\N	2025-05-11 12:12:21.054764
6230	Điểm hệ số 2 #1	1038	2	\N	2025-05-11 12:12:21.054764
6231	Điểm hệ số 2 #2	1038	2	\N	2025-05-11 12:12:21.054764
6232	Điểm hệ số 3	1038	3	\N	2025-05-11 12:12:21.054764
6233	Điểm hệ số 1 #1	1039	1	\N	2025-05-11 12:12:21.054764
6234	Điểm hệ số 1 #2	1039	1	\N	2025-05-11 12:12:21.054764
6235	Điểm hệ số 1 #3	1039	1	\N	2025-05-11 12:12:21.054764
6236	Điểm hệ số 2 #1	1039	2	\N	2025-05-11 12:12:21.054764
6237	Điểm hệ số 2 #2	1039	2	\N	2025-05-11 12:12:21.054764
6238	Điểm hệ số 3	1039	3	\N	2025-05-11 12:12:21.054764
6239	Điểm hệ số 1 #1	1040	1	\N	2025-05-11 12:12:21.054764
6240	Điểm hệ số 1 #2	1040	1	\N	2025-05-11 12:12:21.054764
6241	Điểm hệ số 1 #3	1040	1	\N	2025-05-11 12:12:21.054764
6242	Điểm hệ số 2 #1	1040	2	\N	2025-05-11 12:12:21.054764
6243	Điểm hệ số 2 #2	1040	2	\N	2025-05-11 12:12:21.054764
6244	Điểm hệ số 3	1040	3	\N	2025-05-11 12:12:21.054764
6245	Điểm hệ số 1 #1	1041	1	\N	2025-05-11 12:12:21.054764
6246	Điểm hệ số 1 #2	1041	1	\N	2025-05-11 12:12:21.054764
6247	Điểm hệ số 1 #3	1041	1	\N	2025-05-11 12:12:21.054764
6248	Điểm hệ số 2 #1	1041	2	\N	2025-05-11 12:12:21.055755
6249	Điểm hệ số 2 #2	1041	2	\N	2025-05-11 12:12:21.055755
6250	Điểm hệ số 3	1041	3	\N	2025-05-11 12:12:21.055755
6251	Điểm hệ số 1 #1	1042	1	\N	2025-05-11 12:12:21.055755
6252	Điểm hệ số 1 #2	1042	1	\N	2025-05-11 12:12:21.055755
6253	Điểm hệ số 1 #3	1042	1	\N	2025-05-11 12:12:21.055755
6254	Điểm hệ số 2 #1	1042	2	\N	2025-05-11 12:12:21.055755
6255	Điểm hệ số 2 #2	1042	2	\N	2025-05-11 12:12:21.055755
6256	Điểm hệ số 3	1042	3	\N	2025-05-11 12:12:21.055755
6257	Điểm hệ số 1 #1	1043	1	\N	2025-05-11 12:12:21.055755
6258	Điểm hệ số 1 #2	1043	1	\N	2025-05-11 12:12:21.055755
6259	Điểm hệ số 1 #3	1043	1	\N	2025-05-11 12:12:21.055755
6260	Điểm hệ số 2 #1	1043	2	\N	2025-05-11 12:12:21.055755
6261	Điểm hệ số 2 #2	1043	2	\N	2025-05-11 12:12:21.055755
6262	Điểm hệ số 3	1043	3	\N	2025-05-11 12:12:21.055755
6263	Điểm hệ số 1 #1	1044	1	\N	2025-05-11 12:12:21.055755
6264	Điểm hệ số 1 #2	1044	1	\N	2025-05-11 12:12:21.055755
6265	Điểm hệ số 1 #3	1044	1	\N	2025-05-11 12:12:21.055755
6266	Điểm hệ số 2 #1	1044	2	\N	2025-05-11 12:12:21.055755
6267	Điểm hệ số 2 #2	1044	2	\N	2025-05-11 12:12:21.055755
6268	Điểm hệ số 3	1044	3	\N	2025-05-11 12:12:21.055755
6269	Điểm hệ số 1 #1	1045	1	\N	2025-05-11 12:12:21.055755
6270	Điểm hệ số 1 #2	1045	1	\N	2025-05-11 12:12:21.055755
6271	Điểm hệ số 1 #3	1045	1	\N	2025-05-11 12:12:21.055755
6272	Điểm hệ số 2 #1	1045	2	\N	2025-05-11 12:12:21.055755
6273	Điểm hệ số 2 #2	1045	2	\N	2025-05-11 12:12:21.055755
6274	Điểm hệ số 3	1045	3	\N	2025-05-11 12:12:21.055755
6275	Điểm hệ số 1 #1	1046	1	\N	2025-05-11 12:12:21.055755
6276	Điểm hệ số 1 #2	1046	1	\N	2025-05-11 12:12:21.055755
6277	Điểm hệ số 1 #3	1046	1	\N	2025-05-11 12:12:21.055755
6278	Điểm hệ số 2 #1	1046	2	\N	2025-05-11 12:12:21.055755
6279	Điểm hệ số 2 #2	1046	2	\N	2025-05-11 12:12:21.055755
6280	Điểm hệ số 3	1046	3	\N	2025-05-11 12:12:21.055755
6281	Điểm hệ số 1 #1	1047	1	\N	2025-05-11 12:12:21.055755
6282	Điểm hệ số 1 #2	1047	1	\N	2025-05-11 12:12:21.055755
6283	Điểm hệ số 1 #3	1047	1	\N	2025-05-11 12:12:21.055755
6284	Điểm hệ số 2 #1	1047	2	\N	2025-05-11 12:12:21.055755
6285	Điểm hệ số 2 #2	1047	2	\N	2025-05-11 12:12:21.055755
6286	Điểm hệ số 3	1047	3	\N	2025-05-11 12:12:21.055755
6287	Điểm hệ số 1 #1	1048	1	\N	2025-05-11 12:12:21.055755
6288	Điểm hệ số 1 #2	1048	1	\N	2025-05-11 12:12:21.055755
6289	Điểm hệ số 1 #3	1048	1	\N	2025-05-11 12:12:21.055755
6290	Điểm hệ số 2 #1	1048	2	\N	2025-05-11 12:12:21.055755
6291	Điểm hệ số 2 #2	1048	2	\N	2025-05-11 12:12:21.055755
6292	Điểm hệ số 3	1048	3	\N	2025-05-11 12:12:21.055755
6293	Điểm hệ số 1 #1	1049	1	\N	2025-05-11 12:12:21.055755
6294	Điểm hệ số 1 #2	1049	1	\N	2025-05-11 12:12:21.055755
6295	Điểm hệ số 1 #3	1049	1	\N	2025-05-11 12:12:21.055755
6296	Điểm hệ số 2 #1	1049	2	\N	2025-05-11 12:12:21.055755
6297	Điểm hệ số 2 #2	1049	2	\N	2025-05-11 12:12:21.055755
6298	Điểm hệ số 3	1049	3	\N	2025-05-11 12:12:21.055755
6299	Điểm hệ số 1 #1	1050	1	\N	2025-05-11 12:12:21.055755
6300	Điểm hệ số 1 #2	1050	1	\N	2025-05-11 12:12:21.055755
6301	Điểm hệ số 1 #3	1050	1	\N	2025-05-11 12:12:21.055755
6302	Điểm hệ số 2 #1	1050	2	\N	2025-05-11 12:12:21.055755
6303	Điểm hệ số 2 #2	1050	2	\N	2025-05-11 12:12:21.055755
6304	Điểm hệ số 3	1050	3	\N	2025-05-11 12:12:21.055755
6305	Điểm hệ số 1 #1	1051	1	\N	2025-05-11 12:12:21.055755
6306	Điểm hệ số 1 #2	1051	1	\N	2025-05-11 12:12:21.055755
6307	Điểm hệ số 1 #3	1051	1	\N	2025-05-11 12:12:21.055755
6308	Điểm hệ số 2 #1	1051	2	\N	2025-05-11 12:12:21.055755
6309	Điểm hệ số 2 #2	1051	2	\N	2025-05-11 12:12:21.055755
6310	Điểm hệ số 3	1051	3	\N	2025-05-11 12:12:21.055755
6311	Điểm hệ số 1 #1	1052	1	\N	2025-05-11 12:12:21.055755
6312	Điểm hệ số 1 #2	1052	1	\N	2025-05-11 12:12:21.055755
6313	Điểm hệ số 1 #3	1052	1	\N	2025-05-11 12:12:21.055755
6314	Điểm hệ số 2 #1	1052	2	\N	2025-05-11 12:12:21.055755
6315	Điểm hệ số 2 #2	1052	2	\N	2025-05-11 12:12:21.055755
6316	Điểm hệ số 3	1052	3	\N	2025-05-11 12:12:21.055755
6317	Điểm hệ số 1 #1	1053	1	\N	2025-05-11 12:12:21.055755
6318	Điểm hệ số 1 #2	1053	1	\N	2025-05-11 12:12:21.055755
6319	Điểm hệ số 1 #3	1053	1	\N	2025-05-11 12:12:21.055755
6320	Điểm hệ số 2 #1	1053	2	\N	2025-05-11 12:12:21.055755
6321	Điểm hệ số 2 #2	1053	2	\N	2025-05-11 12:12:21.055755
6322	Điểm hệ số 3	1053	3	\N	2025-05-11 12:12:21.055755
6323	Điểm hệ số 1 #1	1054	1	\N	2025-05-11 12:12:21.055755
6324	Điểm hệ số 1 #2	1054	1	\N	2025-05-11 12:12:21.055755
6325	Điểm hệ số 1 #3	1054	1	\N	2025-05-11 12:12:21.055755
6326	Điểm hệ số 2 #1	1054	2	\N	2025-05-11 12:12:21.055755
6327	Điểm hệ số 2 #2	1054	2	\N	2025-05-11 12:12:21.055755
6328	Điểm hệ số 3	1054	3	\N	2025-05-11 12:12:21.055755
6329	Điểm hệ số 1 #1	1055	1	\N	2025-05-11 12:12:21.055755
6330	Điểm hệ số 1 #2	1055	1	\N	2025-05-11 12:12:21.055755
6331	Điểm hệ số 1 #3	1055	1	\N	2025-05-11 12:12:21.055755
6332	Điểm hệ số 2 #1	1055	2	\N	2025-05-11 12:12:21.055755
6333	Điểm hệ số 2 #2	1055	2	\N	2025-05-11 12:12:21.055755
6334	Điểm hệ số 3	1055	3	\N	2025-05-11 12:12:21.055755
6335	Điểm hệ số 1 #1	1056	1	\N	2025-05-11 12:12:21.055755
6336	Điểm hệ số 1 #2	1056	1	\N	2025-05-11 12:12:21.055755
6337	Điểm hệ số 1 #3	1056	1	\N	2025-05-11 12:12:21.055755
6338	Điểm hệ số 2 #1	1056	2	\N	2025-05-11 12:12:21.055755
6339	Điểm hệ số 2 #2	1056	2	\N	2025-05-11 12:12:21.055755
6340	Điểm hệ số 3	1056	3	\N	2025-05-11 12:12:21.055755
6341	Điểm hệ số 1 #1	1057	1	\N	2025-05-11 12:12:21.055755
6342	Điểm hệ số 1 #2	1057	1	\N	2025-05-11 12:12:21.055755
6343	Điểm hệ số 1 #3	1057	1	\N	2025-05-11 12:12:21.055755
6344	Điểm hệ số 2 #1	1057	2	\N	2025-05-11 12:12:21.055755
6345	Điểm hệ số 2 #2	1057	2	\N	2025-05-11 12:12:21.055755
6346	Điểm hệ số 3	1057	3	\N	2025-05-11 12:12:21.055755
6347	Điểm hệ số 1 #1	1058	1	\N	2025-05-11 12:12:21.055755
6348	Điểm hệ số 1 #2	1058	1	\N	2025-05-11 12:12:21.055755
6349	Điểm hệ số 1 #3	1058	1	\N	2025-05-11 12:12:21.055755
6350	Điểm hệ số 2 #1	1058	2	\N	2025-05-11 12:12:21.055755
6351	Điểm hệ số 2 #2	1058	2	\N	2025-05-11 12:12:21.055755
6352	Điểm hệ số 3	1058	3	\N	2025-05-11 12:12:21.055755
6353	Điểm hệ số 1 #1	1059	1	\N	2025-05-11 12:12:21.055755
6354	Điểm hệ số 1 #2	1059	1	\N	2025-05-11 12:12:21.055755
6355	Điểm hệ số 1 #3	1059	1	\N	2025-05-11 12:12:21.055755
6356	Điểm hệ số 2 #1	1059	2	\N	2025-05-11 12:12:21.055755
6357	Điểm hệ số 2 #2	1059	2	\N	2025-05-11 12:12:21.055755
6358	Điểm hệ số 3	1059	3	\N	2025-05-11 12:12:21.055755
6359	Điểm hệ số 1 #1	1060	1	\N	2025-05-11 12:12:21.055755
6360	Điểm hệ số 1 #2	1060	1	\N	2025-05-11 12:12:21.055755
6361	Điểm hệ số 1 #3	1060	1	\N	2025-05-11 12:12:21.055755
6362	Điểm hệ số 2 #1	1060	2	\N	2025-05-11 12:12:21.055755
6363	Điểm hệ số 2 #2	1060	2	\N	2025-05-11 12:12:21.055755
6364	Điểm hệ số 3	1060	3	\N	2025-05-11 12:12:21.055755
6365	Điểm hệ số 1 #1	1061	1	\N	2025-05-11 12:12:21.055755
6366	Điểm hệ số 1 #2	1061	1	\N	2025-05-11 12:12:21.055755
6367	Điểm hệ số 1 #3	1061	1	\N	2025-05-11 12:12:21.055755
6368	Điểm hệ số 2 #1	1061	2	\N	2025-05-11 12:12:21.055755
6369	Điểm hệ số 2 #2	1061	2	\N	2025-05-11 12:12:21.055755
6370	Điểm hệ số 3	1061	3	\N	2025-05-11 12:12:21.055755
6371	Điểm hệ số 1 #1	1062	1	\N	2025-05-11 12:12:21.055755
6372	Điểm hệ số 1 #2	1062	1	\N	2025-05-11 12:12:21.055755
6373	Điểm hệ số 1 #3	1062	1	\N	2025-05-11 12:12:21.055755
6374	Điểm hệ số 2 #1	1062	2	\N	2025-05-11 12:12:21.055755
6375	Điểm hệ số 2 #2	1062	2	\N	2025-05-11 12:12:21.055755
6376	Điểm hệ số 3	1062	3	\N	2025-05-11 12:12:21.055755
6377	Điểm hệ số 1 #1	1063	1	\N	2025-05-11 12:12:21.055755
6378	Điểm hệ số 1 #2	1063	1	\N	2025-05-11 12:12:21.055755
6379	Điểm hệ số 1 #3	1063	1	\N	2025-05-11 12:12:21.055755
6380	Điểm hệ số 2 #1	1063	2	\N	2025-05-11 12:12:21.055755
6381	Điểm hệ số 2 #2	1063	2	\N	2025-05-11 12:12:21.055755
6382	Điểm hệ số 3	1063	3	\N	2025-05-11 12:12:21.055755
6383	Điểm hệ số 1 #1	1064	1	\N	2025-05-11 12:12:21.055755
6384	Điểm hệ số 1 #2	1064	1	\N	2025-05-11 12:12:21.055755
6385	Điểm hệ số 1 #3	1064	1	\N	2025-05-11 12:12:21.055755
6386	Điểm hệ số 2 #1	1064	2	\N	2025-05-11 12:12:21.055755
6387	Điểm hệ số 2 #2	1064	2	\N	2025-05-11 12:12:21.055755
6388	Điểm hệ số 3	1064	3	\N	2025-05-11 12:12:21.055755
6389	Điểm hệ số 1 #1	1065	1	\N	2025-05-11 12:12:21.055755
6390	Điểm hệ số 1 #2	1065	1	\N	2025-05-11 12:12:21.055755
6391	Điểm hệ số 1 #3	1065	1	\N	2025-05-11 12:12:21.055755
6392	Điểm hệ số 2 #1	1065	2	\N	2025-05-11 12:12:21.055755
6393	Điểm hệ số 2 #2	1065	2	\N	2025-05-11 12:12:21.055755
6394	Điểm hệ số 3	1065	3	\N	2025-05-11 12:12:21.055755
6395	Điểm hệ số 1 #1	1066	1	\N	2025-05-11 12:12:21.055755
6396	Điểm hệ số 1 #2	1066	1	\N	2025-05-11 12:12:21.055755
6397	Điểm hệ số 1 #3	1066	1	\N	2025-05-11 12:12:21.055755
6398	Điểm hệ số 2 #1	1066	2	\N	2025-05-11 12:12:21.055755
6399	Điểm hệ số 2 #2	1066	2	\N	2025-05-11 12:12:21.055755
6400	Điểm hệ số 3	1066	3	\N	2025-05-11 12:12:21.055755
6401	Điểm hệ số 1 #1	1067	1	\N	2025-05-11 12:12:21.055755
6402	Điểm hệ số 1 #2	1067	1	\N	2025-05-11 12:12:21.055755
6403	Điểm hệ số 1 #3	1067	1	\N	2025-05-11 12:12:21.055755
6404	Điểm hệ số 2 #1	1067	2	\N	2025-05-11 12:12:21.055755
6405	Điểm hệ số 2 #2	1067	2	\N	2025-05-11 12:12:21.055755
6406	Điểm hệ số 3	1067	3	\N	2025-05-11 12:12:21.055755
6407	Điểm hệ số 1 #1	1068	1	\N	2025-05-11 12:12:21.055755
6408	Điểm hệ số 1 #2	1068	1	\N	2025-05-11 12:12:21.055755
6409	Điểm hệ số 1 #3	1068	1	\N	2025-05-11 12:12:21.055755
6410	Điểm hệ số 2 #1	1068	2	\N	2025-05-11 12:12:21.055755
6411	Điểm hệ số 2 #2	1068	2	\N	2025-05-11 12:12:21.055755
6412	Điểm hệ số 3	1068	3	\N	2025-05-11 12:12:21.055755
6413	Điểm hệ số 1 #1	1069	1	\N	2025-05-11 12:12:21.055755
6414	Điểm hệ số 1 #2	1069	1	\N	2025-05-11 12:12:21.055755
6415	Điểm hệ số 1 #3	1069	1	\N	2025-05-11 12:12:21.055755
6416	Điểm hệ số 2 #1	1069	2	\N	2025-05-11 12:12:21.055755
6417	Điểm hệ số 2 #2	1069	2	\N	2025-05-11 12:12:21.055755
6418	Điểm hệ số 3	1069	3	\N	2025-05-11 12:12:21.055755
6419	Điểm hệ số 1 #1	1070	1	\N	2025-05-11 12:12:21.055755
6420	Điểm hệ số 1 #2	1070	1	\N	2025-05-11 12:12:21.055755
6421	Điểm hệ số 1 #3	1070	1	\N	2025-05-11 12:12:21.055755
6422	Điểm hệ số 2 #1	1070	2	\N	2025-05-11 12:12:21.055755
6423	Điểm hệ số 2 #2	1070	2	\N	2025-05-11 12:12:21.055755
6424	Điểm hệ số 3	1070	3	\N	2025-05-11 12:12:21.055755
6425	Điểm hệ số 1 #1	1071	1	\N	2025-05-11 12:12:21.055755
6426	Điểm hệ số 1 #2	1071	1	\N	2025-05-11 12:12:21.055755
6427	Điểm hệ số 1 #3	1071	1	\N	2025-05-11 12:12:21.055755
6428	Điểm hệ số 2 #1	1071	2	\N	2025-05-11 12:12:21.055755
6429	Điểm hệ số 2 #2	1071	2	\N	2025-05-11 12:12:21.055755
6430	Điểm hệ số 3	1071	3	\N	2025-05-11 12:12:21.055755
6431	Điểm hệ số 1 #1	1072	1	\N	2025-05-11 12:12:21.055755
6432	Điểm hệ số 1 #2	1072	1	\N	2025-05-11 12:12:21.055755
6433	Điểm hệ số 1 #3	1072	1	\N	2025-05-11 12:12:21.055755
6434	Điểm hệ số 2 #1	1072	2	\N	2025-05-11 12:12:21.055755
6435	Điểm hệ số 2 #2	1072	2	\N	2025-05-11 12:12:21.055755
6436	Điểm hệ số 3	1072	3	\N	2025-05-11 12:12:21.055755
6437	Điểm hệ số 1 #1	1073	1	\N	2025-05-11 12:12:21.055755
6438	Điểm hệ số 1 #2	1073	1	\N	2025-05-11 12:12:21.055755
6439	Điểm hệ số 1 #3	1073	1	\N	2025-05-11 12:12:21.055755
6440	Điểm hệ số 2 #1	1073	2	\N	2025-05-11 12:12:21.055755
6441	Điểm hệ số 2 #2	1073	2	\N	2025-05-11 12:12:21.055755
6442	Điểm hệ số 3	1073	3	\N	2025-05-11 12:12:21.055755
6443	Điểm hệ số 1 #1	1074	1	\N	2025-05-11 12:12:21.055755
6444	Điểm hệ số 1 #2	1074	1	\N	2025-05-11 12:12:21.055755
6445	Điểm hệ số 1 #3	1074	1	\N	2025-05-11 12:12:21.055755
6446	Điểm hệ số 2 #1	1074	2	\N	2025-05-11 12:12:21.055755
6447	Điểm hệ số 2 #2	1074	2	\N	2025-05-11 12:12:21.055755
6448	Điểm hệ số 3	1074	3	\N	2025-05-11 12:12:21.055755
6449	Điểm hệ số 1 #1	1075	1	\N	2025-05-11 12:12:21.055755
6450	Điểm hệ số 1 #2	1075	1	\N	2025-05-11 12:12:21.055755
6451	Điểm hệ số 1 #3	1075	1	\N	2025-05-11 12:12:21.055755
6452	Điểm hệ số 2 #1	1075	2	\N	2025-05-11 12:12:21.055755
6453	Điểm hệ số 2 #2	1075	2	\N	2025-05-11 12:12:21.055755
6454	Điểm hệ số 3	1075	3	\N	2025-05-11 12:12:21.055755
6455	Điểm hệ số 1 #1	1076	1	\N	2025-05-11 12:12:22.172083
6456	Điểm hệ số 1 #2	1076	1	\N	2025-05-11 12:12:22.172083
6457	Điểm hệ số 1 #3	1076	1	\N	2025-05-11 12:12:22.172083
6458	Điểm hệ số 2 #1	1076	2	\N	2025-05-11 12:12:22.172083
6459	Điểm hệ số 2 #2	1076	2	\N	2025-05-11 12:12:22.172083
6460	Điểm hệ số 3	1076	3	\N	2025-05-11 12:12:22.172083
6461	Điểm hệ số 1 #1	1077	1	\N	2025-05-11 12:12:22.172083
6462	Điểm hệ số 1 #2	1077	1	\N	2025-05-11 12:12:22.172083
6463	Điểm hệ số 1 #3	1077	1	\N	2025-05-11 12:12:22.172083
6464	Điểm hệ số 2 #1	1077	2	\N	2025-05-11 12:12:22.172083
6465	Điểm hệ số 2 #2	1077	2	\N	2025-05-11 12:12:22.172083
6466	Điểm hệ số 3	1077	3	\N	2025-05-11 12:12:22.172083
6467	Điểm hệ số 1 #1	1078	1	\N	2025-05-11 12:12:22.172083
6468	Điểm hệ số 1 #2	1078	1	\N	2025-05-11 12:12:22.172083
6469	Điểm hệ số 1 #3	1078	1	\N	2025-05-11 12:12:22.172083
6470	Điểm hệ số 2 #1	1078	2	\N	2025-05-11 12:12:22.172083
6471	Điểm hệ số 2 #2	1078	2	\N	2025-05-11 12:12:22.172083
6472	Điểm hệ số 3	1078	3	\N	2025-05-11 12:12:22.172083
6473	Điểm hệ số 1 #1	1079	1	\N	2025-05-11 12:12:22.172083
6474	Điểm hệ số 1 #2	1079	1	\N	2025-05-11 12:12:22.172083
6475	Điểm hệ số 1 #3	1079	1	\N	2025-05-11 12:12:22.172083
6476	Điểm hệ số 2 #1	1079	2	\N	2025-05-11 12:12:22.172083
6477	Điểm hệ số 2 #2	1079	2	\N	2025-05-11 12:12:22.172083
6478	Điểm hệ số 3	1079	3	\N	2025-05-11 12:12:22.172083
6479	Điểm hệ số 1 #1	1080	1	\N	2025-05-11 12:12:22.172083
6480	Điểm hệ số 1 #2	1080	1	\N	2025-05-11 12:12:22.172083
6481	Điểm hệ số 1 #3	1080	1	\N	2025-05-11 12:12:22.172083
6482	Điểm hệ số 2 #1	1080	2	\N	2025-05-11 12:12:22.172083
6483	Điểm hệ số 2 #2	1080	2	\N	2025-05-11 12:12:22.172083
6484	Điểm hệ số 3	1080	3	\N	2025-05-11 12:12:22.172083
6485	Điểm hệ số 1 #1	1081	1	\N	2025-05-11 12:12:22.172083
6486	Điểm hệ số 1 #2	1081	1	\N	2025-05-11 12:12:22.172083
6487	Điểm hệ số 1 #3	1081	1	\N	2025-05-11 12:12:22.172083
6488	Điểm hệ số 2 #1	1081	2	\N	2025-05-11 12:12:22.172083
6489	Điểm hệ số 2 #2	1081	2	\N	2025-05-11 12:12:22.172083
6490	Điểm hệ số 3	1081	3	\N	2025-05-11 12:12:22.172083
6491	Điểm hệ số 1 #1	1082	1	\N	2025-05-11 12:12:22.172083
6492	Điểm hệ số 1 #2	1082	1	\N	2025-05-11 12:12:22.172083
6493	Điểm hệ số 1 #3	1082	1	\N	2025-05-11 12:12:22.172083
6494	Điểm hệ số 2 #1	1082	2	\N	2025-05-11 12:12:22.172083
6495	Điểm hệ số 2 #2	1082	2	\N	2025-05-11 12:12:22.172083
6496	Điểm hệ số 3	1082	3	\N	2025-05-11 12:12:22.172083
6497	Điểm hệ số 1 #1	1083	1	\N	2025-05-11 12:12:22.172083
6498	Điểm hệ số 1 #2	1083	1	\N	2025-05-11 12:12:22.172083
6499	Điểm hệ số 1 #3	1083	1	\N	2025-05-11 12:12:22.172083
6500	Điểm hệ số 2 #1	1083	2	\N	2025-05-11 12:12:22.172083
6501	Điểm hệ số 2 #2	1083	2	\N	2025-05-11 12:12:22.172083
6502	Điểm hệ số 3	1083	3	\N	2025-05-11 12:12:22.172083
6503	Điểm hệ số 1 #1	1084	1	\N	2025-05-11 12:12:22.172083
6504	Điểm hệ số 1 #2	1084	1	\N	2025-05-11 12:12:22.172083
6505	Điểm hệ số 1 #3	1084	1	\N	2025-05-11 12:12:22.172083
6506	Điểm hệ số 2 #1	1084	2	\N	2025-05-11 12:12:22.172083
6507	Điểm hệ số 2 #2	1084	2	\N	2025-05-11 12:12:22.172083
6508	Điểm hệ số 3	1084	3	\N	2025-05-11 12:12:22.172083
6509	Điểm hệ số 1 #1	1085	1	\N	2025-05-11 12:12:22.172083
6510	Điểm hệ số 1 #2	1085	1	\N	2025-05-11 12:12:22.172083
6511	Điểm hệ số 1 #3	1085	1	\N	2025-05-11 12:12:22.172083
6512	Điểm hệ số 2 #1	1085	2	\N	2025-05-11 12:12:22.172083
6513	Điểm hệ số 2 #2	1085	2	\N	2025-05-11 12:12:22.172083
6514	Điểm hệ số 3	1085	3	\N	2025-05-11 12:12:22.172083
6515	Điểm hệ số 1 #1	1086	1	\N	2025-05-11 12:12:22.172083
6516	Điểm hệ số 1 #2	1086	1	\N	2025-05-11 12:12:22.172083
6517	Điểm hệ số 1 #3	1086	1	\N	2025-05-11 12:12:22.172083
6518	Điểm hệ số 2 #1	1086	2	\N	2025-05-11 12:12:22.172083
6519	Điểm hệ số 2 #2	1086	2	\N	2025-05-11 12:12:22.172083
6520	Điểm hệ số 3	1086	3	\N	2025-05-11 12:12:22.172083
6521	Điểm hệ số 1 #1	1087	1	\N	2025-05-11 12:12:22.172083
6522	Điểm hệ số 1 #2	1087	1	\N	2025-05-11 12:12:22.172083
6523	Điểm hệ số 1 #3	1087	1	\N	2025-05-11 12:12:22.172083
6524	Điểm hệ số 2 #1	1087	2	\N	2025-05-11 12:12:22.172083
6525	Điểm hệ số 2 #2	1087	2	\N	2025-05-11 12:12:22.172083
6526	Điểm hệ số 3	1087	3	\N	2025-05-11 12:12:22.172083
6527	Điểm hệ số 1 #1	1088	1	\N	2025-05-11 12:12:22.172083
6528	Điểm hệ số 1 #2	1088	1	\N	2025-05-11 12:12:22.172083
6529	Điểm hệ số 1 #3	1088	1	\N	2025-05-11 12:12:22.172083
6530	Điểm hệ số 2 #1	1088	2	\N	2025-05-11 12:12:22.172083
6531	Điểm hệ số 2 #2	1088	2	\N	2025-05-11 12:12:22.172083
6532	Điểm hệ số 3	1088	3	\N	2025-05-11 12:12:22.172083
6533	Điểm hệ số 1 #1	1089	1	\N	2025-05-11 12:12:22.172083
6534	Điểm hệ số 1 #2	1089	1	\N	2025-05-11 12:12:22.172083
6535	Điểm hệ số 1 #3	1089	1	\N	2025-05-11 12:12:22.172083
6536	Điểm hệ số 2 #1	1089	2	\N	2025-05-11 12:12:22.172083
6537	Điểm hệ số 2 #2	1089	2	\N	2025-05-11 12:12:22.172083
6538	Điểm hệ số 3	1089	3	\N	2025-05-11 12:12:22.172083
6539	Điểm hệ số 1 #1	1090	1	\N	2025-05-11 12:12:22.172083
6540	Điểm hệ số 1 #2	1090	1	\N	2025-05-11 12:12:22.172083
6541	Điểm hệ số 1 #3	1090	1	\N	2025-05-11 12:12:22.172083
6542	Điểm hệ số 2 #1	1090	2	\N	2025-05-11 12:12:22.172083
6543	Điểm hệ số 2 #2	1090	2	\N	2025-05-11 12:12:22.172083
6544	Điểm hệ số 3	1090	3	\N	2025-05-11 12:12:22.172083
6545	Điểm hệ số 1 #1	1091	1	\N	2025-05-11 12:12:22.172083
6546	Điểm hệ số 1 #2	1091	1	\N	2025-05-11 12:12:22.172083
6547	Điểm hệ số 1 #3	1091	1	\N	2025-05-11 12:12:22.172083
6548	Điểm hệ số 2 #1	1091	2	\N	2025-05-11 12:12:22.172083
6549	Điểm hệ số 2 #2	1091	2	\N	2025-05-11 12:12:22.172083
6550	Điểm hệ số 3	1091	3	\N	2025-05-11 12:12:22.172083
6551	Điểm hệ số 1 #1	1092	1	\N	2025-05-11 12:12:22.172083
6552	Điểm hệ số 1 #2	1092	1	\N	2025-05-11 12:12:22.172083
6553	Điểm hệ số 1 #3	1092	1	\N	2025-05-11 12:12:22.172083
6554	Điểm hệ số 2 #1	1092	2	\N	2025-05-11 12:12:22.172083
6555	Điểm hệ số 2 #2	1092	2	\N	2025-05-11 12:12:22.172083
6556	Điểm hệ số 3	1092	3	\N	2025-05-11 12:12:22.172083
6557	Điểm hệ số 1 #1	1093	1	\N	2025-05-11 12:12:22.172083
6558	Điểm hệ số 1 #2	1093	1	\N	2025-05-11 12:12:22.172083
6559	Điểm hệ số 1 #3	1093	1	\N	2025-05-11 12:12:22.172083
6560	Điểm hệ số 2 #1	1093	2	\N	2025-05-11 12:12:22.172083
6561	Điểm hệ số 2 #2	1093	2	\N	2025-05-11 12:12:22.172083
6562	Điểm hệ số 3	1093	3	\N	2025-05-11 12:12:22.172083
6563	Điểm hệ số 1 #1	1094	1	\N	2025-05-11 12:12:22.172083
6564	Điểm hệ số 1 #2	1094	1	\N	2025-05-11 12:12:22.172083
6565	Điểm hệ số 1 #3	1094	1	\N	2025-05-11 12:12:22.172083
6566	Điểm hệ số 2 #1	1094	2	\N	2025-05-11 12:12:22.172083
6567	Điểm hệ số 2 #2	1094	2	\N	2025-05-11 12:12:22.172083
6568	Điểm hệ số 3	1094	3	\N	2025-05-11 12:12:22.172083
6569	Điểm hệ số 1 #1	1095	1	\N	2025-05-11 12:12:22.172083
6570	Điểm hệ số 1 #2	1095	1	\N	2025-05-11 12:12:22.172083
6571	Điểm hệ số 1 #3	1095	1	\N	2025-05-11 12:12:22.172083
6572	Điểm hệ số 2 #1	1095	2	\N	2025-05-11 12:12:22.173077
6573	Điểm hệ số 2 #2	1095	2	\N	2025-05-11 12:12:22.173077
6574	Điểm hệ số 3	1095	3	\N	2025-05-11 12:12:22.173077
6575	Điểm hệ số 1 #1	1096	1	\N	2025-05-11 12:12:22.173077
6576	Điểm hệ số 1 #2	1096	1	\N	2025-05-11 12:12:22.173077
6577	Điểm hệ số 1 #3	1096	1	\N	2025-05-11 12:12:22.173077
6578	Điểm hệ số 2 #1	1096	2	\N	2025-05-11 12:12:22.173077
6579	Điểm hệ số 2 #2	1096	2	\N	2025-05-11 12:12:22.173077
6580	Điểm hệ số 3	1096	3	\N	2025-05-11 12:12:22.173077
6581	Điểm hệ số 1 #1	1097	1	\N	2025-05-11 12:12:22.173077
6582	Điểm hệ số 1 #2	1097	1	\N	2025-05-11 12:12:22.173077
6583	Điểm hệ số 1 #3	1097	1	\N	2025-05-11 12:12:22.173077
6584	Điểm hệ số 2 #1	1097	2	\N	2025-05-11 12:12:22.173077
6585	Điểm hệ số 2 #2	1097	2	\N	2025-05-11 12:12:22.173077
6586	Điểm hệ số 3	1097	3	\N	2025-05-11 12:12:22.173077
6587	Điểm hệ số 1 #1	1098	1	\N	2025-05-11 12:12:22.173077
6588	Điểm hệ số 1 #2	1098	1	\N	2025-05-11 12:12:22.173077
6589	Điểm hệ số 1 #3	1098	1	\N	2025-05-11 12:12:22.173077
6590	Điểm hệ số 2 #1	1098	2	\N	2025-05-11 12:12:22.173077
6591	Điểm hệ số 2 #2	1098	2	\N	2025-05-11 12:12:22.173077
6592	Điểm hệ số 3	1098	3	\N	2025-05-11 12:12:22.173077
6593	Điểm hệ số 1 #1	1099	1	\N	2025-05-11 12:12:22.173077
6594	Điểm hệ số 1 #2	1099	1	\N	2025-05-11 12:12:22.173077
6595	Điểm hệ số 1 #3	1099	1	\N	2025-05-11 12:12:22.173077
6596	Điểm hệ số 2 #1	1099	2	\N	2025-05-11 12:12:22.173077
6597	Điểm hệ số 2 #2	1099	2	\N	2025-05-11 12:12:22.173077
6598	Điểm hệ số 3	1099	3	\N	2025-05-11 12:12:22.173077
6599	Điểm hệ số 1 #1	1100	1	\N	2025-05-11 12:12:22.173077
6600	Điểm hệ số 1 #2	1100	1	\N	2025-05-11 12:12:22.173077
6601	Điểm hệ số 1 #3	1100	1	\N	2025-05-11 12:12:22.173077
6602	Điểm hệ số 2 #1	1100	2	\N	2025-05-11 12:12:22.173077
6603	Điểm hệ số 2 #2	1100	2	\N	2025-05-11 12:12:22.173077
6604	Điểm hệ số 3	1100	3	\N	2025-05-11 12:12:22.173077
6605	Điểm hệ số 1 #1	1101	1	\N	2025-05-11 12:12:22.173077
6606	Điểm hệ số 1 #2	1101	1	\N	2025-05-11 12:12:22.173077
6607	Điểm hệ số 1 #3	1101	1	\N	2025-05-11 12:12:22.173077
6608	Điểm hệ số 2 #1	1101	2	\N	2025-05-11 12:12:22.173077
6609	Điểm hệ số 2 #2	1101	2	\N	2025-05-11 12:12:22.173077
6610	Điểm hệ số 3	1101	3	\N	2025-05-11 12:12:22.173077
6611	Điểm hệ số 1 #1	1102	1	\N	2025-05-11 12:12:22.173077
6612	Điểm hệ số 1 #2	1102	1	\N	2025-05-11 12:12:22.173077
6613	Điểm hệ số 1 #3	1102	1	\N	2025-05-11 12:12:22.173077
6614	Điểm hệ số 2 #1	1102	2	\N	2025-05-11 12:12:22.173077
6615	Điểm hệ số 2 #2	1102	2	\N	2025-05-11 12:12:22.173077
6616	Điểm hệ số 3	1102	3	\N	2025-05-11 12:12:22.173077
6617	Điểm hệ số 1 #1	1103	1	\N	2025-05-11 12:12:22.173077
6618	Điểm hệ số 1 #2	1103	1	\N	2025-05-11 12:12:22.173077
6619	Điểm hệ số 1 #3	1103	1	\N	2025-05-11 12:12:22.173077
6620	Điểm hệ số 2 #1	1103	2	\N	2025-05-11 12:12:22.173077
6621	Điểm hệ số 2 #2	1103	2	\N	2025-05-11 12:12:22.173077
6622	Điểm hệ số 3	1103	3	\N	2025-05-11 12:12:22.173077
6623	Điểm hệ số 1 #1	1104	1	\N	2025-05-11 12:12:22.173077
6624	Điểm hệ số 1 #2	1104	1	\N	2025-05-11 12:12:22.173077
6625	Điểm hệ số 1 #3	1104	1	\N	2025-05-11 12:12:22.173077
6626	Điểm hệ số 2 #1	1104	2	\N	2025-05-11 12:12:22.173077
6627	Điểm hệ số 2 #2	1104	2	\N	2025-05-11 12:12:22.173077
6628	Điểm hệ số 3	1104	3	\N	2025-05-11 12:12:22.173077
6629	Điểm hệ số 1 #1	1105	1	\N	2025-05-11 12:12:22.173077
6630	Điểm hệ số 1 #2	1105	1	\N	2025-05-11 12:12:22.173077
6631	Điểm hệ số 1 #3	1105	1	\N	2025-05-11 12:12:22.173077
6632	Điểm hệ số 2 #1	1105	2	\N	2025-05-11 12:12:22.173077
6633	Điểm hệ số 2 #2	1105	2	\N	2025-05-11 12:12:22.173077
6634	Điểm hệ số 3	1105	3	\N	2025-05-11 12:12:22.173077
6635	Điểm hệ số 1 #1	1106	1	\N	2025-05-11 12:12:22.173077
6636	Điểm hệ số 1 #2	1106	1	\N	2025-05-11 12:12:22.173077
6637	Điểm hệ số 1 #3	1106	1	\N	2025-05-11 12:12:22.173077
6638	Điểm hệ số 2 #1	1106	2	\N	2025-05-11 12:12:22.173077
6639	Điểm hệ số 2 #2	1106	2	\N	2025-05-11 12:12:22.173077
6640	Điểm hệ số 3	1106	3	\N	2025-05-11 12:12:22.173077
6641	Điểm hệ số 1 #1	1107	1	\N	2025-05-11 12:12:22.173077
6642	Điểm hệ số 1 #2	1107	1	\N	2025-05-11 12:12:22.173077
6643	Điểm hệ số 1 #3	1107	1	\N	2025-05-11 12:12:22.173077
6644	Điểm hệ số 2 #1	1107	2	\N	2025-05-11 12:12:22.173077
6645	Điểm hệ số 2 #2	1107	2	\N	2025-05-11 12:12:22.173077
6646	Điểm hệ số 3	1107	3	\N	2025-05-11 12:12:22.173077
6647	Điểm hệ số 1 #1	1108	1	\N	2025-05-11 12:12:22.173077
6648	Điểm hệ số 1 #2	1108	1	\N	2025-05-11 12:12:22.173077
6649	Điểm hệ số 1 #3	1108	1	\N	2025-05-11 12:12:22.173077
6650	Điểm hệ số 2 #1	1108	2	\N	2025-05-11 12:12:22.173077
6651	Điểm hệ số 2 #2	1108	2	\N	2025-05-11 12:12:22.173077
6652	Điểm hệ số 3	1108	3	\N	2025-05-11 12:12:22.173077
6653	Điểm hệ số 1 #1	1109	1	\N	2025-05-11 12:12:22.173077
6654	Điểm hệ số 1 #2	1109	1	\N	2025-05-11 12:12:22.173077
6655	Điểm hệ số 1 #3	1109	1	\N	2025-05-11 12:12:22.173077
6656	Điểm hệ số 2 #1	1109	2	\N	2025-05-11 12:12:22.173077
6657	Điểm hệ số 2 #2	1109	2	\N	2025-05-11 12:12:22.173077
6658	Điểm hệ số 3	1109	3	\N	2025-05-11 12:12:22.173077
6659	Điểm hệ số 1 #1	1110	1	\N	2025-05-11 12:12:22.173077
6660	Điểm hệ số 1 #2	1110	1	\N	2025-05-11 12:12:22.173077
6661	Điểm hệ số 1 #3	1110	1	\N	2025-05-11 12:12:22.173077
6662	Điểm hệ số 2 #1	1110	2	\N	2025-05-11 12:12:22.173077
6663	Điểm hệ số 2 #2	1110	2	\N	2025-05-11 12:12:22.173077
6664	Điểm hệ số 3	1110	3	\N	2025-05-11 12:12:22.173077
6665	Điểm hệ số 1 #1	1111	1	\N	2025-05-11 12:12:22.173077
6666	Điểm hệ số 1 #2	1111	1	\N	2025-05-11 12:12:22.173077
6667	Điểm hệ số 1 #3	1111	1	\N	2025-05-11 12:12:22.173077
6668	Điểm hệ số 2 #1	1111	2	\N	2025-05-11 12:12:22.173077
6669	Điểm hệ số 2 #2	1111	2	\N	2025-05-11 12:12:22.173077
6670	Điểm hệ số 3	1111	3	\N	2025-05-11 12:12:22.173077
6671	Điểm hệ số 1 #1	1112	1	\N	2025-05-11 12:12:22.173077
6672	Điểm hệ số 1 #2	1112	1	\N	2025-05-11 12:12:22.173077
6673	Điểm hệ số 1 #3	1112	1	\N	2025-05-11 12:12:22.173077
6674	Điểm hệ số 2 #1	1112	2	\N	2025-05-11 12:12:22.173077
6675	Điểm hệ số 2 #2	1112	2	\N	2025-05-11 12:12:22.173077
6676	Điểm hệ số 3	1112	3	\N	2025-05-11 12:12:22.173077
6677	Điểm hệ số 1 #1	1113	1	\N	2025-05-11 12:12:22.173077
6678	Điểm hệ số 1 #2	1113	1	\N	2025-05-11 12:12:22.173077
6679	Điểm hệ số 1 #3	1113	1	\N	2025-05-11 12:12:22.173077
6680	Điểm hệ số 2 #1	1113	2	\N	2025-05-11 12:12:22.173077
6681	Điểm hệ số 2 #2	1113	2	\N	2025-05-11 12:12:22.173077
6682	Điểm hệ số 3	1113	3	\N	2025-05-11 12:12:22.173077
6683	Điểm hệ số 1 #1	1114	1	\N	2025-05-11 12:12:22.173077
6684	Điểm hệ số 1 #2	1114	1	\N	2025-05-11 12:12:22.173077
6685	Điểm hệ số 1 #3	1114	1	\N	2025-05-11 12:12:22.173077
6686	Điểm hệ số 2 #1	1114	2	\N	2025-05-11 12:12:22.173077
6687	Điểm hệ số 2 #2	1114	2	\N	2025-05-11 12:12:22.173077
6688	Điểm hệ số 3	1114	3	\N	2025-05-11 12:12:22.173077
6689	Điểm hệ số 1 #1	1115	1	\N	2025-05-11 12:12:22.173077
6690	Điểm hệ số 1 #2	1115	1	\N	2025-05-11 12:12:22.173077
6691	Điểm hệ số 1 #3	1115	1	\N	2025-05-11 12:12:22.173077
6692	Điểm hệ số 2 #1	1115	2	\N	2025-05-11 12:12:22.173077
6693	Điểm hệ số 2 #2	1115	2	\N	2025-05-11 12:12:22.173077
6694	Điểm hệ số 3	1115	3	\N	2025-05-11 12:12:22.173077
6695	Điểm hệ số 1 #1	1116	1	\N	2025-05-11 12:12:22.173077
6696	Điểm hệ số 1 #2	1116	1	\N	2025-05-11 12:12:22.173077
6697	Điểm hệ số 1 #3	1116	1	\N	2025-05-11 12:12:22.173077
6698	Điểm hệ số 2 #1	1116	2	\N	2025-05-11 12:12:22.173077
6699	Điểm hệ số 2 #2	1116	2	\N	2025-05-11 12:12:22.173077
6700	Điểm hệ số 3	1116	3	\N	2025-05-11 12:12:22.173077
6701	Điểm hệ số 1 #1	1117	1	\N	2025-05-11 12:12:22.173077
6702	Điểm hệ số 1 #2	1117	1	\N	2025-05-11 12:12:22.173077
6703	Điểm hệ số 1 #3	1117	1	\N	2025-05-11 12:12:22.173077
6704	Điểm hệ số 2 #1	1117	2	\N	2025-05-11 12:12:22.173077
6705	Điểm hệ số 2 #2	1117	2	\N	2025-05-11 12:12:22.173077
6706	Điểm hệ số 3	1117	3	\N	2025-05-11 12:12:22.173077
6707	Điểm hệ số 1 #1	1118	1	\N	2025-05-11 12:12:22.173077
6708	Điểm hệ số 1 #2	1118	1	\N	2025-05-11 12:12:22.173077
6709	Điểm hệ số 1 #3	1118	1	\N	2025-05-11 12:12:22.173077
6710	Điểm hệ số 2 #1	1118	2	\N	2025-05-11 12:12:22.173077
6711	Điểm hệ số 2 #2	1118	2	\N	2025-05-11 12:12:22.173077
6712	Điểm hệ số 3	1118	3	\N	2025-05-11 12:12:22.173077
6713	Điểm hệ số 1 #1	1119	1	\N	2025-05-11 12:12:22.173077
6714	Điểm hệ số 1 #2	1119	1	\N	2025-05-11 12:12:22.173077
6715	Điểm hệ số 1 #3	1119	1	\N	2025-05-11 12:12:22.173077
6716	Điểm hệ số 2 #1	1119	2	\N	2025-05-11 12:12:22.173077
6717	Điểm hệ số 2 #2	1119	2	\N	2025-05-11 12:12:22.173077
6718	Điểm hệ số 3	1119	3	\N	2025-05-11 12:12:22.173077
6719	Điểm hệ số 1 #1	1120	1	\N	2025-05-11 12:12:22.173077
6720	Điểm hệ số 1 #2	1120	1	\N	2025-05-11 12:12:22.173077
6721	Điểm hệ số 1 #3	1120	1	\N	2025-05-11 12:12:22.173077
6722	Điểm hệ số 2 #1	1120	2	\N	2025-05-11 12:12:22.173077
6723	Điểm hệ số 2 #2	1120	2	\N	2025-05-11 12:12:22.173077
6724	Điểm hệ số 3	1120	3	\N	2025-05-11 12:12:22.173077
6725	Điểm hệ số 1 #1	1121	1	\N	2025-05-11 12:12:22.173077
6726	Điểm hệ số 1 #2	1121	1	\N	2025-05-11 12:12:22.173077
6727	Điểm hệ số 1 #3	1121	1	\N	2025-05-11 12:12:22.173077
6728	Điểm hệ số 2 #1	1121	2	\N	2025-05-11 12:12:22.173077
6729	Điểm hệ số 2 #2	1121	2	\N	2025-05-11 12:12:22.173077
6730	Điểm hệ số 3	1121	3	\N	2025-05-11 12:12:22.173077
6731	Điểm hệ số 1 #1	1122	1	\N	2025-05-11 12:12:22.173077
6732	Điểm hệ số 1 #2	1122	1	\N	2025-05-11 12:12:22.173077
6733	Điểm hệ số 1 #3	1122	1	\N	2025-05-11 12:12:22.173077
6734	Điểm hệ số 2 #1	1122	2	\N	2025-05-11 12:12:22.173077
6735	Điểm hệ số 2 #2	1122	2	\N	2025-05-11 12:12:22.173077
6736	Điểm hệ số 3	1122	3	\N	2025-05-11 12:12:22.173077
6737	Điểm hệ số 1 #1	1123	1	\N	2025-05-11 12:12:22.173077
6738	Điểm hệ số 1 #2	1123	1	\N	2025-05-11 12:12:22.173077
6739	Điểm hệ số 1 #3	1123	1	\N	2025-05-11 12:12:22.173077
6740	Điểm hệ số 2 #1	1123	2	\N	2025-05-11 12:12:22.173077
6741	Điểm hệ số 2 #2	1123	2	\N	2025-05-11 12:12:22.173077
6742	Điểm hệ số 3	1123	3	\N	2025-05-11 12:12:22.173077
6743	Điểm hệ số 1 #1	1124	1	\N	2025-05-11 12:12:22.173077
6744	Điểm hệ số 1 #2	1124	1	\N	2025-05-11 12:12:22.173077
6745	Điểm hệ số 1 #3	1124	1	\N	2025-05-11 12:12:22.173077
6746	Điểm hệ số 2 #1	1124	2	\N	2025-05-11 12:12:22.173077
6747	Điểm hệ số 2 #2	1124	2	\N	2025-05-11 12:12:22.173077
6748	Điểm hệ số 3	1124	3	\N	2025-05-11 12:12:22.173077
6749	Điểm hệ số 1 #1	1125	1	\N	2025-05-11 12:12:22.173077
6750	Điểm hệ số 1 #2	1125	1	\N	2025-05-11 12:12:22.173077
6751	Điểm hệ số 1 #3	1125	1	\N	2025-05-11 12:12:22.173077
6752	Điểm hệ số 2 #1	1125	2	\N	2025-05-11 12:12:22.173077
6753	Điểm hệ số 2 #2	1125	2	\N	2025-05-11 12:12:22.173077
6754	Điểm hệ số 3	1125	3	\N	2025-05-11 12:12:22.173077
6755	Điểm hệ số 1 #1	1126	1	\N	2025-05-11 12:12:22.173077
6756	Điểm hệ số 1 #2	1126	1	\N	2025-05-11 12:12:22.173077
6757	Điểm hệ số 1 #3	1126	1	\N	2025-05-11 12:12:22.173077
6758	Điểm hệ số 2 #1	1126	2	\N	2025-05-11 12:12:22.173077
6759	Điểm hệ số 2 #2	1126	2	\N	2025-05-11 12:12:22.173077
6760	Điểm hệ số 3	1126	3	\N	2025-05-11 12:12:22.173077
6761	Điểm hệ số 1 #1	1127	1	\N	2025-05-11 12:12:22.173077
6762	Điểm hệ số 1 #2	1127	1	\N	2025-05-11 12:12:22.173077
6763	Điểm hệ số 1 #3	1127	1	\N	2025-05-11 12:12:22.173077
6764	Điểm hệ số 2 #1	1127	2	\N	2025-05-11 12:12:22.173077
6765	Điểm hệ số 2 #2	1127	2	\N	2025-05-11 12:12:22.173077
6766	Điểm hệ số 3	1127	3	\N	2025-05-11 12:12:22.173077
6767	Điểm hệ số 1 #1	1128	1	\N	2025-05-11 12:12:22.173077
6768	Điểm hệ số 1 #2	1128	1	\N	2025-05-11 12:12:22.173077
6769	Điểm hệ số 1 #3	1128	1	\N	2025-05-11 12:12:22.173077
6770	Điểm hệ số 2 #1	1128	2	\N	2025-05-11 12:12:22.173077
6771	Điểm hệ số 2 #2	1128	2	\N	2025-05-11 12:12:22.173077
6772	Điểm hệ số 3	1128	3	\N	2025-05-11 12:12:22.173077
6773	Điểm hệ số 1 #1	1129	1	\N	2025-05-11 12:12:22.173077
6774	Điểm hệ số 1 #2	1129	1	\N	2025-05-11 12:12:22.173077
6775	Điểm hệ số 1 #3	1129	1	\N	2025-05-11 12:12:22.174069
6776	Điểm hệ số 2 #1	1129	2	\N	2025-05-11 12:12:22.174069
6777	Điểm hệ số 2 #2	1129	2	\N	2025-05-11 12:12:22.174069
6778	Điểm hệ số 3	1129	3	\N	2025-05-11 12:12:22.174069
6779	Điểm hệ số 1 #1	1130	1	\N	2025-05-11 12:12:22.174069
6780	Điểm hệ số 1 #2	1130	1	\N	2025-05-11 12:12:22.174069
6781	Điểm hệ số 1 #3	1130	1	\N	2025-05-11 12:12:22.174069
6782	Điểm hệ số 2 #1	1130	2	\N	2025-05-11 12:12:22.174069
6783	Điểm hệ số 2 #2	1130	2	\N	2025-05-11 12:12:22.174069
6784	Điểm hệ số 3	1130	3	\N	2025-05-11 12:12:22.174069
6785	Điểm hệ số 1 #1	1131	1	\N	2025-05-11 12:12:22.174069
6786	Điểm hệ số 1 #2	1131	1	\N	2025-05-11 12:12:22.174069
6787	Điểm hệ số 1 #3	1131	1	\N	2025-05-11 12:12:22.174069
6788	Điểm hệ số 2 #1	1131	2	\N	2025-05-11 12:12:22.174069
6789	Điểm hệ số 2 #2	1131	2	\N	2025-05-11 12:12:22.174069
6790	Điểm hệ số 3	1131	3	\N	2025-05-11 12:12:22.174069
6791	Điểm hệ số 1 #1	1132	1	\N	2025-05-11 12:12:22.174069
6792	Điểm hệ số 1 #2	1132	1	\N	2025-05-11 12:12:22.174069
6793	Điểm hệ số 1 #3	1132	1	\N	2025-05-11 12:12:22.174069
6794	Điểm hệ số 2 #1	1132	2	\N	2025-05-11 12:12:22.174069
6795	Điểm hệ số 2 #2	1132	2	\N	2025-05-11 12:12:22.174069
6796	Điểm hệ số 3	1132	3	\N	2025-05-11 12:12:22.174069
6797	Điểm hệ số 1 #1	1133	1	\N	2025-05-11 12:12:22.174069
6798	Điểm hệ số 1 #2	1133	1	\N	2025-05-11 12:12:22.174069
6799	Điểm hệ số 1 #3	1133	1	\N	2025-05-11 12:12:22.174069
6800	Điểm hệ số 2 #1	1133	2	\N	2025-05-11 12:12:22.174069
6801	Điểm hệ số 2 #2	1133	2	\N	2025-05-11 12:12:22.174069
6802	Điểm hệ số 3	1133	3	\N	2025-05-11 12:12:22.174069
6803	Điểm hệ số 1 #1	1134	1	\N	2025-05-11 12:12:22.174069
6804	Điểm hệ số 1 #2	1134	1	\N	2025-05-11 12:12:22.174069
6805	Điểm hệ số 1 #3	1134	1	\N	2025-05-11 12:12:22.174069
6806	Điểm hệ số 2 #1	1134	2	\N	2025-05-11 12:12:22.174069
6807	Điểm hệ số 2 #2	1134	2	\N	2025-05-11 12:12:22.174069
6808	Điểm hệ số 3	1134	3	\N	2025-05-11 12:12:22.174069
6809	Điểm hệ số 1 #1	1135	1	\N	2025-05-11 12:12:22.174069
6810	Điểm hệ số 1 #2	1135	1	\N	2025-05-11 12:12:22.174069
6811	Điểm hệ số 1 #3	1135	1	\N	2025-05-11 12:12:22.174069
6812	Điểm hệ số 2 #1	1135	2	\N	2025-05-11 12:12:22.174069
6813	Điểm hệ số 2 #2	1135	2	\N	2025-05-11 12:12:22.174069
6814	Điểm hệ số 3	1135	3	\N	2025-05-11 12:12:22.174069
6815	Điểm hệ số 1 #1	1136	1	\N	2025-05-11 12:12:22.174069
6816	Điểm hệ số 1 #2	1136	1	\N	2025-05-11 12:12:22.174069
6817	Điểm hệ số 1 #3	1136	1	\N	2025-05-11 12:12:22.174069
6818	Điểm hệ số 2 #1	1136	2	\N	2025-05-11 12:12:22.174069
6819	Điểm hệ số 2 #2	1136	2	\N	2025-05-11 12:12:22.174069
6820	Điểm hệ số 3	1136	3	\N	2025-05-11 12:12:22.174069
6821	Điểm hệ số 1 #1	1137	1	\N	2025-05-11 12:12:22.174069
6822	Điểm hệ số 1 #2	1137	1	\N	2025-05-11 12:12:22.174069
6823	Điểm hệ số 1 #3	1137	1	\N	2025-05-11 12:12:22.174069
6824	Điểm hệ số 2 #1	1137	2	\N	2025-05-11 12:12:22.174069
6825	Điểm hệ số 2 #2	1137	2	\N	2025-05-11 12:12:22.174069
6826	Điểm hệ số 3	1137	3	\N	2025-05-11 12:12:22.174069
6827	Điểm hệ số 1 #1	1138	1	\N	2025-05-11 12:12:22.174069
6828	Điểm hệ số 1 #2	1138	1	\N	2025-05-11 12:12:22.174069
6829	Điểm hệ số 1 #3	1138	1	\N	2025-05-11 12:12:22.174069
6830	Điểm hệ số 2 #1	1138	2	\N	2025-05-11 12:12:22.174069
6831	Điểm hệ số 2 #2	1138	2	\N	2025-05-11 12:12:22.174069
6832	Điểm hệ số 3	1138	3	\N	2025-05-11 12:12:22.174069
6833	Điểm hệ số 1 #1	1139	1	\N	2025-05-11 12:12:22.174069
6834	Điểm hệ số 1 #2	1139	1	\N	2025-05-11 12:12:22.174069
6835	Điểm hệ số 1 #3	1139	1	\N	2025-05-11 12:12:22.174069
6836	Điểm hệ số 2 #1	1139	2	\N	2025-05-11 12:12:22.174069
6837	Điểm hệ số 2 #2	1139	2	\N	2025-05-11 12:12:22.174069
6838	Điểm hệ số 3	1139	3	\N	2025-05-11 12:12:22.174069
6839	Điểm hệ số 1 #1	1140	1	\N	2025-05-11 12:12:22.174069
6840	Điểm hệ số 1 #2	1140	1	\N	2025-05-11 12:12:22.174069
6841	Điểm hệ số 1 #3	1140	1	\N	2025-05-11 12:12:22.174069
6842	Điểm hệ số 2 #1	1140	2	\N	2025-05-11 12:12:22.174069
6843	Điểm hệ số 2 #2	1140	2	\N	2025-05-11 12:12:22.174069
6844	Điểm hệ số 3	1140	3	\N	2025-05-11 12:12:22.174069
6845	Điểm hệ số 1 #1	1141	1	\N	2025-05-11 12:12:22.174069
6846	Điểm hệ số 1 #2	1141	1	\N	2025-05-11 12:12:22.174069
6847	Điểm hệ số 1 #3	1141	1	\N	2025-05-11 12:12:22.174069
6848	Điểm hệ số 2 #1	1141	2	\N	2025-05-11 12:12:22.174069
6849	Điểm hệ số 2 #2	1141	2	\N	2025-05-11 12:12:22.174069
6850	Điểm hệ số 3	1141	3	\N	2025-05-11 12:12:22.174069
6851	Điểm hệ số 1 #1	1142	1	\N	2025-05-11 12:12:22.174069
6852	Điểm hệ số 1 #2	1142	1	\N	2025-05-11 12:12:22.174069
6853	Điểm hệ số 1 #3	1142	1	\N	2025-05-11 12:12:22.174069
6854	Điểm hệ số 2 #1	1142	2	\N	2025-05-11 12:12:22.174069
6855	Điểm hệ số 2 #2	1142	2	\N	2025-05-11 12:12:22.174069
6856	Điểm hệ số 3	1142	3	\N	2025-05-11 12:12:22.174069
6857	Điểm hệ số 1 #1	1143	1	\N	2025-05-11 12:12:22.174069
6858	Điểm hệ số 1 #2	1143	1	\N	2025-05-11 12:12:22.174069
6859	Điểm hệ số 1 #3	1143	1	\N	2025-05-11 12:12:22.174069
6860	Điểm hệ số 2 #1	1143	2	\N	2025-05-11 12:12:22.174069
6861	Điểm hệ số 2 #2	1143	2	\N	2025-05-11 12:12:22.174069
6862	Điểm hệ số 3	1143	3	\N	2025-05-11 12:12:22.174069
6863	Điểm hệ số 1 #1	1144	1	\N	2025-05-11 12:12:22.174069
6864	Điểm hệ số 1 #2	1144	1	\N	2025-05-11 12:12:22.174069
6865	Điểm hệ số 1 #3	1144	1	\N	2025-05-11 12:12:22.174069
6866	Điểm hệ số 2 #1	1144	2	\N	2025-05-11 12:12:22.174069
6867	Điểm hệ số 2 #2	1144	2	\N	2025-05-11 12:12:22.174069
6868	Điểm hệ số 3	1144	3	\N	2025-05-11 12:12:22.174069
6869	Điểm hệ số 1 #1	1145	1	\N	2025-05-11 12:12:22.174069
6870	Điểm hệ số 1 #2	1145	1	\N	2025-05-11 12:12:22.174069
6871	Điểm hệ số 1 #3	1145	1	\N	2025-05-11 12:12:22.174069
6872	Điểm hệ số 2 #1	1145	2	\N	2025-05-11 12:12:22.174069
6873	Điểm hệ số 2 #2	1145	2	\N	2025-05-11 12:12:22.174069
6874	Điểm hệ số 3	1145	3	\N	2025-05-11 12:12:22.174069
6875	Điểm hệ số 1 #1	1146	1	\N	2025-05-11 12:12:22.174069
6876	Điểm hệ số 1 #2	1146	1	\N	2025-05-11 12:12:22.174069
6877	Điểm hệ số 1 #3	1146	1	\N	2025-05-11 12:12:22.174069
6878	Điểm hệ số 2 #1	1146	2	\N	2025-05-11 12:12:22.174069
6879	Điểm hệ số 2 #2	1146	2	\N	2025-05-11 12:12:22.174069
6880	Điểm hệ số 3	1146	3	\N	2025-05-11 12:12:22.174069
6881	Điểm hệ số 1 #1	1147	1	\N	2025-05-11 12:12:22.174069
6882	Điểm hệ số 1 #2	1147	1	\N	2025-05-11 12:12:22.174069
6883	Điểm hệ số 1 #3	1147	1	\N	2025-05-11 12:12:22.174069
6884	Điểm hệ số 2 #1	1147	2	\N	2025-05-11 12:12:22.174069
6885	Điểm hệ số 2 #2	1147	2	\N	2025-05-11 12:12:22.174069
6886	Điểm hệ số 3	1147	3	\N	2025-05-11 12:12:22.174069
6887	Điểm hệ số 1 #1	1148	1	\N	2025-05-11 12:12:22.174069
6888	Điểm hệ số 1 #2	1148	1	\N	2025-05-11 12:12:22.174069
6889	Điểm hệ số 1 #3	1148	1	\N	2025-05-11 12:12:22.174069
6890	Điểm hệ số 2 #1	1148	2	\N	2025-05-11 12:12:22.174069
6891	Điểm hệ số 2 #2	1148	2	\N	2025-05-11 12:12:22.174069
6892	Điểm hệ số 3	1148	3	\N	2025-05-11 12:12:22.174069
6893	Điểm hệ số 1 #1	1149	1	\N	2025-05-11 12:12:22.174069
6894	Điểm hệ số 1 #2	1149	1	\N	2025-05-11 12:12:22.174069
6895	Điểm hệ số 1 #3	1149	1	\N	2025-05-11 12:12:22.174069
6896	Điểm hệ số 2 #1	1149	2	\N	2025-05-11 12:12:22.174069
6897	Điểm hệ số 2 #2	1149	2	\N	2025-05-11 12:12:22.174069
6898	Điểm hệ số 3	1149	3	\N	2025-05-11 12:12:22.174069
6899	Điểm hệ số 1 #1	1150	1	\N	2025-05-11 12:12:22.174069
6900	Điểm hệ số 1 #2	1150	1	\N	2025-05-11 12:12:22.174069
6901	Điểm hệ số 1 #3	1150	1	\N	2025-05-11 12:12:22.174069
6902	Điểm hệ số 2 #1	1150	2	\N	2025-05-11 12:12:22.174069
6903	Điểm hệ số 2 #2	1150	2	\N	2025-05-11 12:12:22.174069
6904	Điểm hệ số 3	1150	3	\N	2025-05-11 12:12:22.174069
6905	Điểm hệ số 1 #1	1151	1	\N	2025-05-11 12:12:22.174069
6906	Điểm hệ số 1 #2	1151	1	\N	2025-05-11 12:12:22.174069
6907	Điểm hệ số 1 #3	1151	1	\N	2025-05-11 12:12:22.174069
6908	Điểm hệ số 2 #1	1151	2	\N	2025-05-11 12:12:22.174069
6909	Điểm hệ số 2 #2	1151	2	\N	2025-05-11 12:12:22.174069
6910	Điểm hệ số 3	1151	3	\N	2025-05-11 12:12:22.174069
6911	Điểm hệ số 1 #1	1152	1	\N	2025-05-11 12:12:22.174069
6912	Điểm hệ số 1 #2	1152	1	\N	2025-05-11 12:12:22.174069
6913	Điểm hệ số 1 #3	1152	1	\N	2025-05-11 12:12:22.174069
6914	Điểm hệ số 2 #1	1152	2	\N	2025-05-11 12:12:22.174069
6915	Điểm hệ số 2 #2	1152	2	\N	2025-05-11 12:12:22.174069
6916	Điểm hệ số 3	1152	3	\N	2025-05-11 12:12:22.174069
6917	Điểm hệ số 1 #1	1153	1	\N	2025-05-11 12:12:22.174069
6918	Điểm hệ số 1 #2	1153	1	\N	2025-05-11 12:12:22.174069
6919	Điểm hệ số 1 #3	1153	1	\N	2025-05-11 12:12:22.174069
6920	Điểm hệ số 2 #1	1153	2	\N	2025-05-11 12:12:22.174069
6921	Điểm hệ số 2 #2	1153	2	\N	2025-05-11 12:12:22.174069
6922	Điểm hệ số 3	1153	3	\N	2025-05-11 12:12:22.174069
6923	Điểm hệ số 1 #1	1154	1	\N	2025-05-11 12:12:22.174069
6924	Điểm hệ số 1 #2	1154	1	\N	2025-05-11 12:12:22.174069
6925	Điểm hệ số 1 #3	1154	1	\N	2025-05-11 12:12:22.174069
6926	Điểm hệ số 2 #1	1154	2	\N	2025-05-11 12:12:22.174069
6927	Điểm hệ số 2 #2	1154	2	\N	2025-05-11 12:12:22.174069
6928	Điểm hệ số 3	1154	3	\N	2025-05-11 12:12:22.174069
6929	Điểm hệ số 1 #1	1155	1	\N	2025-05-11 12:12:22.174069
6930	Điểm hệ số 1 #2	1155	1	\N	2025-05-11 12:12:22.174069
6931	Điểm hệ số 1 #3	1155	1	\N	2025-05-11 12:12:22.174069
6932	Điểm hệ số 2 #1	1155	2	\N	2025-05-11 12:12:22.174069
6933	Điểm hệ số 2 #2	1155	2	\N	2025-05-11 12:12:22.174069
6934	Điểm hệ số 3	1155	3	\N	2025-05-11 12:12:22.174069
6935	Điểm hệ số 1 #1	1156	1	\N	2025-05-11 12:12:22.174069
6936	Điểm hệ số 1 #2	1156	1	\N	2025-05-11 12:12:22.174069
6937	Điểm hệ số 1 #3	1156	1	\N	2025-05-11 12:12:22.174069
6938	Điểm hệ số 2 #1	1156	2	\N	2025-05-11 12:12:22.174069
6939	Điểm hệ số 2 #2	1156	2	\N	2025-05-11 12:12:22.174069
6940	Điểm hệ số 3	1156	3	\N	2025-05-11 12:12:22.174069
6941	Điểm hệ số 1 #1	1157	1	\N	2025-05-11 12:12:22.174069
6942	Điểm hệ số 1 #2	1157	1	\N	2025-05-11 12:12:22.174069
6943	Điểm hệ số 1 #3	1157	1	\N	2025-05-11 12:12:22.174069
6944	Điểm hệ số 2 #1	1157	2	\N	2025-05-11 12:12:22.174069
6945	Điểm hệ số 2 #2	1157	2	\N	2025-05-11 12:12:22.174069
6946	Điểm hệ số 3	1157	3	\N	2025-05-11 12:12:22.174069
6947	Điểm hệ số 1 #1	1158	1	\N	2025-05-11 12:12:22.174069
6948	Điểm hệ số 1 #2	1158	1	\N	2025-05-11 12:12:22.174069
6949	Điểm hệ số 1 #3	1158	1	\N	2025-05-11 12:12:22.174069
6950	Điểm hệ số 2 #1	1158	2	\N	2025-05-11 12:12:22.174069
6951	Điểm hệ số 2 #2	1158	2	\N	2025-05-11 12:12:22.174069
6952	Điểm hệ số 3	1158	3	\N	2025-05-11 12:12:22.174069
6953	Điểm hệ số 1 #1	1159	1	\N	2025-05-11 12:12:22.174069
6954	Điểm hệ số 1 #2	1159	1	\N	2025-05-11 12:12:22.174069
6955	Điểm hệ số 1 #3	1159	1	\N	2025-05-11 12:12:22.174069
6956	Điểm hệ số 2 #1	1159	2	\N	2025-05-11 12:12:22.174069
6957	Điểm hệ số 2 #2	1159	2	\N	2025-05-11 12:12:22.174069
6958	Điểm hệ số 3	1159	3	\N	2025-05-11 12:12:22.174069
6959	Điểm hệ số 1 #1	1160	1	\N	2025-05-11 12:12:22.174069
6960	Điểm hệ số 1 #2	1160	1	\N	2025-05-11 12:12:22.174069
6961	Điểm hệ số 1 #3	1160	1	\N	2025-05-11 12:12:22.174069
6962	Điểm hệ số 2 #1	1160	2	\N	2025-05-11 12:12:22.174069
6963	Điểm hệ số 2 #2	1160	2	\N	2025-05-11 12:12:22.174069
6964	Điểm hệ số 3	1160	3	\N	2025-05-11 12:12:22.174069
6965	Điểm hệ số 1 #1	1161	1	\N	2025-05-11 12:12:22.174069
6966	Điểm hệ số 1 #2	1161	1	\N	2025-05-11 12:12:22.174069
6967	Điểm hệ số 1 #3	1161	1	\N	2025-05-11 12:12:22.174069
6968	Điểm hệ số 2 #1	1161	2	\N	2025-05-11 12:12:22.174069
6969	Điểm hệ số 2 #2	1161	2	\N	2025-05-11 12:12:22.174069
6970	Điểm hệ số 3	1161	3	\N	2025-05-11 12:12:22.174069
6971	Điểm hệ số 1 #1	1162	1	\N	2025-05-11 12:12:22.174069
6972	Điểm hệ số 1 #2	1162	1	\N	2025-05-11 12:12:22.174069
6973	Điểm hệ số 1 #3	1162	1	\N	2025-05-11 12:12:22.174069
6974	Điểm hệ số 2 #1	1162	2	\N	2025-05-11 12:12:22.174069
6975	Điểm hệ số 2 #2	1162	2	\N	2025-05-11 12:12:22.174069
6976	Điểm hệ số 3	1162	3	\N	2025-05-11 12:12:22.174069
6977	Điểm hệ số 1 #1	1163	1	\N	2025-05-11 12:12:22.174069
6978	Điểm hệ số 1 #2	1163	1	\N	2025-05-11 12:12:22.174069
6979	Điểm hệ số 1 #3	1163	1	\N	2025-05-11 12:12:22.174069
6980	Điểm hệ số 2 #1	1163	2	\N	2025-05-11 12:12:22.174069
6981	Điểm hệ số 2 #2	1163	2	\N	2025-05-11 12:12:22.174069
6982	Điểm hệ số 3	1163	3	\N	2025-05-11 12:12:22.174069
6983	Điểm hệ số 1 #1	1164	1	\N	2025-05-11 12:12:22.174069
6984	Điểm hệ số 1 #2	1164	1	\N	2025-05-11 12:12:22.174069
6985	Điểm hệ số 1 #3	1164	1	\N	2025-05-11 12:12:22.174069
6986	Điểm hệ số 2 #1	1164	2	\N	2025-05-11 12:12:22.174069
6987	Điểm hệ số 2 #2	1164	2	\N	2025-05-11 12:12:22.174069
6988	Điểm hệ số 3	1164	3	\N	2025-05-11 12:12:22.174069
6989	Điểm hệ số 1 #1	1165	1	\N	2025-05-11 12:12:22.174069
6990	Điểm hệ số 1 #2	1165	1	\N	2025-05-11 12:12:22.174069
6991	Điểm hệ số 1 #3	1165	1	\N	2025-05-11 12:12:22.174069
6992	Điểm hệ số 2 #1	1165	2	\N	2025-05-11 12:12:22.174069
6993	Điểm hệ số 2 #2	1165	2	\N	2025-05-11 12:12:22.174069
6994	Điểm hệ số 3	1165	3	\N	2025-05-11 12:12:22.174069
6995	Điểm hệ số 1 #1	1166	1	\N	2025-05-11 12:12:22.174069
6996	Điểm hệ số 1 #2	1166	1	\N	2025-05-11 12:12:22.17507
6997	Điểm hệ số 1 #3	1166	1	\N	2025-05-11 12:12:22.17507
6998	Điểm hệ số 2 #1	1166	2	\N	2025-05-11 12:12:22.17507
6999	Điểm hệ số 2 #2	1166	2	\N	2025-05-11 12:12:22.17507
7000	Điểm hệ số 3	1166	3	\N	2025-05-11 12:12:22.17507
7001	Điểm hệ số 1 #1	1167	1	\N	2025-05-11 12:12:22.17507
7002	Điểm hệ số 1 #2	1167	1	\N	2025-05-11 12:12:22.17507
7003	Điểm hệ số 1 #3	1167	1	\N	2025-05-11 12:12:22.17507
7004	Điểm hệ số 2 #1	1167	2	\N	2025-05-11 12:12:22.17507
7005	Điểm hệ số 2 #2	1167	2	\N	2025-05-11 12:12:22.17507
7006	Điểm hệ số 3	1167	3	\N	2025-05-11 12:12:22.17507
7007	Điểm hệ số 1 #1	1168	1	\N	2025-05-11 12:12:23.239486
7008	Điểm hệ số 1 #2	1168	1	\N	2025-05-11 12:12:23.239486
7009	Điểm hệ số 1 #3	1168	1	\N	2025-05-11 12:12:23.239486
7010	Điểm hệ số 2 #1	1168	2	\N	2025-05-11 12:12:23.239486
7011	Điểm hệ số 2 #2	1168	2	\N	2025-05-11 12:12:23.239486
7012	Điểm hệ số 3	1168	3	\N	2025-05-11 12:12:23.239486
7013	Điểm hệ số 1 #1	1169	1	\N	2025-05-11 12:12:23.239486
7014	Điểm hệ số 1 #2	1169	1	\N	2025-05-11 12:12:23.239486
7015	Điểm hệ số 1 #3	1169	1	\N	2025-05-11 12:12:23.239486
7016	Điểm hệ số 2 #1	1169	2	\N	2025-05-11 12:12:23.239486
7017	Điểm hệ số 2 #2	1169	2	\N	2025-05-11 12:12:23.239486
7018	Điểm hệ số 3	1169	3	\N	2025-05-11 12:12:23.239486
7019	Điểm hệ số 1 #1	1170	1	\N	2025-05-11 12:12:23.239486
7020	Điểm hệ số 1 #2	1170	1	\N	2025-05-11 12:12:23.239486
7021	Điểm hệ số 1 #3	1170	1	\N	2025-05-11 12:12:23.239486
7022	Điểm hệ số 2 #1	1170	2	\N	2025-05-11 12:12:23.239486
7023	Điểm hệ số 2 #2	1170	2	\N	2025-05-11 12:12:23.239486
7024	Điểm hệ số 3	1170	3	\N	2025-05-11 12:12:23.239486
7025	Điểm hệ số 1 #1	1171	1	\N	2025-05-11 12:12:23.240476
7026	Điểm hệ số 1 #2	1171	1	\N	2025-05-11 12:12:23.240476
7027	Điểm hệ số 1 #3	1171	1	\N	2025-05-11 12:12:23.240476
7028	Điểm hệ số 2 #1	1171	2	\N	2025-05-11 12:12:23.240476
7029	Điểm hệ số 2 #2	1171	2	\N	2025-05-11 12:12:23.240476
7030	Điểm hệ số 3	1171	3	\N	2025-05-11 12:12:23.240476
7031	Điểm hệ số 1 #1	1172	1	\N	2025-05-11 12:12:23.240476
7032	Điểm hệ số 1 #2	1172	1	\N	2025-05-11 12:12:23.240476
7033	Điểm hệ số 1 #3	1172	1	\N	2025-05-11 12:12:23.240476
7034	Điểm hệ số 2 #1	1172	2	\N	2025-05-11 12:12:23.240476
7035	Điểm hệ số 2 #2	1172	2	\N	2025-05-11 12:12:23.240476
7036	Điểm hệ số 3	1172	3	\N	2025-05-11 12:12:23.240476
7037	Điểm hệ số 1 #1	1173	1	\N	2025-05-11 12:12:23.240476
7038	Điểm hệ số 1 #2	1173	1	\N	2025-05-11 12:12:23.240476
7039	Điểm hệ số 1 #3	1173	1	\N	2025-05-11 12:12:23.240476
7040	Điểm hệ số 2 #1	1173	2	\N	2025-05-11 12:12:23.240476
7041	Điểm hệ số 2 #2	1173	2	\N	2025-05-11 12:12:23.240476
7042	Điểm hệ số 3	1173	3	\N	2025-05-11 12:12:23.240476
7043	Điểm hệ số 1 #1	1174	1	\N	2025-05-11 12:12:23.240476
7044	Điểm hệ số 1 #2	1174	1	\N	2025-05-11 12:12:23.240476
7045	Điểm hệ số 1 #3	1174	1	\N	2025-05-11 12:12:23.240476
7046	Điểm hệ số 2 #1	1174	2	\N	2025-05-11 12:12:23.240476
7047	Điểm hệ số 2 #2	1174	2	\N	2025-05-11 12:12:23.240476
7048	Điểm hệ số 3	1174	3	\N	2025-05-11 12:12:23.240476
7049	Điểm hệ số 1 #1	1175	1	\N	2025-05-11 12:12:23.240476
7050	Điểm hệ số 1 #2	1175	1	\N	2025-05-11 12:12:23.240476
7051	Điểm hệ số 1 #3	1175	1	\N	2025-05-11 12:12:23.240476
7052	Điểm hệ số 2 #1	1175	2	\N	2025-05-11 12:12:23.240476
7053	Điểm hệ số 2 #2	1175	2	\N	2025-05-11 12:12:23.240476
7054	Điểm hệ số 3	1175	3	\N	2025-05-11 12:12:23.240476
7055	Điểm hệ số 1 #1	1176	1	\N	2025-05-11 12:12:23.240476
7056	Điểm hệ số 1 #2	1176	1	\N	2025-05-11 12:12:23.240476
7057	Điểm hệ số 1 #3	1176	1	\N	2025-05-11 12:12:23.240476
7058	Điểm hệ số 2 #1	1176	2	\N	2025-05-11 12:12:23.240476
7059	Điểm hệ số 2 #2	1176	2	\N	2025-05-11 12:12:23.240476
7060	Điểm hệ số 3	1176	3	\N	2025-05-11 12:12:23.240476
7061	Điểm hệ số 1 #1	1177	1	\N	2025-05-11 12:12:23.240476
7062	Điểm hệ số 1 #2	1177	1	\N	2025-05-11 12:12:23.240476
7063	Điểm hệ số 1 #3	1177	1	\N	2025-05-11 12:12:23.240476
7064	Điểm hệ số 2 #1	1177	2	\N	2025-05-11 12:12:23.240476
7065	Điểm hệ số 2 #2	1177	2	\N	2025-05-11 12:12:23.240476
7066	Điểm hệ số 3	1177	3	\N	2025-05-11 12:12:23.240476
7067	Điểm hệ số 1 #1	1178	1	\N	2025-05-11 12:12:23.240476
7068	Điểm hệ số 1 #2	1178	1	\N	2025-05-11 12:12:23.240476
7069	Điểm hệ số 1 #3	1178	1	\N	2025-05-11 12:12:23.240476
7070	Điểm hệ số 2 #1	1178	2	\N	2025-05-11 12:12:23.240476
7071	Điểm hệ số 2 #2	1178	2	\N	2025-05-11 12:12:23.240476
7072	Điểm hệ số 3	1178	3	\N	2025-05-11 12:12:23.240476
7073	Điểm hệ số 1 #1	1179	1	\N	2025-05-11 12:12:23.240476
7074	Điểm hệ số 1 #2	1179	1	\N	2025-05-11 12:12:23.240476
7075	Điểm hệ số 1 #3	1179	1	\N	2025-05-11 12:12:23.240476
7076	Điểm hệ số 2 #1	1179	2	\N	2025-05-11 12:12:23.240476
7077	Điểm hệ số 2 #2	1179	2	\N	2025-05-11 12:12:23.240476
7078	Điểm hệ số 3	1179	3	\N	2025-05-11 12:12:23.240476
7079	Điểm hệ số 1 #1	1180	1	\N	2025-05-11 12:12:23.240476
7080	Điểm hệ số 1 #2	1180	1	\N	2025-05-11 12:12:23.240476
7081	Điểm hệ số 1 #3	1180	1	\N	2025-05-11 12:12:23.240476
7082	Điểm hệ số 2 #1	1180	2	\N	2025-05-11 12:12:23.240476
7083	Điểm hệ số 2 #2	1180	2	\N	2025-05-11 12:12:23.240476
7084	Điểm hệ số 3	1180	3	\N	2025-05-11 12:12:23.240476
7085	Điểm hệ số 1 #1	1181	1	\N	2025-05-11 12:12:23.240476
7086	Điểm hệ số 1 #2	1181	1	\N	2025-05-11 12:12:23.240476
7087	Điểm hệ số 1 #3	1181	1	\N	2025-05-11 12:12:23.240476
7088	Điểm hệ số 2 #1	1181	2	\N	2025-05-11 12:12:23.240476
7089	Điểm hệ số 2 #2	1181	2	\N	2025-05-11 12:12:23.240476
7090	Điểm hệ số 3	1181	3	\N	2025-05-11 12:12:23.240476
7091	Điểm hệ số 1 #1	1182	1	\N	2025-05-11 12:12:23.240476
7092	Điểm hệ số 1 #2	1182	1	\N	2025-05-11 12:12:23.240476
7093	Điểm hệ số 1 #3	1182	1	\N	2025-05-11 12:12:23.240476
7094	Điểm hệ số 2 #1	1182	2	\N	2025-05-11 12:12:23.240476
7095	Điểm hệ số 2 #2	1182	2	\N	2025-05-11 12:12:23.240476
7096	Điểm hệ số 3	1182	3	\N	2025-05-11 12:12:23.240476
7097	Điểm hệ số 1 #1	1183	1	\N	2025-05-11 12:12:23.240476
7098	Điểm hệ số 1 #2	1183	1	\N	2025-05-11 12:12:23.240476
7099	Điểm hệ số 1 #3	1183	1	\N	2025-05-11 12:12:23.240476
7100	Điểm hệ số 2 #1	1183	2	\N	2025-05-11 12:12:23.240476
7101	Điểm hệ số 2 #2	1183	2	\N	2025-05-11 12:12:23.240476
7102	Điểm hệ số 3	1183	3	\N	2025-05-11 12:12:23.240476
7103	Điểm hệ số 1 #1	1184	1	\N	2025-05-11 12:12:23.240476
7104	Điểm hệ số 1 #2	1184	1	\N	2025-05-11 12:12:23.240476
7105	Điểm hệ số 1 #3	1184	1	\N	2025-05-11 12:12:23.240476
7106	Điểm hệ số 2 #1	1184	2	\N	2025-05-11 12:12:23.240476
7107	Điểm hệ số 2 #2	1184	2	\N	2025-05-11 12:12:23.240476
7108	Điểm hệ số 3	1184	3	\N	2025-05-11 12:12:23.240476
7109	Điểm hệ số 1 #1	1185	1	\N	2025-05-11 12:12:23.240476
7110	Điểm hệ số 1 #2	1185	1	\N	2025-05-11 12:12:23.240476
7111	Điểm hệ số 1 #3	1185	1	\N	2025-05-11 12:12:23.240476
7112	Điểm hệ số 2 #1	1185	2	\N	2025-05-11 12:12:23.240476
7113	Điểm hệ số 2 #2	1185	2	\N	2025-05-11 12:12:23.240476
7114	Điểm hệ số 3	1185	3	\N	2025-05-11 12:12:23.240476
7115	Điểm hệ số 1 #1	1186	1	\N	2025-05-11 12:12:23.240476
7116	Điểm hệ số 1 #2	1186	1	\N	2025-05-11 12:12:23.240476
7117	Điểm hệ số 1 #3	1186	1	\N	2025-05-11 12:12:23.240476
7118	Điểm hệ số 2 #1	1186	2	\N	2025-05-11 12:12:23.240476
7119	Điểm hệ số 2 #2	1186	2	\N	2025-05-11 12:12:23.240476
7120	Điểm hệ số 3	1186	3	\N	2025-05-11 12:12:23.240476
7121	Điểm hệ số 1 #1	1187	1	\N	2025-05-11 12:12:23.240476
7122	Điểm hệ số 1 #2	1187	1	\N	2025-05-11 12:12:23.240476
7123	Điểm hệ số 1 #3	1187	1	\N	2025-05-11 12:12:23.240476
7124	Điểm hệ số 2 #1	1187	2	\N	2025-05-11 12:12:23.240476
7125	Điểm hệ số 2 #2	1187	2	\N	2025-05-11 12:12:23.240476
7126	Điểm hệ số 3	1187	3	\N	2025-05-11 12:12:23.240476
7127	Điểm hệ số 1 #1	1188	1	\N	2025-05-11 12:12:23.240476
7128	Điểm hệ số 1 #2	1188	1	\N	2025-05-11 12:12:23.240476
7129	Điểm hệ số 1 #3	1188	1	\N	2025-05-11 12:12:23.240476
7130	Điểm hệ số 2 #1	1188	2	\N	2025-05-11 12:12:23.240476
7131	Điểm hệ số 2 #2	1188	2	\N	2025-05-11 12:12:23.240476
7132	Điểm hệ số 3	1188	3	\N	2025-05-11 12:12:23.240476
7133	Điểm hệ số 1 #1	1189	1	\N	2025-05-11 12:12:23.240476
7134	Điểm hệ số 1 #2	1189	1	\N	2025-05-11 12:12:23.240476
7135	Điểm hệ số 1 #3	1189	1	\N	2025-05-11 12:12:23.240476
7136	Điểm hệ số 2 #1	1189	2	\N	2025-05-11 12:12:23.240476
7137	Điểm hệ số 2 #2	1189	2	\N	2025-05-11 12:12:23.240476
7138	Điểm hệ số 3	1189	3	\N	2025-05-11 12:12:23.240476
7139	Điểm hệ số 1 #1	1190	1	\N	2025-05-11 12:12:23.240476
7140	Điểm hệ số 1 #2	1190	1	\N	2025-05-11 12:12:23.240476
7141	Điểm hệ số 1 #3	1190	1	\N	2025-05-11 12:12:23.240476
7142	Điểm hệ số 2 #1	1190	2	\N	2025-05-11 12:12:23.240476
7143	Điểm hệ số 2 #2	1190	2	\N	2025-05-11 12:12:23.240476
7144	Điểm hệ số 3	1190	3	\N	2025-05-11 12:12:23.240476
7145	Điểm hệ số 1 #1	1191	1	\N	2025-05-11 12:12:23.240476
7146	Điểm hệ số 1 #2	1191	1	\N	2025-05-11 12:12:23.240476
7147	Điểm hệ số 1 #3	1191	1	\N	2025-05-11 12:12:23.240476
7148	Điểm hệ số 2 #1	1191	2	\N	2025-05-11 12:12:23.240476
7149	Điểm hệ số 2 #2	1191	2	\N	2025-05-11 12:12:23.240476
7150	Điểm hệ số 3	1191	3	\N	2025-05-11 12:12:23.240476
7151	Điểm hệ số 1 #1	1192	1	\N	2025-05-11 12:12:23.240476
7152	Điểm hệ số 1 #2	1192	1	\N	2025-05-11 12:12:23.240476
7153	Điểm hệ số 1 #3	1192	1	\N	2025-05-11 12:12:23.240476
7154	Điểm hệ số 2 #1	1192	2	\N	2025-05-11 12:12:23.240476
7155	Điểm hệ số 2 #2	1192	2	\N	2025-05-11 12:12:23.240476
7156	Điểm hệ số 3	1192	3	\N	2025-05-11 12:12:23.240476
7157	Điểm hệ số 1 #1	1193	1	\N	2025-05-11 12:12:23.240476
7158	Điểm hệ số 1 #2	1193	1	\N	2025-05-11 12:12:23.240476
7159	Điểm hệ số 1 #3	1193	1	\N	2025-05-11 12:12:23.240476
7160	Điểm hệ số 2 #1	1193	2	\N	2025-05-11 12:12:23.240476
7161	Điểm hệ số 2 #2	1193	2	\N	2025-05-11 12:12:23.240476
7162	Điểm hệ số 3	1193	3	\N	2025-05-11 12:12:23.240476
7163	Điểm hệ số 1 #1	1194	1	\N	2025-05-11 12:12:23.240476
7164	Điểm hệ số 1 #2	1194	1	\N	2025-05-11 12:12:23.240476
7165	Điểm hệ số 1 #3	1194	1	\N	2025-05-11 12:12:23.240476
7166	Điểm hệ số 2 #1	1194	2	\N	2025-05-11 12:12:23.240476
7167	Điểm hệ số 2 #2	1194	2	\N	2025-05-11 12:12:23.240476
7168	Điểm hệ số 3	1194	3	\N	2025-05-11 12:12:23.240476
7169	Điểm hệ số 1 #1	1195	1	\N	2025-05-11 12:12:23.240476
7170	Điểm hệ số 1 #2	1195	1	\N	2025-05-11 12:12:23.240476
7171	Điểm hệ số 1 #3	1195	1	\N	2025-05-11 12:12:23.240476
7172	Điểm hệ số 2 #1	1195	2	\N	2025-05-11 12:12:23.240476
7173	Điểm hệ số 2 #2	1195	2	\N	2025-05-11 12:12:23.240476
7174	Điểm hệ số 3	1195	3	\N	2025-05-11 12:12:23.240476
7175	Điểm hệ số 1 #1	1196	1	\N	2025-05-11 12:12:23.240476
7176	Điểm hệ số 1 #2	1196	1	\N	2025-05-11 12:12:23.240476
7177	Điểm hệ số 1 #3	1196	1	\N	2025-05-11 12:12:23.240476
7178	Điểm hệ số 2 #1	1196	2	\N	2025-05-11 12:12:23.240476
7179	Điểm hệ số 2 #2	1196	2	\N	2025-05-11 12:12:23.240476
7180	Điểm hệ số 3	1196	3	\N	2025-05-11 12:12:23.240476
7181	Điểm hệ số 1 #1	1197	1	\N	2025-05-11 12:12:23.240476
7182	Điểm hệ số 1 #2	1197	1	\N	2025-05-11 12:12:23.240476
7183	Điểm hệ số 1 #3	1197	1	\N	2025-05-11 12:12:23.240476
7184	Điểm hệ số 2 #1	1197	2	\N	2025-05-11 12:12:23.240476
7185	Điểm hệ số 2 #2	1197	2	\N	2025-05-11 12:12:23.240476
7186	Điểm hệ số 3	1197	3	\N	2025-05-11 12:12:23.240476
7187	Điểm hệ số 1 #1	1198	1	\N	2025-05-11 12:12:23.240476
7188	Điểm hệ số 1 #2	1198	1	\N	2025-05-11 12:12:23.240476
7189	Điểm hệ số 1 #3	1198	1	\N	2025-05-11 12:12:23.240476
7190	Điểm hệ số 2 #1	1198	2	\N	2025-05-11 12:12:23.240476
7191	Điểm hệ số 2 #2	1198	2	\N	2025-05-11 12:12:23.240476
7192	Điểm hệ số 3	1198	3	\N	2025-05-11 12:12:23.240476
7193	Điểm hệ số 1 #1	1199	1	\N	2025-05-11 12:12:23.240476
7194	Điểm hệ số 1 #2	1199	1	\N	2025-05-11 12:12:23.240476
7195	Điểm hệ số 1 #3	1199	1	\N	2025-05-11 12:12:23.240476
7196	Điểm hệ số 2 #1	1199	2	\N	2025-05-11 12:12:23.240476
7197	Điểm hệ số 2 #2	1199	2	\N	2025-05-11 12:12:23.240476
7198	Điểm hệ số 3	1199	3	\N	2025-05-11 12:12:23.240476
7199	Điểm hệ số 1 #1	1200	1	\N	2025-05-11 12:12:23.240476
7200	Điểm hệ số 1 #2	1200	1	\N	2025-05-11 12:12:23.240476
7201	Điểm hệ số 1 #3	1200	1	\N	2025-05-11 12:12:23.240476
7202	Điểm hệ số 2 #1	1200	2	\N	2025-05-11 12:12:23.240476
7203	Điểm hệ số 2 #2	1200	2	\N	2025-05-11 12:12:23.240476
7204	Điểm hệ số 3	1200	3	\N	2025-05-11 12:12:23.240476
7205	Điểm hệ số 1 #1	1201	1	\N	2025-05-11 12:12:23.240476
7206	Điểm hệ số 1 #2	1201	1	\N	2025-05-11 12:12:23.240476
7207	Điểm hệ số 1 #3	1201	1	\N	2025-05-11 12:12:23.240476
7208	Điểm hệ số 2 #1	1201	2	\N	2025-05-11 12:12:23.240476
7209	Điểm hệ số 2 #2	1201	2	\N	2025-05-11 12:12:23.240476
7210	Điểm hệ số 3	1201	3	\N	2025-05-11 12:12:23.240476
7211	Điểm hệ số 1 #1	1202	1	\N	2025-05-11 12:12:23.240476
7212	Điểm hệ số 1 #2	1202	1	\N	2025-05-11 12:12:23.240476
7213	Điểm hệ số 1 #3	1202	1	\N	2025-05-11 12:12:23.240476
7214	Điểm hệ số 2 #1	1202	2	\N	2025-05-11 12:12:23.240476
7215	Điểm hệ số 2 #2	1202	2	\N	2025-05-11 12:12:23.240476
7216	Điểm hệ số 3	1202	3	\N	2025-05-11 12:12:23.240476
7217	Điểm hệ số 1 #1	1203	1	\N	2025-05-11 12:12:23.240476
7218	Điểm hệ số 1 #2	1203	1	\N	2025-05-11 12:12:23.240476
7219	Điểm hệ số 1 #3	1203	1	\N	2025-05-11 12:12:23.240476
7220	Điểm hệ số 2 #1	1203	2	\N	2025-05-11 12:12:23.240476
7221	Điểm hệ số 2 #2	1203	2	\N	2025-05-11 12:12:23.240476
7222	Điểm hệ số 3	1203	3	\N	2025-05-11 12:12:23.240476
7223	Điểm hệ số 1 #1	1204	1	\N	2025-05-11 12:12:23.240476
7224	Điểm hệ số 1 #2	1204	1	\N	2025-05-11 12:12:23.240476
7225	Điểm hệ số 1 #3	1204	1	\N	2025-05-11 12:12:23.240476
7226	Điểm hệ số 2 #1	1204	2	\N	2025-05-11 12:12:23.240476
7227	Điểm hệ số 2 #2	1204	2	\N	2025-05-11 12:12:23.240476
7228	Điểm hệ số 3	1204	3	\N	2025-05-11 12:12:23.240476
7229	Điểm hệ số 1 #1	1205	1	\N	2025-05-11 12:12:23.240476
7230	Điểm hệ số 1 #2	1205	1	\N	2025-05-11 12:12:23.240476
7231	Điểm hệ số 1 #3	1205	1	\N	2025-05-11 12:12:23.240476
7232	Điểm hệ số 2 #1	1205	2	\N	2025-05-11 12:12:23.240476
7233	Điểm hệ số 2 #2	1205	2	\N	2025-05-11 12:12:23.240476
7234	Điểm hệ số 3	1205	3	\N	2025-05-11 12:12:23.240476
7235	Điểm hệ số 1 #1	1206	1	\N	2025-05-11 12:12:23.240476
7236	Điểm hệ số 1 #2	1206	1	\N	2025-05-11 12:12:23.240476
7237	Điểm hệ số 1 #3	1206	1	\N	2025-05-11 12:12:23.240476
7238	Điểm hệ số 2 #1	1206	2	\N	2025-05-11 12:12:23.240476
7239	Điểm hệ số 2 #2	1206	2	\N	2025-05-11 12:12:23.240476
7240	Điểm hệ số 3	1206	3	\N	2025-05-11 12:12:23.240476
7241	Điểm hệ số 1 #1	1207	1	\N	2025-05-11 12:12:23.240476
7242	Điểm hệ số 1 #2	1207	1	\N	2025-05-11 12:12:23.240476
7243	Điểm hệ số 1 #3	1207	1	\N	2025-05-11 12:12:23.240476
7244	Điểm hệ số 2 #1	1207	2	\N	2025-05-11 12:12:23.241474
7245	Điểm hệ số 2 #2	1207	2	\N	2025-05-11 12:12:23.241474
7246	Điểm hệ số 3	1207	3	\N	2025-05-11 12:12:23.241474
7247	Điểm hệ số 1 #1	1208	1	\N	2025-05-11 12:12:23.241474
7248	Điểm hệ số 1 #2	1208	1	\N	2025-05-11 12:12:23.241474
7249	Điểm hệ số 1 #3	1208	1	\N	2025-05-11 12:12:23.241474
7250	Điểm hệ số 2 #1	1208	2	\N	2025-05-11 12:12:23.241474
7251	Điểm hệ số 2 #2	1208	2	\N	2025-05-11 12:12:23.241474
7252	Điểm hệ số 3	1208	3	\N	2025-05-11 12:12:23.241474
7253	Điểm hệ số 1 #1	1209	1	\N	2025-05-11 12:12:23.241474
7254	Điểm hệ số 1 #2	1209	1	\N	2025-05-11 12:12:23.241474
7255	Điểm hệ số 1 #3	1209	1	\N	2025-05-11 12:12:23.241474
7256	Điểm hệ số 2 #1	1209	2	\N	2025-05-11 12:12:23.241474
7257	Điểm hệ số 2 #2	1209	2	\N	2025-05-11 12:12:23.241474
7258	Điểm hệ số 3	1209	3	\N	2025-05-11 12:12:23.241474
7259	Điểm hệ số 1 #1	1210	1	\N	2025-05-11 12:12:23.241474
7260	Điểm hệ số 1 #2	1210	1	\N	2025-05-11 12:12:23.241474
7261	Điểm hệ số 1 #3	1210	1	\N	2025-05-11 12:12:23.241474
7262	Điểm hệ số 2 #1	1210	2	\N	2025-05-11 12:12:23.241474
7263	Điểm hệ số 2 #2	1210	2	\N	2025-05-11 12:12:23.241474
7264	Điểm hệ số 3	1210	3	\N	2025-05-11 12:12:23.241474
7265	Điểm hệ số 1 #1	1211	1	\N	2025-05-11 12:12:23.241474
7266	Điểm hệ số 1 #2	1211	1	\N	2025-05-11 12:12:23.241474
7267	Điểm hệ số 1 #3	1211	1	\N	2025-05-11 12:12:23.241474
7268	Điểm hệ số 2 #1	1211	2	\N	2025-05-11 12:12:23.241474
7269	Điểm hệ số 2 #2	1211	2	\N	2025-05-11 12:12:23.241474
7270	Điểm hệ số 3	1211	3	\N	2025-05-11 12:12:23.241474
7271	Điểm hệ số 1 #1	1212	1	\N	2025-05-11 12:12:23.241474
7272	Điểm hệ số 1 #2	1212	1	\N	2025-05-11 12:12:23.241474
7273	Điểm hệ số 1 #3	1212	1	\N	2025-05-11 12:12:23.241474
7274	Điểm hệ số 2 #1	1212	2	\N	2025-05-11 12:12:23.241474
7275	Điểm hệ số 2 #2	1212	2	\N	2025-05-11 12:12:23.241474
7276	Điểm hệ số 3	1212	3	\N	2025-05-11 12:12:23.241474
7277	Điểm hệ số 1 #1	1213	1	\N	2025-05-11 12:12:23.241474
7278	Điểm hệ số 1 #2	1213	1	\N	2025-05-11 12:12:23.241474
7279	Điểm hệ số 1 #3	1213	1	\N	2025-05-11 12:12:23.241474
7280	Điểm hệ số 2 #1	1213	2	\N	2025-05-11 12:12:23.241474
7281	Điểm hệ số 2 #2	1213	2	\N	2025-05-11 12:12:23.241474
7282	Điểm hệ số 3	1213	3	\N	2025-05-11 12:12:23.241474
7283	Điểm hệ số 1 #1	1214	1	\N	2025-05-11 12:12:23.241474
7284	Điểm hệ số 1 #2	1214	1	\N	2025-05-11 12:12:23.241474
7285	Điểm hệ số 1 #3	1214	1	\N	2025-05-11 12:12:23.241474
7286	Điểm hệ số 2 #1	1214	2	\N	2025-05-11 12:12:23.241474
7287	Điểm hệ số 2 #2	1214	2	\N	2025-05-11 12:12:23.241474
7288	Điểm hệ số 3	1214	3	\N	2025-05-11 12:12:23.241474
7289	Điểm hệ số 1 #1	1215	1	\N	2025-05-11 12:12:23.241474
7290	Điểm hệ số 1 #2	1215	1	\N	2025-05-11 12:12:23.241474
7291	Điểm hệ số 1 #3	1215	1	\N	2025-05-11 12:12:23.241474
7292	Điểm hệ số 2 #1	1215	2	\N	2025-05-11 12:12:23.241474
7293	Điểm hệ số 2 #2	1215	2	\N	2025-05-11 12:12:23.241474
7294	Điểm hệ số 3	1215	3	\N	2025-05-11 12:12:23.241474
7295	Điểm hệ số 1 #1	1216	1	\N	2025-05-11 12:12:23.241474
7296	Điểm hệ số 1 #2	1216	1	\N	2025-05-11 12:12:23.241474
7297	Điểm hệ số 1 #3	1216	1	\N	2025-05-11 12:12:23.241474
7298	Điểm hệ số 2 #1	1216	2	\N	2025-05-11 12:12:23.241474
7299	Điểm hệ số 2 #2	1216	2	\N	2025-05-11 12:12:23.241474
7300	Điểm hệ số 3	1216	3	\N	2025-05-11 12:12:23.241474
7301	Điểm hệ số 1 #1	1217	1	\N	2025-05-11 12:12:23.241474
7302	Điểm hệ số 1 #2	1217	1	\N	2025-05-11 12:12:23.241474
7303	Điểm hệ số 1 #3	1217	1	\N	2025-05-11 12:12:23.241474
7304	Điểm hệ số 2 #1	1217	2	\N	2025-05-11 12:12:23.241474
7305	Điểm hệ số 2 #2	1217	2	\N	2025-05-11 12:12:23.241474
7306	Điểm hệ số 3	1217	3	\N	2025-05-11 12:12:23.241474
7307	Điểm hệ số 1 #1	1218	1	\N	2025-05-11 12:12:23.241474
7308	Điểm hệ số 1 #2	1218	1	\N	2025-05-11 12:12:23.241474
7309	Điểm hệ số 1 #3	1218	1	\N	2025-05-11 12:12:23.241474
7310	Điểm hệ số 2 #1	1218	2	\N	2025-05-11 12:12:23.241474
7311	Điểm hệ số 2 #2	1218	2	\N	2025-05-11 12:12:23.241474
7312	Điểm hệ số 3	1218	3	\N	2025-05-11 12:12:23.241474
7313	Điểm hệ số 1 #1	1219	1	\N	2025-05-11 12:12:23.241474
7314	Điểm hệ số 1 #2	1219	1	\N	2025-05-11 12:12:23.241474
7315	Điểm hệ số 1 #3	1219	1	\N	2025-05-11 12:12:23.241474
7316	Điểm hệ số 2 #1	1219	2	\N	2025-05-11 12:12:23.241474
7317	Điểm hệ số 2 #2	1219	2	\N	2025-05-11 12:12:23.241474
7318	Điểm hệ số 3	1219	3	\N	2025-05-11 12:12:23.241474
7319	Điểm hệ số 1 #1	1220	1	\N	2025-05-11 12:12:23.241474
7320	Điểm hệ số 1 #2	1220	1	\N	2025-05-11 12:12:23.241474
7321	Điểm hệ số 1 #3	1220	1	\N	2025-05-11 12:12:23.241474
7322	Điểm hệ số 2 #1	1220	2	\N	2025-05-11 12:12:23.241474
7323	Điểm hệ số 2 #2	1220	2	\N	2025-05-11 12:12:23.241474
7324	Điểm hệ số 3	1220	3	\N	2025-05-11 12:12:23.241474
7325	Điểm hệ số 1 #1	1221	1	\N	2025-05-11 12:12:23.241474
7326	Điểm hệ số 1 #2	1221	1	\N	2025-05-11 12:12:23.241474
7327	Điểm hệ số 1 #3	1221	1	\N	2025-05-11 12:12:23.241474
7328	Điểm hệ số 2 #1	1221	2	\N	2025-05-11 12:12:23.241474
7329	Điểm hệ số 2 #2	1221	2	\N	2025-05-11 12:12:23.241474
7330	Điểm hệ số 3	1221	3	\N	2025-05-11 12:12:23.241474
7331	Điểm hệ số 1 #1	1222	1	\N	2025-05-11 12:12:23.241474
7332	Điểm hệ số 1 #2	1222	1	\N	2025-05-11 12:12:23.241474
7333	Điểm hệ số 1 #3	1222	1	\N	2025-05-11 12:12:23.241474
7334	Điểm hệ số 2 #1	1222	2	\N	2025-05-11 12:12:23.241474
7335	Điểm hệ số 2 #2	1222	2	\N	2025-05-11 12:12:23.241474
7336	Điểm hệ số 3	1222	3	\N	2025-05-11 12:12:23.241474
7337	Điểm hệ số 1 #1	1223	1	\N	2025-05-11 12:12:23.241474
7338	Điểm hệ số 1 #2	1223	1	\N	2025-05-11 12:12:23.241474
7339	Điểm hệ số 1 #3	1223	1	\N	2025-05-11 12:12:23.241474
7340	Điểm hệ số 2 #1	1223	2	\N	2025-05-11 12:12:23.241474
7341	Điểm hệ số 2 #2	1223	2	\N	2025-05-11 12:12:23.241474
7342	Điểm hệ số 3	1223	3	\N	2025-05-11 12:12:23.241474
7343	Điểm hệ số 1 #1	1224	1	\N	2025-05-11 12:12:23.241474
7344	Điểm hệ số 1 #2	1224	1	\N	2025-05-11 12:12:23.241474
7345	Điểm hệ số 1 #3	1224	1	\N	2025-05-11 12:12:23.241474
7346	Điểm hệ số 2 #1	1224	2	\N	2025-05-11 12:12:23.241474
7347	Điểm hệ số 2 #2	1224	2	\N	2025-05-11 12:12:23.241474
7348	Điểm hệ số 3	1224	3	\N	2025-05-11 12:12:23.241474
7349	Điểm hệ số 1 #1	1225	1	\N	2025-05-11 12:12:23.241474
7350	Điểm hệ số 1 #2	1225	1	\N	2025-05-11 12:12:23.241474
7351	Điểm hệ số 1 #3	1225	1	\N	2025-05-11 12:12:23.241474
7352	Điểm hệ số 2 #1	1225	2	\N	2025-05-11 12:12:23.241474
7353	Điểm hệ số 2 #2	1225	2	\N	2025-05-11 12:12:23.241474
7354	Điểm hệ số 3	1225	3	\N	2025-05-11 12:12:23.241474
7355	Điểm hệ số 1 #1	1226	1	\N	2025-05-11 12:12:23.241474
7356	Điểm hệ số 1 #2	1226	1	\N	2025-05-11 12:12:23.241474
7357	Điểm hệ số 1 #3	1226	1	\N	2025-05-11 12:12:23.241474
7358	Điểm hệ số 2 #1	1226	2	\N	2025-05-11 12:12:23.241474
7359	Điểm hệ số 2 #2	1226	2	\N	2025-05-11 12:12:23.241474
7360	Điểm hệ số 3	1226	3	\N	2025-05-11 12:12:23.241474
7361	Điểm hệ số 1 #1	1227	1	\N	2025-05-11 12:12:23.241474
7362	Điểm hệ số 1 #2	1227	1	\N	2025-05-11 12:12:23.241474
7363	Điểm hệ số 1 #3	1227	1	\N	2025-05-11 12:12:23.241474
7364	Điểm hệ số 2 #1	1227	2	\N	2025-05-11 12:12:23.241474
7365	Điểm hệ số 2 #2	1227	2	\N	2025-05-11 12:12:23.241474
7366	Điểm hệ số 3	1227	3	\N	2025-05-11 12:12:23.241474
7367	Điểm hệ số 1 #1	1228	1	\N	2025-05-11 12:12:23.241474
7368	Điểm hệ số 1 #2	1228	1	\N	2025-05-11 12:12:23.241474
7369	Điểm hệ số 1 #3	1228	1	\N	2025-05-11 12:12:23.241474
7370	Điểm hệ số 2 #1	1228	2	\N	2025-05-11 12:12:23.241474
7371	Điểm hệ số 2 #2	1228	2	\N	2025-05-11 12:12:23.241474
7372	Điểm hệ số 3	1228	3	\N	2025-05-11 12:12:23.241474
7373	Điểm hệ số 1 #1	1229	1	\N	2025-05-11 12:12:23.241474
7374	Điểm hệ số 1 #2	1229	1	\N	2025-05-11 12:12:23.241474
7375	Điểm hệ số 1 #3	1229	1	\N	2025-05-11 12:12:23.241474
7376	Điểm hệ số 2 #1	1229	2	\N	2025-05-11 12:12:23.241474
7377	Điểm hệ số 2 #2	1229	2	\N	2025-05-11 12:12:23.241474
7378	Điểm hệ số 3	1229	3	\N	2025-05-11 12:12:23.241474
7379	Điểm hệ số 1 #1	1230	1	\N	2025-05-11 12:12:23.241474
7380	Điểm hệ số 1 #2	1230	1	\N	2025-05-11 12:12:23.241474
7381	Điểm hệ số 1 #3	1230	1	\N	2025-05-11 12:12:23.241474
7382	Điểm hệ số 2 #1	1230	2	\N	2025-05-11 12:12:23.241474
7383	Điểm hệ số 2 #2	1230	2	\N	2025-05-11 12:12:23.241474
7384	Điểm hệ số 3	1230	3	\N	2025-05-11 12:12:23.241474
7385	Điểm hệ số 1 #1	1231	1	\N	2025-05-11 12:12:23.241474
7386	Điểm hệ số 1 #2	1231	1	\N	2025-05-11 12:12:23.241474
7387	Điểm hệ số 1 #3	1231	1	\N	2025-05-11 12:12:23.241474
7388	Điểm hệ số 2 #1	1231	2	\N	2025-05-11 12:12:23.241474
7389	Điểm hệ số 2 #2	1231	2	\N	2025-05-11 12:12:23.241474
7390	Điểm hệ số 3	1231	3	\N	2025-05-11 12:12:23.241474
7391	Điểm hệ số 1 #1	1232	1	\N	2025-05-11 12:12:23.241474
7392	Điểm hệ số 1 #2	1232	1	\N	2025-05-11 12:12:23.241474
7393	Điểm hệ số 1 #3	1232	1	\N	2025-05-11 12:12:23.241474
7394	Điểm hệ số 2 #1	1232	2	\N	2025-05-11 12:12:23.241474
7395	Điểm hệ số 2 #2	1232	2	\N	2025-05-11 12:12:23.241474
7396	Điểm hệ số 3	1232	3	\N	2025-05-11 12:12:23.241474
7397	Điểm hệ số 1 #1	1233	1	\N	2025-05-11 12:12:23.241474
7398	Điểm hệ số 1 #2	1233	1	\N	2025-05-11 12:12:23.241474
7399	Điểm hệ số 1 #3	1233	1	\N	2025-05-11 12:12:23.241474
7400	Điểm hệ số 2 #1	1233	2	\N	2025-05-11 12:12:23.241474
7401	Điểm hệ số 2 #2	1233	2	\N	2025-05-11 12:12:23.241474
7402	Điểm hệ số 3	1233	3	\N	2025-05-11 12:12:23.241474
7403	Điểm hệ số 1 #1	1234	1	\N	2025-05-11 12:12:23.241474
7404	Điểm hệ số 1 #2	1234	1	\N	2025-05-11 12:12:23.241474
7405	Điểm hệ số 1 #3	1234	1	\N	2025-05-11 12:12:23.241474
7406	Điểm hệ số 2 #1	1234	2	\N	2025-05-11 12:12:23.241474
7407	Điểm hệ số 2 #2	1234	2	\N	2025-05-11 12:12:23.241474
7408	Điểm hệ số 3	1234	3	\N	2025-05-11 12:12:23.241474
7409	Điểm hệ số 1 #1	1235	1	\N	2025-05-11 12:12:23.241474
7410	Điểm hệ số 1 #2	1235	1	\N	2025-05-11 12:12:23.241474
7411	Điểm hệ số 1 #3	1235	1	\N	2025-05-11 12:12:23.241474
7412	Điểm hệ số 2 #1	1235	2	\N	2025-05-11 12:12:23.241474
7413	Điểm hệ số 2 #2	1235	2	\N	2025-05-11 12:12:23.241474
7414	Điểm hệ số 3	1235	3	\N	2025-05-11 12:12:23.241474
7415	Điểm hệ số 1 #1	1236	1	\N	2025-05-11 12:12:23.241474
7416	Điểm hệ số 1 #2	1236	1	\N	2025-05-11 12:12:23.241474
7417	Điểm hệ số 1 #3	1236	1	\N	2025-05-11 12:12:23.241474
7418	Điểm hệ số 2 #1	1236	2	\N	2025-05-11 12:12:23.241474
7419	Điểm hệ số 2 #2	1236	2	\N	2025-05-11 12:12:23.241474
7420	Điểm hệ số 3	1236	3	\N	2025-05-11 12:12:23.241474
7421	Điểm hệ số 1 #1	1237	1	\N	2025-05-11 12:12:23.241474
7422	Điểm hệ số 1 #2	1237	1	\N	2025-05-11 12:12:23.241474
7423	Điểm hệ số 1 #3	1237	1	\N	2025-05-11 12:12:23.241474
7424	Điểm hệ số 2 #1	1237	2	\N	2025-05-11 12:12:23.241474
7425	Điểm hệ số 2 #2	1237	2	\N	2025-05-11 12:12:23.241474
7426	Điểm hệ số 3	1237	3	\N	2025-05-11 12:12:23.241474
7427	Điểm hệ số 1 #1	1238	1	\N	2025-05-11 12:12:23.241474
7428	Điểm hệ số 1 #2	1238	1	\N	2025-05-11 12:12:23.241474
7429	Điểm hệ số 1 #3	1238	1	\N	2025-05-11 12:12:23.241474
7430	Điểm hệ số 2 #1	1238	2	\N	2025-05-11 12:12:23.241474
7431	Điểm hệ số 2 #2	1238	2	\N	2025-05-11 12:12:23.241474
7432	Điểm hệ số 3	1238	3	\N	2025-05-11 12:12:23.241474
7433	Điểm hệ số 1 #1	1239	1	\N	2025-05-11 12:12:23.241474
7434	Điểm hệ số 1 #2	1239	1	\N	2025-05-11 12:12:23.241474
7435	Điểm hệ số 1 #3	1239	1	\N	2025-05-11 12:12:23.241474
7436	Điểm hệ số 2 #1	1239	2	\N	2025-05-11 12:12:23.241474
7437	Điểm hệ số 2 #2	1239	2	\N	2025-05-11 12:12:23.241474
7438	Điểm hệ số 3	1239	3	\N	2025-05-11 12:12:23.241474
7439	Điểm hệ số 1 #1	1240	1	\N	2025-05-11 12:12:23.241474
7440	Điểm hệ số 1 #2	1240	1	\N	2025-05-11 12:12:23.241474
7441	Điểm hệ số 1 #3	1240	1	\N	2025-05-11 12:12:23.241474
7442	Điểm hệ số 2 #1	1240	2	\N	2025-05-11 12:12:23.241474
7443	Điểm hệ số 2 #2	1240	2	\N	2025-05-11 12:12:23.241474
7444	Điểm hệ số 3	1240	3	\N	2025-05-11 12:12:23.241474
7445	Điểm hệ số 1 #1	1241	1	\N	2025-05-11 12:12:23.241474
7446	Điểm hệ số 1 #2	1241	1	\N	2025-05-11 12:12:23.241474
7447	Điểm hệ số 1 #3	1241	1	\N	2025-05-11 12:12:23.241474
7448	Điểm hệ số 2 #1	1241	2	\N	2025-05-11 12:12:23.241474
7449	Điểm hệ số 2 #2	1241	2	\N	2025-05-11 12:12:23.241474
7450	Điểm hệ số 3	1241	3	\N	2025-05-11 12:12:23.241474
7451	Điểm hệ số 1 #1	1242	1	\N	2025-05-11 12:12:23.241474
7452	Điểm hệ số 1 #2	1242	1	\N	2025-05-11 12:12:23.241474
7453	Điểm hệ số 1 #3	1242	1	\N	2025-05-11 12:12:23.241474
7454	Điểm hệ số 2 #1	1242	2	\N	2025-05-11 12:12:23.241474
7455	Điểm hệ số 2 #2	1242	2	\N	2025-05-11 12:12:23.241474
7456	Điểm hệ số 3	1242	3	\N	2025-05-11 12:12:23.241474
7457	Điểm hệ số 1 #1	1243	1	\N	2025-05-11 12:12:23.241474
7458	Điểm hệ số 1 #2	1243	1	\N	2025-05-11 12:12:23.241474
7459	Điểm hệ số 1 #3	1243	1	\N	2025-05-11 12:12:23.241474
7460	Điểm hệ số 2 #1	1243	2	\N	2025-05-11 12:12:23.241474
7461	Điểm hệ số 2 #2	1243	2	\N	2025-05-11 12:12:23.241474
7462	Điểm hệ số 3	1243	3	\N	2025-05-11 12:12:23.241474
7463	Điểm hệ số 1 #1	1244	1	\N	2025-05-11 12:12:23.241474
7464	Điểm hệ số 1 #2	1244	1	\N	2025-05-11 12:12:23.241474
7465	Điểm hệ số 1 #3	1244	1	\N	2025-05-11 12:12:23.241474
7466	Điểm hệ số 2 #1	1244	2	\N	2025-05-11 12:12:23.241474
7467	Điểm hệ số 2 #2	1244	2	\N	2025-05-11 12:12:23.241474
7468	Điểm hệ số 3	1244	3	\N	2025-05-11 12:12:23.241474
7469	Điểm hệ số 1 #1	1245	1	\N	2025-05-11 12:12:23.241474
7470	Điểm hệ số 1 #2	1245	1	\N	2025-05-11 12:12:23.241474
7471	Điểm hệ số 1 #3	1245	1	\N	2025-05-11 12:12:23.241474
7472	Điểm hệ số 2 #1	1245	2	\N	2025-05-11 12:12:23.241474
7473	Điểm hệ số 2 #2	1245	2	\N	2025-05-11 12:12:23.241474
7474	Điểm hệ số 3	1245	3	\N	2025-05-11 12:12:23.241474
7475	Điểm hệ số 1 #1	1246	1	\N	2025-05-11 12:12:23.242473
7476	Điểm hệ số 1 #2	1246	1	\N	2025-05-11 12:12:23.242473
7477	Điểm hệ số 1 #3	1246	1	\N	2025-05-11 12:12:23.242473
7478	Điểm hệ số 2 #1	1246	2	\N	2025-05-11 12:12:23.242473
7479	Điểm hệ số 2 #2	1246	2	\N	2025-05-11 12:12:23.242473
7480	Điểm hệ số 3	1246	3	\N	2025-05-11 12:12:23.242473
7481	Điểm hệ số 1 #1	1247	1	\N	2025-05-11 12:12:23.242473
7482	Điểm hệ số 1 #2	1247	1	\N	2025-05-11 12:12:23.242473
7483	Điểm hệ số 1 #3	1247	1	\N	2025-05-11 12:12:23.242473
7484	Điểm hệ số 2 #1	1247	2	\N	2025-05-11 12:12:23.242473
7485	Điểm hệ số 2 #2	1247	2	\N	2025-05-11 12:12:23.242473
7486	Điểm hệ số 3	1247	3	\N	2025-05-11 12:12:23.242473
7487	Điểm hệ số 1 #1	1248	1	\N	2025-05-11 12:12:23.242473
7488	Điểm hệ số 1 #2	1248	1	\N	2025-05-11 12:12:23.242473
7489	Điểm hệ số 1 #3	1248	1	\N	2025-05-11 12:12:23.242473
7490	Điểm hệ số 2 #1	1248	2	\N	2025-05-11 12:12:23.242473
7491	Điểm hệ số 2 #2	1248	2	\N	2025-05-11 12:12:23.242473
7492	Điểm hệ số 3	1248	3	\N	2025-05-11 12:12:23.242473
7493	Điểm hệ số 1 #1	1249	1	\N	2025-05-11 12:12:23.242473
7494	Điểm hệ số 1 #2	1249	1	\N	2025-05-11 12:12:23.242473
7495	Điểm hệ số 1 #3	1249	1	\N	2025-05-11 12:12:23.242473
7496	Điểm hệ số 2 #1	1249	2	\N	2025-05-11 12:12:23.242473
7497	Điểm hệ số 2 #2	1249	2	\N	2025-05-11 12:12:23.242473
7498	Điểm hệ số 3	1249	3	\N	2025-05-11 12:12:23.242473
7499	Điểm hệ số 1 #1	1250	1	\N	2025-05-11 12:12:23.242473
7500	Điểm hệ số 1 #2	1250	1	\N	2025-05-11 12:12:23.242473
7501	Điểm hệ số 1 #3	1250	1	\N	2025-05-11 12:12:23.242473
7502	Điểm hệ số 2 #1	1250	2	\N	2025-05-11 12:12:23.242473
7503	Điểm hệ số 2 #2	1250	2	\N	2025-05-11 12:12:23.242473
7504	Điểm hệ số 3	1250	3	\N	2025-05-11 12:12:23.242473
7505	Điểm hệ số 1 #1	1251	1	\N	2025-05-11 12:12:23.242473
7506	Điểm hệ số 1 #2	1251	1	\N	2025-05-11 12:12:23.242473
7507	Điểm hệ số 1 #3	1251	1	\N	2025-05-11 12:12:23.242473
7508	Điểm hệ số 2 #1	1251	2	\N	2025-05-11 12:12:23.242473
7509	Điểm hệ số 2 #2	1251	2	\N	2025-05-11 12:12:23.242473
7510	Điểm hệ số 3	1251	3	\N	2025-05-11 12:12:23.242473
7511	Điểm hệ số 1 #1	1252	1	\N	2025-05-11 12:12:23.242473
7512	Điểm hệ số 1 #2	1252	1	\N	2025-05-11 12:12:23.242473
7513	Điểm hệ số 1 #3	1252	1	\N	2025-05-11 12:12:23.242473
7514	Điểm hệ số 2 #1	1252	2	\N	2025-05-11 12:12:23.242473
7515	Điểm hệ số 2 #2	1252	2	\N	2025-05-11 12:12:23.242473
7516	Điểm hệ số 3	1252	3	\N	2025-05-11 12:12:23.242473
7517	Điểm hệ số 1 #1	1253	1	\N	2025-05-11 12:12:23.242473
7518	Điểm hệ số 1 #2	1253	1	\N	2025-05-11 12:12:23.242473
7519	Điểm hệ số 1 #3	1253	1	\N	2025-05-11 12:12:23.242473
7520	Điểm hệ số 2 #1	1253	2	\N	2025-05-11 12:12:23.242473
7521	Điểm hệ số 2 #2	1253	2	\N	2025-05-11 12:12:23.242473
7522	Điểm hệ số 3	1253	3	\N	2025-05-11 12:12:23.242473
7523	Điểm hệ số 1 #1	1254	1	\N	2025-05-11 12:12:23.242473
7524	Điểm hệ số 1 #2	1254	1	\N	2025-05-11 12:12:23.242473
7525	Điểm hệ số 1 #3	1254	1	\N	2025-05-11 12:12:23.242473
7526	Điểm hệ số 2 #1	1254	2	\N	2025-05-11 12:12:23.242473
7527	Điểm hệ số 2 #2	1254	2	\N	2025-05-11 12:12:23.242473
7528	Điểm hệ số 3	1254	3	\N	2025-05-11 12:12:23.242473
7529	Điểm hệ số 1 #1	1255	1	\N	2025-05-11 12:12:23.242473
7530	Điểm hệ số 1 #2	1255	1	\N	2025-05-11 12:12:23.242473
7531	Điểm hệ số 1 #3	1255	1	\N	2025-05-11 12:12:23.242473
7532	Điểm hệ số 2 #1	1255	2	\N	2025-05-11 12:12:23.242473
7533	Điểm hệ số 2 #2	1255	2	\N	2025-05-11 12:12:23.242473
7534	Điểm hệ số 3	1255	3	\N	2025-05-11 12:12:23.242473
7535	Điểm hệ số 1 #1	1256	1	\N	2025-05-11 12:12:23.242473
7536	Điểm hệ số 1 #2	1256	1	\N	2025-05-11 12:12:23.242473
7537	Điểm hệ số 1 #3	1256	1	\N	2025-05-11 12:12:23.242473
7538	Điểm hệ số 2 #1	1256	2	\N	2025-05-11 12:12:23.242473
7539	Điểm hệ số 2 #2	1256	2	\N	2025-05-11 12:12:23.242473
7540	Điểm hệ số 3	1256	3	\N	2025-05-11 12:12:23.242473
7541	Điểm hệ số 1 #1	1257	1	\N	2025-05-11 12:12:23.242473
7542	Điểm hệ số 1 #2	1257	1	\N	2025-05-11 12:12:23.242473
7543	Điểm hệ số 1 #3	1257	1	\N	2025-05-11 12:12:23.242473
7544	Điểm hệ số 2 #1	1257	2	\N	2025-05-11 12:12:23.242473
7545	Điểm hệ số 2 #2	1257	2	\N	2025-05-11 12:12:23.242473
7546	Điểm hệ số 3	1257	3	\N	2025-05-11 12:12:23.242473
7547	Điểm hệ số 1 #1	1258	1	\N	2025-05-11 12:12:23.242473
7548	Điểm hệ số 1 #2	1258	1	\N	2025-05-11 12:12:23.242473
7549	Điểm hệ số 1 #3	1258	1	\N	2025-05-11 12:12:23.242473
7550	Điểm hệ số 2 #1	1258	2	\N	2025-05-11 12:12:23.242473
7551	Điểm hệ số 2 #2	1258	2	\N	2025-05-11 12:12:23.242473
7552	Điểm hệ số 3	1258	3	\N	2025-05-11 12:12:23.242473
7553	Điểm hệ số 1 #1	1259	1	\N	2025-05-11 12:12:23.242473
7554	Điểm hệ số 1 #2	1259	1	\N	2025-05-11 12:12:23.242473
7555	Điểm hệ số 1 #3	1259	1	\N	2025-05-11 12:12:23.242473
7556	Điểm hệ số 2 #1	1259	2	\N	2025-05-11 12:12:23.242473
7557	Điểm hệ số 2 #2	1259	2	\N	2025-05-11 12:12:23.242473
7558	Điểm hệ số 3	1259	3	\N	2025-05-11 12:12:23.242473
7559	Điểm hệ số 1 #1	1260	1	\N	2025-05-11 12:12:24.369212
7560	Điểm hệ số 1 #2	1260	1	\N	2025-05-11 12:12:24.369212
7561	Điểm hệ số 1 #3	1260	1	\N	2025-05-11 12:12:24.369212
7562	Điểm hệ số 2 #1	1260	2	\N	2025-05-11 12:12:24.369212
7563	Điểm hệ số 2 #2	1260	2	\N	2025-05-11 12:12:24.369212
7564	Điểm hệ số 3	1260	3	\N	2025-05-11 12:12:24.369212
7565	Điểm hệ số 1 #1	1261	1	\N	2025-05-11 12:12:24.369212
7566	Điểm hệ số 1 #2	1261	1	\N	2025-05-11 12:12:24.369212
7567	Điểm hệ số 1 #3	1261	1	\N	2025-05-11 12:12:24.369212
7568	Điểm hệ số 2 #1	1261	2	\N	2025-05-11 12:12:24.369212
7569	Điểm hệ số 2 #2	1261	2	\N	2025-05-11 12:12:24.369212
7570	Điểm hệ số 3	1261	3	\N	2025-05-11 12:12:24.369212
7571	Điểm hệ số 1 #1	1262	1	\N	2025-05-11 12:12:24.369212
7572	Điểm hệ số 1 #2	1262	1	\N	2025-05-11 12:12:24.369212
7573	Điểm hệ số 1 #3	1262	1	\N	2025-05-11 12:12:24.369212
7574	Điểm hệ số 2 #1	1262	2	\N	2025-05-11 12:12:24.369212
7575	Điểm hệ số 2 #2	1262	2	\N	2025-05-11 12:12:24.369212
7576	Điểm hệ số 3	1262	3	\N	2025-05-11 12:12:24.369212
7577	Điểm hệ số 1 #1	1263	1	\N	2025-05-11 12:12:24.369212
7578	Điểm hệ số 1 #2	1263	1	\N	2025-05-11 12:12:24.369212
7579	Điểm hệ số 1 #3	1263	1	\N	2025-05-11 12:12:24.369212
7580	Điểm hệ số 2 #1	1263	2	\N	2025-05-11 12:12:24.369212
7581	Điểm hệ số 2 #2	1263	2	\N	2025-05-11 12:12:24.369212
7582	Điểm hệ số 3	1263	3	\N	2025-05-11 12:12:24.369212
7583	Điểm hệ số 1 #1	1264	1	\N	2025-05-11 12:12:24.369212
7584	Điểm hệ số 1 #2	1264	1	\N	2025-05-11 12:12:24.369212
7585	Điểm hệ số 1 #3	1264	1	\N	2025-05-11 12:12:24.369212
7586	Điểm hệ số 2 #1	1264	2	\N	2025-05-11 12:12:24.369212
7587	Điểm hệ số 2 #2	1264	2	\N	2025-05-11 12:12:24.369212
7588	Điểm hệ số 3	1264	3	\N	2025-05-11 12:12:24.369212
7589	Điểm hệ số 1 #1	1265	1	\N	2025-05-11 12:12:24.369212
7590	Điểm hệ số 1 #2	1265	1	\N	2025-05-11 12:12:24.369212
7591	Điểm hệ số 1 #3	1265	1	\N	2025-05-11 12:12:24.369212
7592	Điểm hệ số 2 #1	1265	2	\N	2025-05-11 12:12:24.369212
7593	Điểm hệ số 2 #2	1265	2	\N	2025-05-11 12:12:24.369212
7594	Điểm hệ số 3	1265	3	\N	2025-05-11 12:12:24.369212
7595	Điểm hệ số 1 #1	1266	1	\N	2025-05-11 12:12:24.369212
7596	Điểm hệ số 1 #2	1266	1	\N	2025-05-11 12:12:24.369212
7597	Điểm hệ số 1 #3	1266	1	\N	2025-05-11 12:12:24.369212
7598	Điểm hệ số 2 #1	1266	2	\N	2025-05-11 12:12:24.369212
7599	Điểm hệ số 2 #2	1266	2	\N	2025-05-11 12:12:24.369212
7600	Điểm hệ số 3	1266	3	\N	2025-05-11 12:12:24.369212
7601	Điểm hệ số 1 #1	1267	1	\N	2025-05-11 12:12:24.369212
7602	Điểm hệ số 1 #2	1267	1	\N	2025-05-11 12:12:24.369212
7603	Điểm hệ số 1 #3	1267	1	\N	2025-05-11 12:12:24.369212
7604	Điểm hệ số 2 #1	1267	2	\N	2025-05-11 12:12:24.369212
7605	Điểm hệ số 2 #2	1267	2	\N	2025-05-11 12:12:24.369212
7606	Điểm hệ số 3	1267	3	\N	2025-05-11 12:12:24.369212
7607	Điểm hệ số 1 #1	1268	1	\N	2025-05-11 12:12:24.369212
7608	Điểm hệ số 1 #2	1268	1	\N	2025-05-11 12:12:24.369212
7609	Điểm hệ số 1 #3	1268	1	\N	2025-05-11 12:12:24.369212
7610	Điểm hệ số 2 #1	1268	2	\N	2025-05-11 12:12:24.369212
7611	Điểm hệ số 2 #2	1268	2	\N	2025-05-11 12:12:24.369212
7612	Điểm hệ số 3	1268	3	\N	2025-05-11 12:12:24.369212
7613	Điểm hệ số 1 #1	1269	1	\N	2025-05-11 12:12:24.369212
7614	Điểm hệ số 1 #2	1269	1	\N	2025-05-11 12:12:24.369212
7615	Điểm hệ số 1 #3	1269	1	\N	2025-05-11 12:12:24.369212
7616	Điểm hệ số 2 #1	1269	2	\N	2025-05-11 12:12:24.369212
7617	Điểm hệ số 2 #2	1269	2	\N	2025-05-11 12:12:24.369212
7618	Điểm hệ số 3	1269	3	\N	2025-05-11 12:12:24.369212
7619	Điểm hệ số 1 #1	1270	1	\N	2025-05-11 12:12:24.369212
7620	Điểm hệ số 1 #2	1270	1	\N	2025-05-11 12:12:24.369212
7621	Điểm hệ số 1 #3	1270	1	\N	2025-05-11 12:12:24.369212
7622	Điểm hệ số 2 #1	1270	2	\N	2025-05-11 12:12:24.369212
7623	Điểm hệ số 2 #2	1270	2	\N	2025-05-11 12:12:24.369212
7624	Điểm hệ số 3	1270	3	\N	2025-05-11 12:12:24.369212
7625	Điểm hệ số 1 #1	1271	1	\N	2025-05-11 12:12:24.369212
7626	Điểm hệ số 1 #2	1271	1	\N	2025-05-11 12:12:24.369212
7627	Điểm hệ số 1 #3	1271	1	\N	2025-05-11 12:12:24.369212
7628	Điểm hệ số 2 #1	1271	2	\N	2025-05-11 12:12:24.369212
7629	Điểm hệ số 2 #2	1271	2	\N	2025-05-11 12:12:24.369212
7630	Điểm hệ số 3	1271	3	\N	2025-05-11 12:12:24.369212
7631	Điểm hệ số 1 #1	1272	1	\N	2025-05-11 12:12:24.369212
7632	Điểm hệ số 1 #2	1272	1	\N	2025-05-11 12:12:24.369212
7633	Điểm hệ số 1 #3	1272	1	\N	2025-05-11 12:12:24.369212
7634	Điểm hệ số 2 #1	1272	2	\N	2025-05-11 12:12:24.369212
7635	Điểm hệ số 2 #2	1272	2	\N	2025-05-11 12:12:24.369212
7636	Điểm hệ số 3	1272	3	\N	2025-05-11 12:12:24.369212
7637	Điểm hệ số 1 #1	1273	1	\N	2025-05-11 12:12:24.369212
7638	Điểm hệ số 1 #2	1273	1	\N	2025-05-11 12:12:24.369212
7639	Điểm hệ số 1 #3	1273	1	\N	2025-05-11 12:12:24.369212
7640	Điểm hệ số 2 #1	1273	2	\N	2025-05-11 12:12:24.369212
7641	Điểm hệ số 2 #2	1273	2	\N	2025-05-11 12:12:24.369212
7642	Điểm hệ số 3	1273	3	\N	2025-05-11 12:12:24.369212
7643	Điểm hệ số 1 #1	1274	1	\N	2025-05-11 12:12:24.369212
7644	Điểm hệ số 1 #2	1274	1	\N	2025-05-11 12:12:24.369212
7645	Điểm hệ số 1 #3	1274	1	\N	2025-05-11 12:12:24.369212
7646	Điểm hệ số 2 #1	1274	2	\N	2025-05-11 12:12:24.369212
7647	Điểm hệ số 2 #2	1274	2	\N	2025-05-11 12:12:24.369212
7648	Điểm hệ số 3	1274	3	\N	2025-05-11 12:12:24.369212
7649	Điểm hệ số 1 #1	1275	1	\N	2025-05-11 12:12:24.369212
7650	Điểm hệ số 1 #2	1275	1	\N	2025-05-11 12:12:24.369212
7651	Điểm hệ số 1 #3	1275	1	\N	2025-05-11 12:12:24.369212
7652	Điểm hệ số 2 #1	1275	2	\N	2025-05-11 12:12:24.369212
7653	Điểm hệ số 2 #2	1275	2	\N	2025-05-11 12:12:24.369212
7654	Điểm hệ số 3	1275	3	\N	2025-05-11 12:12:24.369212
7655	Điểm hệ số 1 #1	1276	1	\N	2025-05-11 12:12:24.369212
7656	Điểm hệ số 1 #2	1276	1	\N	2025-05-11 12:12:24.369212
7657	Điểm hệ số 1 #3	1276	1	\N	2025-05-11 12:12:24.369212
7658	Điểm hệ số 2 #1	1276	2	\N	2025-05-11 12:12:24.369212
7659	Điểm hệ số 2 #2	1276	2	\N	2025-05-11 12:12:24.369212
7660	Điểm hệ số 3	1276	3	\N	2025-05-11 12:12:24.369212
7661	Điểm hệ số 1 #1	1277	1	\N	2025-05-11 12:12:24.369212
7662	Điểm hệ số 1 #2	1277	1	\N	2025-05-11 12:12:24.369212
7663	Điểm hệ số 1 #3	1277	1	\N	2025-05-11 12:12:24.369212
7664	Điểm hệ số 2 #1	1277	2	\N	2025-05-11 12:12:24.369212
7665	Điểm hệ số 2 #2	1277	2	\N	2025-05-11 12:12:24.369212
7666	Điểm hệ số 3	1277	3	\N	2025-05-11 12:12:24.369212
7667	Điểm hệ số 1 #1	1278	1	\N	2025-05-11 12:12:24.369212
7668	Điểm hệ số 1 #2	1278	1	\N	2025-05-11 12:12:24.369212
7669	Điểm hệ số 1 #3	1278	1	\N	2025-05-11 12:12:24.369212
7670	Điểm hệ số 2 #1	1278	2	\N	2025-05-11 12:12:24.369212
7671	Điểm hệ số 2 #2	1278	2	\N	2025-05-11 12:12:24.369212
7672	Điểm hệ số 3	1278	3	\N	2025-05-11 12:12:24.369212
7673	Điểm hệ số 1 #1	1279	1	\N	2025-05-11 12:12:24.369212
7674	Điểm hệ số 1 #2	1279	1	\N	2025-05-11 12:12:24.369212
7675	Điểm hệ số 1 #3	1279	1	\N	2025-05-11 12:12:24.369212
7676	Điểm hệ số 2 #1	1279	2	\N	2025-05-11 12:12:24.369212
7677	Điểm hệ số 2 #2	1279	2	\N	2025-05-11 12:12:24.369212
7678	Điểm hệ số 3	1279	3	\N	2025-05-11 12:12:24.369212
7679	Điểm hệ số 1 #1	1280	1	\N	2025-05-11 12:12:24.369212
7680	Điểm hệ số 1 #2	1280	1	\N	2025-05-11 12:12:24.369212
7681	Điểm hệ số 1 #3	1280	1	\N	2025-05-11 12:12:24.369212
7682	Điểm hệ số 2 #1	1280	2	\N	2025-05-11 12:12:24.369212
7683	Điểm hệ số 2 #2	1280	2	\N	2025-05-11 12:12:24.369212
7684	Điểm hệ số 3	1280	3	\N	2025-05-11 12:12:24.369212
7685	Điểm hệ số 1 #1	1281	1	\N	2025-05-11 12:12:24.369212
7686	Điểm hệ số 1 #2	1281	1	\N	2025-05-11 12:12:24.369212
7687	Điểm hệ số 1 #3	1281	1	\N	2025-05-11 12:12:24.369212
7688	Điểm hệ số 2 #1	1281	2	\N	2025-05-11 12:12:24.369212
7689	Điểm hệ số 2 #2	1281	2	\N	2025-05-11 12:12:24.369212
7690	Điểm hệ số 3	1281	3	\N	2025-05-11 12:12:24.369212
7691	Điểm hệ số 1 #1	1282	1	\N	2025-05-11 12:12:24.369212
7692	Điểm hệ số 1 #2	1282	1	\N	2025-05-11 12:12:24.369212
7693	Điểm hệ số 1 #3	1282	1	\N	2025-05-11 12:12:24.369212
7694	Điểm hệ số 2 #1	1282	2	\N	2025-05-11 12:12:24.369212
7695	Điểm hệ số 2 #2	1282	2	\N	2025-05-11 12:12:24.369212
7696	Điểm hệ số 3	1282	3	\N	2025-05-11 12:12:24.369212
7697	Điểm hệ số 1 #1	1283	1	\N	2025-05-11 12:12:24.369212
7698	Điểm hệ số 1 #2	1283	1	\N	2025-05-11 12:12:24.369212
7699	Điểm hệ số 1 #3	1283	1	\N	2025-05-11 12:12:24.369212
7700	Điểm hệ số 2 #1	1283	2	\N	2025-05-11 12:12:24.369212
7701	Điểm hệ số 2 #2	1283	2	\N	2025-05-11 12:12:24.369212
7702	Điểm hệ số 3	1283	3	\N	2025-05-11 12:12:24.369212
7703	Điểm hệ số 1 #1	1284	1	\N	2025-05-11 12:12:24.369212
7704	Điểm hệ số 1 #2	1284	1	\N	2025-05-11 12:12:24.369212
7705	Điểm hệ số 1 #3	1284	1	\N	2025-05-11 12:12:24.369212
7706	Điểm hệ số 2 #1	1284	2	\N	2025-05-11 12:12:24.369212
7707	Điểm hệ số 2 #2	1284	2	\N	2025-05-11 12:12:24.369212
7708	Điểm hệ số 3	1284	3	\N	2025-05-11 12:12:24.369212
7709	Điểm hệ số 1 #1	1285	1	\N	2025-05-11 12:12:24.369212
7710	Điểm hệ số 1 #2	1285	1	\N	2025-05-11 12:12:24.369212
7711	Điểm hệ số 1 #3	1285	1	\N	2025-05-11 12:12:24.369212
7712	Điểm hệ số 2 #1	1285	2	\N	2025-05-11 12:12:24.369212
7713	Điểm hệ số 2 #2	1285	2	\N	2025-05-11 12:12:24.369212
7714	Điểm hệ số 3	1285	3	\N	2025-05-11 12:12:24.369212
7715	Điểm hệ số 1 #1	1286	1	\N	2025-05-11 12:12:24.370211
7716	Điểm hệ số 1 #2	1286	1	\N	2025-05-11 12:12:24.370211
7717	Điểm hệ số 1 #3	1286	1	\N	2025-05-11 12:12:24.370211
7718	Điểm hệ số 2 #1	1286	2	\N	2025-05-11 12:12:24.370211
7719	Điểm hệ số 2 #2	1286	2	\N	2025-05-11 12:12:24.370211
7720	Điểm hệ số 3	1286	3	\N	2025-05-11 12:12:24.370211
7721	Điểm hệ số 1 #1	1287	1	\N	2025-05-11 12:12:24.370211
7722	Điểm hệ số 1 #2	1287	1	\N	2025-05-11 12:12:24.370211
7723	Điểm hệ số 1 #3	1287	1	\N	2025-05-11 12:12:24.370211
7724	Điểm hệ số 2 #1	1287	2	\N	2025-05-11 12:12:24.370211
7725	Điểm hệ số 2 #2	1287	2	\N	2025-05-11 12:12:24.370211
7726	Điểm hệ số 3	1287	3	\N	2025-05-11 12:12:24.370211
7727	Điểm hệ số 1 #1	1288	1	\N	2025-05-11 12:12:24.370211
7728	Điểm hệ số 1 #2	1288	1	\N	2025-05-11 12:12:24.370211
7729	Điểm hệ số 1 #3	1288	1	\N	2025-05-11 12:12:24.370211
7730	Điểm hệ số 2 #1	1288	2	\N	2025-05-11 12:12:24.370211
7731	Điểm hệ số 2 #2	1288	2	\N	2025-05-11 12:12:24.370211
7732	Điểm hệ số 3	1288	3	\N	2025-05-11 12:12:24.370211
7733	Điểm hệ số 1 #1	1289	1	\N	2025-05-11 12:12:24.370211
7734	Điểm hệ số 1 #2	1289	1	\N	2025-05-11 12:12:24.370211
7735	Điểm hệ số 1 #3	1289	1	\N	2025-05-11 12:12:24.370211
7736	Điểm hệ số 2 #1	1289	2	\N	2025-05-11 12:12:24.370211
7737	Điểm hệ số 2 #2	1289	2	\N	2025-05-11 12:12:24.370211
7738	Điểm hệ số 3	1289	3	\N	2025-05-11 12:12:24.370211
7739	Điểm hệ số 1 #1	1290	1	\N	2025-05-11 12:12:24.370211
7740	Điểm hệ số 1 #2	1290	1	\N	2025-05-11 12:12:24.370211
7741	Điểm hệ số 1 #3	1290	1	\N	2025-05-11 12:12:24.370211
7742	Điểm hệ số 2 #1	1290	2	\N	2025-05-11 12:12:24.370211
7743	Điểm hệ số 2 #2	1290	2	\N	2025-05-11 12:12:24.370211
7744	Điểm hệ số 3	1290	3	\N	2025-05-11 12:12:24.370211
7745	Điểm hệ số 1 #1	1291	1	\N	2025-05-11 12:12:24.370211
7746	Điểm hệ số 1 #2	1291	1	\N	2025-05-11 12:12:24.370211
7747	Điểm hệ số 1 #3	1291	1	\N	2025-05-11 12:12:24.370211
7748	Điểm hệ số 2 #1	1291	2	\N	2025-05-11 12:12:24.370211
7749	Điểm hệ số 2 #2	1291	2	\N	2025-05-11 12:12:24.370211
7750	Điểm hệ số 3	1291	3	\N	2025-05-11 12:12:24.370211
7751	Điểm hệ số 1 #1	1292	1	\N	2025-05-11 12:12:24.370211
7752	Điểm hệ số 1 #2	1292	1	\N	2025-05-11 12:12:24.370211
7753	Điểm hệ số 1 #3	1292	1	\N	2025-05-11 12:12:24.370211
7754	Điểm hệ số 2 #1	1292	2	\N	2025-05-11 12:12:24.370211
7755	Điểm hệ số 2 #2	1292	2	\N	2025-05-11 12:12:24.370211
7756	Điểm hệ số 3	1292	3	\N	2025-05-11 12:12:24.370211
7757	Điểm hệ số 1 #1	1293	1	\N	2025-05-11 12:12:24.370211
7758	Điểm hệ số 1 #2	1293	1	\N	2025-05-11 12:12:24.370211
7759	Điểm hệ số 1 #3	1293	1	\N	2025-05-11 12:12:24.370211
7760	Điểm hệ số 2 #1	1293	2	\N	2025-05-11 12:12:24.370211
7761	Điểm hệ số 2 #2	1293	2	\N	2025-05-11 12:12:24.370211
7762	Điểm hệ số 3	1293	3	\N	2025-05-11 12:12:24.370211
7763	Điểm hệ số 1 #1	1294	1	\N	2025-05-11 12:12:24.370211
7764	Điểm hệ số 1 #2	1294	1	\N	2025-05-11 12:12:24.370211
7765	Điểm hệ số 1 #3	1294	1	\N	2025-05-11 12:12:24.370211
7766	Điểm hệ số 2 #1	1294	2	\N	2025-05-11 12:12:24.370211
7767	Điểm hệ số 2 #2	1294	2	\N	2025-05-11 12:12:24.370211
7768	Điểm hệ số 3	1294	3	\N	2025-05-11 12:12:24.370211
7769	Điểm hệ số 1 #1	1295	1	\N	2025-05-11 12:12:24.370211
7770	Điểm hệ số 1 #2	1295	1	\N	2025-05-11 12:12:24.370211
7771	Điểm hệ số 1 #3	1295	1	\N	2025-05-11 12:12:24.370211
7772	Điểm hệ số 2 #1	1295	2	\N	2025-05-11 12:12:24.370211
7773	Điểm hệ số 2 #2	1295	2	\N	2025-05-11 12:12:24.370211
7774	Điểm hệ số 3	1295	3	\N	2025-05-11 12:12:24.370211
7775	Điểm hệ số 1 #1	1296	1	\N	2025-05-11 12:12:24.370211
7776	Điểm hệ số 1 #2	1296	1	\N	2025-05-11 12:12:24.370211
7777	Điểm hệ số 1 #3	1296	1	\N	2025-05-11 12:12:24.370211
7778	Điểm hệ số 2 #1	1296	2	\N	2025-05-11 12:12:24.370211
7779	Điểm hệ số 2 #2	1296	2	\N	2025-05-11 12:12:24.370211
7780	Điểm hệ số 3	1296	3	\N	2025-05-11 12:12:24.370211
7781	Điểm hệ số 1 #1	1297	1	\N	2025-05-11 12:12:24.370211
7782	Điểm hệ số 1 #2	1297	1	\N	2025-05-11 12:12:24.370211
7783	Điểm hệ số 1 #3	1297	1	\N	2025-05-11 12:12:24.370211
7784	Điểm hệ số 2 #1	1297	2	\N	2025-05-11 12:12:24.370211
7785	Điểm hệ số 2 #2	1297	2	\N	2025-05-11 12:12:24.370211
7786	Điểm hệ số 3	1297	3	\N	2025-05-11 12:12:24.370211
7787	Điểm hệ số 1 #1	1298	1	\N	2025-05-11 12:12:24.370211
7788	Điểm hệ số 1 #2	1298	1	\N	2025-05-11 12:12:24.370211
7789	Điểm hệ số 1 #3	1298	1	\N	2025-05-11 12:12:24.370211
7790	Điểm hệ số 2 #1	1298	2	\N	2025-05-11 12:12:24.370211
7791	Điểm hệ số 2 #2	1298	2	\N	2025-05-11 12:12:24.370211
7792	Điểm hệ số 3	1298	3	\N	2025-05-11 12:12:24.370211
7793	Điểm hệ số 1 #1	1299	1	\N	2025-05-11 12:12:24.370211
7794	Điểm hệ số 1 #2	1299	1	\N	2025-05-11 12:12:24.370211
7795	Điểm hệ số 1 #3	1299	1	\N	2025-05-11 12:12:24.370211
7796	Điểm hệ số 2 #1	1299	2	\N	2025-05-11 12:12:24.370211
7797	Điểm hệ số 2 #2	1299	2	\N	2025-05-11 12:12:24.370211
7798	Điểm hệ số 3	1299	3	\N	2025-05-11 12:12:24.370211
7799	Điểm hệ số 1 #1	1300	1	\N	2025-05-11 12:12:24.370211
7800	Điểm hệ số 1 #2	1300	1	\N	2025-05-11 12:12:24.370211
7801	Điểm hệ số 1 #3	1300	1	\N	2025-05-11 12:12:24.370211
7802	Điểm hệ số 2 #1	1300	2	\N	2025-05-11 12:12:24.370211
7803	Điểm hệ số 2 #2	1300	2	\N	2025-05-11 12:12:24.370211
7804	Điểm hệ số 3	1300	3	\N	2025-05-11 12:12:24.370211
7805	Điểm hệ số 1 #1	1301	1	\N	2025-05-11 12:12:24.370211
7806	Điểm hệ số 1 #2	1301	1	\N	2025-05-11 12:12:24.370211
7807	Điểm hệ số 1 #3	1301	1	\N	2025-05-11 12:12:24.370211
7808	Điểm hệ số 2 #1	1301	2	\N	2025-05-11 12:12:24.370211
7809	Điểm hệ số 2 #2	1301	2	\N	2025-05-11 12:12:24.370211
7810	Điểm hệ số 3	1301	3	\N	2025-05-11 12:12:24.370211
7811	Điểm hệ số 1 #1	1302	1	\N	2025-05-11 12:12:24.370211
7812	Điểm hệ số 1 #2	1302	1	\N	2025-05-11 12:12:24.370211
7813	Điểm hệ số 1 #3	1302	1	\N	2025-05-11 12:12:24.370211
7814	Điểm hệ số 2 #1	1302	2	\N	2025-05-11 12:12:24.370211
7815	Điểm hệ số 2 #2	1302	2	\N	2025-05-11 12:12:24.370211
7816	Điểm hệ số 3	1302	3	\N	2025-05-11 12:12:24.370211
7817	Điểm hệ số 1 #1	1303	1	\N	2025-05-11 12:12:24.370211
7818	Điểm hệ số 1 #2	1303	1	\N	2025-05-11 12:12:24.370211
7819	Điểm hệ số 1 #3	1303	1	\N	2025-05-11 12:12:24.370211
7820	Điểm hệ số 2 #1	1303	2	\N	2025-05-11 12:12:24.370211
7821	Điểm hệ số 2 #2	1303	2	\N	2025-05-11 12:12:24.370211
7822	Điểm hệ số 3	1303	3	\N	2025-05-11 12:12:24.370211
7823	Điểm hệ số 1 #1	1304	1	\N	2025-05-11 12:12:24.370211
7824	Điểm hệ số 1 #2	1304	1	\N	2025-05-11 12:12:24.370211
7825	Điểm hệ số 1 #3	1304	1	\N	2025-05-11 12:12:24.370211
7826	Điểm hệ số 2 #1	1304	2	\N	2025-05-11 12:12:24.370211
7827	Điểm hệ số 2 #2	1304	2	\N	2025-05-11 12:12:24.370211
7828	Điểm hệ số 3	1304	3	\N	2025-05-11 12:12:24.370211
7829	Điểm hệ số 1 #1	1305	1	\N	2025-05-11 12:12:24.370211
7830	Điểm hệ số 1 #2	1305	1	\N	2025-05-11 12:12:24.370211
7831	Điểm hệ số 1 #3	1305	1	\N	2025-05-11 12:12:24.370211
7832	Điểm hệ số 2 #1	1305	2	\N	2025-05-11 12:12:24.370211
7833	Điểm hệ số 2 #2	1305	2	\N	2025-05-11 12:12:24.370211
7834	Điểm hệ số 3	1305	3	\N	2025-05-11 12:12:24.370211
7835	Điểm hệ số 1 #1	1306	1	\N	2025-05-11 12:12:24.370211
7836	Điểm hệ số 1 #2	1306	1	\N	2025-05-11 12:12:24.370211
7837	Điểm hệ số 1 #3	1306	1	\N	2025-05-11 12:12:24.370211
7838	Điểm hệ số 2 #1	1306	2	\N	2025-05-11 12:12:24.370211
7839	Điểm hệ số 2 #2	1306	2	\N	2025-05-11 12:12:24.370211
7840	Điểm hệ số 3	1306	3	\N	2025-05-11 12:12:24.370211
7841	Điểm hệ số 1 #1	1307	1	\N	2025-05-11 12:12:24.370211
7842	Điểm hệ số 1 #2	1307	1	\N	2025-05-11 12:12:24.370211
7843	Điểm hệ số 1 #3	1307	1	\N	2025-05-11 12:12:24.370211
7844	Điểm hệ số 2 #1	1307	2	\N	2025-05-11 12:12:24.370211
7845	Điểm hệ số 2 #2	1307	2	\N	2025-05-11 12:12:24.370211
7846	Điểm hệ số 3	1307	3	\N	2025-05-11 12:12:24.370211
7847	Điểm hệ số 1 #1	1308	1	\N	2025-05-11 12:12:24.370211
7848	Điểm hệ số 1 #2	1308	1	\N	2025-05-11 12:12:24.370211
7849	Điểm hệ số 1 #3	1308	1	\N	2025-05-11 12:12:24.370211
7850	Điểm hệ số 2 #1	1308	2	\N	2025-05-11 12:12:24.370211
7851	Điểm hệ số 2 #2	1308	2	\N	2025-05-11 12:12:24.370211
7852	Điểm hệ số 3	1308	3	\N	2025-05-11 12:12:24.370211
7853	Điểm hệ số 1 #1	1309	1	\N	2025-05-11 12:12:24.370211
7854	Điểm hệ số 1 #2	1309	1	\N	2025-05-11 12:12:24.370211
7855	Điểm hệ số 1 #3	1309	1	\N	2025-05-11 12:12:24.370211
7856	Điểm hệ số 2 #1	1309	2	\N	2025-05-11 12:12:24.370211
7857	Điểm hệ số 2 #2	1309	2	\N	2025-05-11 12:12:24.370211
7858	Điểm hệ số 3	1309	3	\N	2025-05-11 12:12:24.370211
7859	Điểm hệ số 1 #1	1310	1	\N	2025-05-11 12:12:24.370211
7860	Điểm hệ số 1 #2	1310	1	\N	2025-05-11 12:12:24.370211
7861	Điểm hệ số 1 #3	1310	1	\N	2025-05-11 12:12:24.370211
7862	Điểm hệ số 2 #1	1310	2	\N	2025-05-11 12:12:24.370211
7863	Điểm hệ số 2 #2	1310	2	\N	2025-05-11 12:12:24.370211
7864	Điểm hệ số 3	1310	3	\N	2025-05-11 12:12:24.370211
7865	Điểm hệ số 1 #1	1311	1	\N	2025-05-11 12:12:24.370211
7866	Điểm hệ số 1 #2	1311	1	\N	2025-05-11 12:12:24.370211
7867	Điểm hệ số 1 #3	1311	1	\N	2025-05-11 12:12:24.370211
7868	Điểm hệ số 2 #1	1311	2	\N	2025-05-11 12:12:24.370211
7869	Điểm hệ số 2 #2	1311	2	\N	2025-05-11 12:12:24.370211
7870	Điểm hệ số 3	1311	3	\N	2025-05-11 12:12:24.370211
7871	Điểm hệ số 1 #1	1312	1	\N	2025-05-11 12:12:24.370211
7872	Điểm hệ số 1 #2	1312	1	\N	2025-05-11 12:12:24.370211
7873	Điểm hệ số 1 #3	1312	1	\N	2025-05-11 12:12:24.370211
7874	Điểm hệ số 2 #1	1312	2	\N	2025-05-11 12:12:24.370211
7875	Điểm hệ số 2 #2	1312	2	\N	2025-05-11 12:12:24.370211
7876	Điểm hệ số 3	1312	3	\N	2025-05-11 12:12:24.370211
7877	Điểm hệ số 1 #1	1313	1	\N	2025-05-11 12:12:24.370211
7878	Điểm hệ số 1 #2	1313	1	\N	2025-05-11 12:12:24.370211
7879	Điểm hệ số 1 #3	1313	1	\N	2025-05-11 12:12:24.370211
7880	Điểm hệ số 2 #1	1313	2	\N	2025-05-11 12:12:24.370211
7881	Điểm hệ số 2 #2	1313	2	\N	2025-05-11 12:12:24.370211
7882	Điểm hệ số 3	1313	3	\N	2025-05-11 12:12:24.370211
7883	Điểm hệ số 1 #1	1314	1	\N	2025-05-11 12:12:24.370211
7884	Điểm hệ số 1 #2	1314	1	\N	2025-05-11 12:12:24.370211
7885	Điểm hệ số 1 #3	1314	1	\N	2025-05-11 12:12:24.370211
7886	Điểm hệ số 2 #1	1314	2	\N	2025-05-11 12:12:24.370211
7887	Điểm hệ số 2 #2	1314	2	\N	2025-05-11 12:12:24.370211
7888	Điểm hệ số 3	1314	3	\N	2025-05-11 12:12:24.370211
7889	Điểm hệ số 1 #1	1315	1	\N	2025-05-11 12:12:24.370211
7890	Điểm hệ số 1 #2	1315	1	\N	2025-05-11 12:12:24.370211
7891	Điểm hệ số 1 #3	1315	1	\N	2025-05-11 12:12:24.370211
7892	Điểm hệ số 2 #1	1315	2	\N	2025-05-11 12:12:24.370211
7893	Điểm hệ số 2 #2	1315	2	\N	2025-05-11 12:12:24.370211
7894	Điểm hệ số 3	1315	3	\N	2025-05-11 12:12:24.370211
7895	Điểm hệ số 1 #1	1316	1	\N	2025-05-11 12:12:24.370211
7896	Điểm hệ số 1 #2	1316	1	\N	2025-05-11 12:12:24.370211
7897	Điểm hệ số 1 #3	1316	1	\N	2025-05-11 12:12:24.370211
7898	Điểm hệ số 2 #1	1316	2	\N	2025-05-11 12:12:24.370211
7899	Điểm hệ số 2 #2	1316	2	\N	2025-05-11 12:12:24.370211
7900	Điểm hệ số 3	1316	3	\N	2025-05-11 12:12:24.370211
7901	Điểm hệ số 1 #1	1317	1	\N	2025-05-11 12:12:24.370211
7902	Điểm hệ số 1 #2	1317	1	\N	2025-05-11 12:12:24.370211
7903	Điểm hệ số 1 #3	1317	1	\N	2025-05-11 12:12:24.370211
7904	Điểm hệ số 2 #1	1317	2	\N	2025-05-11 12:12:24.370211
7905	Điểm hệ số 2 #2	1317	2	\N	2025-05-11 12:12:24.370211
7906	Điểm hệ số 3	1317	3	\N	2025-05-11 12:12:24.370211
7907	Điểm hệ số 1 #1	1318	1	\N	2025-05-11 12:12:24.370211
7908	Điểm hệ số 1 #2	1318	1	\N	2025-05-11 12:12:24.370211
7909	Điểm hệ số 1 #3	1318	1	\N	2025-05-11 12:12:24.370211
7910	Điểm hệ số 2 #1	1318	2	\N	2025-05-11 12:12:24.370211
7911	Điểm hệ số 2 #2	1318	2	\N	2025-05-11 12:12:24.370211
7912	Điểm hệ số 3	1318	3	\N	2025-05-11 12:12:24.370211
7913	Điểm hệ số 1 #1	1319	1	\N	2025-05-11 12:12:24.370211
7914	Điểm hệ số 1 #2	1319	1	\N	2025-05-11 12:12:24.370211
7915	Điểm hệ số 1 #3	1319	1	\N	2025-05-11 12:12:24.370211
7916	Điểm hệ số 2 #1	1319	2	\N	2025-05-11 12:12:24.370211
7917	Điểm hệ số 2 #2	1319	2	\N	2025-05-11 12:12:24.370211
7918	Điểm hệ số 3	1319	3	\N	2025-05-11 12:12:24.370211
7919	Điểm hệ số 1 #1	1320	1	\N	2025-05-11 12:12:24.370211
7920	Điểm hệ số 1 #2	1320	1	\N	2025-05-11 12:12:24.370211
7921	Điểm hệ số 1 #3	1320	1	\N	2025-05-11 12:12:24.370211
7922	Điểm hệ số 2 #1	1320	2	\N	2025-05-11 12:12:24.370211
7923	Điểm hệ số 2 #2	1320	2	\N	2025-05-11 12:12:24.370211
7924	Điểm hệ số 3	1320	3	\N	2025-05-11 12:12:24.370211
7925	Điểm hệ số 1 #1	1321	1	\N	2025-05-11 12:12:24.370211
7926	Điểm hệ số 1 #2	1321	1	\N	2025-05-11 12:12:24.370211
7927	Điểm hệ số 1 #3	1321	1	\N	2025-05-11 12:12:24.370211
7928	Điểm hệ số 2 #1	1321	2	\N	2025-05-11 12:12:24.370211
7929	Điểm hệ số 2 #2	1321	2	\N	2025-05-11 12:12:24.370211
7930	Điểm hệ số 3	1321	3	\N	2025-05-11 12:12:24.370211
7931	Điểm hệ số 1 #1	1322	1	\N	2025-05-11 12:12:24.370211
7932	Điểm hệ số 1 #2	1322	1	\N	2025-05-11 12:12:24.370211
7933	Điểm hệ số 1 #3	1322	1	\N	2025-05-11 12:12:24.370211
7934	Điểm hệ số 2 #1	1322	2	\N	2025-05-11 12:12:24.370211
7935	Điểm hệ số 2 #2	1322	2	\N	2025-05-11 12:12:24.370211
7936	Điểm hệ số 3	1322	3	\N	2025-05-11 12:12:24.370211
7937	Điểm hệ số 1 #1	1323	1	\N	2025-05-11 12:12:24.370211
7938	Điểm hệ số 1 #2	1323	1	\N	2025-05-11 12:12:24.370211
7939	Điểm hệ số 1 #3	1323	1	\N	2025-05-11 12:12:24.370211
7940	Điểm hệ số 2 #1	1323	2	\N	2025-05-11 12:12:24.370211
7941	Điểm hệ số 2 #2	1323	2	\N	2025-05-11 12:12:24.370211
7942	Điểm hệ số 3	1323	3	\N	2025-05-11 12:12:24.370211
7943	Điểm hệ số 1 #1	1324	1	\N	2025-05-11 12:12:24.370211
7944	Điểm hệ số 1 #2	1324	1	\N	2025-05-11 12:12:24.37122
7945	Điểm hệ số 1 #3	1324	1	\N	2025-05-11 12:12:24.37122
7946	Điểm hệ số 2 #1	1324	2	\N	2025-05-11 12:12:24.37122
7947	Điểm hệ số 2 #2	1324	2	\N	2025-05-11 12:12:24.37122
7948	Điểm hệ số 3	1324	3	\N	2025-05-11 12:12:24.37122
7949	Điểm hệ số 1 #1	1325	1	\N	2025-05-11 12:12:24.37122
7950	Điểm hệ số 1 #2	1325	1	\N	2025-05-11 12:12:24.37122
7951	Điểm hệ số 1 #3	1325	1	\N	2025-05-11 12:12:24.37122
7952	Điểm hệ số 2 #1	1325	2	\N	2025-05-11 12:12:24.37122
7953	Điểm hệ số 2 #2	1325	2	\N	2025-05-11 12:12:24.37122
7954	Điểm hệ số 3	1325	3	\N	2025-05-11 12:12:24.37122
7955	Điểm hệ số 1 #1	1326	1	\N	2025-05-11 12:12:24.37122
7956	Điểm hệ số 1 #2	1326	1	\N	2025-05-11 12:12:24.37122
7957	Điểm hệ số 1 #3	1326	1	\N	2025-05-11 12:12:24.37122
7958	Điểm hệ số 2 #1	1326	2	\N	2025-05-11 12:12:24.37122
7959	Điểm hệ số 2 #2	1326	2	\N	2025-05-11 12:12:24.37122
7960	Điểm hệ số 3	1326	3	\N	2025-05-11 12:12:24.37122
7961	Điểm hệ số 1 #1	1327	1	\N	2025-05-11 12:12:24.37122
7962	Điểm hệ số 1 #2	1327	1	\N	2025-05-11 12:12:24.37122
7963	Điểm hệ số 1 #3	1327	1	\N	2025-05-11 12:12:24.37122
7964	Điểm hệ số 2 #1	1327	2	\N	2025-05-11 12:12:24.37122
7965	Điểm hệ số 2 #2	1327	2	\N	2025-05-11 12:12:24.37122
7966	Điểm hệ số 3	1327	3	\N	2025-05-11 12:12:24.37122
7967	Điểm hệ số 1 #1	1328	1	\N	2025-05-11 12:12:24.37122
7968	Điểm hệ số 1 #2	1328	1	\N	2025-05-11 12:12:24.37122
7969	Điểm hệ số 1 #3	1328	1	\N	2025-05-11 12:12:24.37122
7970	Điểm hệ số 2 #1	1328	2	\N	2025-05-11 12:12:24.37122
7971	Điểm hệ số 2 #2	1328	2	\N	2025-05-11 12:12:24.37122
7972	Điểm hệ số 3	1328	3	\N	2025-05-11 12:12:24.37122
7973	Điểm hệ số 1 #1	1329	1	\N	2025-05-11 12:12:24.37122
7974	Điểm hệ số 1 #2	1329	1	\N	2025-05-11 12:12:24.37122
7975	Điểm hệ số 1 #3	1329	1	\N	2025-05-11 12:12:24.37122
7976	Điểm hệ số 2 #1	1329	2	\N	2025-05-11 12:12:24.37122
7977	Điểm hệ số 2 #2	1329	2	\N	2025-05-11 12:12:24.37122
7978	Điểm hệ số 3	1329	3	\N	2025-05-11 12:12:24.37122
7979	Điểm hệ số 1 #1	1330	1	\N	2025-05-11 12:12:24.37122
7980	Điểm hệ số 1 #2	1330	1	\N	2025-05-11 12:12:24.37122
7981	Điểm hệ số 1 #3	1330	1	\N	2025-05-11 12:12:24.37122
7982	Điểm hệ số 2 #1	1330	2	\N	2025-05-11 12:12:24.37122
7983	Điểm hệ số 2 #2	1330	2	\N	2025-05-11 12:12:24.37122
7984	Điểm hệ số 3	1330	3	\N	2025-05-11 12:12:24.37122
7985	Điểm hệ số 1 #1	1331	1	\N	2025-05-11 12:12:24.37122
7986	Điểm hệ số 1 #2	1331	1	\N	2025-05-11 12:12:24.37122
7987	Điểm hệ số 1 #3	1331	1	\N	2025-05-11 12:12:24.37122
7988	Điểm hệ số 2 #1	1331	2	\N	2025-05-11 12:12:24.37122
7989	Điểm hệ số 2 #2	1331	2	\N	2025-05-11 12:12:24.37122
7990	Điểm hệ số 3	1331	3	\N	2025-05-11 12:12:24.37122
7991	Điểm hệ số 1 #1	1332	1	\N	2025-05-11 12:12:24.37122
7992	Điểm hệ số 1 #2	1332	1	\N	2025-05-11 12:12:24.37122
7993	Điểm hệ số 1 #3	1332	1	\N	2025-05-11 12:12:24.37122
7994	Điểm hệ số 2 #1	1332	2	\N	2025-05-11 12:12:24.37122
7995	Điểm hệ số 2 #2	1332	2	\N	2025-05-11 12:12:24.37122
7996	Điểm hệ số 3	1332	3	\N	2025-05-11 12:12:24.37122
7997	Điểm hệ số 1 #1	1333	1	\N	2025-05-11 12:12:24.37122
7998	Điểm hệ số 1 #2	1333	1	\N	2025-05-11 12:12:24.37122
7999	Điểm hệ số 1 #3	1333	1	\N	2025-05-11 12:12:24.37122
8000	Điểm hệ số 2 #1	1333	2	\N	2025-05-11 12:12:24.37122
8001	Điểm hệ số 2 #2	1333	2	\N	2025-05-11 12:12:24.37122
8002	Điểm hệ số 3	1333	3	\N	2025-05-11 12:12:24.37122
8003	Điểm hệ số 1 #1	1334	1	\N	2025-05-11 12:12:24.37122
8004	Điểm hệ số 1 #2	1334	1	\N	2025-05-11 12:12:24.37122
8005	Điểm hệ số 1 #3	1334	1	\N	2025-05-11 12:12:24.37122
8006	Điểm hệ số 2 #1	1334	2	\N	2025-05-11 12:12:24.37122
8007	Điểm hệ số 2 #2	1334	2	\N	2025-05-11 12:12:24.37122
8008	Điểm hệ số 3	1334	3	\N	2025-05-11 12:12:24.37122
8009	Điểm hệ số 1 #1	1335	1	\N	2025-05-11 12:12:24.37122
8010	Điểm hệ số 1 #2	1335	1	\N	2025-05-11 12:12:24.37122
8011	Điểm hệ số 1 #3	1335	1	\N	2025-05-11 12:12:24.37122
8012	Điểm hệ số 2 #1	1335	2	\N	2025-05-11 12:12:24.37122
8013	Điểm hệ số 2 #2	1335	2	\N	2025-05-11 12:12:24.37122
8014	Điểm hệ số 3	1335	3	\N	2025-05-11 12:12:24.37122
8015	Điểm hệ số 1 #1	1336	1	\N	2025-05-11 12:12:24.37122
8016	Điểm hệ số 1 #2	1336	1	\N	2025-05-11 12:12:24.37122
8017	Điểm hệ số 1 #3	1336	1	\N	2025-05-11 12:12:24.37122
8018	Điểm hệ số 2 #1	1336	2	\N	2025-05-11 12:12:24.37122
8019	Điểm hệ số 2 #2	1336	2	\N	2025-05-11 12:12:24.37122
8020	Điểm hệ số 3	1336	3	\N	2025-05-11 12:12:24.37122
8021	Điểm hệ số 1 #1	1337	1	\N	2025-05-11 12:12:24.37122
8022	Điểm hệ số 1 #2	1337	1	\N	2025-05-11 12:12:24.37122
8023	Điểm hệ số 1 #3	1337	1	\N	2025-05-11 12:12:24.37122
8024	Điểm hệ số 2 #1	1337	2	\N	2025-05-11 12:12:24.37122
8025	Điểm hệ số 2 #2	1337	2	\N	2025-05-11 12:12:24.37122
8026	Điểm hệ số 3	1337	3	\N	2025-05-11 12:12:24.37122
8027	Điểm hệ số 1 #1	1338	1	\N	2025-05-11 12:12:24.37122
8028	Điểm hệ số 1 #2	1338	1	\N	2025-05-11 12:12:24.37122
8029	Điểm hệ số 1 #3	1338	1	\N	2025-05-11 12:12:24.37122
8030	Điểm hệ số 2 #1	1338	2	\N	2025-05-11 12:12:24.37122
8031	Điểm hệ số 2 #2	1338	2	\N	2025-05-11 12:12:24.37122
8032	Điểm hệ số 3	1338	3	\N	2025-05-11 12:12:24.37122
8033	Điểm hệ số 1 #1	1339	1	\N	2025-05-11 12:12:24.37122
8034	Điểm hệ số 1 #2	1339	1	\N	2025-05-11 12:12:24.37122
8035	Điểm hệ số 1 #3	1339	1	\N	2025-05-11 12:12:24.37122
8036	Điểm hệ số 2 #1	1339	2	\N	2025-05-11 12:12:24.37122
8037	Điểm hệ số 2 #2	1339	2	\N	2025-05-11 12:12:24.37122
8038	Điểm hệ số 3	1339	3	\N	2025-05-11 12:12:24.37122
8039	Điểm hệ số 1 #1	1340	1	\N	2025-05-11 12:12:24.37122
8040	Điểm hệ số 1 #2	1340	1	\N	2025-05-11 12:12:24.37122
8041	Điểm hệ số 1 #3	1340	1	\N	2025-05-11 12:12:24.37122
8042	Điểm hệ số 2 #1	1340	2	\N	2025-05-11 12:12:24.37122
8043	Điểm hệ số 2 #2	1340	2	\N	2025-05-11 12:12:24.37122
8044	Điểm hệ số 3	1340	3	\N	2025-05-11 12:12:24.37122
8045	Điểm hệ số 1 #1	1341	1	\N	2025-05-11 12:12:24.37122
8046	Điểm hệ số 1 #2	1341	1	\N	2025-05-11 12:12:24.37122
8047	Điểm hệ số 1 #3	1341	1	\N	2025-05-11 12:12:24.37122
8048	Điểm hệ số 2 #1	1341	2	\N	2025-05-11 12:12:24.37122
8049	Điểm hệ số 2 #2	1341	2	\N	2025-05-11 12:12:24.37122
8050	Điểm hệ số 3	1341	3	\N	2025-05-11 12:12:24.37122
8051	Điểm hệ số 1 #1	1342	1	\N	2025-05-11 12:12:24.37122
8052	Điểm hệ số 1 #2	1342	1	\N	2025-05-11 12:12:24.37122
8053	Điểm hệ số 1 #3	1342	1	\N	2025-05-11 12:12:24.37122
8054	Điểm hệ số 2 #1	1342	2	\N	2025-05-11 12:12:24.37122
8055	Điểm hệ số 2 #2	1342	2	\N	2025-05-11 12:12:24.37122
8056	Điểm hệ số 3	1342	3	\N	2025-05-11 12:12:24.37122
8057	Điểm hệ số 1 #1	1343	1	\N	2025-05-11 12:12:24.37122
8058	Điểm hệ số 1 #2	1343	1	\N	2025-05-11 12:12:24.37122
8059	Điểm hệ số 1 #3	1343	1	\N	2025-05-11 12:12:24.37122
8060	Điểm hệ số 2 #1	1343	2	\N	2025-05-11 12:12:24.37122
8061	Điểm hệ số 2 #2	1343	2	\N	2025-05-11 12:12:24.37122
8062	Điểm hệ số 3	1343	3	\N	2025-05-11 12:12:24.37122
8063	Điểm hệ số 1 #1	1344	1	\N	2025-05-11 12:12:24.37122
8064	Điểm hệ số 1 #2	1344	1	\N	2025-05-11 12:12:24.37122
8065	Điểm hệ số 1 #3	1344	1	\N	2025-05-11 12:12:24.37122
8066	Điểm hệ số 2 #1	1344	2	\N	2025-05-11 12:12:24.37122
8067	Điểm hệ số 2 #2	1344	2	\N	2025-05-11 12:12:24.37122
8068	Điểm hệ số 3	1344	3	\N	2025-05-11 12:12:24.37122
8069	Điểm hệ số 1 #1	1345	1	\N	2025-05-11 12:12:24.37122
8070	Điểm hệ số 1 #2	1345	1	\N	2025-05-11 12:12:24.37122
8071	Điểm hệ số 1 #3	1345	1	\N	2025-05-11 12:12:24.37122
8072	Điểm hệ số 2 #1	1345	2	\N	2025-05-11 12:12:24.37122
8073	Điểm hệ số 2 #2	1345	2	\N	2025-05-11 12:12:24.37122
8074	Điểm hệ số 3	1345	3	\N	2025-05-11 12:12:24.37122
8075	Điểm hệ số 1 #1	1346	1	\N	2025-05-11 12:12:24.37122
8076	Điểm hệ số 1 #2	1346	1	\N	2025-05-11 12:12:24.37122
8077	Điểm hệ số 1 #3	1346	1	\N	2025-05-11 12:12:24.37122
8078	Điểm hệ số 2 #1	1346	2	\N	2025-05-11 12:12:24.37122
8079	Điểm hệ số 2 #2	1346	2	\N	2025-05-11 12:12:24.37122
8080	Điểm hệ số 3	1346	3	\N	2025-05-11 12:12:24.37122
8081	Điểm hệ số 1 #1	1347	1	\N	2025-05-11 12:12:24.37122
8082	Điểm hệ số 1 #2	1347	1	\N	2025-05-11 12:12:24.37122
8083	Điểm hệ số 1 #3	1347	1	\N	2025-05-11 12:12:24.37122
8084	Điểm hệ số 2 #1	1347	2	\N	2025-05-11 12:12:24.37122
8085	Điểm hệ số 2 #2	1347	2	\N	2025-05-11 12:12:24.37122
8086	Điểm hệ số 3	1347	3	\N	2025-05-11 12:12:24.37122
8087	Điểm hệ số 1 #1	1348	1	\N	2025-05-11 12:12:24.37122
8088	Điểm hệ số 1 #2	1348	1	\N	2025-05-11 12:12:24.37122
8089	Điểm hệ số 1 #3	1348	1	\N	2025-05-11 12:12:24.37122
8090	Điểm hệ số 2 #1	1348	2	\N	2025-05-11 12:12:24.37122
8091	Điểm hệ số 2 #2	1348	2	\N	2025-05-11 12:12:24.37122
8092	Điểm hệ số 3	1348	3	\N	2025-05-11 12:12:24.37122
8093	Điểm hệ số 1 #1	1349	1	\N	2025-05-11 12:12:24.37122
8094	Điểm hệ số 1 #2	1349	1	\N	2025-05-11 12:12:24.37122
8095	Điểm hệ số 1 #3	1349	1	\N	2025-05-11 12:12:24.37122
8096	Điểm hệ số 2 #1	1349	2	\N	2025-05-11 12:12:24.37122
8097	Điểm hệ số 2 #2	1349	2	\N	2025-05-11 12:12:24.37122
8098	Điểm hệ số 3	1349	3	\N	2025-05-11 12:12:24.37122
8099	Điểm hệ số 1 #1	1350	1	\N	2025-05-11 12:12:24.37122
8100	Điểm hệ số 1 #2	1350	1	\N	2025-05-11 12:12:24.37122
8101	Điểm hệ số 1 #3	1350	1	\N	2025-05-11 12:12:24.37122
8102	Điểm hệ số 2 #1	1350	2	\N	2025-05-11 12:12:24.37122
8103	Điểm hệ số 2 #2	1350	2	\N	2025-05-11 12:12:24.37122
8104	Điểm hệ số 3	1350	3	\N	2025-05-11 12:12:24.37122
8105	Điểm hệ số 1 #1	1351	1	\N	2025-05-11 12:12:24.37122
8106	Điểm hệ số 1 #2	1351	1	\N	2025-05-11 12:12:24.37122
8107	Điểm hệ số 1 #3	1351	1	\N	2025-05-11 12:12:24.37122
8108	Điểm hệ số 2 #1	1351	2	\N	2025-05-11 12:12:24.37122
8109	Điểm hệ số 2 #2	1351	2	\N	2025-05-11 12:12:24.37122
8110	Điểm hệ số 3	1351	3	\N	2025-05-11 12:12:24.37122
8111	Điểm hệ số 1 #1	1352	1	\N	2025-05-11 12:12:25.441062
8112	Điểm hệ số 1 #2	1352	1	\N	2025-05-11 12:12:25.441062
8113	Điểm hệ số 1 #3	1352	1	\N	2025-05-11 12:12:25.441062
8114	Điểm hệ số 2 #1	1352	2	\N	2025-05-11 12:12:25.441062
8115	Điểm hệ số 2 #2	1352	2	\N	2025-05-11 12:12:25.441062
8116	Điểm hệ số 3	1352	3	\N	2025-05-11 12:12:25.441062
8117	Điểm hệ số 1 #1	1353	1	\N	2025-05-11 12:12:25.441062
8118	Điểm hệ số 1 #2	1353	1	\N	2025-05-11 12:12:25.441062
8119	Điểm hệ số 1 #3	1353	1	\N	2025-05-11 12:12:25.441062
8120	Điểm hệ số 2 #1	1353	2	\N	2025-05-11 12:12:25.441062
8121	Điểm hệ số 2 #2	1353	2	\N	2025-05-11 12:12:25.441062
8122	Điểm hệ số 3	1353	3	\N	2025-05-11 12:12:25.441062
8123	Điểm hệ số 1 #1	1354	1	\N	2025-05-11 12:12:25.441062
8124	Điểm hệ số 1 #2	1354	1	\N	2025-05-11 12:12:25.441062
8125	Điểm hệ số 1 #3	1354	1	\N	2025-05-11 12:12:25.441062
8126	Điểm hệ số 2 #1	1354	2	\N	2025-05-11 12:12:25.441062
8127	Điểm hệ số 2 #2	1354	2	\N	2025-05-11 12:12:25.441062
8128	Điểm hệ số 3	1354	3	\N	2025-05-11 12:12:25.441062
8129	Điểm hệ số 1 #1	1355	1	\N	2025-05-11 12:12:25.441062
8130	Điểm hệ số 1 #2	1355	1	\N	2025-05-11 12:12:25.441062
8131	Điểm hệ số 1 #3	1355	1	\N	2025-05-11 12:12:25.441062
8132	Điểm hệ số 2 #1	1355	2	\N	2025-05-11 12:12:25.441062
8133	Điểm hệ số 2 #2	1355	2	\N	2025-05-11 12:12:25.441062
8134	Điểm hệ số 3	1355	3	\N	2025-05-11 12:12:25.441062
8135	Điểm hệ số 1 #1	1356	1	\N	2025-05-11 12:12:25.441062
8136	Điểm hệ số 1 #2	1356	1	\N	2025-05-11 12:12:25.441062
8137	Điểm hệ số 1 #3	1356	1	\N	2025-05-11 12:12:25.441062
8138	Điểm hệ số 2 #1	1356	2	\N	2025-05-11 12:12:25.441062
8139	Điểm hệ số 2 #2	1356	2	\N	2025-05-11 12:12:25.441062
8140	Điểm hệ số 3	1356	3	\N	2025-05-11 12:12:25.441062
8141	Điểm hệ số 1 #1	1357	1	\N	2025-05-11 12:12:25.441062
8142	Điểm hệ số 1 #2	1357	1	\N	2025-05-11 12:12:25.441062
8143	Điểm hệ số 1 #3	1357	1	\N	2025-05-11 12:12:25.441062
8144	Điểm hệ số 2 #1	1357	2	\N	2025-05-11 12:12:25.441062
8145	Điểm hệ số 2 #2	1357	2	\N	2025-05-11 12:12:25.441062
8146	Điểm hệ số 3	1357	3	\N	2025-05-11 12:12:25.441062
8147	Điểm hệ số 1 #1	1358	1	\N	2025-05-11 12:12:25.441062
8148	Điểm hệ số 1 #2	1358	1	\N	2025-05-11 12:12:25.441062
8149	Điểm hệ số 1 #3	1358	1	\N	2025-05-11 12:12:25.441062
8150	Điểm hệ số 2 #1	1358	2	\N	2025-05-11 12:12:25.441062
8151	Điểm hệ số 2 #2	1358	2	\N	2025-05-11 12:12:25.441062
8152	Điểm hệ số 3	1358	3	\N	2025-05-11 12:12:25.441062
8153	Điểm hệ số 1 #1	1359	1	\N	2025-05-11 12:12:25.441062
8154	Điểm hệ số 1 #2	1359	1	\N	2025-05-11 12:12:25.441062
8155	Điểm hệ số 1 #3	1359	1	\N	2025-05-11 12:12:25.441062
8156	Điểm hệ số 2 #1	1359	2	\N	2025-05-11 12:12:25.441062
8157	Điểm hệ số 2 #2	1359	2	\N	2025-05-11 12:12:25.441062
8158	Điểm hệ số 3	1359	3	\N	2025-05-11 12:12:25.441062
8159	Điểm hệ số 1 #1	1360	1	\N	2025-05-11 12:12:25.441062
8160	Điểm hệ số 1 #2	1360	1	\N	2025-05-11 12:12:25.441062
8161	Điểm hệ số 1 #3	1360	1	\N	2025-05-11 12:12:25.441062
8162	Điểm hệ số 2 #1	1360	2	\N	2025-05-11 12:12:25.441062
8163	Điểm hệ số 2 #2	1360	2	\N	2025-05-11 12:12:25.441062
8164	Điểm hệ số 3	1360	3	\N	2025-05-11 12:12:25.441062
8165	Điểm hệ số 1 #1	1361	1	\N	2025-05-11 12:12:25.441062
8166	Điểm hệ số 1 #2	1361	1	\N	2025-05-11 12:12:25.441062
8167	Điểm hệ số 1 #3	1361	1	\N	2025-05-11 12:12:25.441062
8168	Điểm hệ số 2 #1	1361	2	\N	2025-05-11 12:12:25.441062
8169	Điểm hệ số 2 #2	1361	2	\N	2025-05-11 12:12:25.441062
8170	Điểm hệ số 3	1361	3	\N	2025-05-11 12:12:25.441062
8171	Điểm hệ số 1 #1	1362	1	\N	2025-05-11 12:12:25.441062
8172	Điểm hệ số 1 #2	1362	1	\N	2025-05-11 12:12:25.441062
8173	Điểm hệ số 1 #3	1362	1	\N	2025-05-11 12:12:25.441062
8174	Điểm hệ số 2 #1	1362	2	\N	2025-05-11 12:12:25.441062
8175	Điểm hệ số 2 #2	1362	2	\N	2025-05-11 12:12:25.441062
8176	Điểm hệ số 3	1362	3	\N	2025-05-11 12:12:25.441062
8177	Điểm hệ số 1 #1	1363	1	\N	2025-05-11 12:12:25.441062
8178	Điểm hệ số 1 #2	1363	1	\N	2025-05-11 12:12:25.441062
8179	Điểm hệ số 1 #3	1363	1	\N	2025-05-11 12:12:25.441062
8180	Điểm hệ số 2 #1	1363	2	\N	2025-05-11 12:12:25.441062
8181	Điểm hệ số 2 #2	1363	2	\N	2025-05-11 12:12:25.441062
8182	Điểm hệ số 3	1363	3	\N	2025-05-11 12:12:25.441062
8183	Điểm hệ số 1 #1	1364	1	\N	2025-05-11 12:12:25.442078
8184	Điểm hệ số 1 #2	1364	1	\N	2025-05-11 12:12:25.442078
8185	Điểm hệ số 1 #3	1364	1	\N	2025-05-11 12:12:25.442078
8186	Điểm hệ số 2 #1	1364	2	\N	2025-05-11 12:12:25.442078
8187	Điểm hệ số 2 #2	1364	2	\N	2025-05-11 12:12:25.442078
8188	Điểm hệ số 3	1364	3	\N	2025-05-11 12:12:25.442078
8189	Điểm hệ số 1 #1	1365	1	\N	2025-05-11 12:12:25.442078
8190	Điểm hệ số 1 #2	1365	1	\N	2025-05-11 12:12:25.442078
8191	Điểm hệ số 1 #3	1365	1	\N	2025-05-11 12:12:25.442078
8192	Điểm hệ số 2 #1	1365	2	\N	2025-05-11 12:12:25.442078
8193	Điểm hệ số 2 #2	1365	2	\N	2025-05-11 12:12:25.442078
8194	Điểm hệ số 3	1365	3	\N	2025-05-11 12:12:25.442078
8195	Điểm hệ số 1 #1	1366	1	\N	2025-05-11 12:12:25.442078
8196	Điểm hệ số 1 #2	1366	1	\N	2025-05-11 12:12:25.442078
8197	Điểm hệ số 1 #3	1366	1	\N	2025-05-11 12:12:25.442078
8198	Điểm hệ số 2 #1	1366	2	\N	2025-05-11 12:12:25.442078
8199	Điểm hệ số 2 #2	1366	2	\N	2025-05-11 12:12:25.442078
8200	Điểm hệ số 3	1366	3	\N	2025-05-11 12:12:25.442078
8201	Điểm hệ số 1 #1	1367	1	\N	2025-05-11 12:12:25.442078
8202	Điểm hệ số 1 #2	1367	1	\N	2025-05-11 12:12:25.442078
8203	Điểm hệ số 1 #3	1367	1	\N	2025-05-11 12:12:25.442078
8204	Điểm hệ số 2 #1	1367	2	\N	2025-05-11 12:12:25.442078
8205	Điểm hệ số 2 #2	1367	2	\N	2025-05-11 12:12:25.442078
8206	Điểm hệ số 3	1367	3	\N	2025-05-11 12:12:25.442078
8207	Điểm hệ số 1 #1	1368	1	\N	2025-05-11 12:12:25.442078
8208	Điểm hệ số 1 #2	1368	1	\N	2025-05-11 12:12:25.442078
8209	Điểm hệ số 1 #3	1368	1	\N	2025-05-11 12:12:25.442078
8210	Điểm hệ số 2 #1	1368	2	\N	2025-05-11 12:12:25.442078
8211	Điểm hệ số 2 #2	1368	2	\N	2025-05-11 12:12:25.442078
8212	Điểm hệ số 3	1368	3	\N	2025-05-11 12:12:25.442078
8213	Điểm hệ số 1 #1	1369	1	\N	2025-05-11 12:12:25.442078
8214	Điểm hệ số 1 #2	1369	1	\N	2025-05-11 12:12:25.442078
8215	Điểm hệ số 1 #3	1369	1	\N	2025-05-11 12:12:25.442078
8216	Điểm hệ số 2 #1	1369	2	\N	2025-05-11 12:12:25.442078
8217	Điểm hệ số 2 #2	1369	2	\N	2025-05-11 12:12:25.442078
8218	Điểm hệ số 3	1369	3	\N	2025-05-11 12:12:25.442078
8219	Điểm hệ số 1 #1	1370	1	\N	2025-05-11 12:12:25.442078
8220	Điểm hệ số 1 #2	1370	1	\N	2025-05-11 12:12:25.442078
8221	Điểm hệ số 1 #3	1370	1	\N	2025-05-11 12:12:25.442078
8222	Điểm hệ số 2 #1	1370	2	\N	2025-05-11 12:12:25.442078
8223	Điểm hệ số 2 #2	1370	2	\N	2025-05-11 12:12:25.442078
8224	Điểm hệ số 3	1370	3	\N	2025-05-11 12:12:25.442078
8225	Điểm hệ số 1 #1	1371	1	\N	2025-05-11 12:12:25.442078
8226	Điểm hệ số 1 #2	1371	1	\N	2025-05-11 12:12:25.442078
8227	Điểm hệ số 1 #3	1371	1	\N	2025-05-11 12:12:25.442078
8228	Điểm hệ số 2 #1	1371	2	\N	2025-05-11 12:12:25.442078
8229	Điểm hệ số 2 #2	1371	2	\N	2025-05-11 12:12:25.442078
8230	Điểm hệ số 3	1371	3	\N	2025-05-11 12:12:25.442078
8231	Điểm hệ số 1 #1	1372	1	\N	2025-05-11 12:12:25.442078
8232	Điểm hệ số 1 #2	1372	1	\N	2025-05-11 12:12:25.442078
8233	Điểm hệ số 1 #3	1372	1	\N	2025-05-11 12:12:25.442078
8234	Điểm hệ số 2 #1	1372	2	\N	2025-05-11 12:12:25.442078
8235	Điểm hệ số 2 #2	1372	2	\N	2025-05-11 12:12:25.442078
8236	Điểm hệ số 3	1372	3	\N	2025-05-11 12:12:25.442078
8237	Điểm hệ số 1 #1	1373	1	\N	2025-05-11 12:12:25.442078
8238	Điểm hệ số 1 #2	1373	1	\N	2025-05-11 12:12:25.442078
8239	Điểm hệ số 1 #3	1373	1	\N	2025-05-11 12:12:25.442078
8240	Điểm hệ số 2 #1	1373	2	\N	2025-05-11 12:12:25.442078
8241	Điểm hệ số 2 #2	1373	2	\N	2025-05-11 12:12:25.442078
8242	Điểm hệ số 3	1373	3	\N	2025-05-11 12:12:25.442078
8243	Điểm hệ số 1 #1	1374	1	\N	2025-05-11 12:12:25.442078
8244	Điểm hệ số 1 #2	1374	1	\N	2025-05-11 12:12:25.442078
8245	Điểm hệ số 1 #3	1374	1	\N	2025-05-11 12:12:25.442078
8246	Điểm hệ số 2 #1	1374	2	\N	2025-05-11 12:12:25.442078
8247	Điểm hệ số 2 #2	1374	2	\N	2025-05-11 12:12:25.442078
8248	Điểm hệ số 3	1374	3	\N	2025-05-11 12:12:25.442078
8249	Điểm hệ số 1 #1	1375	1	\N	2025-05-11 12:12:25.442078
8250	Điểm hệ số 1 #2	1375	1	\N	2025-05-11 12:12:25.442078
8251	Điểm hệ số 1 #3	1375	1	\N	2025-05-11 12:12:25.442078
8252	Điểm hệ số 2 #1	1375	2	\N	2025-05-11 12:12:25.442078
8253	Điểm hệ số 2 #2	1375	2	\N	2025-05-11 12:12:25.442078
8254	Điểm hệ số 3	1375	3	\N	2025-05-11 12:12:25.442078
8255	Điểm hệ số 1 #1	1376	1	\N	2025-05-11 12:12:25.442078
8256	Điểm hệ số 1 #2	1376	1	\N	2025-05-11 12:12:25.442078
8257	Điểm hệ số 1 #3	1376	1	\N	2025-05-11 12:12:25.442078
8258	Điểm hệ số 2 #1	1376	2	\N	2025-05-11 12:12:25.442078
8259	Điểm hệ số 2 #2	1376	2	\N	2025-05-11 12:12:25.442078
8260	Điểm hệ số 3	1376	3	\N	2025-05-11 12:12:25.442078
8261	Điểm hệ số 1 #1	1377	1	\N	2025-05-11 12:12:25.442078
8262	Điểm hệ số 1 #2	1377	1	\N	2025-05-11 12:12:25.442078
8263	Điểm hệ số 1 #3	1377	1	\N	2025-05-11 12:12:25.442078
8264	Điểm hệ số 2 #1	1377	2	\N	2025-05-11 12:12:25.442078
8265	Điểm hệ số 2 #2	1377	2	\N	2025-05-11 12:12:25.442078
8266	Điểm hệ số 3	1377	3	\N	2025-05-11 12:12:25.442078
8267	Điểm hệ số 1 #1	1378	1	\N	2025-05-11 12:12:25.442078
8268	Điểm hệ số 1 #2	1378	1	\N	2025-05-11 12:12:25.442078
8269	Điểm hệ số 1 #3	1378	1	\N	2025-05-11 12:12:25.442078
8270	Điểm hệ số 2 #1	1378	2	\N	2025-05-11 12:12:25.442078
8271	Điểm hệ số 2 #2	1378	2	\N	2025-05-11 12:12:25.442078
8272	Điểm hệ số 3	1378	3	\N	2025-05-11 12:12:25.442078
8273	Điểm hệ số 1 #1	1379	1	\N	2025-05-11 12:12:25.442078
8274	Điểm hệ số 1 #2	1379	1	\N	2025-05-11 12:12:25.442078
8275	Điểm hệ số 1 #3	1379	1	\N	2025-05-11 12:12:25.442078
8276	Điểm hệ số 2 #1	1379	2	\N	2025-05-11 12:12:25.442078
8277	Điểm hệ số 2 #2	1379	2	\N	2025-05-11 12:12:25.442078
8278	Điểm hệ số 3	1379	3	\N	2025-05-11 12:12:25.442078
8279	Điểm hệ số 1 #1	1380	1	\N	2025-05-11 12:12:25.442078
8280	Điểm hệ số 1 #2	1380	1	\N	2025-05-11 12:12:25.442078
8281	Điểm hệ số 1 #3	1380	1	\N	2025-05-11 12:12:25.442078
8282	Điểm hệ số 2 #1	1380	2	\N	2025-05-11 12:12:25.442078
8283	Điểm hệ số 2 #2	1380	2	\N	2025-05-11 12:12:25.442078
8284	Điểm hệ số 3	1380	3	\N	2025-05-11 12:12:25.442078
8285	Điểm hệ số 1 #1	1381	1	\N	2025-05-11 12:12:25.442078
8286	Điểm hệ số 1 #2	1381	1	\N	2025-05-11 12:12:25.442078
8287	Điểm hệ số 1 #3	1381	1	\N	2025-05-11 12:12:25.442078
8288	Điểm hệ số 2 #1	1381	2	\N	2025-05-11 12:12:25.442078
8289	Điểm hệ số 2 #2	1381	2	\N	2025-05-11 12:12:25.442078
8290	Điểm hệ số 3	1381	3	\N	2025-05-11 12:12:25.442078
8291	Điểm hệ số 1 #1	1382	1	\N	2025-05-11 12:12:25.442078
8292	Điểm hệ số 1 #2	1382	1	\N	2025-05-11 12:12:25.442078
8293	Điểm hệ số 1 #3	1382	1	\N	2025-05-11 12:12:25.442078
8294	Điểm hệ số 2 #1	1382	2	\N	2025-05-11 12:12:25.442078
8295	Điểm hệ số 2 #2	1382	2	\N	2025-05-11 12:12:25.442078
8296	Điểm hệ số 3	1382	3	\N	2025-05-11 12:12:25.442078
8297	Điểm hệ số 1 #1	1383	1	\N	2025-05-11 12:12:25.442078
8298	Điểm hệ số 1 #2	1383	1	\N	2025-05-11 12:12:25.442078
8299	Điểm hệ số 1 #3	1383	1	\N	2025-05-11 12:12:25.442078
8300	Điểm hệ số 2 #1	1383	2	\N	2025-05-11 12:12:25.442078
8301	Điểm hệ số 2 #2	1383	2	\N	2025-05-11 12:12:25.442078
8302	Điểm hệ số 3	1383	3	\N	2025-05-11 12:12:25.442078
8303	Điểm hệ số 1 #1	1384	1	\N	2025-05-11 12:12:25.442078
8304	Điểm hệ số 1 #2	1384	1	\N	2025-05-11 12:12:25.442078
8305	Điểm hệ số 1 #3	1384	1	\N	2025-05-11 12:12:25.442078
8306	Điểm hệ số 2 #1	1384	2	\N	2025-05-11 12:12:25.442078
8307	Điểm hệ số 2 #2	1384	2	\N	2025-05-11 12:12:25.442078
8308	Điểm hệ số 3	1384	3	\N	2025-05-11 12:12:25.442078
8309	Điểm hệ số 1 #1	1385	1	\N	2025-05-11 12:12:25.442078
8310	Điểm hệ số 1 #2	1385	1	\N	2025-05-11 12:12:25.442078
8311	Điểm hệ số 1 #3	1385	1	\N	2025-05-11 12:12:25.442078
8312	Điểm hệ số 2 #1	1385	2	\N	2025-05-11 12:12:25.442078
8313	Điểm hệ số 2 #2	1385	2	\N	2025-05-11 12:12:25.442078
8314	Điểm hệ số 3	1385	3	\N	2025-05-11 12:12:25.442078
8315	Điểm hệ số 1 #1	1386	1	\N	2025-05-11 12:12:25.442078
8316	Điểm hệ số 1 #2	1386	1	\N	2025-05-11 12:12:25.442078
8317	Điểm hệ số 1 #3	1386	1	\N	2025-05-11 12:12:25.442078
8318	Điểm hệ số 2 #1	1386	2	\N	2025-05-11 12:12:25.442078
8319	Điểm hệ số 2 #2	1386	2	\N	2025-05-11 12:12:25.442078
8320	Điểm hệ số 3	1386	3	\N	2025-05-11 12:12:25.442078
8321	Điểm hệ số 1 #1	1387	1	\N	2025-05-11 12:12:25.442078
8322	Điểm hệ số 1 #2	1387	1	\N	2025-05-11 12:12:25.442078
8323	Điểm hệ số 1 #3	1387	1	\N	2025-05-11 12:12:25.442078
8324	Điểm hệ số 2 #1	1387	2	\N	2025-05-11 12:12:25.442078
8325	Điểm hệ số 2 #2	1387	2	\N	2025-05-11 12:12:25.442078
8326	Điểm hệ số 3	1387	3	\N	2025-05-11 12:12:25.442078
8327	Điểm hệ số 1 #1	1388	1	\N	2025-05-11 12:12:25.442078
8328	Điểm hệ số 1 #2	1388	1	\N	2025-05-11 12:12:25.442078
8329	Điểm hệ số 1 #3	1388	1	\N	2025-05-11 12:12:25.442078
8330	Điểm hệ số 2 #1	1388	2	\N	2025-05-11 12:12:25.442078
8331	Điểm hệ số 2 #2	1388	2	\N	2025-05-11 12:12:25.442078
8332	Điểm hệ số 3	1388	3	\N	2025-05-11 12:12:25.442078
8333	Điểm hệ số 1 #1	1389	1	\N	2025-05-11 12:12:25.442078
8334	Điểm hệ số 1 #2	1389	1	\N	2025-05-11 12:12:25.442078
8335	Điểm hệ số 1 #3	1389	1	\N	2025-05-11 12:12:25.442078
8336	Điểm hệ số 2 #1	1389	2	\N	2025-05-11 12:12:25.442078
8337	Điểm hệ số 2 #2	1389	2	\N	2025-05-11 12:12:25.442078
8338	Điểm hệ số 3	1389	3	\N	2025-05-11 12:12:25.442078
8339	Điểm hệ số 1 #1	1390	1	\N	2025-05-11 12:12:25.442078
8340	Điểm hệ số 1 #2	1390	1	\N	2025-05-11 12:12:25.442078
8341	Điểm hệ số 1 #3	1390	1	\N	2025-05-11 12:12:25.442078
8342	Điểm hệ số 2 #1	1390	2	\N	2025-05-11 12:12:25.442078
8343	Điểm hệ số 2 #2	1390	2	\N	2025-05-11 12:12:25.442078
8344	Điểm hệ số 3	1390	3	\N	2025-05-11 12:12:25.442078
8345	Điểm hệ số 1 #1	1391	1	\N	2025-05-11 12:12:25.442078
8346	Điểm hệ số 1 #2	1391	1	\N	2025-05-11 12:12:25.442078
8347	Điểm hệ số 1 #3	1391	1	\N	2025-05-11 12:12:25.442078
8348	Điểm hệ số 2 #1	1391	2	\N	2025-05-11 12:12:25.442078
8349	Điểm hệ số 2 #2	1391	2	\N	2025-05-11 12:12:25.442078
8350	Điểm hệ số 3	1391	3	\N	2025-05-11 12:12:25.442078
8351	Điểm hệ số 1 #1	1392	1	\N	2025-05-11 12:12:25.442078
8352	Điểm hệ số 1 #2	1392	1	\N	2025-05-11 12:12:25.442078
8353	Điểm hệ số 1 #3	1392	1	\N	2025-05-11 12:12:25.442078
8354	Điểm hệ số 2 #1	1392	2	\N	2025-05-11 12:12:25.442078
8355	Điểm hệ số 2 #2	1392	2	\N	2025-05-11 12:12:25.442078
8356	Điểm hệ số 3	1392	3	\N	2025-05-11 12:12:25.442078
8357	Điểm hệ số 1 #1	1393	1	\N	2025-05-11 12:12:25.442078
8358	Điểm hệ số 1 #2	1393	1	\N	2025-05-11 12:12:25.442078
8359	Điểm hệ số 1 #3	1393	1	\N	2025-05-11 12:12:25.442078
8360	Điểm hệ số 2 #1	1393	2	\N	2025-05-11 12:12:25.442078
8361	Điểm hệ số 2 #2	1393	2	\N	2025-05-11 12:12:25.442078
8362	Điểm hệ số 3	1393	3	\N	2025-05-11 12:12:25.442078
8363	Điểm hệ số 1 #1	1394	1	\N	2025-05-11 12:12:25.442078
8364	Điểm hệ số 1 #2	1394	1	\N	2025-05-11 12:12:25.442078
8365	Điểm hệ số 1 #3	1394	1	\N	2025-05-11 12:12:25.442078
8366	Điểm hệ số 2 #1	1394	2	\N	2025-05-11 12:12:25.442078
8367	Điểm hệ số 2 #2	1394	2	\N	2025-05-11 12:12:25.442078
8368	Điểm hệ số 3	1394	3	\N	2025-05-11 12:12:25.442078
8369	Điểm hệ số 1 #1	1395	1	\N	2025-05-11 12:12:25.442078
8370	Điểm hệ số 1 #2	1395	1	\N	2025-05-11 12:12:25.442078
8371	Điểm hệ số 1 #3	1395	1	\N	2025-05-11 12:12:25.442078
8372	Điểm hệ số 2 #1	1395	2	\N	2025-05-11 12:12:25.442078
8373	Điểm hệ số 2 #2	1395	2	\N	2025-05-11 12:12:25.442078
8374	Điểm hệ số 3	1395	3	\N	2025-05-11 12:12:25.442078
8375	Điểm hệ số 1 #1	1396	1	\N	2025-05-11 12:12:25.442078
8376	Điểm hệ số 1 #2	1396	1	\N	2025-05-11 12:12:25.442078
8377	Điểm hệ số 1 #3	1396	1	\N	2025-05-11 12:12:25.442078
8378	Điểm hệ số 2 #1	1396	2	\N	2025-05-11 12:12:25.442078
8379	Điểm hệ số 2 #2	1396	2	\N	2025-05-11 12:12:25.442078
8380	Điểm hệ số 3	1396	3	\N	2025-05-11 12:12:25.442078
8381	Điểm hệ số 1 #1	1397	1	\N	2025-05-11 12:12:25.442078
8382	Điểm hệ số 1 #2	1397	1	\N	2025-05-11 12:12:25.442078
8383	Điểm hệ số 1 #3	1397	1	\N	2025-05-11 12:12:25.442078
8384	Điểm hệ số 2 #1	1397	2	\N	2025-05-11 12:12:25.442078
8385	Điểm hệ số 2 #2	1397	2	\N	2025-05-11 12:12:25.442078
8386	Điểm hệ số 3	1397	3	\N	2025-05-11 12:12:25.442078
8387	Điểm hệ số 1 #1	1398	1	\N	2025-05-11 12:12:25.442078
8388	Điểm hệ số 1 #2	1398	1	\N	2025-05-11 12:12:25.442078
8389	Điểm hệ số 1 #3	1398	1	\N	2025-05-11 12:12:25.442078
8390	Điểm hệ số 2 #1	1398	2	\N	2025-05-11 12:12:25.442078
8391	Điểm hệ số 2 #2	1398	2	\N	2025-05-11 12:12:25.442078
8392	Điểm hệ số 3	1398	3	\N	2025-05-11 12:12:25.442078
8393	Điểm hệ số 1 #1	1399	1	\N	2025-05-11 12:12:25.442078
8394	Điểm hệ số 1 #2	1399	1	\N	2025-05-11 12:12:25.442078
8395	Điểm hệ số 1 #3	1399	1	\N	2025-05-11 12:12:25.442078
8396	Điểm hệ số 2 #1	1399	2	\N	2025-05-11 12:12:25.442078
8397	Điểm hệ số 2 #2	1399	2	\N	2025-05-11 12:12:25.442078
8398	Điểm hệ số 3	1399	3	\N	2025-05-11 12:12:25.442078
8399	Điểm hệ số 1 #1	1400	1	\N	2025-05-11 12:12:25.442078
8400	Điểm hệ số 1 #2	1400	1	\N	2025-05-11 12:12:25.442078
8401	Điểm hệ số 1 #3	1400	1	\N	2025-05-11 12:12:25.442078
8402	Điểm hệ số 2 #1	1400	2	\N	2025-05-11 12:12:25.442078
8403	Điểm hệ số 2 #2	1400	2	\N	2025-05-11 12:12:25.442078
8404	Điểm hệ số 3	1400	3	\N	2025-05-11 12:12:25.442078
8405	Điểm hệ số 1 #1	1401	1	\N	2025-05-11 12:12:25.442078
8406	Điểm hệ số 1 #2	1401	1	\N	2025-05-11 12:12:25.442078
8407	Điểm hệ số 1 #3	1401	1	\N	2025-05-11 12:12:25.442078
8408	Điểm hệ số 2 #1	1401	2	\N	2025-05-11 12:12:25.442078
8409	Điểm hệ số 2 #2	1401	2	\N	2025-05-11 12:12:25.442078
8410	Điểm hệ số 3	1401	3	\N	2025-05-11 12:12:25.442078
8411	Điểm hệ số 1 #1	1402	1	\N	2025-05-11 12:12:25.443074
8412	Điểm hệ số 1 #2	1402	1	\N	2025-05-11 12:12:25.443074
8413	Điểm hệ số 1 #3	1402	1	\N	2025-05-11 12:12:25.443074
8414	Điểm hệ số 2 #1	1402	2	\N	2025-05-11 12:12:25.443074
8415	Điểm hệ số 2 #2	1402	2	\N	2025-05-11 12:12:25.443074
8416	Điểm hệ số 3	1402	3	\N	2025-05-11 12:12:25.443074
8417	Điểm hệ số 1 #1	1403	1	\N	2025-05-11 12:12:25.443074
8418	Điểm hệ số 1 #2	1403	1	\N	2025-05-11 12:12:25.443074
8419	Điểm hệ số 1 #3	1403	1	\N	2025-05-11 12:12:25.443074
8420	Điểm hệ số 2 #1	1403	2	\N	2025-05-11 12:12:25.443074
8421	Điểm hệ số 2 #2	1403	2	\N	2025-05-11 12:12:25.443074
8422	Điểm hệ số 3	1403	3	\N	2025-05-11 12:12:25.443074
8423	Điểm hệ số 1 #1	1404	1	\N	2025-05-11 12:12:25.443074
8424	Điểm hệ số 1 #2	1404	1	\N	2025-05-11 12:12:25.443074
8425	Điểm hệ số 1 #3	1404	1	\N	2025-05-11 12:12:25.443074
8426	Điểm hệ số 2 #1	1404	2	\N	2025-05-11 12:12:25.443074
8427	Điểm hệ số 2 #2	1404	2	\N	2025-05-11 12:12:25.443074
8428	Điểm hệ số 3	1404	3	\N	2025-05-11 12:12:25.443074
8429	Điểm hệ số 1 #1	1405	1	\N	2025-05-11 12:12:25.443074
8430	Điểm hệ số 1 #2	1405	1	\N	2025-05-11 12:12:25.443074
8431	Điểm hệ số 1 #3	1405	1	\N	2025-05-11 12:12:25.443074
8432	Điểm hệ số 2 #1	1405	2	\N	2025-05-11 12:12:25.443074
8433	Điểm hệ số 2 #2	1405	2	\N	2025-05-11 12:12:25.443074
8434	Điểm hệ số 3	1405	3	\N	2025-05-11 12:12:25.443074
8435	Điểm hệ số 1 #1	1406	1	\N	2025-05-11 12:12:25.443074
8436	Điểm hệ số 1 #2	1406	1	\N	2025-05-11 12:12:25.443074
8437	Điểm hệ số 1 #3	1406	1	\N	2025-05-11 12:12:25.443074
8438	Điểm hệ số 2 #1	1406	2	\N	2025-05-11 12:12:25.443074
8439	Điểm hệ số 2 #2	1406	2	\N	2025-05-11 12:12:25.443074
8440	Điểm hệ số 3	1406	3	\N	2025-05-11 12:12:25.443074
8441	Điểm hệ số 1 #1	1407	1	\N	2025-05-11 12:12:25.443074
8442	Điểm hệ số 1 #2	1407	1	\N	2025-05-11 12:12:25.443074
8443	Điểm hệ số 1 #3	1407	1	\N	2025-05-11 12:12:25.443074
8444	Điểm hệ số 2 #1	1407	2	\N	2025-05-11 12:12:25.443074
8445	Điểm hệ số 2 #2	1407	2	\N	2025-05-11 12:12:25.443074
8446	Điểm hệ số 3	1407	3	\N	2025-05-11 12:12:25.443074
8447	Điểm hệ số 1 #1	1408	1	\N	2025-05-11 12:12:25.443074
8448	Điểm hệ số 1 #2	1408	1	\N	2025-05-11 12:12:25.443074
8449	Điểm hệ số 1 #3	1408	1	\N	2025-05-11 12:12:25.443074
8450	Điểm hệ số 2 #1	1408	2	\N	2025-05-11 12:12:25.443074
8451	Điểm hệ số 2 #2	1408	2	\N	2025-05-11 12:12:25.443074
8452	Điểm hệ số 3	1408	3	\N	2025-05-11 12:12:25.443074
8453	Điểm hệ số 1 #1	1409	1	\N	2025-05-11 12:12:25.443074
8454	Điểm hệ số 1 #2	1409	1	\N	2025-05-11 12:12:25.443074
8455	Điểm hệ số 1 #3	1409	1	\N	2025-05-11 12:12:25.443074
8456	Điểm hệ số 2 #1	1409	2	\N	2025-05-11 12:12:25.443074
8457	Điểm hệ số 2 #2	1409	2	\N	2025-05-11 12:12:25.443074
8458	Điểm hệ số 3	1409	3	\N	2025-05-11 12:12:25.443074
8459	Điểm hệ số 1 #1	1410	1	\N	2025-05-11 12:12:25.443074
8460	Điểm hệ số 1 #2	1410	1	\N	2025-05-11 12:12:25.443074
8461	Điểm hệ số 1 #3	1410	1	\N	2025-05-11 12:12:25.443074
8462	Điểm hệ số 2 #1	1410	2	\N	2025-05-11 12:12:25.443074
8463	Điểm hệ số 2 #2	1410	2	\N	2025-05-11 12:12:25.443074
8464	Điểm hệ số 3	1410	3	\N	2025-05-11 12:12:25.443074
8465	Điểm hệ số 1 #1	1411	1	\N	2025-05-11 12:12:25.443074
8466	Điểm hệ số 1 #2	1411	1	\N	2025-05-11 12:12:25.443074
8467	Điểm hệ số 1 #3	1411	1	\N	2025-05-11 12:12:25.443074
8468	Điểm hệ số 2 #1	1411	2	\N	2025-05-11 12:12:25.443074
8469	Điểm hệ số 2 #2	1411	2	\N	2025-05-11 12:12:25.443074
8470	Điểm hệ số 3	1411	3	\N	2025-05-11 12:12:25.443074
8471	Điểm hệ số 1 #1	1412	1	\N	2025-05-11 12:12:25.443074
8472	Điểm hệ số 1 #2	1412	1	\N	2025-05-11 12:12:25.443074
8473	Điểm hệ số 1 #3	1412	1	\N	2025-05-11 12:12:25.443074
8474	Điểm hệ số 2 #1	1412	2	\N	2025-05-11 12:12:25.443074
8475	Điểm hệ số 2 #2	1412	2	\N	2025-05-11 12:12:25.443074
8476	Điểm hệ số 3	1412	3	\N	2025-05-11 12:12:25.443074
8477	Điểm hệ số 1 #1	1413	1	\N	2025-05-11 12:12:25.443074
8478	Điểm hệ số 1 #2	1413	1	\N	2025-05-11 12:12:25.443074
8479	Điểm hệ số 1 #3	1413	1	\N	2025-05-11 12:12:25.443074
8480	Điểm hệ số 2 #1	1413	2	\N	2025-05-11 12:12:25.443074
8481	Điểm hệ số 2 #2	1413	2	\N	2025-05-11 12:12:25.443074
8482	Điểm hệ số 3	1413	3	\N	2025-05-11 12:12:25.443074
8483	Điểm hệ số 1 #1	1414	1	\N	2025-05-11 12:12:25.443074
8484	Điểm hệ số 1 #2	1414	1	\N	2025-05-11 12:12:25.443074
8485	Điểm hệ số 1 #3	1414	1	\N	2025-05-11 12:12:25.443074
8486	Điểm hệ số 2 #1	1414	2	\N	2025-05-11 12:12:25.443074
8487	Điểm hệ số 2 #2	1414	2	\N	2025-05-11 12:12:25.443074
8488	Điểm hệ số 3	1414	3	\N	2025-05-11 12:12:25.443074
8489	Điểm hệ số 1 #1	1415	1	\N	2025-05-11 12:12:25.443074
8490	Điểm hệ số 1 #2	1415	1	\N	2025-05-11 12:12:25.443074
8491	Điểm hệ số 1 #3	1415	1	\N	2025-05-11 12:12:25.443074
8492	Điểm hệ số 2 #1	1415	2	\N	2025-05-11 12:12:25.443074
8493	Điểm hệ số 2 #2	1415	2	\N	2025-05-11 12:12:25.443074
8494	Điểm hệ số 3	1415	3	\N	2025-05-11 12:12:25.443074
8495	Điểm hệ số 1 #1	1416	1	\N	2025-05-11 12:12:25.443074
8496	Điểm hệ số 1 #2	1416	1	\N	2025-05-11 12:12:25.443074
8497	Điểm hệ số 1 #3	1416	1	\N	2025-05-11 12:12:25.443074
8498	Điểm hệ số 2 #1	1416	2	\N	2025-05-11 12:12:25.443074
8499	Điểm hệ số 2 #2	1416	2	\N	2025-05-11 12:12:25.443074
8500	Điểm hệ số 3	1416	3	\N	2025-05-11 12:12:25.443074
8501	Điểm hệ số 1 #1	1417	1	\N	2025-05-11 12:12:25.443074
8502	Điểm hệ số 1 #2	1417	1	\N	2025-05-11 12:12:25.443074
8503	Điểm hệ số 1 #3	1417	1	\N	2025-05-11 12:12:25.443074
8504	Điểm hệ số 2 #1	1417	2	\N	2025-05-11 12:12:25.443074
8505	Điểm hệ số 2 #2	1417	2	\N	2025-05-11 12:12:25.443074
8506	Điểm hệ số 3	1417	3	\N	2025-05-11 12:12:25.443074
8507	Điểm hệ số 1 #1	1418	1	\N	2025-05-11 12:12:25.443074
8508	Điểm hệ số 1 #2	1418	1	\N	2025-05-11 12:12:25.443074
8509	Điểm hệ số 1 #3	1418	1	\N	2025-05-11 12:12:25.443074
8510	Điểm hệ số 2 #1	1418	2	\N	2025-05-11 12:12:25.443074
8511	Điểm hệ số 2 #2	1418	2	\N	2025-05-11 12:12:25.443074
8512	Điểm hệ số 3	1418	3	\N	2025-05-11 12:12:25.443074
8513	Điểm hệ số 1 #1	1419	1	\N	2025-05-11 12:12:25.443074
8514	Điểm hệ số 1 #2	1419	1	\N	2025-05-11 12:12:25.443074
8515	Điểm hệ số 1 #3	1419	1	\N	2025-05-11 12:12:25.443074
8516	Điểm hệ số 2 #1	1419	2	\N	2025-05-11 12:12:25.443074
8517	Điểm hệ số 2 #2	1419	2	\N	2025-05-11 12:12:25.443074
8518	Điểm hệ số 3	1419	3	\N	2025-05-11 12:12:25.443074
8519	Điểm hệ số 1 #1	1420	1	\N	2025-05-11 12:12:25.443074
8520	Điểm hệ số 1 #2	1420	1	\N	2025-05-11 12:12:25.443074
8521	Điểm hệ số 1 #3	1420	1	\N	2025-05-11 12:12:25.443074
8522	Điểm hệ số 2 #1	1420	2	\N	2025-05-11 12:12:25.443074
8523	Điểm hệ số 2 #2	1420	2	\N	2025-05-11 12:12:25.443074
8524	Điểm hệ số 3	1420	3	\N	2025-05-11 12:12:25.443074
8525	Điểm hệ số 1 #1	1421	1	\N	2025-05-11 12:12:25.443074
8526	Điểm hệ số 1 #2	1421	1	\N	2025-05-11 12:12:25.443074
8527	Điểm hệ số 1 #3	1421	1	\N	2025-05-11 12:12:25.443074
8528	Điểm hệ số 2 #1	1421	2	\N	2025-05-11 12:12:25.443074
8529	Điểm hệ số 2 #2	1421	2	\N	2025-05-11 12:12:25.443074
8530	Điểm hệ số 3	1421	3	\N	2025-05-11 12:12:25.443074
8531	Điểm hệ số 1 #1	1422	1	\N	2025-05-11 12:12:25.443074
8532	Điểm hệ số 1 #2	1422	1	\N	2025-05-11 12:12:25.443074
8533	Điểm hệ số 1 #3	1422	1	\N	2025-05-11 12:12:25.443074
8534	Điểm hệ số 2 #1	1422	2	\N	2025-05-11 12:12:25.443074
8535	Điểm hệ số 2 #2	1422	2	\N	2025-05-11 12:12:25.443074
8536	Điểm hệ số 3	1422	3	\N	2025-05-11 12:12:25.443074
8537	Điểm hệ số 1 #1	1423	1	\N	2025-05-11 12:12:25.443074
8538	Điểm hệ số 1 #2	1423	1	\N	2025-05-11 12:12:25.443074
8539	Điểm hệ số 1 #3	1423	1	\N	2025-05-11 12:12:25.443074
8540	Điểm hệ số 2 #1	1423	2	\N	2025-05-11 12:12:25.443074
8541	Điểm hệ số 2 #2	1423	2	\N	2025-05-11 12:12:25.443074
8542	Điểm hệ số 3	1423	3	\N	2025-05-11 12:12:25.443074
8543	Điểm hệ số 1 #1	1424	1	\N	2025-05-11 12:12:25.443074
8544	Điểm hệ số 1 #2	1424	1	\N	2025-05-11 12:12:25.443074
8545	Điểm hệ số 1 #3	1424	1	\N	2025-05-11 12:12:25.443074
8546	Điểm hệ số 2 #1	1424	2	\N	2025-05-11 12:12:25.443074
8547	Điểm hệ số 2 #2	1424	2	\N	2025-05-11 12:12:25.443074
8548	Điểm hệ số 3	1424	3	\N	2025-05-11 12:12:25.443074
8549	Điểm hệ số 1 #1	1425	1	\N	2025-05-11 12:12:25.443074
8550	Điểm hệ số 1 #2	1425	1	\N	2025-05-11 12:12:25.443074
8551	Điểm hệ số 1 #3	1425	1	\N	2025-05-11 12:12:25.443074
8552	Điểm hệ số 2 #1	1425	2	\N	2025-05-11 12:12:25.443074
8553	Điểm hệ số 2 #2	1425	2	\N	2025-05-11 12:12:25.443074
8554	Điểm hệ số 3	1425	3	\N	2025-05-11 12:12:25.443074
8555	Điểm hệ số 1 #1	1426	1	\N	2025-05-11 12:12:25.443074
8556	Điểm hệ số 1 #2	1426	1	\N	2025-05-11 12:12:25.443074
8557	Điểm hệ số 1 #3	1426	1	\N	2025-05-11 12:12:25.443074
8558	Điểm hệ số 2 #1	1426	2	\N	2025-05-11 12:12:25.443074
8559	Điểm hệ số 2 #2	1426	2	\N	2025-05-11 12:12:25.443074
8560	Điểm hệ số 3	1426	3	\N	2025-05-11 12:12:25.443074
8561	Điểm hệ số 1 #1	1427	1	\N	2025-05-11 12:12:25.443074
8562	Điểm hệ số 1 #2	1427	1	\N	2025-05-11 12:12:25.443074
8563	Điểm hệ số 1 #3	1427	1	\N	2025-05-11 12:12:25.443074
8564	Điểm hệ số 2 #1	1427	2	\N	2025-05-11 12:12:25.443074
8565	Điểm hệ số 2 #2	1427	2	\N	2025-05-11 12:12:25.443074
8566	Điểm hệ số 3	1427	3	\N	2025-05-11 12:12:25.443074
8567	Điểm hệ số 1 #1	1428	1	\N	2025-05-11 12:12:25.443074
8568	Điểm hệ số 1 #2	1428	1	\N	2025-05-11 12:12:25.443074
8569	Điểm hệ số 1 #3	1428	1	\N	2025-05-11 12:12:25.443074
8570	Điểm hệ số 2 #1	1428	2	\N	2025-05-11 12:12:25.443074
8571	Điểm hệ số 2 #2	1428	2	\N	2025-05-11 12:12:25.443074
8572	Điểm hệ số 3	1428	3	\N	2025-05-11 12:12:25.443074
8573	Điểm hệ số 1 #1	1429	1	\N	2025-05-11 12:12:25.443074
8574	Điểm hệ số 1 #2	1429	1	\N	2025-05-11 12:12:25.443074
8575	Điểm hệ số 1 #3	1429	1	\N	2025-05-11 12:12:25.443074
8576	Điểm hệ số 2 #1	1429	2	\N	2025-05-11 12:12:25.443074
8577	Điểm hệ số 2 #2	1429	2	\N	2025-05-11 12:12:25.443074
8578	Điểm hệ số 3	1429	3	\N	2025-05-11 12:12:25.443074
8579	Điểm hệ số 1 #1	1430	1	\N	2025-05-11 12:12:25.443074
8580	Điểm hệ số 1 #2	1430	1	\N	2025-05-11 12:12:25.443074
8581	Điểm hệ số 1 #3	1430	1	\N	2025-05-11 12:12:25.443074
8582	Điểm hệ số 2 #1	1430	2	\N	2025-05-11 12:12:25.443074
8583	Điểm hệ số 2 #2	1430	2	\N	2025-05-11 12:12:25.443074
8584	Điểm hệ số 3	1430	3	\N	2025-05-11 12:12:25.443074
8585	Điểm hệ số 1 #1	1431	1	\N	2025-05-11 12:12:25.443074
8586	Điểm hệ số 1 #2	1431	1	\N	2025-05-11 12:12:25.443074
8587	Điểm hệ số 1 #3	1431	1	\N	2025-05-11 12:12:25.443074
8588	Điểm hệ số 2 #1	1431	2	\N	2025-05-11 12:12:25.443074
8589	Điểm hệ số 2 #2	1431	2	\N	2025-05-11 12:12:25.443074
8590	Điểm hệ số 3	1431	3	\N	2025-05-11 12:12:25.443074
8591	Điểm hệ số 1 #1	1432	1	\N	2025-05-11 12:12:25.443074
8592	Điểm hệ số 1 #2	1432	1	\N	2025-05-11 12:12:25.443074
8593	Điểm hệ số 1 #3	1432	1	\N	2025-05-11 12:12:25.443074
8594	Điểm hệ số 2 #1	1432	2	\N	2025-05-11 12:12:25.443074
8595	Điểm hệ số 2 #2	1432	2	\N	2025-05-11 12:12:25.443074
8596	Điểm hệ số 3	1432	3	\N	2025-05-11 12:12:25.443074
8597	Điểm hệ số 1 #1	1433	1	\N	2025-05-11 12:12:25.443074
8598	Điểm hệ số 1 #2	1433	1	\N	2025-05-11 12:12:25.443074
8599	Điểm hệ số 1 #3	1433	1	\N	2025-05-11 12:12:25.443074
8600	Điểm hệ số 2 #1	1433	2	\N	2025-05-11 12:12:25.443074
8601	Điểm hệ số 2 #2	1433	2	\N	2025-05-11 12:12:25.443074
8602	Điểm hệ số 3	1433	3	\N	2025-05-11 12:12:25.443074
8603	Điểm hệ số 1 #1	1434	1	\N	2025-05-11 12:12:25.443074
8604	Điểm hệ số 1 #2	1434	1	\N	2025-05-11 12:12:25.443074
8605	Điểm hệ số 1 #3	1434	1	\N	2025-05-11 12:12:25.443074
8606	Điểm hệ số 2 #1	1434	2	\N	2025-05-11 12:12:25.443074
8607	Điểm hệ số 2 #2	1434	2	\N	2025-05-11 12:12:25.443074
8608	Điểm hệ số 3	1434	3	\N	2025-05-11 12:12:25.443074
8609	Điểm hệ số 1 #1	1435	1	\N	2025-05-11 12:12:25.443074
8610	Điểm hệ số 1 #2	1435	1	\N	2025-05-11 12:12:25.443074
8611	Điểm hệ số 1 #3	1435	1	\N	2025-05-11 12:12:25.443074
8612	Điểm hệ số 2 #1	1435	2	\N	2025-05-11 12:12:25.443074
8613	Điểm hệ số 2 #2	1435	2	\N	2025-05-11 12:12:25.443074
8614	Điểm hệ số 3	1435	3	\N	2025-05-11 12:12:25.443074
8615	Điểm hệ số 1 #1	1436	1	\N	2025-05-11 12:12:25.443074
8616	Điểm hệ số 1 #2	1436	1	\N	2025-05-11 12:12:25.443074
8617	Điểm hệ số 1 #3	1436	1	\N	2025-05-11 12:12:25.443074
8618	Điểm hệ số 2 #1	1436	2	\N	2025-05-11 12:12:25.443074
8619	Điểm hệ số 2 #2	1436	2	\N	2025-05-11 12:12:25.443074
8620	Điểm hệ số 3	1436	3	\N	2025-05-11 12:12:25.443074
8621	Điểm hệ số 1 #1	1437	1	\N	2025-05-11 12:12:25.443074
8622	Điểm hệ số 1 #2	1437	1	\N	2025-05-11 12:12:25.443074
8623	Điểm hệ số 1 #3	1437	1	\N	2025-05-11 12:12:25.443074
8624	Điểm hệ số 2 #1	1437	2	\N	2025-05-11 12:12:25.443074
8625	Điểm hệ số 2 #2	1437	2	\N	2025-05-11 12:12:25.443074
8626	Điểm hệ số 3	1437	3	\N	2025-05-11 12:12:25.443074
8627	Điểm hệ số 1 #1	1438	1	\N	2025-05-11 12:12:25.443074
8628	Điểm hệ số 1 #2	1438	1	\N	2025-05-11 12:12:25.443074
8629	Điểm hệ số 1 #3	1438	1	\N	2025-05-11 12:12:25.443074
8630	Điểm hệ số 2 #1	1438	2	\N	2025-05-11 12:12:25.443074
8631	Điểm hệ số 2 #2	1438	2	\N	2025-05-11 12:12:25.443074
8632	Điểm hệ số 3	1438	3	\N	2025-05-11 12:12:25.443074
8633	Điểm hệ số 1 #1	1439	1	\N	2025-05-11 12:12:25.443074
8634	Điểm hệ số 1 #2	1439	1	\N	2025-05-11 12:12:25.443074
8635	Điểm hệ số 1 #3	1439	1	\N	2025-05-11 12:12:25.443074
8636	Điểm hệ số 2 #1	1439	2	\N	2025-05-11 12:12:25.443074
8637	Điểm hệ số 2 #2	1439	2	\N	2025-05-11 12:12:25.443074
8638	Điểm hệ số 3	1439	3	\N	2025-05-11 12:12:25.444072
8639	Điểm hệ số 1 #1	1440	1	\N	2025-05-11 12:12:25.444072
8640	Điểm hệ số 1 #2	1440	1	\N	2025-05-11 12:12:25.444072
8641	Điểm hệ số 1 #3	1440	1	\N	2025-05-11 12:12:25.444072
8642	Điểm hệ số 2 #1	1440	2	\N	2025-05-11 12:12:25.444072
8643	Điểm hệ số 2 #2	1440	2	\N	2025-05-11 12:12:25.444072
8644	Điểm hệ số 3	1440	3	\N	2025-05-11 12:12:25.444072
8645	Điểm hệ số 1 #1	1441	1	\N	2025-05-11 12:12:25.444072
8646	Điểm hệ số 1 #2	1441	1	\N	2025-05-11 12:12:25.444072
8647	Điểm hệ số 1 #3	1441	1	\N	2025-05-11 12:12:25.444072
8648	Điểm hệ số 2 #1	1441	2	\N	2025-05-11 12:12:25.444072
8649	Điểm hệ số 2 #2	1441	2	\N	2025-05-11 12:12:25.444072
8650	Điểm hệ số 3	1441	3	\N	2025-05-11 12:12:25.444072
8651	Điểm hệ số 1 #1	1442	1	\N	2025-05-11 12:12:25.444072
8652	Điểm hệ số 1 #2	1442	1	\N	2025-05-11 12:12:25.444072
8653	Điểm hệ số 1 #3	1442	1	\N	2025-05-11 12:12:25.444072
8654	Điểm hệ số 2 #1	1442	2	\N	2025-05-11 12:12:25.444072
8655	Điểm hệ số 2 #2	1442	2	\N	2025-05-11 12:12:25.444072
8656	Điểm hệ số 3	1442	3	\N	2025-05-11 12:12:25.444072
8657	Điểm hệ số 1 #1	1443	1	\N	2025-05-11 12:12:25.444072
8658	Điểm hệ số 1 #2	1443	1	\N	2025-05-11 12:12:25.444072
8659	Điểm hệ số 1 #3	1443	1	\N	2025-05-11 12:12:25.444072
8660	Điểm hệ số 2 #1	1443	2	\N	2025-05-11 12:12:25.444072
8661	Điểm hệ số 2 #2	1443	2	\N	2025-05-11 12:12:25.444072
8662	Điểm hệ số 3	1443	3	\N	2025-05-11 12:12:25.444072
8663	Điểm hệ số 1 #1	1444	1	\N	2025-05-11 12:12:26.612755
8664	Điểm hệ số 1 #2	1444	1	\N	2025-05-11 12:12:26.612755
8665	Điểm hệ số 1 #3	1444	1	\N	2025-05-11 12:12:26.612755
8666	Điểm hệ số 2 #1	1444	2	\N	2025-05-11 12:12:26.612755
8667	Điểm hệ số 2 #2	1444	2	\N	2025-05-11 12:12:26.612755
8668	Điểm hệ số 3	1444	3	\N	2025-05-11 12:12:26.612755
8669	Điểm hệ số 1 #1	1445	1	\N	2025-05-11 12:12:26.612755
8670	Điểm hệ số 1 #2	1445	1	\N	2025-05-11 12:12:26.612755
8671	Điểm hệ số 1 #3	1445	1	\N	2025-05-11 12:12:26.612755
8672	Điểm hệ số 2 #1	1445	2	\N	2025-05-11 12:12:26.612755
8673	Điểm hệ số 2 #2	1445	2	\N	2025-05-11 12:12:26.612755
8674	Điểm hệ số 3	1445	3	\N	2025-05-11 12:12:26.612755
8675	Điểm hệ số 1 #1	1446	1	\N	2025-05-11 12:12:26.612755
8676	Điểm hệ số 1 #2	1446	1	\N	2025-05-11 12:12:26.612755
8677	Điểm hệ số 1 #3	1446	1	\N	2025-05-11 12:12:26.612755
8678	Điểm hệ số 2 #1	1446	2	\N	2025-05-11 12:12:26.612755
8679	Điểm hệ số 2 #2	1446	2	\N	2025-05-11 12:12:26.612755
8680	Điểm hệ số 3	1446	3	\N	2025-05-11 12:12:26.612755
8681	Điểm hệ số 1 #1	1447	1	\N	2025-05-11 12:12:26.612755
8682	Điểm hệ số 1 #2	1447	1	\N	2025-05-11 12:12:26.612755
8683	Điểm hệ số 1 #3	1447	1	\N	2025-05-11 12:12:26.612755
8684	Điểm hệ số 2 #1	1447	2	\N	2025-05-11 12:12:26.612755
8685	Điểm hệ số 2 #2	1447	2	\N	2025-05-11 12:12:26.612755
8686	Điểm hệ số 3	1447	3	\N	2025-05-11 12:12:26.612755
8687	Điểm hệ số 1 #1	1448	1	\N	2025-05-11 12:12:26.612755
8688	Điểm hệ số 1 #2	1448	1	\N	2025-05-11 12:12:26.612755
8689	Điểm hệ số 1 #3	1448	1	\N	2025-05-11 12:12:26.612755
8690	Điểm hệ số 2 #1	1448	2	\N	2025-05-11 12:12:26.612755
8691	Điểm hệ số 2 #2	1448	2	\N	2025-05-11 12:12:26.612755
8692	Điểm hệ số 3	1448	3	\N	2025-05-11 12:12:26.612755
8693	Điểm hệ số 1 #1	1449	1	\N	2025-05-11 12:12:26.612755
8694	Điểm hệ số 1 #2	1449	1	\N	2025-05-11 12:12:26.612755
8695	Điểm hệ số 1 #3	1449	1	\N	2025-05-11 12:12:26.612755
8696	Điểm hệ số 2 #1	1449	2	\N	2025-05-11 12:12:26.612755
8697	Điểm hệ số 2 #2	1449	2	\N	2025-05-11 12:12:26.612755
8698	Điểm hệ số 3	1449	3	\N	2025-05-11 12:12:26.612755
8699	Điểm hệ số 1 #1	1450	1	\N	2025-05-11 12:12:26.612755
8700	Điểm hệ số 1 #2	1450	1	\N	2025-05-11 12:12:26.612755
8701	Điểm hệ số 1 #3	1450	1	\N	2025-05-11 12:12:26.612755
8702	Điểm hệ số 2 #1	1450	2	\N	2025-05-11 12:12:26.612755
8703	Điểm hệ số 2 #2	1450	2	\N	2025-05-11 12:12:26.612755
8704	Điểm hệ số 3	1450	3	\N	2025-05-11 12:12:26.612755
8705	Điểm hệ số 1 #1	1451	1	\N	2025-05-11 12:12:26.612755
8706	Điểm hệ số 1 #2	1451	1	\N	2025-05-11 12:12:26.612755
8707	Điểm hệ số 1 #3	1451	1	\N	2025-05-11 12:12:26.612755
8708	Điểm hệ số 2 #1	1451	2	\N	2025-05-11 12:12:26.612755
8709	Điểm hệ số 2 #2	1451	2	\N	2025-05-11 12:12:26.612755
8710	Điểm hệ số 3	1451	3	\N	2025-05-11 12:12:26.612755
8711	Điểm hệ số 1 #1	1452	1	\N	2025-05-11 12:12:26.612755
8712	Điểm hệ số 1 #2	1452	1	\N	2025-05-11 12:12:26.612755
8713	Điểm hệ số 1 #3	1452	1	\N	2025-05-11 12:12:26.612755
8714	Điểm hệ số 2 #1	1452	2	\N	2025-05-11 12:12:26.612755
8715	Điểm hệ số 2 #2	1452	2	\N	2025-05-11 12:12:26.612755
8716	Điểm hệ số 3	1452	3	\N	2025-05-11 12:12:26.612755
8717	Điểm hệ số 1 #1	1453	1	\N	2025-05-11 12:12:26.612755
8718	Điểm hệ số 1 #2	1453	1	\N	2025-05-11 12:12:26.612755
8719	Điểm hệ số 1 #3	1453	1	\N	2025-05-11 12:12:26.612755
8720	Điểm hệ số 2 #1	1453	2	\N	2025-05-11 12:12:26.612755
8721	Điểm hệ số 2 #2	1453	2	\N	2025-05-11 12:12:26.612755
8722	Điểm hệ số 3	1453	3	\N	2025-05-11 12:12:26.612755
8723	Điểm hệ số 1 #1	1454	1	\N	2025-05-11 12:12:26.612755
8724	Điểm hệ số 1 #2	1454	1	\N	2025-05-11 12:12:26.612755
8725	Điểm hệ số 1 #3	1454	1	\N	2025-05-11 12:12:26.612755
8726	Điểm hệ số 2 #1	1454	2	\N	2025-05-11 12:12:26.612755
8727	Điểm hệ số 2 #2	1454	2	\N	2025-05-11 12:12:26.612755
8728	Điểm hệ số 3	1454	3	\N	2025-05-11 12:12:26.612755
8729	Điểm hệ số 1 #1	1455	1	\N	2025-05-11 12:12:26.612755
8730	Điểm hệ số 1 #2	1455	1	\N	2025-05-11 12:12:26.612755
8731	Điểm hệ số 1 #3	1455	1	\N	2025-05-11 12:12:26.612755
8732	Điểm hệ số 2 #1	1455	2	\N	2025-05-11 12:12:26.612755
8733	Điểm hệ số 2 #2	1455	2	\N	2025-05-11 12:12:26.612755
8734	Điểm hệ số 3	1455	3	\N	2025-05-11 12:12:26.612755
8735	Điểm hệ số 1 #1	1456	1	\N	2025-05-11 12:12:26.612755
8736	Điểm hệ số 1 #2	1456	1	\N	2025-05-11 12:12:26.612755
8737	Điểm hệ số 1 #3	1456	1	\N	2025-05-11 12:12:26.612755
8738	Điểm hệ số 2 #1	1456	2	\N	2025-05-11 12:12:26.612755
8739	Điểm hệ số 2 #2	1456	2	\N	2025-05-11 12:12:26.612755
8740	Điểm hệ số 3	1456	3	\N	2025-05-11 12:12:26.612755
8741	Điểm hệ số 1 #1	1457	1	\N	2025-05-11 12:12:26.612755
8742	Điểm hệ số 1 #2	1457	1	\N	2025-05-11 12:12:26.613766
8743	Điểm hệ số 1 #3	1457	1	\N	2025-05-11 12:12:26.613766
8744	Điểm hệ số 2 #1	1457	2	\N	2025-05-11 12:12:26.613766
8745	Điểm hệ số 2 #2	1457	2	\N	2025-05-11 12:12:26.613766
8746	Điểm hệ số 3	1457	3	\N	2025-05-11 12:12:26.613766
8747	Điểm hệ số 1 #1	1458	1	\N	2025-05-11 12:12:26.613766
8748	Điểm hệ số 1 #2	1458	1	\N	2025-05-11 12:12:26.613766
8749	Điểm hệ số 1 #3	1458	1	\N	2025-05-11 12:12:26.613766
8750	Điểm hệ số 2 #1	1458	2	\N	2025-05-11 12:12:26.613766
8751	Điểm hệ số 2 #2	1458	2	\N	2025-05-11 12:12:26.613766
8752	Điểm hệ số 3	1458	3	\N	2025-05-11 12:12:26.613766
8753	Điểm hệ số 1 #1	1459	1	\N	2025-05-11 12:12:26.613766
8754	Điểm hệ số 1 #2	1459	1	\N	2025-05-11 12:12:26.613766
8755	Điểm hệ số 1 #3	1459	1	\N	2025-05-11 12:12:26.613766
8756	Điểm hệ số 2 #1	1459	2	\N	2025-05-11 12:12:26.613766
8757	Điểm hệ số 2 #2	1459	2	\N	2025-05-11 12:12:26.613766
8758	Điểm hệ số 3	1459	3	\N	2025-05-11 12:12:26.613766
8759	Điểm hệ số 1 #1	1460	1	\N	2025-05-11 12:12:26.613766
8760	Điểm hệ số 1 #2	1460	1	\N	2025-05-11 12:12:26.613766
8761	Điểm hệ số 1 #3	1460	1	\N	2025-05-11 12:12:26.613766
8762	Điểm hệ số 2 #1	1460	2	\N	2025-05-11 12:12:26.613766
8763	Điểm hệ số 2 #2	1460	2	\N	2025-05-11 12:12:26.613766
8764	Điểm hệ số 3	1460	3	\N	2025-05-11 12:12:26.613766
8765	Điểm hệ số 1 #1	1461	1	\N	2025-05-11 12:12:26.613766
8766	Điểm hệ số 1 #2	1461	1	\N	2025-05-11 12:12:26.613766
8767	Điểm hệ số 1 #3	1461	1	\N	2025-05-11 12:12:26.613766
8768	Điểm hệ số 2 #1	1461	2	\N	2025-05-11 12:12:26.613766
8769	Điểm hệ số 2 #2	1461	2	\N	2025-05-11 12:12:26.613766
8770	Điểm hệ số 3	1461	3	\N	2025-05-11 12:12:26.613766
8771	Điểm hệ số 1 #1	1462	1	\N	2025-05-11 12:12:26.613766
8772	Điểm hệ số 1 #2	1462	1	\N	2025-05-11 12:12:26.613766
8773	Điểm hệ số 1 #3	1462	1	\N	2025-05-11 12:12:26.613766
8774	Điểm hệ số 2 #1	1462	2	\N	2025-05-11 12:12:26.613766
8775	Điểm hệ số 2 #2	1462	2	\N	2025-05-11 12:12:26.613766
8776	Điểm hệ số 3	1462	3	\N	2025-05-11 12:12:26.613766
8777	Điểm hệ số 1 #1	1463	1	\N	2025-05-11 12:12:26.613766
8778	Điểm hệ số 1 #2	1463	1	\N	2025-05-11 12:12:26.613766
8779	Điểm hệ số 1 #3	1463	1	\N	2025-05-11 12:12:26.613766
8780	Điểm hệ số 2 #1	1463	2	\N	2025-05-11 12:12:26.613766
8781	Điểm hệ số 2 #2	1463	2	\N	2025-05-11 12:12:26.613766
8782	Điểm hệ số 3	1463	3	\N	2025-05-11 12:12:26.613766
8783	Điểm hệ số 1 #1	1464	1	\N	2025-05-11 12:12:26.613766
8784	Điểm hệ số 1 #2	1464	1	\N	2025-05-11 12:12:26.613766
8785	Điểm hệ số 1 #3	1464	1	\N	2025-05-11 12:12:26.613766
8786	Điểm hệ số 2 #1	1464	2	\N	2025-05-11 12:12:26.613766
8787	Điểm hệ số 2 #2	1464	2	\N	2025-05-11 12:12:26.613766
8788	Điểm hệ số 3	1464	3	\N	2025-05-11 12:12:26.613766
8789	Điểm hệ số 1 #1	1465	1	\N	2025-05-11 12:12:26.613766
8790	Điểm hệ số 1 #2	1465	1	\N	2025-05-11 12:12:26.613766
8791	Điểm hệ số 1 #3	1465	1	\N	2025-05-11 12:12:26.613766
8792	Điểm hệ số 2 #1	1465	2	\N	2025-05-11 12:12:26.613766
8793	Điểm hệ số 2 #2	1465	2	\N	2025-05-11 12:12:26.613766
8794	Điểm hệ số 3	1465	3	\N	2025-05-11 12:12:26.613766
8795	Điểm hệ số 1 #1	1466	1	\N	2025-05-11 12:12:26.613766
8796	Điểm hệ số 1 #2	1466	1	\N	2025-05-11 12:12:26.613766
8797	Điểm hệ số 1 #3	1466	1	\N	2025-05-11 12:12:26.613766
8798	Điểm hệ số 2 #1	1466	2	\N	2025-05-11 12:12:26.613766
8799	Điểm hệ số 2 #2	1466	2	\N	2025-05-11 12:12:26.613766
8800	Điểm hệ số 3	1466	3	\N	2025-05-11 12:12:26.613766
8801	Điểm hệ số 1 #1	1467	1	\N	2025-05-11 12:12:26.613766
8802	Điểm hệ số 1 #2	1467	1	\N	2025-05-11 12:12:26.613766
8803	Điểm hệ số 1 #3	1467	1	\N	2025-05-11 12:12:26.613766
8804	Điểm hệ số 2 #1	1467	2	\N	2025-05-11 12:12:26.613766
8805	Điểm hệ số 2 #2	1467	2	\N	2025-05-11 12:12:26.613766
8806	Điểm hệ số 3	1467	3	\N	2025-05-11 12:12:26.613766
8807	Điểm hệ số 1 #1	1468	1	\N	2025-05-11 12:12:26.613766
8808	Điểm hệ số 1 #2	1468	1	\N	2025-05-11 12:12:26.613766
8809	Điểm hệ số 1 #3	1468	1	\N	2025-05-11 12:12:26.613766
8810	Điểm hệ số 2 #1	1468	2	\N	2025-05-11 12:12:26.613766
8811	Điểm hệ số 2 #2	1468	2	\N	2025-05-11 12:12:26.613766
8812	Điểm hệ số 3	1468	3	\N	2025-05-11 12:12:26.613766
8813	Điểm hệ số 1 #1	1469	1	\N	2025-05-11 12:12:26.613766
8814	Điểm hệ số 1 #2	1469	1	\N	2025-05-11 12:12:26.613766
8815	Điểm hệ số 1 #3	1469	1	\N	2025-05-11 12:12:26.613766
8816	Điểm hệ số 2 #1	1469	2	\N	2025-05-11 12:12:26.613766
8817	Điểm hệ số 2 #2	1469	2	\N	2025-05-11 12:12:26.613766
8818	Điểm hệ số 3	1469	3	\N	2025-05-11 12:12:26.613766
8819	Điểm hệ số 1 #1	1470	1	\N	2025-05-11 12:12:26.613766
8820	Điểm hệ số 1 #2	1470	1	\N	2025-05-11 12:12:26.613766
8821	Điểm hệ số 1 #3	1470	1	\N	2025-05-11 12:12:26.613766
8822	Điểm hệ số 2 #1	1470	2	\N	2025-05-11 12:12:26.613766
8823	Điểm hệ số 2 #2	1470	2	\N	2025-05-11 12:12:26.613766
8824	Điểm hệ số 3	1470	3	\N	2025-05-11 12:12:26.613766
8825	Điểm hệ số 1 #1	1471	1	\N	2025-05-11 12:12:26.613766
8826	Điểm hệ số 1 #2	1471	1	\N	2025-05-11 12:12:26.613766
8827	Điểm hệ số 1 #3	1471	1	\N	2025-05-11 12:12:26.613766
8828	Điểm hệ số 2 #1	1471	2	\N	2025-05-11 12:12:26.613766
8829	Điểm hệ số 2 #2	1471	2	\N	2025-05-11 12:12:26.613766
8830	Điểm hệ số 3	1471	3	\N	2025-05-11 12:12:26.613766
8831	Điểm hệ số 1 #1	1472	1	\N	2025-05-11 12:12:26.613766
8832	Điểm hệ số 1 #2	1472	1	\N	2025-05-11 12:12:26.613766
8833	Điểm hệ số 1 #3	1472	1	\N	2025-05-11 12:12:26.613766
8834	Điểm hệ số 2 #1	1472	2	\N	2025-05-11 12:12:26.613766
8835	Điểm hệ số 2 #2	1472	2	\N	2025-05-11 12:12:26.613766
8836	Điểm hệ số 3	1472	3	\N	2025-05-11 12:12:26.613766
8837	Điểm hệ số 1 #1	1473	1	\N	2025-05-11 12:12:26.613766
8838	Điểm hệ số 1 #2	1473	1	\N	2025-05-11 12:12:26.613766
8839	Điểm hệ số 1 #3	1473	1	\N	2025-05-11 12:12:26.613766
8840	Điểm hệ số 2 #1	1473	2	\N	2025-05-11 12:12:26.613766
8841	Điểm hệ số 2 #2	1473	2	\N	2025-05-11 12:12:26.613766
8842	Điểm hệ số 3	1473	3	\N	2025-05-11 12:12:26.613766
8843	Điểm hệ số 1 #1	1474	1	\N	2025-05-11 12:12:26.613766
8844	Điểm hệ số 1 #2	1474	1	\N	2025-05-11 12:12:26.613766
8845	Điểm hệ số 1 #3	1474	1	\N	2025-05-11 12:12:26.613766
8846	Điểm hệ số 2 #1	1474	2	\N	2025-05-11 12:12:26.613766
8847	Điểm hệ số 2 #2	1474	2	\N	2025-05-11 12:12:26.613766
8848	Điểm hệ số 3	1474	3	\N	2025-05-11 12:12:26.613766
8849	Điểm hệ số 1 #1	1475	1	\N	2025-05-11 12:12:26.613766
8850	Điểm hệ số 1 #2	1475	1	\N	2025-05-11 12:12:26.613766
8851	Điểm hệ số 1 #3	1475	1	\N	2025-05-11 12:12:26.613766
8852	Điểm hệ số 2 #1	1475	2	\N	2025-05-11 12:12:26.613766
8853	Điểm hệ số 2 #2	1475	2	\N	2025-05-11 12:12:26.613766
8854	Điểm hệ số 3	1475	3	\N	2025-05-11 12:12:26.613766
8855	Điểm hệ số 1 #1	1476	1	\N	2025-05-11 12:12:26.613766
8856	Điểm hệ số 1 #2	1476	1	\N	2025-05-11 12:12:26.613766
8857	Điểm hệ số 1 #3	1476	1	\N	2025-05-11 12:12:26.613766
8858	Điểm hệ số 2 #1	1476	2	\N	2025-05-11 12:12:26.613766
8859	Điểm hệ số 2 #2	1476	2	\N	2025-05-11 12:12:26.613766
8860	Điểm hệ số 3	1476	3	\N	2025-05-11 12:12:26.613766
8861	Điểm hệ số 1 #1	1477	1	\N	2025-05-11 12:12:26.613766
8862	Điểm hệ số 1 #2	1477	1	\N	2025-05-11 12:12:26.613766
8863	Điểm hệ số 1 #3	1477	1	\N	2025-05-11 12:12:26.613766
8864	Điểm hệ số 2 #1	1477	2	\N	2025-05-11 12:12:26.613766
8865	Điểm hệ số 2 #2	1477	2	\N	2025-05-11 12:12:26.613766
8866	Điểm hệ số 3	1477	3	\N	2025-05-11 12:12:26.613766
8867	Điểm hệ số 1 #1	1478	1	\N	2025-05-11 12:12:26.613766
8868	Điểm hệ số 1 #2	1478	1	\N	2025-05-11 12:12:26.613766
8869	Điểm hệ số 1 #3	1478	1	\N	2025-05-11 12:12:26.613766
8870	Điểm hệ số 2 #1	1478	2	\N	2025-05-11 12:12:26.613766
8871	Điểm hệ số 2 #2	1478	2	\N	2025-05-11 12:12:26.613766
8872	Điểm hệ số 3	1478	3	\N	2025-05-11 12:12:26.613766
8873	Điểm hệ số 1 #1	1479	1	\N	2025-05-11 12:12:26.613766
8874	Điểm hệ số 1 #2	1479	1	\N	2025-05-11 12:12:26.613766
8875	Điểm hệ số 1 #3	1479	1	\N	2025-05-11 12:12:26.613766
8876	Điểm hệ số 2 #1	1479	2	\N	2025-05-11 12:12:26.613766
8877	Điểm hệ số 2 #2	1479	2	\N	2025-05-11 12:12:26.613766
8878	Điểm hệ số 3	1479	3	\N	2025-05-11 12:12:26.613766
8879	Điểm hệ số 1 #1	1480	1	\N	2025-05-11 12:12:26.613766
8880	Điểm hệ số 1 #2	1480	1	\N	2025-05-11 12:12:26.613766
8881	Điểm hệ số 1 #3	1480	1	\N	2025-05-11 12:12:26.613766
8882	Điểm hệ số 2 #1	1480	2	\N	2025-05-11 12:12:26.613766
8883	Điểm hệ số 2 #2	1480	2	\N	2025-05-11 12:12:26.613766
8884	Điểm hệ số 3	1480	3	\N	2025-05-11 12:12:26.613766
8885	Điểm hệ số 1 #1	1481	1	\N	2025-05-11 12:12:26.613766
8886	Điểm hệ số 1 #2	1481	1	\N	2025-05-11 12:12:26.613766
8887	Điểm hệ số 1 #3	1481	1	\N	2025-05-11 12:12:26.613766
8888	Điểm hệ số 2 #1	1481	2	\N	2025-05-11 12:12:26.613766
8889	Điểm hệ số 2 #2	1481	2	\N	2025-05-11 12:12:26.613766
8890	Điểm hệ số 3	1481	3	\N	2025-05-11 12:12:26.613766
8891	Điểm hệ số 1 #1	1482	1	\N	2025-05-11 12:12:26.613766
8892	Điểm hệ số 1 #2	1482	1	\N	2025-05-11 12:12:26.613766
8893	Điểm hệ số 1 #3	1482	1	\N	2025-05-11 12:12:26.613766
8894	Điểm hệ số 2 #1	1482	2	\N	2025-05-11 12:12:26.613766
8895	Điểm hệ số 2 #2	1482	2	\N	2025-05-11 12:12:26.613766
8896	Điểm hệ số 3	1482	3	\N	2025-05-11 12:12:26.613766
8897	Điểm hệ số 1 #1	1483	1	\N	2025-05-11 12:12:26.613766
8898	Điểm hệ số 1 #2	1483	1	\N	2025-05-11 12:12:26.613766
8899	Điểm hệ số 1 #3	1483	1	\N	2025-05-11 12:12:26.613766
8900	Điểm hệ số 2 #1	1483	2	\N	2025-05-11 12:12:26.613766
8901	Điểm hệ số 2 #2	1483	2	\N	2025-05-11 12:12:26.613766
8902	Điểm hệ số 3	1483	3	\N	2025-05-11 12:12:26.613766
8903	Điểm hệ số 1 #1	1484	1	\N	2025-05-11 12:12:26.613766
8904	Điểm hệ số 1 #2	1484	1	\N	2025-05-11 12:12:26.613766
8905	Điểm hệ số 1 #3	1484	1	\N	2025-05-11 12:12:26.613766
8906	Điểm hệ số 2 #1	1484	2	\N	2025-05-11 12:12:26.613766
8907	Điểm hệ số 2 #2	1484	2	\N	2025-05-11 12:12:26.613766
8908	Điểm hệ số 3	1484	3	\N	2025-05-11 12:12:26.613766
8909	Điểm hệ số 1 #1	1485	1	\N	2025-05-11 12:12:26.613766
8910	Điểm hệ số 1 #2	1485	1	\N	2025-05-11 12:12:26.613766
8911	Điểm hệ số 1 #3	1485	1	\N	2025-05-11 12:12:26.613766
8912	Điểm hệ số 2 #1	1485	2	\N	2025-05-11 12:12:26.613766
8913	Điểm hệ số 2 #2	1485	2	\N	2025-05-11 12:12:26.613766
8914	Điểm hệ số 3	1485	3	\N	2025-05-11 12:12:26.613766
8915	Điểm hệ số 1 #1	1486	1	\N	2025-05-11 12:12:26.613766
8916	Điểm hệ số 1 #2	1486	1	\N	2025-05-11 12:12:26.613766
8917	Điểm hệ số 1 #3	1486	1	\N	2025-05-11 12:12:26.613766
8918	Điểm hệ số 2 #1	1486	2	\N	2025-05-11 12:12:26.613766
8919	Điểm hệ số 2 #2	1486	2	\N	2025-05-11 12:12:26.613766
8920	Điểm hệ số 3	1486	3	\N	2025-05-11 12:12:26.613766
8921	Điểm hệ số 1 #1	1487	1	\N	2025-05-11 12:12:26.613766
8922	Điểm hệ số 1 #2	1487	1	\N	2025-05-11 12:12:26.613766
8923	Điểm hệ số 1 #3	1487	1	\N	2025-05-11 12:12:26.613766
8924	Điểm hệ số 2 #1	1487	2	\N	2025-05-11 12:12:26.613766
8925	Điểm hệ số 2 #2	1487	2	\N	2025-05-11 12:12:26.613766
8926	Điểm hệ số 3	1487	3	\N	2025-05-11 12:12:26.613766
8927	Điểm hệ số 1 #1	1488	1	\N	2025-05-11 12:12:26.613766
8928	Điểm hệ số 1 #2	1488	1	\N	2025-05-11 12:12:26.613766
8929	Điểm hệ số 1 #3	1488	1	\N	2025-05-11 12:12:26.613766
8930	Điểm hệ số 2 #1	1488	2	\N	2025-05-11 12:12:26.613766
8931	Điểm hệ số 2 #2	1488	2	\N	2025-05-11 12:12:26.613766
8932	Điểm hệ số 3	1488	3	\N	2025-05-11 12:12:26.613766
8933	Điểm hệ số 1 #1	1489	1	\N	2025-05-11 12:12:26.613766
8934	Điểm hệ số 1 #2	1489	1	\N	2025-05-11 12:12:26.613766
8935	Điểm hệ số 1 #3	1489	1	\N	2025-05-11 12:12:26.613766
8936	Điểm hệ số 2 #1	1489	2	\N	2025-05-11 12:12:26.613766
8937	Điểm hệ số 2 #2	1489	2	\N	2025-05-11 12:12:26.613766
8938	Điểm hệ số 3	1489	3	\N	2025-05-11 12:12:26.613766
8939	Điểm hệ số 1 #1	1490	1	\N	2025-05-11 12:12:26.613766
8940	Điểm hệ số 1 #2	1490	1	\N	2025-05-11 12:12:26.613766
8941	Điểm hệ số 1 #3	1490	1	\N	2025-05-11 12:12:26.613766
8942	Điểm hệ số 2 #1	1490	2	\N	2025-05-11 12:12:26.613766
8943	Điểm hệ số 2 #2	1490	2	\N	2025-05-11 12:12:26.613766
8944	Điểm hệ số 3	1490	3	\N	2025-05-11 12:12:26.613766
8945	Điểm hệ số 1 #1	1491	1	\N	2025-05-11 12:12:26.613766
8946	Điểm hệ số 1 #2	1491	1	\N	2025-05-11 12:12:26.613766
8947	Điểm hệ số 1 #3	1491	1	\N	2025-05-11 12:12:26.613766
8948	Điểm hệ số 2 #1	1491	2	\N	2025-05-11 12:12:26.613766
8949	Điểm hệ số 2 #2	1491	2	\N	2025-05-11 12:12:26.613766
8950	Điểm hệ số 3	1491	3	\N	2025-05-11 12:12:26.613766
8951	Điểm hệ số 1 #1	1492	1	\N	2025-05-11 12:12:26.613766
8952	Điểm hệ số 1 #2	1492	1	\N	2025-05-11 12:12:26.613766
8953	Điểm hệ số 1 #3	1492	1	\N	2025-05-11 12:12:26.613766
8954	Điểm hệ số 2 #1	1492	2	\N	2025-05-11 12:12:26.613766
8955	Điểm hệ số 2 #2	1492	2	\N	2025-05-11 12:12:26.613766
8956	Điểm hệ số 3	1492	3	\N	2025-05-11 12:12:26.613766
8957	Điểm hệ số 1 #1	1493	1	\N	2025-05-11 12:12:26.613766
8958	Điểm hệ số 1 #2	1493	1	\N	2025-05-11 12:12:26.613766
8959	Điểm hệ số 1 #3	1493	1	\N	2025-05-11 12:12:26.613766
8960	Điểm hệ số 2 #1	1493	2	\N	2025-05-11 12:12:26.613766
8961	Điểm hệ số 2 #2	1493	2	\N	2025-05-11 12:12:26.613766
8962	Điểm hệ số 3	1493	3	\N	2025-05-11 12:12:26.613766
8963	Điểm hệ số 1 #1	1494	1	\N	2025-05-11 12:12:26.613766
8964	Điểm hệ số 1 #2	1494	1	\N	2025-05-11 12:12:26.613766
8965	Điểm hệ số 1 #3	1494	1	\N	2025-05-11 12:12:26.613766
8966	Điểm hệ số 2 #1	1494	2	\N	2025-05-11 12:12:26.613766
8967	Điểm hệ số 2 #2	1494	2	\N	2025-05-11 12:12:26.613766
8968	Điểm hệ số 3	1494	3	\N	2025-05-11 12:12:26.614755
8969	Điểm hệ số 1 #1	1495	1	\N	2025-05-11 12:12:26.614755
8970	Điểm hệ số 1 #2	1495	1	\N	2025-05-11 12:12:26.614755
8971	Điểm hệ số 1 #3	1495	1	\N	2025-05-11 12:12:26.614755
8972	Điểm hệ số 2 #1	1495	2	\N	2025-05-11 12:12:26.614755
8973	Điểm hệ số 2 #2	1495	2	\N	2025-05-11 12:12:26.614755
8974	Điểm hệ số 3	1495	3	\N	2025-05-11 12:12:26.614755
8975	Điểm hệ số 1 #1	1496	1	\N	2025-05-11 12:12:26.614755
8976	Điểm hệ số 1 #2	1496	1	\N	2025-05-11 12:12:26.614755
8977	Điểm hệ số 1 #3	1496	1	\N	2025-05-11 12:12:26.614755
8978	Điểm hệ số 2 #1	1496	2	\N	2025-05-11 12:12:26.614755
8979	Điểm hệ số 2 #2	1496	2	\N	2025-05-11 12:12:26.614755
8980	Điểm hệ số 3	1496	3	\N	2025-05-11 12:12:26.614755
8981	Điểm hệ số 1 #1	1497	1	\N	2025-05-11 12:12:26.614755
8982	Điểm hệ số 1 #2	1497	1	\N	2025-05-11 12:12:26.614755
8983	Điểm hệ số 1 #3	1497	1	\N	2025-05-11 12:12:26.614755
8984	Điểm hệ số 2 #1	1497	2	\N	2025-05-11 12:12:26.614755
8985	Điểm hệ số 2 #2	1497	2	\N	2025-05-11 12:12:26.614755
8986	Điểm hệ số 3	1497	3	\N	2025-05-11 12:12:26.614755
8987	Điểm hệ số 1 #1	1498	1	\N	2025-05-11 12:12:26.614755
8988	Điểm hệ số 1 #2	1498	1	\N	2025-05-11 12:12:26.614755
8989	Điểm hệ số 1 #3	1498	1	\N	2025-05-11 12:12:26.614755
8990	Điểm hệ số 2 #1	1498	2	\N	2025-05-11 12:12:26.614755
8991	Điểm hệ số 2 #2	1498	2	\N	2025-05-11 12:12:26.614755
8992	Điểm hệ số 3	1498	3	\N	2025-05-11 12:12:26.614755
8993	Điểm hệ số 1 #1	1499	1	\N	2025-05-11 12:12:26.614755
8994	Điểm hệ số 1 #2	1499	1	\N	2025-05-11 12:12:26.614755
8995	Điểm hệ số 1 #3	1499	1	\N	2025-05-11 12:12:26.614755
8996	Điểm hệ số 2 #1	1499	2	\N	2025-05-11 12:12:26.614755
8997	Điểm hệ số 2 #2	1499	2	\N	2025-05-11 12:12:26.614755
8998	Điểm hệ số 3	1499	3	\N	2025-05-11 12:12:26.614755
8999	Điểm hệ số 1 #1	1500	1	\N	2025-05-11 12:12:26.614755
9000	Điểm hệ số 1 #2	1500	1	\N	2025-05-11 12:12:26.614755
9001	Điểm hệ số 1 #3	1500	1	\N	2025-05-11 12:12:26.614755
9002	Điểm hệ số 2 #1	1500	2	\N	2025-05-11 12:12:26.614755
9003	Điểm hệ số 2 #2	1500	2	\N	2025-05-11 12:12:26.614755
9004	Điểm hệ số 3	1500	3	\N	2025-05-11 12:12:26.614755
9005	Điểm hệ số 1 #1	1501	1	\N	2025-05-11 12:12:26.614755
9006	Điểm hệ số 1 #2	1501	1	\N	2025-05-11 12:12:26.614755
9007	Điểm hệ số 1 #3	1501	1	\N	2025-05-11 12:12:26.614755
9008	Điểm hệ số 2 #1	1501	2	\N	2025-05-11 12:12:26.614755
9009	Điểm hệ số 2 #2	1501	2	\N	2025-05-11 12:12:26.614755
9010	Điểm hệ số 3	1501	3	\N	2025-05-11 12:12:26.614755
9011	Điểm hệ số 1 #1	1502	1	\N	2025-05-11 12:12:26.614755
9012	Điểm hệ số 1 #2	1502	1	\N	2025-05-11 12:12:26.614755
9013	Điểm hệ số 1 #3	1502	1	\N	2025-05-11 12:12:26.614755
9014	Điểm hệ số 2 #1	1502	2	\N	2025-05-11 12:12:26.614755
9015	Điểm hệ số 2 #2	1502	2	\N	2025-05-11 12:12:26.614755
9016	Điểm hệ số 3	1502	3	\N	2025-05-11 12:12:26.614755
9017	Điểm hệ số 1 #1	1503	1	\N	2025-05-11 12:12:26.614755
9018	Điểm hệ số 1 #2	1503	1	\N	2025-05-11 12:12:26.614755
9019	Điểm hệ số 1 #3	1503	1	\N	2025-05-11 12:12:26.614755
9020	Điểm hệ số 2 #1	1503	2	\N	2025-05-11 12:12:26.614755
9021	Điểm hệ số 2 #2	1503	2	\N	2025-05-11 12:12:26.614755
9022	Điểm hệ số 3	1503	3	\N	2025-05-11 12:12:26.614755
9023	Điểm hệ số 1 #1	1504	1	\N	2025-05-11 12:12:26.614755
9024	Điểm hệ số 1 #2	1504	1	\N	2025-05-11 12:12:26.614755
9025	Điểm hệ số 1 #3	1504	1	\N	2025-05-11 12:12:26.614755
9026	Điểm hệ số 2 #1	1504	2	\N	2025-05-11 12:12:26.614755
9027	Điểm hệ số 2 #2	1504	2	\N	2025-05-11 12:12:26.614755
9028	Điểm hệ số 3	1504	3	\N	2025-05-11 12:12:26.614755
9029	Điểm hệ số 1 #1	1505	1	\N	2025-05-11 12:12:26.614755
9030	Điểm hệ số 1 #2	1505	1	\N	2025-05-11 12:12:26.614755
9031	Điểm hệ số 1 #3	1505	1	\N	2025-05-11 12:12:26.614755
9032	Điểm hệ số 2 #1	1505	2	\N	2025-05-11 12:12:26.614755
9033	Điểm hệ số 2 #2	1505	2	\N	2025-05-11 12:12:26.614755
9034	Điểm hệ số 3	1505	3	\N	2025-05-11 12:12:26.614755
9035	Điểm hệ số 1 #1	1506	1	\N	2025-05-11 12:12:26.614755
9036	Điểm hệ số 1 #2	1506	1	\N	2025-05-11 12:12:26.614755
9037	Điểm hệ số 1 #3	1506	1	\N	2025-05-11 12:12:26.614755
9038	Điểm hệ số 2 #1	1506	2	\N	2025-05-11 12:12:26.614755
9039	Điểm hệ số 2 #2	1506	2	\N	2025-05-11 12:12:26.614755
9040	Điểm hệ số 3	1506	3	\N	2025-05-11 12:12:26.614755
9041	Điểm hệ số 1 #1	1507	1	\N	2025-05-11 12:12:26.614755
9042	Điểm hệ số 1 #2	1507	1	\N	2025-05-11 12:12:26.614755
9043	Điểm hệ số 1 #3	1507	1	\N	2025-05-11 12:12:26.614755
9044	Điểm hệ số 2 #1	1507	2	\N	2025-05-11 12:12:26.614755
9045	Điểm hệ số 2 #2	1507	2	\N	2025-05-11 12:12:26.614755
9046	Điểm hệ số 3	1507	3	\N	2025-05-11 12:12:26.614755
9047	Điểm hệ số 1 #1	1508	1	\N	2025-05-11 12:12:26.614755
9048	Điểm hệ số 1 #2	1508	1	\N	2025-05-11 12:12:26.614755
9049	Điểm hệ số 1 #3	1508	1	\N	2025-05-11 12:12:26.614755
9050	Điểm hệ số 2 #1	1508	2	\N	2025-05-11 12:12:26.614755
9051	Điểm hệ số 2 #2	1508	2	\N	2025-05-11 12:12:26.614755
9052	Điểm hệ số 3	1508	3	\N	2025-05-11 12:12:26.614755
9053	Điểm hệ số 1 #1	1509	1	\N	2025-05-11 12:12:26.614755
9054	Điểm hệ số 1 #2	1509	1	\N	2025-05-11 12:12:26.614755
9055	Điểm hệ số 1 #3	1509	1	\N	2025-05-11 12:12:26.614755
9056	Điểm hệ số 2 #1	1509	2	\N	2025-05-11 12:12:26.614755
9057	Điểm hệ số 2 #2	1509	2	\N	2025-05-11 12:12:26.614755
9058	Điểm hệ số 3	1509	3	\N	2025-05-11 12:12:26.614755
9059	Điểm hệ số 1 #1	1510	1	\N	2025-05-11 12:12:26.614755
9060	Điểm hệ số 1 #2	1510	1	\N	2025-05-11 12:12:26.614755
9061	Điểm hệ số 1 #3	1510	1	\N	2025-05-11 12:12:26.614755
9062	Điểm hệ số 2 #1	1510	2	\N	2025-05-11 12:12:26.614755
9063	Điểm hệ số 2 #2	1510	2	\N	2025-05-11 12:12:26.614755
9064	Điểm hệ số 3	1510	3	\N	2025-05-11 12:12:26.614755
9065	Điểm hệ số 1 #1	1511	1	\N	2025-05-11 12:12:26.614755
9066	Điểm hệ số 1 #2	1511	1	\N	2025-05-11 12:12:26.614755
9067	Điểm hệ số 1 #3	1511	1	\N	2025-05-11 12:12:26.614755
9068	Điểm hệ số 2 #1	1511	2	\N	2025-05-11 12:12:26.614755
9069	Điểm hệ số 2 #2	1511	2	\N	2025-05-11 12:12:26.614755
9070	Điểm hệ số 3	1511	3	\N	2025-05-11 12:12:26.614755
9071	Điểm hệ số 1 #1	1512	1	\N	2025-05-11 12:12:26.614755
9072	Điểm hệ số 1 #2	1512	1	\N	2025-05-11 12:12:26.614755
9073	Điểm hệ số 1 #3	1512	1	\N	2025-05-11 12:12:26.614755
9074	Điểm hệ số 2 #1	1512	2	\N	2025-05-11 12:12:26.614755
9075	Điểm hệ số 2 #2	1512	2	\N	2025-05-11 12:12:26.614755
9076	Điểm hệ số 3	1512	3	\N	2025-05-11 12:12:26.614755
9077	Điểm hệ số 1 #1	1513	1	\N	2025-05-11 12:12:26.614755
9078	Điểm hệ số 1 #2	1513	1	\N	2025-05-11 12:12:26.614755
9079	Điểm hệ số 1 #3	1513	1	\N	2025-05-11 12:12:26.614755
9080	Điểm hệ số 2 #1	1513	2	\N	2025-05-11 12:12:26.614755
9081	Điểm hệ số 2 #2	1513	2	\N	2025-05-11 12:12:26.614755
9082	Điểm hệ số 3	1513	3	\N	2025-05-11 12:12:26.614755
9083	Điểm hệ số 1 #1	1514	1	\N	2025-05-11 12:12:26.614755
9084	Điểm hệ số 1 #2	1514	1	\N	2025-05-11 12:12:26.614755
9085	Điểm hệ số 1 #3	1514	1	\N	2025-05-11 12:12:26.614755
9086	Điểm hệ số 2 #1	1514	2	\N	2025-05-11 12:12:26.614755
9087	Điểm hệ số 2 #2	1514	2	\N	2025-05-11 12:12:26.614755
9088	Điểm hệ số 3	1514	3	\N	2025-05-11 12:12:26.614755
9089	Điểm hệ số 1 #1	1515	1	\N	2025-05-11 12:12:26.614755
9090	Điểm hệ số 1 #2	1515	1	\N	2025-05-11 12:12:26.614755
9091	Điểm hệ số 1 #3	1515	1	\N	2025-05-11 12:12:26.614755
9092	Điểm hệ số 2 #1	1515	2	\N	2025-05-11 12:12:26.614755
9093	Điểm hệ số 2 #2	1515	2	\N	2025-05-11 12:12:26.614755
9094	Điểm hệ số 3	1515	3	\N	2025-05-11 12:12:26.614755
9095	Điểm hệ số 1 #1	1516	1	\N	2025-05-11 12:12:26.614755
9096	Điểm hệ số 1 #2	1516	1	\N	2025-05-11 12:12:26.614755
9097	Điểm hệ số 1 #3	1516	1	\N	2025-05-11 12:12:26.614755
9098	Điểm hệ số 2 #1	1516	2	\N	2025-05-11 12:12:26.614755
9099	Điểm hệ số 2 #2	1516	2	\N	2025-05-11 12:12:26.614755
9100	Điểm hệ số 3	1516	3	\N	2025-05-11 12:12:26.614755
9101	Điểm hệ số 1 #1	1517	1	\N	2025-05-11 12:12:26.614755
9102	Điểm hệ số 1 #2	1517	1	\N	2025-05-11 12:12:26.614755
9103	Điểm hệ số 1 #3	1517	1	\N	2025-05-11 12:12:26.614755
9104	Điểm hệ số 2 #1	1517	2	\N	2025-05-11 12:12:26.614755
9105	Điểm hệ số 2 #2	1517	2	\N	2025-05-11 12:12:26.614755
9106	Điểm hệ số 3	1517	3	\N	2025-05-11 12:12:26.614755
9107	Điểm hệ số 1 #1	1518	1	\N	2025-05-11 12:12:26.614755
9108	Điểm hệ số 1 #2	1518	1	\N	2025-05-11 12:12:26.614755
9109	Điểm hệ số 1 #3	1518	1	\N	2025-05-11 12:12:26.614755
9110	Điểm hệ số 2 #1	1518	2	\N	2025-05-11 12:12:26.614755
9111	Điểm hệ số 2 #2	1518	2	\N	2025-05-11 12:12:26.614755
9112	Điểm hệ số 3	1518	3	\N	2025-05-11 12:12:26.614755
9113	Điểm hệ số 1 #1	1519	1	\N	2025-05-11 12:12:26.614755
9114	Điểm hệ số 1 #2	1519	1	\N	2025-05-11 12:12:26.614755
9115	Điểm hệ số 1 #3	1519	1	\N	2025-05-11 12:12:26.614755
9116	Điểm hệ số 2 #1	1519	2	\N	2025-05-11 12:12:26.614755
9117	Điểm hệ số 2 #2	1519	2	\N	2025-05-11 12:12:26.614755
9118	Điểm hệ số 3	1519	3	\N	2025-05-11 12:12:26.614755
9119	Điểm hệ số 1 #1	1520	1	\N	2025-05-11 12:12:26.614755
9120	Điểm hệ số 1 #2	1520	1	\N	2025-05-11 12:12:26.614755
9121	Điểm hệ số 1 #3	1520	1	\N	2025-05-11 12:12:26.614755
9122	Điểm hệ số 2 #1	1520	2	\N	2025-05-11 12:12:26.614755
9123	Điểm hệ số 2 #2	1520	2	\N	2025-05-11 12:12:26.614755
9124	Điểm hệ số 3	1520	3	\N	2025-05-11 12:12:26.614755
9125	Điểm hệ số 1 #1	1521	1	\N	2025-05-11 12:12:26.614755
9126	Điểm hệ số 1 #2	1521	1	\N	2025-05-11 12:12:26.614755
9127	Điểm hệ số 1 #3	1521	1	\N	2025-05-11 12:12:26.614755
9128	Điểm hệ số 2 #1	1521	2	\N	2025-05-11 12:12:26.614755
9129	Điểm hệ số 2 #2	1521	2	\N	2025-05-11 12:12:26.614755
9130	Điểm hệ số 3	1521	3	\N	2025-05-11 12:12:26.614755
9131	Điểm hệ số 1 #1	1522	1	\N	2025-05-11 12:12:26.614755
9132	Điểm hệ số 1 #2	1522	1	\N	2025-05-11 12:12:26.614755
9133	Điểm hệ số 1 #3	1522	1	\N	2025-05-11 12:12:26.614755
9134	Điểm hệ số 2 #1	1522	2	\N	2025-05-11 12:12:26.614755
9135	Điểm hệ số 2 #2	1522	2	\N	2025-05-11 12:12:26.614755
9136	Điểm hệ số 3	1522	3	\N	2025-05-11 12:12:26.614755
9137	Điểm hệ số 1 #1	1523	1	\N	2025-05-11 12:12:26.614755
9138	Điểm hệ số 1 #2	1523	1	\N	2025-05-11 12:12:26.614755
9139	Điểm hệ số 1 #3	1523	1	\N	2025-05-11 12:12:26.614755
9140	Điểm hệ số 2 #1	1523	2	\N	2025-05-11 12:12:26.614755
9141	Điểm hệ số 2 #2	1523	2	\N	2025-05-11 12:12:26.614755
9142	Điểm hệ số 3	1523	3	\N	2025-05-11 12:12:26.614755
9143	Điểm hệ số 1 #1	1524	1	\N	2025-05-11 12:12:26.614755
9144	Điểm hệ số 1 #2	1524	1	\N	2025-05-11 12:12:26.614755
9145	Điểm hệ số 1 #3	1524	1	\N	2025-05-11 12:12:26.614755
9146	Điểm hệ số 2 #1	1524	2	\N	2025-05-11 12:12:26.614755
9147	Điểm hệ số 2 #2	1524	2	\N	2025-05-11 12:12:26.614755
9148	Điểm hệ số 3	1524	3	\N	2025-05-11 12:12:26.614755
9149	Điểm hệ số 1 #1	1525	1	\N	2025-05-11 12:12:26.614755
9150	Điểm hệ số 1 #2	1525	1	\N	2025-05-11 12:12:26.614755
9151	Điểm hệ số 1 #3	1525	1	\N	2025-05-11 12:12:26.614755
9152	Điểm hệ số 2 #1	1525	2	\N	2025-05-11 12:12:26.614755
9153	Điểm hệ số 2 #2	1525	2	\N	2025-05-11 12:12:26.614755
9154	Điểm hệ số 3	1525	3	\N	2025-05-11 12:12:26.614755
9155	Điểm hệ số 1 #1	1526	1	\N	2025-05-11 12:12:26.614755
9156	Điểm hệ số 1 #2	1526	1	\N	2025-05-11 12:12:26.614755
9157	Điểm hệ số 1 #3	1526	1	\N	2025-05-11 12:12:26.614755
9158	Điểm hệ số 2 #1	1526	2	\N	2025-05-11 12:12:26.614755
9159	Điểm hệ số 2 #2	1526	2	\N	2025-05-11 12:12:26.614755
9160	Điểm hệ số 3	1526	3	\N	2025-05-11 12:12:26.614755
9161	Điểm hệ số 1 #1	1527	1	\N	2025-05-11 12:12:26.614755
9162	Điểm hệ số 1 #2	1527	1	\N	2025-05-11 12:12:26.614755
9163	Điểm hệ số 1 #3	1527	1	\N	2025-05-11 12:12:26.614755
9164	Điểm hệ số 2 #1	1527	2	\N	2025-05-11 12:12:26.614755
9165	Điểm hệ số 2 #2	1527	2	\N	2025-05-11 12:12:26.614755
9166	Điểm hệ số 3	1527	3	\N	2025-05-11 12:12:26.614755
9167	Điểm hệ số 1 #1	1528	1	\N	2025-05-11 12:12:26.614755
9168	Điểm hệ số 1 #2	1528	1	\N	2025-05-11 12:12:26.614755
9169	Điểm hệ số 1 #3	1528	1	\N	2025-05-11 12:12:26.614755
9170	Điểm hệ số 2 #1	1528	2	\N	2025-05-11 12:12:26.614755
9171	Điểm hệ số 2 #2	1528	2	\N	2025-05-11 12:12:26.614755
9172	Điểm hệ số 3	1528	3	\N	2025-05-11 12:12:26.614755
9173	Điểm hệ số 1 #1	1529	1	\N	2025-05-11 12:12:26.614755
9174	Điểm hệ số 1 #2	1529	1	\N	2025-05-11 12:12:26.614755
9175	Điểm hệ số 1 #3	1529	1	\N	2025-05-11 12:12:26.614755
9176	Điểm hệ số 2 #1	1529	2	\N	2025-05-11 12:12:26.614755
9177	Điểm hệ số 2 #2	1529	2	\N	2025-05-11 12:12:26.614755
9178	Điểm hệ số 3	1529	3	\N	2025-05-11 12:12:26.614755
9179	Điểm hệ số 1 #1	1530	1	\N	2025-05-11 12:12:26.614755
9180	Điểm hệ số 1 #2	1530	1	\N	2025-05-11 12:12:26.614755
9181	Điểm hệ số 1 #3	1530	1	\N	2025-05-11 12:12:26.614755
9182	Điểm hệ số 2 #1	1530	2	\N	2025-05-11 12:12:26.614755
9183	Điểm hệ số 2 #2	1530	2	\N	2025-05-11 12:12:26.614755
9184	Điểm hệ số 3	1530	3	\N	2025-05-11 12:12:26.615755
9185	Điểm hệ số 1 #1	1531	1	\N	2025-05-11 12:12:26.615755
9186	Điểm hệ số 1 #2	1531	1	\N	2025-05-11 12:12:26.615755
9187	Điểm hệ số 1 #3	1531	1	\N	2025-05-11 12:12:26.615755
9188	Điểm hệ số 2 #1	1531	2	\N	2025-05-11 12:12:26.615755
9189	Điểm hệ số 2 #2	1531	2	\N	2025-05-11 12:12:26.615755
9190	Điểm hệ số 3	1531	3	\N	2025-05-11 12:12:26.615755
9191	Điểm hệ số 1 #1	1532	1	\N	2025-05-11 12:12:26.615755
9192	Điểm hệ số 1 #2	1532	1	\N	2025-05-11 12:12:26.615755
9193	Điểm hệ số 1 #3	1532	1	\N	2025-05-11 12:12:26.615755
9194	Điểm hệ số 2 #1	1532	2	\N	2025-05-11 12:12:26.615755
9195	Điểm hệ số 2 #2	1532	2	\N	2025-05-11 12:12:26.615755
9196	Điểm hệ số 3	1532	3	\N	2025-05-11 12:12:26.615755
9197	Điểm hệ số 1 #1	1533	1	\N	2025-05-11 12:12:26.615755
9198	Điểm hệ số 1 #2	1533	1	\N	2025-05-11 12:12:26.615755
9199	Điểm hệ số 1 #3	1533	1	\N	2025-05-11 12:12:26.615755
9200	Điểm hệ số 2 #1	1533	2	\N	2025-05-11 12:12:26.615755
9201	Điểm hệ số 2 #2	1533	2	\N	2025-05-11 12:12:26.615755
9202	Điểm hệ số 3	1533	3	\N	2025-05-11 12:12:26.615755
9203	Điểm hệ số 1 #1	1534	1	\N	2025-05-11 12:12:26.615755
9204	Điểm hệ số 1 #2	1534	1	\N	2025-05-11 12:12:26.615755
9205	Điểm hệ số 1 #3	1534	1	\N	2025-05-11 12:12:26.615755
9206	Điểm hệ số 2 #1	1534	2	\N	2025-05-11 12:12:26.615755
9207	Điểm hệ số 2 #2	1534	2	\N	2025-05-11 12:12:26.615755
9208	Điểm hệ số 3	1534	3	\N	2025-05-11 12:12:26.615755
9209	Điểm hệ số 1 #1	1535	1	\N	2025-05-11 12:12:26.615755
9210	Điểm hệ số 1 #2	1535	1	\N	2025-05-11 12:12:26.615755
9211	Điểm hệ số 1 #3	1535	1	\N	2025-05-11 12:12:26.615755
9212	Điểm hệ số 2 #1	1535	2	\N	2025-05-11 12:12:26.615755
9213	Điểm hệ số 2 #2	1535	2	\N	2025-05-11 12:12:26.615755
9214	Điểm hệ số 3	1535	3	\N	2025-05-11 12:12:26.615755
9215	Điểm hệ số 1 #1	1536	1	\N	2025-05-11 12:12:27.827231
9216	Điểm hệ số 1 #2	1536	1	\N	2025-05-11 12:12:27.827231
9217	Điểm hệ số 1 #3	1536	1	\N	2025-05-11 12:12:27.827231
9218	Điểm hệ số 2 #1	1536	2	\N	2025-05-11 12:12:27.827231
9219	Điểm hệ số 2 #2	1536	2	\N	2025-05-11 12:12:27.827231
9220	Điểm hệ số 3	1536	3	\N	2025-05-11 12:12:27.827231
9221	Điểm hệ số 1 #1	1537	1	\N	2025-05-11 12:12:27.827231
9222	Điểm hệ số 1 #2	1537	1	\N	2025-05-11 12:12:27.827231
9223	Điểm hệ số 1 #3	1537	1	\N	2025-05-11 12:12:27.827231
9224	Điểm hệ số 2 #1	1537	2	\N	2025-05-11 12:12:27.827231
9225	Điểm hệ số 2 #2	1537	2	\N	2025-05-11 12:12:27.827231
9226	Điểm hệ số 3	1537	3	\N	2025-05-11 12:12:27.827231
9227	Điểm hệ số 1 #1	1538	1	\N	2025-05-11 12:12:27.827231
9228	Điểm hệ số 1 #2	1538	1	\N	2025-05-11 12:12:27.827231
9229	Điểm hệ số 1 #3	1538	1	\N	2025-05-11 12:12:27.827231
9230	Điểm hệ số 2 #1	1538	2	\N	2025-05-11 12:12:27.827231
9231	Điểm hệ số 2 #2	1538	2	\N	2025-05-11 12:12:27.827231
9232	Điểm hệ số 3	1538	3	\N	2025-05-11 12:12:27.827231
9233	Điểm hệ số 1 #1	1539	1	\N	2025-05-11 12:12:27.827231
9234	Điểm hệ số 1 #2	1539	1	\N	2025-05-11 12:12:27.827231
9235	Điểm hệ số 1 #3	1539	1	\N	2025-05-11 12:12:27.827231
9236	Điểm hệ số 2 #1	1539	2	\N	2025-05-11 12:12:27.827231
9237	Điểm hệ số 2 #2	1539	2	\N	2025-05-11 12:12:27.827231
9238	Điểm hệ số 3	1539	3	\N	2025-05-11 12:12:27.827231
9239	Điểm hệ số 1 #1	1540	1	\N	2025-05-11 12:12:27.827231
9240	Điểm hệ số 1 #2	1540	1	\N	2025-05-11 12:12:27.827231
9241	Điểm hệ số 1 #3	1540	1	\N	2025-05-11 12:12:27.827231
9242	Điểm hệ số 2 #1	1540	2	\N	2025-05-11 12:12:27.827231
9243	Điểm hệ số 2 #2	1540	2	\N	2025-05-11 12:12:27.827231
9244	Điểm hệ số 3	1540	3	\N	2025-05-11 12:12:27.827231
9245	Điểm hệ số 1 #1	1541	1	\N	2025-05-11 12:12:27.827231
9246	Điểm hệ số 1 #2	1541	1	\N	2025-05-11 12:12:27.827231
9247	Điểm hệ số 1 #3	1541	1	\N	2025-05-11 12:12:27.827231
9248	Điểm hệ số 2 #1	1541	2	\N	2025-05-11 12:12:27.827231
9249	Điểm hệ số 2 #2	1541	2	\N	2025-05-11 12:12:27.827231
9250	Điểm hệ số 3	1541	3	\N	2025-05-11 12:12:27.827231
9251	Điểm hệ số 1 #1	1542	1	\N	2025-05-11 12:12:27.827231
9252	Điểm hệ số 1 #2	1542	1	\N	2025-05-11 12:12:27.827231
9253	Điểm hệ số 1 #3	1542	1	\N	2025-05-11 12:12:27.827231
9254	Điểm hệ số 2 #1	1542	2	\N	2025-05-11 12:12:27.827231
9255	Điểm hệ số 2 #2	1542	2	\N	2025-05-11 12:12:27.827231
9256	Điểm hệ số 3	1542	3	\N	2025-05-11 12:12:27.827231
9257	Điểm hệ số 1 #1	1543	1	\N	2025-05-11 12:12:27.827231
9258	Điểm hệ số 1 #2	1543	1	\N	2025-05-11 12:12:27.827231
9259	Điểm hệ số 1 #3	1543	1	\N	2025-05-11 12:12:27.827231
9260	Điểm hệ số 2 #1	1543	2	\N	2025-05-11 12:12:27.827231
9261	Điểm hệ số 2 #2	1543	2	\N	2025-05-11 12:12:27.827231
9262	Điểm hệ số 3	1543	3	\N	2025-05-11 12:12:27.827231
9263	Điểm hệ số 1 #1	1544	1	\N	2025-05-11 12:12:27.827231
9264	Điểm hệ số 1 #2	1544	1	\N	2025-05-11 12:12:27.827231
9265	Điểm hệ số 1 #3	1544	1	\N	2025-05-11 12:12:27.827231
9266	Điểm hệ số 2 #1	1544	2	\N	2025-05-11 12:12:27.827231
9267	Điểm hệ số 2 #2	1544	2	\N	2025-05-11 12:12:27.827231
9268	Điểm hệ số 3	1544	3	\N	2025-05-11 12:12:27.827231
9269	Điểm hệ số 1 #1	1545	1	\N	2025-05-11 12:12:27.827231
9270	Điểm hệ số 1 #2	1545	1	\N	2025-05-11 12:12:27.827231
9271	Điểm hệ số 1 #3	1545	1	\N	2025-05-11 12:12:27.827231
9272	Điểm hệ số 2 #1	1545	2	\N	2025-05-11 12:12:27.827231
9273	Điểm hệ số 2 #2	1545	2	\N	2025-05-11 12:12:27.827231
9274	Điểm hệ số 3	1545	3	\N	2025-05-11 12:12:27.827231
9275	Điểm hệ số 1 #1	1546	1	\N	2025-05-11 12:12:27.827231
9276	Điểm hệ số 1 #2	1546	1	\N	2025-05-11 12:12:27.827231
9277	Điểm hệ số 1 #3	1546	1	\N	2025-05-11 12:12:27.827231
9278	Điểm hệ số 2 #1	1546	2	\N	2025-05-11 12:12:27.827231
9279	Điểm hệ số 2 #2	1546	2	\N	2025-05-11 12:12:27.827231
9280	Điểm hệ số 3	1546	3	\N	2025-05-11 12:12:27.827231
9281	Điểm hệ số 1 #1	1547	1	\N	2025-05-11 12:12:27.827231
9282	Điểm hệ số 1 #2	1547	1	\N	2025-05-11 12:12:27.827231
9283	Điểm hệ số 1 #3	1547	1	\N	2025-05-11 12:12:27.827231
9284	Điểm hệ số 2 #1	1547	2	\N	2025-05-11 12:12:27.827231
9285	Điểm hệ số 2 #2	1547	2	\N	2025-05-11 12:12:27.827231
9286	Điểm hệ số 3	1547	3	\N	2025-05-11 12:12:27.827231
9287	Điểm hệ số 1 #1	1548	1	\N	2025-05-11 12:12:27.827231
9288	Điểm hệ số 1 #2	1548	1	\N	2025-05-11 12:12:27.827231
9289	Điểm hệ số 1 #3	1548	1	\N	2025-05-11 12:12:27.827231
9290	Điểm hệ số 2 #1	1548	2	\N	2025-05-11 12:12:27.827231
9291	Điểm hệ số 2 #2	1548	2	\N	2025-05-11 12:12:27.827231
9292	Điểm hệ số 3	1548	3	\N	2025-05-11 12:12:27.827231
9293	Điểm hệ số 1 #1	1549	1	\N	2025-05-11 12:12:27.827231
9294	Điểm hệ số 1 #2	1549	1	\N	2025-05-11 12:12:27.827231
9295	Điểm hệ số 1 #3	1549	1	\N	2025-05-11 12:12:27.827231
9296	Điểm hệ số 2 #1	1549	2	\N	2025-05-11 12:12:27.827231
9297	Điểm hệ số 2 #2	1549	2	\N	2025-05-11 12:12:27.827231
9298	Điểm hệ số 3	1549	3	\N	2025-05-11 12:12:27.827231
9299	Điểm hệ số 1 #1	1550	1	\N	2025-05-11 12:12:27.827231
9300	Điểm hệ số 1 #2	1550	1	\N	2025-05-11 12:12:27.827231
9301	Điểm hệ số 1 #3	1550	1	\N	2025-05-11 12:12:27.827231
9302	Điểm hệ số 2 #1	1550	2	\N	2025-05-11 12:12:27.827231
9303	Điểm hệ số 2 #2	1550	2	\N	2025-05-11 12:12:27.827231
9304	Điểm hệ số 3	1550	3	\N	2025-05-11 12:12:27.827231
9305	Điểm hệ số 1 #1	1551	1	\N	2025-05-11 12:12:27.827231
9306	Điểm hệ số 1 #2	1551	1	\N	2025-05-11 12:12:27.827231
9307	Điểm hệ số 1 #3	1551	1	\N	2025-05-11 12:12:27.827231
9308	Điểm hệ số 2 #1	1551	2	\N	2025-05-11 12:12:27.827231
9309	Điểm hệ số 2 #2	1551	2	\N	2025-05-11 12:12:27.827231
9310	Điểm hệ số 3	1551	3	\N	2025-05-11 12:12:27.827231
9311	Điểm hệ số 1 #1	1552	1	\N	2025-05-11 12:12:27.827231
9312	Điểm hệ số 1 #2	1552	1	\N	2025-05-11 12:12:27.827231
9313	Điểm hệ số 1 #3	1552	1	\N	2025-05-11 12:12:27.828238
9314	Điểm hệ số 2 #1	1552	2	\N	2025-05-11 12:12:27.828238
9315	Điểm hệ số 2 #2	1552	2	\N	2025-05-11 12:12:27.828238
9316	Điểm hệ số 3	1552	3	\N	2025-05-11 12:12:27.828238
9317	Điểm hệ số 1 #1	1553	1	\N	2025-05-11 12:12:27.828238
9318	Điểm hệ số 1 #2	1553	1	\N	2025-05-11 12:12:27.828238
9319	Điểm hệ số 1 #3	1553	1	\N	2025-05-11 12:12:27.828238
9320	Điểm hệ số 2 #1	1553	2	\N	2025-05-11 12:12:27.828238
9321	Điểm hệ số 2 #2	1553	2	\N	2025-05-11 12:12:27.828238
9322	Điểm hệ số 3	1553	3	\N	2025-05-11 12:12:27.828238
9323	Điểm hệ số 1 #1	1554	1	\N	2025-05-11 12:12:27.828238
9324	Điểm hệ số 1 #2	1554	1	\N	2025-05-11 12:12:27.828238
9325	Điểm hệ số 1 #3	1554	1	\N	2025-05-11 12:12:27.828238
9326	Điểm hệ số 2 #1	1554	2	\N	2025-05-11 12:12:27.828238
9327	Điểm hệ số 2 #2	1554	2	\N	2025-05-11 12:12:27.828238
9328	Điểm hệ số 3	1554	3	\N	2025-05-11 12:12:27.828238
9329	Điểm hệ số 1 #1	1555	1	\N	2025-05-11 12:12:27.828238
9330	Điểm hệ số 1 #2	1555	1	\N	2025-05-11 12:12:27.828238
9331	Điểm hệ số 1 #3	1555	1	\N	2025-05-11 12:12:27.828238
9332	Điểm hệ số 2 #1	1555	2	\N	2025-05-11 12:12:27.828238
9333	Điểm hệ số 2 #2	1555	2	\N	2025-05-11 12:12:27.828238
9334	Điểm hệ số 3	1555	3	\N	2025-05-11 12:12:27.828238
9335	Điểm hệ số 1 #1	1556	1	\N	2025-05-11 12:12:27.828238
9336	Điểm hệ số 1 #2	1556	1	\N	2025-05-11 12:12:27.828238
9337	Điểm hệ số 1 #3	1556	1	\N	2025-05-11 12:12:27.828238
9338	Điểm hệ số 2 #1	1556	2	\N	2025-05-11 12:12:27.828238
9339	Điểm hệ số 2 #2	1556	2	\N	2025-05-11 12:12:27.828238
9340	Điểm hệ số 3	1556	3	\N	2025-05-11 12:12:27.828238
9341	Điểm hệ số 1 #1	1557	1	\N	2025-05-11 12:12:27.828238
9342	Điểm hệ số 1 #2	1557	1	\N	2025-05-11 12:12:27.828238
9343	Điểm hệ số 1 #3	1557	1	\N	2025-05-11 12:12:27.828238
9344	Điểm hệ số 2 #1	1557	2	\N	2025-05-11 12:12:27.828238
9345	Điểm hệ số 2 #2	1557	2	\N	2025-05-11 12:12:27.828238
9346	Điểm hệ số 3	1557	3	\N	2025-05-11 12:12:27.828238
9347	Điểm hệ số 1 #1	1558	1	\N	2025-05-11 12:12:27.828238
9348	Điểm hệ số 1 #2	1558	1	\N	2025-05-11 12:12:27.828238
9349	Điểm hệ số 1 #3	1558	1	\N	2025-05-11 12:12:27.828238
9350	Điểm hệ số 2 #1	1558	2	\N	2025-05-11 12:12:27.828238
9351	Điểm hệ số 2 #2	1558	2	\N	2025-05-11 12:12:27.828238
9352	Điểm hệ số 3	1558	3	\N	2025-05-11 12:12:27.828238
9353	Điểm hệ số 1 #1	1559	1	\N	2025-05-11 12:12:27.828238
9354	Điểm hệ số 1 #2	1559	1	\N	2025-05-11 12:12:27.828238
9355	Điểm hệ số 1 #3	1559	1	\N	2025-05-11 12:12:27.828238
9356	Điểm hệ số 2 #1	1559	2	\N	2025-05-11 12:12:27.828238
9357	Điểm hệ số 2 #2	1559	2	\N	2025-05-11 12:12:27.828238
9358	Điểm hệ số 3	1559	3	\N	2025-05-11 12:12:27.828238
9359	Điểm hệ số 1 #1	1560	1	\N	2025-05-11 12:12:27.828238
9360	Điểm hệ số 1 #2	1560	1	\N	2025-05-11 12:12:27.828238
9361	Điểm hệ số 1 #3	1560	1	\N	2025-05-11 12:12:27.828238
9362	Điểm hệ số 2 #1	1560	2	\N	2025-05-11 12:12:27.828238
9363	Điểm hệ số 2 #2	1560	2	\N	2025-05-11 12:12:27.828238
9364	Điểm hệ số 3	1560	3	\N	2025-05-11 12:12:27.828238
9365	Điểm hệ số 1 #1	1561	1	\N	2025-05-11 12:12:27.828238
9366	Điểm hệ số 1 #2	1561	1	\N	2025-05-11 12:12:27.828238
9367	Điểm hệ số 1 #3	1561	1	\N	2025-05-11 12:12:27.828238
9368	Điểm hệ số 2 #1	1561	2	\N	2025-05-11 12:12:27.828238
9369	Điểm hệ số 2 #2	1561	2	\N	2025-05-11 12:12:27.828238
9370	Điểm hệ số 3	1561	3	\N	2025-05-11 12:12:27.828238
9371	Điểm hệ số 1 #1	1562	1	\N	2025-05-11 12:12:27.828238
9372	Điểm hệ số 1 #2	1562	1	\N	2025-05-11 12:12:27.828238
9373	Điểm hệ số 1 #3	1562	1	\N	2025-05-11 12:12:27.828238
9374	Điểm hệ số 2 #1	1562	2	\N	2025-05-11 12:12:27.828238
9375	Điểm hệ số 2 #2	1562	2	\N	2025-05-11 12:12:27.828238
9376	Điểm hệ số 3	1562	3	\N	2025-05-11 12:12:27.828238
9377	Điểm hệ số 1 #1	1563	1	\N	2025-05-11 12:12:27.828238
9378	Điểm hệ số 1 #2	1563	1	\N	2025-05-11 12:12:27.828238
9379	Điểm hệ số 1 #3	1563	1	\N	2025-05-11 12:12:27.828238
9380	Điểm hệ số 2 #1	1563	2	\N	2025-05-11 12:12:27.828238
9381	Điểm hệ số 2 #2	1563	2	\N	2025-05-11 12:12:27.828238
9382	Điểm hệ số 3	1563	3	\N	2025-05-11 12:12:27.828238
9383	Điểm hệ số 1 #1	1564	1	\N	2025-05-11 12:12:27.828238
9384	Điểm hệ số 1 #2	1564	1	\N	2025-05-11 12:12:27.828238
9385	Điểm hệ số 1 #3	1564	1	\N	2025-05-11 12:12:27.828238
9386	Điểm hệ số 2 #1	1564	2	\N	2025-05-11 12:12:27.828238
9387	Điểm hệ số 2 #2	1564	2	\N	2025-05-11 12:12:27.828238
9388	Điểm hệ số 3	1564	3	\N	2025-05-11 12:12:27.828238
9389	Điểm hệ số 1 #1	1565	1	\N	2025-05-11 12:12:27.828238
9390	Điểm hệ số 1 #2	1565	1	\N	2025-05-11 12:12:27.828238
9391	Điểm hệ số 1 #3	1565	1	\N	2025-05-11 12:12:27.828238
9392	Điểm hệ số 2 #1	1565	2	\N	2025-05-11 12:12:27.828238
9393	Điểm hệ số 2 #2	1565	2	\N	2025-05-11 12:12:27.828238
9394	Điểm hệ số 3	1565	3	\N	2025-05-11 12:12:27.828238
9395	Điểm hệ số 1 #1	1566	1	\N	2025-05-11 12:12:27.828238
9396	Điểm hệ số 1 #2	1566	1	\N	2025-05-11 12:12:27.828238
9397	Điểm hệ số 1 #3	1566	1	\N	2025-05-11 12:12:27.828238
9398	Điểm hệ số 2 #1	1566	2	\N	2025-05-11 12:12:27.828238
9399	Điểm hệ số 2 #2	1566	2	\N	2025-05-11 12:12:27.828238
9400	Điểm hệ số 3	1566	3	\N	2025-05-11 12:12:27.828238
9401	Điểm hệ số 1 #1	1567	1	\N	2025-05-11 12:12:27.828238
9402	Điểm hệ số 1 #2	1567	1	\N	2025-05-11 12:12:27.828238
9403	Điểm hệ số 1 #3	1567	1	\N	2025-05-11 12:12:27.828238
9404	Điểm hệ số 2 #1	1567	2	\N	2025-05-11 12:12:27.828238
9405	Điểm hệ số 2 #2	1567	2	\N	2025-05-11 12:12:27.828238
9406	Điểm hệ số 3	1567	3	\N	2025-05-11 12:12:27.828238
9407	Điểm hệ số 1 #1	1568	1	\N	2025-05-11 12:12:27.828238
9408	Điểm hệ số 1 #2	1568	1	\N	2025-05-11 12:12:27.828238
9409	Điểm hệ số 1 #3	1568	1	\N	2025-05-11 12:12:27.828238
9410	Điểm hệ số 2 #1	1568	2	\N	2025-05-11 12:12:27.828238
9411	Điểm hệ số 2 #2	1568	2	\N	2025-05-11 12:12:27.828238
9412	Điểm hệ số 3	1568	3	\N	2025-05-11 12:12:27.828238
9413	Điểm hệ số 1 #1	1569	1	\N	2025-05-11 12:12:27.828238
9414	Điểm hệ số 1 #2	1569	1	\N	2025-05-11 12:12:27.828238
9415	Điểm hệ số 1 #3	1569	1	\N	2025-05-11 12:12:27.828238
9416	Điểm hệ số 2 #1	1569	2	\N	2025-05-11 12:12:27.828238
9417	Điểm hệ số 2 #2	1569	2	\N	2025-05-11 12:12:27.828238
9418	Điểm hệ số 3	1569	3	\N	2025-05-11 12:12:27.828238
9419	Điểm hệ số 1 #1	1570	1	\N	2025-05-11 12:12:27.828238
9420	Điểm hệ số 1 #2	1570	1	\N	2025-05-11 12:12:27.828238
9421	Điểm hệ số 1 #3	1570	1	\N	2025-05-11 12:12:27.828238
9422	Điểm hệ số 2 #1	1570	2	\N	2025-05-11 12:12:27.828238
9423	Điểm hệ số 2 #2	1570	2	\N	2025-05-11 12:12:27.828238
9424	Điểm hệ số 3	1570	3	\N	2025-05-11 12:12:27.828238
9425	Điểm hệ số 1 #1	1571	1	\N	2025-05-11 12:12:27.828238
9426	Điểm hệ số 1 #2	1571	1	\N	2025-05-11 12:12:27.828238
9427	Điểm hệ số 1 #3	1571	1	\N	2025-05-11 12:12:27.828238
9428	Điểm hệ số 2 #1	1571	2	\N	2025-05-11 12:12:27.828238
9429	Điểm hệ số 2 #2	1571	2	\N	2025-05-11 12:12:27.828238
9430	Điểm hệ số 3	1571	3	\N	2025-05-11 12:12:27.828238
9431	Điểm hệ số 1 #1	1572	1	\N	2025-05-11 12:12:27.828238
9432	Điểm hệ số 1 #2	1572	1	\N	2025-05-11 12:12:27.828238
9433	Điểm hệ số 1 #3	1572	1	\N	2025-05-11 12:12:27.828238
9434	Điểm hệ số 2 #1	1572	2	\N	2025-05-11 12:12:27.828238
9435	Điểm hệ số 2 #2	1572	2	\N	2025-05-11 12:12:27.828238
9436	Điểm hệ số 3	1572	3	\N	2025-05-11 12:12:27.828238
9437	Điểm hệ số 1 #1	1573	1	\N	2025-05-11 12:12:27.828238
9438	Điểm hệ số 1 #2	1573	1	\N	2025-05-11 12:12:27.828238
9439	Điểm hệ số 1 #3	1573	1	\N	2025-05-11 12:12:27.828238
9440	Điểm hệ số 2 #1	1573	2	\N	2025-05-11 12:12:27.828238
9441	Điểm hệ số 2 #2	1573	2	\N	2025-05-11 12:12:27.828238
9442	Điểm hệ số 3	1573	3	\N	2025-05-11 12:12:27.828238
9443	Điểm hệ số 1 #1	1574	1	\N	2025-05-11 12:12:27.828238
9444	Điểm hệ số 1 #2	1574	1	\N	2025-05-11 12:12:27.828238
9445	Điểm hệ số 1 #3	1574	1	\N	2025-05-11 12:12:27.828238
9446	Điểm hệ số 2 #1	1574	2	\N	2025-05-11 12:12:27.828238
9447	Điểm hệ số 2 #2	1574	2	\N	2025-05-11 12:12:27.828238
9448	Điểm hệ số 3	1574	3	\N	2025-05-11 12:12:27.828238
9449	Điểm hệ số 1 #1	1575	1	\N	2025-05-11 12:12:27.828238
9450	Điểm hệ số 1 #2	1575	1	\N	2025-05-11 12:12:27.828238
9451	Điểm hệ số 1 #3	1575	1	\N	2025-05-11 12:12:27.828238
9452	Điểm hệ số 2 #1	1575	2	\N	2025-05-11 12:12:27.828238
9453	Điểm hệ số 2 #2	1575	2	\N	2025-05-11 12:12:27.828238
9454	Điểm hệ số 3	1575	3	\N	2025-05-11 12:12:27.828238
9455	Điểm hệ số 1 #1	1576	1	\N	2025-05-11 12:12:27.828238
9456	Điểm hệ số 1 #2	1576	1	\N	2025-05-11 12:12:27.828238
9457	Điểm hệ số 1 #3	1576	1	\N	2025-05-11 12:12:27.828238
9458	Điểm hệ số 2 #1	1576	2	\N	2025-05-11 12:12:27.828238
9459	Điểm hệ số 2 #2	1576	2	\N	2025-05-11 12:12:27.828238
9460	Điểm hệ số 3	1576	3	\N	2025-05-11 12:12:27.828238
9461	Điểm hệ số 1 #1	1577	1	\N	2025-05-11 12:12:27.828238
9462	Điểm hệ số 1 #2	1577	1	\N	2025-05-11 12:12:27.828238
9463	Điểm hệ số 1 #3	1577	1	\N	2025-05-11 12:12:27.828238
9464	Điểm hệ số 2 #1	1577	2	\N	2025-05-11 12:12:27.828238
9465	Điểm hệ số 2 #2	1577	2	\N	2025-05-11 12:12:27.828238
9466	Điểm hệ số 3	1577	3	\N	2025-05-11 12:12:27.828238
9467	Điểm hệ số 1 #1	1578	1	\N	2025-05-11 12:12:27.828238
9468	Điểm hệ số 1 #2	1578	1	\N	2025-05-11 12:12:27.828238
9469	Điểm hệ số 1 #3	1578	1	\N	2025-05-11 12:12:27.828238
9470	Điểm hệ số 2 #1	1578	2	\N	2025-05-11 12:12:27.828238
9471	Điểm hệ số 2 #2	1578	2	\N	2025-05-11 12:12:27.828238
9472	Điểm hệ số 3	1578	3	\N	2025-05-11 12:12:27.828238
9473	Điểm hệ số 1 #1	1579	1	\N	2025-05-11 12:12:27.828238
9474	Điểm hệ số 1 #2	1579	1	\N	2025-05-11 12:12:27.828238
9475	Điểm hệ số 1 #3	1579	1	\N	2025-05-11 12:12:27.828238
9476	Điểm hệ số 2 #1	1579	2	\N	2025-05-11 12:12:27.828238
9477	Điểm hệ số 2 #2	1579	2	\N	2025-05-11 12:12:27.828238
9478	Điểm hệ số 3	1579	3	\N	2025-05-11 12:12:27.828238
9479	Điểm hệ số 1 #1	1580	1	\N	2025-05-11 12:12:27.828238
9480	Điểm hệ số 1 #2	1580	1	\N	2025-05-11 12:12:27.828238
9481	Điểm hệ số 1 #3	1580	1	\N	2025-05-11 12:12:27.828238
9482	Điểm hệ số 2 #1	1580	2	\N	2025-05-11 12:12:27.828238
9483	Điểm hệ số 2 #2	1580	2	\N	2025-05-11 12:12:27.828238
9484	Điểm hệ số 3	1580	3	\N	2025-05-11 12:12:27.828238
9485	Điểm hệ số 1 #1	1581	1	\N	2025-05-11 12:12:27.828238
9486	Điểm hệ số 1 #2	1581	1	\N	2025-05-11 12:12:27.828238
9487	Điểm hệ số 1 #3	1581	1	\N	2025-05-11 12:12:27.828238
9488	Điểm hệ số 2 #1	1581	2	\N	2025-05-11 12:12:27.828238
9489	Điểm hệ số 2 #2	1581	2	\N	2025-05-11 12:12:27.828238
9490	Điểm hệ số 3	1581	3	\N	2025-05-11 12:12:27.828238
9491	Điểm hệ số 1 #1	1582	1	\N	2025-05-11 12:12:27.828238
9492	Điểm hệ số 1 #2	1582	1	\N	2025-05-11 12:12:27.828238
9493	Điểm hệ số 1 #3	1582	1	\N	2025-05-11 12:12:27.828238
9494	Điểm hệ số 2 #1	1582	2	\N	2025-05-11 12:12:27.828238
9495	Điểm hệ số 2 #2	1582	2	\N	2025-05-11 12:12:27.828238
9496	Điểm hệ số 3	1582	3	\N	2025-05-11 12:12:27.828238
9497	Điểm hệ số 1 #1	1583	1	\N	2025-05-11 12:12:27.828238
9498	Điểm hệ số 1 #2	1583	1	\N	2025-05-11 12:12:27.828238
9499	Điểm hệ số 1 #3	1583	1	\N	2025-05-11 12:12:27.828238
9500	Điểm hệ số 2 #1	1583	2	\N	2025-05-11 12:12:27.828238
9501	Điểm hệ số 2 #2	1583	2	\N	2025-05-11 12:12:27.828238
9502	Điểm hệ số 3	1583	3	\N	2025-05-11 12:12:27.828238
9503	Điểm hệ số 1 #1	1584	1	\N	2025-05-11 12:12:27.828238
9504	Điểm hệ số 1 #2	1584	1	\N	2025-05-11 12:12:27.828238
9505	Điểm hệ số 1 #3	1584	1	\N	2025-05-11 12:12:27.828238
9506	Điểm hệ số 2 #1	1584	2	\N	2025-05-11 12:12:27.828238
9507	Điểm hệ số 2 #2	1584	2	\N	2025-05-11 12:12:27.828238
9508	Điểm hệ số 3	1584	3	\N	2025-05-11 12:12:27.828238
9509	Điểm hệ số 1 #1	1585	1	\N	2025-05-11 12:12:27.828238
9510	Điểm hệ số 1 #2	1585	1	\N	2025-05-11 12:12:27.828238
9511	Điểm hệ số 1 #3	1585	1	\N	2025-05-11 12:12:27.828238
9512	Điểm hệ số 2 #1	1585	2	\N	2025-05-11 12:12:27.828238
9513	Điểm hệ số 2 #2	1585	2	\N	2025-05-11 12:12:27.828238
9514	Điểm hệ số 3	1585	3	\N	2025-05-11 12:12:27.828238
9515	Điểm hệ số 1 #1	1586	1	\N	2025-05-11 12:12:27.828238
9516	Điểm hệ số 1 #2	1586	1	\N	2025-05-11 12:12:27.828238
9517	Điểm hệ số 1 #3	1586	1	\N	2025-05-11 12:12:27.828238
9518	Điểm hệ số 2 #1	1586	2	\N	2025-05-11 12:12:27.828238
9519	Điểm hệ số 2 #2	1586	2	\N	2025-05-11 12:12:27.828238
9520	Điểm hệ số 3	1586	3	\N	2025-05-11 12:12:27.828238
9521	Điểm hệ số 1 #1	1587	1	\N	2025-05-11 12:12:27.828238
9522	Điểm hệ số 1 #2	1587	1	\N	2025-05-11 12:12:27.828238
9523	Điểm hệ số 1 #3	1587	1	\N	2025-05-11 12:12:27.828238
9524	Điểm hệ số 2 #1	1587	2	\N	2025-05-11 12:12:27.828238
9525	Điểm hệ số 2 #2	1587	2	\N	2025-05-11 12:12:27.828238
9526	Điểm hệ số 3	1587	3	\N	2025-05-11 12:12:27.828238
9527	Điểm hệ số 1 #1	1588	1	\N	2025-05-11 12:12:27.828238
9528	Điểm hệ số 1 #2	1588	1	\N	2025-05-11 12:12:27.828238
9529	Điểm hệ số 1 #3	1588	1	\N	2025-05-11 12:12:27.828238
9530	Điểm hệ số 2 #1	1588	2	\N	2025-05-11 12:12:27.828238
9531	Điểm hệ số 2 #2	1588	2	\N	2025-05-11 12:12:27.828238
9532	Điểm hệ số 3	1588	3	\N	2025-05-11 12:12:27.828238
9533	Điểm hệ số 1 #1	1589	1	\N	2025-05-11 12:12:27.828238
9534	Điểm hệ số 1 #2	1589	1	\N	2025-05-11 12:12:27.828238
9535	Điểm hệ số 1 #3	1589	1	\N	2025-05-11 12:12:27.828238
9536	Điểm hệ số 2 #1	1589	2	\N	2025-05-11 12:12:27.828238
9537	Điểm hệ số 2 #2	1589	2	\N	2025-05-11 12:12:27.829233
9538	Điểm hệ số 3	1589	3	\N	2025-05-11 12:12:27.829233
9539	Điểm hệ số 1 #1	1590	1	\N	2025-05-11 12:12:27.829233
9540	Điểm hệ số 1 #2	1590	1	\N	2025-05-11 12:12:27.829233
9541	Điểm hệ số 1 #3	1590	1	\N	2025-05-11 12:12:27.829233
9542	Điểm hệ số 2 #1	1590	2	\N	2025-05-11 12:12:27.829233
9543	Điểm hệ số 2 #2	1590	2	\N	2025-05-11 12:12:27.829233
9544	Điểm hệ số 3	1590	3	\N	2025-05-11 12:12:27.829233
9545	Điểm hệ số 1 #1	1591	1	\N	2025-05-11 12:12:27.829233
9546	Điểm hệ số 1 #2	1591	1	\N	2025-05-11 12:12:27.829233
9547	Điểm hệ số 1 #3	1591	1	\N	2025-05-11 12:12:27.829233
9548	Điểm hệ số 2 #1	1591	2	\N	2025-05-11 12:12:27.829233
9549	Điểm hệ số 2 #2	1591	2	\N	2025-05-11 12:12:27.829233
9550	Điểm hệ số 3	1591	3	\N	2025-05-11 12:12:27.829233
9551	Điểm hệ số 1 #1	1592	1	\N	2025-05-11 12:12:27.829233
9552	Điểm hệ số 1 #2	1592	1	\N	2025-05-11 12:12:27.829233
9553	Điểm hệ số 1 #3	1592	1	\N	2025-05-11 12:12:27.829233
9554	Điểm hệ số 2 #1	1592	2	\N	2025-05-11 12:12:27.829233
9555	Điểm hệ số 2 #2	1592	2	\N	2025-05-11 12:12:27.829233
9556	Điểm hệ số 3	1592	3	\N	2025-05-11 12:12:27.829233
9557	Điểm hệ số 1 #1	1593	1	\N	2025-05-11 12:12:27.829233
9558	Điểm hệ số 1 #2	1593	1	\N	2025-05-11 12:12:27.829233
9559	Điểm hệ số 1 #3	1593	1	\N	2025-05-11 12:12:27.829233
9560	Điểm hệ số 2 #1	1593	2	\N	2025-05-11 12:12:27.829233
9561	Điểm hệ số 2 #2	1593	2	\N	2025-05-11 12:12:27.829233
9562	Điểm hệ số 3	1593	3	\N	2025-05-11 12:12:27.829233
9563	Điểm hệ số 1 #1	1594	1	\N	2025-05-11 12:12:27.829233
9564	Điểm hệ số 1 #2	1594	1	\N	2025-05-11 12:12:27.829233
9565	Điểm hệ số 1 #3	1594	1	\N	2025-05-11 12:12:27.829233
9566	Điểm hệ số 2 #1	1594	2	\N	2025-05-11 12:12:27.829233
9567	Điểm hệ số 2 #2	1594	2	\N	2025-05-11 12:12:27.829233
9568	Điểm hệ số 3	1594	3	\N	2025-05-11 12:12:27.829233
9569	Điểm hệ số 1 #1	1595	1	\N	2025-05-11 12:12:27.829233
9570	Điểm hệ số 1 #2	1595	1	\N	2025-05-11 12:12:27.829233
9571	Điểm hệ số 1 #3	1595	1	\N	2025-05-11 12:12:27.829233
9572	Điểm hệ số 2 #1	1595	2	\N	2025-05-11 12:12:27.829233
9573	Điểm hệ số 2 #2	1595	2	\N	2025-05-11 12:12:27.829233
9574	Điểm hệ số 3	1595	3	\N	2025-05-11 12:12:27.829233
9575	Điểm hệ số 1 #1	1596	1	\N	2025-05-11 12:12:27.829233
9576	Điểm hệ số 1 #2	1596	1	\N	2025-05-11 12:12:27.829233
9577	Điểm hệ số 1 #3	1596	1	\N	2025-05-11 12:12:27.829233
9578	Điểm hệ số 2 #1	1596	2	\N	2025-05-11 12:12:27.829233
9579	Điểm hệ số 2 #2	1596	2	\N	2025-05-11 12:12:27.829233
9580	Điểm hệ số 3	1596	3	\N	2025-05-11 12:12:27.829233
9581	Điểm hệ số 1 #1	1597	1	\N	2025-05-11 12:12:27.829233
9582	Điểm hệ số 1 #2	1597	1	\N	2025-05-11 12:12:27.829233
9583	Điểm hệ số 1 #3	1597	1	\N	2025-05-11 12:12:27.829233
9584	Điểm hệ số 2 #1	1597	2	\N	2025-05-11 12:12:27.829233
9585	Điểm hệ số 2 #2	1597	2	\N	2025-05-11 12:12:27.829233
9586	Điểm hệ số 3	1597	3	\N	2025-05-11 12:12:27.829233
9587	Điểm hệ số 1 #1	1598	1	\N	2025-05-11 12:12:27.829233
9588	Điểm hệ số 1 #2	1598	1	\N	2025-05-11 12:12:27.829233
9589	Điểm hệ số 1 #3	1598	1	\N	2025-05-11 12:12:27.829233
9590	Điểm hệ số 2 #1	1598	2	\N	2025-05-11 12:12:27.829233
9591	Điểm hệ số 2 #2	1598	2	\N	2025-05-11 12:12:27.829233
9592	Điểm hệ số 3	1598	3	\N	2025-05-11 12:12:27.829233
9593	Điểm hệ số 1 #1	1599	1	\N	2025-05-11 12:12:27.829233
9594	Điểm hệ số 1 #2	1599	1	\N	2025-05-11 12:12:27.829233
9595	Điểm hệ số 1 #3	1599	1	\N	2025-05-11 12:12:27.829233
9596	Điểm hệ số 2 #1	1599	2	\N	2025-05-11 12:12:27.829233
9597	Điểm hệ số 2 #2	1599	2	\N	2025-05-11 12:12:27.829233
9598	Điểm hệ số 3	1599	3	\N	2025-05-11 12:12:27.829233
9599	Điểm hệ số 1 #1	1600	1	\N	2025-05-11 12:12:27.829233
9600	Điểm hệ số 1 #2	1600	1	\N	2025-05-11 12:12:27.829233
9601	Điểm hệ số 1 #3	1600	1	\N	2025-05-11 12:12:27.829233
9602	Điểm hệ số 2 #1	1600	2	\N	2025-05-11 12:12:27.829233
9603	Điểm hệ số 2 #2	1600	2	\N	2025-05-11 12:12:27.829233
9604	Điểm hệ số 3	1600	3	\N	2025-05-11 12:12:27.829233
9605	Điểm hệ số 1 #1	1601	1	\N	2025-05-11 12:12:27.829233
9606	Điểm hệ số 1 #2	1601	1	\N	2025-05-11 12:12:27.829233
9607	Điểm hệ số 1 #3	1601	1	\N	2025-05-11 12:12:27.829233
9608	Điểm hệ số 2 #1	1601	2	\N	2025-05-11 12:12:27.829233
9609	Điểm hệ số 2 #2	1601	2	\N	2025-05-11 12:12:27.829233
9610	Điểm hệ số 3	1601	3	\N	2025-05-11 12:12:27.829233
9611	Điểm hệ số 1 #1	1602	1	\N	2025-05-11 12:12:27.829233
9612	Điểm hệ số 1 #2	1602	1	\N	2025-05-11 12:12:27.829233
9613	Điểm hệ số 1 #3	1602	1	\N	2025-05-11 12:12:27.829233
9614	Điểm hệ số 2 #1	1602	2	\N	2025-05-11 12:12:27.829233
9615	Điểm hệ số 2 #2	1602	2	\N	2025-05-11 12:12:27.829233
9616	Điểm hệ số 3	1602	3	\N	2025-05-11 12:12:27.829233
9617	Điểm hệ số 1 #1	1603	1	\N	2025-05-11 12:12:27.829233
9618	Điểm hệ số 1 #2	1603	1	\N	2025-05-11 12:12:27.829233
9619	Điểm hệ số 1 #3	1603	1	\N	2025-05-11 12:12:27.829233
9620	Điểm hệ số 2 #1	1603	2	\N	2025-05-11 12:12:27.829233
9621	Điểm hệ số 2 #2	1603	2	\N	2025-05-11 12:12:27.829233
9622	Điểm hệ số 3	1603	3	\N	2025-05-11 12:12:27.829233
9623	Điểm hệ số 1 #1	1604	1	\N	2025-05-11 12:12:27.829233
9624	Điểm hệ số 1 #2	1604	1	\N	2025-05-11 12:12:27.829233
9625	Điểm hệ số 1 #3	1604	1	\N	2025-05-11 12:12:27.829233
9626	Điểm hệ số 2 #1	1604	2	\N	2025-05-11 12:12:27.829233
9627	Điểm hệ số 2 #2	1604	2	\N	2025-05-11 12:12:27.829233
9628	Điểm hệ số 3	1604	3	\N	2025-05-11 12:12:27.829233
9629	Điểm hệ số 1 #1	1605	1	\N	2025-05-11 12:12:27.829233
9630	Điểm hệ số 1 #2	1605	1	\N	2025-05-11 12:12:27.829233
9631	Điểm hệ số 1 #3	1605	1	\N	2025-05-11 12:12:27.829233
9632	Điểm hệ số 2 #1	1605	2	\N	2025-05-11 12:12:27.829233
9633	Điểm hệ số 2 #2	1605	2	\N	2025-05-11 12:12:27.829233
9634	Điểm hệ số 3	1605	3	\N	2025-05-11 12:12:27.829233
9635	Điểm hệ số 1 #1	1606	1	\N	2025-05-11 12:12:27.829233
9636	Điểm hệ số 1 #2	1606	1	\N	2025-05-11 12:12:27.829233
9637	Điểm hệ số 1 #3	1606	1	\N	2025-05-11 12:12:27.829233
9638	Điểm hệ số 2 #1	1606	2	\N	2025-05-11 12:12:27.829233
9639	Điểm hệ số 2 #2	1606	2	\N	2025-05-11 12:12:27.829233
9640	Điểm hệ số 3	1606	3	\N	2025-05-11 12:12:27.829233
9641	Điểm hệ số 1 #1	1607	1	\N	2025-05-11 12:12:27.829233
9642	Điểm hệ số 1 #2	1607	1	\N	2025-05-11 12:12:27.829233
9643	Điểm hệ số 1 #3	1607	1	\N	2025-05-11 12:12:27.829233
9644	Điểm hệ số 2 #1	1607	2	\N	2025-05-11 12:12:27.829233
9645	Điểm hệ số 2 #2	1607	2	\N	2025-05-11 12:12:27.829233
9646	Điểm hệ số 3	1607	3	\N	2025-05-11 12:12:27.829233
9647	Điểm hệ số 1 #1	1608	1	\N	2025-05-11 12:12:27.829233
9648	Điểm hệ số 1 #2	1608	1	\N	2025-05-11 12:12:27.829233
9649	Điểm hệ số 1 #3	1608	1	\N	2025-05-11 12:12:27.829233
9650	Điểm hệ số 2 #1	1608	2	\N	2025-05-11 12:12:27.829233
9651	Điểm hệ số 2 #2	1608	2	\N	2025-05-11 12:12:27.829233
9652	Điểm hệ số 3	1608	3	\N	2025-05-11 12:12:27.829233
9653	Điểm hệ số 1 #1	1609	1	\N	2025-05-11 12:12:27.829233
9654	Điểm hệ số 1 #2	1609	1	\N	2025-05-11 12:12:27.829233
9655	Điểm hệ số 1 #3	1609	1	\N	2025-05-11 12:12:27.829233
9656	Điểm hệ số 2 #1	1609	2	\N	2025-05-11 12:12:27.829233
9657	Điểm hệ số 2 #2	1609	2	\N	2025-05-11 12:12:27.829233
9658	Điểm hệ số 3	1609	3	\N	2025-05-11 12:12:27.829233
9659	Điểm hệ số 1 #1	1610	1	\N	2025-05-11 12:12:27.829233
9660	Điểm hệ số 1 #2	1610	1	\N	2025-05-11 12:12:27.829233
9661	Điểm hệ số 1 #3	1610	1	\N	2025-05-11 12:12:27.829233
9662	Điểm hệ số 2 #1	1610	2	\N	2025-05-11 12:12:27.829233
9663	Điểm hệ số 2 #2	1610	2	\N	2025-05-11 12:12:27.829233
9664	Điểm hệ số 3	1610	3	\N	2025-05-11 12:12:27.829233
9665	Điểm hệ số 1 #1	1611	1	\N	2025-05-11 12:12:27.829233
9666	Điểm hệ số 1 #2	1611	1	\N	2025-05-11 12:12:27.829233
9667	Điểm hệ số 1 #3	1611	1	\N	2025-05-11 12:12:27.829233
9668	Điểm hệ số 2 #1	1611	2	\N	2025-05-11 12:12:27.829233
9669	Điểm hệ số 2 #2	1611	2	\N	2025-05-11 12:12:27.829233
9670	Điểm hệ số 3	1611	3	\N	2025-05-11 12:12:27.829233
9671	Điểm hệ số 1 #1	1612	1	\N	2025-05-11 12:12:27.829233
9672	Điểm hệ số 1 #2	1612	1	\N	2025-05-11 12:12:27.829233
9673	Điểm hệ số 1 #3	1612	1	\N	2025-05-11 12:12:27.829233
9674	Điểm hệ số 2 #1	1612	2	\N	2025-05-11 12:12:27.829233
9675	Điểm hệ số 2 #2	1612	2	\N	2025-05-11 12:12:27.829233
9676	Điểm hệ số 3	1612	3	\N	2025-05-11 12:12:27.829233
9677	Điểm hệ số 1 #1	1613	1	\N	2025-05-11 12:12:27.829233
9678	Điểm hệ số 1 #2	1613	1	\N	2025-05-11 12:12:27.829233
9679	Điểm hệ số 1 #3	1613	1	\N	2025-05-11 12:12:27.829233
9680	Điểm hệ số 2 #1	1613	2	\N	2025-05-11 12:12:27.829233
9681	Điểm hệ số 2 #2	1613	2	\N	2025-05-11 12:12:27.829233
9682	Điểm hệ số 3	1613	3	\N	2025-05-11 12:12:27.829233
9683	Điểm hệ số 1 #1	1614	1	\N	2025-05-11 12:12:27.829233
9684	Điểm hệ số 1 #2	1614	1	\N	2025-05-11 12:12:27.829233
9685	Điểm hệ số 1 #3	1614	1	\N	2025-05-11 12:12:27.829233
9686	Điểm hệ số 2 #1	1614	2	\N	2025-05-11 12:12:27.829233
9687	Điểm hệ số 2 #2	1614	2	\N	2025-05-11 12:12:27.829233
9688	Điểm hệ số 3	1614	3	\N	2025-05-11 12:12:27.829233
9689	Điểm hệ số 1 #1	1615	1	\N	2025-05-11 12:12:27.829233
9690	Điểm hệ số 1 #2	1615	1	\N	2025-05-11 12:12:27.829233
9691	Điểm hệ số 1 #3	1615	1	\N	2025-05-11 12:12:27.829233
9692	Điểm hệ số 2 #1	1615	2	\N	2025-05-11 12:12:27.829233
9693	Điểm hệ số 2 #2	1615	2	\N	2025-05-11 12:12:27.829233
9694	Điểm hệ số 3	1615	3	\N	2025-05-11 12:12:27.829233
9695	Điểm hệ số 1 #1	1616	1	\N	2025-05-11 12:12:27.829233
9696	Điểm hệ số 1 #2	1616	1	\N	2025-05-11 12:12:27.829233
9697	Điểm hệ số 1 #3	1616	1	\N	2025-05-11 12:12:27.829233
9698	Điểm hệ số 2 #1	1616	2	\N	2025-05-11 12:12:27.829233
9699	Điểm hệ số 2 #2	1616	2	\N	2025-05-11 12:12:27.829233
9700	Điểm hệ số 3	1616	3	\N	2025-05-11 12:12:27.829233
9701	Điểm hệ số 1 #1	1617	1	\N	2025-05-11 12:12:27.829233
9702	Điểm hệ số 1 #2	1617	1	\N	2025-05-11 12:12:27.829233
9703	Điểm hệ số 1 #3	1617	1	\N	2025-05-11 12:12:27.829233
9704	Điểm hệ số 2 #1	1617	2	\N	2025-05-11 12:12:27.829233
9705	Điểm hệ số 2 #2	1617	2	\N	2025-05-11 12:12:27.829233
9706	Điểm hệ số 3	1617	3	\N	2025-05-11 12:12:27.829233
9707	Điểm hệ số 1 #1	1618	1	\N	2025-05-11 12:12:27.829233
9708	Điểm hệ số 1 #2	1618	1	\N	2025-05-11 12:12:27.829233
9709	Điểm hệ số 1 #3	1618	1	\N	2025-05-11 12:12:27.829233
9710	Điểm hệ số 2 #1	1618	2	\N	2025-05-11 12:12:27.829233
9711	Điểm hệ số 2 #2	1618	2	\N	2025-05-11 12:12:27.829233
9712	Điểm hệ số 3	1618	3	\N	2025-05-11 12:12:27.829233
9713	Điểm hệ số 1 #1	1619	1	\N	2025-05-11 12:12:27.829233
9714	Điểm hệ số 1 #2	1619	1	\N	2025-05-11 12:12:27.829233
9715	Điểm hệ số 1 #3	1619	1	\N	2025-05-11 12:12:27.829233
9716	Điểm hệ số 2 #1	1619	2	\N	2025-05-11 12:12:27.829233
9717	Điểm hệ số 2 #2	1619	2	\N	2025-05-11 12:12:27.829233
9718	Điểm hệ số 3	1619	3	\N	2025-05-11 12:12:27.829233
9719	Điểm hệ số 1 #1	1620	1	\N	2025-05-11 12:12:27.829233
9720	Điểm hệ số 1 #2	1620	1	\N	2025-05-11 12:12:27.829233
9721	Điểm hệ số 1 #3	1620	1	\N	2025-05-11 12:12:27.829233
9722	Điểm hệ số 2 #1	1620	2	\N	2025-05-11 12:12:27.829233
9723	Điểm hệ số 2 #2	1620	2	\N	2025-05-11 12:12:27.829233
9724	Điểm hệ số 3	1620	3	\N	2025-05-11 12:12:27.829233
9725	Điểm hệ số 1 #1	1621	1	\N	2025-05-11 12:12:27.829233
9726	Điểm hệ số 1 #2	1621	1	\N	2025-05-11 12:12:27.829233
9727	Điểm hệ số 1 #3	1621	1	\N	2025-05-11 12:12:27.829233
9728	Điểm hệ số 2 #1	1621	2	\N	2025-05-11 12:12:27.829233
9729	Điểm hệ số 2 #2	1621	2	\N	2025-05-11 12:12:27.829233
9730	Điểm hệ số 3	1621	3	\N	2025-05-11 12:12:27.829233
9731	Điểm hệ số 1 #1	1622	1	\N	2025-05-11 12:12:27.829233
9732	Điểm hệ số 1 #2	1622	1	\N	2025-05-11 12:12:27.829233
9733	Điểm hệ số 1 #3	1622	1	\N	2025-05-11 12:12:27.829233
9734	Điểm hệ số 2 #1	1622	2	\N	2025-05-11 12:12:27.829233
9735	Điểm hệ số 2 #2	1622	2	\N	2025-05-11 12:12:27.829233
9736	Điểm hệ số 3	1622	3	\N	2025-05-11 12:12:27.829233
9737	Điểm hệ số 1 #1	1623	1	\N	2025-05-11 12:12:27.829233
9738	Điểm hệ số 1 #2	1623	1	\N	2025-05-11 12:12:27.829233
9739	Điểm hệ số 1 #3	1623	1	\N	2025-05-11 12:12:27.829233
9740	Điểm hệ số 2 #1	1623	2	\N	2025-05-11 12:12:27.829233
9741	Điểm hệ số 2 #2	1623	2	\N	2025-05-11 12:12:27.829233
9742	Điểm hệ số 3	1623	3	\N	2025-05-11 12:12:27.829233
9743	Điểm hệ số 1 #1	1624	1	\N	2025-05-11 12:12:27.829233
9744	Điểm hệ số 1 #2	1624	1	\N	2025-05-11 12:12:27.829233
9745	Điểm hệ số 1 #3	1624	1	\N	2025-05-11 12:12:27.829233
9746	Điểm hệ số 2 #1	1624	2	\N	2025-05-11 12:12:27.829233
9747	Điểm hệ số 2 #2	1624	2	\N	2025-05-11 12:12:27.829233
9748	Điểm hệ số 3	1624	3	\N	2025-05-11 12:12:27.829233
9749	Điểm hệ số 1 #1	1625	1	\N	2025-05-11 12:12:27.829233
9750	Điểm hệ số 1 #2	1625	1	\N	2025-05-11 12:12:27.829233
9751	Điểm hệ số 1 #3	1625	1	\N	2025-05-11 12:12:27.829233
9752	Điểm hệ số 2 #1	1625	2	\N	2025-05-11 12:12:27.829233
9753	Điểm hệ số 2 #2	1625	2	\N	2025-05-11 12:12:27.829233
9754	Điểm hệ số 3	1625	3	\N	2025-05-11 12:12:27.829233
9755	Điểm hệ số 1 #1	1626	1	\N	2025-05-11 12:12:27.829233
9756	Điểm hệ số 1 #2	1626	1	\N	2025-05-11 12:12:27.829233
9757	Điểm hệ số 1 #3	1626	1	\N	2025-05-11 12:12:27.829233
9758	Điểm hệ số 2 #1	1626	2	\N	2025-05-11 12:12:27.829233
9759	Điểm hệ số 2 #2	1626	2	\N	2025-05-11 12:12:27.829233
9760	Điểm hệ số 3	1626	3	\N	2025-05-11 12:12:27.829233
9761	Điểm hệ số 1 #1	1627	1	\N	2025-05-11 12:12:27.829233
9762	Điểm hệ số 1 #2	1627	1	\N	2025-05-11 12:12:27.829233
9763	Điểm hệ số 1 #3	1627	1	\N	2025-05-11 12:12:27.829233
9764	Điểm hệ số 2 #1	1627	2	\N	2025-05-11 12:12:27.829233
9765	Điểm hệ số 2 #2	1627	2	\N	2025-05-11 12:12:27.83023
9766	Điểm hệ số 3	1627	3	\N	2025-05-11 12:12:27.83023
358	Điểm hệ số 3	59	3	10	2025-05-11 11:52:32.99848
354	Điểm hệ số 1 #2	59	1	8.5	2025-05-11 11:52:32.99848
286	Điểm hệ số 3	47	3	10	2025-05-11 11:52:32.99848
282	Điểm hệ số 1 #2	47	1	9.4	2025-05-11 11:52:32.99848
172	Điểm hệ số 3	28	3	8	2025-05-11 11:52:32.997459
168	Điểm hệ số 1 #2	28	1	8	2025-05-11 11:52:32.997459
241	Điểm hệ số 1 #3	40	1	8	2025-05-11 11:52:32.997459
\.


--
-- TOC entry 5203 (class 0 OID 27717)
-- Dependencies: 254
-- Data for Name: grades; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.grades ("GradeID", "StudentID", "ClassSubjectID", "FinalScore", "Semester", "UpdatedAt") FROM stdin;
28	56	20	8	HK1	2025-05-11 12:44:33.075425
2	17	5	\N	HK1	2025-05-11 10:35:25.226641
3	17	6	\N	HK1	2025-05-11 10:38:05.664447
4	17	7	\N	HK1	2025-05-11 10:52:46.192854
5	17	8	\N	HK1	2025-05-11 10:54:09.974942
6	17	9	\N	HK1	2025-05-11 10:56:50.750269
7	17	10	\N	HK1	2025-05-11 10:57:41.323076
8	17	11	\N	HK1	2025-05-11 10:58:22.321018
9	12	12	\N	HK1	2025-05-11 10:59:07.042077
10	13	12	\N	HK1	2025-05-11 10:59:07.0456
11	17	13	\N	HK1	2025-05-11 10:59:56.778956
12	17	14	\N	HK1	2025-05-11 11:01:20.564109
13	17	15	\N	HK1	2025-05-11 11:02:07.754312
14	17	16	\N	HK1	2025-05-11 11:02:36.397805
15	17	17	\N	HK1	2025-05-11 11:03:24.307487
16	17	18	\N	HK1	2025-05-11 11:05:29.468387
17	17	19	\N	HK1	2025-05-11 11:06:49.132823
118	54	4	\N	Học kỳ 2	2025-05-11 12:11:42.346341
119	55	4	\N	Học kỳ 2	2025-05-11 12:11:42.349332
120	56	4	\N	Học kỳ 2	2025-05-11 12:11:42.352333
121	57	4	\N	Học kỳ 2	2025-05-11 12:11:42.355346
122	12	4	\N	Học kỳ 2	2025-05-11 12:11:42.357342
1	17	4	9.6	HK1	2025-05-11 11:15:05.75674
18	20	20	\N	HK1	2025-05-11 11:52:32.661973
19	21	20	\N	HK1	2025-05-11 11:52:32.667069
20	28	20	\N	HK1	2025-05-11 11:52:32.67176
21	43	20	\N	HK1	2025-05-11 11:52:32.675283
22	44	20	\N	HK1	2025-05-11 11:52:32.678788
23	51	20	\N	HK1	2025-05-11 11:52:32.681787
24	52	20	\N	HK1	2025-05-11 11:52:32.685308
25	53	20	\N	HK1	2025-05-11 11:52:32.688876
26	54	20	\N	HK1	2025-05-11 11:52:32.691872
27	55	20	\N	HK1	2025-05-11 11:52:32.693869
29	57	20	\N	HK1	2025-05-11 11:52:32.700356
30	12	20	\N	HK1	2025-05-11 11:52:32.703367
31	13	20	\N	HK1	2025-05-11 11:52:32.706626
32	14	20	\N	HK1	2025-05-11 11:52:32.710152
33	15	20	\N	HK1	2025-05-11 11:52:32.713152
34	16	20	\N	HK1	2025-05-11 11:52:32.716474
35	19	20	\N	HK1	2025-05-11 11:52:32.719507
36	17	20	\N	HK1	2025-05-11 11:52:32.72249
37	18	20	\N	HK1	2025-05-11 11:52:32.726005
38	22	20	\N	HK1	2025-05-11 11:52:32.729335
39	23	20	\N	HK1	2025-05-11 11:52:32.732337
41	26	20	\N	HK1	2025-05-11 11:52:32.738112
42	24	20	\N	HK1	2025-05-11 11:52:32.741116
43	27	20	\N	HK1	2025-05-11 11:52:32.744113
44	31	20	\N	HK1	2025-05-11 11:52:32.746998
45	32	20	\N	HK1	2025-05-11 11:52:32.750211
46	33	20	\N	HK1	2025-05-11 11:52:32.753431
48	30	20	\N	HK1	2025-05-11 11:52:32.760282
49	29	20	\N	HK1	2025-05-11 11:52:32.763281
50	35	20	\N	HK1	2025-05-11 11:52:32.766456
51	36	20	\N	HK1	2025-05-11 11:52:32.769772
52	37	20	\N	HK1	2025-05-11 11:52:32.77331
53	38	20	\N	HK1	2025-05-11 11:52:32.775824
54	39	20	\N	HK1	2025-05-11 11:52:32.779166
55	40	20	\N	HK1	2025-05-11 11:52:32.782174
56	41	20	\N	HK1	2025-05-11 11:52:32.785662
57	42	20	\N	HK1	2025-05-11 11:52:32.789193
58	45	20	\N	HK1	2025-05-11 11:52:32.792203
60	47	20	\N	HK1	2025-05-11 11:52:32.798478
61	48	20	\N	HK1	2025-05-11 11:52:32.800459
62	50	20	\N	HK1	2025-05-11 11:52:32.80354
63	49	20	\N	HK1	2025-05-11 11:52:32.80726
64	20	4	\N	Học kỳ 1	2025-05-11 12:11:42.112725
65	21	4	\N	Học kỳ 1	2025-05-11 12:11:42.116738
66	28	4	\N	Học kỳ 1	2025-05-11 12:11:42.120861
67	43	4	\N	Học kỳ 1	2025-05-11 12:11:42.124725
68	44	4	\N	Học kỳ 1	2025-05-11 12:11:42.126738
69	51	4	\N	Học kỳ 1	2025-05-11 12:11:42.130727
70	52	4	\N	Học kỳ 1	2025-05-11 12:11:42.133727
71	53	4	\N	Học kỳ 1	2025-05-11 12:11:42.136739
72	54	4	\N	Học kỳ 1	2025-05-11 12:11:42.139789
73	55	4	\N	Học kỳ 1	2025-05-11 12:11:42.142786
74	56	4	\N	Học kỳ 1	2025-05-11 12:11:42.144787
75	57	4	\N	Học kỳ 1	2025-05-11 12:11:42.147788
76	12	4	\N	Học kỳ 1	2025-05-11 12:11:42.151775
77	13	4	\N	Học kỳ 1	2025-05-11 12:11:42.154307
78	14	4	\N	Học kỳ 1	2025-05-11 12:11:42.158338
79	15	4	\N	Học kỳ 1	2025-05-11 12:11:42.16132
80	16	4	\N	Học kỳ 1	2025-05-11 12:11:42.164339
81	19	4	\N	Học kỳ 1	2025-05-11 12:11:42.167339
82	17	4	\N	Học kỳ 1	2025-05-11 12:11:42.169354
83	18	4	\N	Học kỳ 1	2025-05-11 12:11:42.173337
84	22	4	\N	Học kỳ 1	2025-05-11 12:11:42.17534
85	23	4	\N	Học kỳ 1	2025-05-11 12:11:42.178318
86	25	4	\N	Học kỳ 1	2025-05-11 12:11:42.181351
87	26	4	\N	Học kỳ 1	2025-05-11 12:11:42.184352
88	24	4	\N	Học kỳ 1	2025-05-11 12:11:42.187351
89	27	4	\N	Học kỳ 1	2025-05-11 12:11:42.190368
90	31	4	\N	Học kỳ 1	2025-05-11 12:11:42.193387
91	32	4	\N	Học kỳ 1	2025-05-11 12:11:42.196385
92	33	4	\N	Học kỳ 1	2025-05-11 12:11:42.199368
93	34	4	\N	Học kỳ 1	2025-05-11 12:11:42.202367
94	30	4	\N	Học kỳ 1	2025-05-11 12:11:42.205899
95	29	4	\N	Học kỳ 1	2025-05-11 12:11:42.207902
96	35	4	\N	Học kỳ 1	2025-05-11 12:11:42.211896
97	36	4	\N	Học kỳ 1	2025-05-11 12:11:42.214898
98	37	4	\N	Học kỳ 1	2025-05-11 12:11:42.217898
99	38	4	\N	Học kỳ 1	2025-05-11 12:11:42.220899
100	39	4	\N	Học kỳ 1	2025-05-11 12:11:42.223898
101	40	4	\N	Học kỳ 1	2025-05-11 12:11:42.226894
102	41	4	\N	Học kỳ 1	2025-05-11 12:11:42.229897
103	42	4	\N	Học kỳ 1	2025-05-11 12:11:42.232897
104	45	4	\N	Học kỳ 1	2025-05-11 12:11:42.235897
105	46	4	\N	Học kỳ 1	2025-05-11 12:11:42.238898
106	47	4	\N	Học kỳ 1	2025-05-11 12:11:42.241918
107	48	4	\N	Học kỳ 1	2025-05-11 12:11:42.245935
108	50	4	\N	Học kỳ 1	2025-05-11 12:11:42.248936
109	49	4	\N	Học kỳ 1	2025-05-11 12:11:42.250949
110	20	4	\N	Học kỳ 2	2025-05-11 12:11:42.323297
111	21	4	\N	Học kỳ 2	2025-05-11 12:11:42.326299
112	28	4	\N	Học kỳ 2	2025-05-11 12:11:42.329288
113	43	4	\N	Học kỳ 2	2025-05-11 12:11:42.332298
114	44	4	\N	Học kỳ 2	2025-05-11 12:11:42.335299
115	51	4	\N	Học kỳ 2	2025-05-11 12:11:42.338303
116	52	4	\N	Học kỳ 2	2025-05-11 12:11:42.341298
117	53	4	\N	Học kỳ 2	2025-05-11 12:11:42.34434
123	13	4	\N	Học kỳ 2	2025-05-11 12:11:42.360922
124	14	4	\N	Học kỳ 2	2025-05-11 12:11:42.364078
125	15	4	\N	Học kỳ 2	2025-05-11 12:11:42.366939
126	16	4	\N	Học kỳ 2	2025-05-11 12:11:42.369941
127	19	4	\N	Học kỳ 2	2025-05-11 12:11:42.372935
128	17	4	\N	Học kỳ 2	2025-05-11 12:11:42.375936
129	18	4	\N	Học kỳ 2	2025-05-11 12:11:42.378922
130	22	4	\N	Học kỳ 2	2025-05-11 12:11:42.381935
131	23	4	\N	Học kỳ 2	2025-05-11 12:11:42.383935
132	25	4	\N	Học kỳ 2	2025-05-11 12:11:42.386936
133	26	4	\N	Học kỳ 2	2025-05-11 12:11:42.389926
134	24	4	\N	Học kỳ 2	2025-05-11 12:11:42.392936
47	34	20	9.59	HK1	2025-05-11 12:44:25.473892
135	27	4	\N	Học kỳ 2	2025-05-11 12:11:42.395969
136	31	4	\N	Học kỳ 2	2025-05-11 12:11:42.400971
137	32	4	\N	Học kỳ 2	2025-05-11 12:11:42.40298
138	33	4	\N	Học kỳ 2	2025-05-11 12:11:42.405969
139	34	4	\N	Học kỳ 2	2025-05-11 12:11:42.409498
140	30	4	\N	Học kỳ 2	2025-05-11 12:11:42.412533
141	29	4	\N	Học kỳ 2	2025-05-11 12:11:42.416542
142	35	4	\N	Học kỳ 2	2025-05-11 12:11:42.419538
143	36	4	\N	Học kỳ 2	2025-05-11 12:11:42.422537
144	37	4	\N	Học kỳ 2	2025-05-11 12:11:42.425545
145	38	4	\N	Học kỳ 2	2025-05-11 12:11:42.428542
146	39	4	\N	Học kỳ 2	2025-05-11 12:11:42.431546
147	40	4	\N	Học kỳ 2	2025-05-11 12:11:42.434545
148	41	4	\N	Học kỳ 2	2025-05-11 12:11:42.437547
149	42	4	\N	Học kỳ 2	2025-05-11 12:11:42.440544
150	45	4	\N	Học kỳ 2	2025-05-11 12:11:42.442544
151	46	4	\N	Học kỳ 2	2025-05-11 12:11:42.44582
152	47	4	\N	Học kỳ 2	2025-05-11 12:11:42.44882
153	48	4	\N	Học kỳ 2	2025-05-11 12:11:42.45182
154	50	4	\N	Học kỳ 2	2025-05-11 12:11:42.454812
155	49	4	\N	Học kỳ 2	2025-05-11 12:11:42.457819
156	20	5	\N	Học kỳ 1	2025-05-11 12:12:10.820537
157	21	5	\N	Học kỳ 1	2025-05-11 12:12:10.82462
158	28	5	\N	Học kỳ 1	2025-05-11 12:12:10.827621
159	43	5	\N	Học kỳ 1	2025-05-11 12:12:10.831616
160	44	5	\N	Học kỳ 1	2025-05-11 12:12:10.83462
161	51	5	\N	Học kỳ 1	2025-05-11 12:12:10.838618
162	52	5	\N	Học kỳ 1	2025-05-11 12:12:10.841614
163	53	5	\N	Học kỳ 1	2025-05-11 12:12:10.844609
164	54	5	\N	Học kỳ 1	2025-05-11 12:12:10.847613
165	55	5	\N	Học kỳ 1	2025-05-11 12:12:10.851612
166	56	5	\N	Học kỳ 1	2025-05-11 12:12:10.854633
167	57	5	\N	Học kỳ 1	2025-05-11 12:12:10.857615
168	12	5	\N	Học kỳ 1	2025-05-11 12:12:10.861637
169	13	5	\N	Học kỳ 1	2025-05-11 12:12:10.864638
170	14	5	\N	Học kỳ 1	2025-05-11 12:12:10.868634
171	15	5	\N	Học kỳ 1	2025-05-11 12:12:10.871631
172	16	5	\N	Học kỳ 1	2025-05-11 12:12:10.875808
173	19	5	\N	Học kỳ 1	2025-05-11 12:12:10.878819
174	17	5	\N	Học kỳ 1	2025-05-11 12:12:10.882812
175	18	5	\N	Học kỳ 1	2025-05-11 12:12:10.885806
176	22	5	\N	Học kỳ 1	2025-05-11 12:12:10.888823
177	23	5	\N	Học kỳ 1	2025-05-11 12:12:10.891807
178	25	5	\N	Học kỳ 1	2025-05-11 12:12:10.895808
179	26	5	\N	Học kỳ 1	2025-05-11 12:12:10.898818
180	24	5	\N	Học kỳ 1	2025-05-11 12:12:10.902808
181	27	5	\N	Học kỳ 1	2025-05-11 12:12:10.905817
182	31	5	\N	Học kỳ 1	2025-05-11 12:12:10.908822
183	32	5	\N	Học kỳ 1	2025-05-11 12:12:10.912843
184	33	5	\N	Học kỳ 1	2025-05-11 12:12:10.915846
185	34	5	\N	Học kỳ 1	2025-05-11 12:12:10.919836
186	30	5	\N	Học kỳ 1	2025-05-11 12:12:10.922834
187	29	5	\N	Học kỳ 1	2025-05-11 12:12:10.926376
188	35	5	\N	Học kỳ 1	2025-05-11 12:12:10.929385
189	36	5	\N	Học kỳ 1	2025-05-11 12:12:10.933376
190	37	5	\N	Học kỳ 1	2025-05-11 12:12:10.936365
191	38	5	\N	Học kỳ 1	2025-05-11 12:12:10.939379
192	39	5	\N	Học kỳ 1	2025-05-11 12:12:10.942368
193	40	5	\N	Học kỳ 1	2025-05-11 12:12:10.946367
194	41	5	\N	Học kỳ 1	2025-05-11 12:12:10.94938
195	42	5	\N	Học kỳ 1	2025-05-11 12:12:10.953365
196	45	5	\N	Học kỳ 1	2025-05-11 12:12:10.956373
197	46	5	\N	Học kỳ 1	2025-05-11 12:12:10.959375
198	47	5	\N	Học kỳ 1	2025-05-11 12:12:10.962391
199	48	5	\N	Học kỳ 1	2025-05-11 12:12:10.966393
200	50	5	\N	Học kỳ 1	2025-05-11 12:12:10.969383
201	49	5	\N	Học kỳ 1	2025-05-11 12:12:10.9724
202	20	5	\N	Học kỳ 2	2025-05-11 12:12:11.038833
203	21	5	\N	Học kỳ 2	2025-05-11 12:12:11.042543
204	28	5	\N	Học kỳ 2	2025-05-11 12:12:11.045535
205	43	5	\N	Học kỳ 2	2025-05-11 12:12:11.048549
206	44	5	\N	Học kỳ 2	2025-05-11 12:12:11.05255
207	51	5	\N	Học kỳ 2	2025-05-11 12:12:11.05555
208	52	5	\N	Học kỳ 2	2025-05-11 12:12:11.058565
209	53	5	\N	Học kỳ 2	2025-05-11 12:12:11.061588
210	54	5	\N	Học kỳ 2	2025-05-11 12:12:11.065584
211	55	5	\N	Học kỳ 2	2025-05-11 12:12:11.06858
212	56	5	\N	Học kỳ 2	2025-05-11 12:12:11.07159
213	57	5	\N	Học kỳ 2	2025-05-11 12:12:11.074582
214	12	5	\N	Học kỳ 2	2025-05-11 12:12:11.07782
215	13	5	\N	Học kỳ 2	2025-05-11 12:12:11.081815
216	14	5	\N	Học kỳ 2	2025-05-11 12:12:11.08479
217	15	5	\N	Học kỳ 2	2025-05-11 12:12:11.086818
218	16	5	\N	Học kỳ 2	2025-05-11 12:12:11.09081
219	19	5	\N	Học kỳ 2	2025-05-11 12:12:11.093823
220	17	5	\N	Học kỳ 2	2025-05-11 12:12:11.09582
221	18	5	\N	Học kỳ 2	2025-05-11 12:12:11.098821
222	22	5	\N	Học kỳ 2	2025-05-11 12:12:11.101809
223	23	5	\N	Học kỳ 2	2025-05-11 12:12:11.104818
224	25	5	\N	Học kỳ 2	2025-05-11 12:12:11.107812
225	26	5	\N	Học kỳ 2	2025-05-11 12:12:11.11082
226	24	5	\N	Học kỳ 2	2025-05-11 12:12:11.113853
227	27	5	\N	Học kỳ 2	2025-05-11 12:12:11.11685
228	31	5	\N	Học kỳ 2	2025-05-11 12:12:11.11986
229	32	5	\N	Học kỳ 2	2025-05-11 12:12:11.123856
230	33	5	\N	Học kỳ 2	2025-05-11 12:12:11.127422
231	34	5	\N	Học kỳ 2	2025-05-11 12:12:11.130422
232	30	5	\N	Học kỳ 2	2025-05-11 12:12:11.133422
233	29	5	\N	Học kỳ 2	2025-05-11 12:12:11.136431
234	35	5	\N	Học kỳ 2	2025-05-11 12:12:11.139426
235	36	5	\N	Học kỳ 2	2025-05-11 12:12:11.143429
236	37	5	\N	Học kỳ 2	2025-05-11 12:12:11.146436
237	38	5	\N	Học kỳ 2	2025-05-11 12:12:11.148437
238	39	5	\N	Học kỳ 2	2025-05-11 12:12:11.151435
239	40	5	\N	Học kỳ 2	2025-05-11 12:12:11.154437
240	41	5	\N	Học kỳ 2	2025-05-11 12:12:11.157414
241	42	5	\N	Học kỳ 2	2025-05-11 12:12:11.159436
242	45	5	\N	Học kỳ 2	2025-05-11 12:12:11.163635
243	46	5	\N	Học kỳ 2	2025-05-11 12:12:11.166635
244	47	5	\N	Học kỳ 2	2025-05-11 12:12:11.169647
245	48	5	\N	Học kỳ 2	2025-05-11 12:12:11.172631
246	50	5	\N	Học kỳ 2	2025-05-11 12:12:11.176203
247	49	5	\N	Học kỳ 2	2025-05-11 12:12:11.179238
248	20	6	\N	Học kỳ 1	2025-05-11 12:12:11.668697
249	21	6	\N	Học kỳ 1	2025-05-11 12:12:11.672686
250	28	6	\N	Học kỳ 1	2025-05-11 12:12:11.67669
251	43	6	\N	Học kỳ 1	2025-05-11 12:12:11.679712
252	44	6	\N	Học kỳ 1	2025-05-11 12:12:11.683702
253	51	6	\N	Học kỳ 1	2025-05-11 12:12:11.687711
254	52	6	\N	Học kỳ 1	2025-05-11 12:12:11.690684
255	53	6	\N	Học kỳ 1	2025-05-11 12:12:11.694699
256	54	6	\N	Học kỳ 1	2025-05-11 12:12:11.697703
257	55	6	\N	Học kỳ 1	2025-05-11 12:12:11.701689
258	56	6	\N	Học kỳ 1	2025-05-11 12:12:11.704696
259	57	6	\N	Học kỳ 1	2025-05-11 12:12:11.707688
260	12	6	\N	Học kỳ 1	2025-05-11 12:12:11.711703
261	13	6	\N	Học kỳ 1	2025-05-11 12:12:11.714681
262	14	6	\N	Học kỳ 1	2025-05-11 12:12:11.718683
263	15	6	\N	Học kỳ 1	2025-05-11 12:12:11.721685
264	16	6	\N	Học kỳ 1	2025-05-11 12:12:11.725694
265	19	6	\N	Học kỳ 1	2025-05-11 12:12:11.729691
266	17	6	\N	Học kỳ 1	2025-05-11 12:12:11.733686
267	18	6	\N	Học kỳ 1	2025-05-11 12:12:11.737688
268	22	6	\N	Học kỳ 1	2025-05-11 12:12:11.74268
269	23	6	\N	Học kỳ 1	2025-05-11 12:12:11.746684
270	25	6	\N	Học kỳ 1	2025-05-11 12:12:11.749678
271	26	6	\N	Học kỳ 1	2025-05-11 12:12:11.752702
272	24	6	\N	Học kỳ 1	2025-05-11 12:12:11.756703
273	27	6	\N	Học kỳ 1	2025-05-11 12:12:11.759713
274	31	6	\N	Học kỳ 1	2025-05-11 12:12:11.763704
275	32	6	\N	Học kỳ 1	2025-05-11 12:12:11.766711
276	33	6	\N	Học kỳ 1	2025-05-11 12:12:11.770714
277	34	6	\N	Học kỳ 1	2025-05-11 12:12:11.773697
278	30	6	\N	Học kỳ 1	2025-05-11 12:12:11.7777
279	29	6	\N	Học kỳ 1	2025-05-11 12:12:11.781696
280	35	6	\N	Học kỳ 1	2025-05-11 12:12:11.785704
281	36	6	\N	Học kỳ 1	2025-05-11 12:12:11.789701
282	37	6	\N	Học kỳ 1	2025-05-11 12:12:11.792709
283	38	6	\N	Học kỳ 1	2025-05-11 12:12:11.796711
284	39	6	\N	Học kỳ 1	2025-05-11 12:12:11.800711
285	40	6	\N	Học kỳ 1	2025-05-11 12:12:11.803709
286	41	6	\N	Học kỳ 1	2025-05-11 12:12:11.806701
287	42	6	\N	Học kỳ 1	2025-05-11 12:12:11.810704
288	45	6	\N	Học kỳ 1	2025-05-11 12:12:11.8147
289	46	6	\N	Học kỳ 1	2025-05-11 12:12:11.817701
290	47	6	\N	Học kỳ 1	2025-05-11 12:12:11.821712
291	48	6	\N	Học kỳ 1	2025-05-11 12:12:11.824713
292	50	6	\N	Học kỳ 1	2025-05-11 12:12:11.828744
293	49	6	\N	Học kỳ 1	2025-05-11 12:12:11.832745
294	20	6	\N	Học kỳ 2	2025-05-11 12:12:11.915876
295	21	6	\N	Học kỳ 2	2025-05-11 12:12:11.920878
296	28	6	\N	Học kỳ 2	2025-05-11 12:12:11.924872
297	43	6	\N	Học kỳ 2	2025-05-11 12:12:11.927871
298	44	6	\N	Học kỳ 2	2025-05-11 12:12:11.931891
299	51	6	\N	Học kỳ 2	2025-05-11 12:12:11.935891
300	52	6	\N	Học kỳ 2	2025-05-11 12:12:11.939892
301	53	6	\N	Học kỳ 2	2025-05-11 12:12:11.943895
302	54	6	\N	Học kỳ 2	2025-05-11 12:12:11.94843
303	55	6	\N	Học kỳ 2	2025-05-11 12:12:11.951419
304	56	6	\N	Học kỳ 2	2025-05-11 12:12:11.955428
305	57	6	\N	Học kỳ 2	2025-05-11 12:12:11.959431
306	12	6	\N	Học kỳ 2	2025-05-11 12:12:11.963433
307	13	6	\N	Học kỳ 2	2025-05-11 12:12:11.967431
308	14	6	\N	Học kỳ 2	2025-05-11 12:12:11.971433
309	15	6	\N	Học kỳ 2	2025-05-11 12:12:11.974429
310	16	6	\N	Học kỳ 2	2025-05-11 12:12:11.977421
311	19	6	\N	Học kỳ 2	2025-05-11 12:12:11.981446
312	17	6	\N	Học kỳ 2	2025-05-11 12:12:11.985454
313	18	6	\N	Học kỳ 2	2025-05-11 12:12:11.989442
314	22	6	\N	Học kỳ 2	2025-05-11 12:12:11.992446
315	23	6	\N	Học kỳ 2	2025-05-11 12:12:11.995967
316	25	6	\N	Học kỳ 2	2025-05-11 12:12:11.999992
317	26	6	\N	Học kỳ 2	2025-05-11 12:12:12.003999
318	24	6	\N	Học kỳ 2	2025-05-11 12:12:12.006983
319	27	6	\N	Học kỳ 2	2025-05-11 12:12:12.009986
320	31	6	\N	Học kỳ 2	2025-05-11 12:12:12.012989
321	32	6	\N	Học kỳ 2	2025-05-11 12:12:12.016987
322	33	6	\N	Học kỳ 2	2025-05-11 12:12:12.020989
323	34	6	\N	Học kỳ 2	2025-05-11 12:12:12.024986
324	30	6	\N	Học kỳ 2	2025-05-11 12:12:12.027982
325	29	6	\N	Học kỳ 2	2025-05-11 12:12:12.033004
326	35	6	\N	Học kỳ 2	2025-05-11 12:12:12.037001
327	36	6	\N	Học kỳ 2	2025-05-11 12:12:12.042005
328	37	6	\N	Học kỳ 2	2025-05-11 12:12:12.046522
329	38	6	\N	Học kỳ 2	2025-05-11 12:12:12.051543
330	39	6	\N	Học kỳ 2	2025-05-11 12:12:12.056539
331	40	6	\N	Học kỳ 2	2025-05-11 12:12:12.060536
332	41	6	\N	Học kỳ 2	2025-05-11 12:12:12.065541
333	42	6	\N	Học kỳ 2	2025-05-11 12:12:12.069553
334	45	6	\N	Học kỳ 2	2025-05-11 12:12:12.073543
335	46	6	\N	Học kỳ 2	2025-05-11 12:12:12.078544
336	47	6	\N	Học kỳ 2	2025-05-11 12:12:12.082561
337	48	6	\N	Học kỳ 2	2025-05-11 12:12:12.087567
338	50	6	\N	Học kỳ 2	2025-05-11 12:12:12.092566
339	49	6	\N	Học kỳ 2	2025-05-11 12:12:12.098101
340	20	7	\N	Học kỳ 1	2025-05-11 12:12:12.92879
341	21	7	\N	Học kỳ 1	2025-05-11 12:12:12.933324
342	28	7	\N	Học kỳ 1	2025-05-11 12:12:12.935367
343	43	7	\N	Học kỳ 1	2025-05-11 12:12:12.938366
344	44	7	\N	Học kỳ 1	2025-05-11 12:12:12.942338
345	51	7	\N	Học kỳ 1	2025-05-11 12:12:12.94536
346	52	7	\N	Học kỳ 1	2025-05-11 12:12:12.948373
347	53	7	\N	Học kỳ 1	2025-05-11 12:12:12.951367
348	54	7	\N	Học kỳ 1	2025-05-11 12:12:12.95437
349	55	7	\N	Học kỳ 1	2025-05-11 12:12:12.958358
350	56	7	\N	Học kỳ 1	2025-05-11 12:12:12.961355
351	57	7	\N	Học kỳ 1	2025-05-11 12:12:12.964339
352	12	7	\N	Học kỳ 1	2025-05-11 12:12:12.968404
353	13	7	\N	Học kỳ 1	2025-05-11 12:12:12.972395
354	14	7	\N	Học kỳ 1	2025-05-11 12:12:12.97639
355	15	7	\N	Học kỳ 1	2025-05-11 12:12:12.979374
356	16	7	\N	Học kỳ 1	2025-05-11 12:12:12.983398
357	19	7	\N	Học kỳ 1	2025-05-11 12:12:12.988751
358	17	7	\N	Học kỳ 1	2025-05-11 12:12:12.991748
359	18	7	\N	Học kỳ 1	2025-05-11 12:12:12.995739
360	22	7	\N	Học kỳ 1	2025-05-11 12:12:13.000741
361	23	7	\N	Học kỳ 1	2025-05-11 12:12:13.004735
362	25	7	\N	Học kỳ 1	2025-05-11 12:12:13.008755
363	26	7	\N	Học kỳ 1	2025-05-11 12:12:13.013735
364	24	7	\N	Học kỳ 1	2025-05-11 12:12:13.017751
365	27	7	\N	Học kỳ 1	2025-05-11 12:12:13.021752
366	31	7	\N	Học kỳ 1	2025-05-11 12:12:13.026753
367	32	7	\N	Học kỳ 1	2025-05-11 12:12:13.030761
368	33	7	\N	Học kỳ 1	2025-05-11 12:12:13.036326
369	34	7	\N	Học kỳ 1	2025-05-11 12:12:13.040315
370	30	7	\N	Học kỳ 1	2025-05-11 12:12:13.044333
371	29	7	\N	Học kỳ 1	2025-05-11 12:12:13.048321
372	35	7	\N	Học kỳ 1	2025-05-11 12:12:13.053335
373	36	7	\N	Học kỳ 1	2025-05-11 12:12:13.057327
374	37	7	\N	Học kỳ 1	2025-05-11 12:12:13.06133
375	38	7	\N	Học kỳ 1	2025-05-11 12:12:13.066312
376	39	7	\N	Học kỳ 1	2025-05-11 12:12:13.071328
377	40	7	\N	Học kỳ 1	2025-05-11 12:12:13.076335
378	41	7	\N	Học kỳ 1	2025-05-11 12:12:13.080318
379	42	7	\N	Học kỳ 1	2025-05-11 12:12:13.084318
380	45	7	\N	Học kỳ 1	2025-05-11 12:12:13.089387
381	46	7	\N	Học kỳ 1	2025-05-11 12:12:13.09341
382	47	7	\N	Học kỳ 1	2025-05-11 12:12:13.097412
383	48	7	\N	Học kỳ 1	2025-05-11 12:12:13.102409
384	50	7	\N	Học kỳ 1	2025-05-11 12:12:13.10642
385	49	7	\N	Học kỳ 1	2025-05-11 12:12:13.11042
386	20	7	\N	Học kỳ 2	2025-05-11 12:12:13.207247
387	21	7	\N	Học kỳ 2	2025-05-11 12:12:13.211247
388	28	7	\N	Học kỳ 2	2025-05-11 12:12:13.216236
389	43	7	\N	Học kỳ 2	2025-05-11 12:12:13.219256
390	44	7	\N	Học kỳ 2	2025-05-11 12:12:13.224282
391	51	7	\N	Học kỳ 2	2025-05-11 12:12:13.228297
392	52	7	\N	Học kỳ 2	2025-05-11 12:12:13.233294
393	53	7	\N	Học kỳ 2	2025-05-11 12:12:13.237843
394	54	7	\N	Học kỳ 2	2025-05-11 12:12:13.241844
395	55	7	\N	Học kỳ 2	2025-05-11 12:12:13.246843
396	56	7	\N	Học kỳ 2	2025-05-11 12:12:13.250837
397	57	7	\N	Học kỳ 2	2025-05-11 12:12:13.254849
398	12	7	\N	Học kỳ 2	2025-05-11 12:12:13.258841
399	13	7	\N	Học kỳ 2	2025-05-11 12:12:13.262841
400	14	7	\N	Học kỳ 2	2025-05-11 12:12:13.267836
401	15	7	\N	Học kỳ 2	2025-05-11 12:12:13.271866
402	16	7	\N	Học kỳ 2	2025-05-11 12:12:13.276874
403	19	7	\N	Học kỳ 2	2025-05-11 12:12:13.280858
404	17	7	\N	Học kỳ 2	2025-05-11 12:12:13.285378
405	18	7	\N	Học kỳ 2	2025-05-11 12:12:13.289389
406	22	7	\N	Học kỳ 2	2025-05-11 12:12:13.293393
407	23	7	\N	Học kỳ 2	2025-05-11 12:12:13.297391
408	25	7	\N	Học kỳ 2	2025-05-11 12:12:13.302387
409	26	7	\N	Học kỳ 2	2025-05-11 12:12:13.308411
410	24	7	\N	Học kỳ 2	2025-05-11 12:12:13.312409
411	27	7	\N	Học kỳ 2	2025-05-11 12:12:13.316395
412	31	7	\N	Học kỳ 2	2025-05-11 12:12:13.320423
413	32	7	\N	Học kỳ 2	2025-05-11 12:12:13.325454
414	33	7	\N	Học kỳ 2	2025-05-11 12:12:13.32946
415	34	7	\N	Học kỳ 2	2025-05-11 12:12:13.333433
416	30	7	\N	Học kỳ 2	2025-05-11 12:12:13.33798
417	29	7	\N	Học kỳ 2	2025-05-11 12:12:13.343002
418	35	7	\N	Học kỳ 2	2025-05-11 12:12:13.347014
419	36	7	\N	Học kỳ 2	2025-05-11 12:12:13.350986
420	37	7	\N	Học kỳ 2	2025-05-11 12:12:13.356
421	38	7	\N	Học kỳ 2	2025-05-11 12:12:13.359982
422	39	7	\N	Học kỳ 2	2025-05-11 12:12:13.365005
423	40	7	\N	Học kỳ 2	2025-05-11 12:12:13.369985
424	41	7	\N	Học kỳ 2	2025-05-11 12:12:13.374006
425	42	7	\N	Học kỳ 2	2025-05-11 12:12:13.378008
426	45	7	\N	Học kỳ 2	2025-05-11 12:12:13.383
427	46	7	\N	Học kỳ 2	2025-05-11 12:12:13.386515
428	47	7	\N	Học kỳ 2	2025-05-11 12:12:13.390559
429	48	7	\N	Học kỳ 2	2025-05-11 12:12:13.395534
430	50	7	\N	Học kỳ 2	2025-05-11 12:12:13.399534
431	49	7	\N	Học kỳ 2	2025-05-11 12:12:13.404534
432	20	8	\N	Học kỳ 1	2025-05-11 12:12:14.087376
433	21	8	\N	Học kỳ 1	2025-05-11 12:12:14.090875
434	28	8	\N	Học kỳ 1	2025-05-11 12:12:14.094885
435	43	8	\N	Học kỳ 1	2025-05-11 12:12:14.097885
436	44	8	\N	Học kỳ 1	2025-05-11 12:12:14.101894
437	51	8	\N	Học kỳ 1	2025-05-11 12:12:14.10489
438	52	8	\N	Học kỳ 1	2025-05-11 12:12:14.108918
439	53	8	\N	Học kỳ 1	2025-05-11 12:12:14.111907
440	54	8	\N	Học kỳ 1	2025-05-11 12:12:14.11591
441	55	8	\N	Học kỳ 1	2025-05-11 12:12:14.118922
442	56	8	\N	Học kỳ 1	2025-05-11 12:12:14.121922
443	57	8	\N	Học kỳ 1	2025-05-11 12:12:14.123923
444	12	8	\N	Học kỳ 1	2025-05-11 12:12:14.127938
445	13	8	\N	Học kỳ 1	2025-05-11 12:12:14.130945
446	14	8	\N	Học kỳ 1	2025-05-11 12:12:14.133944
447	15	8	\N	Học kỳ 1	2025-05-11 12:12:14.136945
448	16	8	\N	Học kỳ 1	2025-05-11 12:12:14.139936
449	19	8	\N	Học kỳ 1	2025-05-11 12:12:14.144479
450	17	8	\N	Học kỳ 1	2025-05-11 12:12:14.148492
451	18	8	\N	Học kỳ 1	2025-05-11 12:12:14.151492
452	22	8	\N	Học kỳ 1	2025-05-11 12:12:14.154502
453	23	8	\N	Học kỳ 1	2025-05-11 12:12:14.157502
454	25	8	\N	Học kỳ 1	2025-05-11 12:12:14.160494
455	26	8	\N	Học kỳ 1	2025-05-11 12:12:14.163502
456	24	8	\N	Học kỳ 1	2025-05-11 12:12:14.166502
457	27	8	\N	Học kỳ 1	2025-05-11 12:12:14.169502
458	31	8	\N	Học kỳ 1	2025-05-11 12:12:14.171502
459	32	8	\N	Học kỳ 1	2025-05-11 12:12:14.174502
460	33	8	\N	Học kỳ 1	2025-05-11 12:12:14.178514
461	34	8	\N	Học kỳ 1	2025-05-11 12:12:14.181494
462	30	8	\N	Học kỳ 1	2025-05-11 12:12:14.183511
463	29	8	\N	Học kỳ 1	2025-05-11 12:12:14.186521
464	35	8	\N	Học kỳ 1	2025-05-11 12:12:14.189521
465	36	8	\N	Học kỳ 1	2025-05-11 12:12:14.193081
466	37	8	\N	Học kỳ 1	2025-05-11 12:12:14.197082
467	38	8	\N	Học kỳ 1	2025-05-11 12:12:14.199076
468	39	8	\N	Học kỳ 1	2025-05-11 12:12:14.202079
469	40	8	\N	Học kỳ 1	2025-05-11 12:12:14.205082
470	41	8	\N	Học kỳ 1	2025-05-11 12:12:14.208091
471	42	8	\N	Học kỳ 1	2025-05-11 12:12:14.211083
472	45	8	\N	Học kỳ 1	2025-05-11 12:12:14.214081
473	46	8	\N	Học kỳ 1	2025-05-11 12:12:14.217082
474	47	8	\N	Học kỳ 1	2025-05-11 12:12:14.220083
475	48	8	\N	Học kỳ 1	2025-05-11 12:12:14.222076
476	50	8	\N	Học kỳ 1	2025-05-11 12:12:14.225077
477	49	8	\N	Học kỳ 1	2025-05-11 12:12:14.228097
478	20	8	\N	Học kỳ 2	2025-05-11 12:12:14.293237
479	21	8	\N	Học kỳ 2	2025-05-11 12:12:14.296258
480	28	8	\N	Học kỳ 2	2025-05-11 12:12:14.299259
481	43	8	\N	Học kỳ 2	2025-05-11 12:12:14.302257
482	44	8	\N	Học kỳ 2	2025-05-11 12:12:14.304251
483	51	8	\N	Học kỳ 2	2025-05-11 12:12:14.307252
484	52	8	\N	Học kỳ 2	2025-05-11 12:12:14.310256
485	53	8	\N	Học kỳ 2	2025-05-11 12:12:14.313252
486	54	8	\N	Học kỳ 2	2025-05-11 12:12:14.316264
487	55	8	\N	Học kỳ 2	2025-05-11 12:12:14.319256
488	56	8	\N	Học kỳ 2	2025-05-11 12:12:14.322258
489	57	8	\N	Học kỳ 2	2025-05-11 12:12:14.325259
490	12	8	\N	Học kỳ 2	2025-05-11 12:12:14.328258
491	13	8	\N	Học kỳ 2	2025-05-11 12:12:14.331278
492	14	8	\N	Học kỳ 2	2025-05-11 12:12:14.335305
493	15	8	\N	Học kỳ 2	2025-05-11 12:12:14.3383
494	16	8	\N	Học kỳ 2	2025-05-11 12:12:14.341787
495	19	8	\N	Học kỳ 2	2025-05-11 12:12:14.344851
496	17	8	\N	Học kỳ 2	2025-05-11 12:12:14.348854
497	18	8	\N	Học kỳ 2	2025-05-11 12:12:14.351865
498	22	8	\N	Học kỳ 2	2025-05-11 12:12:14.354867
499	23	8	\N	Học kỳ 2	2025-05-11 12:12:14.357841
500	25	8	\N	Học kỳ 2	2025-05-11 12:12:14.360836
501	26	8	\N	Học kỳ 2	2025-05-11 12:12:14.364853
502	24	8	\N	Học kỳ 2	2025-05-11 12:12:14.367855
503	27	8	\N	Học kỳ 2	2025-05-11 12:12:14.370866
504	31	8	\N	Học kỳ 2	2025-05-11 12:12:14.373866
505	32	8	\N	Học kỳ 2	2025-05-11 12:12:14.377848
506	33	8	\N	Học kỳ 2	2025-05-11 12:12:14.380869
507	34	8	\N	Học kỳ 2	2025-05-11 12:12:14.38488
508	30	8	\N	Học kỳ 2	2025-05-11 12:12:14.38888
509	29	8	\N	Học kỳ 2	2025-05-11 12:12:14.391878
510	35	8	\N	Học kỳ 2	2025-05-11 12:12:14.395422
511	36	8	\N	Học kỳ 2	2025-05-11 12:12:14.399433
512	37	8	\N	Học kỳ 2	2025-05-11 12:12:14.402445
513	38	8	\N	Học kỳ 2	2025-05-11 12:12:14.405436
514	39	8	\N	Học kỳ 2	2025-05-11 12:12:14.408432
515	40	8	\N	Học kỳ 2	2025-05-11 12:12:14.412416
516	41	8	\N	Học kỳ 2	2025-05-11 12:12:14.416433
517	42	8	\N	Học kỳ 2	2025-05-11 12:12:14.420436
518	45	8	\N	Học kỳ 2	2025-05-11 12:12:14.423423
519	46	8	\N	Học kỳ 2	2025-05-11 12:12:14.427438
520	47	8	\N	Học kỳ 2	2025-05-11 12:12:14.430483
521	48	8	\N	Học kỳ 2	2025-05-11 12:12:14.43347
522	50	8	\N	Học kỳ 2	2025-05-11 12:12:14.436485
523	49	8	\N	Học kỳ 2	2025-05-11 12:12:14.439481
524	20	9	\N	Học kỳ 1	2025-05-11 12:12:15.102523
525	21	9	\N	Học kỳ 1	2025-05-11 12:12:15.106512
526	28	9	\N	Học kỳ 1	2025-05-11 12:12:15.110524
527	43	9	\N	Học kỳ 1	2025-05-11 12:12:15.114516
528	44	9	\N	Học kỳ 1	2025-05-11 12:12:15.117511
529	51	9	\N	Học kỳ 1	2025-05-11 12:12:15.121516
530	52	9	\N	Học kỳ 1	2025-05-11 12:12:15.124534
531	53	9	\N	Học kỳ 1	2025-05-11 12:12:15.129525
532	54	9	\N	Học kỳ 1	2025-05-11 12:12:15.133512
533	55	9	\N	Học kỳ 1	2025-05-11 12:12:15.137527
534	56	9	\N	Học kỳ 1	2025-05-11 12:12:15.14153
535	57	9	\N	Học kỳ 1	2025-05-11 12:12:15.146535
536	12	9	\N	Học kỳ 1	2025-05-11 12:12:15.15053
537	13	9	\N	Học kỳ 1	2025-05-11 12:12:15.155088
538	14	9	\N	Học kỳ 1	2025-05-11 12:12:15.15909
539	15	9	\N	Học kỳ 1	2025-05-11 12:12:15.164116
540	16	9	\N	Học kỳ 1	2025-05-11 12:12:15.1681
541	19	9	\N	Học kỳ 1	2025-05-11 12:12:15.171104
542	17	9	\N	Học kỳ 1	2025-05-11 12:12:15.174115
543	18	9	\N	Học kỳ 1	2025-05-11 12:12:15.179091
544	22	9	\N	Học kỳ 1	2025-05-11 12:12:15.183084
545	23	9	\N	Học kỳ 1	2025-05-11 12:12:15.186103
546	25	9	\N	Học kỳ 1	2025-05-11 12:12:15.188152
547	26	9	\N	Học kỳ 1	2025-05-11 12:12:15.191152
548	24	9	\N	Học kỳ 1	2025-05-11 12:12:15.196131
549	27	9	\N	Học kỳ 1	2025-05-11 12:12:15.199142
550	31	9	\N	Học kỳ 1	2025-05-11 12:12:15.20269
551	32	9	\N	Học kỳ 1	2025-05-11 12:12:15.205732
552	33	9	\N	Học kỳ 1	2025-05-11 12:12:15.208704
553	34	9	\N	Học kỳ 1	2025-05-11 12:12:15.212724
554	30	9	\N	Học kỳ 1	2025-05-11 12:12:15.216722
555	29	9	\N	Học kỳ 1	2025-05-11 12:12:15.219732
556	35	9	\N	Học kỳ 1	2025-05-11 12:12:15.221732
557	36	9	\N	Học kỳ 1	2025-05-11 12:12:15.224723
558	37	9	\N	Học kỳ 1	2025-05-11 12:12:15.229725
559	38	9	\N	Học kỳ 1	2025-05-11 12:12:15.232726
560	39	9	\N	Học kỳ 1	2025-05-11 12:12:15.235738
561	40	9	\N	Học kỳ 1	2025-05-11 12:12:15.237737
562	41	9	\N	Học kỳ 1	2025-05-11 12:12:15.242454
563	42	9	\N	Học kỳ 1	2025-05-11 12:12:15.246148
564	45	9	\N	Học kỳ 1	2025-05-11 12:12:15.249163
565	46	9	\N	Học kỳ 1	2025-05-11 12:12:15.252161
566	47	9	\N	Học kỳ 1	2025-05-11 12:12:15.255702
567	48	9	\N	Học kỳ 1	2025-05-11 12:12:15.258686
568	50	9	\N	Học kỳ 1	2025-05-11 12:12:15.263685
569	49	9	\N	Học kỳ 1	2025-05-11 12:12:15.267685
570	20	9	\N	Học kỳ 2	2025-05-11 12:12:15.351368
571	21	9	\N	Học kỳ 2	2025-05-11 12:12:15.35387
572	28	9	\N	Học kỳ 2	2025-05-11 12:12:15.357911
573	43	9	\N	Học kỳ 2	2025-05-11 12:12:15.36291
574	44	9	\N	Học kỳ 2	2025-05-11 12:12:15.365913
575	51	9	\N	Học kỳ 2	2025-05-11 12:12:15.369902
576	52	9	\N	Học kỳ 2	2025-05-11 12:12:15.373913
577	53	9	\N	Học kỳ 2	2025-05-11 12:12:15.378908
578	54	9	\N	Học kỳ 2	2025-05-11 12:12:15.382903
579	55	9	\N	Học kỳ 2	2025-05-11 12:12:15.385917
580	56	9	\N	Học kỳ 2	2025-05-11 12:12:15.388915
581	57	9	\N	Học kỳ 2	2025-05-11 12:12:15.39096
582	12	9	\N	Học kỳ 2	2025-05-11 12:12:15.395945
583	13	9	\N	Học kỳ 2	2025-05-11 12:12:15.398945
584	14	9	\N	Học kỳ 2	2025-05-11 12:12:15.401956
585	15	9	\N	Học kỳ 2	2025-05-11 12:12:15.404468
586	16	9	\N	Học kỳ 2	2025-05-11 12:12:15.407508
587	19	9	\N	Học kỳ 2	2025-05-11 12:12:15.411501
588	17	9	\N	Học kỳ 2	2025-05-11 12:12:15.414499
589	18	9	\N	Học kỳ 2	2025-05-11 12:12:15.41751
590	22	9	\N	Học kỳ 2	2025-05-11 12:12:15.420508
591	23	9	\N	Học kỳ 2	2025-05-11 12:12:15.422508
592	25	9	\N	Học kỳ 2	2025-05-11 12:12:15.425838
593	26	9	\N	Học kỳ 2	2025-05-11 12:12:15.429504
594	24	9	\N	Học kỳ 2	2025-05-11 12:12:15.432502
595	27	9	\N	Học kỳ 2	2025-05-11 12:12:15.435513
596	31	9	\N	Học kỳ 2	2025-05-11 12:12:15.438514
597	32	9	\N	Học kỳ 2	2025-05-11 12:12:15.441558
598	33	9	\N	Học kỳ 2	2025-05-11 12:12:15.444536
599	34	9	\N	Học kỳ 2	2025-05-11 12:12:15.448548
600	30	9	\N	Học kỳ 2	2025-05-11 12:12:15.451558
601	29	9	\N	Học kỳ 2	2025-05-11 12:12:15.454106
602	35	9	\N	Học kỳ 2	2025-05-11 12:12:15.457155
603	36	9	\N	Học kỳ 2	2025-05-11 12:12:15.462126
604	37	9	\N	Học kỳ 2	2025-05-11 12:12:15.465155
605	38	9	\N	Học kỳ 2	2025-05-11 12:12:15.468154
606	39	9	\N	Học kỳ 2	2025-05-11 12:12:15.471154
607	40	9	\N	Học kỳ 2	2025-05-11 12:12:15.474153
608	41	9	\N	Học kỳ 2	2025-05-11 12:12:15.478127
609	42	9	\N	Học kỳ 2	2025-05-11 12:12:15.482144
610	45	9	\N	Học kỳ 2	2025-05-11 12:12:15.485155
611	46	9	\N	Học kỳ 2	2025-05-11 12:12:15.488154
612	47	9	\N	Học kỳ 2	2025-05-11 12:12:15.49119
613	48	9	\N	Học kỳ 2	2025-05-11 12:12:15.495173
614	50	9	\N	Học kỳ 2	2025-05-11 12:12:15.499188
615	49	9	\N	Học kỳ 2	2025-05-11 12:12:15.502197
616	20	10	\N	Học kỳ 1	2025-05-11 12:12:16.151566
617	21	10	\N	Học kỳ 1	2025-05-11 12:12:16.154565
618	28	10	\N	Học kỳ 1	2025-05-11 12:12:16.157566
619	43	10	\N	Học kỳ 1	2025-05-11 12:12:16.160588
620	44	10	\N	Học kỳ 1	2025-05-11 12:12:16.165135
621	51	10	\N	Học kỳ 1	2025-05-11 12:12:16.167144
622	52	10	\N	Học kỳ 1	2025-05-11 12:12:16.170144
623	53	10	\N	Học kỳ 1	2025-05-11 12:12:16.173144
624	54	10	\N	Học kỳ 1	2025-05-11 12:12:16.176144
625	55	10	\N	Học kỳ 1	2025-05-11 12:12:16.180126
626	56	10	\N	Học kỳ 1	2025-05-11 12:12:16.18315
627	57	10	\N	Học kỳ 1	2025-05-11 12:12:16.18615
628	12	10	\N	Học kỳ 1	2025-05-11 12:12:16.189148
629	13	10	\N	Học kỳ 1	2025-05-11 12:12:16.192139
630	14	10	\N	Học kỳ 1	2025-05-11 12:12:16.197195
631	15	10	\N	Học kỳ 1	2025-05-11 12:12:16.200183
632	16	10	\N	Học kỳ 1	2025-05-11 12:12:16.202192
633	19	10	\N	Học kỳ 1	2025-05-11 12:12:16.205193
634	17	10	\N	Học kỳ 1	2025-05-11 12:12:16.208193
635	18	10	\N	Học kỳ 1	2025-05-11 12:12:16.213713
636	22	10	\N	Học kỳ 1	2025-05-11 12:12:16.216726
637	23	10	\N	Học kỳ 1	2025-05-11 12:12:16.218735
638	25	10	\N	Học kỳ 1	2025-05-11 12:12:16.221726
639	26	10	\N	Học kỳ 1	2025-05-11 12:12:16.224735
640	24	10	\N	Học kỳ 1	2025-05-11 12:12:16.229727
641	27	10	\N	Học kỳ 1	2025-05-11 12:12:16.232729
642	31	10	\N	Học kỳ 1	2025-05-11 12:12:16.235741
643	32	10	\N	Học kỳ 1	2025-05-11 12:12:16.238741
644	33	10	\N	Học kỳ 1	2025-05-11 12:12:16.24173
645	34	10	\N	Học kỳ 1	2025-05-11 12:12:16.245714
646	30	10	\N	Học kỳ 1	2025-05-11 12:12:16.249744
647	29	10	\N	Học kỳ 1	2025-05-11 12:12:16.252753
648	35	10	\N	Học kỳ 1	2025-05-11 12:12:16.255754
649	36	10	\N	Học kỳ 1	2025-05-11 12:12:16.258744
650	37	10	\N	Học kỳ 1	2025-05-11 12:12:16.262745
651	38	10	\N	Học kỳ 1	2025-05-11 12:12:16.265863
652	39	10	\N	Học kỳ 1	2025-05-11 12:12:16.268863
653	40	10	\N	Học kỳ 1	2025-05-11 12:12:16.271863
654	41	10	\N	Học kỳ 1	2025-05-11 12:12:16.275875
655	42	10	\N	Học kỳ 1	2025-05-11 12:12:16.279863
656	45	10	\N	Học kỳ 1	2025-05-11 12:12:16.282863
657	46	10	\N	Học kỳ 1	2025-05-11 12:12:16.285873
658	47	10	\N	Học kỳ 1	2025-05-11 12:12:16.288875
659	48	10	\N	Học kỳ 1	2025-05-11 12:12:16.290863
660	50	10	\N	Học kỳ 1	2025-05-11 12:12:16.294875
661	49	10	\N	Học kỳ 1	2025-05-11 12:12:16.298865
662	20	10	\N	Học kỳ 2	2025-05-11 12:12:16.365516
663	21	10	\N	Học kỳ 2	2025-05-11 12:12:16.368516
664	28	10	\N	Học kỳ 2	2025-05-11 12:12:16.371516
665	43	10	\N	Học kỳ 2	2025-05-11 12:12:16.374516
666	44	10	\N	Học kỳ 2	2025-05-11 12:12:16.377515
667	51	10	\N	Học kỳ 2	2025-05-11 12:12:16.381528
668	52	10	\N	Học kỳ 2	2025-05-11 12:12:16.384535
669	53	10	\N	Học kỳ 2	2025-05-11 12:12:16.387536
670	54	10	\N	Học kỳ 2	2025-05-11 12:12:16.389535
671	55	10	\N	Học kỳ 2	2025-05-11 12:12:16.392535
672	56	10	\N	Học kỳ 2	2025-05-11 12:12:16.397527
673	57	10	\N	Học kỳ 2	2025-05-11 12:12:16.400559
674	12	10	\N	Học kỳ 2	2025-05-11 12:12:16.403572
675	13	10	\N	Học kỳ 2	2025-05-11 12:12:16.405572
676	14	10	\N	Học kỳ 2	2025-05-11 12:12:16.408573
677	15	10	\N	Học kỳ 2	2025-05-11 12:12:16.412561
678	16	10	\N	Học kỳ 2	2025-05-11 12:12:16.416088
679	19	10	\N	Học kỳ 2	2025-05-11 12:12:16.419097
680	17	10	\N	Học kỳ 2	2025-05-11 12:12:16.422097
681	18	10	\N	Học kỳ 2	2025-05-11 12:12:16.424097
682	22	10	\N	Học kỳ 2	2025-05-11 12:12:16.428099
683	23	10	\N	Học kỳ 2	2025-05-11 12:12:16.432078
684	25	10	\N	Học kỳ 2	2025-05-11 12:12:16.435074
685	26	10	\N	Học kỳ 2	2025-05-11 12:12:16.438077
686	24	10	\N	Học kỳ 2	2025-05-11 12:12:16.441077
687	27	10	\N	Học kỳ 2	2025-05-11 12:12:16.44408
688	31	10	\N	Học kỳ 2	2025-05-11 12:12:16.447088
689	32	10	\N	Học kỳ 2	2025-05-11 12:12:16.450125
690	33	10	\N	Học kỳ 2	2025-05-11 12:12:16.453125
691	34	10	\N	Học kỳ 2	2025-05-11 12:12:16.456125
692	30	10	\N	Học kỳ 2	2025-05-11 12:12:16.459125
693	29	10	\N	Học kỳ 2	2025-05-11 12:12:16.462118
694	35	10	\N	Học kỳ 2	2025-05-11 12:12:16.465681
695	36	10	\N	Học kỳ 2	2025-05-11 12:12:16.468681
696	37	10	\N	Học kỳ 2	2025-05-11 12:12:16.471681
697	38	10	\N	Học kỳ 2	2025-05-11 12:12:16.473681
698	39	10	\N	Học kỳ 2	2025-05-11 12:12:16.477668
699	40	10	\N	Học kỳ 2	2025-05-11 12:12:16.481663
700	41	10	\N	Học kỳ 2	2025-05-11 12:12:16.484661
701	42	10	\N	Học kỳ 2	2025-05-11 12:12:16.486656
702	45	10	\N	Học kỳ 2	2025-05-11 12:12:16.489656
703	46	10	\N	Học kỳ 2	2025-05-11 12:12:16.493656
704	47	10	\N	Học kỳ 2	2025-05-11 12:12:16.497676
705	48	10	\N	Học kỳ 2	2025-05-11 12:12:16.500706
706	50	10	\N	Học kỳ 2	2025-05-11 12:12:16.503718
707	49	10	\N	Học kỳ 2	2025-05-11 12:12:16.50572
708	20	11	\N	Học kỳ 1	2025-05-11 12:12:17.088027
709	21	11	\N	Học kỳ 1	2025-05-11 12:12:17.091018
710	28	11	\N	Học kỳ 1	2025-05-11 12:12:17.094052
711	43	11	\N	Học kỳ 1	2025-05-11 12:12:17.09703
712	44	11	\N	Học kỳ 1	2025-05-11 12:12:17.100018
713	51	11	\N	Học kỳ 1	2025-05-11 12:12:17.103027
714	52	11	\N	Học kỳ 1	2025-05-11 12:12:17.106018
715	53	11	\N	Học kỳ 1	2025-05-11 12:12:17.109056
716	54	11	\N	Học kỳ 1	2025-05-11 12:12:17.112068
717	55	11	\N	Học kỳ 1	2025-05-11 12:12:17.115056
718	56	11	\N	Học kỳ 1	2025-05-11 12:12:17.118066
719	57	11	\N	Học kỳ 1	2025-05-11 12:12:17.121058
720	12	11	\N	Học kỳ 1	2025-05-11 12:12:17.12463
721	13	11	\N	Học kỳ 1	2025-05-11 12:12:17.126631
722	14	11	\N	Học kỳ 1	2025-05-11 12:12:17.130617
723	15	11	\N	Học kỳ 1	2025-05-11 12:12:17.133631
724	16	11	\N	Học kỳ 1	2025-05-11 12:12:17.136631
725	19	11	\N	Học kỳ 1	2025-05-11 12:12:17.140629
726	17	11	\N	Học kỳ 1	2025-05-11 12:12:17.143631
727	18	11	\N	Học kỳ 1	2025-05-11 12:12:17.146606
728	22	11	\N	Học kỳ 1	2025-05-11 12:12:17.149629
729	23	11	\N	Học kỳ 1	2025-05-11 12:12:17.152632
730	25	11	\N	Học kỳ 1	2025-05-11 12:12:17.15563
731	26	11	\N	Học kỳ 1	2025-05-11 12:12:17.158663
732	24	11	\N	Học kỳ 1	2025-05-11 12:12:17.161661
733	27	11	\N	Học kỳ 1	2025-05-11 12:12:17.165661
734	31	11	\N	Học kỳ 1	2025-05-11 12:12:17.168673
735	32	11	\N	Học kỳ 1	2025-05-11 12:12:17.171662
736	33	11	\N	Học kỳ 1	2025-05-11 12:12:17.174257
737	34	11	\N	Học kỳ 1	2025-05-11 12:12:17.177387
738	30	11	\N	Học kỳ 1	2025-05-11 12:12:17.181242
739	29	11	\N	Học kỳ 1	2025-05-11 12:12:17.184242
740	35	11	\N	Học kỳ 1	2025-05-11 12:12:17.186256
741	36	11	\N	Học kỳ 1	2025-05-11 12:12:17.189258
742	37	11	\N	Học kỳ 1	2025-05-11 12:12:17.192245
743	38	11	\N	Học kỳ 1	2025-05-11 12:12:17.195259
744	39	11	\N	Học kỳ 1	2025-05-11 12:12:17.198255
745	40	11	\N	Học kỳ 1	2025-05-11 12:12:17.201244
746	41	11	\N	Học kỳ 1	2025-05-11 12:12:17.204256
747	42	11	\N	Học kỳ 1	2025-05-11 12:12:17.207253
748	45	11	\N	Học kỳ 1	2025-05-11 12:12:17.210276
749	46	11	\N	Học kỳ 1	2025-05-11 12:12:17.213258
750	47	11	\N	Học kỳ 1	2025-05-11 12:12:17.216278
751	48	11	\N	Học kỳ 1	2025-05-11 12:12:17.219287
752	50	11	\N	Học kỳ 1	2025-05-11 12:12:17.222288
753	49	11	\N	Học kỳ 1	2025-05-11 12:12:17.224872
754	20	11	\N	Học kỳ 2	2025-05-11 12:12:17.288882
755	21	11	\N	Học kỳ 2	2025-05-11 12:12:17.291882
756	28	11	\N	Học kỳ 2	2025-05-11 12:12:17.294884
757	43	11	\N	Học kỳ 2	2025-05-11 12:12:17.297882
758	44	11	\N	Học kỳ 2	2025-05-11 12:12:17.300882
759	51	11	\N	Học kỳ 2	2025-05-11 12:12:17.303882
760	52	11	\N	Học kỳ 2	2025-05-11 12:12:17.306882
761	53	11	\N	Học kỳ 2	2025-05-11 12:12:17.309906
762	54	11	\N	Học kỳ 2	2025-05-11 12:12:17.312902
763	55	11	\N	Học kỳ 2	2025-05-11 12:12:17.315902
764	56	11	\N	Học kỳ 2	2025-05-11 12:12:17.318906
765	57	11	\N	Học kỳ 2	2025-05-11 12:12:17.321905
766	12	11	\N	Học kỳ 2	2025-05-11 12:12:17.324905
767	13	11	\N	Học kỳ 2	2025-05-11 12:12:17.328098
768	14	11	\N	Học kỳ 2	2025-05-11 12:12:17.331095
769	15	11	\N	Học kỳ 2	2025-05-11 12:12:17.334096
770	16	11	\N	Học kỳ 2	2025-05-11 12:12:17.337097
771	19	11	\N	Học kỳ 2	2025-05-11 12:12:17.340096
772	17	11	\N	Học kỳ 2	2025-05-11 12:12:17.343097
773	18	11	\N	Học kỳ 2	2025-05-11 12:12:17.346098
774	22	11	\N	Học kỳ 2	2025-05-11 12:12:17.349097
775	23	11	\N	Học kỳ 2	2025-05-11 12:12:17.35209
776	25	11	\N	Học kỳ 2	2025-05-11 12:12:17.35572
777	26	11	\N	Học kỳ 2	2025-05-11 12:12:17.35872
778	24	11	\N	Học kỳ 2	2025-05-11 12:12:17.361768
779	27	11	\N	Học kỳ 2	2025-05-11 12:12:17.365766
780	31	11	\N	Học kỳ 2	2025-05-11 12:12:17.367766
781	32	11	\N	Học kỳ 2	2025-05-11 12:12:17.370754
782	33	11	\N	Học kỳ 2	2025-05-11 12:12:17.373767
783	34	11	\N	Học kỳ 2	2025-05-11 12:12:17.377348
784	30	11	\N	Học kỳ 2	2025-05-11 12:12:17.380348
785	29	11	\N	Học kỳ 2	2025-05-11 12:12:17.383361
786	35	11	\N	Học kỳ 2	2025-05-11 12:12:17.38636
787	36	11	\N	Học kỳ 2	2025-05-11 12:12:17.38936
788	37	11	\N	Học kỳ 2	2025-05-11 12:12:17.392349
789	38	11	\N	Học kỳ 2	2025-05-11 12:12:17.395363
790	39	11	\N	Học kỳ 2	2025-05-11 12:12:17.398349
791	40	11	\N	Học kỳ 2	2025-05-11 12:12:17.40136
792	41	11	\N	Học kỳ 2	2025-05-11 12:12:17.40436
793	42	11	\N	Học kỳ 2	2025-05-11 12:12:17.407359
794	45	11	\N	Học kỳ 2	2025-05-11 12:12:17.409349
795	46	11	\N	Học kỳ 2	2025-05-11 12:12:17.412405
796	47	11	\N	Học kỳ 2	2025-05-11 12:12:17.415393
797	48	11	\N	Học kỳ 2	2025-05-11 12:12:17.419404
798	50	11	\N	Học kỳ 2	2025-05-11 12:12:17.421405
799	49	11	\N	Học kỳ 2	2025-05-11 12:12:17.424405
800	20	12	\N	Học kỳ 1	2025-05-11 12:12:17.992208
801	21	12	\N	Học kỳ 1	2025-05-11 12:12:17.995196
802	28	12	\N	Học kỳ 1	2025-05-11 12:12:17.998196
803	43	12	\N	Học kỳ 1	2025-05-11 12:12:18.002179
804	44	12	\N	Học kỳ 1	2025-05-11 12:12:18.00518
805	51	12	\N	Học kỳ 1	2025-05-11 12:12:18.008182
806	52	12	\N	Học kỳ 1	2025-05-11 12:12:18.012184
807	53	12	\N	Học kỳ 1	2025-05-11 12:12:18.016194
808	54	12	\N	Học kỳ 1	2025-05-11 12:12:18.019196
809	55	12	\N	Học kỳ 1	2025-05-11 12:12:18.022194
810	56	12	\N	Học kỳ 1	2025-05-11 12:12:18.025194
811	57	12	\N	Học kỳ 1	2025-05-11 12:12:18.029203
812	12	12	\N	Học kỳ 1	2025-05-11 12:12:18.032724
813	13	12	\N	Học kỳ 1	2025-05-11 12:12:18.036729
814	14	12	\N	Học kỳ 1	2025-05-11 12:12:18.040726
815	15	12	\N	Học kỳ 1	2025-05-11 12:12:18.043726
816	16	12	\N	Học kỳ 1	2025-05-11 12:12:18.047718
817	19	12	\N	Học kỳ 1	2025-05-11 12:12:18.050718
818	17	12	\N	Học kỳ 1	2025-05-11 12:12:18.05372
819	18	12	\N	Học kỳ 1	2025-05-11 12:12:18.05672
820	22	12	\N	Học kỳ 1	2025-05-11 12:12:18.05872
821	23	12	\N	Học kỳ 1	2025-05-11 12:12:18.062739
822	25	12	\N	Học kỳ 1	2025-05-11 12:12:18.065718
823	26	12	\N	Học kỳ 1	2025-05-11 12:12:18.068726
824	24	12	\N	Học kỳ 1	2025-05-11 12:12:18.071726
825	27	12	\N	Học kỳ 1	2025-05-11 12:12:18.074726
826	31	12	\N	Học kỳ 1	2025-05-11 12:12:18.078736
827	32	12	\N	Học kỳ 1	2025-05-11 12:12:18.082237
828	33	12	\N	Học kỳ 1	2025-05-11 12:12:18.085247
829	34	12	\N	Học kỳ 1	2025-05-11 12:12:18.088247
830	30	12	\N	Học kỳ 1	2025-05-11 12:12:18.091247
831	29	12	\N	Học kỳ 1	2025-05-11 12:12:18.095257
832	35	12	\N	Học kỳ 1	2025-05-11 12:12:18.098279
833	36	12	\N	Học kỳ 1	2025-05-11 12:12:18.10128
834	37	12	\N	Học kỳ 1	2025-05-11 12:12:18.10428
835	38	12	\N	Học kỳ 1	2025-05-11 12:12:18.10728
836	39	12	\N	Học kỳ 1	2025-05-11 12:12:18.111255
837	40	12	\N	Học kỳ 1	2025-05-11 12:12:18.115248
838	41	12	\N	Học kỳ 1	2025-05-11 12:12:18.118259
839	42	12	\N	Học kỳ 1	2025-05-11 12:12:18.12129
840	45	12	\N	Học kỳ 1	2025-05-11 12:12:18.124291
841	46	12	\N	Học kỳ 1	2025-05-11 12:12:18.12729
842	47	12	\N	Học kỳ 1	2025-05-11 12:12:18.131279
843	48	12	\N	Học kỳ 1	2025-05-11 12:12:18.133848
844	50	12	\N	Học kỳ 1	2025-05-11 12:12:18.136847
845	49	12	\N	Học kỳ 1	2025-05-11 12:12:18.139847
846	20	12	\N	Học kỳ 2	2025-05-11 12:12:18.200471
847	21	12	\N	Học kỳ 2	2025-05-11 12:12:18.203472
848	28	12	\N	Học kỳ 2	2025-05-11 12:12:18.205461
849	43	12	\N	Học kỳ 2	2025-05-11 12:12:18.208471
850	44	12	\N	Học kỳ 2	2025-05-11 12:12:18.211449
851	51	12	\N	Học kỳ 2	2025-05-11 12:12:18.214459
852	52	12	\N	Học kỳ 2	2025-05-11 12:12:18.217471
853	53	12	\N	Học kỳ 2	2025-05-11 12:12:18.220514
854	54	12	\N	Học kỳ 2	2025-05-11 12:12:18.223514
855	55	12	\N	Học kỳ 2	2025-05-11 12:12:18.226513
856	56	12	\N	Học kỳ 2	2025-05-11 12:12:18.230502
857	57	12	\N	Học kỳ 2	2025-05-11 12:12:18.233054
858	12	12	\N	Học kỳ 2	2025-05-11 12:12:18.23607
859	13	12	\N	Học kỳ 2	2025-05-11 12:12:18.239099
860	14	12	\N	Học kỳ 2	2025-05-11 12:12:18.241101
861	15	12	\N	Học kỳ 2	2025-05-11 12:12:18.244099
862	16	12	\N	Học kỳ 2	2025-05-11 12:12:18.247089
863	19	12	\N	Học kỳ 2	2025-05-11 12:12:18.250099
864	17	12	\N	Học kỳ 2	2025-05-11 12:12:18.254096
865	18	12	\N	Học kỳ 2	2025-05-11 12:12:18.257099
866	22	12	\N	Học kỳ 2	2025-05-11 12:12:18.260099
867	23	12	\N	Học kỳ 2	2025-05-11 12:12:18.263081
868	25	12	\N	Học kỳ 2	2025-05-11 12:12:18.266099
869	26	12	\N	Học kỳ 2	2025-05-11 12:12:18.26914
870	24	12	\N	Học kỳ 2	2025-05-11 12:12:18.272141
871	27	12	\N	Học kỳ 2	2025-05-11 12:12:18.274141
872	31	12	\N	Học kỳ 2	2025-05-11 12:12:18.277142
873	32	12	\N	Học kỳ 2	2025-05-11 12:12:18.280145
874	33	12	\N	Học kỳ 2	2025-05-11 12:12:18.283671
875	34	12	\N	Học kỳ 2	2025-05-11 12:12:18.285717
876	30	12	\N	Học kỳ 2	2025-05-11 12:12:18.288718
877	29	12	\N	Học kỳ 2	2025-05-11 12:12:18.291716
878	35	12	\N	Học kỳ 2	2025-05-11 12:12:18.294717
879	36	12	\N	Học kỳ 2	2025-05-11 12:12:18.297707
880	37	12	\N	Học kỳ 2	2025-05-11 12:12:18.301716
881	38	12	\N	Học kỳ 2	2025-05-11 12:12:18.303717
882	39	12	\N	Học kỳ 2	2025-05-11 12:12:18.306717
883	40	12	\N	Học kỳ 2	2025-05-11 12:12:18.309717
884	41	12	\N	Học kỳ 2	2025-05-11 12:12:18.312697
885	42	12	\N	Học kỳ 2	2025-05-11 12:12:18.315717
886	45	12	\N	Học kỳ 2	2025-05-11 12:12:18.317718
887	46	12	\N	Học kỳ 2	2025-05-11 12:12:18.320759
888	47	12	\N	Học kỳ 2	2025-05-11 12:12:18.323759
889	48	12	\N	Học kỳ 2	2025-05-11 12:12:18.325759
890	50	12	\N	Học kỳ 2	2025-05-11 12:12:18.329761
891	49	12	\N	Học kỳ 2	2025-05-11 12:12:18.333757
892	20	13	\N	Học kỳ 1	2025-05-11 12:12:19.060096
893	21	13	\N	Học kỳ 1	2025-05-11 12:12:19.063087
894	28	13	\N	Học kỳ 1	2025-05-11 12:12:19.066086
895	43	13	\N	Học kỳ 1	2025-05-11 12:12:19.069087
896	44	13	\N	Học kỳ 1	2025-05-11 12:12:19.072096
897	51	13	\N	Học kỳ 1	2025-05-11 12:12:19.075097
898	52	13	\N	Học kỳ 1	2025-05-11 12:12:19.078127
899	53	13	\N	Học kỳ 1	2025-05-11 12:12:19.082128
900	54	13	\N	Học kỳ 1	2025-05-11 12:12:19.08514
901	55	13	\N	Học kỳ 1	2025-05-11 12:12:19.088109
902	56	13	\N	Học kỳ 1	2025-05-11 12:12:19.090678
903	57	13	\N	Học kỳ 1	2025-05-11 12:12:19.093696
904	12	13	\N	Học kỳ 1	2025-05-11 12:12:19.096715
905	13	13	\N	Học kỳ 1	2025-05-11 12:12:19.100704
906	14	13	\N	Học kỳ 1	2025-05-11 12:12:19.103698
907	15	13	\N	Học kỳ 1	2025-05-11 12:12:19.107705
908	16	13	\N	Học kỳ 1	2025-05-11 12:12:19.110705
909	19	13	\N	Học kỳ 1	2025-05-11 12:12:19.113716
910	17	13	\N	Học kỳ 1	2025-05-11 12:12:19.117716
911	18	13	\N	Học kỳ 1	2025-05-11 12:12:19.120723
912	22	13	\N	Học kỳ 1	2025-05-11 12:12:19.123725
913	23	13	\N	Học kỳ 1	2025-05-11 12:12:19.126757
914	25	13	\N	Học kỳ 1	2025-05-11 12:12:19.129742
915	26	13	\N	Học kỳ 1	2025-05-11 12:12:19.132744
916	24	13	\N	Học kỳ 1	2025-05-11 12:12:19.135743
917	27	13	\N	Học kỳ 1	2025-05-11 12:12:19.138753
918	31	13	\N	Học kỳ 1	2025-05-11 12:12:19.142323
919	32	13	\N	Học kỳ 1	2025-05-11 12:12:19.14633
920	33	13	\N	Học kỳ 1	2025-05-11 12:12:19.150326
921	34	13	\N	Học kỳ 1	2025-05-11 12:12:19.152335
922	30	13	\N	Học kỳ 1	2025-05-11 12:12:19.155338
923	29	13	\N	Học kỳ 1	2025-05-11 12:12:19.158559
924	35	13	\N	Học kỳ 1	2025-05-11 12:12:19.162312
925	36	13	\N	Học kỳ 1	2025-05-11 12:12:19.165328
926	37	13	\N	Học kỳ 1	2025-05-11 12:12:19.168335
927	38	13	\N	Học kỳ 1	2025-05-11 12:12:19.171336
928	39	13	\N	Học kỳ 1	2025-05-11 12:12:19.174564
929	40	13	\N	Học kỳ 1	2025-05-11 12:12:19.178353
930	41	13	\N	Học kỳ 1	2025-05-11 12:12:19.181354
931	42	13	\N	Học kỳ 1	2025-05-11 12:12:19.184355
932	45	13	\N	Học kỳ 1	2025-05-11 12:12:19.187365
933	46	13	\N	Học kỳ 1	2025-05-11 12:12:19.190364
934	47	13	\N	Học kỳ 1	2025-05-11 12:12:19.193948
935	48	13	\N	Học kỳ 1	2025-05-11 12:12:19.196924
936	50	13	\N	Học kỳ 1	2025-05-11 12:12:19.200928
937	49	13	\N	Học kỳ 1	2025-05-11 12:12:19.203922
938	20	13	\N	Học kỳ 2	2025-05-11 12:12:19.269529
939	21	13	\N	Học kỳ 2	2025-05-11 12:12:19.272541
940	28	13	\N	Học kỳ 2	2025-05-11 12:12:19.275539
941	43	13	\N	Học kỳ 2	2025-05-11 12:12:19.278569
942	44	13	\N	Học kỳ 2	2025-05-11 12:12:19.282568
943	51	13	\N	Học kỳ 2	2025-05-11 12:12:19.285578
944	52	13	\N	Học kỳ 2	2025-05-11 12:12:19.288578
945	53	13	\N	Học kỳ 2	2025-05-11 12:12:19.291581
946	54	13	\N	Học kỳ 2	2025-05-11 12:12:19.294165
947	55	13	\N	Học kỳ 2	2025-05-11 12:12:19.297159
948	56	13	\N	Học kỳ 2	2025-05-11 12:12:19.301163
949	57	13	\N	Học kỳ 2	2025-05-11 12:12:19.303163
950	12	13	\N	Học kỳ 2	2025-05-11 12:12:19.306163
951	13	13	\N	Học kỳ 2	2025-05-11 12:12:19.309165
952	14	13	\N	Học kỳ 2	2025-05-11 12:12:19.312154
953	15	13	\N	Học kỳ 2	2025-05-11 12:12:19.315163
954	16	13	\N	Học kỳ 2	2025-05-11 12:12:19.318165
955	19	13	\N	Học kỳ 2	2025-05-11 12:12:19.321163
956	17	13	\N	Học kỳ 2	2025-05-11 12:12:19.324164
957	18	13	\N	Học kỳ 2	2025-05-11 12:12:19.32714
958	22	13	\N	Học kỳ 2	2025-05-11 12:12:19.330184
959	23	13	\N	Học kỳ 2	2025-05-11 12:12:19.334192
960	25	13	\N	Học kỳ 2	2025-05-11 12:12:19.337192
961	26	13	\N	Học kỳ 2	2025-05-11 12:12:19.340192
962	24	13	\N	Học kỳ 2	2025-05-11 12:12:19.342194
963	27	13	\N	Học kỳ 2	2025-05-11 12:12:19.345753
964	31	13	\N	Học kỳ 2	2025-05-11 12:12:19.348754
965	32	13	\N	Học kỳ 2	2025-05-11 12:12:19.35175
966	33	13	\N	Học kỳ 2	2025-05-11 12:12:19.354748
967	34	13	\N	Học kỳ 2	2025-05-11 12:12:19.357747
968	30	13	\N	Học kỳ 2	2025-05-11 12:12:19.360748
969	29	13	\N	Học kỳ 2	2025-05-11 12:12:19.363741
970	35	13	\N	Học kỳ 2	2025-05-11 12:12:19.36675
971	36	13	\N	Học kỳ 2	2025-05-11 12:12:19.369747
972	37	13	\N	Học kỳ 2	2025-05-11 12:12:19.372747
973	38	13	\N	Học kỳ 2	2025-05-11 12:12:19.375748
974	39	13	\N	Học kỳ 2	2025-05-11 12:12:19.379763
975	40	13	\N	Học kỳ 2	2025-05-11 12:12:19.382782
976	41	13	\N	Học kỳ 2	2025-05-11 12:12:19.385783
977	42	13	\N	Học kỳ 2	2025-05-11 12:12:19.388784
978	45	13	\N	Học kỳ 2	2025-05-11 12:12:19.391784
979	46	13	\N	Học kỳ 2	2025-05-11 12:12:19.395313
980	47	13	\N	Học kỳ 2	2025-05-11 12:12:19.39831
981	48	13	\N	Học kỳ 2	2025-05-11 12:12:19.401314
982	50	13	\N	Học kỳ 2	2025-05-11 12:12:19.404321
983	49	13	\N	Học kỳ 2	2025-05-11 12:12:19.407321
984	20	14	\N	Học kỳ 1	2025-05-11 12:12:20.069125
985	21	14	\N	Học kỳ 1	2025-05-11 12:12:20.074128
986	28	14	\N	Học kỳ 1	2025-05-11 12:12:20.07813
987	43	14	\N	Học kỳ 1	2025-05-11 12:12:20.082129
988	44	14	\N	Học kỳ 1	2025-05-11 12:12:20.087141
989	51	14	\N	Học kỳ 1	2025-05-11 12:12:20.091154
990	52	14	\N	Học kỳ 1	2025-05-11 12:12:20.095158
991	53	14	\N	Học kỳ 1	2025-05-11 12:12:20.100147
992	54	14	\N	Học kỳ 1	2025-05-11 12:12:20.104295
993	55	14	\N	Học kỳ 1	2025-05-11 12:12:20.108287
994	56	14	\N	Học kỳ 1	2025-05-11 12:12:20.112292
995	57	14	\N	Học kỳ 1	2025-05-11 12:12:20.117298
996	12	14	\N	Học kỳ 1	2025-05-11 12:12:20.121291
997	13	14	\N	Học kỳ 1	2025-05-11 12:12:20.125292
998	14	14	\N	Học kỳ 1	2025-05-11 12:12:20.129293
999	15	14	\N	Học kỳ 1	2025-05-11 12:12:20.133295
1000	16	14	\N	Học kỳ 1	2025-05-11 12:12:20.137309
1001	19	14	\N	Học kỳ 1	2025-05-11 12:12:20.142309
1002	17	14	\N	Học kỳ 1	2025-05-11 12:12:20.146314
1003	18	14	\N	Học kỳ 1	2025-05-11 12:12:20.150312
1004	22	14	\N	Học kỳ 1	2025-05-11 12:12:20.154857
1005	23	14	\N	Học kỳ 1	2025-05-11 12:12:20.158857
1006	25	14	\N	Học kỳ 1	2025-05-11 12:12:20.162856
1007	26	14	\N	Học kỳ 1	2025-05-11 12:12:20.168852
1008	24	14	\N	Học kỳ 1	2025-05-11 12:12:20.172852
1009	27	14	\N	Học kỳ 1	2025-05-11 12:12:20.176853
1010	31	14	\N	Học kỳ 1	2025-05-11 12:12:20.180852
1011	32	14	\N	Học kỳ 1	2025-05-11 12:12:20.18485
1012	33	14	\N	Học kỳ 1	2025-05-11 12:12:20.188861
1013	34	14	\N	Học kỳ 1	2025-05-11 12:12:20.192862
1014	30	14	\N	Học kỳ 1	2025-05-11 12:12:20.19686
1015	29	14	\N	Học kỳ 1	2025-05-11 12:12:20.201865
1016	35	14	\N	Học kỳ 1	2025-05-11 12:12:20.205387
1017	36	14	\N	Học kỳ 1	2025-05-11 12:12:20.209389
1018	37	14	\N	Học kỳ 1	2025-05-11 12:12:20.214398
1019	38	14	\N	Học kỳ 1	2025-05-11 12:12:20.218388
1020	39	14	\N	Học kỳ 1	2025-05-11 12:12:20.221388
1021	40	14	\N	Học kỳ 1	2025-05-11 12:12:20.225396
1022	41	14	\N	Học kỳ 1	2025-05-11 12:12:20.229392
1023	42	14	\N	Học kỳ 1	2025-05-11 12:12:20.234395
1024	45	14	\N	Học kỳ 1	2025-05-11 12:12:20.237397
1025	46	14	\N	Học kỳ 1	2025-05-11 12:12:20.241396
1026	47	14	\N	Học kỳ 1	2025-05-11 12:12:20.244402
1027	48	14	\N	Học kỳ 1	2025-05-11 12:12:20.248402
1028	50	14	\N	Học kỳ 1	2025-05-11 12:12:20.252399
1029	49	14	\N	Học kỳ 1	2025-05-11 12:12:20.255927
1030	20	14	\N	Học kỳ 2	2025-05-11 12:12:20.337475
1031	21	14	\N	Học kỳ 2	2025-05-11 12:12:20.340492
1032	28	14	\N	Học kỳ 2	2025-05-11 12:12:20.344492
1033	43	14	\N	Học kỳ 2	2025-05-11 12:12:20.348493
1034	44	14	\N	Học kỳ 2	2025-05-11 12:12:20.352488
1035	51	14	\N	Học kỳ 2	2025-05-11 12:12:20.356013
1036	52	14	\N	Học kỳ 2	2025-05-11 12:12:20.359012
1037	53	14	\N	Học kỳ 2	2025-05-11 12:12:20.363009
1038	54	14	\N	Học kỳ 2	2025-05-11 12:12:20.368006
1039	55	14	\N	Học kỳ 2	2025-05-11 12:12:20.371011
1040	56	14	\N	Học kỳ 2	2025-05-11 12:12:20.375006
1041	57	14	\N	Học kỳ 2	2025-05-11 12:12:20.379007
1042	12	14	\N	Học kỳ 2	2025-05-11 12:12:20.383012
1043	13	14	\N	Học kỳ 2	2025-05-11 12:12:20.387006
1044	14	14	\N	Học kỳ 2	2025-05-11 12:12:20.390018
1045	15	14	\N	Học kỳ 2	2025-05-11 12:12:20.393027
1046	16	14	\N	Học kỳ 2	2025-05-11 12:12:20.397014
1047	19	14	\N	Học kỳ 2	2025-05-11 12:12:20.402013
1048	17	14	\N	Học kỳ 2	2025-05-11 12:12:20.405537
1049	18	14	\N	Học kỳ 2	2025-05-11 12:12:20.408531
1050	22	14	\N	Học kỳ 2	2025-05-11 12:12:20.412531
1051	23	14	\N	Học kỳ 2	2025-05-11 12:12:20.416556
1052	25	14	\N	Học kỳ 2	2025-05-11 12:12:20.420553
1053	26	14	\N	Học kỳ 2	2025-05-11 12:12:20.423567
1054	24	14	\N	Học kỳ 2	2025-05-11 12:12:20.427555
1055	27	14	\N	Học kỳ 2	2025-05-11 12:12:20.431539
1056	31	14	\N	Học kỳ 2	2025-05-11 12:12:20.435553
1057	32	14	\N	Học kỳ 2	2025-05-11 12:12:20.438553
1058	33	14	\N	Học kỳ 2	2025-05-11 12:12:20.441564
1059	34	14	\N	Học kỳ 2	2025-05-11 12:12:20.444581
1060	30	14	\N	Học kỳ 2	2025-05-11 12:12:20.449568
1061	29	14	\N	Học kỳ 2	2025-05-11 12:12:20.453581
1062	35	14	\N	Học kỳ 2	2025-05-11 12:12:20.456119
1063	36	14	\N	Học kỳ 2	2025-05-11 12:12:20.460119
1064	37	14	\N	Học kỳ 2	2025-05-11 12:12:20.464106
1065	38	14	\N	Học kỳ 2	2025-05-11 12:12:20.46712
1066	39	14	\N	Học kỳ 2	2025-05-11 12:12:20.471119
1067	40	14	\N	Học kỳ 2	2025-05-11 12:12:20.474129
1068	41	14	\N	Học kỳ 2	2025-05-11 12:12:20.478119
1069	42	14	\N	Học kỳ 2	2025-05-11 12:12:20.482111
1070	45	14	\N	Học kỳ 2	2025-05-11 12:12:20.486119
1071	46	14	\N	Học kỳ 2	2025-05-11 12:12:20.489129
1072	47	14	\N	Học kỳ 2	2025-05-11 12:12:20.492158
1073	48	14	\N	Học kỳ 2	2025-05-11 12:12:20.496158
1074	50	14	\N	Học kỳ 2	2025-05-11 12:12:20.500159
1075	49	14	\N	Học kỳ 2	2025-05-11 12:12:20.50317
1076	20	15	\N	Học kỳ 1	2025-05-11 12:12:21.199281
1077	21	15	\N	Học kỳ 1	2025-05-11 12:12:21.203284
1078	28	15	\N	Học kỳ 1	2025-05-11 12:12:21.207282
1079	43	15	\N	Học kỳ 1	2025-05-11 12:12:21.210278
1080	44	15	\N	Học kỳ 1	2025-05-11 12:12:21.214185
1081	51	15	\N	Học kỳ 1	2025-05-11 12:12:21.217841
1082	52	15	\N	Học kỳ 1	2025-05-11 12:12:21.220832
1083	53	15	\N	Học kỳ 1	2025-05-11 12:12:21.223842
1084	54	15	\N	Học kỳ 1	2025-05-11 12:12:21.226842
1085	55	15	\N	Học kỳ 1	2025-05-11 12:12:21.229842
1086	56	15	\N	Học kỳ 1	2025-05-11 12:12:21.233819
1087	57	15	\N	Học kỳ 1	2025-05-11 12:12:21.237832
1088	12	15	\N	Học kỳ 1	2025-05-11 12:12:21.240844
1089	13	15	\N	Học kỳ 1	2025-05-11 12:12:21.243842
1090	14	15	\N	Học kỳ 1	2025-05-11 12:12:21.246842
1091	15	15	\N	Học kỳ 1	2025-05-11 12:12:21.249875
1092	16	15	\N	Học kỳ 1	2025-05-11 12:12:21.253874
1093	19	15	\N	Học kỳ 1	2025-05-11 12:12:21.256883
1094	17	15	\N	Học kỳ 1	2025-05-11 12:12:21.259883
1095	18	15	\N	Học kỳ 1	2025-05-11 12:12:21.262884
1096	22	15	\N	Học kỳ 1	2025-05-11 12:12:21.266427
1097	23	15	\N	Học kỳ 1	2025-05-11 12:12:21.269436
1098	25	15	\N	Học kỳ 1	2025-05-11 12:12:21.272439
1099	26	15	\N	Học kỳ 1	2025-05-11 12:12:21.275437
1100	24	15	\N	Học kỳ 1	2025-05-11 12:12:21.278439
1101	27	15	\N	Học kỳ 1	2025-05-11 12:12:21.282428
1102	31	15	\N	Học kỳ 1	2025-05-11 12:12:21.285439
1103	32	15	\N	Học kỳ 1	2025-05-11 12:12:21.288439
1104	33	15	\N	Học kỳ 1	2025-05-11 12:12:21.291439
1105	34	15	\N	Học kỳ 1	2025-05-11 12:12:21.294438
1106	30	15	\N	Học kỳ 1	2025-05-11 12:12:21.297424
1107	29	15	\N	Học kỳ 1	2025-05-11 12:12:21.301439
1108	35	15	\N	Học kỳ 1	2025-05-11 12:12:21.304437
1109	36	15	\N	Học kỳ 1	2025-05-11 12:12:21.307437
1110	37	15	\N	Học kỳ 1	2025-05-11 12:12:21.311453
1111	38	15	\N	Học kỳ 1	2025-05-11 12:12:21.316007
1112	39	15	\N	Học kỳ 1	2025-05-11 12:12:21.319001
1113	40	15	\N	Học kỳ 1	2025-05-11 12:12:21.323002
1114	41	15	\N	Học kỳ 1	2025-05-11 12:12:21.326
1115	42	15	\N	Học kỳ 1	2025-05-11 12:12:21.330004
1116	45	15	\N	Học kỳ 1	2025-05-11 12:12:21.334005
1117	46	15	\N	Học kỳ 1	2025-05-11 12:12:21.337002
1118	47	15	\N	Học kỳ 1	2025-05-11 12:12:21.340998
1119	48	15	\N	Học kỳ 1	2025-05-11 12:12:21.345018
1120	50	15	\N	Học kỳ 1	2025-05-11 12:12:21.349036
1121	49	15	\N	Học kỳ 1	2025-05-11 12:12:21.352025
1122	20	15	\N	Học kỳ 2	2025-05-11 12:12:21.43207
1123	21	15	\N	Học kỳ 2	2025-05-11 12:12:21.435054
1124	28	15	\N	Học kỳ 2	2025-05-11 12:12:21.439063
1125	43	15	\N	Học kỳ 2	2025-05-11 12:12:21.443055
1126	44	15	\N	Học kỳ 2	2025-05-11 12:12:21.446053
1127	51	15	\N	Học kỳ 2	2025-05-11 12:12:21.45005
1128	52	15	\N	Học kỳ 2	2025-05-11 12:12:21.453058
1129	53	15	\N	Học kỳ 2	2025-05-11 12:12:21.457593
1130	54	15	\N	Học kỳ 2	2025-05-11 12:12:21.460581
1131	55	15	\N	Học kỳ 2	2025-05-11 12:12:21.463593
1132	56	15	\N	Học kỳ 2	2025-05-11 12:12:21.468131
1133	57	15	\N	Học kỳ 2	2025-05-11 12:12:21.47214
1134	12	15	\N	Học kỳ 2	2025-05-11 12:12:21.475131
1135	13	15	\N	Học kỳ 2	2025-05-11 12:12:21.47914
1136	14	15	\N	Học kỳ 2	2025-05-11 12:12:21.483143
1137	15	15	\N	Học kỳ 2	2025-05-11 12:12:21.487131
1138	16	15	\N	Học kỳ 2	2025-05-11 12:12:21.490142
1139	19	15	\N	Học kỳ 2	2025-05-11 12:12:21.49413
1140	17	15	\N	Học kỳ 2	2025-05-11 12:12:21.49714
1141	18	15	\N	Học kỳ 2	2025-05-11 12:12:21.502162
1142	22	15	\N	Học kỳ 2	2025-05-11 12:12:21.506175
1143	23	15	\N	Học kỳ 2	2025-05-11 12:12:21.509169
1144	25	15	\N	Học kỳ 2	2025-05-11 12:12:21.512166
1145	26	15	\N	Học kỳ 2	2025-05-11 12:12:21.515711
1146	24	15	\N	Học kỳ 2	2025-05-11 12:12:21.519745
1147	27	15	\N	Học kỳ 2	2025-05-11 12:12:21.523756
1148	31	15	\N	Học kỳ 2	2025-05-11 12:12:21.526755
1149	32	15	\N	Học kỳ 2	2025-05-11 12:12:21.530739
1150	33	15	\N	Học kỳ 2	2025-05-11 12:12:21.534745
1151	34	15	\N	Học kỳ 2	2025-05-11 12:12:21.538745
1152	30	15	\N	Học kỳ 2	2025-05-11 12:12:21.541754
1153	29	15	\N	Học kỳ 2	2025-05-11 12:12:21.545754
1154	35	15	\N	Học kỳ 2	2025-05-11 12:12:21.549752
1155	36	15	\N	Học kỳ 2	2025-05-11 12:12:21.553778
1156	37	15	\N	Học kỳ 2	2025-05-11 12:12:21.557781
1157	38	15	\N	Học kỳ 2	2025-05-11 12:12:21.560771
1158	39	15	\N	Học kỳ 2	2025-05-11 12:12:21.564771
1159	40	15	\N	Học kỳ 2	2025-05-11 12:12:21.568336
1160	41	15	\N	Học kỳ 2	2025-05-11 12:12:21.571349
1161	42	15	\N	Học kỳ 2	2025-05-11 12:12:21.575363
1162	45	15	\N	Học kỳ 2	2025-05-11 12:12:21.579349
1163	46	15	\N	Học kỳ 2	2025-05-11 12:12:21.582363
1164	47	15	\N	Học kỳ 2	2025-05-11 12:12:21.586351
1165	48	15	\N	Học kỳ 2	2025-05-11 12:12:21.589363
1166	50	15	\N	Học kỳ 2	2025-05-11 12:12:21.592348
1167	49	15	\N	Học kỳ 2	2025-05-11 12:12:21.596344
1168	20	16	\N	Học kỳ 1	2025-05-11 12:12:22.321196
1169	21	16	\N	Học kỳ 1	2025-05-11 12:12:22.325179
1170	28	16	\N	Học kỳ 1	2025-05-11 12:12:22.328191
1171	43	16	\N	Học kỳ 1	2025-05-11 12:12:22.33119
1172	44	16	\N	Học kỳ 1	2025-05-11 12:12:22.335195
1173	51	16	\N	Học kỳ 1	2025-05-11 12:12:22.337178
1174	52	16	\N	Học kỳ 1	2025-05-11 12:12:22.340189
1175	53	16	\N	Học kỳ 1	2025-05-11 12:12:22.344167
1176	54	16	\N	Học kỳ 1	2025-05-11 12:12:22.348166
1177	55	16	\N	Học kỳ 1	2025-05-11 12:12:22.351178
1178	56	16	\N	Học kỳ 1	2025-05-11 12:12:22.354178
1179	57	16	\N	Học kỳ 1	2025-05-11 12:12:22.357161
1180	12	16	\N	Học kỳ 1	2025-05-11 12:12:22.360158
1181	13	16	\N	Học kỳ 1	2025-05-11 12:12:22.364157
1182	14	16	\N	Học kỳ 1	2025-05-11 12:12:22.367157
1183	15	16	\N	Học kỳ 1	2025-05-11 12:12:22.370156
1184	16	16	\N	Học kỳ 1	2025-05-11 12:12:22.373177
1185	19	16	\N	Học kỳ 1	2025-05-11 12:12:22.377177
1186	17	16	\N	Học kỳ 1	2025-05-11 12:12:22.380183
1187	18	16	\N	Học kỳ 1	2025-05-11 12:12:22.384191
1188	22	16	\N	Học kỳ 1	2025-05-11 12:12:22.38719
1189	23	16	\N	Học kỳ 1	2025-05-11 12:12:22.390191
1190	25	16	\N	Học kỳ 1	2025-05-11 12:12:22.393178
1191	26	16	\N	Học kỳ 1	2025-05-11 12:12:22.397187
1192	24	16	\N	Học kỳ 1	2025-05-11 12:12:22.40018
1193	27	16	\N	Học kỳ 1	2025-05-11 12:12:22.403194
1194	31	16	\N	Học kỳ 1	2025-05-11 12:12:22.406159
1195	32	16	\N	Học kỳ 1	2025-05-11 12:12:22.409161
1196	33	16	\N	Học kỳ 1	2025-05-11 12:12:22.412157
1197	34	16	\N	Học kỳ 1	2025-05-11 12:12:22.416185
1198	30	16	\N	Học kỳ 1	2025-05-11 12:12:22.419197
1199	29	16	\N	Học kỳ 1	2025-05-11 12:12:22.422185
1200	35	16	\N	Học kỳ 1	2025-05-11 12:12:22.426202
1201	36	16	\N	Học kỳ 1	2025-05-11 12:12:22.42977
1202	37	16	\N	Học kỳ 1	2025-05-11 12:12:22.432752
1203	38	16	\N	Học kỳ 1	2025-05-11 12:12:22.435772
1204	39	16	\N	Học kỳ 1	2025-05-11 12:12:22.438761
1205	40	16	\N	Học kỳ 1	2025-05-11 12:12:22.442761
1206	41	16	\N	Học kỳ 1	2025-05-11 12:12:22.44577
1207	42	16	\N	Học kỳ 1	2025-05-11 12:12:22.449773
1208	45	16	\N	Học kỳ 1	2025-05-11 12:12:22.45276
1209	46	16	\N	Học kỳ 1	2025-05-11 12:12:22.45577
1210	47	16	\N	Học kỳ 1	2025-05-11 12:12:22.458762
1211	48	16	\N	Học kỳ 1	2025-05-11 12:12:22.462773
1212	50	16	\N	Học kỳ 1	2025-05-11 12:12:22.465815
1213	49	16	\N	Học kỳ 1	2025-05-11 12:12:22.469814
1214	20	16	\N	Học kỳ 2	2025-05-11 12:12:22.539902
1215	21	16	\N	Học kỳ 2	2025-05-11 12:12:22.542902
1216	28	16	\N	Học kỳ 2	2025-05-11 12:12:22.5469
1217	43	16	\N	Học kỳ 2	2025-05-11 12:12:22.550891
1218	44	16	\N	Học kỳ 2	2025-05-11 12:12:22.553902
1219	51	16	\N	Học kỳ 2	2025-05-11 12:12:22.5559
1220	52	16	\N	Học kỳ 2	2025-05-11 12:12:22.559902
1221	53	16	\N	Học kỳ 2	2025-05-11 12:12:22.5629
1222	54	16	\N	Học kỳ 2	2025-05-11 12:12:22.566912
1223	55	16	\N	Học kỳ 2	2025-05-11 12:12:22.57092
1224	56	16	\N	Học kỳ 2	2025-05-11 12:12:22.574044
1225	57	16	\N	Học kỳ 2	2025-05-11 12:12:22.576931
1226	12	16	\N	Học kỳ 2	2025-05-11 12:12:22.581508
1227	13	16	\N	Học kỳ 2	2025-05-11 12:12:22.585499
1228	14	16	\N	Học kỳ 2	2025-05-11 12:12:22.58949
1229	15	16	\N	Học kỳ 2	2025-05-11 12:12:22.593499
1230	16	16	\N	Học kỳ 2	2025-05-11 12:12:22.597503
1231	19	16	\N	Học kỳ 2	2025-05-11 12:12:22.602499
1232	17	16	\N	Học kỳ 2	2025-05-11 12:12:22.606509
1233	18	16	\N	Học kỳ 2	2025-05-11 12:12:22.611499
1234	22	16	\N	Học kỳ 2	2025-05-11 12:12:22.614511
1235	23	16	\N	Học kỳ 2	2025-05-11 12:12:22.618552
1236	25	16	\N	Học kỳ 2	2025-05-11 12:12:22.622528
1237	26	16	\N	Học kỳ 2	2025-05-11 12:12:22.625556
1238	24	16	\N	Học kỳ 2	2025-05-11 12:12:22.631059
1239	27	16	\N	Học kỳ 2	2025-05-11 12:12:22.635066
1240	31	16	\N	Học kỳ 2	2025-05-11 12:12:22.639082
1241	32	16	\N	Học kỳ 2	2025-05-11 12:12:22.643073
1242	33	16	\N	Học kỳ 2	2025-05-11 12:12:22.647082
1243	34	16	\N	Học kỳ 2	2025-05-11 12:12:22.651074
1244	30	16	\N	Học kỳ 2	2025-05-11 12:12:22.655073
1245	29	16	\N	Học kỳ 2	2025-05-11 12:12:22.659085
1246	35	16	\N	Học kỳ 2	2025-05-11 12:12:22.663084
1247	36	16	\N	Học kỳ 2	2025-05-11 12:12:22.666114
1248	37	16	\N	Học kỳ 2	2025-05-11 12:12:22.670125
1249	38	16	\N	Học kỳ 2	2025-05-11 12:12:22.673123
1250	39	16	\N	Học kỳ 2	2025-05-11 12:12:22.677114
1251	40	16	\N	Học kỳ 2	2025-05-11 12:12:22.681098
1252	41	16	\N	Học kỳ 2	2025-05-11 12:12:22.68412
1253	42	16	\N	Học kỳ 2	2025-05-11 12:12:22.687142
1254	45	16	\N	Học kỳ 2	2025-05-11 12:12:22.691147
1255	46	16	\N	Học kỳ 2	2025-05-11 12:12:22.694139
1256	47	16	\N	Học kỳ 2	2025-05-11 12:12:22.69714
1257	48	16	\N	Học kỳ 2	2025-05-11 12:12:22.700131
1258	50	16	\N	Học kỳ 2	2025-05-11 12:12:22.70313
1259	49	16	\N	Học kỳ 2	2025-05-11 12:12:22.706146
1260	20	17	\N	Học kỳ 1	2025-05-11 12:12:23.388241
1261	21	17	\N	Học kỳ 1	2025-05-11 12:12:23.392285
1262	28	17	\N	Học kỳ 1	2025-05-11 12:12:23.395285
1263	43	17	\N	Học kỳ 1	2025-05-11 12:12:23.398254
1264	44	17	\N	Học kỳ 1	2025-05-11 12:12:23.40228
1265	51	17	\N	Học kỳ 1	2025-05-11 12:12:23.406284
1266	52	17	\N	Học kỳ 1	2025-05-11 12:12:23.410257
1267	53	17	\N	Học kỳ 1	2025-05-11 12:12:23.41326
1268	54	17	\N	Học kỳ 1	2025-05-11 12:12:23.417277
1269	55	17	\N	Học kỳ 1	2025-05-11 12:12:23.420288
1270	56	17	\N	Học kỳ 1	2025-05-11 12:12:23.424306
1271	57	17	\N	Học kỳ 1	2025-05-11 12:12:23.427301
1272	12	17	\N	Học kỳ 1	2025-05-11 12:12:23.431309
1273	13	17	\N	Học kỳ 1	2025-05-11 12:12:23.435291
1274	14	17	\N	Học kỳ 1	2025-05-11 12:12:23.438818
1275	15	17	\N	Học kỳ 1	2025-05-11 12:12:23.442853
1276	16	17	\N	Học kỳ 1	2025-05-11 12:12:23.445865
1277	19	17	\N	Học kỳ 1	2025-05-11 12:12:23.449847
1278	17	17	\N	Học kỳ 1	2025-05-11 12:12:23.453851
1279	18	17	\N	Học kỳ 1	2025-05-11 12:12:23.456839
1280	22	17	\N	Học kỳ 1	2025-05-11 12:12:23.460854
1281	23	17	\N	Học kỳ 1	2025-05-11 12:12:23.463852
1282	25	17	\N	Học kỳ 1	2025-05-11 12:12:23.468831
1283	26	17	\N	Học kỳ 1	2025-05-11 12:12:23.472861
1284	24	17	\N	Học kỳ 1	2025-05-11 12:12:23.476902
1285	27	17	\N	Học kỳ 1	2025-05-11 12:12:23.479891
1286	31	17	\N	Học kỳ 1	2025-05-11 12:12:23.483892
1287	32	17	\N	Học kỳ 1	2025-05-11 12:12:23.487891
1288	33	17	\N	Học kỳ 1	2025-05-11 12:12:23.491472
1289	34	17	\N	Học kỳ 1	2025-05-11 12:12:23.49546
1290	30	17	\N	Học kỳ 1	2025-05-11 12:12:23.499462
1291	29	17	\N	Học kỳ 1	2025-05-11 12:12:23.503471
1292	35	17	\N	Học kỳ 1	2025-05-11 12:12:23.50746
1293	36	17	\N	Học kỳ 1	2025-05-11 12:12:23.510474
1294	37	17	\N	Học kỳ 1	2025-05-11 12:12:23.513475
1295	38	17	\N	Học kỳ 1	2025-05-11 12:12:23.517445
1296	39	17	\N	Học kỳ 1	2025-05-11 12:12:23.52146
1297	40	17	\N	Học kỳ 1	2025-05-11 12:12:23.525504
1298	41	17	\N	Học kỳ 1	2025-05-11 12:12:23.528739
1299	42	17	\N	Học kỳ 1	2025-05-11 12:12:23.531503
1300	45	17	\N	Học kỳ 1	2025-05-11 12:12:23.536505
1301	46	17	\N	Học kỳ 1	2025-05-11 12:12:23.540011
1302	47	17	\N	Học kỳ 1	2025-05-11 12:12:23.543052
1303	48	17	\N	Học kỳ 1	2025-05-11 12:12:23.547052
1304	50	17	\N	Học kỳ 1	2025-05-11 12:12:23.551043
1305	49	17	\N	Học kỳ 1	2025-05-11 12:12:23.55404
1306	20	17	\N	Học kỳ 2	2025-05-11 12:12:23.6327
1307	21	17	\N	Học kỳ 2	2025-05-11 12:12:23.636698
1308	28	17	\N	Học kỳ 2	2025-05-11 12:12:23.641201
1309	43	17	\N	Học kỳ 2	2025-05-11 12:12:23.645212
1310	44	17	\N	Học kỳ 2	2025-05-11 12:12:23.64922
1311	51	17	\N	Học kỳ 2	2025-05-11 12:12:23.653223
1312	52	17	\N	Học kỳ 2	2025-05-11 12:12:23.657249
1313	53	17	\N	Học kỳ 2	2025-05-11 12:12:23.660237
1314	54	17	\N	Học kỳ 2	2025-05-11 12:12:23.664245
1315	55	17	\N	Học kỳ 2	2025-05-11 12:12:23.668236
1316	56	17	\N	Học kỳ 2	2025-05-11 12:12:23.672234
1317	57	17	\N	Học kỳ 2	2025-05-11 12:12:23.676245
1318	12	17	\N	Học kỳ 2	2025-05-11 12:12:23.679288
1319	13	17	\N	Học kỳ 2	2025-05-11 12:12:23.682289
1320	14	17	\N	Học kỳ 2	2025-05-11 12:12:23.686279
1321	15	17	\N	Học kỳ 2	2025-05-11 12:12:23.690286
1322	16	17	\N	Học kỳ 2	2025-05-11 12:12:23.693855
1323	19	17	\N	Học kỳ 2	2025-05-11 12:12:23.697067
1324	17	17	\N	Học kỳ 2	2025-05-11 12:12:23.700848
1325	18	17	\N	Học kỳ 2	2025-05-11 12:12:23.705049
1326	22	17	\N	Học kỳ 2	2025-05-11 12:12:23.707846
1327	23	17	\N	Học kỳ 2	2025-05-11 12:12:23.711846
1328	25	17	\N	Học kỳ 2	2025-05-11 12:12:23.714857
1329	26	17	\N	Học kỳ 2	2025-05-11 12:12:23.71883
1330	24	17	\N	Học kỳ 2	2025-05-11 12:12:23.722837
1331	27	17	\N	Học kỳ 2	2025-05-11 12:12:23.726823
1332	31	17	\N	Học kỳ 2	2025-05-11 12:12:23.729837
1333	32	17	\N	Học kỳ 2	2025-05-11 12:12:23.733835
1334	33	17	\N	Học kỳ 2	2025-05-11 12:12:23.737862
1335	34	17	\N	Học kỳ 2	2025-05-11 12:12:23.740863
1336	30	17	\N	Học kỳ 2	2025-05-11 12:12:23.745445
1337	29	17	\N	Học kỳ 2	2025-05-11 12:12:23.748437
1338	35	17	\N	Học kỳ 2	2025-05-11 12:12:23.753437
1339	36	17	\N	Học kỳ 2	2025-05-11 12:12:23.756439
1340	37	17	\N	Học kỳ 2	2025-05-11 12:12:23.759452
1341	38	17	\N	Học kỳ 2	2025-05-11 12:12:23.763437
1342	39	17	\N	Học kỳ 2	2025-05-11 12:12:23.766438
1343	40	17	\N	Học kỳ 2	2025-05-11 12:12:23.770386
1344	41	17	\N	Học kỳ 2	2025-05-11 12:12:23.774387
1345	42	17	\N	Học kỳ 2	2025-05-11 12:12:23.777384
1346	45	17	\N	Học kỳ 2	2025-05-11 12:12:23.780423
1347	46	17	\N	Học kỳ 2	2025-05-11 12:12:23.784402
1348	47	17	\N	Học kỳ 2	2025-05-11 12:12:23.7887
1349	48	17	\N	Học kỳ 2	2025-05-11 12:12:23.791423
1350	50	17	\N	Học kỳ 2	2025-05-11 12:12:23.795995
1351	49	17	\N	Học kỳ 2	2025-05-11 12:12:23.799007
1352	20	18	\N	Học kỳ 1	2025-05-11 12:12:24.525571
1353	21	18	\N	Học kỳ 1	2025-05-11 12:12:24.528571
1354	28	18	\N	Học kỳ 1	2025-05-11 12:12:24.531571
1355	43	18	\N	Học kỳ 1	2025-05-11 12:12:24.535602
1356	44	18	\N	Học kỳ 1	2025-05-11 12:12:24.5386
1357	51	18	\N	Học kỳ 1	2025-05-11 12:12:24.542614
1358	52	18	\N	Học kỳ 1	2025-05-11 12:12:24.545615
1359	53	18	\N	Học kỳ 1	2025-05-11 12:12:24.54869
1360	54	18	\N	Học kỳ 1	2025-05-11 12:12:24.551732
1361	55	18	\N	Học kỳ 1	2025-05-11 12:12:24.554739
1362	56	18	\N	Học kỳ 1	2025-05-11 12:12:24.558735
1363	57	18	\N	Học kỳ 1	2025-05-11 12:12:24.561734
1364	12	18	\N	Học kỳ 1	2025-05-11 12:12:24.564734
1365	13	18	\N	Học kỳ 1	2025-05-11 12:12:24.567725
1366	14	18	\N	Học kỳ 1	2025-05-11 12:12:24.570735
1367	15	18	\N	Học kỳ 1	2025-05-11 12:12:24.574735
1368	16	18	\N	Học kỳ 1	2025-05-11 12:12:24.577732
1369	19	18	\N	Học kỳ 1	2025-05-11 12:12:24.580732
1370	17	18	\N	Học kỳ 1	2025-05-11 12:12:24.583719
1371	18	18	\N	Học kỳ 1	2025-05-11 12:12:24.586738
1372	22	18	\N	Học kỳ 1	2025-05-11 12:12:24.59075
1373	23	18	\N	Học kỳ 1	2025-05-11 12:12:24.593763
1374	25	18	\N	Học kỳ 1	2025-05-11 12:12:24.596764
1375	26	18	\N	Học kỳ 1	2025-05-11 12:12:24.600348
1376	24	18	\N	Học kỳ 1	2025-05-11 12:12:24.603357
1377	27	18	\N	Học kỳ 1	2025-05-11 12:12:24.607357
1378	31	18	\N	Học kỳ 1	2025-05-11 12:12:24.610357
1379	32	18	\N	Học kỳ 1	2025-05-11 12:12:24.613355
1380	33	18	\N	Học kỳ 1	2025-05-11 12:12:24.616355
1381	34	18	\N	Học kỳ 1	2025-05-11 12:12:24.619348
1382	30	18	\N	Học kỳ 1	2025-05-11 12:12:24.622355
1383	29	18	\N	Học kỳ 1	2025-05-11 12:12:24.626355
1384	35	18	\N	Học kỳ 1	2025-05-11 12:12:24.628355
1385	36	18	\N	Học kỳ 1	2025-05-11 12:12:24.632358
1386	37	18	\N	Học kỳ 1	2025-05-11 12:12:24.636385
1387	38	18	\N	Học kỳ 1	2025-05-11 12:12:24.640385
1388	39	18	\N	Học kỳ 1	2025-05-11 12:12:24.643404
1389	40	18	\N	Học kỳ 1	2025-05-11 12:12:24.647394
1390	41	18	\N	Học kỳ 1	2025-05-11 12:12:24.650931
1391	42	18	\N	Học kỳ 1	2025-05-11 12:12:24.654961
1392	45	18	\N	Học kỳ 1	2025-05-11 12:12:24.657962
1393	46	18	\N	Học kỳ 1	2025-05-11 12:12:24.66195
1394	47	18	\N	Học kỳ 1	2025-05-11 12:12:24.665965
1395	48	18	\N	Học kỳ 1	2025-05-11 12:12:24.670953
1396	50	18	\N	Học kỳ 1	2025-05-11 12:12:24.674961
1397	49	18	\N	Học kỳ 1	2025-05-11 12:12:24.677961
1398	20	18	\N	Học kỳ 2	2025-05-11 12:12:24.744602
1399	21	18	\N	Học kỳ 2	2025-05-11 12:12:24.747594
1400	28	18	\N	Học kỳ 2	2025-05-11 12:12:24.752133
1401	43	18	\N	Học kỳ 2	2025-05-11 12:12:24.755164
1402	44	18	\N	Học kỳ 2	2025-05-11 12:12:24.758165
1403	51	18	\N	Học kỳ 2	2025-05-11 12:12:24.761165
1404	52	18	\N	Học kỳ 2	2025-05-11 12:12:24.764165
1405	53	18	\N	Học kỳ 2	2025-05-11 12:12:24.768161
1406	54	18	\N	Học kỳ 2	2025-05-11 12:12:24.771148
1407	55	18	\N	Học kỳ 2	2025-05-11 12:12:24.775148
1408	56	18	\N	Học kỳ 2	2025-05-11 12:12:24.778157
1409	57	18	\N	Học kỳ 2	2025-05-11 12:12:24.781159
1410	12	18	\N	Học kỳ 2	2025-05-11 12:12:24.784144
1411	13	18	\N	Học kỳ 2	2025-05-11 12:12:24.788198
1412	14	18	\N	Học kỳ 2	2025-05-11 12:12:24.791204
1413	15	18	\N	Học kỳ 2	2025-05-11 12:12:24.795193
1414	16	18	\N	Học kỳ 2	2025-05-11 12:12:24.798193
1415	19	18	\N	Học kỳ 2	2025-05-11 12:12:24.801756
1416	17	18	\N	Học kỳ 2	2025-05-11 12:12:24.804767
1417	18	18	\N	Học kỳ 2	2025-05-11 12:12:24.807767
1418	22	18	\N	Học kỳ 2	2025-05-11 12:12:24.811767
1419	23	18	\N	Học kỳ 2	2025-05-11 12:12:24.813765
1420	25	18	\N	Học kỳ 2	2025-05-11 12:12:24.817747
1421	26	18	\N	Học kỳ 2	2025-05-11 12:12:24.820756
1422	24	18	\N	Học kỳ 2	2025-05-11 12:12:24.824768
1423	27	18	\N	Học kỳ 2	2025-05-11 12:12:24.828765
1424	31	18	\N	Học kỳ 2	2025-05-11 12:12:24.831768
1425	32	18	\N	Học kỳ 2	2025-05-11 12:12:24.834756
1426	33	18	\N	Học kỳ 2	2025-05-11 12:12:24.837794
1427	34	18	\N	Học kỳ 2	2025-05-11 12:12:24.841795
1428	30	18	\N	Học kỳ 2	2025-05-11 12:12:24.844794
1429	29	18	\N	Học kỳ 2	2025-05-11 12:12:24.848784
1430	35	18	\N	Học kỳ 2	2025-05-11 12:12:24.852358
1431	36	18	\N	Học kỳ 2	2025-05-11 12:12:24.856377
1432	37	18	\N	Học kỳ 2	2025-05-11 12:12:24.86038
1433	38	18	\N	Học kỳ 2	2025-05-11 12:12:24.864377
1434	39	18	\N	Học kỳ 2	2025-05-11 12:12:24.867351
1435	40	18	\N	Học kỳ 2	2025-05-11 12:12:24.871378
1436	41	18	\N	Học kỳ 2	2025-05-11 12:12:24.874377
1437	42	18	\N	Học kỳ 2	2025-05-11 12:12:24.877375
1438	45	18	\N	Học kỳ 2	2025-05-11 12:12:24.880378
1439	46	18	\N	Học kỳ 2	2025-05-11 12:12:24.883375
1440	47	18	\N	Học kỳ 2	2025-05-11 12:12:24.886376
1441	48	18	\N	Học kỳ 2	2025-05-11 12:12:24.889414
1442	50	18	\N	Học kỳ 2	2025-05-11 12:12:24.893416
1443	49	18	\N	Học kỳ 2	2025-05-11 12:12:24.896377
1444	20	19	\N	Học kỳ 1	2025-05-11 12:12:25.611425
1445	21	19	\N	Học kỳ 1	2025-05-11 12:12:25.614459
1446	28	19	\N	Học kỳ 1	2025-05-11 12:12:25.618448
1447	43	19	\N	Học kỳ 1	2025-05-11 12:12:25.622431
1448	44	19	\N	Học kỳ 1	2025-05-11 12:12:25.62546
1449	51	19	\N	Học kỳ 1	2025-05-11 12:12:25.629457
1450	52	19	\N	Học kỳ 1	2025-05-11 12:12:25.632459
1451	53	19	\N	Học kỳ 1	2025-05-11 12:12:25.637439
1452	54	19	\N	Học kỳ 1	2025-05-11 12:12:25.641456
1453	55	19	\N	Học kỳ 1	2025-05-11 12:12:25.644493
1454	56	19	\N	Học kỳ 1	2025-05-11 12:12:25.647489
1455	57	19	\N	Học kỳ 1	2025-05-11 12:12:25.651501
1456	12	19	\N	Học kỳ 1	2025-05-11 12:12:25.655488
1457	13	19	\N	Học kỳ 1	2025-05-11 12:12:25.660061
1458	14	19	\N	Học kỳ 1	2025-05-11 12:12:25.663061
1459	15	19	\N	Học kỳ 1	2025-05-11 12:12:25.666062
1460	16	19	\N	Học kỳ 1	2025-05-11 12:12:25.67005
1461	19	19	\N	Học kỳ 1	2025-05-11 12:12:25.67404
1462	17	19	\N	Học kỳ 1	2025-05-11 12:12:25.677036
1463	18	19	\N	Học kỳ 1	2025-05-11 12:12:25.681067
1464	22	19	\N	Học kỳ 1	2025-05-11 12:12:25.685049
1465	23	19	\N	Học kỳ 1	2025-05-11 12:12:25.68903
1466	25	19	\N	Học kỳ 1	2025-05-11 12:12:25.693065
1467	26	19	\N	Học kỳ 1	2025-05-11 12:12:25.696109
1468	24	19	\N	Học kỳ 1	2025-05-11 12:12:25.699113
1469	27	19	\N	Học kỳ 1	2025-05-11 12:12:25.703103
1470	31	19	\N	Học kỳ 1	2025-05-11 12:12:25.707082
1471	32	19	\N	Học kỳ 1	2025-05-11 12:12:25.710621
1472	33	19	\N	Học kỳ 1	2025-05-11 12:12:25.714629
1473	34	19	\N	Học kỳ 1	2025-05-11 12:12:25.718644
1474	30	19	\N	Học kỳ 1	2025-05-11 12:12:25.72262
1475	29	19	\N	Học kỳ 1	2025-05-11 12:12:25.726618
1476	35	19	\N	Học kỳ 1	2025-05-11 12:12:25.72962
1477	36	19	\N	Học kỳ 1	2025-05-11 12:12:25.734631
1478	37	19	\N	Học kỳ 1	2025-05-11 12:12:25.737625
1479	38	19	\N	Học kỳ 1	2025-05-11 12:12:25.741614
1480	39	19	\N	Học kỳ 1	2025-05-11 12:12:25.745671
1481	40	19	\N	Học kỳ 1	2025-05-11 12:12:25.749075
1482	41	19	\N	Học kỳ 1	2025-05-11 12:12:25.752652
1483	42	19	\N	Học kỳ 1	2025-05-11 12:12:25.756663
1484	45	19	\N	Học kỳ 1	2025-05-11 12:12:25.760222
1485	46	19	\N	Học kỳ 1	2025-05-11 12:12:25.764208
1486	47	19	\N	Học kỳ 1	2025-05-11 12:12:25.767232
1487	48	19	\N	Học kỳ 1	2025-05-11 12:12:25.77123
1488	50	19	\N	Học kỳ 1	2025-05-11 12:12:25.77524
1489	49	19	\N	Học kỳ 1	2025-05-11 12:12:25.77923
1490	20	19	\N	Học kỳ 2	2025-05-11 12:12:25.858903
1491	21	19	\N	Học kỳ 2	2025-05-11 12:12:25.862463
1492	28	19	\N	Học kỳ 2	2025-05-11 12:12:25.866443
1493	43	19	\N	Học kỳ 2	2025-05-11 12:12:25.870447
1494	44	19	\N	Học kỳ 2	2025-05-11 12:12:25.87446
1495	51	19	\N	Học kỳ 2	2025-05-11 12:12:25.877457
1496	52	19	\N	Học kỳ 2	2025-05-11 12:12:25.880458
1497	53	19	\N	Học kỳ 2	2025-05-11 12:12:25.884458
1498	54	19	\N	Học kỳ 2	2025-05-11 12:12:25.888446
1499	55	19	\N	Học kỳ 2	2025-05-11 12:12:25.892465
1500	56	19	\N	Học kỳ 2	2025-05-11 12:12:25.896772
1501	57	19	\N	Học kỳ 2	2025-05-11 12:12:25.899494
1502	12	19	\N	Học kỳ 2	2025-05-11 12:12:25.903506
1503	13	19	\N	Học kỳ 2	2025-05-11 12:12:25.907483
1504	14	19	\N	Học kỳ 2	2025-05-11 12:12:25.910481
1505	15	19	\N	Học kỳ 2	2025-05-11 12:12:25.914962
1506	16	19	\N	Học kỳ 2	2025-05-11 12:12:25.917963
1507	19	19	\N	Học kỳ 2	2025-05-11 12:12:25.921974
1508	17	19	\N	Học kỳ 2	2025-05-11 12:12:25.925987
1509	18	19	\N	Học kỳ 2	2025-05-11 12:12:25.928985
1510	22	19	\N	Học kỳ 2	2025-05-11 12:12:25.932985
1511	23	19	\N	Học kỳ 2	2025-05-11 12:12:25.935974
1512	25	19	\N	Học kỳ 2	2025-05-11 12:12:25.94099
1513	26	19	\N	Học kỳ 2	2025-05-11 12:12:25.943995
1514	24	19	\N	Học kỳ 2	2025-05-11 12:12:25.948038
1515	27	19	\N	Học kỳ 2	2025-05-11 12:12:25.95104
1516	31	19	\N	Học kỳ 2	2025-05-11 12:12:25.955031
1517	32	19	\N	Học kỳ 2	2025-05-11 12:12:25.958024
1518	33	19	\N	Học kỳ 2	2025-05-11 12:12:25.961547
1519	34	19	\N	Học kỳ 2	2025-05-11 12:12:25.963588
1520	30	19	\N	Học kỳ 2	2025-05-11 12:12:25.967591
1521	29	19	\N	Học kỳ 2	2025-05-11 12:12:25.972591
1522	35	19	\N	Học kỳ 2	2025-05-11 12:12:25.975591
1523	36	19	\N	Học kỳ 2	2025-05-11 12:12:25.978592
1524	37	19	\N	Học kỳ 2	2025-05-11 12:12:25.982584
1525	38	19	\N	Học kỳ 2	2025-05-11 12:12:25.986578
1526	39	19	\N	Học kỳ 2	2025-05-11 12:12:25.990568
1527	40	19	\N	Học kỳ 2	2025-05-11 12:12:25.994576
1528	41	19	\N	Học kỳ 2	2025-05-11 12:12:25.998618
1529	42	19	\N	Học kỳ 2	2025-05-11 12:12:26.003598
1530	45	19	\N	Học kỳ 2	2025-05-11 12:12:26.007603
1531	46	19	\N	Học kỳ 2	2025-05-11 12:12:26.010603
1532	47	19	\N	Học kỳ 2	2025-05-11 12:12:26.015154
1533	48	19	\N	Học kỳ 2	2025-05-11 12:12:26.019153
1534	50	19	\N	Học kỳ 2	2025-05-11 12:12:26.023155
1535	49	19	\N	Học kỳ 2	2025-05-11 12:12:26.026153
1536	20	20	\N	Học kỳ 1	2025-05-11 12:12:26.802472
1537	21	20	\N	Học kỳ 1	2025-05-11 12:12:26.806485
1538	28	20	\N	Học kỳ 1	2025-05-11 12:12:26.809483
1539	43	20	\N	Học kỳ 1	2025-05-11 12:12:26.813483
1540	44	20	\N	Học kỳ 1	2025-05-11 12:12:26.816479
1541	51	20	\N	Học kỳ 1	2025-05-11 12:12:26.821013
1542	52	20	\N	Học kỳ 1	2025-05-11 12:12:26.825016
1543	53	20	\N	Học kỳ 1	2025-05-11 12:12:26.828011
1544	54	20	\N	Học kỳ 1	2025-05-11 12:12:26.832034
1545	55	20	\N	Học kỳ 1	2025-05-11 12:12:26.83504
1546	56	20	\N	Học kỳ 1	2025-05-11 12:12:26.839022
1547	57	20	\N	Học kỳ 1	2025-05-11 12:12:26.843023
1548	12	20	\N	Học kỳ 1	2025-05-11 12:12:26.848009
1549	13	20	\N	Học kỳ 1	2025-05-11 12:12:26.852015
1550	14	20	\N	Học kỳ 1	2025-05-11 12:12:26.857025
1551	15	20	\N	Học kỳ 1	2025-05-11 12:12:26.862023
1552	16	20	\N	Học kỳ 1	2025-05-11 12:12:26.86702
1553	19	20	\N	Học kỳ 1	2025-05-11 12:12:26.87058
1554	17	20	\N	Học kỳ 1	2025-05-11 12:12:26.875571
1555	18	20	\N	Học kỳ 1	2025-05-11 12:12:26.879573
1556	22	20	\N	Học kỳ 1	2025-05-11 12:12:26.883566
1557	23	20	\N	Học kỳ 1	2025-05-11 12:12:26.888572
1558	25	20	\N	Học kỳ 1	2025-05-11 12:12:26.891588
1559	26	20	\N	Học kỳ 1	2025-05-11 12:12:26.894597
1560	24	20	\N	Học kỳ 1	2025-05-11 12:12:26.897597
1561	27	20	\N	Học kỳ 1	2025-05-11 12:12:26.900597
1562	31	20	\N	Học kỳ 1	2025-05-11 12:12:26.9046
1563	32	20	\N	Học kỳ 1	2025-05-11 12:12:26.907639
1564	33	20	\N	Học kỳ 1	2025-05-11 12:12:26.911639
1565	34	20	\N	Học kỳ 1	2025-05-11 12:12:26.914639
1566	30	20	\N	Học kỳ 1	2025-05-11 12:12:26.917639
1567	29	20	\N	Học kỳ 1	2025-05-11 12:12:26.921181
1568	35	20	\N	Học kỳ 1	2025-05-11 12:12:26.92518
1569	36	20	\N	Học kỳ 1	2025-05-11 12:12:26.92818
1570	37	20	\N	Học kỳ 1	2025-05-11 12:12:26.933183
1571	38	20	\N	Học kỳ 1	2025-05-11 12:12:26.937183
1572	39	20	\N	Học kỳ 1	2025-05-11 12:12:26.940196
1573	40	20	\N	Học kỳ 1	2025-05-11 12:12:26.943209
1574	41	20	\N	Học kỳ 1	2025-05-11 12:12:26.946209
1575	42	20	\N	Học kỳ 1	2025-05-11 12:12:26.949211
1576	45	20	\N	Học kỳ 1	2025-05-11 12:12:26.953185
1577	46	20	\N	Học kỳ 1	2025-05-11 12:12:26.957226
1578	47	20	\N	Học kỳ 1	2025-05-11 12:12:26.961214
1579	48	20	\N	Học kỳ 1	2025-05-11 12:12:26.966237
1580	50	20	\N	Học kỳ 1	2025-05-11 12:12:26.969214
1581	49	20	\N	Học kỳ 1	2025-05-11 12:12:26.973755
1582	20	20	\N	Học kỳ 2	2025-05-11 12:12:27.058299
1583	21	20	\N	Học kỳ 2	2025-05-11 12:12:27.061333
1584	28	20	\N	Học kỳ 2	2025-05-11 12:12:27.064332
1585	43	20	\N	Học kỳ 2	2025-05-11 12:12:27.068332
1586	44	20	\N	Học kỳ 2	2025-05-11 12:12:27.07184
1587	51	20	\N	Học kỳ 2	2025-05-11 12:12:27.075863
1588	52	20	\N	Học kỳ 2	2025-05-11 12:12:27.079861
1589	53	20	\N	Học kỳ 2	2025-05-11 12:12:27.082856
1590	54	20	\N	Học kỳ 2	2025-05-11 12:12:27.086855
1591	55	20	\N	Học kỳ 2	2025-05-11 12:12:27.090862
1592	56	20	\N	Học kỳ 2	2025-05-11 12:12:27.093861
1593	57	20	\N	Học kỳ 2	2025-05-11 12:12:27.097849
1594	12	20	\N	Học kỳ 2	2025-05-11 12:12:27.100884
1595	13	20	\N	Học kỳ 2	2025-05-11 12:12:27.104861
1596	14	20	\N	Học kỳ 2	2025-05-11 12:12:27.10787
1597	15	20	\N	Học kỳ 2	2025-05-11 12:12:27.111871
1598	16	20	\N	Học kỳ 2	2025-05-11 12:12:27.115868
1599	19	20	\N	Học kỳ 2	2025-05-11 12:12:27.120877
1600	17	20	\N	Học kỳ 2	2025-05-11 12:12:27.125407
1601	18	20	\N	Học kỳ 2	2025-05-11 12:12:27.130413
1602	22	20	\N	Học kỳ 2	2025-05-11 12:12:27.134411
1603	23	20	\N	Học kỳ 2	2025-05-11 12:12:27.141415
1604	25	20	\N	Học kỳ 2	2025-05-11 12:12:27.146412
1605	26	20	\N	Học kỳ 2	2025-05-11 12:12:27.15041
1606	24	20	\N	Học kỳ 2	2025-05-11 12:12:27.155415
1607	27	20	\N	Học kỳ 2	2025-05-11 12:12:27.159413
1608	31	20	\N	Học kỳ 2	2025-05-11 12:12:27.162414
1609	32	20	\N	Học kỳ 2	2025-05-11 12:12:27.165414
1610	33	20	\N	Học kỳ 2	2025-05-11 12:12:27.168414
1611	34	20	\N	Học kỳ 2	2025-05-11 12:12:27.173948
1612	30	20	\N	Học kỳ 2	2025-05-11 12:12:27.177949
1613	29	20	\N	Học kỳ 2	2025-05-11 12:12:27.18296
1614	35	20	\N	Học kỳ 2	2025-05-11 12:12:27.186955
1615	36	20	\N	Học kỳ 2	2025-05-11 12:12:27.190957
1616	37	20	\N	Học kỳ 2	2025-05-11 12:12:27.194959
1617	38	20	\N	Học kỳ 2	2025-05-11 12:12:27.197954
1618	39	20	\N	Học kỳ 2	2025-05-11 12:12:27.201954
1619	40	20	\N	Học kỳ 2	2025-05-11 12:12:27.205951
1620	41	20	\N	Học kỳ 2	2025-05-11 12:12:27.20897
1621	42	20	\N	Học kỳ 2	2025-05-11 12:12:27.212972
1622	45	20	\N	Học kỳ 2	2025-05-11 12:12:27.21597
1623	46	20	\N	Học kỳ 2	2025-05-11 12:12:27.219974
1624	47	20	\N	Học kỳ 2	2025-05-11 12:12:27.223481
1625	48	20	\N	Học kỳ 2	2025-05-11 12:12:27.227498
1626	50	20	\N	Học kỳ 2	2025-05-11 12:12:27.230496
1627	49	20	\N	Học kỳ 2	2025-05-11 12:12:27.234501
59	46	20	9.58	HK1	2025-05-11 12:14:20.210168
40	25	20	7.7	HK1	2025-05-11 12:45:07.286548
\.


--
-- TOC entry 5190 (class 0 OID 27594)
-- Dependencies: 241
-- Data for Name: message_files; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.message_files ("FileID", "FileName", "FileSize", "ContentType", "SubmittedAt", "MessageID") FROM stdin;
\.


--
-- TOC entry 5175 (class 0 OID 27449)
-- Dependencies: 226
-- Data for Name: messages; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.messages ("MessageID", "ConversationID", "UserID", "Content", "SentAt") FROM stdin;
1	1	4	Kính chào anh Minh, tôi là Lê Văn Cường, giáo viên chủ nhiệm lớp 10A1 của cháu An...	2025-01-20 10:05:00
2	1	8	Chào thầy Cường, tôi là Minh, phụ huynh cháu An...	2025-01-20 10:06:00
7	15	2	chào ae	2025-05-11 11:51:05.788858
8	15	2	1 kì học mới bùng nổ nhé	2025-05-11 11:51:21.096371
\.


--
-- TOC entry 5201 (class 0 OID 27699)
-- Dependencies: 252
-- Data for Name: parent_students; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.parent_students ("RelationshipID", "Relationship", "ParentID", "StudentID") FROM stdin;
1	FATHER	8	12
2	MOTHER	9	13
3	FATHER	10	14
4	MOTHER	11	15
5	FATHER	8	16
6	MOTHER	9	17
\.


--
-- TOC entry 5180 (class 0 OID 27515)
-- Dependencies: 231
-- Data for Name: parents; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.parents ("ParentID", "Occupation") FROM stdin;
8	Kỹ sư phần mềm
9	Bác sĩ
10	Giáo viên tiểu học
11	Kinh doanh tự do
\.


--
-- TOC entry 5177 (class 0 OID 27469)
-- Dependencies: 228
-- Data for Name: participations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.participations ("ParticipationID", "ConversationID", "UserID", "JoinedAt") FROM stdin;
1	1	4	2025-01-20 10:00:00
2	1	8	2025-01-20 10:00:00
33	15	2	2025-05-11 11:41:46.193455
34	16	2	2025-05-11 11:41:46.218188
35	15	12	2025-05-11 11:49:38.064142
36	16	8	2025-05-11 11:49:38.086353
37	15	13	2025-05-11 11:49:38.145141
38	16	9	2025-05-11 11:49:38.158772
39	15	14	2025-05-11 11:50:00.121143
40	16	10	2025-05-11 11:50:00.13529
41	15	15	2025-05-11 11:50:00.170069
42	16	11	2025-05-11 11:50:00.182357
43	15	16	2025-05-11 11:50:00.20616
44	15	19	2025-05-11 11:50:00.233134
45	15	17	2025-05-11 11:50:00.256965
46	15	18	2025-05-11 11:50:00.298808
47	15	22	2025-05-11 11:50:00.320262
48	15	23	2025-05-11 11:50:00.342985
49	15	25	2025-05-11 11:50:00.365819
50	15	26	2025-05-11 11:50:00.386952
51	15	24	2025-05-11 11:50:00.408042
52	15	27	2025-05-11 11:50:00.429294
53	15	31	2025-05-11 11:50:00.44954
54	15	32	2025-05-11 11:50:00.469045
55	15	33	2025-05-11 11:50:00.487476
56	15	34	2025-05-11 11:50:00.509274
57	15	30	2025-05-11 11:50:00.537008
58	15	29	2025-05-11 11:50:00.558036
59	15	35	2025-05-11 11:50:00.579394
60	15	36	2025-05-11 11:50:00.602974
61	15	37	2025-05-11 11:50:00.62408
62	15	38	2025-05-11 11:50:00.6438
63	15	39	2025-05-11 11:50:00.663952
64	15	40	2025-05-11 11:50:00.687333
65	15	41	2025-05-11 11:50:00.706076
66	15	42	2025-05-11 11:50:00.725956
67	15	45	2025-05-11 11:50:00.746852
68	15	46	2025-05-11 11:50:00.772719
69	15	47	2025-05-11 11:50:00.799897
70	15	48	2025-05-11 11:50:00.820077
71	15	50	2025-05-11 11:50:00.839636
72	15	49	2025-05-11 11:50:00.861545
73	15	20	2025-05-11 11:50:14.399373
74	15	21	2025-05-11 11:50:14.433606
75	15	28	2025-05-11 11:50:14.461046
76	15	43	2025-05-11 11:50:14.483174
77	15	44	2025-05-11 11:50:14.507088
78	15	51	2025-05-11 11:50:14.527858
79	15	52	2025-05-11 11:50:14.549928
80	15	53	2025-05-11 11:50:14.571274
81	15	54	2025-05-11 11:50:14.592568
82	15	55	2025-05-11 11:50:14.62799
83	15	56	2025-05-11 11:50:14.650798
84	15	57	2025-05-11 11:50:14.674204
\.


--
-- TOC entry 5197 (class 0 OID 27669)
-- Dependencies: 248
-- Data for Name: petition_files; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.petition_files ("FileID", "FileName", "FilePath", "FileSize", "ContentType", "SubmittedAt", "PetitionID") FROM stdin;
\.


--
-- TOC entry 5188 (class 0 OID 27574)
-- Dependencies: 239
-- Data for Name: petitions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.petitions ("PetitionID", "ParentID", "AdminID", "Title", "Content", "Status", "SubmittedAt", "Response") FROM stdin;
\.


--
-- TOC entry 5207 (class 0 OID 27757)
-- Dependencies: 258
-- Data for Name: post_files; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.post_files ("FileID", "FileName", "FilePath", "FileSize", "ContentType", "SubmittedAt", "PostID") FROM stdin;
\.


--
-- TOC entry 5205 (class 0 OID 27737)
-- Dependencies: 256
-- Data for Name: reward_punishments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.reward_punishments ("RecordID", "Title", "Type", "Description", "Date", "Semester", "Week", "StudentID", "AdminID") FROM stdin;
\.


--
-- TOC entry 5191 (class 0 OID 27608)
-- Dependencies: 242
-- Data for Name: students; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.students ("StudentID", "ClassID", "EnrollmentDate", "YtDate") FROM stdin;
20	14	2025-05-11 11:26:08.205719	\N
21	14	2025-05-11 11:26:08.664333	\N
28	14	2025-05-11 11:26:12.005424	\N
43	14	2025-05-11 11:26:19.181196	\N
44	14	2025-05-11 11:26:19.672396	\N
51	14	2025-05-11 11:26:23.015233	\N
52	14	2025-05-11 11:26:23.485115	\N
53	14	2025-05-11 11:26:23.963988	\N
54	14	2025-05-11 11:26:24.443938	\N
55	14	2025-05-11 11:26:24.927482	\N
56	14	2025-05-11 11:26:25.404235	\N
57	14	2025-05-11 11:26:25.87688	\N
12	14	2025-05-11 09:36:46.561713	2024-08-15 07:00:00
13	14	2025-05-11 09:36:57.563639	2024-08-15 07:00:00
14	14	2025-05-11 09:37:10.104459	2023-08-15 07:00:00
15	14	2025-05-11 09:37:22.594559	2023-08-15 07:00:00
16	14	2025-05-11 09:37:56.914082	2022-08-15 07:00:00
19	14	2025-05-11 11:26:07.738442	\N
17	14	2025-05-11 09:38:08.126922	2022-08-15 07:00:00
18	14	2025-05-11 11:26:07.259383	\N
22	14	2025-05-11 11:26:09.128083	\N
23	14	2025-05-11 11:26:09.609247	\N
25	14	2025-05-11 11:26:10.563317	\N
26	14	2025-05-11 11:26:11.054084	\N
24	14	2025-05-11 11:26:10.081688	\N
27	14	2025-05-11 11:26:11.525059	\N
31	14	2025-05-11 11:26:13.448323	\N
32	14	2025-05-11 11:26:13.93102	\N
33	14	2025-05-11 11:26:14.409437	\N
34	14	2025-05-11 11:26:14.877921	\N
30	14	2025-05-11 11:26:12.978279	\N
29	14	2025-05-11 11:26:12.510057	\N
35	14	2025-05-11 11:26:15.343567	\N
36	14	2025-05-11 11:26:15.81102	\N
37	14	2025-05-11 11:26:16.290975	\N
38	14	2025-05-11 11:26:16.758014	\N
39	14	2025-05-11 11:26:17.224221	\N
40	14	2025-05-11 11:26:17.691571	\N
41	14	2025-05-11 11:26:18.159052	\N
42	14	2025-05-11 11:26:18.632882	\N
45	14	2025-05-11 11:26:20.145101	\N
46	14	2025-05-11 11:26:20.628863	\N
47	14	2025-05-11 11:26:21.102921	\N
48	14	2025-05-11 11:26:21.581396	\N
50	14	2025-05-11 11:26:22.531065	\N
49	14	2025-05-11 11:26:22.061294	\N
\.


--
-- TOC entry 5211 (class 0 OID 27792)
-- Dependencies: 262
-- Data for Name: subject_schedules; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.subject_schedules ("SubjectScheduleID", "ClassSubjectID", "StartPeriod", "EndPeriod", "Day") FROM stdin;
4	6	3	3	Monday
5	6	6	7	Wednesday
6	4	4	5	Monday
7	7	1	1	Monday
8	8	2	2	Monday
9	4	3	4	Friday
10	9	1	1	Wednesday
11	9	2	2	Friday
13	11	1	1	Tuesday
14	12	1	1	Thursday
15	13	1	1	Thursday
16	14	1	2	Saturday
17	15	3	4	Wednesday
19	17	2	4	Thursday
21	11	2	2	Wednesday
22	19	2	4	Tuesday
23	15	5	5	Thursday
24	17	1	1	Friday
25	11	3	4	Saturday
26	11	5	5	Tuesday
\.


--
-- TOC entry 5173 (class 0 OID 27437)
-- Dependencies: 224
-- Data for Name: subjects; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.subjects ("SubjectID", "SubjectName", "Description") FROM stdin;
1	Toán	Môn Toán học phổ thông
2	Ngữ Văn	Môn Ngữ Văn phổ thông
3	Tiếng Anh	Môn Tiếng Anh phổ thông
4	Vật Lý	Môn Vật Lý phổ thông
5	Hóa Học	Môn Hóa Học phổ thông
6	Sinh Học	Môn Sinh Học phổ thông
7	Lịch Sử	Môn Lịch Sử phổ thông
8	Địa Lý	Môn Địa Lý phổ thông
9	Giáo Dục Công Dân	Môn Giáo Dục Công Dân phổ thông
10	Tin Học	Môn Tin Học phổ thông
11	Thể Dục	Môn Thể Dục phổ thông
12	Giáo Dục Quốc Phòng - An Ninh	Môn Giáo Dục Quốc Phòng - An Ninh
13	Chào Cờ	Chào cờ đầu tuần
\.


--
-- TOC entry 5179 (class 0 OID 27498)
-- Dependencies: 230
-- Data for Name: teachers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.teachers ("TeacherID", "DepartmentID", "Graduate", "Degree", "Position") FROM stdin;
2	1	Đại học Sư phạm Hà Nội	Tiến sĩ	Hiệu trưởng
3	1	Đại học Sư phạm II	Thạc sĩ	Hiệu phó
4	2	Đại học Sư phạm Hà Nội	Thạc sĩ	Giáo viên
5	3	Đại học Khoa học Xã hội và Nhân văn	Cử nhân	Tổ trưởng
7	4	Đại học Ngoại Ngữ - ĐHQGHN	Cử nhân	Giáo viên
6	6	Đại học Khoa học Tự nhiên	Thạc sĩ	Giáo viên
\.


--
-- TOC entry 5167 (class 0 OID 27404)
-- Dependencies: 218
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users ("UserID", "FirstName", "LastName", "Street", "District", "City", "Email", "Password", "PhoneNumber", "DOB", "PlaceOfBirth", "Gender", "Address", "CreatedAt", "UpdatedAt", "Status", role) FROM stdin;
1	Kỹ Thuật	Viên	\N	\N	\N	techadmin.sys@example.com	$2b$12$.b/dISvB6lh6SCxCmUFK7OEgg/mtQZpJrI2Gj8WDR26ucsjxBghr2	0999999999	1980-01-01 07:00:00	Hà Nội	OTHER	Phòng Kỹ Thuật, Hà Nội	2025-05-11 09:33:31.648013	2025-05-11 09:33:31.648013	ACTIVE	admin
2	Anh	Nguyễn Văn	\N	\N	\N	hieutruong.cva@example.com	$2b$12$8yeB.jshhC99/4CluO0/Le9VW3aIJAETKpHsJHxQpD0Xo1iF8cVhi	0912345678	1970-01-01 07:00:00	Hà Nội	MALE	Số 10 Đường Thụy Khuê, Tây Hồ, Hà Nội	2025-05-11 09:34:38.786492	2025-05-11 09:34:38.786492	ACTIVE	teacher
3	Bình	Trần Thị	\N	\N	\N	hieupho.cva@example.com	$2b$12$5MbuMKEWysfhQglIAPCKoe2FSYKfujEG/1/rl0JtzJNnJzV6Ybksi	0912345679	1975-05-15 07:00:00	Hải Phòng	FEMALE	Số 12 Phố Phó Đức Chính, Ba Đình, Hà Nội	2025-05-11 09:34:49.46309	2025-05-11 09:34:49.46309	ACTIVE	teacher
4	Cường	Lê Văn	\N	\N	\N	cuong.lv.gv@example.com	$2b$12$dJGnF8nnSEL4oj1RWBwjIuYcCCMrOskLpPbQf.55KLmkqMrGdXKli	0987654321	1980-03-10 07:00:00	Hà Nội	MALE	Số 1 Phố Trần Duy Hưng, Cầu Giấy, Hà Nội	2025-05-11 09:34:59.061577	2025-05-11 09:34:59.061577	ACTIVE	teacher
5	Dung	Phạm Thị	\N	\N	\N	dung.pt.gv@example.com	$2b$12$gk6lA0h/kMdCoVg0mU8TSu1xKOJuKnacG/6XJBErLk9zI.SrgUrSq	0987654322	1985-07-20 07:00:00	Nam Định	FEMALE	Số 2 Ngõ Xã Đàn, Đống Đa, Hà Nội	2025-05-11 09:35:11.418786	2025-05-11 09:35:11.418786	ACTIVE	teacher
6	Giang	Hoàng Văn	\N	\N	\N	giang.hv.gv@example.com	$2b$12$It.UfyjjvEnpb1Gx154xpeoy4.a4gtJAnwxokruUIAJUCn//ahbZS	0987654323	1978-11-25 07:00:00	Hà Nội	MALE	Số 3 Đường Láng, Đống Đa, Hà Nội	2025-05-11 09:35:23.201448	2025-05-11 09:35:23.201448	ACTIVE	teacher
7	Hương	Vũ Thị	\N	\N	\N	huong.vt.gv@example.com	$2b$12$5mxR3n1W6IueePlJq5VZE.qWHoMaD7XUv20bisrAAktYfWt2xUDvi	0987654324	1990-01-30 07:00:00	Thái Bình	FEMALE	Số 4 Phố Hàng Bài, Hoàn Kiếm, Hà Nội	2025-05-11 09:35:35.145842	2025-05-11 09:35:35.145842	ACTIVE	teacher
8	Minh	Nguyễn Văn An	\N	\N	\N	minh.nva.ph@example.com	$2b$12$PxjlZqV61dKW/.kjkyE.AODP8MpQQzRppzy4HtfB.O360Burg09cC	0911223344	1975-02-10 07:00:00	Hà Nội	MALE	Số 50 Đường Nguyễn Trãi, Thanh Xuân, Hà Nội	2025-05-11 09:36:02.407003	2025-05-11 09:36:02.407003	ACTIVE	parent
9	Nga	Trần Thị Bích	\N	\N	\N	nga.ttb.ph@example.com	$2b$12$vI8xKYo89TPGocRabiXIm.JB/CIsKjVtsEi1JwZT1WUIFPDK3OZCK	0911223355	1980-06-15 07:00:00	Hải Dương	FEMALE	Số 51 Phố Huế, Hai Bà Trưng, Hà Nội	2025-05-11 09:36:11.789543	2025-05-11 09:36:11.789543	ACTIVE	parent
10	Quân	Lê Văn Chiến	\N	\N	\N	quan.lvc.ph@example.com	$2b$12$Dla0G3SwaiE2Z.ZawrwuMOo6AEplKqYmeXg6ZaTiaWkdI9hFvxLBG	0911223366	1978-09-20 07:00:00	Hà Nội	MALE	Số 52 Đường Lạc Long Quân, Tây Hồ, Hà Nội	2025-05-11 09:36:16.770506	2025-05-11 09:36:16.770506	ACTIVE	parent
11	Phương	Phạm Thị Diệp	\N	\N	\N	phuong.ptd.ph@example.com	$2b$12$QnN4Vwmv8/M5HIRV2dnbNe.4Q0uI1ysmzB0AEWOkOlESufe8gA9N2	0911223377	1982-12-25 07:00:00	Nam Định	FEMALE	Số 53 Phố Kim Mã, Ba Đình, Hà Nội	2025-05-11 09:36:25.444229	2025-05-11 09:36:25.444229	ACTIVE	parent
12	An	Nguyễn Văn	\N	\N	\N	an.nv.hs@example.com	$2b$12$eXnjR8Nhqb8hxAac0/weWONuMBhDJZarGGm2DAlS0CIAo.u86byxe	0900123001	2010-01-15 07:00:00	Hà Nội	MALE	Số 101 Đường Xuân Thủy, Cầu Giấy, Hà Nội	2025-05-11 09:36:46.560094	2025-05-11 09:36:46.560094	ACTIVE	student
13	Bích	Trần Thị	\N	\N	\N	bich.tt.hs@example.com	$2b$12$.94mmXoUODBTciLLrYonj.S9MHty7Pbs5VVosRNG5iz7k7VlOFJ3m	0900123002	2010-03-20 07:00:00	Hải Phòng	FEMALE	Số 102 Phố Chùa Bộc, Đống Đa, Hà Nội	2025-05-11 09:36:57.56263	2025-05-11 09:36:57.56263	ACTIVE	student
14	Chiến	Lê Văn	\N	\N	\N	chien.lv.hs@example.com	$2b$12$569ZJIpBwwmWJdjQh6knuOTbKK64INR1I3BAyJqMkl8uA1Doh7Mfy	0900123003	2009-05-10 07:00:00	Hà Nội	MALE	Số 103 Phố Đội Cấn, Ba Đình, Hà Nội	2025-05-11 09:37:10.103459	2025-05-11 09:37:10.103459	ACTIVE	student
15	Diệp	Phạm Thị	\N	\N	\N	diep.pt.hs@example.com	$2b$12$NBHq/4fmG46lvlDk62cJ1..yEXicDcr4QS3DGsV2hIpRlJjRjvzbq	0900123004	2009-07-22 07:00:00	Nam Định	FEMALE	Số 104 Đường Âu Cơ, Tây Hồ, Hà Nội	2025-05-11 09:37:22.59259	2025-05-11 09:37:22.59259	ACTIVE	student
17	Hà	Vũ Thị	\N	\N	\N	ha.vt.hs@example.com	$2b$12$fdt2exG.STNmf2QIC7fEEuT5.mtvzSoUig0C3gkq5Tif.E/7NHDuC	0900123006	2008-04-28 07:00:00	Thái Bình	FEMALE	Số 106 Phố Lý Thường Kiệt, Hoàn Kiếm, Hà Nội	2025-05-11 09:38:08.125934	2025-05-11 09:59:21.449411	ACTIVE	student
16	Đức	Hoàng Văn	\N	\N	\N	duc.hv.hs@example.com	$2b$12$rHZ8bUA8htspg3dVZ8B3Hu0o7OZP/9tQFf70h6kTT8pockIkPuekm	0900123005	2008-02-18 07:00:00	Hà Nội	MALE	Số 105 Phố Bạch Mai, Hai Bà Trưng, Hà Nội	2025-05-11 09:37:56.913086	2025-05-11 11:30:09.055273	ACTIVE	student
20	Bảo	Lê Quốc	\N	\N	\N	bao.lq.hs3@example.com	$2b$12$.RAydAciPgHJ5ge/LclYhOvQW8W2v6jfsyXUSrcPUoHrlATZrx5hG	901230103	2009-10-07 00:00:00	\N	MALE	Số 56, Đường Láng, Đống Đa, Hà Nội	2025-05-11 11:26:08.204722	2025-05-11 11:26:08.204722	ACTIVE	student
21	Bình	Phạm Minh	\N	\N	\N	binh.pm.hs4@example.com	$2b$12$U/I0HPrWhatfOVWawEHx/.h/lK3BntAtBDqoG2KI.o9oKjP/reema	901230104	2009-05-11 00:00:00	\N	MALE	Số 78, Ngõ Chợ Khâm Thiên, Đống Đa, Hà Nội	2025-05-11 11:26:08.663359	2025-05-11 11:26:08.663359	ACTIVE	student
22	Châu	Võ Ngọc	\N	\N	\N	chau.vn.hs5@example.com	$2b$12$RFMIGrFlj6joCg/Keikm7ucD/cEC7X0jcAj/Is95sWt8dzJZvfWS2	901230105	2010-02-18 00:00:00	\N	FEMALE	Số 90, Đường Giải Phóng, Hoàng Mai, Hà Nội	2025-05-11 11:26:09.126057	2025-05-11 11:26:09.126057	ACTIVE	student
23	Chi	Hoàng Thảo	\N	\N	\N	chi.ht.hs6@example.com	$2b$12$hMT8gCaXepY5ta5FTj3b/.3kupB.LZbTu3rokMUKqn8HHn67lh70e	901230106	2010-06-25 00:00:00	\N	FEMALE	Số 11, Phố Bà Triệu, Hoàn Kiếm, Hà Nội	2025-05-11 11:26:09.608243	2025-05-11 11:26:09.608243	ACTIVE	student
24	Cường	Đỗ Mạnh	\N	\N	\N	cuong.dm.hs7@example.com	$2b$12$dwNUZ2xRMdRG504ESGbrSOI57OMOJM1jfBUvuCJ2ZwZQ6iTl9TgOm	901230107	2008-03-09 00:00:00	\N	MALE	Số 23, Đường Nguyễn Trãi, Thanh Xuân, Hà Nội	2025-05-11 11:26:10.079687	2025-05-11 11:26:10.079687	ACTIVE	student
25	Đạt	Bùi Tiến	\N	\N	\N	dat.bt.hs8@example.com	$2b$12$YVoY2V5RDP9G1.XmOBIHTuKDaU04n6WRQg8ZhasUj0BuCa1tuHQ9i	901230108	2009-04-14 00:00:00	\N	MALE	Số 45, Phố Kim Mã, Ba Đình, Hà Nội	2025-05-11 11:26:10.562317	2025-05-11 11:26:10.562317	ACTIVE	student
26	Dung	Nguyễn Thùy	\N	\N	\N	dung.nt.hs9@example.com	$2b$12$WJXp9YgasMyEtPHqbDMmxeGNqf9VyxSqkk7qUhP.r/PWJM.uJzF9i	901230109	2009-08-29 00:00:00	\N	FEMALE	Số 67, Đường Cầu Giấy, Cầu Giấy, Hà Nội	2025-05-11 11:26:11.05208	2025-05-11 11:26:11.05208	ACTIVE	student
28	Giang	Lê Thu	\N	\N	\N	giang.lt.hs11@example.com	$2b$12$teLBil2Nq8XliFlosoVZm.UdvCKxBx5wcBnbdZ1wL3c.SLXFLN5O.	912340201	2010-07-01 00:00:00	\N	FEMALE	Số 10, Ngõ Văn Chương, Đống Đa, Hà Nội	2025-05-11 11:26:12.003397	2025-05-11 11:26:12.003397	ACTIVE	student
29	Hà	Trần Phương	\N	\N	\N	ha.tp.hs12@example.com	$2b$12$u/hH3RN4RiHZJ8q4AlTx9u9Sx3YPmMUiIln/QwC6GK9ZZo4LJKc9G	912340202	2008-05-19 00:00:00	\N	FEMALE	Số 22, Đường Tây Sơn, Đống Đa, Hà Nội	2025-05-11 11:26:12.509055	2025-05-11 11:26:12.509055	ACTIVE	student
30	Hải	Nguyễn Đình	\N	\N	\N	hai.nd.hs13@example.com	$2b$12$pWaVQphHAaaU.8ELulAJ3eUm5RkJUF1KoLlirTnMGLFctChbZIeFa	912340203	2009-02-08 00:00:00	\N	MALE	Số 34, Phố Xã Đàn, Đống Đa, Hà Nội	2025-05-11 11:26:12.977042	2025-05-11 11:26:12.977042	ACTIVE	student
31	Hằng	Đặng Thu	\N	\N	\N	hang.dt.hs14@example.com	$2b$12$35coUSyeXfIv.b1j4gWXteydAW5B.uwzDbNDnwwpBwmHwTuMEp6Sy	912340204	2009-10-16 00:00:00	\N	FEMALE	Số 46, Đường Hoàng Hoa Thám, Ba Đình, Hà Nội	2025-05-11 11:26:13.44722	2025-05-11 11:26:13.44722	ACTIVE	student
18	An	Nguyễn Văn	\N	\N	\N	an.nv.hs1@example.com	$2b$12$Nf4L7d8pDsX5BycEL67GgOj7QJfJmyQdedrgFEzn6wiBF8IHBcbgK	901230101	2009-01-14 07:00:00	\N	MALE	Số 12, Đường Trần Phú, Hà Đông, Hà Nội	2025-05-11 11:26:07.254188	2025-05-11 11:30:21.779878	ACTIVE	student
19	Anh	Trần Mai	\N	\N	\N	anh.tm.hs2@example.com	$2b$12$ZNqzeaB5KbTBQqOCe2Hz8unhO/Q4Btun9evN0/kDGxappri80AqeC	901230102	2009-03-21 07:00:00	\N	FEMALE	Số 34, Phố Huế, Hai Bà Trưng, Hà Nội	2025-05-11 11:26:07.736235	2025-05-11 11:30:27.491481	ACTIVE	student
32	Hậu	Vũ Đức	\N	\N	\N	hau.vd.hs15@example.com	$2b$12$wy278LFx0QubVRaonXpXkeaAO95DidFmoxHG8YhvD1KRiwPVj1ZYy	912340205	2010-03-28 00:00:00	\N	MALE	Số 58, Phố Tôn Đức Thắng, Đống Đa, Hà Nội	2025-05-11 11:26:13.928018	2025-05-11 11:26:13.928018	ACTIVE	student
33	Hiếu	Phạm Trung	\N	\N	\N	hieu.pt.hs16@example.com	$2b$12$oBbIJZc5.cH7LLp8Chi.fuotAGvvUQeAgsaH6LZ7NN6oZiiDeHeha	912340206	2008-09-07 00:00:00	\N	MALE	Số 70, Đường Lê Duẩn, Hoàn Kiếm, Hà Nội	2025-05-11 11:26:14.408439	2025-05-11 11:26:14.408439	ACTIVE	student
34	Hoa	Bùi Thị	\N	\N	\N	hoa.bt.hs17@example.com	$2b$12$u7j1dGpyDpB5ujf4ojPeyOxaYpKKUxD26O4j8P6edWw.L/Uii3.FC	912340207	2009-11-21 00:00:00	\N	FEMALE	Số 82, Phố Hàng Bông, Hoàn Kiếm, Hà Nội	2025-05-11 11:26:14.876947	2025-05-11 11:26:14.876947	ACTIVE	student
35	Hoài	Nguyễn Khánh	\N	\N	\N	hoai.nk.hs18@example.com	$2b$12$PaaLkl/B4oztG9W06jKZrecqGm37Whrq65jPzGPfKZGm4M/emouvW	912340208	2010-04-02 00:00:00	\N	FEMALE	Số 94, Đường Thanh Niên, Tây Hồ, Hà Nội	2025-05-11 11:26:15.342592	2025-05-11 11:26:15.342592	ACTIVE	student
36	Hoàng	Lê Minh	\N	\N	\N	hoang.lm.hs19@example.com	$2b$12$tZ3cdp1y3bwho9GjPBWND.Z9q7XR/Y6Unbcu3HC70YY1/ROdRAHzW	912340209	2009-06-17 00:00:00	\N	MALE	Số 13, Ngõ Huyện, Hoàn Kiếm, Hà Nội	2025-05-11 11:26:15.810018	2025-05-11 11:26:15.810018	ACTIVE	student
37	Hồng	Trần Thị	\N	\N	\N	hong.tt.hs20@example.com	$2b$12$/TJsrTOQ6O5Xe84.DzhIV.cnNhWuUnaal7cqOJuojoD8XSYTJtbgO	912340210	2009-09-30 00:00:00	\N	FEMALE	Số 25, Phố Nhà Chung, Hoàn Kiếm, Hà Nội	2025-05-11 11:26:16.289483	2025-05-11 11:26:16.289483	ACTIVE	student
38	Hùng	Nguyễn Mạnh	\N	\N	\N	hung.nm.hs21@example.com	$2b$12$8.sSxHm4ihOg1WnmMngeo./UnzQ6Lrdz839T5xGhbZ/x2ABUv0yeC	987650301	2009-12-01 00:00:00	\N	MALE	Số 37, Đường Lạc Long Quân, Tây Hồ, Hà Nội	2025-05-11 11:26:16.75599	2025-05-11 11:26:16.75599	ACTIVE	student
39	Hương	Phạm Thu	\N	\N	\N	huong.pt.hs22@example.com	$2b$12$4V2d2b2iZtPfBqJPGDvUfOsmxGzvApucHgolaOkpEvnwILiJSLj0m	987650302	2009-04-24 00:00:00	\N	FEMALE	Số 49, Phố Quán Thánh, Ba Đình, Hà Nội	2025-05-11 11:26:17.222221	2025-05-11 11:26:17.222221	ACTIVE	student
40	Huy	Lê Quang	\N	\N	\N	huy.lq.hs23@example.com	$2b$12$2484Wmlt5RtgywzC9sDSTefPRYg2UYBiA0r5oJBJdjP1idKflyvLu	987650303	2009-08-08 00:00:00	\N	MALE	Số 61, Đường Âu Cơ, Tây Hồ, Hà Nội	2025-05-11 11:26:17.689568	2025-05-11 11:26:17.689568	ACTIVE	student
41	Huyền	Võ Thị	\N	\N	\N	huyen.vt.hs24@example.com	$2b$12$b3eUY5e0cjYodAhkFKnCseLSWtC/A3v4zd0quEcSZH0vd0WVSpkJe	987650304	2009-12-20 00:00:00	\N	FEMALE	Số 73, Phố Yên Phụ, Tây Hồ, Hà Nội	2025-05-11 11:26:18.158048	2025-05-11 11:26:18.158048	ACTIVE	student
42	Khải	Hoàng Gia	\N	\N	\N	khai.hg.hs25@example.com	$2b$12$5z0zCTsTjbVdY3eSTLetb.UKik4FX6pQZBNIiihdLh58e.OrZ.v3W	987650305	2010-01-03 00:00:00	\N	MALE	Số 85, Đường Nghi Tàm, Tây Hồ, Hà Nội	2025-05-11 11:26:18.631877	2025-05-11 11:26:18.631877	ACTIVE	student
43	Khanh	Đỗ Bảo	\N	\N	\N	khanh.db.hs26@example.com	$2b$12$U6ubnhm/YkjqNFrmlDPuVOGeacaXcCXVNnUOYjU9QsKZE1DpcFb/e	987650306	2008-07-13 00:00:00	\N	FEMALE	Số 97, Phố Từ Hoa, Tây Hồ, Hà Nội	2025-05-11 11:26:19.180204	2025-05-11 11:26:19.180204	ACTIVE	student
44	Khoa	Nguyễn Đăng	\N	\N	\N	khoa.nd.hs27@example.com	$2b$12$KQga6mvgDNBbY0q.HRuFJ.gJxjR6FwybT3bsljTJxC5VpX5.R.bJ.	987650307	2009-10-26 00:00:00	\N	MALE	Số 109, Đường Xuân Diệu, Tây Hồ, Hà Nội	2025-05-11 11:26:19.670391	2025-05-11 11:26:19.670391	ACTIVE	student
45	Kiên	Trần Trung	\N	\N	\N	kien.tt.hs28@example.com	$2b$12$qZhvBqatebNDz.a28BWr0erAtn24Mrac8ibATr3z/WLU/3vREYUFS	987650308	2010-06-02 00:00:00	\N	MALE	Số 121, Phố Đặng Thai Mai, Tây Hồ, Hà Nội	2025-05-11 11:26:20.14357	2025-05-11 11:26:20.14357	ACTIVE	student
47	Lan	Lê Mỹ	\N	\N	\N	lan.lm.hs30@example.com	$2b$12$LoJ8Bs6xZP9JiRt93OUSLOZvWXlYOXwO49V6ssvBMgA2gZh1PlpYC	987650310	2008-02-09 00:00:00	\N	FEMALE	Số 145, Ngõ Quảng An, Tây Hồ, Hà Nội	2025-05-11 11:26:21.101934	2025-05-11 11:26:21.101934	ACTIVE	student
52	Mạnh	Nguyễn Đức	\N	\N	\N	manh.nd.hs35@example.com	$2b$12$l8zScfeBUHvOK/dN35rXhe1R40x95gHXaf8vzgh633iZvvLUMKMsS	331230405	2010-03-03 00:00:00	\N	MALE	Số 63, Đường Dịch Vọng Hậu, Cầu Giấy, Hà Nội	2025-05-11 11:26:23.483602	2025-05-11 11:26:23.483602	ACTIVE	student
54	My	Võ Lan	\N	\N	\N	my.vl.hs37@example.com	$2b$12$pH.pgVC1v1az2whJ2MZK3ecJhMv/6CJEM7MFeKnfNQ//MxqYPfV7e	331230407	2009-09-28 00:00:00	\N	FEMALE	Số 87, Đường Nguyễn Khánh Toàn, Cầu Giấy, Hà Nội	2025-05-11 11:26:24.443938	2025-05-11 11:26:24.443938	ACTIVE	student
56	Nga	Bùi Thu	\N	\N	\N	nga.bt.hs39@example.com	$2b$12$ARsOJDjb0.gfmEaltnPGDeqan5RLpEjgvDSIx.qPaH9g8IKnuvvZq	331230409	2010-02-22 00:00:00	\N	FEMALE	Số 111, Đường Trung Kính, Cầu Giấy, Hà Nội	2025-05-11 11:26:25.403249	2025-05-11 11:26:25.403249	ACTIVE	student
27	Dương	Phan Hoài	\N	\N	\N	duong.ph.hs10@example.com	$2b$12$pPAkLUfc8DFLs3tIulv.8OydxmRCi/3LWNcDX4Wq6OvViPZssXSLu	901230110	2009-11-11 07:00:00	\N	MALE	Số 89, Phố Chùa Láng, Đống Đa, Hà Nội	2025-05-11 11:26:11.523537	2025-05-11 11:28:15.99387	ACTIVE	student
57	Ngân	Phạm Thị Kim	\N	\N	\N	ngan.ptk.hs40@example.com	$2b$12$kMQgPXKtQO6yIw7wlsn9l.x.9fzvI.X3D41s3yBIWDI12Zp2i18te	331230410	2009-05-05 07:00:00	\N	FEMALE	Số 123, Phố Vũ Phạm Hàm, Cầu Giấy, Hà Nội	2025-05-11 11:26:25.875337	2025-05-11 11:29:16.257054	ACTIVE	student
55	Nam	Đỗ Thành	\N	\N	\N	nam.dt.hs38@example.com	$2b$12$1x4dy9DFR8zEtyUOYvOqHOG8aqWdbujYIWNC2RoLA99Md89Jjmjje	331230408	2009-10-11 07:00:00	\N	MALE	Số 99, Phố Chùa Hà, Cầu Giấy, Hà Nội	2025-05-11 11:26:24.926226	2025-05-11 11:29:22.341757	ACTIVE	student
53	Minh	Hoàng Quang	\N	\N	\N	minh.hq.hs36@example.com	$2b$12$ctjB4saEDoNQ4Y4hfopEJuiDQCsnvckJjLSTcJk8Q8DxocsSlh3eq	331230406	2008-06-15 07:00:00	\N	MALE	Số 75, Phố Trần Đăng Ninh, Cầu Giấy, Hà Nội	2025-05-11 11:26:23.962335	2025-05-11 11:29:28.931834	ACTIVE	student
51	Mai	Lê Thị	\N	\N	\N	mai.lt.hs34@example.com	$2b$12$rUjcK9tG7eRYJEfoybYOmu0O2NAcGUbwHNzdcauB80K04eCoyEAYG	331230404	2009-11-20 07:00:00	\N	FEMALE	Số 51, Phố Nguyễn Phong Sắc, Cầu Giấy, Hà Nội	2025-05-11 11:26:23.014226	2025-05-11 11:29:34.010251	ACTIVE	student
49	Long	Phạm Thành	\N	\N	\N	long.pt.hs32@example.com	$2b$12$rlJi0EIlnrvsMCjkHz0/8uQOGuCWI70sWNVdL.TXNWWKuJZeCKHSG	331230402	2009-04-26 07:00:00	\N	MALE	Số 27, Phố Duy Tân, Cầu Giấy, Hà Nội	2025-05-11 11:26:22.060292	2025-05-11 11:29:39.653148	ACTIVE	student
48	Linh	Nguyễn Thùy	\N	\N	\N	linh.nt.hs31@example.com	$2b$12$JkisdqNS61IBA70EFNAHWedD2ZF7wxJlXNL/qeEVWvgUynFMpfGdS	331230401	2010-01-14 07:00:00	\N	FEMALE	Số 15, Đường Hoàng Quốc Việt, Cầu Giấy, Hà Nội	2025-05-11 11:26:21.580421	2025-05-11 11:29:44.709259	ACTIVE	student
46	Lam	Bùi Phương	\N	\N	\N	lam.bp.hs29@example.com	$2b$12$DV0.lk.mrFbseBh3M941se4.OPEEaFwQrgLcpYdYyC1M6bhsyHS7G	987650309	2010-05-18 07:00:00	\N	FEMALE	Số 133, Đường Tô Ngọc Vân, Tây Hồ, Hà Nội	2025-05-11 11:26:20.627862	2025-05-11 11:29:50.831715	ACTIVE	student
50	Ly	Trần Khánh	\N	\N	\N	ly.tk.hs33@example.com	$2b$12$s.nOqfOMAuY0hX9Ik4tYc.pUdMFgupXOzdLsTzMvciwDTlGbzpqXW	331230403	2009-09-07 07:00:00	\N	FEMALE	Số 39, Đường Trần Quốc Hoàn, Cầu Giấy, Hà Nội	2025-05-11 11:26:22.530026	2025-05-11 11:29:57.256677	ACTIVE	student
\.


--
-- TOC entry 5242 (class 0 OID 0)
-- Dependencies: 232
-- Name: access_permissions_AccessID_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."access_permissions_AccessID_seq"', 1, false);


--
-- TOC entry 5243 (class 0 OID 0)
-- Dependencies: 245
-- Name: class_posts_PostID_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."class_posts_PostID_seq"', 1, true);


--
-- TOC entry 5244 (class 0 OID 0)
-- Dependencies: 243
-- Name: class_subjects_ClassSubjectID_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."class_subjects_ClassSubjectID_seq"', 20, true);


--
-- TOC entry 5245 (class 0 OID 0)
-- Dependencies: 236
-- Name: classes_ClassID_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."classes_ClassID_seq"', 14, true);


--
-- TOC entry 5246 (class 0 OID 0)
-- Dependencies: 219
-- Name: conversations_ConversationID_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."conversations_ConversationID_seq"', 16, true);


--
-- TOC entry 5247 (class 0 OID 0)
-- Dependencies: 259
-- Name: daily_progress_DailyID_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."daily_progress_DailyID_seq"', 1, true);


--
-- TOC entry 5248 (class 0 OID 0)
-- Dependencies: 221
-- Name: departments_DepartmentID_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."departments_DepartmentID_seq"', 1, false);


--
-- TOC entry 5249 (class 0 OID 0)
-- Dependencies: 249
-- Name: event_files_FileID_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."event_files_FileID_seq"', 4, true);


--
-- TOC entry 5250 (class 0 OID 0)
-- Dependencies: 234
-- Name: events_EventID_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."events_EventID_seq"', 4, true);


--
-- TOC entry 5251 (class 0 OID 0)
-- Dependencies: 263
-- Name: grade_components_ComponentID_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."grade_components_ComponentID_seq"', 9766, true);


--
-- TOC entry 5252 (class 0 OID 0)
-- Dependencies: 253
-- Name: grades_GradeID_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."grades_GradeID_seq"', 1627, true);


--
-- TOC entry 5253 (class 0 OID 0)
-- Dependencies: 240
-- Name: message_files_FileID_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."message_files_FileID_seq"', 2, true);


--
-- TOC entry 5254 (class 0 OID 0)
-- Dependencies: 225
-- Name: messages_MessageID_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."messages_MessageID_seq"', 8, true);


--
-- TOC entry 5255 (class 0 OID 0)
-- Dependencies: 251
-- Name: parent_students_RelationshipID_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."parent_students_RelationshipID_seq"', 6, true);


--
-- TOC entry 5256 (class 0 OID 0)
-- Dependencies: 227
-- Name: participations_ParticipationID_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."participations_ParticipationID_seq"', 84, true);


--
-- TOC entry 5257 (class 0 OID 0)
-- Dependencies: 247
-- Name: petition_files_FileID_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."petition_files_FileID_seq"', 1, false);


--
-- TOC entry 5258 (class 0 OID 0)
-- Dependencies: 238
-- Name: petitions_PetitionID_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."petitions_PetitionID_seq"', 1, false);


--
-- TOC entry 5259 (class 0 OID 0)
-- Dependencies: 257
-- Name: post_files_FileID_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."post_files_FileID_seq"', 1, false);


--
-- TOC entry 5260 (class 0 OID 0)
-- Dependencies: 255
-- Name: reward_punishments_RecordID_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."reward_punishments_RecordID_seq"', 1, false);


--
-- TOC entry 5261 (class 0 OID 0)
-- Dependencies: 261
-- Name: subject_schedules_SubjectScheduleID_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."subject_schedules_SubjectScheduleID_seq"', 26, true);


--
-- TOC entry 5262 (class 0 OID 0)
-- Dependencies: 223
-- Name: subjects_SubjectID_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."subjects_SubjectID_seq"', 14, false);


--
-- TOC entry 5263 (class 0 OID 0)
-- Dependencies: 217
-- Name: users_UserID_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."users_UserID_seq"', 57, true);


--
-- TOC entry 4937 (class 2606 OID 27535)
-- Name: access_permissions access_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.access_permissions
    ADD CONSTRAINT access_permissions_pkey PRIMARY KEY ("AccessID");


--
-- TOC entry 4931 (class 2606 OID 27492)
-- Name: administrative_staffs administrative_staffs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.administrative_staffs
    ADD CONSTRAINT administrative_staffs_pkey PRIMARY KEY ("AdminID");


--
-- TOC entry 4958 (class 2606 OID 27656)
-- Name: class_posts class_posts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.class_posts
    ADD CONSTRAINT class_posts_pkey PRIMARY KEY ("PostID");


--
-- TOC entry 4955 (class 2606 OID 27631)
-- Name: class_subjects class_subjects_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.class_subjects
    ADD CONSTRAINT class_subjects_pkey PRIMARY KEY ("ClassSubjectID");


--
-- TOC entry 4944 (class 2606 OID 27566)
-- Name: classes classes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.classes
    ADD CONSTRAINT classes_pkey PRIMARY KEY ("ClassID");


--
-- TOC entry 4912 (class 2606 OID 27422)
-- Name: conversations conversations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.conversations
    ADD CONSTRAINT conversations_pkey PRIMARY KEY ("ConversationID");


--
-- TOC entry 4979 (class 2606 OID 27779)
-- Name: daily_progress daily_progress_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.daily_progress
    ADD CONSTRAINT daily_progress_pkey PRIMARY KEY ("DailyID");


--
-- TOC entry 4915 (class 2606 OID 27434)
-- Name: departments departments_DepartmentName_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.departments
    ADD CONSTRAINT "departments_DepartmentName_key" UNIQUE ("DepartmentName");


--
-- TOC entry 4917 (class 2606 OID 27432)
-- Name: departments departments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.departments
    ADD CONSTRAINT departments_pkey PRIMARY KEY ("DepartmentID");


--
-- TOC entry 4964 (class 2606 OID 27691)
-- Name: event_files event_files_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.event_files
    ADD CONSTRAINT event_files_pkey PRIMARY KEY ("FileID");


--
-- TOC entry 4940 (class 2606 OID 27550)
-- Name: events events_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_pkey PRIMARY KEY ("EventID");


--
-- TOC entry 4985 (class 2606 OID 27816)
-- Name: grade_components grade_components_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grade_components
    ADD CONSTRAINT grade_components_pkey PRIMARY KEY ("ComponentID");


--
-- TOC entry 4970 (class 2606 OID 27724)
-- Name: grades grades_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grades
    ADD CONSTRAINT grades_pkey PRIMARY KEY ("GradeID");


--
-- TOC entry 4951 (class 2606 OID 27601)
-- Name: message_files message_files_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.message_files
    ADD CONSTRAINT message_files_pkey PRIMARY KEY ("FileID");


--
-- TOC entry 4926 (class 2606 OID 27456)
-- Name: messages messages_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.messages
    ADD CONSTRAINT messages_pkey PRIMARY KEY ("MessageID");


--
-- TOC entry 4968 (class 2606 OID 27704)
-- Name: parent_students parent_students_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parent_students
    ADD CONSTRAINT parent_students_pkey PRIMARY KEY ("RelationshipID");


--
-- TOC entry 4935 (class 2606 OID 27521)
-- Name: parents parents_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parents
    ADD CONSTRAINT parents_pkey PRIMARY KEY ("ParentID");


--
-- TOC entry 4929 (class 2606 OID 27474)
-- Name: participations participations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.participations
    ADD CONSTRAINT participations_pkey PRIMARY KEY ("ParticipationID");


--
-- TOC entry 4962 (class 2606 OID 27676)
-- Name: petition_files petition_files_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.petition_files
    ADD CONSTRAINT petition_files_pkey PRIMARY KEY ("FileID");


--
-- TOC entry 4948 (class 2606 OID 27581)
-- Name: petitions petitions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.petitions
    ADD CONSTRAINT petitions_pkey PRIMARY KEY ("PetitionID");


--
-- TOC entry 4977 (class 2606 OID 27764)
-- Name: post_files post_files_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.post_files
    ADD CONSTRAINT post_files_pkey PRIMARY KEY ("FileID");


--
-- TOC entry 4974 (class 2606 OID 27744)
-- Name: reward_punishments reward_punishments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reward_punishments
    ADD CONSTRAINT reward_punishments_pkey PRIMARY KEY ("RecordID");


--
-- TOC entry 4953 (class 2606 OID 27612)
-- Name: students students_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.students
    ADD CONSTRAINT students_pkey PRIMARY KEY ("StudentID");


--
-- TOC entry 4983 (class 2606 OID 27801)
-- Name: subject_schedules subject_schedules_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subject_schedules
    ADD CONSTRAINT subject_schedules_pkey PRIMARY KEY ("SubjectScheduleID");


--
-- TOC entry 4921 (class 2606 OID 27446)
-- Name: subjects subjects_SubjectName_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subjects
    ADD CONSTRAINT "subjects_SubjectName_key" UNIQUE ("SubjectName");


--
-- TOC entry 4923 (class 2606 OID 27444)
-- Name: subjects subjects_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subjects
    ADD CONSTRAINT subjects_pkey PRIMARY KEY ("SubjectID");


--
-- TOC entry 4933 (class 2606 OID 27504)
-- Name: teachers teachers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teachers
    ADD CONSTRAINT teachers_pkey PRIMARY KEY ("TeacherID");


--
-- TOC entry 4910 (class 2606 OID 27411)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY ("UserID");


--
-- TOC entry 4938 (class 1259 OID 27541)
-- Name: ix_access_permissions_AccessID; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "ix_access_permissions_AccessID" ON public.access_permissions USING btree ("AccessID");


--
-- TOC entry 4959 (class 1259 OID 27667)
-- Name: ix_class_posts_PostID; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "ix_class_posts_PostID" ON public.class_posts USING btree ("PostID");


--
-- TOC entry 4956 (class 1259 OID 27647)
-- Name: ix_class_subjects_ClassSubjectID; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "ix_class_subjects_ClassSubjectID" ON public.class_subjects USING btree ("ClassSubjectID");


--
-- TOC entry 4945 (class 1259 OID 27572)
-- Name: ix_classes_ClassID; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "ix_classes_ClassID" ON public.classes USING btree ("ClassID");


--
-- TOC entry 4913 (class 1259 OID 27423)
-- Name: ix_conversations_ConversationID; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "ix_conversations_ConversationID" ON public.conversations USING btree ("ConversationID");


--
-- TOC entry 4980 (class 1259 OID 27790)
-- Name: ix_daily_progress_DailyID; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "ix_daily_progress_DailyID" ON public.daily_progress USING btree ("DailyID");


--
-- TOC entry 4918 (class 1259 OID 27435)
-- Name: ix_departments_DepartmentID; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "ix_departments_DepartmentID" ON public.departments USING btree ("DepartmentID");


--
-- TOC entry 4965 (class 1259 OID 27697)
-- Name: ix_event_files_FileID; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "ix_event_files_FileID" ON public.event_files USING btree ("FileID");


--
-- TOC entry 4941 (class 1259 OID 27557)
-- Name: ix_events_EventID; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "ix_events_EventID" ON public.events USING btree ("EventID");


--
-- TOC entry 4942 (class 1259 OID 27556)
-- Name: ix_events_Title; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "ix_events_Title" ON public.events USING btree ("Title");


--
-- TOC entry 4986 (class 1259 OID 27822)
-- Name: ix_grade_components_ComponentID; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "ix_grade_components_ComponentID" ON public.grade_components USING btree ("ComponentID");


--
-- TOC entry 4971 (class 1259 OID 27735)
-- Name: ix_grades_GradeID; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "ix_grades_GradeID" ON public.grades USING btree ("GradeID");


--
-- TOC entry 4949 (class 1259 OID 27607)
-- Name: ix_message_files_FileID; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "ix_message_files_FileID" ON public.message_files USING btree ("FileID");


--
-- TOC entry 4924 (class 1259 OID 27467)
-- Name: ix_messages_MessageID; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "ix_messages_MessageID" ON public.messages USING btree ("MessageID");


--
-- TOC entry 4966 (class 1259 OID 27715)
-- Name: ix_parent_students_RelationshipID; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "ix_parent_students_RelationshipID" ON public.parent_students USING btree ("RelationshipID");


--
-- TOC entry 4927 (class 1259 OID 27485)
-- Name: ix_participations_ParticipationID; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "ix_participations_ParticipationID" ON public.participations USING btree ("ParticipationID");


--
-- TOC entry 4960 (class 1259 OID 27682)
-- Name: ix_petition_files_FileID; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "ix_petition_files_FileID" ON public.petition_files USING btree ("FileID");


--
-- TOC entry 4946 (class 1259 OID 27592)
-- Name: ix_petitions_PetitionID; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "ix_petitions_PetitionID" ON public.petitions USING btree ("PetitionID");


--
-- TOC entry 4975 (class 1259 OID 27770)
-- Name: ix_post_files_FileID; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "ix_post_files_FileID" ON public.post_files USING btree ("FileID");


--
-- TOC entry 4972 (class 1259 OID 27755)
-- Name: ix_reward_punishments_RecordID; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "ix_reward_punishments_RecordID" ON public.reward_punishments USING btree ("RecordID");


--
-- TOC entry 4981 (class 1259 OID 27807)
-- Name: ix_subject_schedules_SubjectScheduleID; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "ix_subject_schedules_SubjectScheduleID" ON public.subject_schedules USING btree ("SubjectScheduleID");


--
-- TOC entry 4919 (class 1259 OID 27447)
-- Name: ix_subjects_SubjectID; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "ix_subjects_SubjectID" ON public.subjects USING btree ("SubjectID");


--
-- TOC entry 4907 (class 1259 OID 27412)
-- Name: ix_users_Email; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "ix_users_Email" ON public.users USING btree ("Email");


--
-- TOC entry 4908 (class 1259 OID 27413)
-- Name: ix_users_UserID; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "ix_users_UserID" ON public.users USING btree ("UserID");


--
-- TOC entry 4995 (class 2606 OID 27536)
-- Name: access_permissions access_permissions_UserID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.access_permissions
    ADD CONSTRAINT "access_permissions_UserID_fkey" FOREIGN KEY ("UserID") REFERENCES public.users("UserID");


--
-- TOC entry 4991 (class 2606 OID 27493)
-- Name: administrative_staffs administrative_staffs_AdminID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.administrative_staffs
    ADD CONSTRAINT "administrative_staffs_AdminID_fkey" FOREIGN KEY ("AdminID") REFERENCES public.users("UserID");


--
-- TOC entry 5006 (class 2606 OID 27662)
-- Name: class_posts class_posts_ClassID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.class_posts
    ADD CONSTRAINT "class_posts_ClassID_fkey" FOREIGN KEY ("ClassID") REFERENCES public.classes("ClassID");


--
-- TOC entry 5007 (class 2606 OID 27657)
-- Name: class_posts class_posts_TeacherID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.class_posts
    ADD CONSTRAINT "class_posts_TeacherID_fkey" FOREIGN KEY ("TeacherID") REFERENCES public.teachers("TeacherID");


--
-- TOC entry 5003 (class 2606 OID 27637)
-- Name: class_subjects class_subjects_ClassID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.class_subjects
    ADD CONSTRAINT "class_subjects_ClassID_fkey" FOREIGN KEY ("ClassID") REFERENCES public.classes("ClassID");


--
-- TOC entry 5004 (class 2606 OID 27642)
-- Name: class_subjects class_subjects_SubjectID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.class_subjects
    ADD CONSTRAINT "class_subjects_SubjectID_fkey" FOREIGN KEY ("SubjectID") REFERENCES public.subjects("SubjectID");


--
-- TOC entry 5005 (class 2606 OID 27632)
-- Name: class_subjects class_subjects_TeacherID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.class_subjects
    ADD CONSTRAINT "class_subjects_TeacherID_fkey" FOREIGN KEY ("TeacherID") REFERENCES public.teachers("TeacherID");


--
-- TOC entry 4997 (class 2606 OID 27567)
-- Name: classes classes_HomeroomTeacherID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.classes
    ADD CONSTRAINT "classes_HomeroomTeacherID_fkey" FOREIGN KEY ("HomeroomTeacherID") REFERENCES public.teachers("TeacherID");


--
-- TOC entry 5017 (class 2606 OID 27785)
-- Name: daily_progress daily_progress_StudentID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.daily_progress
    ADD CONSTRAINT "daily_progress_StudentID_fkey" FOREIGN KEY ("StudentID") REFERENCES public.students("StudentID");


--
-- TOC entry 5018 (class 2606 OID 27780)
-- Name: daily_progress daily_progress_TeacherID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.daily_progress
    ADD CONSTRAINT "daily_progress_TeacherID_fkey" FOREIGN KEY ("TeacherID") REFERENCES public.teachers("TeacherID");


--
-- TOC entry 5009 (class 2606 OID 27692)
-- Name: event_files event_files_EventID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.event_files
    ADD CONSTRAINT "event_files_EventID_fkey" FOREIGN KEY ("EventID") REFERENCES public.events("EventID");


--
-- TOC entry 4996 (class 2606 OID 27551)
-- Name: events events_AdminID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT "events_AdminID_fkey" FOREIGN KEY ("AdminID") REFERENCES public.administrative_staffs("AdminID");


--
-- TOC entry 5020 (class 2606 OID 27817)
-- Name: grade_components grade_components_GradeID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grade_components
    ADD CONSTRAINT "grade_components_GradeID_fkey" FOREIGN KEY ("GradeID") REFERENCES public.grades("GradeID");


--
-- TOC entry 5012 (class 2606 OID 27730)
-- Name: grades grades_ClassSubjectID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grades
    ADD CONSTRAINT "grades_ClassSubjectID_fkey" FOREIGN KEY ("ClassSubjectID") REFERENCES public.class_subjects("ClassSubjectID");


--
-- TOC entry 5013 (class 2606 OID 27725)
-- Name: grades grades_StudentID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grades
    ADD CONSTRAINT "grades_StudentID_fkey" FOREIGN KEY ("StudentID") REFERENCES public.students("StudentID");


--
-- TOC entry 5000 (class 2606 OID 27602)
-- Name: message_files message_files_MessageID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.message_files
    ADD CONSTRAINT "message_files_MessageID_fkey" FOREIGN KEY ("MessageID") REFERENCES public.messages("MessageID");


--
-- TOC entry 4987 (class 2606 OID 27457)
-- Name: messages messages_ConversationID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.messages
    ADD CONSTRAINT "messages_ConversationID_fkey" FOREIGN KEY ("ConversationID") REFERENCES public.conversations("ConversationID");


--
-- TOC entry 4988 (class 2606 OID 27462)
-- Name: messages messages_UserID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.messages
    ADD CONSTRAINT "messages_UserID_fkey" FOREIGN KEY ("UserID") REFERENCES public.users("UserID");


--
-- TOC entry 5010 (class 2606 OID 27705)
-- Name: parent_students parent_students_ParentID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parent_students
    ADD CONSTRAINT "parent_students_ParentID_fkey" FOREIGN KEY ("ParentID") REFERENCES public.parents("ParentID");


--
-- TOC entry 5011 (class 2606 OID 27710)
-- Name: parent_students parent_students_StudentID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parent_students
    ADD CONSTRAINT "parent_students_StudentID_fkey" FOREIGN KEY ("StudentID") REFERENCES public.students("StudentID");


--
-- TOC entry 4994 (class 2606 OID 27522)
-- Name: parents parents_ParentID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parents
    ADD CONSTRAINT "parents_ParentID_fkey" FOREIGN KEY ("ParentID") REFERENCES public.users("UserID");


--
-- TOC entry 4989 (class 2606 OID 27475)
-- Name: participations participations_ConversationID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.participations
    ADD CONSTRAINT "participations_ConversationID_fkey" FOREIGN KEY ("ConversationID") REFERENCES public.conversations("ConversationID");


--
-- TOC entry 4990 (class 2606 OID 27480)
-- Name: participations participations_UserID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.participations
    ADD CONSTRAINT "participations_UserID_fkey" FOREIGN KEY ("UserID") REFERENCES public.users("UserID");


--
-- TOC entry 5008 (class 2606 OID 27677)
-- Name: petition_files petition_files_PetitionID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.petition_files
    ADD CONSTRAINT "petition_files_PetitionID_fkey" FOREIGN KEY ("PetitionID") REFERENCES public.petitions("PetitionID");


--
-- TOC entry 4998 (class 2606 OID 27587)
-- Name: petitions petitions_AdminID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.petitions
    ADD CONSTRAINT "petitions_AdminID_fkey" FOREIGN KEY ("AdminID") REFERENCES public.administrative_staffs("AdminID");


--
-- TOC entry 4999 (class 2606 OID 27582)
-- Name: petitions petitions_ParentID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.petitions
    ADD CONSTRAINT "petitions_ParentID_fkey" FOREIGN KEY ("ParentID") REFERENCES public.parents("ParentID");


--
-- TOC entry 5016 (class 2606 OID 27765)
-- Name: post_files post_files_PostID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.post_files
    ADD CONSTRAINT "post_files_PostID_fkey" FOREIGN KEY ("PostID") REFERENCES public.class_posts("PostID");


--
-- TOC entry 5014 (class 2606 OID 27750)
-- Name: reward_punishments reward_punishments_AdminID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reward_punishments
    ADD CONSTRAINT "reward_punishments_AdminID_fkey" FOREIGN KEY ("AdminID") REFERENCES public.administrative_staffs("AdminID");


--
-- TOC entry 5015 (class 2606 OID 27745)
-- Name: reward_punishments reward_punishments_StudentID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reward_punishments
    ADD CONSTRAINT "reward_punishments_StudentID_fkey" FOREIGN KEY ("StudentID") REFERENCES public.students("StudentID");


--
-- TOC entry 5001 (class 2606 OID 27618)
-- Name: students students_ClassID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.students
    ADD CONSTRAINT "students_ClassID_fkey" FOREIGN KEY ("ClassID") REFERENCES public.classes("ClassID");


--
-- TOC entry 5002 (class 2606 OID 27613)
-- Name: students students_StudentID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.students
    ADD CONSTRAINT "students_StudentID_fkey" FOREIGN KEY ("StudentID") REFERENCES public.users("UserID");


--
-- TOC entry 5019 (class 2606 OID 27802)
-- Name: subject_schedules subject_schedules_ClassSubjectID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subject_schedules
    ADD CONSTRAINT "subject_schedules_ClassSubjectID_fkey" FOREIGN KEY ("ClassSubjectID") REFERENCES public.class_subjects("ClassSubjectID");


--
-- TOC entry 4992 (class 2606 OID 27510)
-- Name: teachers teachers_DepartmentID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teachers
    ADD CONSTRAINT "teachers_DepartmentID_fkey" FOREIGN KEY ("DepartmentID") REFERENCES public.departments("DepartmentID");


--
-- TOC entry 4993 (class 2606 OID 27505)
-- Name: teachers teachers_TeacherID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teachers
    ADD CONSTRAINT "teachers_TeacherID_fkey" FOREIGN KEY ("TeacherID") REFERENCES public.users("UserID");


-- Completed on 2025-05-11 21:29:37

--
-- PostgreSQL database dump complete
--

