--
-- PostgreSQL database dump
--

-- Dumped from database version 14.15 (Homebrew)
-- Dumped by pg_dump version 17.0

-- Started on 2024-12-20 16:02:51 EST

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
-- TOC entry 3784 (class 0 OID 0)
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


-- Completed on 2024-12-20 16:02:51 EST

--
-- PostgreSQL database dump complete
--

