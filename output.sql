--
-- PostgreSQL database dump
--

-- Dumped from database version 16.2
-- Dumped by pg_dump version 16.2

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
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
-- Name: postcomment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.postcomment (
    id integer NOT NULL,
    username character varying(255) NOT NULL,
    content text NOT NULL,
    date date,
    idpost integer
);


ALTER TABLE public.postcomment OWNER TO postgres;

--
-- Name: comment_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.comment_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.comment_id_seq OWNER TO postgres;

--
-- Name: comment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.comment_id_seq OWNED BY public.postcomment.id;


--
-- Name: locationcomment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.locationcomment (
    id integer NOT NULL,
    username character varying(255) NOT NULL,
    content text,
    date timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    idlocation integer NOT NULL
);


ALTER TABLE public.locationcomment OWNER TO postgres;

--
-- Name: locationcomment_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.locationcomment_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.locationcomment_id_seq OWNER TO postgres;

--
-- Name: locationcomment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.locationcomment_id_seq OWNED BY public.locationcomment.id;


--
-- Name: locationdetail; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.locationdetail (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    information text,
    image character varying(255),
    rate numeric(3,2) DEFAULT 0,
    amongrate numeric(3,2) DEFAULT 0,
    date timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    location character varying(255),
    point numeric DEFAULT 0
);


ALTER TABLE public.locationdetail OWNER TO postgres;

--
-- Name: locationdetail_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.locationdetail_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.locationdetail_id_seq OWNER TO postgres;

--
-- Name: locationdetail_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.locationdetail_id_seq OWNED BY public.locationdetail.id;


--
-- Name: postdetail; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.postdetail (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    date date,
    image character varying(255),
    content text,
    rate numeric(3,2) DEFAULT 0,
    amongrate integer DEFAULT 0,
    location character varying(255),
    view integer,
    userid integer
);


ALTER TABLE public.postdetail OWNER TO postgres;

--
-- Name: postdetail_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.postdetail_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.postdetail_id_seq OWNER TO postgres;

--
-- Name: postdetail_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.postdetail_id_seq OWNED BY public.postdetail.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id integer NOT NULL,
    username character varying(50) NOT NULL,
    password character varying(255) NOT NULL,
    email character varying(255) NOT NULL,
    fullname character varying(255),
    address text,
    isadmin boolean DEFAULT false,
    avatar character varying(255),
    banned_until timestamp without time zone,
    point numeric DEFAULT 0
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_id_seq OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: locationcomment id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.locationcomment ALTER COLUMN id SET DEFAULT nextval('public.locationcomment_id_seq'::regclass);


--
-- Name: locationdetail id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.locationdetail ALTER COLUMN id SET DEFAULT nextval('public.locationdetail_id_seq'::regclass);


--
-- Name: postcomment id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.postcomment ALTER COLUMN id SET DEFAULT nextval('public.comment_id_seq'::regclass);


