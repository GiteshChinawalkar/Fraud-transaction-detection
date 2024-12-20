--
-- PostgreSQL database dump
--

-- Dumped from database version 14.15 (Homebrew)
-- Dumped by pg_dump version 17.0

-- Started on 2024-12-20 15:54:13 EST

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
-- TOC entry 5 (class 2615 OID 16385)
-- Name: bank_v3; Type: SCHEMA; Schema: -; Owner: aryagoyal
--

CREATE SCHEMA bank_v3;


ALTER SCHEMA bank_v3 OWNER TO aryagoyal;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 209 (class 1259 OID 16386)
-- Name: bank; Type: TABLE; Schema: bank_v3; Owner: aryagoyal
--

CREATE TABLE bank_v3.bank (
    branch_no double precision NOT NULL,
    timings character varying(255) DEFAULT NULL::character varying,
    street character varying(255) DEFAULT NULL::character varying,
    city character varying(255) DEFAULT NULL::character varying,
    state character varying(255) DEFAULT NULL::character varying
);


ALTER TABLE bank_v3.bank OWNER TO aryagoyal;

--
-- TOC entry 210 (class 1259 OID 16395)
-- Name: bank_account; Type: TABLE; Schema: bank_v3; Owner: aryagoyal
--

CREATE TABLE bank_v3.bank_account (
    acc_no character varying(255) NOT NULL,
    acc_type character varying(20) DEFAULT NULL::character varying,
    ssn character varying(11) DEFAULT NULL::character varying,
    balance double precision
);


ALTER TABLE bank_v3.bank_account OWNER TO aryagoyal;

--
-- TOC entry 211 (class 1259 OID 16400)
-- Name: bond; Type: TABLE; Schema: bank_v3; Owner: aryagoyal
--

CREATE TABLE bank_v3.bond (
    coupon_no double precision NOT NULL,
    coupon_val double precision,
    face_val double precision,
    coupon_rate double precision,
    bond_price double precision,
    maturity integer,
    ytm double precision,
    issue_date date,
    trans_id double precision
);


ALTER TABLE bank_v3.bond OWNER TO aryagoyal;

--
-- TOC entry 212 (class 1259 OID 16403)
-- Name: card; Type: TABLE; Schema: bank_v3; Owner: aryagoyal
--

CREATE TABLE bank_v3.card (
    card_no character varying(25) NOT NULL,
    active_status character varying(15) DEFAULT NULL::character varying,
    branch_no double precision,
    ssn character varying(11) DEFAULT NULL::character varying
);


ALTER TABLE bank_v3.card OWNER TO aryagoyal;

--
-- TOC entry 213 (class 1259 OID 16408)
-- Name: cash_investment; Type: TABLE; Schema: bank_v3; Owner: aryagoyal
--

CREATE TABLE bank_v3.cash_investment (
    receipt double precision NOT NULL,
    inv_date date,
    amt_inv double precision,
    rate_offered double precision,
    trans_id double precision
);


ALTER TABLE bank_v3.cash_investment OWNER TO aryagoyal;

--
-- TOC entry 214 (class 1259 OID 16411)
-- Name: checking; Type: TABLE; Schema: bank_v3; Owner: aryagoyal
--

CREATE TABLE bank_v3.checking (
    acc_no character varying(255) NOT NULL,
    withdrawal_limit double precision,
    fee double precision
);


ALTER TABLE bank_v3.checking OWNER TO aryagoyal;

--
-- TOC entry 215 (class 1259 OID 16414)
-- Name: client; Type: TABLE; Schema: bank_v3; Owner: aryagoyal
--

CREATE TABLE bank_v3.client (
    ssn character varying(11) NOT NULL,
    fname character varying(50) DEFAULT NULL::character varying,
    lname character varying(50) DEFAULT NULL::character varying,
    dob date,
    email character varying(50) DEFAULT NULL::character varying,
    phone character varying(255) DEFAULT NULL::character varying,
    street character varying(255) DEFAULT NULL::character varying,
    city character varying(255) DEFAULT NULL::character varying,
    state character varying(255) DEFAULT NULL::character varying
);


