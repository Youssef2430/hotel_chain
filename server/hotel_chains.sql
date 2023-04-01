--
-- PostgreSQL database dump
--

-- Dumped from database version 14.7 (Homebrew)
-- Dumped by pg_dump version 15.1

-- Started on 2023-03-31 22:18:41 EDT

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

--
-- TOC entry 4 (class 2615 OID 2200)
-- Name: public; Type: SCHEMA; Schema: -; Owner: ychouay
--

-- *not* creating schema, since initdb creates it


ALTER SCHEMA public OWNER TO ychouay;

--
-- TOC entry 239 (class 1255 OID 34079)
-- Name: log_hotel_change(); Type: FUNCTION; Schema: public; Owner: ychouay
--

CREATE FUNCTION public.log_hotel_change() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
	 INSERT INTO hotel_audit(hotel_id,operation,changed_on)
	 VALUES(OLD.hotel_id,'updated',now());

	 RETURN NEW;
END;
$$;


ALTER FUNCTION public.log_hotel_change() OWNER TO ychouay;

--
-- TOC entry 240 (class 1255 OID 34081)
-- Name: log_hotel_delete(); Type: FUNCTION; Schema: public; Owner: ychouay
--

CREATE FUNCTION public.log_hotel_delete() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
	 INSERT INTO hotel_audit(hotel_id,operation,changed_on)
	 VALUES(OLD.hotel_id,'deleted',now());

	 RETURN NEW;
END;
$$;


ALTER FUNCTION public.log_hotel_delete() OWNER TO ychouay;

--
-- TOC entry 241 (class 1255 OID 34095)
-- Name: log_reservation(); Type: FUNCTION; Schema: public; Owner: ychouay
--

CREATE FUNCTION public.log_reservation() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
	IF NEW.status = 'finished' THEN
	 INSERT INTO reservation_audit(reservation_id, changed_on, operation)
	 VALUES(OLD.reservation_id, now(), 'closed');
	END IF;
	RETURN NEW;
END;
$$;


ALTER FUNCTION public.log_reservation() OWNER TO ychouay;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 216 (class 1259 OID 33863)
-- Name: central_office; Type: TABLE; Schema: public; Owner: ychouay
--

CREATE TABLE public.central_office (
    office_id integer NOT NULL,
    chain_id integer NOT NULL,
    email character varying NOT NULL,
    phone_number character varying[] NOT NULL,
    address character varying NOT NULL,
    office_name character varying
);


ALTER TABLE public.central_office OWNER TO ychouay;

--
-- TOC entry 215 (class 1259 OID 33862)
-- Name: central_office_chain_id_seq; Type: SEQUENCE; Schema: public; Owner: ychouay
--

CREATE SEQUENCE public.central_office_chain_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.central_office_chain_id_seq OWNER TO ychouay;

--
-- TOC entry 3750 (class 0 OID 0)
-- Dependencies: 215
-- Name: central_office_chain_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ychouay
--

ALTER SEQUENCE public.central_office_chain_id_seq OWNED BY public.central_office.chain_id;


--
-- TOC entry 214 (class 1259 OID 33861)
-- Name: central_office_office_id_seq; Type: SEQUENCE; Schema: public; Owner: ychouay
--

CREATE SEQUENCE public.central_office_office_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.central_office_office_id_seq OWNER TO ychouay;

--
-- TOC entry 3751 (class 0 OID 0)
-- Dependencies: 214
-- Name: central_office_office_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ychouay
--

ALTER SEQUENCE public.central_office_office_id_seq OWNED BY public.central_office.office_id;


--
-- TOC entry 210 (class 1259 OID 33843)
-- Name: chains; Type: TABLE; Schema: public; Owner: ychouay
--

CREATE TABLE public.chains (
    chain_id integer NOT NULL,
    name character varying NOT NULL
);


ALTER TABLE public.chains OWNER TO ychouay;

--
-- TOC entry 209 (class 1259 OID 33842)
-- Name: chains_chain_id_seq; Type: SEQUENCE; Schema: public; Owner: ychouay
--

CREATE SEQUENCE public.chains_chain_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.chains_chain_id_seq OWNER TO ychouay;

--
-- TOC entry 3752 (class 0 OID 0)
-- Dependencies: 209
-- Name: chains_chain_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ychouay
--

ALTER SEQUENCE public.chains_chain_id_seq OWNED BY public.chains.chain_id;


--
-- TOC entry 223 (class 1259 OID 33901)
-- Name: customers; Type: TABLE; Schema: public; Owner: ychouay
--

CREATE TABLE public.customers (
    sin integer NOT NULL,
    email character varying NOT NULL,
    password character varying NOT NULL,
    customer_id integer NOT NULL,
    registration_date date DEFAULT CURRENT_TIMESTAMP NOT NULL,
    phone_number character varying[],
    customer_address character varying[]
);


ALTER TABLE public.customers OWNER TO ychouay;

--
-- TOC entry 222 (class 1259 OID 33900)
-- Name: customers_customer_id_seq; Type: SEQUENCE; Schema: public; Owner: ychouay
--

CREATE SEQUENCE public.customers_customer_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.customers_customer_id_seq OWNER TO ychouay;

--
-- TOC entry 3753 (class 0 OID 0)
-- Dependencies: 222
-- Name: customers_customer_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ychouay
--

ALTER SEQUENCE public.customers_customer_id_seq OWNED BY public.customers.customer_id;


--
-- TOC entry 221 (class 1259 OID 33899)
-- Name: customers_sin_seq; Type: SEQUENCE; Schema: public; Owner: ychouay
--

CREATE SEQUENCE public.customers_sin_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.customers_sin_seq OWNER TO ychouay;

--
-- TOC entry 3754 (class 0 OID 0)
-- Dependencies: 221
-- Name: customers_sin_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ychouay
--

ALTER SEQUENCE public.customers_sin_seq OWNED BY public.customers.sin;


--
-- TOC entry 227 (class 1259 OID 33913)
-- Name: employees; Type: TABLE; Schema: public; Owner: ychouay
--

CREATE TABLE public.employees (
    sin integer NOT NULL,
    email character varying NOT NULL,
    password character varying NOT NULL,
    role character varying,
    employee_id integer NOT NULL,
    hotel_id integer,
    employee_address character varying[]
);


ALTER TABLE public.employees OWNER TO ychouay;

--
-- TOC entry 225 (class 1259 OID 33911)
-- Name: employees_employee_id_seq; Type: SEQUENCE; Schema: public; Owner: ychouay
--

CREATE SEQUENCE public.employees_employee_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.employees_employee_id_seq OWNER TO ychouay;

--
-- TOC entry 3755 (class 0 OID 0)
-- Dependencies: 225
-- Name: employees_employee_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ychouay
--

ALTER SEQUENCE public.employees_employee_id_seq OWNED BY public.employees.employee_id;


--
-- TOC entry 226 (class 1259 OID 33912)
-- Name: employees_hotel_id_seq; Type: SEQUENCE; Schema: public; Owner: ychouay
--

CREATE SEQUENCE public.employees_hotel_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.employees_hotel_id_seq OWNER TO ychouay;

--
-- TOC entry 3756 (class 0 OID 0)
-- Dependencies: 226
-- Name: employees_hotel_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ychouay
--

ALTER SEQUENCE public.employees_hotel_id_seq OWNED BY public.employees.hotel_id;


--
-- TOC entry 224 (class 1259 OID 33910)
-- Name: employees_sin_seq; Type: SEQUENCE; Schema: public; Owner: ychouay
--

CREATE SEQUENCE public.employees_sin_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.employees_sin_seq OWNER TO ychouay;

--
-- TOC entry 3757 (class 0 OID 0)
-- Dependencies: 224
-- Name: employees_sin_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ychouay
--

ALTER SEQUENCE public.employees_sin_seq OWNED BY public.employees.sin;


--
-- TOC entry 234 (class 1259 OID 34067)
-- Name: hotel_audit; Type: TABLE; Schema: public; Owner: ychouay
--

CREATE TABLE public.hotel_audit (
    hotel_id integer NOT NULL,
    operation character varying NOT NULL,
    changed_on timestamp without time zone NOT NULL
);


ALTER TABLE public.hotel_audit OWNER TO ychouay;

--
-- TOC entry 233 (class 1259 OID 34066)
-- Name: hotel_audit_hotel_id_seq; Type: SEQUENCE; Schema: public; Owner: ychouay
--

CREATE SEQUENCE public.hotel_audit_hotel_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.hotel_audit_hotel_id_seq OWNER TO ychouay;

--
-- TOC entry 3758 (class 0 OID 0)
-- Dependencies: 233
-- Name: hotel_audit_hotel_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ychouay
--

ALTER SEQUENCE public.hotel_audit_hotel_id_seq OWNED BY public.hotel_audit.hotel_id;


--
-- TOC entry 213 (class 1259 OID 33851)
-- Name: hotels; Type: TABLE; Schema: public; Owner: ychouay
--

CREATE TABLE public.hotels (
    hotel_id integer NOT NULL,
    chain_id integer NOT NULL,
    hname character varying NOT NULL,
    rating integer NOT NULL,
    email character varying NOT NULL,
    phone_number character varying[],
    address character varying NOT NULL,
    manager_id integer,
    count_rating integer DEFAULT 1,
    category character varying,
    CONSTRAINT hotels_rating_check CHECK (((rating > 0) AND (rating <= 5)))
);


ALTER TABLE public.hotels OWNER TO ychouay;

--
-- TOC entry 212 (class 1259 OID 33850)
-- Name: hotels_chain_id_seq; Type: SEQUENCE; Schema: public; Owner: ychouay
--

CREATE SEQUENCE public.hotels_chain_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.hotels_chain_id_seq OWNER TO ychouay;

--
-- TOC entry 3759 (class 0 OID 0)
-- Dependencies: 212
-- Name: hotels_chain_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ychouay
--

ALTER SEQUENCE public.hotels_chain_id_seq OWNED BY public.hotels.chain_id;


--
-- TOC entry 211 (class 1259 OID 33849)
-- Name: hotels_hotel_id_seq; Type: SEQUENCE; Schema: public; Owner: ychouay
--

CREATE SEQUENCE public.hotels_hotel_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.hotels_hotel_id_seq OWNER TO ychouay;

--
-- TOC entry 3760 (class 0 OID 0)
-- Dependencies: 211
-- Name: hotels_hotel_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ychouay
--

ALTER SEQUENCE public.hotels_hotel_id_seq OWNED BY public.hotels.hotel_id;


--
-- TOC entry 220 (class 1259 OID 33891)
-- Name: person; Type: TABLE; Schema: public; Owner: ychouay
--

CREATE TABLE public.person (
    sin integer NOT NULL,
    fullname character varying NOT NULL,
    email character varying NOT NULL
);


ALTER TABLE public.person OWNER TO ychouay;

--
-- TOC entry 219 (class 1259 OID 33890)
-- Name: person_sin_seq; Type: SEQUENCE; Schema: public; Owner: ychouay
--

CREATE SEQUENCE public.person_sin_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.person_sin_seq OWNER TO ychouay;

--
-- TOC entry 3761 (class 0 OID 0)
-- Dependencies: 219
-- Name: person_sin_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ychouay
--

ALTER SEQUENCE public.person_sin_seq OWNED BY public.person.sin;


--
-- TOC entry 232 (class 1259 OID 33928)
-- Name: reservation; Type: TABLE; Schema: public; Owner: ychouay
--

CREATE TABLE public.reservation (
    reservation_id integer NOT NULL,
    chain_id integer NOT NULL,
    hotel_id integer NOT NULL,
    room_number integer,
    customer_id integer NOT NULL,
    status character varying,
    active boolean DEFAULT true,
    rated boolean DEFAULT false,
    check_in date,
    check_out date
);


ALTER TABLE public.reservation OWNER TO ychouay;

--
-- TOC entry 235 (class 1259 OID 34074)
-- Name: reservation_audit; Type: TABLE; Schema: public; Owner: ychouay
--

CREATE TABLE public.reservation_audit (
    reservation_id integer NOT NULL,
    changed_on date,
    operation character varying
);


ALTER TABLE public.reservation_audit OWNER TO ychouay;

--
-- TOC entry 236 (class 1259 OID 34083)
-- Name: reservation_audit_reservation_id_seq; Type: SEQUENCE; Schema: public; Owner: ychouay
--

CREATE SEQUENCE public.reservation_audit_reservation_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.reservation_audit_reservation_id_seq OWNER TO ychouay;

--
-- TOC entry 3762 (class 0 OID 0)
-- Dependencies: 236
-- Name: reservation_audit_reservation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ychouay
--

ALTER SEQUENCE public.reservation_audit_reservation_id_seq OWNED BY public.reservation_audit.reservation_id;


--
-- TOC entry 229 (class 1259 OID 33924)
-- Name: reservation_chain_id_seq; Type: SEQUENCE; Schema: public; Owner: ychouay
--

CREATE SEQUENCE public.reservation_chain_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.reservation_chain_id_seq OWNER TO ychouay;

--
-- TOC entry 3763 (class 0 OID 0)
-- Dependencies: 229
-- Name: reservation_chain_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ychouay
--

ALTER SEQUENCE public.reservation_chain_id_seq OWNED BY public.reservation.chain_id;


--
-- TOC entry 231 (class 1259 OID 33926)
-- Name: reservation_customer_id_seq; Type: SEQUENCE; Schema: public; Owner: ychouay
--

CREATE SEQUENCE public.reservation_customer_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.reservation_customer_id_seq OWNER TO ychouay;

--
-- TOC entry 3764 (class 0 OID 0)
-- Dependencies: 231
-- Name: reservation_customer_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ychouay
--

ALTER SEQUENCE public.reservation_customer_id_seq OWNED BY public.reservation.customer_id;


--
-- TOC entry 230 (class 1259 OID 33925)
-- Name: reservation_hotel_id_seq; Type: SEQUENCE; Schema: public; Owner: ychouay
--

CREATE SEQUENCE public.reservation_hotel_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.reservation_hotel_id_seq OWNER TO ychouay;

--
-- TOC entry 3765 (class 0 OID 0)
-- Dependencies: 230
-- Name: reservation_hotel_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ychouay
--

ALTER SEQUENCE public.reservation_hotel_id_seq OWNED BY public.reservation.hotel_id;


--
-- TOC entry 228 (class 1259 OID 33923)
-- Name: reservation_reservation_id_seq; Type: SEQUENCE; Schema: public; Owner: ychouay
--

CREATE SEQUENCE public.reservation_reservation_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.reservation_reservation_id_seq OWNER TO ychouay;

--
-- TOC entry 3766 (class 0 OID 0)
-- Dependencies: 228
-- Name: reservation_reservation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ychouay
--

ALTER SEQUENCE public.reservation_reservation_id_seq OWNED BY public.reservation.reservation_id;


--
-- TOC entry 218 (class 1259 OID 33874)
-- Name: rooms; Type: TABLE; Schema: public; Owner: ychouay
--

