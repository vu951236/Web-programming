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
    date timestamp without time zone,
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
    point numeric DEFAULT 0,
    type character varying(50)
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
    date timestamp without time zone,
    image character varying(255),
    content text,
    rate numeric(3,2) DEFAULT 0,
    amongrate integer DEFAULT 0,
    location character varying(255),
    view integer,
    userid integer,
    description text
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

COPY public.locationcomment (id, username, content, date, idlocation) FROM stdin;
\.


--
-- Data for Name: locationdetail; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.locationdetail (id, name, information, image, rate, amongrate, date, location, point, type) FROM stdin;
1	An Giang	Tß╗ënh An Giang nß╗òi tiß║┐ng vß╗¢i chß╗ú nß╗òi Long Xuy├¬n v├á v├╣ng Bß║úy N├║i linh thi├¬ng.	\N	0.00	0.00	2024-10-30 08:00:12.826911	angiang	0	dongbang
50	S├│c Tr─âng	S├│c Tr─âng c├│ ch├╣a D╞íi, ch├╣a Ch├⌐n Kiß╗âu v├á v─ân h├│a Khmer.	\N	0.00	0.00	2024-10-30 08:00:12.826911	soctrang	0	dongbang
53	Th├íi B├¼nh	Th├íi B├¼nh l├á qu├¬ l├║a, ph├ít triß╗ân n├┤ng nghiß╗çp v├á l├áng nghß╗ü.	\N	0.00	0.00	2024-10-30 08:00:12.826911	thaibinh	0	dongbang
57	Tiß╗ün Giang	Tiß╗ün Giang c├│ chß╗ú nß╗òi C├íi B├¿ v├á c├íc c├╣ lao s├┤ng n╞░ß╗¢c.	\N	0.00	0.00	2024-10-30 08:00:12.826911	tiengiang	0	dongbang
59	Tr├á Vinh	Tr├á Vinh c├│ nhiß╗üu ch├╣a Khmer v├á v─ân h├│a truyß╗ün thß╗æng.	\N	0.00	0.00	2024-10-30 08:00:12.826911	travinh	0	dongbang
62	V─⌐nh Ph├║c	V─⌐nh Ph├║c c├│ Tam ─Éß║úo, ─æß╗ïa ─æiß╗âm nghß╗ë d╞░ß╗íng v├á phong cß║únh ─æß║╣p.	\N	0.00	0.00	2024-10-30 08:00:12.826911	vinhphuc	0	dongbang
5	Bß║íc Li├¬u	Nß╗òi tiß║┐ng vß╗¢i ─æiß╗çn gi├│ v├á gß║»n liß╗ün vß╗¢i giai thoß║íi C├┤ng tß╗¡ Bß║íc Li├¬u.	\N	0.00	0.00	2024-10-30 08:00:12.826911	baclieu	0	dongbang
6	Bß║»c Ninh	Bß║»c Ninh l├á c├íi n├┤i cß╗ºa d├ón ca quan hß╗ì truyß╗ün thß╗æng Viß╗çt Nam.	\N	0.00	0.00	2024-10-30 08:00:12.826911	bacninh	0	dongbang
7	Bß║┐n Tre	─É╞░ß╗úc mß╗çnh danh l├á "xß╗⌐ dß╗½a" vß╗¢i nhiß╗üu ─æß║╖c sß║ún v├á l├áng nghß╗ü truyß╗ün thß╗æng.	\N	0.00	0.00	2024-10-30 08:00:12.826911	bentre	0	dongbang
61	V─⌐nh Long	V─⌐nh Long c├│ nhiß╗üu c├╣ lao v├á ─æß║╖c tr╞░ng miß╗ün s├┤ng n╞░ß╗¢c.	\N	0.00	0.00	2024-10-30 08:00:12.826911	vinhlong	0	dongbang
9	B├¼nh D╞░╞íng	B├¼nh D╞░╞íng l├á trung t├óm c├┤ng nghiß╗çp lß╗¢n cß╗ºa miß╗ün Nam Viß╗çt Nam.	\N	0.00	0.00	2024-10-30 08:00:12.826911	binhduong	0	dongbang
10	B├¼nh Ph╞░ß╗¢c	B├¼nh Ph╞░ß╗¢c nß╗òi tiß║┐ng vß╗¢i rß╗½ng cao su v├á ─æiß╗üu, kinh tß║┐ chß╗º yß║┐u tß╗½ n├┤ng nghiß╗çp.	\N	0.00	0.00	2024-10-30 08:00:12.826911	binhphuoc	0	dongbang
13	Cß║ºn Th╞í	Cß║ºn Th╞í l├á trung t├óm kinh tß║┐, v─ân h├│a cß╗ºa ─Éß╗ông bß║▒ng s├┤ng Cß╗¡u Long.	\N	0.00	0.00	2024-10-30 08:00:12.826911	cantho	0	dongbang
19	─Éß╗ông Nai	─Éß╗ông Nai c├│ nß╗ün c├┤ng nghiß╗çp ph├ít triß╗ân v├á khu bß║úo tß╗ôn thi├¬n nhi├¬n Nam C├ít Ti├¬n.	\N	0.00	0.00	2024-10-30 08:00:12.826911	dongnai	0	dongbang
4	Bß║»c Kß║ín	Bß║»c Kß║ín c├│ hß╗ô Ba Bß╗â v├á nhiß╗üu cß║únh quan thi├¬n nhi├¬n tuyß╗çt ─æß║╣p.	\N	0.00	0.00	2024-10-30 08:00:12.826911	backan	0	nui\n
52	T├óy Ninh	T├óy Ninh c├│ n├║i B├á ─Éen v├á ─æß║ío Cao ─É├ái.	post/tayninh.jpg	0.00	0.00	2024-10-30 08:00:12.826911	tayninh	5.9	dongbang
16	─Éß║»k Lß║»k	─Éß║»k Lß║»k l├á trung t├óm c├á ph├¬ lß╗¢n v├á v─ân h├│a T├óy Nguy├¬n.	\N	0.00	0.00	2024-10-30 08:00:12.826911	daklak	0	nui
54	Th├íi Nguy├¬n	Th├íi Nguy├¬n nß╗òi tiß║┐ng vß╗¢i ch├¿ Th├íi Nguy├¬n v├á c├íc khu c├┤ng nghiß╗çp.	\N	0.00	0.00	2024-10-30 08:00:12.826911	thainguyen	0	nui
60	Tuy├¬n Quang	Tuy├¬n Quang c├│ di t├¡ch T├ón Tr├áo, gß║»n vß╗¢i lß╗ïch sß╗¡ c├ích mß║íng.	\N	0.00	0.00	2024-10-30 08:00:12.826911	tuyenquang	0	nui
63	Y├¬n B├íi	Y├¬n B├íi c├│ ruß╗Öng bß║¡c thang M├╣ Cang Chß║úi nß╗òi tiß║┐ng.	\N	0.00	0.00	2024-10-30 08:00:12.826911	yenbai	0	nui
3	Bß║»c Giang	Bß║»c Giang c├│ nhiß╗üu cß║únh quan tß╗▒ nhi├¬n v├á l├á n╞íi sß║ún xuß║Ñt vß║úi thiß╗üu nß╗òi tiß║┐ng.	\N	0.00	0.00	2024-10-30 08:00:12.826911	bacgiang	0	nui
14	Cao Bß║▒ng	Cao Bß║▒ng c├│ th├íc Bß║ún Giß╗æc v├á nhiß╗üu danh lam thß║»ng cß║únh.	\N	0.00	0.00	2024-10-30 08:00:12.826911	caobang	0	nui
17	─Éß║»k N├┤ng	Nß╗òi tiß║┐ng vß╗¢i c├íc th├íc n╞░ß╗¢c v├á cß║únh quan thi├¬n nhi├¬n h├╣ng v─⌐.	\N	0.00	0.00	2024-10-30 08:00:12.826911	daknong	0	nui
18	─Éiß╗çn Bi├¬n	─Éiß╗çn Bi├¬n gß║»n liß╗ün vß╗¢i chiß║┐n thß║»ng ─Éiß╗çn Bi├¬n Phß╗º lß╗ïch sß╗¡.	\N	0.00	0.00	2024-10-30 08:00:12.826911	dienbien	0	nui
20	─Éß╗ông Th├íp	N╞íi c├│ v╞░ß╗¥n quß╗æc gia Tr├ám Chim v├á nhiß╗üu c├ính ─æß╗ông sen.	\N	0.00	0.00	2024-10-30 08:00:12.826911	dongthap	0	dongbang
24	H├á Nß╗Öi	Thß╗º ─æ├┤ cß╗ºa Viß╗çt Nam vß╗¢i nhiß╗üu di t├¡ch lß╗ïch sß╗¡ v├á v─ân h├│a.	\N	0.00	0.00	2024-10-30 08:00:12.826911	hanoi	0	dongbang
27	Hß║úi Ph├▓ng	Hß║úi Ph├▓ng l├á th├ánh phß╗æ cß║úng, c├│ b├úi biß╗ân ─Éß╗ô S╞ín nß╗òi tiß║┐ng.	\N	0.00	0.00	2024-10-30 08:00:12.826911	haiphong	0	dongbang
28	Hß║¡u Giang	Hß║¡u Giang l├á mß╗Öt tß╗ënh thuß╗Öc ─æß╗ông bß║▒ng s├┤ng Cß╗¡u Long, ph├ít triß╗ân n├┤ng nghiß╗çp.	\N	0.00	0.00	2024-10-30 08:00:12.826911	haugiang	0	dongbang
30	H╞░ng Y├¬n	H╞░ng Y├¬n nß╗òi tiß║┐ng vß╗¢i nh├ún lß╗ông v├á nhiß╗üu l├áng nghß╗ü truyß╗ün thß╗æng.	\N	0.00	0.00	2024-10-30 08:00:12.826911	hungyen	0	dongbang
23	H├á Nam	H├á Nam nß╗òi tiß║┐ng vß╗¢i l├áng nghß╗ü v├á ch├╣a Tam Ch├║c lß╗¢n nhß║Ñt Viß╗çt Nam.	\N	0.00	0.00	2024-10-30 08:00:12.826911	hanam	0	dongbang
38	Long An	Long An c├│ nß╗ün n├┤ng nghiß╗çp ph├ít triß╗ân v├á gi├íp ranh TP. Hß╗ô Ch├¡ Minh.	\N	0.00	0.00	2024-10-30 08:00:12.826911	longan	0	dongbang
39	Nam ─Éß╗ïnh	Nam ─Éß╗ïnh nß╗òi tiß║┐ng vß╗¢i nh├á thß╗¥ lß╗¢n v├á l├áng nghß╗ü chß║ím bß║íc.	\N	0.00	0.00	2024-10-30 08:00:12.826911	namdinh	0	dongbang
41	Ninh B├¼nh	Ninh B├¼nh c├│ Tr├áng An, Tam Cß╗æc - B├¡ch ─Éß╗Öng v├á nhiß╗üu di sß║ún thi├¬n nhi├¬n.	\N	0.00	0.00	2024-10-30 08:00:12.826911	ninhbinh	0	dongbang
48	Quß║úng Ninh	Quß║úng Ninh c├│ vß╗ïnh Hß║í Long l├á di sß║ún thi├¬n nhi├¬n thß║┐ giß╗¢i.	\N	0.00	0.00	2024-10-30 08:00:12.826911	quangninh	0	bien
22	H├á Giang	H├á Giang c├│ cao nguy├¬n ─æ├í ─Éß╗ông V─ân v├á nhiß╗üu cung ─æ╞░ß╗¥ng ─æ├¿o ─æß║╣p.	\N	0.00	0.00	2024-10-30 08:00:12.826911	hagiang	0	nui
36	Lß║íng S╞ín	Lß║íng S╞ín l├á tß╗ënh bi├¬n giß╗¢i vß╗¢i nhiß╗üu danh lam thß║»ng cß║únh.	\N	0.00	0.00	2024-10-30 08:00:12.826911	langson	0	nui
43	Ph├║ Thß╗ì	Ph├║ Thß╗ì l├á ─æß║Ñt tß╗ò H├╣ng V╞░╞íng vß╗¢i ─æß╗ün H├╣ng nß╗òi tiß║┐ng.	\N	0.00	0.00	2024-10-30 08:00:12.826911	phutho	0	nui
51	S╞ín La	S╞ín La c├│ cao nguy├¬n Mß╗Öc Ch├óu vß╗¢i nhiß╗üu ─æß╗ôi ch├¿ v├á cß║únh quan ─æß║╣p.	post/sonla.jpg	0.00	0.00	2024-10-30 08:00:12.826911	sonla	6	nui
21	Gia Lai	Gia Lai nß╗òi tiß║┐ng vß╗¢i Biß╗ân Hß╗ô v├á v─ân h├│a cß╗ông chi├¬ng T├óy Nguy├¬n.	\N	0.00	0.00	2024-10-30 08:00:12.826911	gialai	0	nui
25	H├á T─⌐nh	H├á T─⌐nh c├│ b├úi biß╗ân Thi├¬n Cß║ºm v├á c├íc di t├¡ch lß╗ïch sß╗¡.	\N	0.00	0.00	2024-10-30 08:00:12.826911	hatinh	0	nui
29	H├▓a B├¼nh	H├▓a B├¼nh c├│ thß╗ºy ─æiß╗çn H├▓a B├¼nh v├á v─ân h├│a d├ón tß╗Öc M╞░ß╗¥ng.	\N	0.00	0.00	2024-10-30 08:00:12.826911	hoabinh	0	nui
33	Kon Tum	Kon Tum nß╗òi tiß║┐ng vß╗¢i nh├á r├┤ng T├óy Nguy├¬n v├á c├íc bß║ún l├áng d├ón tß╗Öc.	\N	0.00	0.00	2024-10-30 08:00:12.826911	kontum	0	nui
34	Lai Ch├óu	Lai Ch├óu c├│ nhiß╗üu ─æß╗ënh n├║i cao v├á phong cß║únh h├╣ng v─⌐.	\N	0.00	0.00	2024-10-30 08:00:12.826911	laichau	0	nui
35	L├óm ─Éß╗ông	L├óm ─Éß╗ông c├│ th├ánh phß╗æ ─É├á Lß║ít vß╗¢i kh├¡ hß║¡u m├ít mß║╗ quanh n─âm.	\N	0.00	0.00	2024-10-30 08:00:12.826911	lamdong	0	nui
37	L├áo Cai	L├áo Cai c├│ Sapa, ─æiß╗âm ─æß║┐n nß╗òi tiß║┐ng vß╗¢i cß║únh quan n├║i rß╗½ng.	\N	0.00	0.00	2024-10-30 08:00:12.826911	laocai	0	nui
42	Ninh Thuß║¡n	Nß╗òi tiß║┐ng vß╗¢i th├íp Ch─âm v├á c├íc c├ính ─æß╗ông muß╗æi, nho ─æß║╖c tr╞░ng.	\N	0.00	0.00	2024-10-30 08:00:12.826911	ninhthuan	0	nui
32	Ki├¬n Giang	Ki├¬n Giang c├│ ─æß║úo Ph├║ Quß╗æc v├á cß║únh quan biß╗ân ─æß║úo ─æß║╣p.	\N	0.00	0.00	2024-10-30 08:00:12.826911	kiengiang	0	bien
47	Quß║úng Ng├úi	Quß║úng Ng├úi nß╗òi tiß║┐ng vß╗¢i ─æß║úo L├╜ S╞ín v├á v─ân h├│a Champa.	\N	0.00	0.00	2024-10-30 08:00:12.826911	quangngai	0	bien
45	Quß║úng B├¼nh	Quß║úng B├¼nh c├│ ─æß╗Öng Phong Nha - Kß║╗ B├áng v├á nhiß╗üu hang ─æß╗Öng lß╗¢n.	\N	0.00	0.00	2024-10-30 08:00:12.826911	quangbinh	0	nui
49	Quß║úng Trß╗ï	Quß║úng Trß╗ï gß║»n liß╗ün vß╗¢i nhiß╗üu di t├¡ch lß╗ïch sß╗¡ chiß║┐n tranh.	\N	0.00	0.00	2024-10-30 08:00:12.826911	quangtri	0	nui
55	Thanh H├│a	Thanh H├│a c├│ b├úi biß╗ân Sß║ºm S╞ín v├á nhiß╗üu di t├¡ch lß╗ïch sß╗¡.	\N	0.00	0.00	2024-10-30 08:00:12.826911	thanhhoa	0	bien
2	B├á Rß╗ïa - V┼⌐ng T├áu	N╞íi c├│ b├úi biß╗ân V┼⌐ng T├áu nß╗òi tiß║┐ng, thu h├║t nhiß╗üu kh├ích du lß╗ïch.	\N	0.00	0.00	2024-10-30 08:00:12.826911	bariavungtau	0	bien
11	B├¼nh Thuß║¡n	N╞íi c├│ M┼⌐i N├⌐ vß╗¢i b├úi biß╗ân ─æß║╣p v├á c├íc ─æß╗ôi c├ít nß╗òi tiß║┐ng.	\N	0.00	0.00	2024-10-30 08:00:12.826911	binhthuan	0	bien
12	C├á Mau	C├á Mau l├á cß╗▒c Nam cß╗ºa Viß╗çt Nam, nß╗òi tiß║┐ng vß╗¢i rß╗½ng ngß║¡p mß║╖n.	\N	0.00	0.00	2024-10-30 08:00:12.826911	camau	0	bien
26	Hß║úi D╞░╞íng	Hß║úi D╞░╞íng nß╗òi tiß║┐ng vß╗¢i b├ính ─æß║¡u xanh v├á c├íc l├áng nghß╗ü truyß╗ün thß╗æng.	\N	0.00	0.00	2024-10-30 08:00:12.826911	haiduong	0	bien
31	Kh├ính H├▓a	Kh├ính H├▓a c├│ vß╗ïnh Nha Trang v├á nhiß╗üu b├úi biß╗ân ─æß║╣p.	\N	0.00	0.00	2024-10-30 08:00:12.826911	khanhhoa	0	bien
44	Ph├║ Y├¬n	Ph├║ Y├¬n c├│ G├ánh ─É├í ─É─⌐a v├á nhiß╗üu b├úi biß╗ân hoang s╞í.	\N	0.00	0.00	2024-10-30 08:00:12.826911	phuyen	0	bien
46	Quß║úng Nam	Quß║úng Nam c├│ phß╗æ cß╗ò Hß╗Öi An v├á th├ính ─æß╗ïa Mß╗╣ S╞ín.	\N	0.00	0.00	2024-10-30 08:00:12.826911	quangnam	0	bien
8	B├¼nh ─Éß╗ïnh	B├¼nh ─Éß╗ïnh nß╗òi tiß║┐ng vß╗¢i v├╡ cß╗ò truyß╗ün v├á nhiß╗üu di t├¡ch lß╗ïch sß╗¡.	\N	0.00	0.00	2024-10-30 08:00:12.826911	binhdinh	0	bien
56	Thß╗½a Thi├¬n Huß║┐	Huß║┐ l├á cß╗æ ─æ├┤ vß╗¢i nhiß╗üu di sß║ún v─ân h├│a v├á l─âng tß║⌐m triß╗üu Nguyß╗àn.	\N	0.00	0.00	2024-10-30 08:00:12.826911	thuathienhue	0	bien
40	Nghß╗ç An	Nghß╗ç An l├á qu├¬ h╞░╞íng cß╗ºa Chß╗º tß╗ïch Hß╗ô Ch├¡ Minh, c├│ biß╗ân Cß╗¡a L├▓.	\N	0.00	0.00	2024-10-30 08:00:12.826911	nghean	0	bien
58	TP. Hß╗ô Ch├¡ Minh	Trung t├óm kinh tß║┐ lß╗¢n nhß║Ñt Viß╗çt Nam vß╗¢i nhiß╗üu hoß║ít ─æß╗Öng s├┤i ─æß╗Öng.	\N	0.00	0.00	2024-10-30 08:00:12.826911	tphochiminh	0	bien
15	─É├á Nß║╡ng	─É├á Nß║╡ng l├á th├ánh phß╗æ hiß╗çn ─æß║íi, c├│ nhiß╗üu b├úi biß╗ân v├á cß║ºu Rß╗ông nß╗òi tiß║┐ng.	post/danang.jpg	0.00	0.00	2024-10-30 08:00:12.826911	danang	6.37	bien
\.