ALTER TABLE bank_v3.client OWNER TO aryagoyal;

--
-- TOC entry 216 (class 1259 OID 16426)
-- Name: credit; Type: TABLE; Schema: bank_v3; Owner: aryagoyal
--

CREATE TABLE bank_v3.credit (
    card_no character varying(25) NOT NULL,
    card_rate double precision,
    pay_deadline date,
    fine_due double precision,
    exp_date date,
    cvv integer,
    fname character varying(50) DEFAULT NULL::character varying,
    lname character varying(50) DEFAULT NULL::character varying
);


ALTER TABLE bank_v3.credit OWNER TO aryagoyal;

--
-- TOC entry 217 (class 1259 OID 16431)
-- Name: debit; Type: TABLE; Schema: bank_v3; Owner: aryagoyal
--

CREATE TABLE bank_v3.debit (
    card_no character varying(25) NOT NULL,
    exp_date date,
    cvv integer,
    rem_balance double precision,
    fname character varying(50) DEFAULT NULL::character varying,
    lname character varying(50) DEFAULT NULL::character varying
);


ALTER TABLE bank_v3.debit OWNER TO aryagoyal;

--
-- TOC entry 218 (class 1259 OID 16436)
-- Name: from_or_to; Type: TABLE; Schema: bank_v3; Owner: aryagoyal
--

CREATE TABLE bank_v3.from_or_to (
    index1 integer NOT NULL,
    trans_id double precision,
    acc_no character varying(255) DEFAULT NULL::character varying
);


ALTER TABLE bank_v3.from_or_to OWNER TO aryagoyal;

--
-- TOC entry 219 (class 1259 OID 16440)
-- Name: issues; Type: TABLE; Schema: bank_v3; Owner: aryagoyal
--

CREATE TABLE bank_v3.issues (
    index2 integer NOT NULL,
    coupon_no double precision,
    branch_no double precision
);


ALTER TABLE bank_v3.issues OWNER TO aryagoyal;

--
-- TOC entry 220 (class 1259 OID 16443)
-- Name: loan; Type: TABLE; Schema: bank_v3; Owner: aryagoyal
--

CREATE TABLE bank_v3.loan (
    loan_id double precision NOT NULL,
    loan_amt double precision,
    payment_period character varying(20) DEFAULT NULL::character varying,
    comp_period character varying(20) DEFAULT NULL::character varying,
    branch_no double precision,
    loan_date date,
    apr double precision,
    trans_id double precision
);


ALTER TABLE bank_v3.loan OWNER TO aryagoyal;

--
-- TOC entry 221 (class 1259 OID 16448)
-- Name: money_value; Type: TABLE; Schema: bank_v3; Owner: aryagoyal
--

CREATE TABLE bank_v3.money_value (
    mv_id double precision NOT NULL,
    inflation double precision,
    tax_rate double precision,
    ssn character varying(11) DEFAULT NULL::character varying
);


ALTER TABLE bank_v3.money_value OWNER TO aryagoyal;

--
-- TOC entry 222 (class 1259 OID 16452)
-- Name: savings; Type: TABLE; Schema: bank_v3; Owner: aryagoyal
--

CREATE TABLE bank_v3.savings (
    acc_no character varying(255) NOT NULL,
    withdrawal_limit double precision,
    fee double precision
);


ALTER TABLE bank_v3.savings OWNER TO aryagoyal;

--
-- TOC entry 223 (class 1259 OID 16455)
-- Name: transaction; Type: TABLE; Schema: bank_v3; Owner: aryagoyal
--

CREATE TABLE bank_v3.transaction (
    trans_id double precision NOT NULL,
    trans_date date,
    amount integer,
    type character varying(20) DEFAULT NULL::character varying,
    ssn character varying(11) DEFAULT NULL::character varying,
    from_acc character varying(255) DEFAULT NULL::character varying,
    to_acc character varying(255) DEFAULT NULL::character varying
);