CREATE TABLE public.rooms (
    room_number integer NOT NULL,
    hotel_id integer NOT NULL,
    view character varying,
    price integer NOT NULL,
    capacity integer NOT NULL,
    extendable boolean NOT NULL,
    damaged boolean,
    pictures character varying[],
    amenities character varying[]
);


ALTER TABLE public.rooms OWNER TO ychouay;

--
-- TOC entry 237 (class 1259 OID 34101)
-- Name: rooms_capacity; Type: VIEW; Schema: public; Owner: ychouay
--

CREATE VIEW public.rooms_capacity AS
 SELECT rooms.room_number,
    rooms.capacity
   FROM public.rooms
  WHERE (rooms.hotel_id = 32);


ALTER TABLE public.rooms_capacity OWNER TO ychouay;

--
-- TOC entry 217 (class 1259 OID 33872)
-- Name: rooms_hotel_id_seq; Type: SEQUENCE; Schema: public; Owner: ychouay
--

CREATE SEQUENCE public.rooms_hotel_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.rooms_hotel_id_seq OWNER TO ychouay;

--
-- TOC entry 3767 (class 0 OID 0)
-- Dependencies: 217
-- Name: rooms_hotel_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ychouay
--

ALTER SEQUENCE public.rooms_hotel_id_seq OWNED BY public.rooms.hotel_id;


--
-- TOC entry 238 (class 1259 OID 34105)
-- Name: rooms_per_area; Type: VIEW; Schema: public; Owner: ychouay
--

CREATE VIEW public.rooms_per_area AS
 SELECT split_part((hotels.address)::text, ', '::text, 2) AS area,
    count(rooms.room_number) AS count
   FROM (public.hotels
     JOIN public.rooms USING (hotel_id))
  GROUP BY (split_part((hotels.address)::text, ', '::text, 2));


ALTER TABLE public.rooms_per_area OWNER TO ychouay;

--
-- TOC entry 3520 (class 2604 OID 33866)
-- Name: central_office office_id; Type: DEFAULT; Schema: public; Owner: ychouay
--

ALTER TABLE ONLY public.central_office ALTER COLUMN office_id SET DEFAULT nextval('public.central_office_office_id_seq'::regclass);


--
-- TOC entry 3521 (class 2604 OID 33867)
-- Name: central_office chain_id; Type: DEFAULT; Schema: public; Owner: ychouay
--

ALTER TABLE ONLY public.central_office ALTER COLUMN chain_id SET DEFAULT nextval('public.central_office_chain_id_seq'::regclass);


--
-- TOC entry 3516 (class 2604 OID 33846)
-- Name: chains chain_id; Type: DEFAULT; Schema: public; Owner: ychouay
--

ALTER TABLE ONLY public.chains ALTER COLUMN chain_id SET DEFAULT nextval('public.chains_chain_id_seq'::regclass);


--
-- TOC entry 3524 (class 2604 OID 33904)
-- Name: customers sin; Type: DEFAULT; Schema: public; Owner: ychouay
--

ALTER TABLE ONLY public.customers ALTER COLUMN sin SET DEFAULT nextval('public.customers_sin_seq'::regclass);


--
-- TOC entry 3525 (class 2604 OID 33905)
-- Name: customers customer_id; Type: DEFAULT; Schema: public; Owner: ychouay
--

ALTER TABLE ONLY public.customers ALTER COLUMN customer_id SET DEFAULT nextval('public.customers_customer_id_seq'::regclass);


--
-- TOC entry 3527 (class 2604 OID 33916)
-- Name: employees sin; Type: DEFAULT; Schema: public; Owner: ychouay
--

ALTER TABLE ONLY public.employees ALTER COLUMN sin SET DEFAULT nextval('public.employees_sin_seq'::regclass);


--
-- TOC entry 3528 (class 2604 OID 33917)
-- Name: employees employee_id; Type: DEFAULT; Schema: public; Owner: ychouay
--

ALTER TABLE ONLY public.employees ALTER COLUMN employee_id SET DEFAULT nextval('public.employees_employee_id_seq'::regclass);


--
-- TOC entry 3529 (class 2604 OID 33918)
-- Name: employees hotel_id; Type: DEFAULT; Schema: public; Owner: ychouay
--

ALTER TABLE ONLY public.employees ALTER COLUMN hotel_id SET DEFAULT nextval('public.employees_hotel_id_seq'::regclass);


--
-- TOC entry 3536 (class 2604 OID 34070)
-- Name: hotel_audit hotel_id; Type: DEFAULT; Schema: public; Owner: ychouay
--

ALTER TABLE ONLY public.hotel_audit ALTER COLUMN hotel_id SET DEFAULT nextval('public.hotel_audit_hotel_id_seq'::regclass);


--
-- TOC entry 3517 (class 2604 OID 33854)
-- Name: hotels hotel_id; Type: DEFAULT; Schema: public; Owner: ychouay
--

ALTER TABLE ONLY public.hotels ALTER COLUMN hotel_id SET DEFAULT nextval('public.hotels_hotel_id_seq'::regclass);


--
-- TOC entry 3518 (class 2604 OID 33855)
-- Name: hotels chain_id; Type: DEFAULT; Schema: public; Owner: ychouay
--

ALTER TABLE ONLY public.hotels ALTER COLUMN chain_id SET DEFAULT nextval('public.hotels_chain_id_seq'::regclass);


--
-- TOC entry 3523 (class 2604 OID 33894)
-- Name: person sin; Type: DEFAULT; Schema: public; Owner: ychouay
--

ALTER TABLE ONLY public.person ALTER COLUMN sin SET DEFAULT nextval('public.person_sin_seq'::regclass);


--
-- TOC entry 3530 (class 2604 OID 33931)
-- Name: reservation reservation_id; Type: DEFAULT; Schema: public; Owner: ychouay
--

ALTER TABLE ONLY public.reservation ALTER COLUMN reservation_id SET DEFAULT nextval('public.reservation_reservation_id_seq'::regclass);


--
-- TOC entry 3531 (class 2604 OID 33932)
-- Name: reservation chain_id; Type: DEFAULT; Schema: public; Owner: ychouay
--

ALTER TABLE ONLY public.reservation ALTER COLUMN chain_id SET DEFAULT nextval('public.reservation_chain_id_seq'::regclass);


--
-- TOC entry 3532 (class 2604 OID 33933)
-- Name: reservation hotel_id; Type: DEFAULT; Schema: public; Owner: ychouay
--

ALTER TABLE ONLY public.reservation ALTER COLUMN hotel_id SET DEFAULT nextval('public.reservation_hotel_id_seq'::regclass);


--
-- TOC entry 3533 (class 2604 OID 33934)
-- Name: reservation customer_id; Type: DEFAULT; Schema: public; Owner: ychouay
--

ALTER TABLE ONLY public.reservation ALTER COLUMN customer_id SET DEFAULT nextval('public.reservation_customer_id_seq'::regclass);


--
-- TOC entry 3537 (class 2604 OID 34084)
-- Name: reservation_audit reservation_id; Type: DEFAULT; Schema: public; Owner: ychouay
--

ALTER TABLE ONLY public.reservation_audit ALTER COLUMN reservation_id SET DEFAULT nextval('public.reservation_audit_reservation_id_seq'::regclass);


--
-- TOC entry 3522 (class 2604 OID 33877)
-- Name: rooms hotel_id; Type: DEFAULT; Schema: public; Owner: ychouay
--

ALTER TABLE ONLY public.rooms ALTER COLUMN hotel_id SET DEFAULT nextval('public.rooms_hotel_id_seq'::regclass);


--
-- TOC entry 3723 (class 0 OID 33863)
-- Dependencies: 216
-- Data for Name: central_office; Type: TABLE DATA; Schema: public; Owner: ychouay
--

COPY public.central_office (office_id, chain_id, email, phone_number, address, office_name) FROM stdin;
4	13	customer.care@marriott.com	{13013803000}	10400 Fernwood Road, Maryland, Bethesda, 20817, USA	Marriott International
5	12	guestassistance@hilton.com	{17038831000}	7930 Jones Branch Drive, Virginia, McLean, 22102, USA	Hilton Worldwide Holdings Inc.
6	14	customer.care@ihg.com	{18774242449}	0 Broadwater Park, Buckinghamshire, Denham, UB9 5HR, United Kingdom	InterContinental Hotels Group (IHG)
7	15	customerrelations@accor.com	{+33(0)145388600}	110 avenue de France, Paris, cedex 13, 75210, France	AccorHotels
8	16	hyattcustomerservice@hyatt.com	{18003237249}	150 North Riverside Plaza, Chicago, Illinois, 60606, USA	Hyatt Hotels Corporation
\.


--
-- TOC entry 3717 (class 0 OID 33843)
-- Dependencies: 210
-- Data for Name: chains; Type: TABLE DATA; Schema: public; Owner: ychouay
--

COPY public.chains (chain_id, name) FROM stdin;
12	Hilton Hotels & Resorts
13	Marriott International
14	InterContinental Hotels Group
15	AccorHotels
16	Hyatt Hotels Corporation
\.


--
-- TOC entry 3730 (class 0 OID 33901)
-- Dependencies: 223
-- Data for Name: customers; Type: TABLE DATA; Schema: public; Owner: ychouay
--

COPY public.customers (sin, email, password, customer_id, registration_date, phone_number, customer_address) FROM stdin;
4	test@email.ca	$2a$10$7ctTs0Pr3bLF6S.3qYky2O1v.Tgvvbc.C0CGyeKFq8QzpbSeAB7Ku	3	2023-03-06	{2342341234}	{{"23&test&on &idk&k1k2n2"}}
6	test@test.ca	$2a$10$Xg1or/TmA4rV3h8lwTO3O.1EvJ2JwkpMxGTzjuXjmtoSMiFpx4wlu	4	2023-03-13	{123445221}	{{22&dbsgdg&csdf&vsvb&fsda}}
\.


--
-- TOC entry 3734 (class 0 OID 33913)
-- Dependencies: 227
-- Data for Name: employees; Type: TABLE DATA; Schema: public; Owner: ychouay
--

COPY public.employees (sin, email, password, role, employee_id, hotel_id, employee_address) FROM stdin;
8	employee@test.ca	$2a$10$U4S32hcBsPfSknNM/h6P9OtlsCrkrCvLjXXPiG6vMOkctiqjxFg92	employee	2	\N	{"23 Micheal, Toronto, ON, K1N7L3"}
7	admin@test.ca	$2a$10$R27QZqbIi1DktMHac5J4tOOW6shyRSOH6Y6erIipc143O4AzPvVLS	admin	1	\N	{here}
\.


--
-- TOC entry 3741 (class 0 OID 34067)
-- Dependencies: 234
-- Data for Name: hotel_audit; Type: TABLE DATA; Schema: public; Owner: ychouay
--

COPY public.hotel_audit (hotel_id, operation, changed_on) FROM stdin;
3	updated	2023-03-31 03:45:53.715747
3	deleted	2023-03-31 03:45:53.715747
3	updated	2023-03-31 03:47:07.853806
3	deleted	2023-03-31 03:47:07.853806
3	updated	2023-03-31 03:48:26.1785
3	deleted	2023-03-31 03:48:26.1785
3	updated	2023-03-31 03:49:50.766466
3	deleted	2023-03-31 03:49:50.766466
1	updated	2023-03-31 12:46:04.366774
1	deleted	2023-03-31 12:46:04.366774
1	updated	2023-03-31 12:46:26.356413
1	deleted	2023-03-31 12:46:26.356413
\.


--
-- TOC entry 3720 (class 0 OID 33851)
-- Dependencies: 213
-- Data for Name: hotels; Type: TABLE DATA; Schema: public; Owner: ychouay
--