--
-- Data for Name: postcomment; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.postcomment (id, username, content, date, idpost) FROM stdin;
1	vu951236	─Éß║╣p qu├í	2024-10-15 00:00:00	1
2	vu951236	t├┤i muß╗æn ─æi thß╗¡	2024-11-01 11:20:39	16
3	nhuan12345	─æß║╣p qu├í	2024-11-01 11:21:23	13
\.


--
-- Data for Name: postdetail; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.postdetail (id, name, date, image, content, rate, amongrate, location, view, userid, description) FROM stdin;
4	Cß║únh ─æß║╣p thi├¬n nhi├¬n Ph├║ Y├¬n	2024-10-14 08:45:00	asset/img/post/phuyen.jpg	Ph├║ Y├¬n l├á n╞íi d├ánh cho ng╞░ß╗¥i th├¡ch kh├ím ph├í thi├¬n nhi├¬n hoang s╞í vß╗¢i c├íc ghß╗ünh ─æ├í v├á b├úi biß╗ân tuyß╗çt ─æß║╣p.	4.60	1	phuyen	40	6	Ph├║ Y├¬n ─æß║╣p vß╗¢i biß╗ân xanh v├á thi├¬n nhi├¬n hoang s╞í.
5	H├ánh tr├¼nh H├á Nß╗Öi - Tr├íi tim Viß╗çt Nam	2024-10-10 14:15:00	asset/img/post/hanoi.jpeg	H├á Nß╗Öi mang ─æß║¡m n├⌐t v─ân h├│a v├á lß╗ïch sß╗¡ vß╗¢i Hß╗ô G╞░╞ím, phß╗æ cß╗ò v├á ß║⌐m thß╗▒c ─æ╞░ß╗¥ng phß╗æ ─æß╗Öc ─æ├ío.	4.70	2	hanoi	70	3	H├á Nß╗Öi cß╗ò k├¡nh v├á hiß╗çn ─æß║íi vß╗¢i nhiß╗üu n├⌐t v─ân h├│a ─æß║╖c sß║»c.
6	Biß╗ân Nha Trang - ─Éiß╗âm ─æß║┐n l├╜ t╞░ß╗ƒng	2024-10-15 15:20:00	asset/img/post/nhatrang.jpg	B├úi biß╗ân Nha Trang nß╗òi tiß║┐ng vß╗¢i c├ít trß║»ng v├á n╞░ß╗¢c biß╗ân trong xanh, ─æiß╗âm ─æß║┐n l├╜ t╞░ß╗ƒng cho nhß╗»ng ai y├¬u th├¡ch biß╗ân.	4.90	4	nhatrang	65	4	Biß╗ân xanh Nha Trang v├á nhß╗»ng trß║úi nghiß╗çm tuyß╗çt vß╗¥i.
12	Chinh phß╗Ñc n├║i Bß║ích M├ú - Huß║┐	2024-10-18 06:30:00	asset/img/post/bachma.jpg	N├║i Bß║ích M├ú mang lß║íi trß║úi nghiß╗çm leo n├║i th├║ vß╗ï vß╗¢i cß║únh quan thi├¬n nhi├¬n tuyß╗çt ─æß║╣p tß║íi Huß║┐.	4.40	3	hue	45	4	N├║i Bß║ích M├ú vß╗¢i thi├¬n nhi├¬n xanh m├ít v├á nhß╗»ng trß║úi nghiß╗çm leo n├║i kh├│ qu├¬n.
19	Thuyß╗ün ─æß╗Öc mß╗Öc tr├¬n s├┤ng H╞░╞íng	2024-10-17 16:30:00	asset/img/post/thuyendocmoc.jpg	─Éi thuyß╗ün ─æß╗Öc mß╗Öc tr├¬n s├┤ng H╞░╞íng mang ─æß║┐n trß║úi nghiß╗çm y├¬n b├¼nh, ngß║»m cß║únh v├á t├¼m hiß╗âu cuß╗Öc sß╗æng cß╗ºa ng╞░ß╗¥i d├ón xung quanh.	4.80	1	hue	78	1	Thuyß╗ün ─æß╗Öc mß╗Öc tr├¬n s├┤ng H╞░╞íng, trß║úi nghiß╗çm b├¼nh y├¬n giß╗»a thi├¬n nhi├¬n.
2	Kh├ím ph├í Huß║┐ cß╗ò k├¡nh	2024-10-18 09:00:00	asset/img/post/hue.webp\n	Huß║┐, th├ánh phß╗æ nß║▒m b├¬n d├▓ng s├┤ng H╞░╞íng th╞í mß╗Öng, nß╗òi tiß║┐ng vß╗¢i di sß║ún cung ─æ├¼nh v├á vß║╗ ─æß║╣p l├úng mß║ín, l├á ─æiß╗âm ─æß║┐n kh├┤ng thß╗â bß╗Å qua ─æß╗æi vß╗¢i nhß╗»ng ai y├¬u th├¡ch lß╗ïch sß╗¡ v├á v─ân h├│a. Vß╗¢i nhß╗»ng c├┤ng tr├¼nh kiß║┐n tr├║c cß╗ò k├¡nh, Huß║┐ kh├┤ng chß╗ë l├á n╞íi l╞░u giß╗» nhß╗»ng gi├í trß╗ï v─ân h├│a ─æß╗Öc ─æ├ío m├á c├▓n mang ─æß║┐n cho du kh├ích nhß╗»ng trß║úi nghiß╗çm kh├│ qu├¬n.\n\nKhi ─æß║╖t ch├ón ─æß║┐n Huß║┐, du kh├ích sß║╜ ngay lß║¡p tß╗⌐c bß╗ï cuß╗æn h├║t bß╗ƒi vß║╗ ─æß║╣p trß║ºm mß║╖c cß╗ºa nhß╗»ng di sß║ún lß╗ïch sß╗¡. ─Éß║íi Nß╗Öi, n╞íi tß╗½ng l├á trung t├óm quyß╗ün lß╗▒c cß╗ºa triß╗üu ─æß║íi Nguyß╗àn, vß╗¢i nhß╗»ng bß╗⌐c t╞░ß╗¥ng th├ánh ki├¬n cß╗æ v├á c├íc c├┤ng tr├¼nh kiß║┐n tr├║c tuyß╗çt mß╗╣, hiß╗çn l├¬n nh╞░ mß╗Öt bß╗⌐c tranh sß╗æng ─æß╗Öng vß╗ü qu├í khß╗⌐. Mß╗ùi g├│c nhß╗Å cß╗ºa ─Éß║íi Nß╗Öi ─æß╗üu chß╗⌐a ─æß╗▒ng nhß╗»ng c├óu chuyß╗çn lß╗ïch sß╗¡, mang lß║íi cho du kh├ích cß║úm gi├íc nh╞░ ─æang lß║íc v├áo mß╗Öt thß║┐ giß╗¢i xa x╞░a.\n\nB├¬n cß║ính ─æ├│, vß║╗ ─æß║╣p cß╗ºa Huß║┐ c├▓n nß║▒m ß╗ƒ d├▓ng s├┤ng H╞░╞íng th╞í mß╗Öng v├á nhß╗»ng chiß║┐c thuyß╗ün rß╗ông lß╗»ng lß╗¥ tr├┤i. Du kh├ích c├│ thß╗â thß║ú hß╗ôn v├áo kh├┤ng gian y├¬n b├¼nh, chi├¬m ng╞░ß╗íng cß║únh sß║»c thi├¬n nhi├¬n tuyß╗çt ─æß║╣p v├á tß║¡n h╞░ß╗ƒng kh├┤ng kh├¡ trong l├ánh n╞íi ─æ├óy. ─Éß║╖c biß╗çt, v├áo buß╗òi tß╗æi, khi ├ính ─æ├¿n lung linh phß║ún chiß║┐u tr├¬n mß║╖t n╞░ß╗¢c, s├┤ng H╞░╞íng trß╗ƒ n├¬n huyß╗ün ß║úo v├á l├úng mß║ín, khiß║┐n ai c┼⌐ng muß╗æn dß╗½ng lß║íi ─æß╗â th╞░ß╗ƒng thß╗⌐c khoß║únh khß║»c tuyß╗çt vß╗¥i n├áy.\n\nß║¿m thß╗▒c Huß║┐ c┼⌐ng l├á mß╗Öt phß║ºn kh├┤ng thß╗â thiß║┐u trong h├ánh tr├¼nh kh├ím ph├í th├ánh phß╗æ n├áy. Nhß╗»ng m├│n ─ân ─æß║╖c sß║ún nh╞░ b├║n b├▓ Huß║┐, b├ính b├¿o, v├á nem lß╗Ñi ─æß╗üu mang ─æß║¡m h╞░╞íng vß╗ï v├á n├⌐t v─ân h├│a cß╗ºa v├╣ng ─æß║Ñt cß╗æ ─æ├┤. Mß╗ùi m├│n ─ân kh├┤ng chß╗ë l├á mß╗Öt bß╗»a tiß╗çc cho vß╗ï gi├íc m├á c├▓n l├á mß╗Öt h├ánh tr├¼nh kh├ím ph├í nhß╗»ng n├⌐t v─ân h├│a ß║⌐m thß╗▒c phong ph├║ v├á ─æa dß║íng.\n\nCuß╗æi c├╣ng, nhß╗ïp sß╗æng chß║¡m r├úi cß╗ºa ng╞░ß╗¥i d├ón n╞íi ─æ├óy c┼⌐ng l├á ─æiß╗üu thu h├║t du kh├ích. Huß║┐ kh├┤ng ß╗ôn ├áo, n├ío nhiß╗çt nh╞░ c├íc th├ánh phß╗æ lß╗¢n kh├íc, m├á b├¼nh y├¬n v├á th╞░ th├íi, mang ─æß║┐n cho du kh├ích cß║úm gi├íc gß║ºn g┼⌐i v├á th├ón quen. ─É├óy l├á n╞íi bß║ín c├│ thß╗â t├¼m thß║Ñy sß╗▒ b├¼nh y├¬n trong t├óm hß╗ôn, chi├¬m nghiß╗çm nhß╗»ng gi├í trß╗ï v─ân h├│a s├óu sß║»c v├á h├▓a m├¼nh v├áo nhß╗ïp sß╗æng nhß║╣ nh├áng cß╗ºa th├ánh phß╗æ.\n\nT├│m lß║íi, Huß║┐ kh├┤ng chß╗ë l├á mß╗Öt ─æiß╗âm ─æß║┐n du lß╗ïch m├á c├▓n l├á mß╗Öt kho b├íu v─ân h├│a vß╗¢i nhß╗»ng gi├í trß╗ï lß╗ïch sß╗¡ qu├╜ gi├í. Vß╗¢i vß║╗ ─æß║╣p l├úng mß║ín v├á sß╗▒ thanh b├¼nh, Huß║┐ chß║»c chß║»n sß║╜ ─æß╗â lß║íi trong l├▓ng du kh├ích nhß╗»ng ß║Ñn t╞░ß╗úng kh├│ phai.\n\n	4.50	3	hue	30	2	Di sß║ún Huß║┐ cß╗ò k├¡nh, cß║únh ─æß║╣p y├¬n b├¼nh v├á di sß║ún v─ân h├│a.
1	Kinh nghiß╗çm du lß╗ïch ─É├á Nß║╡ng	2024-10-15 00:00:00	asset/img/post/danang.jpg	─É├á Nß║╡ng, th├ánh phß╗æ biß╗ân xinh ─æß║╣p miß╗ün Trung, tß╗½ l├óu ─æ├ú trß╗ƒ th├ánh ─æiß╗âm ─æß║┐n l├╜ t╞░ß╗ƒng cho nhß╗»ng ai y├¬u th├¡ch vß║╗ ─æß║╣p thi├¬n nhi├¬n h├▓a quyß╗çn c├╣ng n├⌐t v─ân h├│a ─æß║╖c sß║»c. Nß╗òi tiß║┐ng vß╗¢i nhß╗»ng b├úi biß╗ân xanh ngß║»t, nhß╗»ng c├óy cß║ºu ─æß╗Öc ─æ├ío v├á v├┤ v├án m├│n ─ân ngon, ─É├á Nß║╡ng mang ─æß║┐n cho du kh├ích trß║úi nghiß╗çm ─æa dß║íng v├á kh├│ qu├¬n.\n\nKhi ─æß║┐n ─É├á Nß║╡ng, b├úi biß╗ân Mß╗╣ Kh├¬ l├á ─æiß╗âm dß╗½ng ch├ón ─æß║ºu ti├¬n kh├┤ng thß╗â bß╗Å qua. ─É├óy l├á mß╗Öt trong nhß╗»ng b├úi biß╗ân ─æß║╣p nhß║Ñt Viß╗çt Nam, nß╗òi tiß║┐ng vß╗¢i b├úi c├ít trß║»ng mß╗ïn v├á l├án n╞░ß╗¢c trong xanh. Thß║ú m├¼nh d╞░ß╗¢i ├ính nß║»ng dß╗ïu nhß║╣, cß║úm nhß║¡n l├án gi├│ biß╗ân m├ít lß║ính v├á nghe tiß║┐ng s├│ng vß╗ù bß╗¥, du kh├ích sß║╜ cß║úm nhß║¡n ─æ╞░ß╗úc sß╗▒ th╞░ th├íi v├á b├¼nh y├¬n.\n\n─É├á Nß║╡ng c├▓n ─æ╞░ß╗úc biß║┐t ─æß║┐n vß╗¢i hß╗ç thß╗æng nhß╗»ng c├óy cß║ºu ─æß╗Öc ─æ├ío, m├á nß╗òi bß║¡t nhß║Ñt l├á Cß║ºu Rß╗ông. C├óy cß║ºu n├áy kh├┤ng chß╗ë l├á ─æiß╗âm kß║┐t nß╗æi giß╗»a c├íc khu vß╗▒c trong th├ánh phß╗æ m├á c├▓n l├á biß╗âu t╞░ß╗úng hiß╗çn ─æß║íi cß╗ºa ─É├á Nß║╡ng. V├áo cuß╗æi tuß║ºn, du kh├ích sß║╜ ─æ╞░ß╗úc chi├¬m ng╞░ß╗íng m├án tr├¼nh diß╗àn rß╗ông phun lß╗¡a v├á n╞░ß╗¢c ─æß║╖c sß║»c, tß║ío n├¬n khung cß║únh lung linh v├á sß╗æng ─æß╗Öng.\n\nNß║┐u y├¬u th├¡ch kh├┤ng gian thi├¬n nhi├¬n h├╣ng v─⌐, B├á N├á Hills chß║»c chß║»n l├á ─æiß╗âm ─æß║┐n tiß║┐p theo m├á bß║ín n├¬n gh├⌐ qua. Nß║▒m ß╗ƒ ─æß╗Ö cao h╞ín 1.400 m├⌐t, B├á N├á Hills l├á khu nghß╗ë d╞░ß╗íng kß║┐t hß╗úp giß║úi tr├¡ vß╗¢i cß║únh quan n├║i non tr├╣ng ─æiß╗çp, kh├¡ hß║¡u m├ít mß║╗ quanh n─âm v├á nhß╗»ng c├┤ng tr├¼nh kiß║┐n tr├║c Ph├íp cß╗ò k├¡nh. Cß║ºu V├áng vß╗¢i hai b├án tay khß╗òng lß╗ô n├óng ─æß╗í l├á ─æiß╗âm nhß║Ñn nß╗òi tiß║┐ng, mang ─æß║┐n mß╗Öt g├│c nh├¼n tuyß╗çt ─æß║╣p v├á huyß╗ün ß║úo giß╗»a m├óy trß╗¥i.\n\nß║¿m thß╗▒c ─É├á Nß║╡ng l├á mß╗Öt trong nhß╗»ng yß║┐u tß╗æ g├│p phß║ºn tß║ío n├¬n sß╗⌐c h├║t cß╗ºa th├ánh phß╗æ n├áy. Bß║ín c├│ thß╗â thß╗¡ c├íc m├│n ─æß║╖c sß║ún nh╞░ b├ính tr├íng cuß╗æn thß╗ït heo, m├¼ Quß║úng, b├║n chß║ú c├í v├á hß║úi sß║ún t╞░╞íi ngon. H╞░╞íng vß╗ï ─æß║¡m ─æ├á v├á ─æa dß║íng cß╗ºa nhß╗»ng m├│n ─ân n├áy sß║╜ khiß║┐n bß║Ñt kß╗│ ai c┼⌐ng phß║úi xi├¬u l├▓ng v├á muß╗æn quay lß║íi ─æß╗â th╞░ß╗ƒng thß╗⌐c th├¬m.\n\nVß╗¢i cß║únh sß║»c thi├¬n nhi├¬n t╞░╞íi ─æß║╣p, nhß╗»ng c├┤ng tr├¼nh hiß╗çn ─æß║íi v├á nß╗ün ß║⌐m thß╗▒c phong ph├║, ─É├á Nß║╡ng thß╗▒c sß╗▒ l├á ─æiß╗âm ─æß║┐n ho├án hß║úo cho nhß╗»ng ai muß╗æn t├¼m kiß║┐m sß╗▒ th╞░ gi├ún v├á trß║úi nghiß╗çm v─ân h├│a ─æß╗Öc ─æ├ío cß╗ºa miß╗ün Trung. ─É├óy l├á n╞íi bß║ín c├│ thß╗â h├▓a m├¼nh v├áo thi├¬n nhi├¬n, chi├¬m ng╞░ß╗íng sß╗▒ ph├ít triß╗ân hiß╗çn ─æß║íi cß╗ºa mß╗Öt th├ánh phß╗æ trß║╗, v├á tß║¡n h╞░ß╗ƒng nhß╗»ng khoß║únh khß║»c ─æ├íng nhß╗¢ c├╣ng gia ─æ├¼nh v├á bß║ín b├¿.	4.37	46	danang	15	1	─É├á Nß║╡ng, th├ánh phß╗æ biß╗ân xinh ─æß║╣p miß╗ün Trung, nß╗òi bß║¡t vß╗¢i b├úi biß╗ân Mß╗╣ Kh├¬, cß║ºu Rß╗ông ─æß╗Öc ─æ├ío, B├á N├á Hills h├╣ng v─⌐ v├á nß╗ün ß║⌐m thß╗▒c phong ph├║.
7	─É├á Nß║╡ng n─âng ─æß╗Öng	2024-10-16 12:00:00	asset/img/post/danang2.jpg	─É├á Nß║╡ng nß╗òi bß║¡t vß╗¢i biß╗ân Mß╗╣ Kh├¬, cß║ºu Rß╗ông v├á sß╗▒ ph├ít triß╗ân n─âng ─æß╗Öng cß╗ºa mß╗Öt th├ánh phß╗æ trß║╗.	4.70	1	danang	60	5	─É├á Nß║╡ng n─âng ─æß╗Öng vß╗¢i cß║ºu Rß╗ông, biß╗ân Mß╗╣ Kh├¬, v├á nß╗ün v─ân h├│a ─æa dß║íng.
8	Th╞░ß╗ƒng thß╗⌐c ß║⌐m thß╗▒c S├ái G├▓n	2024-10-11 18:30:00	asset/img/post/saigon.jpg	S├ái G├▓n l├á thi├¬n ─æ╞░ß╗¥ng ß║⌐m thß╗▒c vß╗¢i nhiß╗üu m├│n ngon ─æ╞░ß╗¥ng phß╗æ v├á sß╗▒ pha trß╗Ön v─ân h├│a ─æa dß║íng.	4.80	2	hochiminh	75	6	ß║¿m thß╗▒c S├ái G├▓n v├á trß║úi nghiß╗çm v─ân h├│a ─æ╞░ß╗¥ng phß╗æ.
9	Kß╗│ nghß╗ë ß╗ƒ ─æß║úo Ph├║ Quß╗æc	2024-10-09 16:10:00	asset/img/post/phuquoc.jpg	Ph├║ Quß╗æc nß╗òi tiß║┐ng vß╗¢i biß╗ân xanh, resort sang trß╗ìng v├á kh├┤ng kh├¡ trong l├ánh.	4.90	4	phuquoc	90	2	Ph├║ Quß╗æc vß╗¢i biß╗ân ─æß║╣p v├á c├íc resort cao cß║Ñp.
10	Lß║íc v├áo thi├¬n nhi├¬n Cß║ºn Th╞í	2024-10-13 11:25:00	asset/img/post/cantho.jpg	Cß║ºn Th╞í nß╗òi tiß║┐ng vß╗¢i chß╗ú nß╗òi, n├⌐t v─ân h├│a s├┤ng n╞░ß╗¢c v├á cuß╗Öc sß╗æng b├¼nh dß╗ï cß╗ºa ng╞░ß╗¥i d├ón miß╗ün T├óy.	4.50	2	cantho	50	1	Chß╗ú nß╗òi Cß║ºn Th╞í v├á n├⌐t v─ân h├│a miß╗ün T├óy ─æß╗Öc ─æ├ío.
11	Ngß║»m ho├áng h├┤n V┼⌐ng T├áu	2024-10-17 17:45:00	asset/img/post/vungtau.jpg	V┼⌐ng T├áu c├│ nhß╗»ng b├úi biß╗ân ─æß║╣p v├á phong cß║únh l├úng mß║ín, l├á ─æiß╗âm ─æß║┐n l├╜ t╞░ß╗ƒng cho nhß╗»ng ai y├¬u th├¡ch thi├¬n nhi├¬n.	4.60	1	vungtau	80	3	V┼⌐ng T├áu vß╗¢i biß╗ân xanh, phong cß║únh l├úng mß║ín v├á ho├áng h├┤n ─æß║╣p.
14	Gh├⌐ th─âm rß╗½ng tr├ám Tr├á S╞░ - An Giang	2024-10-08 09:15:00	asset/img/post/trasu.jpg	Rß╗½ng tr├ám Tr├á S╞░ l├á ─æß╗ïa ─æiß╗âm l├╜ t╞░ß╗ƒng cho nhß╗»ng ai y├¬u th├¡ch kh├ím ph├í thi├¬n nhi├¬n miß╗ün T├óy.	4.30	1	angiang	55	6	Rß╗½ng tr├ám Tr├á S╞░ vß╗¢i hß╗ç sinh th├íi ─æa dß║íng v├á kh├┤ng gian xanh m├ít.
15	Mß╗Öc Ch├óu - Miß╗ün ─æß║Ñt hoa cß║úi trß║»ng	2024-10-10 07:30:00	asset/img/post/mocchau.webp	Mß╗Öc Ch├óu mang ─æß║┐n vß║╗ ─æß║╣p cß╗ºa c├íc m├╣a hoa, ─æß║╖c biß╗çt l├á hoa cß║úi trß║»ng nß╗ƒ rß╗Ö v├áo m├╣a ─æ├┤ng.	4.70	1	sonla	60	1	Mß╗Öc Ch├óu vß╗¢i nhß╗»ng m├╣a hoa tuyß╗çt ─æß║╣p, ─æß║╖c biß╗çt l├á hoa cß║úi trß║»ng.
17	Kh├ím ph├í biß╗ân Quy Nh╞ín	2024-10-11 14:40:00	asset/img/post/quynhon.jpg	Quy Nh╞ín c├│ nhß╗»ng b├úi biß╗ân hoang s╞í v├á thi├¬n nhi├¬n tuyß╗çt ─æß║╣p, l├á n╞íi l├╜ t╞░ß╗ƒng cho ng╞░ß╗¥i th├¡ch kh├ím ph├í.	4.50	1	binhdinh	48	3	Quy Nh╞ín vß╗¢i biß╗ân xanh trong v├á b├úi c├ít trß║»ng mß╗ïn.
18	T├¼m hiß╗âu v─ân h├│a ng╞░ß╗¥i Ch─âm	2024-10-14 15:15:00	asset/img/post/cham.jpg	Kh├ím ph├í v─ân h├│a ─æß╗Öc ─æ├ío cß╗ºa ng╞░ß╗¥i Ch─âm tß║íi Ninh Thuß║¡n v├á B├¼nh Thuß║¡n, vß╗¢i c├íc lß╗à hß╗Öi v├á phong tß╗Ñc tß║¡p qu├ín ─æß║╖c sß║»c.	4.60	2	ninhthuan	54	5	V─ân h├│a Ch─âm vß╗¢i c├íc lß╗à hß╗Öi ─æß║╖c sß║»c v├á phong tß╗Ñc tß║¡p qu├ín ─æß╗Öc ─æ├ío.
3	Trß║úi nghiß╗çm v─ân h├│a Hß╗Öi An	2024-10-12 10:30:00	asset/img/post/hoian.jpg	Hß╗Öi An, mß╗Öt th├ánh phß╗æ nhß╗Å xinh ─æß║╣p nß║▒m b├¬n d├▓ng s├┤ng Thu Bß╗ôn, ─æ╞░ß╗úc UNESCO c├┤ng nhß║¡n l├á di sß║ún thß║┐ giß╗¢i, nß╗òi tiß║┐ng vß╗¢i vß║╗ ─æß║╣p cß╗ò k├¡nh cß╗ºa phß╗æ cß╗ò, nhß╗»ng chiß║┐c ─æ├¿n lß╗ông lung linh v├á nß╗ün ß║⌐m thß╗▒c ─æß╗Öc ─æ├ío. ─É├óy l├á ─æiß╗âm ─æß║┐n l├╜ t╞░ß╗ƒng cho nhß╗»ng ai muß╗æn t├¼m hiß╗âu vß╗ü v─ân h├│a v├á lß╗ïch sß╗¡ cß╗ºa Viß╗çt Nam.\n\nPhß╗æ cß╗ò Hß╗Öi An, vß╗¢i nhß╗»ng ng├┤i nh├á gß╗ù cß╗ò k├¡nh ─æ╞░ß╗úc x├óy dß╗▒ng theo phong c├ích kiß║┐n tr├║c truyß╗ün thß╗æng, mang lß║íi cho du kh├ích cß║úm gi├íc nh╞░ lß║íc v├áo mß╗Öt thß║┐ giß╗¢i kh├íc. Mß╗ùi con phß╗æ, mß╗ùi g├│c nhß╗Å ─æß╗üu c├│ nhß╗»ng c├óu chuyß╗çn ri├¬ng, gß╗úi nhß╗¢ vß╗ü qu├í khß╗⌐ huy ho├áng cß╗ºa mß╗Öt th╞░╞íng cß║úng nhß╗Ön nhß╗ïp. ─Éi dß║ío tr├¬n nhß╗»ng con phß╗æ hß║╣p, bß║ín sß║╜ bß║»t gß║╖p nhß╗»ng cß╗¡a h├áng thß╗º c├┤ng mß╗╣ nghß╗ç, qu├ín c├á ph├¬ xinh xß║»n v├á c├íc sß║ún phß║⌐m ─æß╗ïa ph╞░╞íng ─æß║ºy m├áu sß║»c. V├áo buß╗òi tß╗æi, khi ├ính ─æ├¿n lß╗ông rß╗▒c rß╗í ─æ╞░ß╗úc thß║»p s├íng, phß╗æ cß╗ò trß╗ƒ n├¬n lung linh v├á huyß╗ün ß║úo, khiß║┐n l├▓ng ng╞░ß╗¥i xao xuyß║┐n.\n\nHß╗Öi An kh├┤ng chß╗ë thu h├║t du kh├ích bß╗ƒi vß║╗ ─æß║╣p cß╗ºa kiß║┐n tr├║c m├á c├▓n bß╗ƒi nß╗ün ß║⌐m thß╗▒c phong ph├║ v├á ─æa dß║íng. Nhß╗»ng m├│n ─ân ─æß║╖c sß║ún nh╞░ cao lß║ºu, m├¼ quß║úng, b├ính m├¼ Hß╗Öi An hay c├íc m├│n hß║úi sß║ún t╞░╞íi ngon ─æß╗üu mang ─æß║¡m h╞░╞íng vß╗ï v├á bß║ún sß║»c v─ân h├│a cß╗ºa ─æß╗ïa ph╞░╞íng. Mß╗ùi m├│n ─ân kh├┤ng chß╗ë l├á mß╗Öt bß╗»a tiß╗çc cho vß╗ï gi├íc m├á c├▓n l├á mß╗Öt h├ánh tr├¼nh kh├ím ph├í nhß╗»ng n├⌐t v─ân h├│a ß║⌐m thß╗▒c phong ph├║ cß╗ºa ng╞░ß╗¥i d├ón n╞íi ─æ├óy.\n\nHß╗Öi An c├▓n nß╗òi bß║¡t vß╗¢i sß╗▒ ß║Ñm ├íp v├á th├ón thiß╗çn cß╗ºa ng╞░ß╗¥i d├ón. Du kh├ích c├│ thß╗â cß║úm nhß║¡n ─æ╞░ß╗úc sß╗▒ ch├áo ─æ├│n nß╗ông nhiß╗çt v├á l├▓ng hiß║┐u kh├ích cß╗ºa ng╞░ß╗¥i d├ón n╞íi ─æ├óy. Hß╗ì sß║╡n s├áng chia sß║╗ vß╗ü v─ân h├│a, phong tß╗Ñc tß║¡p qu├ín v├á nhß╗»ng c├óu chuyß╗çn th├║ vß╗ï vß╗ü th├ánh phß╗æ m├á hß╗ì y├¬u th╞░╞íng. ─Éiß╗üu n├áy kh├┤ng chß╗ë gi├║p du kh├ích cß║úm thß║Ñy gß║ºn g┼⌐i h╞ín m├á c├▓n tß║ío ra nhß╗»ng kß╗╖ niß╗çm ─æ├íng nhß╗¢ trong h├ánh tr├¼nh kh├ím ph├í Hß╗Öi An.\n\nT├│m lß║íi, Hß╗Öi An l├á mß╗Öt di sß║ún v─ân h├│a thß║┐ giß╗¢i vß╗¢i vß║╗ ─æß║╣p quyß║┐n r┼⌐, nß╗ün ß║⌐m thß╗▒c ─æß╗Öc ─æ├ío v├á sß╗▒ ß║Ñm ├íp cß╗ºa con ng╞░ß╗¥i. ─Éß║┐n vß╗¢i Hß╗Öi An, du kh├ích kh├┤ng chß╗ë ─æ╞░ß╗úc chi├¬m ng╞░ß╗íng nhß╗»ng cß║únh sß║»c tuyß╗çt ─æß║╣p m├á c├▓n ─æ╞░ß╗úc h├▓a m├¼nh v├áo cuß╗Öc sß╗æng ─æß║ºy m├áu sß║»c cß╗ºa mß╗Öt th├ánh phß╗æ mang ─æß║¡m bß║ún sß║»c v─ân h├│a Viß╗çt Nam.	4.80	1	quangnam	56	1	Phß╗æ cß╗ò Hß╗Öi An, ─æ├¿n lß╗ông rß╗▒c rß╗í, v├á nß╗ün v─ân h├│a ─æß╗Öc ─æ├ío.
16	Chß╗ú ─æ├¬m ─Éß╗ông Xu├ón - H├á Nß╗Öi	2024-10-20 19:00:00	asset/img/post/dongxuan.jpg	Chß╗ú ─æ├¬m ─Éß╗ông Xu├ón, mß╗Öt trong nhß╗»ng ─æiß╗âm ─æß║┐n kh├┤ng thß╗â bß╗Å qua khi ─æß║┐n H├á Nß╗Öi, l├á n╞íi l├╜ t╞░ß╗ƒng ─æß╗â du kh├ích vß╗½a mua sß║»m vß╗½a kh├ím ph├í v─ân h├│a ─æß║╖c sß║»c cß╗ºa thß╗º ─æ├┤ v├áo ban ─æ├¬m. Khi ├ính ─æ├¿n bß║»t ─æß║ºu s├íng l├¬n, chß╗ú ─æ├¬m trß╗ƒ n├¬n sß╗æng ─æß╗Öng vß╗¢i kh├┤ng kh├¡ nhß╗Ön nhß╗ïp, thu h├║t ─æ├┤ng ─æß║úo ng╞░ß╗¥i d├ón ─æß╗ïa ph╞░╞íng v├á du kh├ích.\n\nTß╗ìa lß║íc tß║íi quß║¡n Ho├án Kiß║┐m, chß╗ú ─æ├¬m ─Éß╗ông Xu├ón kh├┤ng chß╗ë nß╗òi tiß║┐ng vß╗¢i ─æa dß║íng mß║╖t h├áng tß╗½ quß║ºn ├ío, gi├áy d├⌐p, ─æß╗ô l╞░u niß╗çm ─æß║┐n c├íc sß║ún phß║⌐m thß╗º c├┤ng mß╗╣ nghß╗ç m├á c├▓n l├á n╞íi l├╜ t╞░ß╗ƒng ─æß╗â th╞░ß╗ƒng thß╗⌐c c├íc m├│n ─ân ─æ╞░ß╗¥ng phß╗æ ─æß║╖c sß║»c cß╗ºa H├á Nß╗Öi. Du kh├ích c├│ thß╗â dß╗à d├áng t├¼m thß║Ñy nhß╗»ng gian h├áng b├áy b├ín b├ính m├¼, phß╗ƒ, nem r├ín, ch├¿ v├á nhiß╗üu m├│n ngon kh├íc, tß║ío n├¬n mß╗Öt bß╗»a tiß╗çc ß║⌐m thß╗▒c phong ph├║.\n\nKh├┤ng kh├¡ tß║íi chß╗ú ─æ├¬m lu├┤n tß║Ñp nß║¡p v├á vui t╞░╞íi, vß╗¢i tiß║┐ng c╞░ß╗¥i n├│i, tiß║┐ng ch├áo h├áng cß╗ºa ng╞░ß╗¥i b├ín v├á ├óm thanh nhß╗Ön nhß╗ïp cß╗ºa nhß╗»ng b╞░ß╗¢c ch├ón du kh├ích. Nhß╗»ng chiß║┐c ─æ├¿n lß╗ông rß╗▒c rß╗í ─æ╞░ß╗úc treo khß║»p n╞íi, h├▓a quyß╗çn vß╗¢i h╞░╞íng th╞ím cß╗ºa c├íc m├│n ─ân, tß║ío n├¬n mß╗Öt bß╗⌐c tranh sß╗æng ─æß╗Öng v├á quyß║┐n r┼⌐. ─Éß║╖c biß╗çt, v├áo nhß╗»ng ng├áy lß╗à hß╗Öi, chß╗ú ─æ├¬m c├áng trß╗ƒ n├¬n s├┤i ─æß╗Öng vß╗¢i c├íc hoß║ít ─æß╗Öng v─ân h├│a nghß╗ç thuß║¡t ─æß║╖c sß║»c, mang ─æß║¡m bß║ún sß║»c v─ân h├│a H├á Nß╗Öi.\n\n─Éi dß║ío trong chß╗ú ─æ├¬m, du kh├ích kh├┤ng chß╗ë ─æ╞░ß╗úc thß╗Åa sß╗⌐c mua sß║»m m├á c├▓n c├│ c╞í hß╗Öi giao l╞░u, tr├▓ chuyß╗çn vß╗¢i ng╞░ß╗¥i d├ón ─æß╗ïa ph╞░╞íng. Hß╗ì sß║╡n s├áng chia sß║╗ nhß╗»ng c├óu chuyß╗çn th├║ vß╗ï vß╗ü v─ân h├│a, phong tß╗Ñc tß║¡p qu├ín v├á cuß╗Öc sß╗æng th╞░ß╗¥ng nhß║¡t cß╗ºa ng╞░ß╗¥i H├á Nß╗Öi. ─Éiß╗üu n├áy kh├┤ng chß╗ë gi├║p du kh├ích hiß╗âu th├¬m vß╗ü cuß╗Öc sß╗æng n╞íi ─æ├óy m├á c├▓n tß║ío ra nhß╗»ng kß╗╖ niß╗çm ─æ├íng nhß╗¢ trong h├ánh tr├¼nh kh├ím ph├í.\n\nT├│m lß║íi, chß╗ú ─æ├¬m ─Éß╗ông Xu├ón l├á mß╗Öt ─æiß╗âm ─æß║┐n kh├┤ng thß╗â thiß║┐u trong h├ánh tr├¼nh kh├ím ph├í H├á Nß╗Öi. Vß╗¢i kh├┤ng kh├¡ n├ío nhiß╗çt, ─æa dß║íng mß║╖t h├áng v├á nß╗ün ß║⌐m thß╗▒c phong ph├║, n╞íi ─æ├óy chß║»c chß║»n sß║╜ mang ─æß║┐n cho du kh├ích nhß╗»ng trß║úi nghiß╗çm th├║ vß╗ï v├á nhß╗»ng k├╜ ß╗⌐c kh├│ qu├¬n vß╗ü th├ánh phß╗æ ngh├¼n n─âm v─ân hiß║┐n.\n\n	4.20	2	hanoi	52	2	Chß╗ú ─æ├¬m ─Éß╗ông Xu├ón vß╗¢i kh├┤ng kh├¡ s├┤i ─æß╗Öng v├á sß║ún phß║⌐m ─æa dß║íng.
13	Th╞░ß╗ƒng ngoß║ín cß║únh ─æß║╣p Sapa	2024-10-19 07:00:00	asset/img/post/sapa.jpg	Sapa, v├╣ng ─æß║Ñt nß║▒m tr├¬n ─æß╗Ö cao 1.600 m├⌐t so vß╗¢i mß╗▒c n╞░ß╗¢c biß╗ân, nß╗òi tiß║┐ng vß╗¢i cß║únh sß║»c h├╣ng v─⌐ cß╗ºa n├║i ─æß╗ôi v├á nhß╗»ng thß╗¡a ruß╗Öng bß║¡c thang tuyß╗çt ─æß║╣p, l├á ─æiß╗âm ─æß║┐n l├╜ t╞░ß╗ƒng cho nhß╗»ng ai y├¬u th├¡ch thi├¬n nhi├¬n v├á muß╗æn kh├ím ph├í vß║╗ ─æß║╣p hoang s╞í cß╗ºa n├║i rß╗½ng ph├¡a Bß║»c Viß╗çt Nam.\n\nKhi ─æß║╖t ch├ón ─æß║┐n Sapa, du kh├ích sß║╜ ngay lß║¡p tß╗⌐c bß╗ï cuß╗æn h├║t bß╗ƒi khung cß║únh n├║i non tr├╣ng ─æiß╗çp, vß╗¢i nhß╗»ng ─æß╗ënh n├║i cao vß╗¥i vß╗úi, nhß╗»ng thung l┼⌐ng s├óu v├á nhß╗»ng d├▓ng suß╗æi trong xanh. ─Éß║╖c biß╗çt, Fansipan - "N├│c nh├á ─É├┤ng D╞░╞íng" - l├á ─æ├¡ch ─æß║┐n kh├┤ng thß╗â bß╗Å qua cho nhß╗»ng ai y├¬u th├¡ch mß║ío hiß╗âm v├á muß╗æn chinh phß╗Ñc ─æß╗ënh n├║i cao nhß║Ñt Viß╗çt Nam. H├ánh tr├¼nh leo n├║i ─æß║┐n Fansipan kh├┤ng chß╗ë mang lß║íi cß║úm gi├íc hß╗ôi hß╗Öp, m├á c├▓n cho ph├⌐p bß║ín chi├¬m ng╞░ß╗íng vß║╗ ─æß║╣p kß╗│ diß╗çu cß╗ºa thi├¬n nhi├¬n n╞íi ─æ├óy.\n\nMß╗Öt trong nhß╗»ng ─æiß╗âm nß╗òi bß║¡t nhß║Ñt cß╗ºa Sapa ch├¡nh l├á nhß╗»ng thß╗¡a ruß╗Öng bß║¡c thang trß║úi d├ái nh╞░ nhß╗»ng bß╗⌐c tranh tuyß╗çt mß╗╣. Nhß╗»ng thß╗¡a ruß╗Öng n├áy kh├┤ng chß╗ë mang lß║íi vß║╗ ─æß║╣p hß╗»u t├¼nh m├á c├▓n l├á minh chß╗⌐ng cho sß╗▒ kh├⌐o l├⌐o v├á cß║ºn c├╣ cß╗ºa ng╞░ß╗¥i d├ón tß╗Öc thiß╗âu sß╗æ n╞íi ─æ├óy. Mß╗ùi m├╣a, ruß╗Öng bß║¡c thang lß║íi kho├íc l├¬n m├¼nh mß╗Öt m├áu sß║»c kh├íc nhau: m├╣a n╞░ß╗¢c ─æß╗ò, nhß╗»ng thß╗¡a ruß╗Öng lß║Ñp l├ính ├ính mß║╖t trß╗¥i; m├╣a gß║╖t, nhß╗»ng b├┤ng l├║a ch├¡n v├áng rß╗▒c rß╗í. Tß║Ñt cß║ú tß║ío n├¬n mß╗Öt bß╗⌐c tranh sß╗æng ─æß╗Öng v├á quyß║┐n r┼⌐.\n\nKh├┤ng chß╗ë c├│ cß║únh sß║»c thi├¬n nhi├¬n h├╣ng v─⌐, Sapa c├▓n l├á n╞íi l╞░u giß╗» nhiß╗üu gi├í trß╗ï v─ân h├│a ─æß║╖c sß║»c cß╗ºa c├íc d├ón tß╗Öc thiß╗âu sß╗æ nh╞░ H'M├┤ng, Dao, T├áy... Du kh├ích c├│ thß╗â gh├⌐ th─âm c├íc bß║ún l├áng, t├¼m hiß╗âu vß╗ü phong tß╗Ñc tß║¡p qu├ín, c├ích sß╗æng cß╗ºa ng╞░ß╗¥i d├ón n╞íi ─æ├óy. Nhß╗»ng phi├¬n chß╗ú ─æß║ºy sß║»c m├áu, n╞íi b├áy b├ín sß║ún phß║⌐m thß╗º c├┤ng mß╗╣ nghß╗ç, sß║╜ mang ─æß║┐n cho bß║ín nhß╗»ng trß║úi nghiß╗çm ─æß╗Öc ─æ├ío v├á th├║ vß╗ï.\n\nß║¿m thß╗▒c Sapa c┼⌐ng l├á mß╗Öt phß║ºn kh├┤ng thß╗â thiß║┐u trong h├ánh tr├¼nh kh├ím ph├í. Nhß╗»ng m├│n ─ân ─æß║╖c sß║ún nh╞░ c├í hß╗ôi, lß╗ún bß║ún, hay nhß╗»ng m├│n ─ân ─æ╞░ß╗úc chß║┐ biß║┐n tß╗½ rau cß╗º t╞░╞íi ngon cß╗ºa v├╣ng ─æß║Ñt n├áy sß║╜ khiß║┐n bß║ín kh├│ qu├¬n. H╞░╞íng vß╗ï ─æß║¡m ─æ├á v├á t╞░╞íi ngon cß╗ºa nhß╗»ng m├│n ─ân n├áy kh├┤ng chß╗ë mang ─æß║┐n sß╗▒ thß╗Åa m├ún cho vß╗ï gi├íc m├á c├▓n l├á mß╗Öt phß║ºn cß╗ºa v─ân h├│a ─æß╗ïa ph╞░╞íng.\n\nT├│m lß║íi, Sapa l├á mß╗Öt ─æiß╗âm ─æß║┐n tuyß╗çt vß╗¥i cho nhß╗»ng ai y├¬u th├¡ch n├║i ─æß╗ôi v├á muß╗æn h├▓a m├¼nh v├áo thi├¬n nhi├¬n. Vß╗¢i cß║únh sß║»c h├╣ng v─⌐, nhß╗»ng thß╗¡a ruß╗Öng bß║¡c thang tuyß╗çt ─æß║╣p v├á nß╗ün v─ân h├│a phong ph├║, Sapa chß║»c chß║»n sß║╜ ─æß╗â lß║íi trong l├▓ng du kh├ích nhß╗»ng ß║Ñn t╞░ß╗úng s├óu sß║»c v├á nhß╗»ng kß╗╖ niß╗çm kh├│ qu├¬n.	4.90	1	laocai	85	5	Sapa v├á nhß╗»ng ruß╗Öng bß║¡c thang ─æß║╣p m├¬ hß╗ôn giß╗»a n├║i ─æß╗ôi.
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, username, password, email, fullname, address, isadmin, avatar, banned_until, point) FROM stdin;
2	vuad951236	$2y$10$m1Dxc0rQbJdakzKB2BArUegWilFq7yFdcArYROXL/vDeHhkp4DxOq	hoangvuvo877@gmail.com	V├╡ Ho├áng V┼⌐	440 Thß╗æng Nhß║Ñt	t	\N	\N	0
4	vu951237	$2y$10$eJAvVytP8xr1Adu8sgQQOe.lrXpFmRrxDc9VhxjyoUWmWsXLlSR6O	2251120133@ut.edu.vn	V├╡ Ho├áng V┼⌐	440 Thß╗æng Nhß║Ñt	f	\N	\N	0
5	linh951236	$2y$10$Nb63IuCqOuZpkqlooV9KreIMHZ1sHCsOuIwuzScD071KuVQE/8.86	truclinh300678@gmail.com	Tr├║c Linh	440 Thß╗æng Nhß║Ñt	f	\N	\N	0
1	vu951236	$2y$10$wDuIK3liBjIFG7QeIaU93eyhNeyaDI20K2HkmngOoeCPuBaQHFBvC	hoangvuvo907@gmail.com	V├╡ Ho├áng V┼⌐	440 Thß╗æng Nhß║Ñt	f	asset/img/user/vu.png	\N	6.37
3	thinh12345	$2y$10$fsau3/2PpC4Ir5WF.04Yzea6vcav/3eIgtKbc3KxQdJQ13S1XJPQy	nguyenminhthinh26122004@gmail.com	Nguyß╗àn Minh Thß╗ïnh	Quy Nh╞ín	f	\N	\N	0
6	nhuan12345	$2y$10$jYeRWMuLLX3ouJPkWH9OAue.1p.a6sO1YXuVkmAeXangL8Jgbp9cu	clohuynh@gmail.com	Huß╗│nh Hß╗ông Nhuß║¡n	Tuy Ph╞░ß╗¢c	f	\N	\N	0
\.


--
-- Name: comment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.comment_id_seq', 3, true);


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

SELECT pg_catalog.setval('public.postdetail_id_seq', 37, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 7, true);


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

