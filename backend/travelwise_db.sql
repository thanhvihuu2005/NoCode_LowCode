--
-- PostgreSQL database dump
--

\restrict cDmLVsjala0bRJSXgskzIhrFzN1fgCmP32pBnDxte5JhIcnBmKBOAGCccJZc4dz

-- Dumped from database version 18.3
-- Dumped by pg_dump version 18.3

-- Started on 2026-04-04 00:51:45

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
-- TOC entry 894 (class 1247 OID 16414)
-- Name: availability_t; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.availability_t AS ENUM (
    'available',
    'selling-fast',
    'sold-out'
);


ALTER TYPE public.availability_t OWNER TO postgres;

--
-- TOC entry 897 (class 1247 OID 16422)
-- Name: booking_status; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.booking_status AS ENUM (
    'Pending',
    'Confirmed',
    'Completed',
    'Cancelled'
);


ALTER TYPE public.booking_status OWNER TO postgres;

--
-- TOC entry 888 (class 1247 OID 16402)
-- Name: dest_status; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.dest_status AS ENUM (
    'active',
    'inactive'
);


ALTER TYPE public.dest_status OWNER TO postgres;

--
-- TOC entry 891 (class 1247 OID 16408)
-- Name: item_status; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.item_status AS ENUM (
    'active',
    'inactive'
);


ALTER TYPE public.item_status OWNER TO postgres;

--
-- TOC entry 912 (class 1247 OID 16458)
-- Name: log_status; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.log_status AS ENUM (
    'success',
    'failure'
);


ALTER TYPE public.log_status OWNER TO postgres;

--
-- TOC entry 915 (class 1247 OID 16464)
-- Name: notif_type; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.notif_type AS ENUM (
    'booking',
    'promo',
    'system'
);


ALTER TYPE public.notif_type OWNER TO postgres;

--
-- TOC entry 906 (class 1247 OID 16444)
-- Name: promo_status; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.promo_status AS ENUM (
    'active',
    'expired',
    'disabled'
);


ALTER TYPE public.promo_status OWNER TO postgres;

--
-- TOC entry 903 (class 1247 OID 16438)
-- Name: review_status; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.review_status AS ENUM (
    'published',
    'hidden'
);


ALTER TYPE public.review_status OWNER TO postgres;

--
-- TOC entry 909 (class 1247 OID 16452)
-- Name: rule_type; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.rule_type AS ENUM (
    'cross-sell',
    'upsell'
);


ALTER TYPE public.rule_type OWNER TO postgres;

--
-- TOC entry 900 (class 1247 OID 16432)
-- Name: service_type; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.service_type AS ENUM (
    'tour',
    'hotel'
);


ALTER TYPE public.service_type OWNER TO postgres;

--
-- TOC entry 882 (class 1247 OID 16390)
-- Name: user_role; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.user_role AS ENUM (
    'client',
    'admin'
);


ALTER TYPE public.user_role OWNER TO postgres;

--
-- TOC entry 885 (class 1247 OID 16396)
-- Name: user_status; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.user_status AS ENUM (
    'active',
    'blocked'
);


ALTER TYPE public.user_status OWNER TO postgres;

--
-- TOC entry 249 (class 1255 OID 16471)
-- Name: set_updated_at(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.set_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.set_updated_at() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 230 (class 1259 OID 16588)
-- Name: addons; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.addons (
    id integer NOT NULL,
    code character varying(20),
    name character varying(200) NOT NULL,
    description text,
    price numeric(10,2) DEFAULT 0 NOT NULL,
    status public.item_status DEFAULT 'active'::public.item_status
);


ALTER TABLE public.addons OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 16587)
-- Name: addons_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.addons_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.addons_id_seq OWNER TO postgres;

--
-- TOC entry 5283 (class 0 OID 0)
-- Dependencies: 229
-- Name: addons_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.addons_id_seq OWNED BY public.addons.id;


--
-- TOC entry 242 (class 1259 OID 16705)
-- Name: automation_logs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.automation_logs (
    id integer NOT NULL,
    code character varying(20),
    event character varying(500) NOT NULL,
    status public.log_status DEFAULT 'success'::public.log_status,
    payload jsonb,
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.automation_logs OWNER TO postgres;

--
-- TOC entry 241 (class 1259 OID 16704)
-- Name: automation_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.automation_logs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.automation_logs_id_seq OWNER TO postgres;

--
-- TOC entry 5284 (class 0 OID 0)
-- Dependencies: 241
-- Name: automation_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.automation_logs_id_seq OWNED BY public.automation_logs.id;


--
-- TOC entry 232 (class 1259 OID 16604)
-- Name: booking_addons; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.booking_addons (
    id integer NOT NULL,
    booking_id integer NOT NULL,
    addon_id integer NOT NULL,
    quantity integer DEFAULT 1,
    price numeric(10,2)
);


ALTER TABLE public.booking_addons OWNER TO postgres;

--
-- TOC entry 231 (class 1259 OID 16603)
-- Name: booking_addons_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.booking_addons_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.booking_addons_id_seq OWNER TO postgres;

--
-- TOC entry 5285 (class 0 OID 0)
-- Dependencies: 231
-- Name: booking_addons_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.booking_addons_id_seq OWNED BY public.booking_addons.id;


--
-- TOC entry 228 (class 1259 OID 16561)
-- Name: bookings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.bookings (
    id integer NOT NULL,
    code character varying(20),
    user_id integer NOT NULL,
    service_type public.service_type NOT NULL,
    service_id integer NOT NULL,
    service_name character varying(200),
    check_in_date date,
    check_out_date date,
    guests integer DEFAULT 1,
    total_price numeric(10,2) DEFAULT 0 NOT NULL,
    discount_code character varying(50),
    status public.booking_status DEFAULT 'Pending'::public.booking_status,
    note text,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.bookings OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 16560)
-- Name: bookings_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.bookings_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.bookings_id_seq OWNER TO postgres;

--
-- TOC entry 5286 (class 0 OID 0)
-- Dependencies: 227
-- Name: bookings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.bookings_id_seq OWNED BY public.bookings.id;


--
-- TOC entry 247 (class 1259 OID 16760)
-- Name: cache; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cache (
    key character varying(255) NOT NULL,
    value text NOT NULL,
    expiration integer NOT NULL
);


ALTER TABLE public.cache OWNER TO postgres;

--
-- TOC entry 248 (class 1259 OID 16770)
-- Name: cache_locks; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cache_locks (
    key character varying(255) NOT NULL,
    owner character varying(255) NOT NULL,
    expiration integer NOT NULL
);


ALTER TABLE public.cache_locks OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 16495)
-- Name: destinations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.destinations (
    id integer NOT NULL,
    code character varying(20),
    name character varying(100) NOT NULL,
    keyword character varying(100),
    image_url character varying(500),
    description text,
    status public.dest_status DEFAULT 'active'::public.dest_status,
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.destinations OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 16494)
-- Name: destinations_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.destinations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.destinations_id_seq OWNER TO postgres;