COPY public.hotels (hotel_id, chain_id, hname, rating, email, phone_number, address, manager_id, count_rating, category) FROM stdin;
31	15	Novotel Sydney Darling Square	5	H3021@accor.com	{+61-2-8217-4000}	17 Little Pier Street, Sydney, Haymarket, 2000, Australia	\N	1	Comfortable
32	15	Pullman Paris Tour Eiffel	5	H7229-RE1@accor.com	{+33-1-4438-5600}	18 Avenue De Suffren, Paris, Paris, 75015, France	\N	1	Comfortable
33	15	Mercure London Bridge	5	H2811@accor.com	{+44-20-7902-0800}	71-79 Southwark Street, London, London, SE1 0JA, United Kingdom	\N	1	Comfortable
34	15	Pullman Barcelona Skipper	5	H7341@accor.com	{+34-93-221-6500}	10 Avenida Litoral, Barcelona, Barcelona, 08005, Spain	\N	1	Luxurious
35	15	Pullman Bali Legian Beach	5	H5261@accor.com	{+62-361-762500}	1 Melasti Beach Resort, Bali, Legian, 80361, Indonesia	\N	1	Comfortable
36	15	Novotel Bangkok Ploenchit Sukhumvit	5	H7174@accor.com	{+66-2-305-6000}	566 Ploenchit Road, Bangkok, Lumpini, 10330, Thailand	\N	1	Economic
37	15	Sofitel Sydney Wentworth	5	H3665@sofitel.com	{+61-2-9228-9188}	61-101 Phillip Street, Sydney, New South Wales, 2000, Australia	\N	1	Comfortable
38	16	Park Hyatt Tokyo	5	tokyo.park@hyatt.com	{"+81 3 5322 1234"}	3-7-1-2 Nishi Shinjuku, Tokyo, Shinjuku-Ku, Shinjuku-Ku, Japan	\N	1	Comfortable
39	16	Andaz Amsterdam Prinsengracht	5	amsterdam.prinsengracht@andaz.com	{"+31 20 523 1234"}	587 Prinsengracht, Amsterdam, 1016 HT, 1016 HT, Netherlands	\N	1	Comfortable
6	12	Hilton London Metropole	5	LONMET_INFO@HILTON.COM	{+442074024141}	225 Edgware Road, London, London, W2 1JU, United Kingdom	\N	1	Comfortable
7	12	Hilton San Francisco Union Square	5	SFOUH-SALESADM@HILTON.COM	{+14157711400}	333 O'Farrell Street, California, San Francisco, 94102, USA	\N	1	Luxurious
8	12	Hilton Tokyo	5	TYOHITW_INFO@HILTON.COM	{+81333445111}	6-6-2 Nishi-Shinjuku, Tokyo, Shinjuku-Ku, 160-0023, Japan	\N	1	Luxurious
9	12	Hilton Sydney	5	SYDHIT_INFO@HILTON.COM	{+61292662000}	488 George Street, Sydney, New South Wales, 2000, Australia	\N	1	Luxurious
10	12	Hilton Amsterdam	5	AMSHI_INFO@HILTON.COM	{+31207106000}	138 Apollolaan, Amsterdam, BG, 1077, Netherlands	\N	1	Comfortable
11	12	Hilton Buenos Aires	5	BUENAHIT_INFO@HILTON.COM	{+541148910000}	351 Av. Macacha Guemes, Buenos Aires, BA, C1106BKG, Argentina	\N	1	Economic
12	12	Hilton Mexico City Reforma	5	MEXRF_INFO@HILTON.COM	{+525551305300}	70 Av. Juarez, Mexico City, Colonia Centro, 06010, Mexico	\N	1	Economic
13	12	Hilton Garden Inn Bali Ngurah Rai Airport	5	DPSAP_INFO@HILTON.COM	{+623618976100}	0 Jalan Airport Ngurah Rai, Bali, B, 80361, Indonesia	\N	1	Comfortable
14	13	Marriott Marquis San Diego Marina	5	mhrs.sandt.guest.services@marriott.com	{+1-619-234-1500}	333 West Harbor Drive, San Diego, California, 92101, USA	\N	1	Luxurious
15	13	JW Marriott Marquis Hotel Dubai	5	jwmarriottmarquisdubai@marriott.com	{+971-4-414-0000}	00 Sheikh Zayed Road, Dubai, Business Bay, PO Box 121000, UAE	\N	1	Luxurious
16	13	Sheraton Grand Hotel & Spa, Edinburgh	5	sheratongrandedinburgh@marriott.com	{+44-131-229-9131}	1 Festival Square, Edinburgh, E, EH3 9SR, United Kingdom	\N	1	Comfortable
17	13	Courtyard by Marriott Sydney-North Ryde	5	cy.sydry.reservations@marriott.com	{+61-2-9491-9500}	7-11 Talavera Road, New South Wales, North Ryde, 2113, Australia	\N	1	Economic
18	13	Le Méridien Kuala Lumpur	5	reservations.lmkuala@lemeridien.com	{+60-3-2263-7888}	2 Jalan Stesen Sentral, Kuala Lumpur, Kuala Lumpur Sentral, 50470, Malaysia	\N	1	Comfortable
19	13	Marriott Hotel Al Forsan, Abu Dhabi	5	mhrs.auhal.ays@marriott.com	{+971-2-201-4000}	00 Al Forsan International Sports Resort, Abu Dhabi, Khalifa City, PO Box 128717, UAE	\N	1	Luxurious
20	13	AC Hotel Atocha by Marriott	5	ac.atocha@ac-hotels.com	{+34-91-330-2500}	42 Calle Delicias, Madrid, M, 28045, Spain	\N	1	Comfortable
21	13	W Bali - Seminyak	5	wbali.reservation@whotels.com	{+62-361-3000-106}	0 Jl. Petitenget, Bali, Kerobokan, 80361, Indonesia	\N	1	Economic
22	14	InterContinental New York Times Square	5	icnewyork@ihg.com	{+1-212-803-4500}	300 West 44th Street, New York, New York, 10036, USA	\N	1	Comfortable
23	14	InterContinental Sydney	5	sydney@ihg.com	{+61-2-9253-9000}	117 Macquarie Street, Sydney, New South Wales, 2000, Australia	\N	1	Comfortable
24	14	Crowne Plaza London - The City	5	londoncity@ihg.com	{+44-20-7438-8040}	19 New Bridge Street, London, London, EC4V 6DB, United Kingdom	\N	1	Economic
25	14	Kimpton Shinjuku Tokyo	5	info@kimptonshinjukutokyo.jp	{+81-3-6890-3232}	3-3-5 Nishi-Shinjuku, Tokyo, Shinjuku-ku, 160-0023, Japan	\N	1	Economic
26	14	InterContinental Paris Le Grand	5	paris@ihg.com	{+33-1-4007-3232}	2 Rue Scribe, Paris, Paris, 75009, France	\N	1	Comfortable
27	14	InterContinental Madrid	5	icmadrid@ihg.com	{+34-91-700-7300}	49 Paseo de la Castellana, Madrid, Madrid, 28046, Spain	\N	1	Comfortable
28	14	InterContinental Kuala Lumpur	5	info@intercontinental-kl.com.my	{+60-3-2782-6000}	165 Jalan Ampang, Kuala Lumpur, Kuala Lumpur, 50450, Malaysia	\N	1	Economic
29	14	Crowne Plaza Bali Kuta Beach	5	reservation@crownplazabali.com	{+62-361-209-9999}	0 Jalan Raya Kuta, Bali, Bali, 80361, Indonesia	\N	1	Comfortable
30	15	Sofitel New York	5	H1299-RE1@sofitel.com	{+1-212-782-3010}	45 West 44th Street, New York, New York, 10036, USA	\N	1	Luxurious
40	16	Grand Hyatt Singapore	5	singapore.grand@hyatt.com	{"+65 6738 1234"}	10 Scotts Road, Singapore, Scotts Road, 228211, Singapore	\N	1	Luxurious
41	16	Hyatt Regency London - The Churchill	5	churchilllondon.regency@hyatt.com	{"+44 20 7486 5800"}	30 Portman Square, London, London, W1H 7BH, United Kingdom	\N	1	Comfortable
42	16	Hyatt Regency Tokyo	5	tokyo.regency@hyatt.com	{"+81 3 3348 1234"}	2-7-2 Nishi-Shinjuku, Tokyo, Shinjuku-Ku, Shinjuku-Ku, Japan	\N	1	Comfortable
43	16	Park Hyatt Istanbul - Macka Palas	5	istanbul.mackapalas@hyatt.com	{"+90 212 315 1234"}	Tesvikiye Bronz Sokak No. 4, Istanbul, Sisli, Sisli, Turkey	\N	1	Luxurious
44	16	Hyatt Regency Sydney	5	sydney.regency@hyatt.com	{"+61 2 8099 1234"}	161 Sussex Street, Sydney, New South Wales, New South Wales, Australia	\N	1	Comfortable
45	16	Hyatt Place Waikiki Beach	5	waikikibeach.place@hyatt.com	{"+1 808 687 6100"}	175 Paoakalani Avenue, Hawaii, Honolulu, Honolulu, USA	\N	1	Luxurious
\.


--
-- TOC entry 3727 (class 0 OID 33891)
-- Dependencies: 220
-- Data for Name: person; Type: TABLE DATA; Schema: public; Owner: ychouay
--

COPY public.person (sin, fullname, email) FROM stdin;
4	testing	test@email.ca
6	test	test@test.ca
7	admin	admin@test.ca
8	John	employee@test.ca
\.


--
-- TOC entry 3739 (class 0 OID 33928)
-- Dependencies: 232
-- Data for Name: reservation; Type: TABLE DATA; Schema: public; Owner: ychouay
--

COPY public.reservation (reservation_id, chain_id, hotel_id, room_number, customer_id, status, active, rated, check_in, check_out) FROM stdin;
24	3	3	22	4	booked	t	f	2023-04-01	2023-04-08
20	3	3	33	4	rented	t	t	2023-04-01	2023-04-08
23	3	3	33	4	rented	t	t	2023-04-01	2023-04-08
25	1	1	55	4	rented	t	f	2023-04-01	2023-04-08
26	12	7	510	4	rented	t	f	2023-04-01	2023-04-08
27	14	22	715	4	booked	t	f	2023-04-22	2023-04-29
\.


--
-- TOC entry 3742 (class 0 OID 34074)
-- Dependencies: 235
-- Data for Name: reservation_audit; Type: TABLE DATA; Schema: public; Owner: ychouay
--

COPY public.reservation_audit (reservation_id, changed_on, operation) FROM stdin;
20	2023-03-30	\N
20	2023-03-30	\N
20	2023-03-30	\N
20	2023-03-30	\N
20	2023-03-30	\N
20	2023-03-30	\N
20	2023-03-30	\N
20	2023-03-30	\N
20	2023-03-30	\N
20	2023-03-30	\N
20	2023-03-30	\N
20	2023-03-30	\N
20	2023-03-30	\N
20	2023-03-30	\N
\.


--
-- TOC entry 3725 (class 0 OID 33874)
-- Dependencies: 218
-- Data for Name: rooms; Type: TABLE DATA; Schema: public; Owner: ychouay
--

