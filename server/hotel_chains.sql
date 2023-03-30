--
-- PostgreSQL database dump
--

-- Dumped from database version 14.7 (Homebrew)
-- Dumped by pg_dump version 14.7 (Homebrew)

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
-- Name: central_office; Type: TABLE; Schema: public; Owner: ychouay
--

CREATE TABLE public.central_office (
    office_id integer NOT NULL,
    chain_id integer NOT NULL,
    email character varying NOT NULL,
    phone_number character varying[] NOT NULL,
    address character varying NOT NULL
);


ALTER TABLE public.central_office OWNER TO ychouay;

--
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
-- Name: central_office_chain_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ychouay
--

ALTER SEQUENCE public.central_office_chain_id_seq OWNED BY public.central_office.chain_id;


--
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
-- Name: central_office_office_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ychouay
--

ALTER SEQUENCE public.central_office_office_id_seq OWNED BY public.central_office.office_id;


--
-- Name: chains; Type: TABLE; Schema: public; Owner: ychouay
--

CREATE TABLE public.chains (
    chain_id integer NOT NULL,
    name character varying NOT NULL
);


ALTER TABLE public.chains OWNER TO ychouay;

--
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
-- Name: chains_chain_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ychouay
--

ALTER SEQUENCE public.chains_chain_id_seq OWNED BY public.chains.chain_id;


--
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
-- Name: customers_customer_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ychouay
--

ALTER SEQUENCE public.customers_customer_id_seq OWNED BY public.customers.customer_id;


--
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
-- Name: customers_sin_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ychouay
--

ALTER SEQUENCE public.customers_sin_seq OWNED BY public.customers.sin;


--
-- Name: employees; Type: TABLE; Schema: public; Owner: ychouay
--

CREATE TABLE public.employees (
    sin integer NOT NULL,
    email character varying NOT NULL,
    password character varying NOT NULL,
    role character varying,
    employee_id integer NOT NULL,
    hotel_id integer NOT NULL,
    employee_address character varying[]
);


ALTER TABLE public.employees OWNER TO ychouay;

--
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
-- Name: employees_employee_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ychouay
--

ALTER SEQUENCE public.employees_employee_id_seq OWNED BY public.employees.employee_id;


--
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
-- Name: employees_hotel_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ychouay
--

ALTER SEQUENCE public.employees_hotel_id_seq OWNED BY public.employees.hotel_id;


--
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
-- Name: employees_sin_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ychouay
--

ALTER SEQUENCE public.employees_sin_seq OWNED BY public.employees.sin;


--
-- Name: hotel_audit; Type: TABLE; Schema: public; Owner: ychouay
--

CREATE TABLE public.hotel_audit (
    hotel_id integer NOT NULL,
    operation character varying NOT NULL,
    changed_on timestamp without time zone NOT NULL
);


ALTER TABLE public.hotel_audit OWNER TO ychouay;

--
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
-- Name: hotel_audit_hotel_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ychouay
--

ALTER SEQUENCE public.hotel_audit_hotel_id_seq OWNED BY public.hotel_audit.hotel_id;


--
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
    CONSTRAINT hotels_rating_check CHECK (((rating > 0) AND (rating <= 5)))
);


ALTER TABLE public.hotels OWNER TO ychouay;

--
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
-- Name: hotels_chain_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ychouay
--

ALTER SEQUENCE public.hotels_chain_id_seq OWNED BY public.hotels.chain_id;


--
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
-- Name: hotels_hotel_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ychouay
--

ALTER SEQUENCE public.hotels_hotel_id_seq OWNED BY public.hotels.hotel_id;


--
-- Name: person; Type: TABLE; Schema: public; Owner: ychouay
--

CREATE TABLE public.person (
    sin integer NOT NULL,
    fullname character varying NOT NULL,
    email character varying NOT NULL
);


ALTER TABLE public.person OWNER TO ychouay;

--
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
-- Name: person_sin_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ychouay
--

ALTER SEQUENCE public.person_sin_seq OWNED BY public.person.sin;


--
-- Name: reservation; Type: TABLE; Schema: public; Owner: ychouay
--