--
-- TOC entry 5287 (class 0 OID 0)
-- Dependencies: 221
-- Name: destinations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.destinations_id_seq OWNED BY public.destinations.id;


--
-- TOC entry 226 (class 1259 OID 16535)
-- Name: hotels; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.hotels (
    id integer NOT NULL,
    name character varying(200) NOT NULL,
    image_url character varying(500),
    image_alt character varying(200),
    destination_id integer,
    location character varying(100),
    full_location character varying(200),
    feature character varying(100),
    description text,
    price_per_night numeric(10,2) DEFAULT 0 NOT NULL,
    discount integer DEFAULT 0,
    badge character varying(50),
    availability public.availability_t DEFAULT 'available'::public.availability_t,
    rating numeric(3,1) DEFAULT 0,
    review_count integer DEFAULT 0,
    status public.item_status DEFAULT 'active'::public.item_status,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.hotels OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 16534)
-- Name: hotels_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.hotels_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.hotels_id_seq OWNER TO postgres;

--
-- TOC entry 5288 (class 0 OID 0)
-- Dependencies: 225
-- Name: hotels_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.hotels_id_seq OWNED BY public.hotels.id;


--
-- TOC entry 246 (class 1259 OID 16748)
-- Name: migrations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.migrations (
    id integer NOT NULL,
    migration character varying(255) NOT NULL,
    batch integer NOT NULL
);


ALTER TABLE public.migrations OWNER TO postgres;

--
-- TOC entry 245 (class 1259 OID 16747)
-- Name: migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.migrations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.migrations_id_seq OWNER TO postgres;

--
-- TOC entry 5289 (class 0 OID 0)
-- Dependencies: 245
-- Name: migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.migrations_id_seq OWNED BY public.migrations.id;