COPY public.rooms (room_number, hotel_id, view, price, capacity, extendable, damaged, pictures, amenities) FROM stdin;
510	7	City View	550	3	t	f	{b0db90fb3da5cc8fd1219a81cf779b42.avif,b25b091eb668dac1352be14afe5bc69b.avif,53f3fabafb24874efa18d30192cae374.avif}	{Climatisation,Wifi,TV,Bathroom}
511	7	Mountain View	600	4	t	f	{b0db90fb3da5cc8fd1219a81cf779b42.avif,b25b091eb668dac1352be14afe5bc69b.avif,53f3fabafb24874efa18d30192cae374.avif}	{Climatisation,Wifi,TV,Bathroom}
512	7	Sea View	400	2	t	f	{b0db90fb3da5cc8fd1219a81cf779b42.avif,b25b091eb668dac1352be14afe5bc69b.avif,53f3fabafb24874efa18d30192cae374.avif}	{Climatisation,Wifi,TV,Bathroom}
513	7	City View	600	2	f	f	{b0db90fb3da5cc8fd1219a81cf779b42.avif,b25b091eb668dac1352be14afe5bc69b.avif,53f3fabafb24874efa18d30192cae374.avif}	{Climatisation,Wifi,TV,Bathroom}
1	6	City View	400	2	t	f	{705340dd29260d1ef72a99a8c4a2b516.avif,1d4208c2b42b60c9a0435a8e2e015aba.avif,e29b964657a0d101d934eae62860770c.avif}	{Climatisation,Wifi,TV,Bathroom,Parking}
2	6	City View	500	3	t	f	{adcab08f544559b1259ef846c2225869.avif,4deebcf92a997d344118ca915431e599.avif,0f2c2c78a9d6b6e06e9aca5462789232.avif,03e1192fbf8a68df3b46c81bfbb0aaed.avif}	{Climatisation,Wifi,Balcony,TV,Bathroom,Parking}
3	6	City View	600	4	f	f	{05ba5876f3bcf5ddfa029e90b9e76278.avif,59e7e99423a691c805c51aed96245715.avif,9dc7b6f9bab9682c999f24cd02f7f115.avif}	{Climatisation,Wifi,TV,Bathroom}
4	6	City View	550	3	t	f	{abfcff85e8baffb87b022ce4ed0d459d.avif,018464a825c142c4f5b3e078003adc3a.avif,5c7037da42609f0def2d2bfea8434527.avif,0fee9f552c5a875daee50b899cc5580f.avif}	{Climatisation,Balcony,Wifi,TV,Bathroom}
5	6	City View	350	1	t	f	{342ff6908d278dbc99574162e10d1a5c.avif,0259b2803d7825396d7f8168610120de.avif,64e4933ef854c6e1e114d822b32332f0.avif}	{Climatisation,Wifi,TV,Bathroom,Parking}
20	7	Sea View	600	6	f	f	{b0db90fb3da5cc8fd1219a81cf779b42.avif,b25b091eb668dac1352be14afe5bc69b.avif,53f3fabafb24874efa18d30192cae374.avif}	{Climatisation,Balcony,Wifi,TV,Bathroom,Parking}
45	8	City View	900	5	t	f	{fa7e5682d6b9dcf33006601677b59773.avif,abfba63ea0b01574ebe35e6eaede7417.avif,47ca0ecc8db5f8e26e51e9bd6f82a40e.avif,e0ec5675f3ccab83c056f84006e05a57.avif}	{Balcony,Climatisation,Wifi,TV,Bathroom}
68	9	Mountain View	450	3	f	f	{16a66c12fd90da1f49642da118ac0a53.jpg,616bbcf6c3f04ab437e14c93dad6621a.jpg,851257b19a37bdccdaec73b62e8d373a.jpg}	{Climatisation,Wifi,TV,Bathroom}
55	10	Sea View	560	3	t	f	{9e035a4a6a4ad55d99f77a3be7c6c614.avif,cb82342cd0b7b77144bec5701da436ae.avif,6c561313f2e5032c93af616ce4dbd303.avif}	{Climatisation,Wifi,TV,Bathroom}
98	11	City View	500	4	t	f	{f79cb04a7ff9c2a5f97e9d3548f55aaf.avif,63d249a9631abc3940a5cc1a91960a5d.avif,63743426663605ffe8f0aa24007fd2bf.avif}	{Climatisation,Balcony,Wifi,Bathroom}
32	12	Sea View	580	3	f	f	{1ba68d4d81b95e04fd5f6d32f4ae846d.avif,0697b6bd72a5cbf286a6a1d641a439fe.avif,1461a592cadb534422e4549887ab0f7e.avif}	{Climatisation,Wifi,TV,Bathroom}
65	13	Sea View	750	4	t	f	{04d806bdfa47f006f8770d357a67ddb7.avif,70434c22eea12ca611487a4f038c9c4f.avif,317ba210146ef95dcb6a86cf4ba303f6.avif}	{Climatisation,Wifi,TV,Bathroom}
33	7	Sea View	600	6	f	f	{b0db90fb3da5cc8fd1219a81cf779b42.avif,b25b091eb668dac1352be14afe5bc69b.avif,53f3fabafb24874efa18d30192cae374.avif}	{Climatisation,Wifi,TV,Bathroom}
514	12	Mountain View	600	2	f	t	{1ba68d4d81b95e04fd5f6d32f4ae846d.avif,0697b6bd72a5cbf286a6a1d641a439fe.avif,1461a592cadb534422e4549887ab0f7e.avif}	{Climatisation,Wifi,TV,Bathroom}
515	12	Sea View	560	3	f	t	{1ba68d4d81b95e04fd5f6d32f4ae846d.avif,0697b6bd72a5cbf286a6a1d641a439fe.avif,1461a592cadb534422e4549887ab0f7e.avif}	{Climatisation,Wifi,TV,Bathroom}
516	12	City View	600	3	f	t	{1ba68d4d81b95e04fd5f6d32f4ae846d.avif,0697b6bd72a5cbf286a6a1d641a439fe.avif,1461a592cadb534422e4549887ab0f7e.avif}	{Climatisation,Wifi,TV,Bathroom}
517	12	Mountain View	540	4	f	t	{1ba68d4d81b95e04fd5f6d32f4ae846d.avif,0697b6bd72a5cbf286a6a1d641a439fe.avif,1461a592cadb534422e4549887ab0f7e.avif}	{Climatisation,Wifi,TV,Bathroom}
518	12	Sea View	600	2	f	t	{1ba68d4d81b95e04fd5f6d32f4ae846d.avif,0697b6bd72a5cbf286a6a1d641a439fe.avif,1461a592cadb534422e4549887ab0f7e.avif}	{Climatisation,Wifi,TV,Bathroom}
519	8	City View	600	2	f	t	{fa7e5682d6b9dcf33006601677b59773.avif,abfba63ea0b01574ebe35e6eaede7417.avif,47ca0ecc8db5f8e26e51e9bd6f82a40e.avif,e0ec5675f3ccab83c056f84006e05a57.avif}	{Climatisation,Wifi,TV,Bathroom}
520	8	Mountain View	560	3	f	t	{fa7e5682d6b9dcf33006601677b59773.avif,abfba63ea0b01574ebe35e6eaede7417.avif,47ca0ecc8db5f8e26e51e9bd6f82a40e.avif,e0ec5675f3ccab83c056f84006e05a57.avif}	{Climatisation,Wifi,TV,Bathroom}
521	8	Sea View	600	3	f	t	{fa7e5682d6b9dcf33006601677b59773.avif,abfba63ea0b01574ebe35e6eaede7417.avif,47ca0ecc8db5f8e26e51e9bd6f82a40e.avif,e0ec5675f3ccab83c056f84006e05a57.avif}	{Climatisation,Wifi,TV,Bathroom}
522	8	City View	540	4	f	t	{fa7e5682d6b9dcf33006601677b59773.avif,abfba63ea0b01574ebe35e6eaede7417.avif,47ca0ecc8db5f8e26e51e9bd6f82a40e.avif,e0ec5675f3ccab83c056f84006e05a57.avif}	{Climatisation,Wifi,TV,Bathroom}
523	8	Mountain View	600	2	f	t	{fa7e5682d6b9dcf33006601677b59773.avif,abfba63ea0b01574ebe35e6eaede7417.avif,47ca0ecc8db5f8e26e51e9bd6f82a40e.avif,e0ec5675f3ccab83c056f84006e05a57.avif}	{Climatisation,Wifi,TV,Bathroom}
524	10	Sea View	600	2	f	t	{9e035a4a6a4ad55d99f77a3be7c6c614.avif,cb82342cd0b7b77144bec5701da436ae.avif,6c561313f2e5032c93af616ce4dbd303.avif}	{Climatisation,Wifi,TV,Bathroom}
525	10	City View	560	3	f	t	{9e035a4a6a4ad55d99f77a3be7c6c614.avif,cb82342cd0b7b77144bec5701da436ae.avif,6c561313f2e5032c93af616ce4dbd303.avif}	{Climatisation,Wifi,TV,Bathroom}
526	10	Mountain View	600	3	f	t	{9e035a4a6a4ad55d99f77a3be7c6c614.avif,cb82342cd0b7b77144bec5701da436ae.avif,6c561313f2e5032c93af616ce4dbd303.avif}	{Climatisation,Wifi,TV,Bathroom}
527	10	Sea View	540	4	f	t	{9e035a4a6a4ad55d99f77a3be7c6c614.avif,cb82342cd0b7b77144bec5701da436ae.avif,6c561313f2e5032c93af616ce4dbd303.avif}	{Climatisation,Wifi,TV,Bathroom}
528	10	City View	600	2	f	t	{9e035a4a6a4ad55d99f77a3be7c6c614.avif,cb82342cd0b7b77144bec5701da436ae.avif,6c561313f2e5032c93af616ce4dbd303.avif}	{Climatisation,Wifi,TV,Bathroom}
529	13	Mountain View	600	2	f	t	{04d806bdfa47f006f8770d357a67ddb7.avif,70434c22eea12ca611487a4f038c9c4f.avif,317ba210146ef95dcb6a86cf4ba303f6.avif}	{Climatisation,Wifi,TV,Bathroom}
530	13	Sea View	560	3	f	t	{04d806bdfa47f006f8770d357a67ddb7.avif,70434c22eea12ca611487a4f038c9c4f.avif,317ba210146ef95dcb6a86cf4ba303f6.avif}	{Climatisation,Wifi,TV,Bathroom}
531	13	City View	600	3	f	t	{04d806bdfa47f006f8770d357a67ddb7.avif,70434c22eea12ca611487a4f038c9c4f.avif,317ba210146ef95dcb6a86cf4ba303f6.avif}	{Climatisation,Wifi,TV,Bathroom}
532	13	Mountain View	540	4	f	t	{04d806bdfa47f006f8770d357a67ddb7.avif,70434c22eea12ca611487a4f038c9c4f.avif,317ba210146ef95dcb6a86cf4ba303f6.avif}	{Climatisation,Wifi,TV,Bathroom}
533	13	Sea View	600	2	f	t	{04d806bdfa47f006f8770d357a67ddb7.avif,70434c22eea12ca611487a4f038c9c4f.avif,317ba210146ef95dcb6a86cf4ba303f6.avif}	{Climatisation,Wifi,TV,Bathroom}
534	9	City View	600	2	f	t	{16a66c12fd90da1f49642da118ac0a53.jpg,616bbcf6c3f04ab437e14c93dad6621a.jpg,851257b19a37bdccdaec73b62e8d373a.jpg}	{Climatisation,Wifi,TV,Bathroom}
535	9	Mountain View	560	3	f	t	{16a66c12fd90da1f49642da118ac0a53.jpg,616bbcf6c3f04ab437e14c93dad6621a.jpg,851257b19a37bdccdaec73b62e8d373a.jpg}	{Climatisation,Wifi,TV,Bathroom}
536	9	Sea View	600	3	f	t	{16a66c12fd90da1f49642da118ac0a53.jpg,616bbcf6c3f04ab437e14c93dad6621a.jpg,851257b19a37bdccdaec73b62e8d373a.jpg}	{Climatisation,Wifi,TV,Bathroom}
537	9	City View	540	4	f	t	{16a66c12fd90da1f49642da118ac0a53.jpg,616bbcf6c3f04ab437e14c93dad6621a.jpg,851257b19a37bdccdaec73b62e8d373a.jpg}	{Climatisation,Wifi,TV,Bathroom}
538	9	Mountain View	600	2	f	t	{16a66c12fd90da1f49642da118ac0a53.jpg,616bbcf6c3f04ab437e14c93dad6621a.jpg,851257b19a37bdccdaec73b62e8d373a.jpg}	{Climatisation,Wifi,TV,Bathroom}
539	11	Sea View	600	2	f	t	{f79cb04a7ff9c2a5f97e9d3548f55aaf.avif,63d249a9631abc3940a5cc1a91960a5d.avif,63743426663605ffe8f0aa24007fd2bf.avif}	{Climatisation,Wifi,TV,Bathroom}
540	11	City View	560	3	f	t	{f79cb04a7ff9c2a5f97e9d3548f55aaf.avif,63d249a9631abc3940a5cc1a91960a5d.avif,63743426663605ffe8f0aa24007fd2bf.avif}	{Climatisation,Wifi,TV,Bathroom}
541	11	Mountain View	600	3	f	t	{f79cb04a7ff9c2a5f97e9d3548f55aaf.avif,63d249a9631abc3940a5cc1a91960a5d.avif,63743426663605ffe8f0aa24007fd2bf.avif}	{Climatisation,Wifi,TV,Bathroom}
542	11	Sea View	540	4	f	t	{f79cb04a7ff9c2a5f97e9d3548f55aaf.avif,63d249a9631abc3940a5cc1a91960a5d.avif,63743426663605ffe8f0aa24007fd2bf.avif}	{Climatisation,Wifi,TV,Bathroom}
543	11	City View	600	2	f	t	{f79cb04a7ff9c2a5f97e9d3548f55aaf.avif,63d249a9631abc3940a5cc1a91960a5d.avif,63743426663605ffe8f0aa24007fd2bf.avif}	{Climatisation,Wifi,TV,Bathroom}
609	14	City View	550	3	t	f	{b0db90fb3da5cc8fd1219a81cf779b42.avif,b25b091eb668dac1352be14afe5bc69b.avif,53f3fabafb24874efa18d30192cae374.avif}	{Climatisation,Wifi,TV,Bathroom}
610	14	City View	550	3	t	f	{b0db90fb3da5cc8fd1219a81cf779b42.avif,b25b091eb668dac1352be14afe5bc69b.avif,53f3fabafb24874efa18d30192cae374.avif}	{Climatisation,Wifi,TV,Bathroom}
611	14	Mountain View	600	4	t	f	{b0db90fb3da5cc8fd1219a81cf779b42.avif,b25b091eb668dac1352be14afe5bc69b.avif,53f3fabafb24874efa18d30192cae374.avif}	{Climatisation,Wifi,TV,Bathroom}
612	14	Sea View	400	2	t	f	{b0db90fb3da5cc8fd1219a81cf779b42.avif,b25b091eb668dac1352be14afe5bc69b.avif,53f3fabafb24874efa18d30192cae374.avif}	{Climatisation,Wifi,TV,Bathroom}
613	14	City View	600	2	f	f	{b0db90fb3da5cc8fd1219a81cf779b42.avif,b25b091eb668dac1352be14afe5bc69b.avif,53f3fabafb24874efa18d30192cae374.avif}	{Climatisation,Wifi,TV,Bathroom}
614	15	Mountain View	600	2	f	t	{1ba68d4d81b95e04fd5f6d32f4ae846d.avif,0697b6bd72a5cbf286a6a1d641a439fe.avif,1461a592cadb534422e4549887ab0f7e.avif}	{Climatisation,Wifi,TV,Bathroom}
615	15	Sea View	560	3	f	t	{1ba68d4d81b95e04fd5f6d32f4ae846d.avif,0697b6bd72a5cbf286a6a1d641a439fe.avif,1461a592cadb534422e4549887ab0f7e.avif}	{Climatisation,Wifi,TV,Bathroom}
616	15	City View	600	3	f	t	{1ba68d4d81b95e04fd5f6d32f4ae846d.avif,0697b6bd72a5cbf286a6a1d641a439fe.avif,1461a592cadb534422e4549887ab0f7e.avif}	{Climatisation,Wifi,TV,Bathroom}
617	15	Mountain View	540	4	f	t	{1ba68d4d81b95e04fd5f6d32f4ae846d.avif,0697b6bd72a5cbf286a6a1d641a439fe.avif,1461a592cadb534422e4549887ab0f7e.avif}	{Climatisation,Wifi,TV,Bathroom}
618	15	Sea View	600	2	f	t	{1ba68d4d81b95e04fd5f6d32f4ae846d.avif,0697b6bd72a5cbf286a6a1d641a439fe.avif,1461a592cadb534422e4549887ab0f7e.avif}	{Climatisation,Wifi,TV,Bathroom}
619	16	City View	600	2	f	t	{fa7e5682d6b9dcf33006601677b59773.avif,abfba63ea0b01574ebe35e6eaede7417.avif,47ca0ecc8db5f8e26e51e9bd6f82a40e.avif,e0ec5675f3ccab83c056f84006e05a57.avif}	{Climatisation,Wifi,TV,Bathroom}
620	16	Mountain View	560	3	f	t	{fa7e5682d6b9dcf33006601677b59773.avif,abfba63ea0b01574ebe35e6eaede7417.avif,47ca0ecc8db5f8e26e51e9bd6f82a40e.avif,e0ec5675f3ccab83c056f84006e05a57.avif}	{Climatisation,Wifi,TV,Bathroom}
621	16	Sea View	600	3	f	t	{fa7e5682d6b9dcf33006601677b59773.avif,abfba63ea0b01574ebe35e6eaede7417.avif,47ca0ecc8db5f8e26e51e9bd6f82a40e.avif,e0ec5675f3ccab83c056f84006e05a57.avif}	{Climatisation,Wifi,TV,Bathroom}
622	16	City View	540	4	f	t	{fa7e5682d6b9dcf33006601677b59773.avif,abfba63ea0b01574ebe35e6eaede7417.avif,47ca0ecc8db5f8e26e51e9bd6f82a40e.avif,e0ec5675f3ccab83c056f84006e05a57.avif}	{Climatisation,Wifi,TV,Bathroom}
623	16	Mountain View	600	2	f	t	{fa7e5682d6b9dcf33006601677b59773.avif,abfba63ea0b01574ebe35e6eaede7417.avif,47ca0ecc8db5f8e26e51e9bd6f82a40e.avif,e0ec5675f3ccab83c056f84006e05a57.avif}	{Climatisation,Wifi,TV,Bathroom}
624	17	Sea View	600	2	f	t	{9e035a4a6a4ad55d99f77a3be7c6c614.avif,cb82342cd0b7b77144bec5701da436ae.avif,6c561313f2e5032c93af616ce4dbd303.avif}	{Climatisation,Wifi,TV,Bathroom}
625	17	City View	560	3	f	t	{9e035a4a6a4ad55d99f77a3be7c6c614.avif,cb82342cd0b7b77144bec5701da436ae.avif,6c561313f2e5032c93af616ce4dbd303.avif}	{Climatisation,Wifi,TV,Bathroom}
626	17	Mountain View	600	3	f	t	{9e035a4a6a4ad55d99f77a3be7c6c614.avif,cb82342cd0b7b77144bec5701da436ae.avif,6c561313f2e5032c93af616ce4dbd303.avif}	{Climatisation,Wifi,TV,Bathroom}
627	17	Sea View	540	4	f	t	{9e035a4a6a4ad55d99f77a3be7c6c614.avif,cb82342cd0b7b77144bec5701da436ae.avif,6c561313f2e5032c93af616ce4dbd303.avif}	{Climatisation,Wifi,TV,Bathroom}
628	17	City View	600	2	f	t	{9e035a4a6a4ad55d99f77a3be7c6c614.avif,cb82342cd0b7b77144bec5701da436ae.avif,6c561313f2e5032c93af616ce4dbd303.avif}	{Climatisation,Wifi,TV,Bathroom}
629	18	Mountain View	600	2	f	t	{04d806bdfa47f006f8770d357a67ddb7.avif,70434c22eea12ca611487a4f038c9c4f.avif,317ba210146ef95dcb6a86cf4ba303f6.avif}	{Climatisation,Wifi,TV,Bathroom}
630	18	Sea View	560	3	f	t	{04d806bdfa47f006f8770d357a67ddb7.avif,70434c22eea12ca611487a4f038c9c4f.avif,317ba210146ef95dcb6a86cf4ba303f6.avif}	{Climatisation,Wifi,TV,Bathroom}
631	18	City View	600	3	f	t	{04d806bdfa47f006f8770d357a67ddb7.avif,70434c22eea12ca611487a4f038c9c4f.avif,317ba210146ef95dcb6a86cf4ba303f6.avif}	{Climatisation,Wifi,TV,Bathroom}
632	18	Mountain View	540	4	f	t	{04d806bdfa47f006f8770d357a67ddb7.avif,70434c22eea12ca611487a4f038c9c4f.avif,317ba210146ef95dcb6a86cf4ba303f6.avif}	{Climatisation,Wifi,TV,Bathroom}
633	18	Sea View	600	2	f	t	{04d806bdfa47f006f8770d357a67ddb7.avif,70434c22eea12ca611487a4f038c9c4f.avif,317ba210146ef95dcb6a86cf4ba303f6.avif}	{Climatisation,Wifi,TV,Bathroom}
634	19	City View	600	2	f	t	{16a66c12fd90da1f49642da118ac0a53.jpg,616bbcf6c3f04ab437e14c93dad6621a.jpg,851257b19a37bdccdaec73b62e8d373a.jpg}	{Climatisation,Wifi,TV,Bathroom}
635	19	Mountain View	560	3	f	t	{16a66c12fd90da1f49642da118ac0a53.jpg,616bbcf6c3f04ab437e14c93dad6621a.jpg,851257b19a37bdccdaec73b62e8d373a.jpg}	{Climatisation,Wifi,TV,Bathroom}
636	19	Sea View	600	3	f	t	{16a66c12fd90da1f49642da118ac0a53.jpg,616bbcf6c3f04ab437e14c93dad6621a.jpg,851257b19a37bdccdaec73b62e8d373a.jpg}	{Climatisation,Wifi,TV,Bathroom}
637	19	City View	540	4	f	t	{16a66c12fd90da1f49642da118ac0a53.jpg,616bbcf6c3f04ab437e14c93dad6621a.jpg,851257b19a37bdccdaec73b62e8d373a.jpg}	{Climatisation,Wifi,TV,Bathroom}
638	19	Mountain View	600	2	f	t	{16a66c12fd90da1f49642da118ac0a53.jpg,616bbcf6c3f04ab437e14c93dad6621a.jpg,851257b19a37bdccdaec73b62e8d373a.jpg}	{Climatisation,Wifi,TV,Bathroom}
639	20	Sea View	600	2	f	t	{f79cb04a7ff9c2a5f97e9d3548f55aaf.avif,63d249a9631abc3940a5cc1a91960a5d.avif,63743426663605ffe8f0aa24007fd2bf.avif}	{Climatisation,Wifi,TV,Bathroom}
640	20	City View	560	3	f	t	{f79cb04a7ff9c2a5f97e9d3548f55aaf.avif,63d249a9631abc3940a5cc1a91960a5d.avif,63743426663605ffe8f0aa24007fd2bf.avif}	{Climatisation,Wifi,TV,Bathroom}
641	20	Mountain View	600	3	f	t	{f79cb04a7ff9c2a5f97e9d3548f55aaf.avif,63d249a9631abc3940a5cc1a91960a5d.avif,63743426663605ffe8f0aa24007fd2bf.avif}	{Climatisation,Wifi,TV,Bathroom}
642	20	Sea View	540	4	f	t	{f79cb04a7ff9c2a5f97e9d3548f55aaf.avif,63d249a9631abc3940a5cc1a91960a5d.avif,63743426663605ffe8f0aa24007fd2bf.avif}	{Climatisation,Wifi,TV,Bathroom}
643	20	City View	600	2	f	t	{f79cb04a7ff9c2a5f97e9d3548f55aaf.avif,63d249a9631abc3940a5cc1a91960a5d.avif,63743426663605ffe8f0aa24007fd2bf.avif}	{Climatisation,Wifi,TV,Bathroom}
709	21	City View	550	3	t	f	{b0db90fb3da5cc8fd1219a81cf779b42.avif,b25b091eb668dac1352be14afe5bc69b.avif,53f3fabafb24874efa18d30192cae374.avif}	{Climatisation,Wifi,TV,Bathroom}
710	21	City View	550	3	t	f	{b0db90fb3da5cc8fd1219a81cf779b42.avif,b25b091eb668dac1352be14afe5bc69b.avif,53f3fabafb24874efa18d30192cae374.avif}	{Climatisation,Wifi,TV,Bathroom}
711	21	Mountain View	600	4	t	f	{b0db90fb3da5cc8fd1219a81cf779b42.avif,b25b091eb668dac1352be14afe5bc69b.avif,53f3fabafb24874efa18d30192cae374.avif}	{Climatisation,Wifi,TV,Bathroom}
712	21	Sea View	400	2	t	f	{b0db90fb3da5cc8fd1219a81cf779b42.avif,b25b091eb668dac1352be14afe5bc69b.avif,53f3fabafb24874efa18d30192cae374.avif}	{Climatisation,Wifi,TV,Bathroom}
713	21	City View	600	2	f	f	{b0db90fb3da5cc8fd1219a81cf779b42.avif,b25b091eb668dac1352be14afe5bc69b.avif,53f3fabafb24874efa18d30192cae374.avif}	{Climatisation,Wifi,TV,Bathroom}
714	22	Mountain View	600	2	f	t	{1ba68d4d81b95e04fd5f6d32f4ae846d.avif,0697b6bd72a5cbf286a6a1d641a439fe.avif,1461a592cadb534422e4549887ab0f7e.avif}	{Climatisation,Wifi,TV,Bathroom}
715	22	Sea View	560	3	f	t	{1ba68d4d81b95e04fd5f6d32f4ae846d.avif,0697b6bd72a5cbf286a6a1d641a439fe.avif,1461a592cadb534422e4549887ab0f7e.avif}	{Climatisation,Wifi,TV,Bathroom}
716	22	City View	600	3	f	t	{1ba68d4d81b95e04fd5f6d32f4ae846d.avif,0697b6bd72a5cbf286a6a1d641a439fe.avif,1461a592cadb534422e4549887ab0f7e.avif}	{Climatisation,Wifi,TV,Bathroom}
717	22	Mountain View	540	4	f	t	{1ba68d4d81b95e04fd5f6d32f4ae846d.avif,0697b6bd72a5cbf286a6a1d641a439fe.avif,1461a592cadb534422e4549887ab0f7e.avif}	{Climatisation,Wifi,TV,Bathroom}
718	22	Sea View	600	2	f	t	{1ba68d4d81b95e04fd5f6d32f4ae846d.avif,0697b6bd72a5cbf286a6a1d641a439fe.avif,1461a592cadb534422e4549887ab0f7e.avif}	{Climatisation,Wifi,TV,Bathroom}
719	22	City View	600	2	f	t	{fa7e5682d6b9dcf33006601677b59773.avif,abfba63ea0b01574ebe35e6eaede7417.avif,47ca0ecc8db5f8e26e51e9bd6f82a40e.avif,e0ec5675f3ccab83c056f84006e05a57.avif}	{Climatisation,Wifi,TV,Bathroom}
720	22	Mountain View	560	3	f	t	{fa7e5682d6b9dcf33006601677b59773.avif,abfba63ea0b01574ebe35e6eaede7417.avif,47ca0ecc8db5f8e26e51e9bd6f82a40e.avif,e0ec5675f3ccab83c056f84006e05a57.avif}	{Climatisation,Wifi,TV,Bathroom}
721	22	Sea View	600	3	f	t	{fa7e5682d6b9dcf33006601677b59773.avif,abfba63ea0b01574ebe35e6eaede7417.avif,47ca0ecc8db5f8e26e51e9bd6f82a40e.avif,e0ec5675f3ccab83c056f84006e05a57.avif}	{Climatisation,Wifi,TV,Bathroom}
722	22	City View	540	4	f	t	{fa7e5682d6b9dcf33006601677b59773.avif,abfba63ea0b01574ebe35e6eaede7417.avif,47ca0ecc8db5f8e26e51e9bd6f82a40e.avif,e0ec5675f3ccab83c056f84006e05a57.avif}	{Climatisation,Wifi,TV,Bathroom}
723	22	Mountain View	600	2	f	t	{fa7e5682d6b9dcf33006601677b59773.avif,abfba63ea0b01574ebe35e6eaede7417.avif,47ca0ecc8db5f8e26e51e9bd6f82a40e.avif,e0ec5675f3ccab83c056f84006e05a57.avif}	{Climatisation,Wifi,TV,Bathroom}
724	23	Sea View	600	2	f	t	{9e035a4a6a4ad55d99f77a3be7c6c614.avif,cb82342cd0b7b77144bec5701da436ae.avif,6c561313f2e5032c93af616ce4dbd303.avif}	{Climatisation,Wifi,TV,Bathroom}
725	23	City View	560	3	f	t	{9e035a4a6a4ad55d99f77a3be7c6c614.avif,cb82342cd0b7b77144bec5701da436ae.avif,6c561313f2e5032c93af616ce4dbd303.avif}	{Climatisation,Wifi,TV,Bathroom}
726	23	Mountain View	600	3	f	t	{9e035a4a6a4ad55d99f77a3be7c6c614.avif,cb82342cd0b7b77144bec5701da436ae.avif,6c561313f2e5032c93af616ce4dbd303.avif}	{Climatisation,Wifi,TV,Bathroom}
727	23	Sea View	540	4	f	t	{9e035a4a6a4ad55d99f77a3be7c6c614.avif,cb82342cd0b7b77144bec5701da436ae.avif,6c561313f2e5032c93af616ce4dbd303.avif}	{Climatisation,Wifi,TV,Bathroom}
728	23	City View	600	2	f	t	{9e035a4a6a4ad55d99f77a3be7c6c614.avif,cb82342cd0b7b77144bec5701da436ae.avif,6c561313f2e5032c93af616ce4dbd303.avif}	{Climatisation,Wifi,TV,Bathroom}
729	24	Mountain View	600	2	f	t	{04d806bdfa47f006f8770d357a67ddb7.avif,70434c22eea12ca611487a4f038c9c4f.avif,317ba210146ef95dcb6a86cf4ba303f6.avif}	{Climatisation,Wifi,TV,Bathroom}
730	24	Sea View	560	3	f	t	{04d806bdfa47f006f8770d357a67ddb7.avif,70434c22eea12ca611487a4f038c9c4f.avif,317ba210146ef95dcb6a86cf4ba303f6.avif}	{Climatisation,Wifi,TV,Bathroom}
731	24	City View	600	3	f	t	{04d806bdfa47f006f8770d357a67ddb7.avif,70434c22eea12ca611487a4f038c9c4f.avif,317ba210146ef95dcb6a86cf4ba303f6.avif}	{Climatisation,Wifi,TV,Bathroom}
732	24	Mountain View	540	4	f	t	{04d806bdfa47f006f8770d357a67ddb7.avif,70434c22eea12ca611487a4f038c9c4f.avif,317ba210146ef95dcb6a86cf4ba303f6.avif}	{Climatisation,Wifi,TV,Bathroom}
733	24	Sea View	600	2	f	t	{04d806bdfa47f006f8770d357a67ddb7.avif,70434c22eea12ca611487a4f038c9c4f.avif,317ba210146ef95dcb6a86cf4ba303f6.avif}	{Climatisation,Wifi,TV,Bathroom}
734	25	City View	600	2	f	t	{16a66c12fd90da1f49642da118ac0a53.jpg,616bbcf6c3f04ab437e14c93dad6621a.jpg,851257b19a37bdccdaec73b62e8d373a.jpg}	{Climatisation,Wifi,TV,Bathroom}
735	25	Mountain View	560	3	f	t	{16a66c12fd90da1f49642da118ac0a53.jpg,616bbcf6c3f04ab437e14c93dad6621a.jpg,851257b19a37bdccdaec73b62e8d373a.jpg}	{Climatisation,Wifi,TV,Bathroom}
736	25	Sea View	600	3	f	t	{16a66c12fd90da1f49642da118ac0a53.jpg,616bbcf6c3f04ab437e14c93dad6621a.jpg,851257b19a37bdccdaec73b62e8d373a.jpg}	{Climatisation,Wifi,TV,Bathroom}
737	25	City View	540	4	f	t	{16a66c12fd90da1f49642da118ac0a53.jpg,616bbcf6c3f04ab437e14c93dad6621a.jpg,851257b19a37bdccdaec73b62e8d373a.jpg}	{Climatisation,Wifi,TV,Bathroom}
738	25	Mountain View	600	2	f	t	{16a66c12fd90da1f49642da118ac0a53.jpg,616bbcf6c3f04ab437e14c93dad6621a.jpg,851257b19a37bdccdaec73b62e8d373a.jpg}	{Climatisation,Wifi,TV,Bathroom}
739	26	Sea View	600	2	f	t	{f79cb04a7ff9c2a5f97e9d3548f55aaf.avif,63d249a9631abc3940a5cc1a91960a5d.avif,63743426663605ffe8f0aa24007fd2bf.avif}	{Climatisation,Wifi,TV,Bathroom}
740	26	City View	560	3	f	t	{f79cb04a7ff9c2a5f97e9d3548f55aaf.avif,63d249a9631abc3940a5cc1a91960a5d.avif,63743426663605ffe8f0aa24007fd2bf.avif}	{Climatisation,Wifi,TV,Bathroom}
741	26	Mountain View	600	3	f	t	{f79cb04a7ff9c2a5f97e9d3548f55aaf.avif,63d249a9631abc3940a5cc1a91960a5d.avif,63743426663605ffe8f0aa24007fd2bf.avif}	{Climatisation,Wifi,TV,Bathroom}
742	26	Sea View	540	4	f	t	{f79cb04a7ff9c2a5f97e9d3548f55aaf.avif,63d249a9631abc3940a5cc1a91960a5d.avif,63743426663605ffe8f0aa24007fd2bf.avif}	{Climatisation,Wifi,TV,Bathroom}
743	26	City View	600	2	f	t	{f79cb04a7ff9c2a5f97e9d3548f55aaf.avif,63d249a9631abc3940a5cc1a91960a5d.avif,63743426663605ffe8f0aa24007fd2bf.avif}	{Climatisation,Wifi,TV,Bathroom}
809	27	City View	550	3	t	f	{b0db90fb3da5cc8fd1219a81cf779b42.avif,b25b091eb668dac1352be14afe5bc69b.avif,53f3fabafb24874efa18d30192cae374.avif}	{Climatisation,Wifi,TV,Bathroom}
810	27	City View	550	3	t	f	{b0db90fb3da5cc8fd1219a81cf779b42.avif,b25b091eb668dac1352be14afe5bc69b.avif,53f3fabafb24874efa18d30192cae374.avif}	{Climatisation,Wifi,TV,Bathroom}
811	27	Mountain View	600	4	t	f	{b0db90fb3da5cc8fd1219a81cf779b42.avif,b25b091eb668dac1352be14afe5bc69b.avif,53f3fabafb24874efa18d30192cae374.avif}	{Climatisation,Wifi,TV,Bathroom}
812	27	Sea View	400	2	t	f	{b0db90fb3da5cc8fd1219a81cf779b42.avif,b25b091eb668dac1352be14afe5bc69b.avif,53f3fabafb24874efa18d30192cae374.avif}	{Climatisation,Wifi,TV,Bathroom}
813	27	City View	600	2	f	f	{b0db90fb3da5cc8fd1219a81cf779b42.avif,b25b091eb668dac1352be14afe5bc69b.avif,53f3fabafb24874efa18d30192cae374.avif}	{Climatisation,Wifi,TV,Bathroom}
814	28	Mountain View	600	2	f	t	{1ba68d4d81b95e04fd5f6d32f4ae846d.avif,0697b6bd72a5cbf286a6a1d641a439fe.avif,1461a592cadb534422e4549887ab0f7e.avif}	{Climatisation,Wifi,TV,Bathroom}
815	28	Sea View	560	3	f	t	{1ba68d4d81b95e04fd5f6d32f4ae846d.avif,0697b6bd72a5cbf286a6a1d641a439fe.avif,1461a592cadb534422e4549887ab0f7e.avif}	{Climatisation,Wifi,TV,Bathroom}
816	28	City View	600	3	f	t	{1ba68d4d81b95e04fd5f6d32f4ae846d.avif,0697b6bd72a5cbf286a6a1d641a439fe.avif,1461a592cadb534422e4549887ab0f7e.avif}	{Climatisation,Wifi,TV,Bathroom}
817	28	Mountain View	540	4	f	t	{1ba68d4d81b95e04fd5f6d32f4ae846d.avif,0697b6bd72a5cbf286a6a1d641a439fe.avif,1461a592cadb534422e4549887ab0f7e.avif}	{Climatisation,Wifi,TV,Bathroom}
818	28	Sea View	600	2	f	t	{1ba68d4d81b95e04fd5f6d32f4ae846d.avif,0697b6bd72a5cbf286a6a1d641a439fe.avif,1461a592cadb534422e4549887ab0f7e.avif}	{Climatisation,Wifi,TV,Bathroom}
819	28	City View	600	2	f	t	{fa7e5682d6b9dcf33006601677b59773.avif,abfba63ea0b01574ebe35e6eaede7417.avif,47ca0ecc8db5f8e26e51e9bd6f82a40e.avif,e0ec5675f3ccab83c056f84006e05a57.avif}	{Climatisation,Wifi,TV,Bathroom}
820	28	Mountain View	560	3	f	t	{fa7e5682d6b9dcf33006601677b59773.avif,abfba63ea0b01574ebe35e6eaede7417.avif,47ca0ecc8db5f8e26e51e9bd6f82a40e.avif,e0ec5675f3ccab83c056f84006e05a57.avif}	{Climatisation,Wifi,TV,Bathroom}
821	28	Sea View	600	3	f	t	{fa7e5682d6b9dcf33006601677b59773.avif,abfba63ea0b01574ebe35e6eaede7417.avif,47ca0ecc8db5f8e26e51e9bd6f82a40e.avif,e0ec5675f3ccab83c056f84006e05a57.avif}	{Climatisation,Wifi,TV,Bathroom}
822	28	City View	540	4	f	t	{fa7e5682d6b9dcf33006601677b59773.avif,abfba63ea0b01574ebe35e6eaede7417.avif,47ca0ecc8db5f8e26e51e9bd6f82a40e.avif,e0ec5675f3ccab83c056f84006e05a57.avif}	{Climatisation,Wifi,TV,Bathroom}
823	28	Mountain View	600	2	f	t	{fa7e5682d6b9dcf33006601677b59773.avif,abfba63ea0b01574ebe35e6eaede7417.avif,47ca0ecc8db5f8e26e51e9bd6f82a40e.avif,e0ec5675f3ccab83c056f84006e05a57.avif}	{Climatisation,Wifi,TV,Bathroom}
824	29	Sea View	600	2	f	t	{9e035a4a6a4ad55d99f77a3be7c6c614.avif,cb82342cd0b7b77144bec5701da436ae.avif,6c561313f2e5032c93af616ce4dbd303.avif}	{Climatisation,Wifi,TV,Bathroom}
825	29	City View	560	3	f	t	{9e035a4a6a4ad55d99f77a3be7c6c614.avif,cb82342cd0b7b77144bec5701da436ae.avif,6c561313f2e5032c93af616ce4dbd303.avif}	{Climatisation,Wifi,TV,Bathroom}
826	29	Mountain View	600	3	f	t	{9e035a4a6a4ad55d99f77a3be7c6c614.avif,cb82342cd0b7b77144bec5701da436ae.avif,6c561313f2e5032c93af616ce4dbd303.avif}	{Climatisation,Wifi,TV,Bathroom}
827	29	Sea View	540	4	f	t	{9e035a4a6a4ad55d99f77a3be7c6c614.avif,cb82342cd0b7b77144bec5701da436ae.avif,6c561313f2e5032c93af616ce4dbd303.avif}	{Climatisation,Wifi,TV,Bathroom}
828	29	City View	600	2	f	t	{9e035a4a6a4ad55d99f77a3be7c6c614.avif,cb82342cd0b7b77144bec5701da436ae.avif,6c561313f2e5032c93af616ce4dbd303.avif}	{Climatisation,Wifi,TV,Bathroom}
829	30	Mountain View	600	2	f	t	{04d806bdfa47f006f8770d357a67ddb7.avif,70434c22eea12ca611487a4f038c9c4f.avif,317ba210146ef95dcb6a86cf4ba303f6.avif}	{Climatisation,Wifi,TV,Bathroom}
830	30	Sea View	560	3	f	t	{04d806bdfa47f006f8770d357a67ddb7.avif,70434c22eea12ca611487a4f038c9c4f.avif,317ba210146ef95dcb6a86cf4ba303f6.avif}	{Climatisation,Wifi,TV,Bathroom}
831	30	City View	600	3	f	t	{04d806bdfa47f006f8770d357a67ddb7.avif,70434c22eea12ca611487a4f038c9c4f.avif,317ba210146ef95dcb6a86cf4ba303f6.avif}	{Climatisation,Wifi,TV,Bathroom}
832	30	Mountain View	540	4	f	t	{04d806bdfa47f006f8770d357a67ddb7.avif,70434c22eea12ca611487a4f038c9c4f.avif,317ba210146ef95dcb6a86cf4ba303f6.avif}	{Climatisation,Wifi,TV,Bathroom}
833	30	Sea View	600	2	f	t	{04d806bdfa47f006f8770d357a67ddb7.avif,70434c22eea12ca611487a4f038c9c4f.avif,317ba210146ef95dcb6a86cf4ba303f6.avif}	{Climatisation,Wifi,TV,Bathroom}
834	31	City View	600	2	f	t	{16a66c12fd90da1f49642da118ac0a53.jpg,616bbcf6c3f04ab437e14c93dad6621a.jpg,851257b19a37bdccdaec73b62e8d373a.jpg}	{Climatisation,Wifi,TV,Bathroom}
835	31	Mountain View	560	3	f	t	{16a66c12fd90da1f49642da118ac0a53.jpg,616bbcf6c3f04ab437e14c93dad6621a.jpg,851257b19a37bdccdaec73b62e8d373a.jpg}	{Climatisation,Wifi,TV,Bathroom}
836	31	Sea View	600	3	f	t	{16a66c12fd90da1f49642da118ac0a53.jpg,616bbcf6c3f04ab437e14c93dad6621a.jpg,851257b19a37bdccdaec73b62e8d373a.jpg}	{Climatisation,Wifi,TV,Bathroom}
837	31	City View	540	4	f	t	{16a66c12fd90da1f49642da118ac0a53.jpg,616bbcf6c3f04ab437e14c93dad6621a.jpg,851257b19a37bdccdaec73b62e8d373a.jpg}	{Climatisation,Wifi,TV,Bathroom}
838	31	Mountain View	600	2	f	t	{16a66c12fd90da1f49642da118ac0a53.jpg,616bbcf6c3f04ab437e14c93dad6621a.jpg,851257b19a37bdccdaec73b62e8d373a.jpg}	{Climatisation,Wifi,TV,Bathroom}
839	32	Sea View	600	2	f	t	{f79cb04a7ff9c2a5f97e9d3548f55aaf.avif,63d249a9631abc3940a5cc1a91960a5d.avif,63743426663605ffe8f0aa24007fd2bf.avif}	{Climatisation,Wifi,TV,Bathroom}
840	32	City View	560	3	f	t	{f79cb04a7ff9c2a5f97e9d3548f55aaf.avif,63d249a9631abc3940a5cc1a91960a5d.avif,63743426663605ffe8f0aa24007fd2bf.avif}	{Climatisation,Wifi,TV,Bathroom}
841	32	Mountain View	600	3	f	t	{f79cb04a7ff9c2a5f97e9d3548f55aaf.avif,63d249a9631abc3940a5cc1a91960a5d.avif,63743426663605ffe8f0aa24007fd2bf.avif}	{Climatisation,Wifi,TV,Bathroom}
842	32	Sea View	540	4	f	t	{f79cb04a7ff9c2a5f97e9d3548f55aaf.avif,63d249a9631abc3940a5cc1a91960a5d.avif,63743426663605ffe8f0aa24007fd2bf.avif}	{Climatisation,Wifi,TV,Bathroom}
843	32	City View	600	2	f	t	{f79cb04a7ff9c2a5f97e9d3548f55aaf.avif,63d249a9631abc3940a5cc1a91960a5d.avif,63743426663605ffe8f0aa24007fd2bf.avif}	{Climatisation,Wifi,TV,Bathroom}
909	38	City View	550	3	t	f	{b0db90fb3da5cc8fd1219a81cf779b42.avif,b25b091eb668dac1352be14afe5bc69b.avif,53f3fabafb24874efa18d30192cae374.avif}	{Climatisation,Wifi,TV,Bathroom}
910	38	City View	550	3	t	f	{b0db90fb3da5cc8fd1219a81cf779b42.avif,b25b091eb668dac1352be14afe5bc69b.avif,53f3fabafb24874efa18d30192cae374.avif}	{Climatisation,Wifi,TV,Bathroom}
911	38	Mountain View	600	4	t	f	{b0db90fb3da5cc8fd1219a81cf779b42.avif,b25b091eb668dac1352be14afe5bc69b.avif,53f3fabafb24874efa18d30192cae374.avif}	{Climatisation,Wifi,TV,Bathroom}
912	38	Sea View	400	2	t	f	{b0db90fb3da5cc8fd1219a81cf779b42.avif,b25b091eb668dac1352be14afe5bc69b.avif,53f3fabafb24874efa18d30192cae374.avif}	{Climatisation,Wifi,TV,Bathroom}
913	38	City View	600	2	f	f	{b0db90fb3da5cc8fd1219a81cf779b42.avif,b25b091eb668dac1352be14afe5bc69b.avif,53f3fabafb24874efa18d30192cae374.avif}	{Climatisation,Wifi,TV,Bathroom}
914	34	Mountain View	600	2	f	t	{1ba68d4d81b95e04fd5f6d32f4ae846d.avif,0697b6bd72a5cbf286a6a1d641a439fe.avif,1461a592cadb534422e4549887ab0f7e.avif}	{Climatisation,Wifi,TV,Bathroom}
915	34	Sea View	560	3	f	t	{1ba68d4d81b95e04fd5f6d32f4ae846d.avif,0697b6bd72a5cbf286a6a1d641a439fe.avif,1461a592cadb534422e4549887ab0f7e.avif}	{Climatisation,Wifi,TV,Bathroom}
916	34	City View	600	3	f	t	{1ba68d4d81b95e04fd5f6d32f4ae846d.avif,0697b6bd72a5cbf286a6a1d641a439fe.avif,1461a592cadb534422e4549887ab0f7e.avif}	{Climatisation,Wifi,TV,Bathroom}
917	34	Mountain View	540	4	f	t	{1ba68d4d81b95e04fd5f6d32f4ae846d.avif,0697b6bd72a5cbf286a6a1d641a439fe.avif,1461a592cadb534422e4549887ab0f7e.avif}	{Climatisation,Wifi,TV,Bathroom}
918	34	Sea View	600	2	f	t	{1ba68d4d81b95e04fd5f6d32f4ae846d.avif,0697b6bd72a5cbf286a6a1d641a439fe.avif,1461a592cadb534422e4549887ab0f7e.avif}	{Climatisation,Wifi,TV,Bathroom}
919	34	City View	600	2	f	t	{fa7e5682d6b9dcf33006601677b59773.avif,abfba63ea0b01574ebe35e6eaede7417.avif,47ca0ecc8db5f8e26e51e9bd6f82a40e.avif,e0ec5675f3ccab83c056f84006e05a57.avif}	{Climatisation,Wifi,TV,Bathroom}
920	34	Mountain View	560	3	f	t	{fa7e5682d6b9dcf33006601677b59773.avif,abfba63ea0b01574ebe35e6eaede7417.avif,47ca0ecc8db5f8e26e51e9bd6f82a40e.avif,e0ec5675f3ccab83c056f84006e05a57.avif}	{Climatisation,Wifi,TV,Bathroom}
921	34	Sea View	600	3	f	t	{fa7e5682d6b9dcf33006601677b59773.avif,abfba63ea0b01574ebe35e6eaede7417.avif,47ca0ecc8db5f8e26e51e9bd6f82a40e.avif,e0ec5675f3ccab83c056f84006e05a57.avif}	{Climatisation,Wifi,TV,Bathroom}
922	34	City View	540	4	f	t	{fa7e5682d6b9dcf33006601677b59773.avif,abfba63ea0b01574ebe35e6eaede7417.avif,47ca0ecc8db5f8e26e51e9bd6f82a40e.avif,e0ec5675f3ccab83c056f84006e05a57.avif}	{Climatisation,Wifi,TV,Bathroom}
923	34	Mountain View	600	2	f	t	{fa7e5682d6b9dcf33006601677b59773.avif,abfba63ea0b01574ebe35e6eaede7417.avif,47ca0ecc8db5f8e26e51e9bd6f82a40e.avif,e0ec5675f3ccab83c056f84006e05a57.avif}	{Climatisation,Wifi,TV,Bathroom}
924	35	Sea View	600	2	f	t	{9e035a4a6a4ad55d99f77a3be7c6c614.avif,cb82342cd0b7b77144bec5701da436ae.avif,6c561313f2e5032c93af616ce4dbd303.avif}	{Climatisation,Wifi,TV,Bathroom}
925	35	City View	560	3	f	t	{9e035a4a6a4ad55d99f77a3be7c6c614.avif,cb82342cd0b7b77144bec5701da436ae.avif,6c561313f2e5032c93af616ce4dbd303.avif}	{Climatisation,Wifi,TV,Bathroom}
926	35	Mountain View	600	3	f	t	{9e035a4a6a4ad55d99f77a3be7c6c614.avif,cb82342cd0b7b77144bec5701da436ae.avif,6c561313f2e5032c93af616ce4dbd303.avif}	{Climatisation,Wifi,TV,Bathroom}
927	35	Sea View	540	4	f	t	{9e035a4a6a4ad55d99f77a3be7c6c614.avif,cb82342cd0b7b77144bec5701da436ae.avif,6c561313f2e5032c93af616ce4dbd303.avif}	{Climatisation,Wifi,TV,Bathroom}
928	35	City View	600	2	f	t	{9e035a4a6a4ad55d99f77a3be7c6c614.avif,cb82342cd0b7b77144bec5701da436ae.avif,6c561313f2e5032c93af616ce4dbd303.avif}	{Climatisation,Wifi,TV,Bathroom}
929	36	Mountain View	600	2	f	t	{04d806bdfa47f006f8770d357a67ddb7.avif,70434c22eea12ca611487a4f038c9c4f.avif,317ba210146ef95dcb6a86cf4ba303f6.avif}	{Climatisation,Wifi,TV,Bathroom}
930	36	Sea View	560	3	f	t	{04d806bdfa47f006f8770d357a67ddb7.avif,70434c22eea12ca611487a4f038c9c4f.avif,317ba210146ef95dcb6a86cf4ba303f6.avif}	{Climatisation,Wifi,TV,Bathroom}
931	36	City View	600	3	f	t	{04d806bdfa47f006f8770d357a67ddb7.avif,70434c22eea12ca611487a4f038c9c4f.avif,317ba210146ef95dcb6a86cf4ba303f6.avif}	{Climatisation,Wifi,TV,Bathroom}
932	36	Mountain View	540	4	f	t	{04d806bdfa47f006f8770d357a67ddb7.avif,70434c22eea12ca611487a4f038c9c4f.avif,317ba210146ef95dcb6a86cf4ba303f6.avif}	{Climatisation,Wifi,TV,Bathroom}
933	36	Sea View	600	2	f	t	{04d806bdfa47f006f8770d357a67ddb7.avif,70434c22eea12ca611487a4f038c9c4f.avif,317ba210146ef95dcb6a86cf4ba303f6.avif}	{Climatisation,Wifi,TV,Bathroom}
934	37	City View	600	2	f	t	{16a66c12fd90da1f49642da118ac0a53.jpg,616bbcf6c3f04ab437e14c93dad6621a.jpg,851257b19a37bdccdaec73b62e8d373a.jpg}	{Climatisation,Wifi,TV,Bathroom}
935	37	Mountain View	560	3	f	t	{16a66c12fd90da1f49642da118ac0a53.jpg,616bbcf6c3f04ab437e14c93dad6621a.jpg,851257b19a37bdccdaec73b62e8d373a.jpg}	{Climatisation,Wifi,TV,Bathroom}
936	37	Sea View	600	3	f	t	{16a66c12fd90da1f49642da118ac0a53.jpg,616bbcf6c3f04ab437e14c93dad6621a.jpg,851257b19a37bdccdaec73b62e8d373a.jpg}	{Climatisation,Wifi,TV,Bathroom}
937	37	City View	540	4	f	t	{16a66c12fd90da1f49642da118ac0a53.jpg,616bbcf6c3f04ab437e14c93dad6621a.jpg,851257b19a37bdccdaec73b62e8d373a.jpg}	{Climatisation,Wifi,TV,Bathroom}
938	37	Mountain View	600	2	f	t	{16a66c12fd90da1f49642da118ac0a53.jpg,616bbcf6c3f04ab437e14c93dad6621a.jpg,851257b19a37bdccdaec73b62e8d373a.jpg}	{Climatisation,Wifi,TV,Bathroom}
939	32	Sea View	600	2	f	t	{f79cb04a7ff9c2a5f97e9d3548f55aaf.avif,63d249a9631abc3940a5cc1a91960a5d.avif,63743426663605ffe8f0aa24007fd2bf.avif}	{Climatisation,Wifi,TV,Bathroom}
940	32	City View	560	3	f	t	{f79cb04a7ff9c2a5f97e9d3548f55aaf.avif,63d249a9631abc3940a5cc1a91960a5d.avif,63743426663605ffe8f0aa24007fd2bf.avif}	{Climatisation,Wifi,TV,Bathroom}
941	32	Mountain View	600	3	f	t	{f79cb04a7ff9c2a5f97e9d3548f55aaf.avif,63d249a9631abc3940a5cc1a91960a5d.avif,63743426663605ffe8f0aa24007fd2bf.avif}	{Climatisation,Wifi,TV,Bathroom}
942	32	Sea View	540	4	f	t	{f79cb04a7ff9c2a5f97e9d3548f55aaf.avif,63d249a9631abc3940a5cc1a91960a5d.avif,63743426663605ffe8f0aa24007fd2bf.avif}	{Climatisation,Wifi,TV,Bathroom}
943	32	City View	600	2	f	t	{f79cb04a7ff9c2a5f97e9d3548f55aaf.avif,63d249a9631abc3940a5cc1a91960a5d.avif,63743426663605ffe8f0aa24007fd2bf.avif}	{Climatisation,Wifi,TV,Bathroom}
1009	33	City View	550	3	t	f	{b0db90fb3da5cc8fd1219a81cf779b42.avif,b25b091eb668dac1352be14afe5bc69b.avif,53f3fabafb24874efa18d30192cae374.avif}	{Climatisation,Wifi,TV,Bathroom}
1010	33	City View	550	3	t	f	{b0db90fb3da5cc8fd1219a81cf779b42.avif,b25b091eb668dac1352be14afe5bc69b.avif,53f3fabafb24874efa18d30192cae374.avif}	{Climatisation,Wifi,TV,Bathroom}
1011	33	Mountain View	600	4	t	f	{b0db90fb3da5cc8fd1219a81cf779b42.avif,b25b091eb668dac1352be14afe5bc69b.avif,53f3fabafb24874efa18d30192cae374.avif}	{Climatisation,Wifi,TV,Bathroom}
1012	33	Sea View	400	2	t	f	{b0db90fb3da5cc8fd1219a81cf779b42.avif,b25b091eb668dac1352be14afe5bc69b.avif,53f3fabafb24874efa18d30192cae374.avif}	{Climatisation,Wifi,TV,Bathroom}
1013	33	City View	600	2	f	f	{b0db90fb3da5cc8fd1219a81cf779b42.avif,b25b091eb668dac1352be14afe5bc69b.avif,53f3fabafb24874efa18d30192cae374.avif}	{Climatisation,Wifi,TV,Bathroom}
1014	39	Mountain View	600	2	f	t	{1ba68d4d81b95e04fd5f6d32f4ae846d.avif,0697b6bd72a5cbf286a6a1d641a439fe.avif,1461a592cadb534422e4549887ab0f7e.avif}	{Climatisation,Wifi,TV,Bathroom}
1015	39	Sea View	560	3	f	t	{1ba68d4d81b95e04fd5f6d32f4ae846d.avif,0697b6bd72a5cbf286a6a1d641a439fe.avif,1461a592cadb534422e4549887ab0f7e.avif}	{Climatisation,Wifi,TV,Bathroom}
1016	39	City View	600	3	f	t	{1ba68d4d81b95e04fd5f6d32f4ae846d.avif,0697b6bd72a5cbf286a6a1d641a439fe.avif,1461a592cadb534422e4549887ab0f7e.avif}	{Climatisation,Wifi,TV,Bathroom}
1017	39	Mountain View	540	4	f	t	{1ba68d4d81b95e04fd5f6d32f4ae846d.avif,0697b6bd72a5cbf286a6a1d641a439fe.avif,1461a592cadb534422e4549887ab0f7e.avif}	{Climatisation,Wifi,TV,Bathroom}
1018	39	Sea View	600	2	f	t	{1ba68d4d81b95e04fd5f6d32f4ae846d.avif,0697b6bd72a5cbf286a6a1d641a439fe.avif,1461a592cadb534422e4549887ab0f7e.avif}	{Climatisation,Wifi,TV,Bathroom}
1019	39	City View	600	2	f	t	{fa7e5682d6b9dcf33006601677b59773.avif,abfba63ea0b01574ebe35e6eaede7417.avif,47ca0ecc8db5f8e26e51e9bd6f82a40e.avif,e0ec5675f3ccab83c056f84006e05a57.avif}	{Climatisation,Wifi,TV,Bathroom}
1020	39	Mountain View	560	3	f	t	{fa7e5682d6b9dcf33006601677b59773.avif,abfba63ea0b01574ebe35e6eaede7417.avif,47ca0ecc8db5f8e26e51e9bd6f82a40e.avif,e0ec5675f3ccab83c056f84006e05a57.avif}	{Climatisation,Wifi,TV,Bathroom}
1021	39	Sea View	600	3	f	t	{fa7e5682d6b9dcf33006601677b59773.avif,abfba63ea0b01574ebe35e6eaede7417.avif,47ca0ecc8db5f8e26e51e9bd6f82a40e.avif,e0ec5675f3ccab83c056f84006e05a57.avif}	{Climatisation,Wifi,TV,Bathroom}
1022	39	City View	540	4	f	t	{fa7e5682d6b9dcf33006601677b59773.avif,abfba63ea0b01574ebe35e6eaede7417.avif,47ca0ecc8db5f8e26e51e9bd6f82a40e.avif,e0ec5675f3ccab83c056f84006e05a57.avif}	{Climatisation,Wifi,TV,Bathroom}
1023	39	Mountain View	600	2	f	t	{fa7e5682d6b9dcf33006601677b59773.avif,abfba63ea0b01574ebe35e6eaede7417.avif,47ca0ecc8db5f8e26e51e9bd6f82a40e.avif,e0ec5675f3ccab83c056f84006e05a57.avif}	{Climatisation,Wifi,TV,Bathroom}
1024	41	Sea View	600	2	f	t	{9e035a4a6a4ad55d99f77a3be7c6c614.avif,cb82342cd0b7b77144bec5701da436ae.avif,6c561313f2e5032c93af616ce4dbd303.avif}	{Climatisation,Wifi,TV,Bathroom}
1025	41	City View	560	3	f	t	{9e035a4a6a4ad55d99f77a3be7c6c614.avif,cb82342cd0b7b77144bec5701da436ae.avif,6c561313f2e5032c93af616ce4dbd303.avif}	{Climatisation,Wifi,TV,Bathroom}
1026	41	Mountain View	600	3	f	t	{9e035a4a6a4ad55d99f77a3be7c6c614.avif,cb82342cd0b7b77144bec5701da436ae.avif,6c561313f2e5032c93af616ce4dbd303.avif}	{Climatisation,Wifi,TV,Bathroom}
1027	41	Sea View	540	4	f	t	{9e035a4a6a4ad55d99f77a3be7c6c614.avif,cb82342cd0b7b77144bec5701da436ae.avif,6c561313f2e5032c93af616ce4dbd303.avif}	{Climatisation,Wifi,TV,Bathroom}
1028	41	City View	600	2	f	t	{9e035a4a6a4ad55d99f77a3be7c6c614.avif,cb82342cd0b7b77144bec5701da436ae.avif,6c561313f2e5032c93af616ce4dbd303.avif}	{Climatisation,Wifi,TV,Bathroom}
1029	42	Mountain View	600	2	f	t	{04d806bdfa47f006f8770d357a67ddb7.avif,70434c22eea12ca611487a4f038c9c4f.avif,317ba210146ef95dcb6a86cf4ba303f6.avif}	{Climatisation,Wifi,TV,Bathroom}
1030	42	Sea View	560	3	f	t	{04d806bdfa47f006f8770d357a67ddb7.avif,70434c22eea12ca611487a4f038c9c4f.avif,317ba210146ef95dcb6a86cf4ba303f6.avif}	{Climatisation,Wifi,TV,Bathroom}
1031	42	City View	600	3	f	t	{04d806bdfa47f006f8770d357a67ddb7.avif,70434c22eea12ca611487a4f038c9c4f.avif,317ba210146ef95dcb6a86cf4ba303f6.avif}	{Climatisation,Wifi,TV,Bathroom}
1032	42	Mountain View	540	4	f	t	{04d806bdfa47f006f8770d357a67ddb7.avif,70434c22eea12ca611487a4f038c9c4f.avif,317ba210146ef95dcb6a86cf4ba303f6.avif}	{Climatisation,Wifi,TV,Bathroom}
1033	42	Sea View	600	2	f	t	{04d806bdfa47f006f8770d357a67ddb7.avif,70434c22eea12ca611487a4f038c9c4f.avif,317ba210146ef95dcb6a86cf4ba303f6.avif}	{Climatisation,Wifi,TV,Bathroom}
1034	43	City View	600	2	f	t	{16a66c12fd90da1f49642da118ac0a53.jpg,616bbcf6c3f04ab437e14c93dad6621a.jpg,851257b19a37bdccdaec73b62e8d373a.jpg}	{Climatisation,Wifi,TV,Bathroom}
1035	43	Mountain View	560	3	f	t	{16a66c12fd90da1f49642da118ac0a53.jpg,616bbcf6c3f04ab437e14c93dad6621a.jpg,851257b19a37bdccdaec73b62e8d373a.jpg}	{Climatisation,Wifi,TV,Bathroom}
1036	43	Sea View	600	3	f	t	{16a66c12fd90da1f49642da118ac0a53.jpg,616bbcf6c3f04ab437e14c93dad6621a.jpg,851257b19a37bdccdaec73b62e8d373a.jpg}	{Climatisation,Wifi,TV,Bathroom}
1037	43	City View	540	4	f	t	{16a66c12fd90da1f49642da118ac0a53.jpg,616bbcf6c3f04ab437e14c93dad6621a.jpg,851257b19a37bdccdaec73b62e8d373a.jpg}	{Climatisation,Wifi,TV,Bathroom}
1038	43	Mountain View	600	2	f	t	{16a66c12fd90da1f49642da118ac0a53.jpg,616bbcf6c3f04ab437e14c93dad6621a.jpg,851257b19a37bdccdaec73b62e8d373a.jpg}	{Climatisation,Wifi,TV,Bathroom}
1039	40	Sea View	600	2	f	t	{f79cb04a7ff9c2a5f97e9d3548f55aaf.avif,63d249a9631abc3940a5cc1a91960a5d.avif,63743426663605ffe8f0aa24007fd2bf.avif}	{Climatisation,Wifi,TV,Bathroom}
1040	40	City View	560	3	f	t	{f79cb04a7ff9c2a5f97e9d3548f55aaf.avif,63d249a9631abc3940a5cc1a91960a5d.avif,63743426663605ffe8f0aa24007fd2bf.avif}	{Climatisation,Wifi,TV,Bathroom}
1041	40	Mountain View	600	3	f	t	{f79cb04a7ff9c2a5f97e9d3548f55aaf.avif,63d249a9631abc3940a5cc1a91960a5d.avif,63743426663605ffe8f0aa24007fd2bf.avif}	{Climatisation,Wifi,TV,Bathroom}
1042	40	Sea View	540	4	f	t	{f79cb04a7ff9c2a5f97e9d3548f55aaf.avif,63d249a9631abc3940a5cc1a91960a5d.avif,63743426663605ffe8f0aa24007fd2bf.avif}	{Climatisation,Wifi,TV,Bathroom}
1043	40	City View	600	2	f	t	{f79cb04a7ff9c2a5f97e9d3548f55aaf.avif,63d249a9631abc3940a5cc1a91960a5d.avif,63743426663605ffe8f0aa24007fd2bf.avif}	{Climatisation,Wifi,TV,Bathroom}
1109	44	City View	550	3	t	f	{b0db90fb3da5cc8fd1219a81cf779b42.avif,b25b091eb668dac1352be14afe5bc69b.avif,53f3fabafb24874efa18d30192cae374.avif}	{Climatisation,Wifi,TV,Bathroom}
1110	44	City View	550	3	t	f	{b0db90fb3da5cc8fd1219a81cf779b42.avif,b25b091eb668dac1352be14afe5bc69b.avif,53f3fabafb24874efa18d30192cae374.avif}	{Climatisation,Wifi,TV,Bathroom}
1111	44	Mountain View	600	4	t	f	{b0db90fb3da5cc8fd1219a81cf779b42.avif,b25b091eb668dac1352be14afe5bc69b.avif,53f3fabafb24874efa18d30192cae374.avif}	{Climatisation,Wifi,TV,Bathroom}
1112	44	Sea View	400	2	t	f	{b0db90fb3da5cc8fd1219a81cf779b42.avif,b25b091eb668dac1352be14afe5bc69b.avif,53f3fabafb24874efa18d30192cae374.avif}	{Climatisation,Wifi,TV,Bathroom}
1113	44	City View	600	2	f	f	{b0db90fb3da5cc8fd1219a81cf779b42.avif,b25b091eb668dac1352be14afe5bc69b.avif,53f3fabafb24874efa18d30192cae374.avif}	{Climatisation,Wifi,TV,Bathroom}
1114	45	Mountain View	600	2	f	t	{1ba68d4d81b95e04fd5f6d32f4ae846d.avif,0697b6bd72a5cbf286a6a1d641a439fe.avif,1461a592cadb534422e4549887ab0f7e.avif}	{Climatisation,Wifi,TV,Bathroom}
1115	45	Sea View	560	3	f	t	{1ba68d4d81b95e04fd5f6d32f4ae846d.avif,0697b6bd72a5cbf286a6a1d641a439fe.avif,1461a592cadb534422e4549887ab0f7e.avif}	{Climatisation,Wifi,TV,Bathroom}
1116	45	City View	600	3	f	t	{1ba68d4d81b95e04fd5f6d32f4ae846d.avif,0697b6bd72a5cbf286a6a1d641a439fe.avif,1461a592cadb534422e4549887ab0f7e.avif}	{Climatisation,Wifi,TV,Bathroom}
1117	45	Mountain View	540	4	f	t	{1ba68d4d81b95e04fd5f6d32f4ae846d.avif,0697b6bd72a5cbf286a6a1d641a439fe.avif,1461a592cadb534422e4549887ab0f7e.avif}	{Climatisation,Wifi,TV,Bathroom}
1118	45	Sea View	600	2	f	t	{1ba68d4d81b95e04fd5f6d32f4ae846d.avif,0697b6bd72a5cbf286a6a1d641a439fe.avif,1461a592cadb534422e4549887ab0f7e.avif}	{Climatisation,Wifi,TV,Bathroom}
1119	45	City View	600	2	f	t	{fa7e5682d6b9dcf33006601677b59773.avif,abfba63ea0b01574ebe35e6eaede7417.avif,47ca0ecc8db5f8e26e51e9bd6f82a40e.avif,e0ec5675f3ccab83c056f84006e05a57.avif}	{Climatisation,Wifi,TV,Bathroom}
1120	45	Mountain View	560	3	f	t	{fa7e5682d6b9dcf33006601677b59773.avif,abfba63ea0b01574ebe35e6eaede7417.avif,47ca0ecc8db5f8e26e51e9bd6f82a40e.avif,e0ec5675f3ccab83c056f84006e05a57.avif}	{Climatisation,Wifi,TV,Bathroom}
1121	45	Sea View	600	3	f	t	{fa7e5682d6b9dcf33006601677b59773.avif,abfba63ea0b01574ebe35e6eaede7417.avif,47ca0ecc8db5f8e26e51e9bd6f82a40e.avif,e0ec5675f3ccab83c056f84006e05a57.avif}	{Climatisation,Wifi,TV,Bathroom}
1122	45	City View	540	4	f	t	{fa7e5682d6b9dcf33006601677b59773.avif,abfba63ea0b01574ebe35e6eaede7417.avif,47ca0ecc8db5f8e26e51e9bd6f82a40e.avif,e0ec5675f3ccab83c056f84006e05a57.avif}	{Climatisation,Wifi,TV,Bathroom}
1123	45	Mountain View	600	2	f	t	{fa7e5682d6b9dcf33006601677b59773.avif,abfba63ea0b01574ebe35e6eaede7417.avif,47ca0ecc8db5f8e26e51e9bd6f82a40e.avif,e0ec5675f3ccab83c056f84006e05a57.avif}	{Climatisation,Wifi,TV,Bathroom}
\.