ALTER TABLE bank_v3.transaction OWNER TO aryagoyal;

--
-- TOC entry 224 (class 1259 OID 16464)
-- Name: userdata; Type: TABLE; Schema: bank_v3; Owner: aryagoyal
--

CREATE TABLE bank_v3.userdata (
    id integer NOT NULL,
    username character varying(20) NOT NULL,
    password character varying(80) NOT NULL,
    email character varying(100) NOT NULL
);


ALTER TABLE bank_v3.userdata OWNER TO aryagoyal;

--
-- TOC entry 225 (class 1259 OID 16467)
-- Name: userdata_id_seq; Type: SEQUENCE; Schema: bank_v3; Owner: aryagoyal
--

CREATE SEQUENCE bank_v3.userdata_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE bank_v3.userdata_id_seq OWNER TO aryagoyal;

--
-- TOC entry 3801 (class 0 OID 0)
-- Dependencies: 225
-- Name: userdata_id_seq; Type: SEQUENCE OWNED BY; Schema: bank_v3; Owner: aryagoyal
--

ALTER SEQUENCE bank_v3.userdata_id_seq OWNED BY bank_v3.userdata.id;


--
-- TOC entry 3603 (class 2604 OID 16468)
-- Name: userdata id; Type: DEFAULT; Schema: bank_v3; Owner: aryagoyal
--

ALTER TABLE ONLY bank_v3.userdata ALTER COLUMN id SET DEFAULT nextval('bank_v3.userdata_id_seq'::regclass);


--
-- TOC entry 3779 (class 0 OID 16386)
-- Dependencies: 209
-- Data for Name: bank; Type: TABLE DATA; Schema: bank_v3; Owner: aryagoyal
--

COPY bank_v3.bank (branch_no, timings, street, city, state) FROM stdin;
160780	9:00 AM - 5:00 PM	45982 Fair Oaks Parkway	Colorado Springs	Colorado
161107	9:00 AM - 5:00 PM	601 Morningstar Street	Orlando	Florida
187541	9:00 AM - 5:00 PM	38 Bashford Drive	Racine	Wisconsin
531837	9:00 AM - 5:00 PM	306 Ilene Point	Los Angeles	California
556240	9:00 AM - 5:00 PM	08 Golf Trail	Birmingham	Alabama
576546	9:00 AM - 5:00 PM	61982 Sundown Terrace	Clearwater	Florida
653853	9:00 AM - 5:00 PM	96209 Moland Avenue	Indianapolis	Indiana
701300	9:00 AM - 5:00 PM	07 Summit Junction	Saint Louis	Missouri
788531	9:00 AM - 5:00 PM	1754 Florence Court	Johnstown	Pennsylvania
871772	9:00 AM - 5:00 PM	7804 Summerview Parkway	Washington	District of Columbia
\.


--
-- TOC entry 3780 (class 0 OID 16395)
-- Dependencies: 210
-- Data for Name: bank_account; Type: TABLE DATA; Schema: bank_v3; Owner: aryagoyal
--

COPY bank_v3.bank_account (acc_no, acc_type, ssn, balance) FROM stdin;
0279-6808-0475-7018	savings	421-06-0674	354672.49
0634-6008-5089-0042	savings	740-53-1660	248584.83
2040-3207-8177-0175	checkings	505-56-2364	349435.46
4432-4474-5427-9937	savings	885-10-9066	28151.83
4989-0839-7981-7646	checkings	513-20-8841	194827.41
6418-2280-2913-7885	checkings	512-38-6950	378561.59
7674-3966-2600-0176	savings	538-64-3169	364014.45
8576-8537-4845-8696	savings	864-17-2878	397014.6
9090-3282-6637-0732	savings	370-51-5387	258536.59
9618-0575-5694-9468	checkings	261-12-1948	162945.53
2358-6634-1380-2942	Savings	123-123-123	0
9959-3438-5084-4635	Savings	111-111-111	0
5988-3262-4683-9540	Savings	123456789	9265
8391-9798-8218-4089	Savings	929-629-581	4900
9832-9958-9456-7053	Savings	929-629-581	100
\.