--
-- TOC entry 244 (class 1259 OID 16720)
-- Name: notifications; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.notifications (
    id integer NOT NULL,
    user_id integer NOT NULL,
    title character varying(200),
    message text,
    type public.notif_type DEFAULT 'system'::public.notif_type,
    is_read boolean DEFAULT false,
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.notifications OWNER TO postgres;

--
-- TOC entry 243 (class 1259 OID 16719)
-- Name: notifications_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.notifications_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.notifications_id_seq OWNER TO postgres;

--
-- TOC entry 5290 (class 0 OID 0)
-- Dependencies: 243
-- Name: notifications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.notifications_id_seq OWNED BY public.notifications.id;


--
-- TOC entry 238 (class 1259 OID 16668)
-- Name: promo_codes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.promo_codes (
    id integer NOT NULL,
    code character varying(20),
    promo_code character varying(50) NOT NULL,
    type character varying(50),
    value_num numeric(10,2) DEFAULT 0 NOT NULL,
    is_percent boolean DEFAULT true,
    use_limit integer DEFAULT 0,
    used_count integer DEFAULT 0,
    expiry_date date,
    status public.promo_status DEFAULT 'active'::public.promo_status,
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.promo_codes OWNER TO postgres;

--
-- TOC entry 237 (class 1259 OID 16667)
-- Name: promo_codes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.promo_codes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.promo_codes_id_seq OWNER TO postgres;

--
-- TOC entry 5291 (class 0 OID 0)
-- Dependencies: 237
-- Name: promo_codes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.promo_codes_id_seq OWNED BY public.promo_codes.id;


--
-- TOC entry 240 (class 1259 OID 16688)
-- Name: recommendation_rules; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.recommendation_rules (
    id integer NOT NULL,
    code character varying(20),
    trigger_kw character varying(200) NOT NULL,
    suggestion character varying(500) NOT NULL,
    type public.rule_type DEFAULT 'cross-sell'::public.rule_type,
    is_active boolean DEFAULT true,
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.recommendation_rules OWNER TO postgres;

--
-- TOC entry 239 (class 1259 OID 16687)
-- Name: recommendation_rules_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.recommendation_rules_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.recommendation_rules_id_seq OWNER TO postgres;

--
-- TOC entry 5292 (class 0 OID 0)
-- Dependencies: 239
-- Name: recommendation_rules_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.recommendation_rules_id_seq OWNED BY public.recommendation_rules.id;


--
-- TOC entry 234 (class 1259 OID 16625)
-- Name: reviews; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.reviews (
    id integer NOT NULL,
    code character varying(20),
    user_id integer NOT NULL,
    service_type public.service_type NOT NULL,
    service_id integer NOT NULL,
    service_name character varying(200),
    rating smallint NOT NULL,
    comment text,
    status public.review_status DEFAULT 'published'::public.review_status,
    created_at timestamp without time zone DEFAULT now(),
    CONSTRAINT reviews_rating_check CHECK (((rating >= 1) AND (rating <= 5)))
);


ALTER TABLE public.reviews OWNER TO postgres;

--
-- TOC entry 233 (class 1259 OID 16624)
-- Name: reviews_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.reviews_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.reviews_id_seq OWNER TO postgres;

--
-- TOC entry 5293 (class 0 OID 0)
-- Dependencies: 233
-- Name: reviews_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.reviews_id_seq OWNED BY public.reviews.id;


--
-- TOC entry 224 (class 1259 OID 16510)
-- Name: tours; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tours (
    id integer NOT NULL,
    title character varying(200) NOT NULL,
    image_url character varying(500),
    image_alt character varying(200),
    destination_id integer,
    location character varying(100),
    full_location character varying(200),
    duration character varying(50),
    includes character varying(500),
    description text,
    price_per_person numeric(10,2) DEFAULT 0 NOT NULL,
    discount integer DEFAULT 0,
    badge character varying(50),
    rating numeric(3,1) DEFAULT 0,
    review_count integer DEFAULT 0,
    status public.item_status DEFAULT 'active'::public.item_status,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.tours OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 16509)
-- Name: tours_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tours_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tours_id_seq OWNER TO postgres;

--
-- TOC entry 5294 (class 0 OID 0)
-- Dependencies: 223
-- Name: tours_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tours_id_seq OWNED BY public.tours.id;


--
-- TOC entry 220 (class 1259 OID 16473)
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id integer NOT NULL,
    code character varying(20),
    name character varying(100) NOT NULL,
    email character varying(150) NOT NULL,
    password character varying(255) NOT NULL,
    phone character varying(20),
    avatar_url character varying(500),
    role public.user_role DEFAULT 'client'::public.user_role,
    status public.user_status DEFAULT 'active'::public.user_status,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.users OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 16472)
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
-- TOC entry 5295 (class 0 OID 0)
-- Dependencies: 219
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- TOC entry 236 (class 1259 OID 16649)
-- Name: wishlists; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.wishlists (
    id integer NOT NULL,
    user_id integer NOT NULL,
    service_type public.service_type NOT NULL,
    service_id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.wishlists OWNER TO postgres;

--
-- TOC entry 235 (class 1259 OID 16648)
-- Name: wishlists_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.wishlists_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.wishlists_id_seq OWNER TO postgres;

--
-- TOC entry 5296 (class 0 OID 0)
-- Dependencies: 235
-- Name: wishlists_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.wishlists_id_seq OWNED BY public.wishlists.id;


--
-- TOC entry 4997 (class 2604 OID 16591)
-- Name: addons id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.addons ALTER COLUMN id SET DEFAULT nextval('public.addons_id_seq'::regclass);


--
-- TOC entry 5018 (class 2604 OID 16708)
-- Name: automation_logs id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.automation_logs ALTER COLUMN id SET DEFAULT nextval('public.automation_logs_id_seq'::regclass);


--
-- TOC entry 5000 (class 2604 OID 16607)
-- Name: booking_addons id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.booking_addons ALTER COLUMN id SET DEFAULT nextval('public.booking_addons_id_seq'::regclass);


--
-- TOC entry 4991 (class 2604 OID 16564)
-- Name: bookings id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bookings ALTER COLUMN id SET DEFAULT nextval('public.bookings_id_seq'::regclass);


--
-- TOC entry 4971 (class 2604 OID 16498)
-- Name: destinations id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.destinations ALTER COLUMN id SET DEFAULT nextval('public.destinations_id_seq'::regclass);


--
-- TOC entry 4982 (class 2604 OID 16538)
-- Name: hotels id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hotels ALTER COLUMN id SET DEFAULT nextval('public.hotels_id_seq'::regclass);


--
-- TOC entry 5025 (class 2604 OID 16751)
-- Name: migrations id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.migrations ALTER COLUMN id SET DEFAULT nextval('public.migrations_id_seq'::regclass);


--
-- TOC entry 5021 (class 2604 OID 16723)
-- Name: notifications id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notifications ALTER COLUMN id SET DEFAULT nextval('public.notifications_id_seq'::regclass);


--
-- TOC entry 5007 (class 2604 OID 16671)
-- Name: promo_codes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promo_codes ALTER COLUMN id SET DEFAULT nextval('public.promo_codes_id_seq'::regclass);


--
-- TOC entry 5014 (class 2604 OID 16691)
-- Name: recommendation_rules id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recommendation_rules ALTER COLUMN id SET DEFAULT nextval('public.recommendation_rules_id_seq'::regclass);


--
-- TOC entry 5002 (class 2604 OID 16628)
-- Name: reviews id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reviews ALTER COLUMN id SET DEFAULT nextval('public.reviews_id_seq'::regclass);


--
-- TOC entry 4974 (class 2604 OID 16513)
-- Name: tours id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tours ALTER COLUMN id SET DEFAULT nextval('public.tours_id_seq'::regclass);


--
-- TOC entry 4966 (class 2604 OID 16476)
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- TOC entry 5005 (class 2604 OID 16652)
-- Name: wishlists id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.wishlists ALTER COLUMN id SET DEFAULT nextval('public.wishlists_id_seq'::regclass);


--
-- TOC entry 5259 (class 0 OID 16588)
-- Dependencies: 230
-- Data for Name: addons; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.addons (id, code, name, description, price, status) FROM stdin;
1	ADD-01	Bảo hiểm du lịch toàn diện	Bảo vệ bạn trước mọi rủi ro về sức khỏe và hành lý.	15.00	active
2	ADD-02	Xe đưa đón sân bay	Đón tận nơi, đúng giờ bằng xe đời mới.	25.00	active
3	ADD-03	SIM du lịch 4G tốc độ cao	Luôn kết nối mọi lúc mọi nơi.	10.00	active
\.


--
-- TOC entry 5271 (class 0 OID 16705)
-- Dependencies: 242
-- Data for Name: automation_logs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.automation_logs (id, code, event, status, payload, created_at) FROM stdin;
1	LOG-001	Email xác nhận BK-1002	success	\N	2026-03-28 11:31:47.214236
2	LOG-002	Gợi ý tour mới USR-004	success	\N	2026-03-28 11:31:47.214236
3	LOG-003	Lỗi gửi email USR-003	failure	\N	2026-03-28 11:31:47.214236
4	\N	Kích hoạt qua retention-tour	success	"{\\"path\\":\\"retention-tour\\"}"	2026-04-03 15:26:43
\.


--
-- TOC entry 5261 (class 0 OID 16604)
-- Dependencies: 232
-- Data for Name: booking_addons; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.booking_addons (id, booking_id, addon_id, quantity, price) FROM stdin;
\.


--
-- TOC entry 5257 (class 0 OID 16561)
-- Dependencies: 228
-- Data for Name: bookings; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.bookings (id, code, user_id, service_type, service_id, service_name, check_in_date, check_out_date, guests, total_price, discount_code, status, note, created_at, updated_at) FROM stdin;
1	BK-1001	1	tour	1	Khám phá bờ biển Amalfi	2024-03-20	\N	1	1899.00	\N	Pending	\N	2026-03-28 11:31:47.214236	2026-03-28 11:31:47.214236
2	BK-1002	2	tour	4	Sapa Misty Mountains	2024-03-22	\N	1	150.00	\N	Confirmed	\N	2026-03-28 11:31:47.214236	2026-03-28 11:31:47.214236
3	BK-1003	1	hotel	1	An Home - Phòng đơn Vũng Tàu	2024-03-25	\N	1	85.00	\N	Completed	\N	2026-03-28 11:31:47.214236	2026-03-28 11:31:47.214236
4	BK-1004	4	tour	2	Cuộc phiêu lưu dãy Alps	2024-04-01	\N	1	2450.00	\N	Confirmed	\N	2026-03-28 11:31:47.214236	2026-03-30 21:03:15.414442
\.


--
-- TOC entry 5276 (class 0 OID 16760)
-- Dependencies: 247
-- Data for Name: cache; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cache (key, value, expiration) FROM stdin;
\.


--
-- TOC entry 5277 (class 0 OID 16770)
-- Dependencies: 248
-- Data for Name: cache_locks; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cache_locks (key, owner, expiration) FROM stdin;
\.


--
-- TOC entry 5251 (class 0 OID 16495)
-- Dependencies: 222
-- Data for Name: destinations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.destinations (id, code, name, keyword, image_url, description, status, created_at) FROM stdin;
1	dest-1	Vũng Tàu	Vũng Tàu	https://images.unsplash.com/photo-1507525428034-b723cf961d3e?q=80&w=800	Thành phố biển nổi tiếng gần TP. Hồ Chí Minh.	active	2026-03-28 11:31:47.214236
2	dest-2	Đà Lạt	Đà Lạt	https://images.unsplash.com/photo-1558618666-fcd25c85cd64?q=80&w=800	Thành phố ngàn hoa với khí hậu mát mẻ, thơ mộng.	active	2026-03-28 11:31:47.214236
5	dest-5	Phú Quốc	Phú Quốc	https://images.unsplash.com/photo-1537953773345-d172ccf13cf1?q=80&w=800	Đảo ngọc thiên nhiên với bãi biển trắng mịn.	active	2026-03-28 11:31:47.214236
6	dest-6	Hà Nội	Hà Nội	https://images.unsplash.com/photo-1523592121529-f6dde35f079e?q=80&w=800	Thủ đô nghìn năm văn hiến với Hồ Gươm.	active	2026-03-28 11:31:47.214236
7	dest-7	TP. Hồ Chí Minh	TP. Hồ Chí Minh	https://images.unsplash.com/photo-1583417319070-4a69db38a482?q=80&w=800	Thành phố năng động nhất Việt Nam.	active	2026-03-28 11:31:47.214236
8	dest-8	Đà Nẵng	Đà Nẵng	https://images.unsplash.com/photo-1559592413-7cec4d0cae2b?q=80&w=800	Thành phố đáng sống bên bờ biển Mỹ Khê.	active	2026-03-28 11:31:47.214236
\.


--
-- TOC entry 5255 (class 0 OID 16535)
-- Dependencies: 226
-- Data for Name: hotels; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.hotels (id, name, image_url, image_alt, destination_id, location, full_location, feature, description, price_per_night, discount, badge, availability, rating, review_count, status, created_at, updated_at) FROM stdin;
1	An Home - Phòng đơn Vũng Tàu	https://cf.bstatic.com/xdata/images/hotel/max1024x768/438865324.jpg	An Home	\N	Vũng Tàu	Vũng Tàu, Việt Nam	Gần biển	An Home cung cấp không gian nghỉ ngơi ấm cúng tại trung tâm thành phố biển.	15.00	0	TOP RATED	available	9.1	428	active	2026-03-28 11:31:47.214236	2026-03-28 11:31:47.214236
2	The Song Vũng Tàu Xinh	https://cf.bstatic.com/xdata/images/hotel/max1280x900/414436894.jpg	The Song	\N	Vũng Tàu	Vũng Tàu, Việt Nam	View biển	Căn hộ cao cấp tại The Sóng với đầy đủ tiện nghi và tầm nhìn hướng biển.	18.00	20	BEST SELLER	available	9.1	312	active	2026-03-28 11:31:47.214236	2026-03-28 11:31:47.214236
3	Căn hộ The Sóng - Mai Villa	https://cf.bstatic.com/xdata/images/hotel/max1024x768/415510619.jpg	Mai Villa	\N	Vũng Tàu	Vũng Tàu, Việt Nam	Sang trọng	Trải nghiệm không gian sống thượng lưu tại Mai Villa.	22.00	0	LUXURY	selling-fast	8.8	1200	active	2026-03-28 11:31:47.214236	2026-03-28 11:31:47.214236
4	THE SÓNG - TRINH'S HOUSE	https://cf.bstatic.com/xdata/images/hotel/max1024x768/414436894.jpg	Trinh House	\N	Vũng Tàu	Vũng Tàu, Việt Nam	Ấm cúng	Trinh House mang đến cảm giác thân thuộc như chính ngôi nhà của bạn.	19.00	0	\N	available	8.2	56	active	2026-03-28 11:31:47.214236	2026-03-28 11:31:47.214236
5	Dalat Palace Heritage Hotel	https://images.unsplash.com/photo-1566073771259-6a8506099945?q=80&w=800	Dalat Palace	\N	Đà Lạt	Đà Lạt, Lâm Đồng, Việt Nam	Di sản	Khách sạn di sản hàng đầu tại Đà Lạt với kiến trúc Pháp cổ điển.	100.00	0	\N	available	9.5	1200	active	2026-03-28 11:31:47.214236	2026-03-28 11:31:47.214236
6	Terracotta Hotel & Resort Dalat	https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?q=80&w=800	Terracotta	\N	Đà Lạt	Hồ Tuyền Lâm, Đà Lạt	Resort	Khu nghỉ dưỡng nép mình bên hồ Tuyền Lâm mộng mơ.	80.00	0	\N	available	8.9	3400	active	2026-03-28 11:31:47.214236	2026-03-28 11:31:47.214236
\.


--
-- TOC entry 5275 (class 0 OID 16748)
-- Dependencies: 246
-- Data for Name: migrations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.migrations (id, migration, batch) FROM stdin;
1	2024_01_01_000000_create_users_table	1
2	2026_03_30_114931_create_cache_table	2
\.


--
-- TOC entry 5273 (class 0 OID 16720)
-- Dependencies: 244
-- Data for Name: notifications; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.notifications (id, user_id, title, message, type, is_read, created_at) FROM stdin;
\.


--
-- TOC entry 5267 (class 0 OID 16668)
-- Dependencies: 238
-- Data for Name: promo_codes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.promo_codes (id, code, promo_code, type, value_num, is_percent, use_limit, used_count, expiry_date, status, created_at) FROM stdin;
1	PROMO-001	WINTER2024	Dịch vụ	10.00	t	500	123	2024-12-31	active	2026-03-28 11:31:47.214236
2	PROMO-002	WELCOMENEW	Tất cả	100000.00	f	0	87	\N	active	2026-03-28 11:31:47.214236
4	PROMO-004	TEST123	Tất cả	15.00	t	100	0	\N	active	2026-03-30 21:03:14.364388
\.


--
-- TOC entry 5269 (class 0 OID 16688)
-- Dependencies: 240
-- Data for Name: recommendation_rules; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.recommendation_rules (id, code, trigger_kw, suggestion, type, is_active, created_at) FROM stdin;
1	RULE-001	Sapa	Tour Trekking Fansipan	cross-sell	t	2026-03-28 11:31:47.214236
2	RULE-002	Hội An	Vé show Ký Ức Hội An	cross-sell	t	2026-03-28 11:31:47.214236
3	RULE-003	Luxury	Dịch vụ đưa đón VIP bằng Limousine	upsell	f	2026-03-28 11:31:47.214236
\.


--
-- TOC entry 5263 (class 0 OID 16625)
-- Dependencies: 234
-- Data for Name: reviews; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.reviews (id, code, user_id, service_type, service_id, service_name, rating, comment, status, created_at) FROM stdin;
1	REV-001	1	hotel	1	An Home - Phòng đơn Vũng Tàu	5	Dịch vụ tuyệt vời, phòng sạch sẽ!	published	2026-03-28 11:31:47.214236
2	REV-002	2	tour	1	Khám phá bờ biển Amalfi	4	Chuyến đi rất thú vị nhưng thời gian hơi gấp.	published	2026-03-28 11:31:47.214236
3	REV-003	3	tour	4	Sapa Misty Mountains	1	Quá tệ, tôi sẽ không quay lại!	hidden	2026-03-28 11:31:47.214236
\.


--
-- TOC entry 5253 (class 0 OID 16510)
-- Dependencies: 224
-- Data for Name: tours; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tours (id, title, image_url, image_alt, destination_id, location, full_location, duration, includes, description, price_per_person, discount, badge, rating, review_count, status, created_at, updated_at) FROM stdin;
1	Khám phá bờ biển Amalfi	https://images.unsplash.com/photo-1533105079780-92b9be482077?q=80&w=1200	Amalfi Coast	\N	Ý	Bờ biển Amalfi, Ý	8 NGÀY	Hotels, Meals, Guide	Trải nghiệm vẻ đẹp ngoạn mục của phong cảnh thiên nhiên tại Ý.	1899.00	15	BEST SELLER	9.2	1284	active	2026-03-28 11:31:47.214236	2026-03-28 11:31:47.214236
2	Cuộc phiêu lưu dãy Alps Thụy Sĩ	https://images.unsplash.com/photo-1531310197839-ccf54634509e?q=80&w=1200	Swiss Alps	\N	Thụy Sĩ	Dãy Alps, Thụy Sĩ	6 NGÀY	Trains, Chalets, Skiing	Khám phá những đỉnh núi tuyết phủ trắng xóa của dãy Alps.	2450.00	0	FEATURED	9.8	840	active	2026-03-28 11:31:47.214236	2026-03-28 11:31:47.214236
3	Hành trình di sản Kyoto	https://images.unsplash.com/photo-1493976040374-85c8e12f0c0e?q=80&w=800	Kyoto Temple	\N	Nhật Bản	Kyoto, Nhật Bản	10 NGÀY	Ryokans, Tea Ceremony, Transport	Đắm mình vào không gian cổ kính của cố đô Kyoto.	1550.00	0	\N	9.5	2100	active	2026-03-28 11:31:47.214236	2026-03-28 11:31:47.214236
4	Sapa Misty Mountains	https://images.unsplash.com/photo-1504457047772-27fad17af0ec?q=80&w=1200	Sapa Mountains	\N	Việt Nam	Sapa, Lào Cai, Việt Nam	3 NGÀY	Trekking, Home Stay, Guide	Chinh phục đỉnh Fansipan và khám phá vẻ đẹp hoang sơ của Sapa.	150.00	0	POPULAR	8.9	1500	active	2026-03-28 11:31:47.214236	2026-03-28 11:31:47.214236
5	Kỳ nghỉ lãng mạn tại Maldives	https://images.unsplash.com/photo-1514282401047-d79a71a590e8?q=80&w=1200	Maldives	\N	Maldives	Đảo san hô, Maldives	7 NGÀY	Water Villa, Flights	Tận hưởng kỳ nghỉ sang trọng trên những hòn đảo thiên đường Maldives.	3200.00	0	LUXURY	9.9	450	active	2026-03-28 11:31:47.214236	2026-03-28 11:31:47.214236
\.


--
-- TOC entry 5249 (class 0 OID 16473)
-- Dependencies: 220
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, code, name, email, password, phone, avatar_url, role, status, created_at, updated_at) FROM stdin;
1	USR-001	Nguyễn Văn A	vana@gmail.com	482c811da5d5b4bc6d497ffa98491e38	\N	\N	client	active	2024-01-12 00:00:00	2026-03-28 11:31:47.214236
2	USR-002	Trần Thị B	thib@gmail.com	482c811da5d5b4bc6d497ffa98491e38	\N	\N	client	active	2024-02-15 00:00:00	2026-03-28 11:31:47.214236
3	USR-003	Lê Văn C	vanc@gmail.com	482c811da5d5b4bc6d497ffa98491e38	\N	\N	client	blocked	2024-02-20 00:00:00	2026-03-28 11:31:47.214236
4	USR-004	Phạm Minh D	minhd@gmail.com	482c811da5d5b4bc6d497ffa98491e38	\N	\N	client	active	2024-03-05 00:00:00	2026-03-28 11:31:47.214236
6	USR-006	Test User	testuser_demo2@example.com	$2y$12$8X6whRGMOb.gMLpyv51qQ.hVcvgja80FW7O9pqfsth4vAi/iaW/ci	\N	\N	client	active	2026-03-28 15:16:31	2026-03-28 15:16:31
7	USR-007	siuu	dangthanhvu0103@gmail.com	$2y$12$snIOgz3JZIBjcM1zVMnTK.qNmPJoWBXSNu0B1IIiyRxuIx/kQeuyC	\N	\N	client	active	2026-03-28 15:32:19	2026-03-28 15:32:19
8	USR-008	68 - Đặng Thanh Vũ	vudt.23ite@vku.udn.vn	$2y$12$62nSfaU3i4ChcQ1S.YzU9OQusZ9tGzN.onq75Nk9DI/1lZdGZJkgm	0987789765	\N	client	active	2026-03-28 15:53:52	2026-03-28 15:53:52
5	ADM-001	Admin	admin@travelwise.com	$2y$12$W/IJBu3tEJN8QTPYN8W6OelBgyvWW3Djv3NppkBJCezi/JpmMYnvu	\N	\N	admin	active	2024-01-01 00:00:00	2026-03-28 23:07:19.120089
9	USR-999	Demo User	user@travelwise.com	$2y$12$RJHda5DlhOGh3MEH.GbB1OWHrAxcEBJIVYHU/ZeLgy.9ii89.u8oq	\N	\N	client	active	2026-03-28 16:07:19	2026-03-28 16:07:19
\.


--
-- TOC entry 5265 (class 0 OID 16649)
-- Dependencies: 236
-- Data for Name: wishlists; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.wishlists (id, user_id, service_type, service_id, created_at) FROM stdin;
\.


--
-- TOC entry 5297 (class 0 OID 0)
-- Dependencies: 229
-- Name: addons_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.addons_id_seq', 3, true);


--
-- TOC entry 5298 (class 0 OID 0)
-- Dependencies: 241
-- Name: automation_logs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.automation_logs_id_seq', 4, true);


--
-- TOC entry 5299 (class 0 OID 0)
-- Dependencies: 231
-- Name: booking_addons_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.booking_addons_id_seq', 1, false);


--
-- TOC entry 5300 (class 0 OID 0)
-- Dependencies: 227
-- Name: bookings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.bookings_id_seq', 4, true);


--
-- TOC entry 5301 (class 0 OID 0)
-- Dependencies: 221
-- Name: destinations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.destinations_id_seq', 12, true);


--
-- TOC entry 5302 (class 0 OID 0)
-- Dependencies: 225
-- Name: hotels_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.hotels_id_seq', 6, true);


--
-- TOC entry 5303 (class 0 OID 0)
-- Dependencies: 245
-- Name: migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.migrations_id_seq', 2, true);


--
-- TOC entry 5304 (class 0 OID 0)
-- Dependencies: 243
-- Name: notifications_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.notifications_id_seq', 1, false);


--
-- TOC entry 5305 (class 0 OID 0)
-- Dependencies: 237
-- Name: promo_codes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.promo_codes_id_seq', 4, true);


--
-- TOC entry 5306 (class 0 OID 0)
-- Dependencies: 239
-- Name: recommendation_rules_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.recommendation_rules_id_seq', 3, true);


--
-- TOC entry 5307 (class 0 OID 0)
-- Dependencies: 233
-- Name: reviews_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.reviews_id_seq', 3, true);


--
-- TOC entry 5308 (class 0 OID 0)
-- Dependencies: 223
-- Name: tours_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tours_id_seq', 5, true);


--
-- TOC entry 5309 (class 0 OID 0)
-- Dependencies: 219
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 11, true);


--
-- TOC entry 5310 (class 0 OID 0)
-- Dependencies: 235
-- Name: wishlists_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.wishlists_id_seq', 1, false);


--
-- TOC entry 5050 (class 2606 OID 16602)
-- Name: addons addons_code_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.addons
    ADD CONSTRAINT addons_code_key UNIQUE (code);


--
-- TOC entry 5052 (class 2606 OID 16600)
-- Name: addons addons_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.addons
    ADD CONSTRAINT addons_pkey PRIMARY KEY (id);


--
-- TOC entry 5076 (class 2606 OID 16718)
-- Name: automation_logs automation_logs_code_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.automation_logs
    ADD CONSTRAINT automation_logs_code_key UNIQUE (code);


--
-- TOC entry 5078 (class 2606 OID 16716)
-- Name: automation_logs automation_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.automation_logs
    ADD CONSTRAINT automation_logs_pkey PRIMARY KEY (id);


--
-- TOC entry 5054 (class 2606 OID 16613)
-- Name: booking_addons booking_addons_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.booking_addons
    ADD CONSTRAINT booking_addons_pkey PRIMARY KEY (id);


--
-- TOC entry 5044 (class 2606 OID 16580)
-- Name: bookings bookings_code_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bookings
    ADD CONSTRAINT bookings_code_key UNIQUE (code);


--
-- TOC entry 5046 (class 2606 OID 16578)
-- Name: bookings bookings_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bookings
    ADD CONSTRAINT bookings_pkey PRIMARY KEY (id);


--
-- TOC entry 5088 (class 2606 OID 16779)
-- Name: cache_locks cache_locks_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cache_locks
    ADD CONSTRAINT cache_locks_pkey PRIMARY KEY (key);


--
-- TOC entry 5086 (class 2606 OID 16769)
-- Name: cache cache_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cache
    ADD CONSTRAINT cache_pkey PRIMARY KEY (key);


--
-- TOC entry 5034 (class 2606 OID 16508)
-- Name: destinations destinations_code_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.destinations
    ADD CONSTRAINT destinations_code_key UNIQUE (code);


--
-- TOC entry 5036 (class 2606 OID 16506)
-- Name: destinations destinations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.destinations
    ADD CONSTRAINT destinations_pkey PRIMARY KEY (id);


--
-- TOC entry 5041 (class 2606 OID 16553)
-- Name: hotels hotels_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hotels
    ADD CONSTRAINT hotels_pkey PRIMARY KEY (id);


--
-- TOC entry 5084 (class 2606 OID 16756)
-- Name: migrations migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.migrations
    ADD CONSTRAINT migrations_pkey PRIMARY KEY (id);


--
-- TOC entry 5082 (class 2606 OID 16732)
-- Name: notifications notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_pkey PRIMARY KEY (id);


--
-- TOC entry 5066 (class 2606 OID 16684)
-- Name: promo_codes promo_codes_code_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promo_codes
    ADD CONSTRAINT promo_codes_code_key UNIQUE (code);


--
-- TOC entry 5068 (class 2606 OID 16682)
-- Name: promo_codes promo_codes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promo_codes
    ADD CONSTRAINT promo_codes_pkey PRIMARY KEY (id);


--
-- TOC entry 5070 (class 2606 OID 16686)
-- Name: promo_codes promo_codes_promo_code_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promo_codes
    ADD CONSTRAINT promo_codes_promo_code_key UNIQUE (promo_code);


--
-- TOC entry 5072 (class 2606 OID 16703)
-- Name: recommendation_rules recommendation_rules_code_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recommendation_rules
    ADD CONSTRAINT recommendation_rules_code_key UNIQUE (code);


--
-- TOC entry 5074 (class 2606 OID 16701)
-- Name: recommendation_rules recommendation_rules_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recommendation_rules
    ADD CONSTRAINT recommendation_rules_pkey PRIMARY KEY (id);


--
-- TOC entry 5057 (class 2606 OID 16642)
-- Name: reviews reviews_code_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT reviews_code_key UNIQUE (code);


--
-- TOC entry 5059 (class 2606 OID 16640)
-- Name: reviews reviews_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT reviews_pkey PRIMARY KEY (id);


--
-- TOC entry 5039 (class 2606 OID 16527)
-- Name: tours tours_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tours
    ADD CONSTRAINT tours_pkey PRIMARY KEY (id);


--
-- TOC entry 5028 (class 2606 OID 16490)
-- Name: users users_code_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_code_key UNIQUE (code);


--
-- TOC entry 5030 (class 2606 OID 16492)
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- TOC entry 5032 (class 2606 OID 16488)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- TOC entry 5062 (class 2606 OID 16659)
-- Name: wishlists wishlists_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.wishlists
    ADD CONSTRAINT wishlists_pkey PRIMARY KEY (id);


--
-- TOC entry 5064 (class 2606 OID 16661)
-- Name: wishlists wishlists_user_id_service_type_service_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.wishlists
    ADD CONSTRAINT wishlists_user_id_service_type_service_id_key UNIQUE (user_id, service_type, service_id);


--
-- TOC entry 5079 (class 1259 OID 16745)
-- Name: idx_automation_logs_time; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_automation_logs_time ON public.automation_logs USING btree (created_at DESC);


--
-- TOC entry 5047 (class 1259 OID 16741)
-- Name: idx_bookings_service; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_bookings_service ON public.bookings USING btree (service_type, service_id);


--
-- TOC entry 5048 (class 1259 OID 16740)
-- Name: idx_bookings_user; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_bookings_user ON public.bookings USING btree (user_id);


--
-- TOC entry 5042 (class 1259 OID 16739)
-- Name: idx_hotels_destination; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_hotels_destination ON public.hotels USING btree (destination_id);


--
-- TOC entry 5080 (class 1259 OID 16744)
-- Name: idx_notifications_user; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_notifications_user ON public.notifications USING btree (user_id, is_read);


--
-- TOC entry 5055 (class 1259 OID 16742)
-- Name: idx_reviews_service; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_reviews_service ON public.reviews USING btree (service_type, service_id);


--
-- TOC entry 5037 (class 1259 OID 16738)
-- Name: idx_tours_destination; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_tours_destination ON public.tours USING btree (destination_id);


--
-- TOC entry 5060 (class 1259 OID 16743)
-- Name: idx_wishlists_user; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_wishlists_user ON public.wishlists USING btree (user_id);


--
-- TOC entry 5100 (class 2620 OID 16586)
-- Name: bookings trg_bookings_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_bookings_updated_at BEFORE UPDATE ON public.bookings FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- TOC entry 5099 (class 2620 OID 16559)
-- Name: hotels trg_hotels_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_hotels_updated_at BEFORE UPDATE ON public.hotels FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- TOC entry 5098 (class 2620 OID 16533)
-- Name: tours trg_tours_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_tours_updated_at BEFORE UPDATE ON public.tours FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- TOC entry 5097 (class 2620 OID 16493)
-- Name: users trg_users_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_users_updated_at BEFORE UPDATE ON public.users FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- TOC entry 5092 (class 2606 OID 16619)
-- Name: booking_addons booking_addons_addon_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.booking_addons
    ADD CONSTRAINT booking_addons_addon_id_fkey FOREIGN KEY (addon_id) REFERENCES public.addons(id) ON DELETE CASCADE;


--
-- TOC entry 5093 (class 2606 OID 16614)
-- Name: booking_addons booking_addons_booking_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.booking_addons
    ADD CONSTRAINT booking_addons_booking_id_fkey FOREIGN KEY (booking_id) REFERENCES public.bookings(id) ON DELETE CASCADE;


--
-- TOC entry 5091 (class 2606 OID 16581)
-- Name: bookings bookings_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bookings
    ADD CONSTRAINT bookings_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- TOC entry 5090 (class 2606 OID 16554)
-- Name: hotels hotels_destination_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hotels
    ADD CONSTRAINT hotels_destination_id_fkey FOREIGN KEY (destination_id) REFERENCES public.destinations(id) ON DELETE SET NULL;


--
-- TOC entry 5096 (class 2606 OID 16733)
-- Name: notifications notifications_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- TOC entry 5094 (class 2606 OID 16643)
-- Name: reviews reviews_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT reviews_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- TOC entry 5089 (class 2606 OID 16528)
-- Name: tours tours_destination_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tours
    ADD CONSTRAINT tours_destination_id_fkey FOREIGN KEY (destination_id) REFERENCES public.destinations(id) ON DELETE SET NULL;


--
-- TOC entry 5095 (class 2606 OID 16662)
-- Name: wishlists wishlists_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.wishlists
    ADD CONSTRAINT wishlists_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


-- Completed on 2026-04-04 00:51:45

--
-- PostgreSQL database dump complete
--

\unrestrict cDmLVsjala0bRJSXgskzIhrFzN1fgCmP32pBnDxte5JhIcnBmKBOAGCccJZc4dz