--
-- TOC entry 3768 (class 0 OID 0)
-- Dependencies: 215
-- Name: central_office_chain_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ychouay
--

SELECT pg_catalog.setval('public.central_office_chain_id_seq', 1, false);


--
-- TOC entry 3769 (class 0 OID 0)
-- Dependencies: 214
-- Name: central_office_office_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ychouay
--

SELECT pg_catalog.setval('public.central_office_office_id_seq', 8, true);


--
-- TOC entry 3770 (class 0 OID 0)
-- Dependencies: 209
-- Name: chains_chain_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ychouay
--

SELECT pg_catalog.setval('public.chains_chain_id_seq', 16, true);


--
-- TOC entry 3771 (class 0 OID 0)
-- Dependencies: 222
-- Name: customers_customer_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ychouay
--

SELECT pg_catalog.setval('public.customers_customer_id_seq', 4, true);


--
-- TOC entry 3772 (class 0 OID 0)
-- Dependencies: 221
-- Name: customers_sin_seq; Type: SEQUENCE SET; Schema: public; Owner: ychouay
--

SELECT pg_catalog.setval('public.customers_sin_seq', 1, false);


--
-- TOC entry 3773 (class 0 OID 0)
-- Dependencies: 225
-- Name: employees_employee_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ychouay
--