CREATE TABLE public.reservation (
    reservation_id integer NOT NULL,
    chain_id integer NOT NULL,
    hotel_id integer NOT NULL,
    room_number integer,
    customer_id integer NOT NULL,
    employee_id integer,
    status character varying,
    active boolean DEFAULT true,
    rated boolean DEFAULT false,
    check_in date,
    check_out date
);


ALTER TABLE public.reservation OWNER TO ychouay;

--
-- Name: reservation_audit; Type: TABLE; Schema: public; Owner: ychouay
--

CREATE TABLE public.reservation_audit (
    reservation_id integer NOT NULL,
    changed_on date,
    operation character varying
);


ALTER TABLE public.reservation_audit OWNER TO ychouay;

--
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
-- Name: reservation_audit_reservation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ychouay
--

ALTER SEQUENCE public.reservation_audit_reservation_id_seq OWNED BY public.reservation_audit.reservation_id;


--
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
-- Name: reservation_chain_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ychouay
--

ALTER SEQUENCE public.reservation_chain_id_seq OWNED BY public.reservation.chain_id;


--
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
-- Name: reservation_customer_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ychouay
--

ALTER SEQUENCE public.reservation_customer_id_seq OWNED BY public.reservation.customer_id;


--
-- Name: reservation_employee_id_seq; Type: SEQUENCE; Schema: public; Owner: ychouay
--

CREATE SEQUENCE public.reservation_employee_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.reservation_employee_id_seq OWNER TO ychouay;

--
-- Name: reservation_employee_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ychouay
--

ALTER SEQUENCE public.reservation_employee_id_seq OWNED BY public.reservation.employee_id;


--
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
-- Name: reservation_hotel_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ychouay
--

ALTER SEQUENCE public.reservation_hotel_id_seq OWNED BY public.reservation.hotel_id;


--
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
-- Name: reservation_reservation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ychouay
--

ALTER SEQUENCE public.reservation_reservation_id_seq OWNED BY public.reservation.reservation_id;


--
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
-- Name: rooms_hotel_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ychouay
--

ALTER SEQUENCE public.rooms_hotel_id_seq OWNED BY public.rooms.hotel_id;


--
-- Name: central_office office_id; Type: DEFAULT; Schema: public; Owner: ychouay
--

ALTER TABLE ONLY public.central_office ALTER COLUMN office_id SET DEFAULT nextval('public.central_office_office_id_seq'::regclass);


--
-- Name: central_office chain_id; Type: DEFAULT; Schema: public; Owner: ychouay
--

ALTER TABLE ONLY public.central_office ALTER COLUMN chain_id SET DEFAULT nextval('public.central_office_chain_id_seq'::regclass);


--
-- Name: chains chain_id; Type: DEFAULT; Schema: public; Owner: ychouay
--

ALTER TABLE ONLY public.chains ALTER COLUMN chain_id SET DEFAULT nextval('public.chains_chain_id_seq'::regclass);


--
-- Name: customers sin; Type: DEFAULT; Schema: public; Owner: ychouay
--

ALTER TABLE ONLY public.customers ALTER COLUMN sin SET DEFAULT nextval('public.customers_sin_seq'::regclass);


--
-- Name: customers customer_id; Type: DEFAULT; Schema: public; Owner: ychouay
--

ALTER TABLE ONLY public.customers ALTER COLUMN customer_id SET DEFAULT nextval('public.customers_customer_id_seq'::regclass);


--
-- Name: employees sin; Type: DEFAULT; Schema: public; Owner: ychouay
--

ALTER TABLE ONLY public.employees ALTER COLUMN sin SET DEFAULT nextval('public.employees_sin_seq'::regclass);


--
-- Name: employees employee_id; Type: DEFAULT; Schema: public; Owner: ychouay
--

ALTER TABLE ONLY public.employees ALTER COLUMN employee_id SET DEFAULT nextval('public.employees_employee_id_seq'::regclass);


--
-- Name: employees hotel_id; Type: DEFAULT; Schema: public; Owner: ychouay
--

ALTER TABLE ONLY public.employees ALTER COLUMN hotel_id SET DEFAULT nextval('public.employees_hotel_id_seq'::regclass);


--
-- Name: hotel_audit hotel_id; Type: DEFAULT; Schema: public; Owner: ychouay
--

ALTER TABLE ONLY public.hotel_audit ALTER COLUMN hotel_id SET DEFAULT nextval('public.hotel_audit_hotel_id_seq'::regclass);