--
-- Name: postdetail id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.postdetail ALTER COLUMN id SET DEFAULT nextval('public.postdetail_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Data for Name: locationcomment; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: locationdetail; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.locationdetail VALUES (1, 'An Giang', 'Tß╗ënh An Giang nß╗òi tiß║┐ng vß╗¢i chß╗ú nß╗òi Long Xuy├¬n v├á v├╣ng Bß║úy N├║i linh thi├¬ng.', NULL, 0.00, 0.00, '2024-10-30 08:00:12.826911', 'angiang', NULL);
INSERT INTO public.locationdetail VALUES (2, 'B├á Rß╗ïa - V┼⌐ng T├áu', 'N╞íi c├│ b├úi biß╗ân V┼⌐ng T├áu nß╗òi tiß║┐ng, thu h├║t nhiß╗üu kh├ích du lß╗ïch.', NULL, 0.00, 0.00, '2024-10-30 08:00:12.826911', 'bariavungtau', NULL);
INSERT INTO public.locationdetail VALUES (3, 'Bß║»c Giang', 'Bß║»c Giang c├│ nhiß╗üu cß║únh quan tß╗▒ nhi├¬n v├á l├á n╞íi sß║ún xuß║Ñt vß║úi thiß╗üu nß╗òi tiß║┐ng.', NULL, 0.00, 0.00, '2024-10-30 08:00:12.826911', 'bacgiang', NULL);
INSERT INTO public.locationdetail VALUES (4, 'Bß║»c Kß║ín', 'Bß║»c Kß║ín c├│ hß╗ô Ba Bß╗â v├á nhiß╗üu cß║únh quan thi├¬n nhi├¬n tuyß╗çt ─æß║╣p.', NULL, 0.00, 0.00, '2024-10-30 08:00:12.826911', 'backan', NULL);
INSERT INTO public.locationdetail VALUES (5, 'Bß║íc Li├¬u', 'Nß╗òi tiß║┐ng vß╗¢i ─æiß╗çn gi├│ v├á gß║»n liß╗ün vß╗¢i giai thoß║íi C├┤ng tß╗¡ Bß║íc Li├¬u.', NULL, 0.00, 0.00, '2024-10-30 08:00:12.826911', 'baclieu', NULL);
INSERT INTO public.locationdetail VALUES (6, 'Bß║»c Ninh', 'Bß║»c Ninh l├á c├íi n├┤i cß╗ºa d├ón ca quan hß╗ì truyß╗ün thß╗æng Viß╗çt Nam.', NULL, 0.00, 0.00, '2024-10-30 08:00:12.826911', 'bacninh', NULL);
INSERT INTO public.locationdetail VALUES (7, 'Bß║┐n Tre', '─É╞░ß╗úc mß╗çnh danh l├á "xß╗⌐ dß╗½a" vß╗¢i nhiß╗üu ─æß║╖c sß║ún v├á l├áng nghß╗ü truyß╗ün thß╗æng.', NULL, 0.00, 0.00, '2024-10-30 08:00:12.826911', 'bentre', NULL);
INSERT INTO public.locationdetail VALUES (8, 'B├¼nh ─Éß╗ïnh', 'B├¼nh ─Éß╗ïnh nß╗òi tiß║┐ng vß╗¢i v├╡ cß╗ò truyß╗ün v├á nhiß╗üu di t├¡ch lß╗ïch sß╗¡.', NULL, 0.00, 0.00, '2024-10-30 08:00:12.826911', 'binhdinh', NULL);
INSERT INTO public.locationdetail VALUES (9, 'B├¼nh D╞░╞íng', 'B├¼nh D╞░╞íng l├á trung t├óm c├┤ng nghiß╗çp lß╗¢n cß╗ºa miß╗ün Nam Viß╗çt Nam.', NULL, 0.00, 0.00, '2024-10-30 08:00:12.826911', 'binhduong', NULL);
INSERT INTO public.locationdetail VALUES (10, 'B├¼nh Ph╞░ß╗¢c', 'B├¼nh Ph╞░ß╗¢c nß╗òi tiß║┐ng vß╗¢i rß╗½ng cao su v├á ─æiß╗üu, kinh tß║┐ chß╗º yß║┐u tß╗½ n├┤ng nghiß╗çp.', NULL, 0.00, 0.00, '2024-10-30 08:00:12.826911', 'binhphuoc', NULL);
INSERT INTO public.locationdetail VALUES (11, 'B├¼nh Thuß║¡n', 'N╞íi c├│ M┼⌐i N├⌐ vß╗¢i b├úi biß╗ân ─æß║╣p v├á c├íc ─æß╗ôi c├ít nß╗òi tiß║┐ng.', NULL, 0.00, 0.00, '2024-10-30 08:00:12.826911', 'binhthuan', NULL);
INSERT INTO public.locationdetail VALUES (12, 'C├á Mau', 'C├á Mau l├á cß╗▒c Nam cß╗ºa Viß╗çt Nam, nß╗òi tiß║┐ng vß╗¢i rß╗½ng ngß║¡p mß║╖n.', NULL, 0.00, 0.00, '2024-10-30 08:00:12.826911', 'camau', NULL);
INSERT INTO public.locationdetail VALUES (13, 'Cß║ºn Th╞í', 'Cß║ºn Th╞í l├á trung t├óm kinh tß║┐, v─ân h├│a cß╗ºa ─Éß╗ông bß║▒ng s├┤ng Cß╗¡u Long.', NULL, 0.00, 0.00, '2024-10-30 08:00:12.826911', 'cantho', NULL);
INSERT INTO public.locationdetail VALUES (14, 'Cao Bß║▒ng', 'Cao Bß║▒ng c├│ th├íc Bß║ún Giß╗æc v├á nhiß╗üu danh lam thß║»ng cß║únh.', NULL, 0.00, 0.00, '2024-10-30 08:00:12.826911', 'caobang', NULL);
INSERT INTO public.locationdetail VALUES (16, '─Éß║»k Lß║»k', '─Éß║»k Lß║»k l├á trung t├óm c├á ph├¬ lß╗¢n v├á v─ân h├│a T├óy Nguy├¬n.', NULL, 0.00, 0.00, '2024-10-30 08:00:12.826911', 'daklak', NULL);
INSERT INTO public.locationdetail VALUES (17, '─Éß║»k N├┤ng', 'Nß╗òi tiß║┐ng vß╗¢i c├íc th├íc n╞░ß╗¢c v├á cß║únh quan thi├¬n nhi├¬n h├╣ng v─⌐.', NULL, 0.00, 0.00, '2024-10-30 08:00:12.826911', 'daknong', NULL);
INSERT INTO public.locationdetail VALUES (18, '─Éiß╗çn Bi├¬n', '─Éiß╗çn Bi├¬n gß║»n liß╗ün vß╗¢i chiß║┐n thß║»ng ─Éiß╗çn Bi├¬n Phß╗º lß╗ïch sß╗¡.', NULL, 0.00, 0.00, '2024-10-30 08:00:12.826911', 'dienbien', NULL);
INSERT INTO public.locationdetail VALUES (19, '─Éß╗ông Nai', '─Éß╗ông Nai c├│ nß╗ün c├┤ng nghiß╗çp ph├ít triß╗ân v├á khu bß║úo tß╗ôn thi├¬n nhi├¬n Nam C├ít Ti├¬n.', NULL, 0.00, 0.00, '2024-10-30 08:00:12.826911', 'dongnai', NULL);
INSERT INTO public.locationdetail VALUES (20, '─Éß╗ông Th├íp', 'N╞íi c├│ v╞░ß╗¥n quß╗æc gia Tr├ám Chim v├á nhiß╗üu c├ính ─æß╗ông sen.', NULL, 0.00, 0.00, '2024-10-30 08:00:12.826911', 'dongthap', NULL);
INSERT INTO public.locationdetail VALUES (21, 'Gia Lai', 'Gia Lai nß╗òi tiß║┐ng vß╗¢i Biß╗ân Hß╗ô v├á v─ân h├│a cß╗ông chi├¬ng T├óy Nguy├¬n.', NULL, 0.00, 0.00, '2024-10-30 08:00:12.826911', 'gialai', NULL);
INSERT INTO public.locationdetail VALUES (58, 'TP. Hß╗ô Ch├¡ Minh', 'Trung t├óm kinh tß║┐ lß╗¢n nhß║Ñt Viß╗çt Nam vß╗¢i nhiß╗üu hoß║ít ─æß╗Öng s├┤i ─æß╗Öng.', NULL, 0.00, 0.00, '2024-10-30 08:00:12.826911', NULL, NULL);
INSERT INTO public.locationdetail VALUES (22, 'H├á Giang', 'H├á Giang c├│ cao nguy├¬n ─æ├í ─Éß╗ông V─ân v├á nhiß╗üu cung ─æ╞░ß╗¥ng ─æ├¿o ─æß║╣p.', NULL, 0.00, 0.00, '2024-10-30 08:00:12.826911', 'hagiang', NULL);
INSERT INTO public.locationdetail VALUES (23, 'H├á Nam', 'H├á Nam nß╗òi tiß║┐ng vß╗¢i l├áng nghß╗ü v├á ch├╣a Tam Ch├║c lß╗¢n nhß║Ñt Viß╗çt Nam.', NULL, 0.00, 0.00, '2024-10-30 08:00:12.826911', 'hanam', NULL);
INSERT INTO public.locationdetail VALUES (24, 'H├á Nß╗Öi', 'Thß╗º ─æ├┤ cß╗ºa Viß╗çt Nam vß╗¢i nhiß╗üu di t├¡ch lß╗ïch sß╗¡ v├á v─ân h├│a.', NULL, 0.00, 0.00, '2024-10-30 08:00:12.826911', 'hanoi', NULL);
INSERT INTO public.locationdetail VALUES (25, 'H├á T─⌐nh', 'H├á T─⌐nh c├│ b├úi biß╗ân Thi├¬n Cß║ºm v├á c├íc di t├¡ch lß╗ïch sß╗¡.', NULL, 0.00, 0.00, '2024-10-30 08:00:12.826911', 'hatinh', NULL);
INSERT INTO public.locationdetail VALUES (26, 'Hß║úi D╞░╞íng', 'Hß║úi D╞░╞íng nß╗òi tiß║┐ng vß╗¢i b├ính ─æß║¡u xanh v├á c├íc l├áng nghß╗ü truyß╗ün thß╗æng.', NULL, 0.00, 0.00, '2024-10-30 08:00:12.826911', 'haiduong', NULL);
INSERT INTO public.locationdetail VALUES (27, 'Hß║úi Ph├▓ng', 'Hß║úi Ph├▓ng l├á th├ánh phß╗æ cß║úng, c├│ b├úi biß╗ân ─Éß╗ô S╞ín nß╗òi tiß║┐ng.', NULL, 0.00, 0.00, '2024-10-30 08:00:12.826911', 'haiphong', NULL);
INSERT INTO public.locationdetail VALUES (28, 'Hß║¡u Giang', 'Hß║¡u Giang l├á mß╗Öt tß╗ënh thuß╗Öc ─æß╗ông bß║▒ng s├┤ng Cß╗¡u Long, ph├ít triß╗ân n├┤ng nghiß╗çp.', NULL, 0.00, 0.00, '2024-10-30 08:00:12.826911', 'haugiang', NULL);
INSERT INTO public.locationdetail VALUES (29, 'H├▓a B├¼nh', 'H├▓a B├¼nh c├│ thß╗ºy ─æiß╗çn H├▓a B├¼nh v├á v─ân h├│a d├ón tß╗Öc M╞░ß╗¥ng.', NULL, 0.00, 0.00, '2024-10-30 08:00:12.826911', 'hoabinh', NULL);
INSERT INTO public.locationdetail VALUES (15, '─É├á Nß║╡ng', '─É├á Nß║╡ng l├á th├ánh phß╗æ hiß╗çn ─æß║íi, c├│ nhiß╗üu b├úi biß╗ân v├á cß║ºu Rß╗ông nß╗òi tiß║┐ng.', NULL, 0.00, 0.00, '2024-10-30 08:00:12.826911', 'danang', NULL);
INSERT INTO public.locationdetail VALUES (30, 'H╞░ng Y├¬n', 'H╞░ng Y├¬n nß╗òi tiß║┐ng vß╗¢i nh├ún lß╗ông v├á nhiß╗üu l├áng nghß╗ü truyß╗ün thß╗æng.', NULL, 0.00, 0.00, '2024-10-30 08:00:12.826911', 'hungyen', NULL);
INSERT INTO public.locationdetail VALUES (31, 'Kh├ính H├▓a', 'Kh├ính H├▓a c├│ vß╗ïnh Nha Trang v├á nhiß╗üu b├úi biß╗ân ─æß║╣p.', NULL, 0.00, 0.00, '2024-10-30 08:00:12.826911', 'khanhhoa', NULL);
INSERT INTO public.locationdetail VALUES (32, 'Ki├¬n Giang', 'Ki├¬n Giang c├│ ─æß║úo Ph├║ Quß╗æc v├á cß║únh quan biß╗ân ─æß║úo ─æß║╣p.', NULL, 0.00, 0.00, '2024-10-30 08:00:12.826911', 'kiengiang', NULL);
INSERT INTO public.locationdetail VALUES (33, 'Kon Tum', 'Kon Tum nß╗òi tiß║┐ng vß╗¢i nh├á r├┤ng T├óy Nguy├¬n v├á c├íc bß║ún l├áng d├ón tß╗Öc.', NULL, 0.00, 0.00, '2024-10-30 08:00:12.826911', 'kontum', NULL);
INSERT INTO public.locationdetail VALUES (34, 'Lai Ch├óu', 'Lai Ch├óu c├│ nhiß╗üu ─æß╗ënh n├║i cao v├á phong cß║únh h├╣ng v─⌐.', NULL, 0.00, 0.00, '2024-10-30 08:00:12.826911', 'laichau', NULL);
INSERT INTO public.locationdetail VALUES (35, 'L├óm ─Éß╗ông', 'L├óm ─Éß╗ông c├│ th├ánh phß╗æ ─É├á Lß║ít vß╗¢i kh├¡ hß║¡u m├ít mß║╗ quanh n─âm.', NULL, 0.00, 0.00, '2024-10-30 08:00:12.826911', 'lamdong', NULL);
INSERT INTO public.locationdetail VALUES (36, 'Lß║íng S╞ín', 'Lß║íng S╞ín l├á tß╗ënh bi├¬n giß╗¢i vß╗¢i nhiß╗üu danh lam thß║»ng cß║únh.', NULL, 0.00, 0.00, '2024-10-30 08:00:12.826911', 'langson', NULL);
INSERT INTO public.locationdetail VALUES (37, 'L├áo Cai', 'L├áo Cai c├│ Sapa, ─æiß╗âm ─æß║┐n nß╗òi tiß║┐ng vß╗¢i cß║únh quan n├║i rß╗½ng.', NULL, 0.00, 0.00, '2024-10-30 08:00:12.826911', 'laocai', NULL);
INSERT INTO public.locationdetail VALUES (38, 'Long An', 'Long An c├│ nß╗ün n├┤ng nghiß╗çp ph├ít triß╗ân v├á gi├íp ranh TP. Hß╗ô Ch├¡ Minh.', NULL, 0.00, 0.00, '2024-10-30 08:00:12.826911', 'longan', NULL);
INSERT INTO public.locationdetail VALUES (39, 'Nam ─Éß╗ïnh', 'Nam ─Éß╗ïnh nß╗òi tiß║┐ng vß╗¢i nh├á thß╗¥ lß╗¢n v├á l├áng nghß╗ü chß║ím bß║íc.', NULL, 0.00, 0.00, '2024-10-30 08:00:12.826911', 'namdinh', NULL);
INSERT INTO public.locationdetail VALUES (40, 'Nghß╗ç An', 'Nghß╗ç An l├á qu├¬ h╞░╞íng cß╗ºa Chß╗º tß╗ïch Hß╗ô Ch├¡ Minh, c├│ biß╗ân Cß╗¡a L├▓.', NULL, 0.00, 0.00, '2024-10-30 08:00:12.826911', 'nghean', NULL);
INSERT INTO public.locationdetail VALUES (41, 'Ninh B├¼nh', 'Ninh B├¼nh c├│ Tr├áng An, Tam Cß╗æc - B├¡ch ─Éß╗Öng v├á nhiß╗üu di sß║ún thi├¬n nhi├¬n.', NULL, 0.00, 0.00, '2024-10-30 08:00:12.826911', 'ninhbinh', NULL);
INSERT INTO public.locationdetail VALUES (43, 'Ph├║ Thß╗ì', 'Ph├║ Thß╗ì l├á ─æß║Ñt tß╗ò H├╣ng V╞░╞íng vß╗¢i ─æß╗ün H├╣ng nß╗òi tiß║┐ng.', NULL, 0.00, 0.00, '2024-10-30 08:00:12.826911', 'phutho', NULL);
INSERT INTO public.locationdetail VALUES (42, 'Ninh Thuß║¡n', 'Nß╗òi tiß║┐ng vß╗¢i th├íp Ch─âm v├á c├íc c├ính ─æß╗ông muß╗æi, nho ─æß║╖c tr╞░ng.', NULL, 0.00, 0.00, '2024-10-30 08:00:12.826911', 'ninhthuan', NULL);
INSERT INTO public.locationdetail VALUES (44, 'Ph├║ Y├¬n', 'Ph├║ Y├¬n c├│ G├ánh ─É├í ─É─⌐a v├á nhiß╗üu b├úi biß╗ân hoang s╞í.', NULL, 0.00, 0.00, '2024-10-30 08:00:12.826911', 'phuyen', NULL);
INSERT INTO public.locationdetail VALUES (45, 'Quß║úng B├¼nh', 'Quß║úng B├¼nh c├│ ─æß╗Öng Phong Nha - Kß║╗ B├áng v├á nhiß╗üu hang ─æß╗Öng lß╗¢n.', NULL, 0.00, 0.00, '2024-10-30 08:00:12.826911', 'quangbinh', NULL);
INSERT INTO public.locationdetail VALUES (46, 'Quß║úng Nam', 'Quß║úng Nam c├│ phß╗æ cß╗ò Hß╗Öi An v├á th├ính ─æß╗ïa Mß╗╣ S╞ín.', NULL, 0.00, 0.00, '2024-10-30 08:00:12.826911', 'quangnam', NULL);
INSERT INTO public.locationdetail VALUES (47, 'Quß║úng Ng├úi', 'Quß║úng Ng├úi nß╗òi tiß║┐ng vß╗¢i ─æß║úo L├╜ S╞ín v├á v─ân h├│a Champa.', NULL, 0.00, 0.00, '2024-10-30 08:00:12.826911', 'quangngai', NULL);
INSERT INTO public.locationdetail VALUES (48, 'Quß║úng Ninh', 'Quß║úng Ninh c├│ vß╗ïnh Hß║í Long l├á di sß║ún thi├¬n nhi├¬n thß║┐ giß╗¢i.', NULL, 0.00, 0.00, '2024-10-30 08:00:12.826911', 'quangninh', NULL);
INSERT INTO public.locationdetail VALUES (49, 'Quß║úng Trß╗ï', 'Quß║úng Trß╗ï gß║»n liß╗ün vß╗¢i nhiß╗üu di t├¡ch lß╗ïch sß╗¡ chiß║┐n tranh.', NULL, 0.00, 0.00, '2024-10-30 08:00:12.826911', 'quangtri', NULL);
INSERT INTO public.locationdetail VALUES (50, 'S├│c Tr─âng', 'S├│c Tr─âng c├│ ch├╣a D╞íi, ch├╣a Ch├⌐n Kiß╗âu v├á v─ân h├│a Khmer.', NULL, 0.00, 0.00, '2024-10-30 08:00:12.826911', 'soctrang', NULL);
INSERT INTO public.locationdetail VALUES (51, 'S╞ín La', 'S╞ín La c├│ cao nguy├¬n Mß╗Öc Ch├óu vß╗¢i nhiß╗üu ─æß╗ôi ch├¿ v├á cß║únh quan ─æß║╣p.', NULL, 0.00, 0.00, '2024-10-30 08:00:12.826911', 'sonla', NULL);
INSERT INTO public.locationdetail VALUES (52, 'T├óy Ninh', 'T├óy Ninh c├│ n├║i B├á ─Éen v├á ─æß║ío Cao ─É├ái.', NULL, 0.00, 0.00, '2024-10-30 08:00:12.826911', 'tayninh', NULL);
INSERT INTO public.locationdetail VALUES (53, 'Th├íi B├¼nh', 'Th├íi B├¼nh l├á qu├¬ l├║a, ph├ít triß╗ân n├┤ng nghiß╗çp v├á l├áng nghß╗ü.', NULL, 0.00, 0.00, '2024-10-30 08:00:12.826911', 'thaibinh', NULL);
INSERT INTO public.locationdetail VALUES (54, 'Th├íi Nguy├¬n', 'Th├íi Nguy├¬n nß╗òi tiß║┐ng vß╗¢i ch├¿ Th├íi Nguy├¬n v├á c├íc khu c├┤ng nghiß╗çp.', NULL, 0.00, 0.00, '2024-10-30 08:00:12.826911', 'thainguyen', NULL);
INSERT INTO public.locationdetail VALUES (55, 'Thanh H├│a', 'Thanh H├│a c├│ b├úi biß╗ân Sß║ºm S╞ín v├á nhiß╗üu di t├¡ch lß╗ïch sß╗¡.', NULL, 0.00, 0.00, '2024-10-30 08:00:12.826911', 'thanhhoa', NULL);
INSERT INTO public.locationdetail VALUES (56, 'Thß╗½a Thi├¬n Huß║┐', 'Huß║┐ l├á cß╗æ ─æ├┤ vß╗¢i nhiß╗üu di sß║ún v─ân h├│a v├á l─âng tß║⌐m triß╗üu Nguyß╗àn.', NULL, 0.00, 0.00, '2024-10-30 08:00:12.826911', 'thuathienhue', NULL);
INSERT INTO public.locationdetail VALUES (57, 'Tiß╗ün Giang', 'Tiß╗ün Giang c├│ chß╗ú nß╗òi C├íi B├¿ v├á c├íc c├╣ lao s├┤ng n╞░ß╗¢c.', NULL, 0.00, 0.00, '2024-10-30 08:00:12.826911', 'tiengiang', NULL);
INSERT INTO public.locationdetail VALUES (59, 'Tr├á Vinh', 'Tr├á Vinh c├│ nhiß╗üu ch├╣a Khmer v├á v─ân h├│a truyß╗ün thß╗æng.', NULL, 0.00, 0.00, '2024-10-30 08:00:12.826911', 'travinh', NULL);
INSERT INTO public.locationdetail VALUES (60, 'Tuy├¬n Quang', 'Tuy├¬n Quang c├│ di t├¡ch T├ón Tr├áo, gß║»n vß╗¢i lß╗ïch sß╗¡ c├ích mß║íng.', NULL, 0.00, 0.00, '2024-10-30 08:00:12.826911', 'tuyenquang', NULL);
INSERT INTO public.locationdetail VALUES (61, 'V─⌐nh Long', 'V─⌐nh Long c├│ nhiß╗üu c├╣ lao v├á ─æß║╖c tr╞░ng miß╗ün s├┤ng n╞░ß╗¢c.', NULL, 0.00, 0.00, '2024-10-30 08:00:12.826911', 'vinhlong', NULL);
INSERT INTO public.locationdetail VALUES (62, 'V─⌐nh Ph├║c', 'V─⌐nh Ph├║c c├│ Tam ─Éß║úo, ─æß╗ïa ─æiß╗âm nghß╗ë d╞░ß╗íng v├á phong cß║únh ─æß║╣p.', NULL, 0.00, 0.00, '2024-10-30 08:00:12.826911', 'vinhphuc', NULL);
INSERT INTO public.locationdetail VALUES (63, 'Y├¬n B├íi', 'Y├¬n B├íi c├│ ruß╗Öng bß║¡c thang M├╣ Cang Chß║úi nß╗òi tiß║┐ng.', NULL, 0.00, 0.00, '2024-10-30 08:00:12.826911', 'yenbai', NULL);


--
-- Data for Name: postcomment; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.postcomment VALUES (1, 'vu951236', '─Éß║╣p qu├í', '2024-10-15', 1);


--
-- Data for Name: postdetail; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.postdetail VALUES (1, 'Kinh nghiß╗çm du lß╗ïch ─É├á Nß║╡ng', '2024-10-15', 'asset/img/post/danang.jpg', '─É├á Nß║╡ng, th├ánh phß╗æ biß╗ân xinh ─æß║╣p miß╗ün Trung, tß╗½ l├óu ─æ├ú trß╗ƒ th├ánh ─æiß╗âm ─æß║┐n l├╜ t╞░ß╗ƒng cho nhß╗»ng ai y├¬u th├¡ch vß║╗ ─æß║╣p thi├¬n nhi├¬n h├▓a quyß╗çn c├╣ng n├⌐t v─ân h├│a ─æß║╖c sß║»c. Nß╗òi tiß║┐ng vß╗¢i nhß╗»ng b├úi biß╗ân xanh ngß║»t, nhß╗»ng c├óy cß║ºu ─æß╗Öc ─æ├ío v├á v├┤ v├án m├│n ─ân ngon, ─É├á Nß║╡ng mang ─æß║┐n cho du kh├ích trß║úi nghiß╗çm ─æa dß║íng v├á kh├│ qu├¬n.

Khi ─æß║┐n ─É├á Nß║╡ng, b├úi biß╗ân Mß╗╣ Kh├¬ l├á ─æiß╗âm dß╗½ng ch├ón ─æß║ºu ti├¬n kh├┤ng thß╗â bß╗Å qua. ─É├óy l├á mß╗Öt trong nhß╗»ng b├úi biß╗ân ─æß║╣p nhß║Ñt Viß╗çt Nam, nß╗òi tiß║┐ng vß╗¢i b├úi c├ít trß║»ng mß╗ïn v├á l├án n╞░ß╗¢c trong xanh. Thß║ú m├¼nh d╞░ß╗¢i ├ính nß║»ng dß╗ïu nhß║╣, cß║úm nhß║¡n l├án gi├│ biß╗ân m├ít lß║ính v├á nghe tiß║┐ng s├│ng vß╗ù bß╗¥, du kh├ích sß║╜ cß║úm nhß║¡n ─æ╞░ß╗úc sß╗▒ th╞░ th├íi v├á b├¼nh y├¬n.

─É├á Nß║╡ng c├▓n ─æ╞░ß╗úc biß║┐t ─æß║┐n vß╗¢i hß╗ç thß╗æng nhß╗»ng c├óy cß║ºu ─æß╗Öc ─æ├ío, m├á nß╗òi bß║¡t nhß║Ñt l├á Cß║ºu Rß╗ông. C├óy cß║ºu n├áy kh├┤ng chß╗ë l├á ─æiß╗âm kß║┐t nß╗æi giß╗»a c├íc khu vß╗▒c trong th├ánh phß╗æ m├á c├▓n l├á biß╗âu t╞░ß╗úng hiß╗çn ─æß║íi cß╗ºa ─É├á Nß║╡ng. V├áo cuß╗æi tuß║ºn, du kh├ích sß║╜ ─æ╞░ß╗úc chi├¬m ng╞░ß╗íng m├án tr├¼nh diß╗àn rß╗ông phun lß╗¡a v├á n╞░ß╗¢c ─æß║╖c sß║»c, tß║ío n├¬n khung cß║únh lung linh v├á sß╗æng ─æß╗Öng.

Nß║┐u y├¬u th├¡ch kh├┤ng gian thi├¬n nhi├¬n h├╣ng v─⌐, B├á N├á Hills chß║»c chß║»n l├á ─æiß╗âm ─æß║┐n tiß║┐p theo m├á bß║ín n├¬n gh├⌐ qua. Nß║▒m ß╗ƒ ─æß╗Ö cao h╞ín 1.400 m├⌐t, B├á N├á Hills l├á khu nghß╗ë d╞░ß╗íng kß║┐t hß╗úp giß║úi tr├¡ vß╗¢i cß║únh quan n├║i non tr├╣ng ─æiß╗çp, kh├¡ hß║¡u m├ít mß║╗ quanh n─âm v├á nhß╗»ng c├┤ng tr├¼nh kiß║┐n tr├║c Ph├íp cß╗ò k├¡nh. Cß║ºu V├áng vß╗¢i hai b├án tay khß╗òng lß╗ô n├óng ─æß╗í l├á ─æiß╗âm nhß║Ñn nß╗òi tiß║┐ng, mang ─æß║┐n mß╗Öt g├│c nh├¼n tuyß╗çt ─æß║╣p v├á huyß╗ün ß║úo giß╗»a m├óy trß╗¥i.

ß║¿m thß╗▒c ─É├á Nß║╡ng l├á mß╗Öt trong nhß╗»ng yß║┐u tß╗æ g├│p phß║ºn tß║ío n├¬n sß╗⌐c h├║t cß╗ºa th├ánh phß╗æ n├áy. Bß║ín c├│ thß╗â thß╗¡ c├íc m├│n ─æß║╖c sß║ún nh╞░ b├ính tr├íng cuß╗æn thß╗ït heo, m├¼ Quß║úng, b├║n chß║ú c├í v├á hß║úi sß║ún t╞░╞íi ngon. H╞░╞íng vß╗ï ─æß║¡m ─æ├á v├á ─æa dß║íng cß╗ºa nhß╗»ng m├│n ─ân n├áy sß║╜ khiß║┐n bß║Ñt kß╗│ ai c┼⌐ng phß║úi xi├¬u l├▓ng v├á muß╗æn quay lß║íi ─æß╗â th╞░ß╗ƒng thß╗⌐c th├¬m.

Vß╗¢i cß║únh sß║»c thi├¬n nhi├¬n t╞░╞íi ─æß║╣p, nhß╗»ng c├┤ng tr├¼nh hiß╗çn ─æß║íi v├á nß╗ün ß║⌐m thß╗▒c phong ph├║, ─É├á Nß║╡ng thß╗▒c sß╗▒ l├á ─æiß╗âm ─æß║┐n ho├án hß║úo cho nhß╗»ng ai muß╗æn t├¼m kiß║┐m sß╗▒ th╞░ gi├ún v├á trß║úi nghiß╗çm v─ân h├│a ─æß╗Öc ─æ├ío cß╗ºa miß╗ün Trung. ─É├óy l├á n╞íi bß║ín c├│ thß╗â h├▓a m├¼nh v├áo thi├¬n nhi├¬n, chi├¬m ng╞░ß╗íng sß╗▒ ph├ít triß╗ân hiß╗çn ─æß║íi cß╗ºa mß╗Öt th├ánh phß╗æ trß║╗, v├á tß║¡n h╞░ß╗ƒng nhß╗»ng khoß║únh khß║»c ─æ├íng nhß╗¢ c├╣ng gia ─æ├¼nh v├á bß║ín b├¿.', 4.44, 16, 'danang', 15, 1);


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.users VALUES (2, 'vuad951236', '$2y$10$m1Dxc0rQbJdakzKB2BArUegWilFq7yFdcArYROXL/vDeHhkp4DxOq', 'hoangvuvo877@gmail.com', 'V├╡ Ho├áng V┼⌐', '440 Thß╗æng Nhß║Ñt', true, NULL, NULL, 0);
INSERT INTO public.users VALUES (1, 'vu951236', '$2y$10$wDuIK3liBjIFG7QeIaU93eyhNeyaDI20K2HkmngOoeCPuBaQHFBvC', 'hoangvuvo907@gmail.com', 'V├╡ Ho├áng V┼⌐', '440 Thß╗æng Nhß║Ñt', false, NULL, NULL, 0);
INSERT INTO public.users VALUES (4, 'vu951237', '$2y$10$eJAvVytP8xr1Adu8sgQQOe.lrXpFmRrxDc9VhxjyoUWmWsXLlSR6O', '2251120133@ut.edu.vn', 'V├╡ Ho├áng V┼⌐', '440 Thß╗æng Nhß║Ñt', false, NULL, NULL, 0);
INSERT INTO public.users VALUES (5, 'linh951236', '$2y$10$Nb63IuCqOuZpkqlooV9KreIMHZ1sHCsOuIwuzScD071KuVQE/8.86', 'truclinh300678@gmail.com', 'Tr├║c Linh', '440 Thß╗æng Nhß║Ñt', false, NULL, NULL, 0);
INSERT INTO public.users VALUES (6, 'thinh12345', '$2y$10$fsau3/2PpC4Ir5WF.04Yzea6vcav/3eIgtKbc3KxQdJQ13S1XJPQy', 'nguyenminhthinh26122004@gmail.com', 'Nguyß╗àn Minh Thß╗ïnh', 'Quy Nh╞ín', false, NULL, NULL, 0);


--
-- Name: comment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.comment_id_seq', 1, true);


--
-- Name: locationcomment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.locationcomment_id_seq', 1, false);


--
-- Name: locationdetail_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.locationdetail_id_seq', 63, true);


--
-- Name: postdetail_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.postdetail_id_seq', 1, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 6, true);


--
-- Name: postcomment comment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.postcomment
    ADD CONSTRAINT comment_pkey PRIMARY KEY (id);


--
-- Name: locationcomment locationcomment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.locationcomment
    ADD CONSTRAINT locationcomment_pkey PRIMARY KEY (id);


--
-- Name: locationdetail locationdetail_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.locationdetail
    ADD CONSTRAINT locationdetail_pkey PRIMARY KEY (id);


--
-- Name: postdetail postdetail_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.postdetail
    ADD CONSTRAINT postdetail_pkey PRIMARY KEY (id);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: users users_username_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key UNIQUE (username);


--
-- Name: postcomment comment_idpost_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.postcomment
    ADD CONSTRAINT comment_idpost_fkey FOREIGN KEY (idpost) REFERENCES public.postdetail(id) ON DELETE CASCADE;


--
-- Name: postdetail fk_userid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.postdetail
    ADD CONSTRAINT fk_userid FOREIGN KEY (userid) REFERENCES public.users(id);


--
-- Name: locationcomment locationcomment_idlocation_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.locationcomment
    ADD CONSTRAINT locationcomment_idlocation_fkey FOREIGN KEY (idlocation) REFERENCES public.locationdetail(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