SELECT pg_catalog.setval('public.employees_employee_id_seq', 2, true);


--
-- TOC entry 3774 (class 0 OID 0)
-- Dependencies: 226
-- Name: employees_hotel_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ychouay
--

SELECT pg_catalog.setval('public.employees_hotel_id_seq', 1, true);


--
-- TOC entry 3775 (class 0 OID 0)
-- Dependencies: 224
-- Name: employees_sin_seq; Type: SEQUENCE SET; Schema: public; Owner: ychouay
--

SELECT pg_catalog.setval('public.employees_sin_seq', 1, false);


--
-- TOC entry 3776 (class 0 OID 0)
-- Dependencies: 233
-- Name: hotel_audit_hotel_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ychouay
--

SELECT pg_catalog.setval('public.hotel_audit_hotel_id_seq', 1, false);


--
-- TOC entry 3777 (class 0 OID 0)
-- Dependencies: 212
-- Name: hotels_chain_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ychouay
--

SELECT pg_catalog.setval('public.hotels_chain_id_seq', 1, false);


--
-- TOC entry 3778 (class 0 OID 0)
-- Dependencies: 211
-- Name: hotels_hotel_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ychouay
--

SELECT pg_catalog.setval('public.hotels_hotel_id_seq', 45, true);


--
-- TOC entry 3779 (class 0 OID 0)
-- Dependencies: 219
-- Name: person_sin_seq; Type: SEQUENCE SET; Schema: public; Owner: ychouay
--