--
-- TOC entry 3781 (class 0 OID 16400)
-- Dependencies: 211
-- Data for Name: bond; Type: TABLE DATA; Schema: bank_v3; Owner: aryagoyal
--

COPY bank_v3.bond (coupon_no, coupon_val, face_val, coupon_rate, bond_price, maturity, ytm, issue_date, trans_id) FROM stdin;
\.


--
-- TOC entry 3782 (class 0 OID 16403)
-- Dependencies: 212
-- Data for Name: card; Type: TABLE DATA; Schema: bank_v3; Owner: aryagoyal
--

COPY bank_v3.card (card_no, active_status, branch_no, ssn) FROM stdin;
0232-5597-7059-0724	activated	576546	261-12-1948
0778-4386-8709-4877	activated	871772	421-06-0674
4733-9321-1638-4993	activated	653853	864-17-2878
6313-3116-7374-3312	activated	531837	885-10-9066
7446-1880-0941-5663	deactivated	701300	513-20-8841
7489-9263-4709-3996	activated	788531	505-56-2364
7499-5616-1056-2989	activated	160780	538-64-3169
8127-3941-3167-6525	activated	187541	512-38-6950
8144-2513-4025-0907	activated	556240	740-53-1660
9740-3911-8216-0193	deactivated	161107	370-51-5387
\.


--
-- TOC entry 3783 (class 0 OID 16408)
-- Dependencies: 213
-- Data for Name: cash_investment; Type: TABLE DATA; Schema: bank_v3; Owner: aryagoyal
--

COPY bank_v3.cash_investment (receipt, inv_date, amt_inv, rate_offered, trans_id) FROM stdin;
176240	2023-01-24	35445	0.03	849839
200635	2023-11-03	36040	0.1	792965
252377	2023-08-17	15375	0.08	773976
310665	2023-09-25	13170	0.07	600076
367641	2023-04-13	21954	0.06	884493
382231	2023-01-12	36387	0.09	645152
455168	2023-02-19	33048	0.05	642046
806782	2023-03-24	35524	0.04	282406
810269	2023-04-09	31984	0.09	755732
837064	2023-04-14	30427	0.04	240089
\.


--
-- TOC entry 3784 (class 0 OID 16411)
-- Dependencies: 214
-- Data for Name: checking; Type: TABLE DATA; Schema: bank_v3; Owner: aryagoyal
--

COPY bank_v3.checking (acc_no, withdrawal_limit, fee) FROM stdin;
0279-6808-0475-7018	10000	14.25
0634-6008-5089-0042	10000	552.77
2040-3207-8177-0175	10000	354.89
4432-4474-5427-9937	10000	132.39
4989-0839-7981-7646	10000	945.85
6418-2280-2913-7885	10000	25.24
7674-3966-2600-0176	10000	697.84
8576-8537-4845-8696	10000	68.36
9090-3282-6637-0732	10000	922.32
9618-0575-5694-9468	10000	726.14
\.


--
-- TOC entry 3785 (class 0 OID 16414)
-- Dependencies: 215
-- Data for Name: client; Type: TABLE DATA; Schema: bank_v3; Owner: aryagoyal
--

COPY bank_v3.client (ssn, fname, lname, dob, email, phone, street, city, state) FROM stdin;
987-654-321	Gitesh	C	1993-11-11	gitesh@gmail.com	1234567890	2033, Lip Av	jersey	NJ
123-123-123	Rit	Deshpa	1999-10-10	rit@gmail.com	247823670	dgfafds	fagd	fdg
111-111-111	tiir	fger	1111-12-12	rit@gmai.com	1234567890	ghfgdh	gfhfgh	fghfg
123456789	Arya	Goyal	2012-01-10	aryagoyal1301@gmail.com	9296895849	1660 81st steet	Brooklyn	NY
929-629-581	Arya_test	Test	2008-05-19	aryagoyal1311@gmail.com	9296895555	84 romaine avenue	jersey city	NJ
\.