--
-- Name: hotels hotel_id; Type: DEFAULT; Schema: public; Owner: ychouay
--

ALTER TABLE ONLY public.hotels ALTER COLUMN hotel_id SET DEFAULT nextval('public.hotels_hotel_id_seq'::regclass);


--
-- Name: hotels chain_id; Type: DEFAULT; Schema: public; Owner: ychouay
--

ALTER TABLE ONLY public.hotels ALTER COLUMN chain_id SET DEFAULT nextval('public.hotels_chain_id_seq'::regclass);


--
-- Name: person sin; Type: DEFAULT; Schema: public; Owner: ychouay
--

ALTER TABLE ONLY public.person ALTER COLUMN sin SET DEFAULT nextval('public.person_sin_seq'::regclass);


--
-- Name: reservation reservation_id; Type: DEFAULT; Schema: public; Owner: ychouay
--

ALTER TABLE ONLY public.reservation ALTER COLUMN reservation_id SET DEFAULT nextval('public.reservation_reservation_id_seq'::regclass);


--
-- Name: reservation chain_id; Type: DEFAULT; Schema: public; Owner: ychouay
--

ALTER TABLE ONLY public.reservation ALTER COLUMN chain_id SET DEFAULT nextval('public.reservation_chain_id_seq'::regclass);


--
-- Name: reservation hotel_id; Type: DEFAULT; Schema: public; Owner: ychouay
--

ALTER TABLE ONLY public.reservation ALTER COLUMN hotel_id SET DEFAULT nextval('public.reservation_hotel_id_seq'::regclass);


--
-- Name: reservation customer_id; Type: DEFAULT; Schema: public; Owner: ychouay
--

ALTER TABLE ONLY public.reservation ALTER COLUMN customer_id SET DEFAULT nextval('public.reservation_customer_id_seq'::regclass);


--
-- Name: reservation employee_id; Type: DEFAULT; Schema: public; Owner: ychouay
--

ALTER TABLE ONLY public.reservation ALTER COLUMN employee_id SET DEFAULT nextval('public.reservation_employee_id_seq'::regclass);


--
-- Name: reservation_audit reservation_id; Type: DEFAULT; Schema: public; Owner: ychouay
--

ALTER TABLE ONLY public.reservation_audit ALTER COLUMN reservation_id SET DEFAULT nextval('public.reservation_audit_reservation_id_seq'::regclass);


--
-- Name: rooms hotel_id; Type: DEFAULT; Schema: public; Owner: ychouay
--

ALTER TABLE ONLY public.rooms ALTER COLUMN hotel_id SET DEFAULT nextval('public.rooms_hotel_id_seq'::regclass);


--
-- Data for Name: central_office; Type: TABLE DATA; Schema: public; Owner: ychouay
--

COPY public.central_office (office_id, chain_id, email, phone_number, address) FROM stdin;
\.


--
-- Data for Name: chains; Type: TABLE DATA; Schema: public; Owner: ychouay
--

COPY public.chains (chain_id, name) FROM stdin;
1	Paradise
2	Tropical
3	Sofitel
4	Marriott International
5	Hilton Hotels
6	Wyndham Hotel Group
9	marriot inn
\.


--
-- Data for Name: customers; Type: TABLE DATA; Schema: public; Owner: ychouay
--

COPY public.customers (sin, email, password, customer_id, registration_date, phone_number, customer_address) FROM stdin;
4	test@email.ca	$2a$10$7ctTs0Pr3bLF6S.3qYky2O1v.Tgvvbc.C0CGyeKFq8QzpbSeAB7Ku	3	2023-03-06	{2342341234}	{{"23&test&on &idk&k1k2n2"}}
6	test@test.ca	$2a$10$Xg1or/TmA4rV3h8lwTO3O.1EvJ2JwkpMxGTzjuXjmtoSMiFpx4wlu	4	2023-03-13	{123445221}	{{22&dbsgdg&csdf&vsvb&fsda}}
\.


--
-- Data for Name: employees; Type: TABLE DATA; Schema: public; Owner: ychouay
--