SELECT pg_catalog.setval('public.person_sin_seq', 8, true);


--
-- TOC entry 3780 (class 0 OID 0)
-- Dependencies: 236
-- Name: reservation_audit_reservation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ychouay
--

SELECT pg_catalog.setval('public.reservation_audit_reservation_id_seq', 1, false);


--
-- TOC entry 3781 (class 0 OID 0)
-- Dependencies: 229
-- Name: reservation_chain_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ychouay
--

SELECT pg_catalog.setval('public.reservation_chain_id_seq', 1, false);


--
-- TOC entry 3782 (class 0 OID 0)
-- Dependencies: 231
-- Name: reservation_customer_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ychouay
--

SELECT pg_catalog.setval('public.reservation_customer_id_seq', 1, false);


--
-- TOC entry 3783 (class 0 OID 0)
-- Dependencies: 230
-- Name: reservation_hotel_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ychouay
--

SELECT pg_catalog.setval('public.reservation_hotel_id_seq', 1, false);


--
-- TOC entry 3784 (class 0 OID 0)
-- Dependencies: 228
-- Name: reservation_reservation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ychouay
--

SELECT pg_catalog.setval('public.reservation_reservation_id_seq', 27, true);


--
-- TOC entry 3785 (class 0 OID 0)
-- Dependencies: 217
-- Name: rooms_hotel_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ychouay
--