--
-- TOC entry 3786 (class 0 OID 16426)
-- Dependencies: 216
-- Data for Name: credit; Type: TABLE DATA; Schema: bank_v3; Owner: aryagoyal
--

COPY bank_v3.credit (card_no, card_rate, pay_deadline, fine_due, exp_date, cvv, fname, lname) FROM stdin;
\.


--
-- TOC entry 3787 (class 0 OID 16431)
-- Dependencies: 217
-- Data for Name: debit; Type: TABLE DATA; Schema: bank_v3; Owner: aryagoyal
--

COPY bank_v3.debit (card_no, exp_date, cvv, rem_balance, fname, lname) FROM stdin;
0232-5597-7059-0724	2028-05-14	919	8802.41	Nadeen	Jefferys
0778-4386-8709-4877	2027-04-10	162	9165.04	Jacob	Reichartz
7446-1880-0941-5663	2028-04-24	516	3821.64	Muire	Mallinar
\.


--
-- TOC entry 3788 (class 0 OID 16436)
-- Dependencies: 218
-- Data for Name: from_or_to; Type: TABLE DATA; Schema: bank_v3; Owner: aryagoyal
--

COPY bank_v3.from_or_to (index1, trans_id, acc_no) FROM stdin;
1	600076	0634-6008-5089-0042
2	884493	8576-8537-4845-8696
3	642046	7674-3966-2600-0176
4	240089	2040-3207-8177-0175
5	282406	6418-2280-2913-7885
6	773976	9090-3282-6637-0732
7	849839	4432-4474-5427-9937
8	755732	9618-0575-5694-9468
9	792965	4989-0839-7981-7646
10	645152	0279-6808-0475-7018
\.


--
-- TOC entry 3789 (class 0 OID 16440)
-- Dependencies: 219
-- Data for Name: issues; Type: TABLE DATA; Schema: bank_v3; Owner: aryagoyal
--

COPY bank_v3.issues (index2, coupon_no, branch_no) FROM stdin;
1	9037508365	556240
2	9249769065	653853
3	2099541890	160780
4	1298253429	788531
5	9898158824	187541
6	5058289974	161107
7	5724833533	531837
8	2236165534	576546
9	2647850241	701300
10	5072782034	871772
\.


--
-- TOC entry 3790 (class 0 OID 16443)
-- Dependencies: 220
-- Data for Name: loan; Type: TABLE DATA; Schema: bank_v3; Owner: aryagoyal
--

COPY bank_v3.loan (loan_id, loan_amt, payment_period, comp_period, branch_no, loan_date, apr, trans_id) FROM stdin;
218961	153630.52	Monthly	Monthly	531837	2020-06-17	\N	849839
539563	171548.66	Monthly	Monthly	871772	2021-01-30	\N	645152
569332	109548.97	Monthly	Monthly	556240	2020-08-09	\N	600076
598689	53797.3	Monthly	Monthly	701300	2021-04-29	\N	792965
613747	146012.38	Monthly	Monthly	160780	2022-03-22	\N	642046
641609	77658.68	Monthly	Yearly	187541	2020-10-09	\N	282406
690473	108275.11	Monthly	Quarterly	576546	2020-04-05	\N	755732
785583	189615.45	Monthly	Yearly	653853	2021-01-15	\N	884493
859014	133083.98	Monthly	Monthly	161107	2023-04-13	\N	773976
897480	105401.83	Monthly	Monthly	788531	2021-07-30	\N	240089
\.


--
-- TOC entry 3791 (class 0 OID 16448)
-- Dependencies: 221
-- Data for Name: money_value; Type: TABLE DATA; Schema: bank_v3; Owner: aryagoyal
--

COPY bank_v3.money_value (mv_id, inflation, tax_rate, ssn) FROM stdin;
1	0.02	0.06	740-53-1660
2	0.02	0.07	864-17-2878
3	0.02	0.05	538-64-3169
4	0.02	0.04	505-56-2364
5	0.02	0.06	512-38-6950
6	0.02	0.06	370-51-5387
7	0.02	0.06	885-10-9066
8	0.02	0.04	261-12-1948
9	0.02	0.04	513-20-8841
10	0.02	0.06	421-06-0674
\.