COPY public.employees (sin, email, password, role, employee_id, hotel_id, employee_address) FROM stdin;
7	admin@test.ca	$2a$10$R27QZqbIi1DktMHac5J4tOOW6shyRSOH6Y6erIipc143O4AzPvVLS	admin	1	1	{here}
8	employee@test.ca	$2a$10$U4S32hcBsPfSknNM/h6P9OtlsCrkrCvLjXXPiG6vMOkctiqjxFg92	employee	2	3	{"23 Micheal, Toronto, ON, K1N7L3"}
\.


--
-- Data for Name: hotel_audit; Type: TABLE DATA; Schema: public; Owner: ychouay
--

COPY public.hotel_audit (hotel_id, operation, changed_on) FROM stdin;
\.


--
-- Data for Name: hotels; Type: TABLE DATA; Schema: public; Owner: ychouay
--

COPY public.hotels (hotel_id, chain_id, hname, rating, email, phone_number, address, manager_id, count_rating) FROM stdin;
1	1	Paradise sub	5	tester@email.ca	\N	test	\N	1
3	3	Sofitel Sublet	5	sofitel@test.ca	{2341236666}	11 King avenue, Ottawa, ON, K1N6B4	\N	1
4	4	Marriot test	5	mariot@email.ca	{5673458888}	34 Dave street, Toronto, ON, Q2L4T2	\N	1
5	2	Tropical island	5	island@email.ca	{1231237777}	23 Sage street, Quebec, QC, Q1N7L9	\N	1
\.


--
-- Data for Name: person; Type: TABLE DATA; Schema: public; Owner: ychouay
--

COPY public.person (sin, fullname, email) FROM stdin;
4	testing	test@email.ca
6	test	test@test.ca
7	admin	admin@test.ca
8	John	employee@test.ca
\.


--
-- Data for Name: reservation; Type: TABLE DATA; Schema: public; Owner: ychouay
--

COPY public.reservation (reservation_id, chain_id, hotel_id, room_number, customer_id, employee_id, status, active, rated, check_in, check_out) FROM stdin;
20	3	3	33	4	1	rented	t	f	2023-04-01	2023-04-08
\.


--
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
-- Data for Name: rooms; Type: TABLE DATA; Schema: public; Owner: ychouay
--

COPY public.rooms (room_number, hotel_id, view, price, capacity, extendable, damaged, pictures, amenities) FROM stdin;
22	3	City View	650	3	t	f	{d406b55b73704088c35e3b15e423b86e.webp,photo-1679860596969.jpg}	{Climatisation,Wifi,TV,Bathroom,Parking}
33	3	City View	450	2	t	f	{9df2d98724a0369fc4b1480a7c5c01a1.webp,f1150202985e8be4a7388d89bdb33672.webp}	{Wifi,TV,Climatisation,Parking,Bathroom}
55	1	Sea View	400	4	t	t	{6be500a43623a0e091f8d5402d510420.webp,3a37ee172b4ea38145933ac8ea2a0c4e.webp,63d6d566701af8d6f88c52cbc95e37e4.webp}	{Climatisation,Balcony,Wifi,TV,Bathroom,Parking}
\.


--
-- Name: central_office_chain_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ychouay
--

SELECT pg_catalog.setval('public.central_office_chain_id_seq', 1, false);


--
-- Name: central_office_office_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ychouay
--

SELECT pg_catalog.setval('public.central_office_office_id_seq', 1, false);


--
-- Name: chains_chain_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ychouay
--

SELECT pg_catalog.setval('public.chains_chain_id_seq', 11, true);


--
-- Name: customers_customer_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ychouay
--

SELECT pg_catalog.setval('public.customers_customer_id_seq', 4, true);


--
-- Name: customers_sin_seq; Type: SEQUENCE SET; Schema: public; Owner: ychouay
--

SELECT pg_catalog.setval('public.customers_sin_seq', 1, false);


--
-- Name: employees_employee_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ychouay
--

SELECT pg_catalog.setval('public.employees_employee_id_seq', 2, true);


--
-- Name: employees_hotel_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ychouay
--

SELECT pg_catalog.setval('public.employees_hotel_id_seq', 1, true);


--
-- Name: employees_sin_seq; Type: SEQUENCE SET; Schema: public; Owner: ychouay
--

SELECT pg_catalog.setval('public.employees_sin_seq', 1, false);


--
-- Name: hotel_audit_hotel_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ychouay
--

SELECT pg_catalog.setval('public.hotel_audit_hotel_id_seq', 1, false);