SELECT pg_catalog.setval('public.rooms_hotel_id_seq', 1, false);


--
-- TOC entry 3544 (class 2606 OID 33871)
-- Name: central_office central_office_pkey; Type: CONSTRAINT; Schema: public; Owner: ychouay
--

ALTER TABLE ONLY public.central_office
    ADD CONSTRAINT central_office_pkey PRIMARY KEY (office_id, chain_id);


--
-- TOC entry 3540 (class 2606 OID 33848)
-- Name: chains chains_pkey; Type: CONSTRAINT; Schema: public; Owner: ychouay
--

ALTER TABLE ONLY public.chains
    ADD CONSTRAINT chains_pkey PRIMARY KEY (chain_id);


--
-- TOC entry 3554 (class 2606 OID 33909)
-- Name: customers customers_pkey; Type: CONSTRAINT; Schema: public; Owner: ychouay
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_pkey PRIMARY KEY (customer_id);


--
-- TOC entry 3556 (class 2606 OID 33922)
-- Name: employees employees_pkey; Type: CONSTRAINT; Schema: public; Owner: ychouay
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_pkey PRIMARY KEY (employee_id);


--
-- TOC entry 3542 (class 2606 OID 33860)
-- Name: hotels hotels_pkey; Type: CONSTRAINT; Schema: public; Owner: ychouay
--

ALTER TABLE ONLY public.hotels
    ADD CONSTRAINT hotels_pkey PRIMARY KEY (hotel_id);


--
-- TOC entry 3550 (class 2606 OID 34048)
-- Name: person person_email_key; Type: CONSTRAINT; Schema: public; Owner: ychouay
--

ALTER TABLE ONLY public.person
    ADD CONSTRAINT person_email_key UNIQUE (email);


--
-- TOC entry 3552 (class 2606 OID 33898)
-- Name: person person_pkey; Type: CONSTRAINT; Schema: public; Owner: ychouay
--

ALTER TABLE ONLY public.person
    ADD CONSTRAINT person_pkey PRIMARY KEY (sin);


--
-- TOC entry 3558 (class 2606 OID 33939)
-- Name: reservation reservation_pkey; Type: CONSTRAINT; Schema: public; Owner: ychouay
--

ALTER TABLE ONLY public.reservation
    ADD CONSTRAINT reservation_pkey PRIMARY KEY (reservation_id);


--
-- TOC entry 3546 (class 2606 OID 33882)
-- Name: rooms rooms_pkey; Type: CONSTRAINT; Schema: public; Owner: ychouay
--

ALTER TABLE ONLY public.rooms
    ADD CONSTRAINT rooms_pkey PRIMARY KEY (room_number, hotel_id);


--
-- TOC entry 3548 (class 2606 OID 33884)
-- Name: rooms rooms_room_number_key; Type: CONSTRAINT; Schema: public; Owner: ychouay
--

ALTER TABLE ONLY public.rooms
    ADD CONSTRAINT rooms_room_number_key UNIQUE (room_number);


--
-- TOC entry 3559 (class 1259 OID 34065)
-- Name: reservations_unrated; Type: INDEX; Schema: public; Owner: ychouay
--

CREATE INDEX reservations_unrated ON public.reservation USING btree (reservation_id) WHERE (rated = false);


--
-- TOC entry 3560 (class 1259 OID 34062)
-- Name: rooms_booked; Type: INDEX; Schema: public; Owner: ychouay
--

CREATE INDEX rooms_booked ON public.reservation USING btree (room_number, hotel_id) WHERE ((status)::text = 'booked'::text);


--
-- TOC entry 3561 (class 1259 OID 34063)
-- Name: rooms_unavailable; Type: INDEX; Schema: public; Owner: ychouay
--

CREATE INDEX rooms_unavailable ON public.reservation USING btree (room_number, hotel_id) WHERE (((status)::text = 'booked'::text) OR ((status)::text = 'rented'::text));


--
-- TOC entry 3572 (class 2620 OID 34080)
-- Name: hotels hotel_change; Type: TRIGGER; Schema: public; Owner: ychouay
--

CREATE TRIGGER hotel_change BEFORE UPDATE ON public.hotels FOR EACH ROW EXECUTE FUNCTION public.log_hotel_change();


--
-- TOC entry 3573 (class 2620 OID 34082)
-- Name: hotels hotel_delete; Type: TRIGGER; Schema: public; Owner: ychouay
--

CREATE TRIGGER hotel_delete BEFORE UPDATE ON public.hotels FOR EACH ROW EXECUTE FUNCTION public.log_hotel_delete();


--
-- TOC entry 3574 (class 2620 OID 34096)
-- Name: reservation register_old_reservation; Type: TRIGGER; Schema: public; Owner: ychouay
--

CREATE TRIGGER register_old_reservation BEFORE UPDATE ON public.reservation FOR EACH ROW EXECUTE FUNCTION public.log_reservation();


--
-- TOC entry 3564 (class 2606 OID 33950)
-- Name: central_office central_office_chain_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ychouay
--

ALTER TABLE ONLY public.central_office
    ADD CONSTRAINT central_office_chain_id_fkey FOREIGN KEY (chain_id) REFERENCES public.chains(chain_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3567 (class 2606 OID 34049)
-- Name: customers customers_email_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ychouay
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_email_fkey FOREIGN KEY (email) REFERENCES public.person(email) NOT VALID;


--
-- TOC entry 3568 (class 2606 OID 33965)
-- Name: customers customers_sin_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ychouay
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_sin_fkey FOREIGN KEY (sin) REFERENCES public.person(sin) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3569 (class 2606 OID 34054)
-- Name: employees employees_email_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ychouay
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_email_fkey FOREIGN KEY (email) REFERENCES public.person(email) NOT VALID;


--
-- TOC entry 3570 (class 2606 OID 34128)
-- Name: employees employees_hotel_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ychouay
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_hotel_id_fkey FOREIGN KEY (hotel_id) REFERENCES public.hotels(hotel_id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 3571 (class 2606 OID 33975)
-- Name: employees employees_sin_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ychouay
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_sin_fkey FOREIGN KEY (sin) REFERENCES public.person(sin) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3562 (class 2606 OID 33945)
-- Name: hotels hotels_chain_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ychouay
--

ALTER TABLE ONLY public.hotels
    ADD CONSTRAINT hotels_chain_id_fkey FOREIGN KEY (chain_id) REFERENCES public.chains(chain_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3563 (class 2606 OID 33940)
-- Name: hotels hotels_manager_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ychouay
--

ALTER TABLE ONLY public.hotels
    ADD CONSTRAINT hotels_manager_id_fkey FOREIGN KEY (manager_id) REFERENCES public.employees(employee_id);


--
-- TOC entry 3565 (class 2606 OID 33885)
-- Name: rooms rooms_hotel_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ychouay
--

ALTER TABLE ONLY public.rooms
    ADD CONSTRAINT rooms_hotel_id_fkey FOREIGN KEY (hotel_id) REFERENCES public.hotels(hotel_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3566 (class 2606 OID 33960)
-- Name: rooms rooms_hotel_id_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: ychouay
--

ALTER TABLE ONLY public.rooms
    ADD CONSTRAINT rooms_hotel_id_fkey1 FOREIGN KEY (hotel_id) REFERENCES public.hotels(hotel_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3749 (class 0 OID 0)
-- Dependencies: 4
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: ychouay
--

REVOKE USAGE ON SCHEMA public FROM PUBLIC;
GRANT ALL ON SCHEMA public TO PUBLIC;


-- Completed on 2023-03-31 22:18:41 EDT

--
-- PostgreSQL database dump complete
--