--
-- TOC entry 3792 (class 0 OID 16452)
-- Dependencies: 222
-- Data for Name: savings; Type: TABLE DATA; Schema: bank_v3; Owner: aryagoyal
--

COPY bank_v3.savings (acc_no, withdrawal_limit, fee) FROM stdin;
0279-6808-0475-7018	10000	856.27
0634-6008-5089-0042	10000	633.85
2040-3207-8177-0175	10000	254.96
4432-4474-5427-9937	10000	30.68
4989-0839-7981-7646	10000	655.98
6418-2280-2913-7885	10000	428.94
7674-3966-2600-0176	10000	198.61
8576-8537-4845-8696	10000	802.87
9090-3282-6637-0732	10000	987.46
9618-0575-5694-9468	10000	381.83
\.


--
-- TOC entry 3793 (class 0 OID 16455)
-- Dependencies: 223
-- Data for Name: transaction; Type: TABLE DATA; Schema: bank_v3; Owner: aryagoyal
--

COPY bank_v3.transaction (trans_id, trans_date, amount, type, ssn, from_acc, to_acc) FROM stdin;
\.


--
-- TOC entry 3794 (class 0 OID 16464)
-- Dependencies: 224
-- Data for Name: userdata; Type: TABLE DATA; Schema: bank_v3; Owner: aryagoyal
--

COPY bank_v3.userdata (id, username, password, email) FROM stdin;
8	gitesh	gitesh	gitesh@gmail.com
9	arya	arya	aryagoyal1301@gmail.com
\.


--
-- TOC entry 3802 (class 0 OID 0)
-- Dependencies: 225
-- Name: userdata_id_seq; Type: SEQUENCE SET; Schema: bank_v3; Owner: aryagoyal
--

SELECT pg_catalog.setval('bank_v3.userdata_id_seq', 10, true);


--
-- TOC entry 3607 (class 2606 OID 16470)
-- Name: bank_account bank_account_pkey; Type: CONSTRAINT; Schema: bank_v3; Owner: aryagoyal
--

ALTER TABLE ONLY bank_v3.bank_account
    ADD CONSTRAINT bank_account_pkey PRIMARY KEY (acc_no);


--
-- TOC entry 3605 (class 2606 OID 16472)
-- Name: bank bank_pkey; Type: CONSTRAINT; Schema: bank_v3; Owner: aryagoyal
--

ALTER TABLE ONLY bank_v3.bank
    ADD CONSTRAINT bank_pkey PRIMARY KEY (branch_no);


--
-- TOC entry 3609 (class 2606 OID 16474)
-- Name: bond bond_pkey; Type: CONSTRAINT; Schema: bank_v3; Owner: aryagoyal
--

ALTER TABLE ONLY bank_v3.bond
    ADD CONSTRAINT bond_pkey PRIMARY KEY (coupon_no);


--
-- TOC entry 3611 (class 2606 OID 16476)
-- Name: card card_pkey; Type: CONSTRAINT; Schema: bank_v3; Owner: aryagoyal
--

ALTER TABLE ONLY bank_v3.card
    ADD CONSTRAINT card_pkey PRIMARY KEY (card_no);


--
-- TOC entry 3613 (class 2606 OID 16478)
-- Name: cash_investment cash_investment_pkey; Type: CONSTRAINT; Schema: bank_v3; Owner: aryagoyal
--

ALTER TABLE ONLY bank_v3.cash_investment
    ADD CONSTRAINT cash_investment_pkey PRIMARY KEY (receipt);


--
-- TOC entry 3615 (class 2606 OID 16480)
-- Name: checking checking_pkey; Type: CONSTRAINT; Schema: bank_v3; Owner: aryagoyal
--

ALTER TABLE ONLY bank_v3.checking
    ADD CONSTRAINT checking_pkey PRIMARY KEY (acc_no);