--
-- Name: hotels_chain_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ychouay
--

SELECT pg_catalog.setval('public.hotels_chain_id_seq', 1, false);


--
-- Name: hotels_hotel_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ychouay
--

SELECT pg_catalog.setval('public.hotels_hotel_id_seq', 5, true);


--
-- Name: person_sin_seq; Type: SEQUENCE SET; Schema: public; Owner: ychouay
--

SELECT pg_catalog.setval('public.person_sin_seq', 8, true);


--
-- Name: reservation_audit_reservation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ychouay
--

SELECT pg_catalog.setval('public.reservation_audit_reservation_id_seq', 1, false);


--
-- Name: reservation_chain_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ychouay
--

SELECT pg_catalog.setval('public.reservation_chain_id_seq', 1, false);


--
-- Name: reservation_customer_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ychouay
--

SELECT pg_catalog.setval('public.reservation_customer_id_seq', 1, false);


--
-- Name: reservation_employee_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ychouay
--

SELECT pg_catalog.setval('public.reservation_employee_id_seq', 12, true);


--
-- Name: reservation_hotel_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ychouay
--

SELECT pg_catalog.setval('public.reservation_hotel_id_seq', 1, false);


--
-- Name: reservation_reservation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ychouay
--

SELECT pg_catalog.setval('public.reservation_reservation_id_seq', 20, true);


--
-- Name: rooms_hotel_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ychouay
--

SELECT pg_catalog.setval('public.rooms_hotel_id_seq', 1, false);


--
-- Name: central_office central_office_pkey; Type: CONSTRAINT; Schema: public; Owner: ychouay
--

ALTER TABLE ONLY public.central_office
    ADD CONSTRAINT central_office_pkey PRIMARY KEY (office_id, chain_id);


--
-- Name: chains chains_pkey; Type: CONSTRAINT; Schema: public; Owner: ychouay
--

ALTER TABLE ONLY public.chains
    ADD CONSTRAINT chains_pkey PRIMARY KEY (chain_id);


--
-- Name: customers customers_pkey; Type: CONSTRAINT; Schema: public; Owner: ychouay
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_pkey PRIMARY KEY (customer_id);


--
-- Name: employees employees_pkey; Type: CONSTRAINT; Schema: public; Owner: ychouay
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_pkey PRIMARY KEY (employee_id);


--
-- Name: hotels hotels_pkey; Type: CONSTRAINT; Schema: public; Owner: ychouay
--

ALTER TABLE ONLY public.hotels
    ADD CONSTRAINT hotels_pkey PRIMARY KEY (hotel_id);


--
-- Name: person person_email_key; Type: CONSTRAINT; Schema: public; Owner: ychouay
--

ALTER TABLE ONLY public.person
    ADD CONSTRAINT person_email_key UNIQUE (email);


--
-- Name: person person_pkey; Type: CONSTRAINT; Schema: public; Owner: ychouay
--

ALTER TABLE ONLY public.person
    ADD CONSTRAINT person_pkey PRIMARY KEY (sin);


--
-- Name: reservation reservation_pkey; Type: CONSTRAINT; Schema: public; Owner: ychouay
--

ALTER TABLE ONLY public.reservation
    ADD CONSTRAINT reservation_pkey PRIMARY KEY (reservation_id);


--
-- Name: rooms rooms_pkey; Type: CONSTRAINT; Schema: public; Owner: ychouay
--

ALTER TABLE ONLY public.rooms
    ADD CONSTRAINT rooms_pkey PRIMARY KEY (room_number, hotel_id);


--
-- Name: rooms rooms_room_number_key; Type: CONSTRAINT; Schema: public; Owner: ychouay
--

ALTER TABLE ONLY public.rooms
    ADD CONSTRAINT rooms_room_number_key UNIQUE (room_number);


--
-- Name: reservations_unrated; Type: INDEX; Schema: public; Owner: ychouay
--

CREATE INDEX reservations_unrated ON public.reservation USING btree (reservation_id) WHERE (rated = false);


--
-- Name: rooms_booked; Type: INDEX; Schema: public; Owner: ychouay
--

CREATE INDEX rooms_booked ON public.reservation USING btree (room_number, hotel_id) WHERE ((status)::text = 'booked'::text);