--
-- TOC entry 3617 (class 2606 OID 16482)
-- Name: client client_pkey; Type: CONSTRAINT; Schema: bank_v3; Owner: aryagoyal
--

ALTER TABLE ONLY bank_v3.client
    ADD CONSTRAINT client_pkey PRIMARY KEY (ssn);


--
-- TOC entry 3619 (class 2606 OID 16484)
-- Name: credit credit_pkey; Type: CONSTRAINT; Schema: bank_v3; Owner: aryagoyal
--

ALTER TABLE ONLY bank_v3.credit
    ADD CONSTRAINT credit_pkey PRIMARY KEY (card_no);


--
-- TOC entry 3621 (class 2606 OID 16486)
-- Name: debit debit_pkey; Type: CONSTRAINT; Schema: bank_v3; Owner: aryagoyal
--

ALTER TABLE ONLY bank_v3.debit
    ADD CONSTRAINT debit_pkey PRIMARY KEY (card_no);


--
-- TOC entry 3623 (class 2606 OID 16488)
-- Name: from_or_to from_or_to_pkey; Type: CONSTRAINT; Schema: bank_v3; Owner: aryagoyal
--

ALTER TABLE ONLY bank_v3.from_or_to
    ADD CONSTRAINT from_or_to_pkey PRIMARY KEY (index1);


--
-- TOC entry 3625 (class 2606 OID 16490)
-- Name: issues issues_pkey; Type: CONSTRAINT; Schema: bank_v3; Owner: aryagoyal
--

ALTER TABLE ONLY bank_v3.issues
    ADD CONSTRAINT issues_pkey PRIMARY KEY (index2);


--
-- TOC entry 3627 (class 2606 OID 16492)
-- Name: loan loan_pkey; Type: CONSTRAINT; Schema: bank_v3; Owner: aryagoyal
--

ALTER TABLE ONLY bank_v3.loan
    ADD CONSTRAINT loan_pkey PRIMARY KEY (loan_id);


--
-- TOC entry 3629 (class 2606 OID 16494)
-- Name: money_value money_value_pkey; Type: CONSTRAINT; Schema: bank_v3; Owner: aryagoyal
--

ALTER TABLE ONLY bank_v3.money_value
    ADD CONSTRAINT money_value_pkey PRIMARY KEY (mv_id);


--
-- TOC entry 3631 (class 2606 OID 16496)
-- Name: savings savings_pkey; Type: CONSTRAINT; Schema: bank_v3; Owner: aryagoyal
--

ALTER TABLE ONLY bank_v3.savings
    ADD CONSTRAINT savings_pkey PRIMARY KEY (acc_no);


--
-- TOC entry 3633 (class 2606 OID 16498)
-- Name: transaction transaction_pkey; Type: CONSTRAINT; Schema: bank_v3; Owner: aryagoyal
--

ALTER TABLE ONLY bank_v3.transaction
    ADD CONSTRAINT transaction_pkey PRIMARY KEY (trans_id);


--
-- TOC entry 3635 (class 2606 OID 16500)
-- Name: userdata userdata_email_key; Type: CONSTRAINT; Schema: bank_v3; Owner: aryagoyal
--

ALTER TABLE ONLY bank_v3.userdata
    ADD CONSTRAINT userdata_email_key UNIQUE (email);


--
-- TOC entry 3637 (class 2606 OID 16502)
-- Name: userdata userdata_pkey; Type: CONSTRAINT; Schema: bank_v3; Owner: aryagoyal
--

ALTER TABLE ONLY bank_v3.userdata
    ADD CONSTRAINT userdata_pkey PRIMARY KEY (id);


--
-- TOC entry 3639 (class 2606 OID 16504)
-- Name: userdata userdata_username_key; Type: CONSTRAINT; Schema: bank_v3; Owner: aryagoyal
--

ALTER TABLE ONLY bank_v3.userdata
    ADD CONSTRAINT userdata_username_key UNIQUE (username);


-- Completed on 2024-12-20 15:54:13 EST

--
-- PostgreSQL database dump complete
--