--
-- Name: rooms_unavailable; Type: INDEX; Schema: public; Owner: ychouay
--

CREATE INDEX rooms_unavailable ON public.reservation USING btree (room_number, hotel_id) WHERE (((status)::text = 'booked'::text) OR ((status)::text = 'rented'::text));


--
-- Name: hotels hotel_change; Type: TRIGGER; Schema: public; Owner: ychouay
--

CREATE TRIGGER hotel_change BEFORE UPDATE ON public.hotels FOR EACH ROW EXECUTE FUNCTION public.log_hotel_change();


--
-- Name: hotels hotel_delete; Type: TRIGGER; Schema: public; Owner: ychouay
--

CREATE TRIGGER hotel_delete BEFORE UPDATE ON public.hotels FOR EACH ROW EXECUTE FUNCTION public.log_hotel_delete();


--
-- Name: reservation register_old_reservation; Type: TRIGGER; Schema: public; Owner: ychouay
--

CREATE TRIGGER register_old_reservation BEFORE UPDATE ON public.reservation FOR EACH ROW EXECUTE FUNCTION public.log_reservation();


--
-- Name: central_office central_office_chain_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ychouay
--

ALTER TABLE ONLY public.central_office
    ADD CONSTRAINT central_office_chain_id_fkey FOREIGN KEY (chain_id) REFERENCES public.chains(chain_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: customers customers_email_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ychouay
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_email_fkey FOREIGN KEY (email) REFERENCES public.person(email) NOT VALID;


--
-- Name: customers customers_sin_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ychouay
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_sin_fkey FOREIGN KEY (sin) REFERENCES public.person(sin) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: employees employees_email_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ychouay
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_email_fkey FOREIGN KEY (email) REFERENCES public.person(email) NOT VALID;


--
-- Name: employees employees_hotel_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ychouay
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_hotel_id_fkey FOREIGN KEY (hotel_id) REFERENCES public.hotels(hotel_id);


--
-- Name: employees employees_sin_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ychouay
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_sin_fkey FOREIGN KEY (sin) REFERENCES public.person(sin) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: hotels hotels_chain_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ychouay
--

ALTER TABLE ONLY public.hotels
    ADD CONSTRAINT hotels_chain_id_fkey FOREIGN KEY (chain_id) REFERENCES public.chains(chain_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: hotels hotels_manager_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ychouay
--

ALTER TABLE ONLY public.hotels
    ADD CONSTRAINT hotels_manager_id_fkey FOREIGN KEY (manager_id) REFERENCES public.employees(employee_id);


--
-- Name: reservation reservation_chain_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ychouay
--

ALTER TABLE ONLY public.reservation
    ADD CONSTRAINT reservation_chain_id_fkey FOREIGN KEY (chain_id) REFERENCES public.chains(chain_id) ON UPDATE CASCADE;


--
-- Name: reservation reservation_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ychouay
--

ALTER TABLE ONLY public.reservation
    ADD CONSTRAINT reservation_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customers(customer_id) ON UPDATE CASCADE;


--
-- Name: reservation reservation_employee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ychouay
--

ALTER TABLE ONLY public.reservation
    ADD CONSTRAINT reservation_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES public.employees(employee_id) ON UPDATE CASCADE;


--
-- Name: reservation reservation_hotel_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ychouay
--

ALTER TABLE ONLY public.reservation
    ADD CONSTRAINT reservation_hotel_id_fkey FOREIGN KEY (hotel_id) REFERENCES public.hotels(hotel_id) ON UPDATE CASCADE;


--
-- Name: reservation reservation_room_number_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ychouay
--

ALTER TABLE ONLY public.reservation
    ADD CONSTRAINT reservation_room_number_fkey FOREIGN KEY (room_number) REFERENCES public.rooms(room_number) ON UPDATE CASCADE;


--
-- Name: rooms rooms_hotel_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ychouay
--

ALTER TABLE ONLY public.rooms
    ADD CONSTRAINT rooms_hotel_id_fkey FOREIGN KEY (hotel_id) REFERENCES public.hotels(hotel_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: rooms rooms_hotel_id_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: ychouay
--

ALTER TABLE ONLY public.rooms
    ADD CONSTRAINT rooms_hotel_id_fkey1 FOREIGN KEY (hotel_id) REFERENCES public.hotels(hotel_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

