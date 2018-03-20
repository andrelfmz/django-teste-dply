--
-- PostgreSQL database cluster dump
--

SET default_transaction_read_only = off;

SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;

--
-- Drop databases
--





--
-- Drop roles
--

DROP ROLE postgres;


--
-- Roles
--

CREATE ROLE postgres;
ALTER ROLE postgres WITH SUPERUSER INHERIT CREATEROLE CREATEDB LOGIN REPLICATION BYPASSRLS PASSWORD 'md51a7d6d3ef29cef004c51a6b79913d121';






--
-- Database creation
--

REVOKE CONNECT,TEMPORARY ON DATABASE template1 FROM PUBLIC;
GRANT CONNECT ON DATABASE template1 TO PUBLIC;


\connect postgres

SET default_transaction_read_only = off;

--
-- PostgreSQL database dump
--

-- Dumped from database version 10.2 (Debian 10.2-1.pgdg90+1)
-- Dumped by pg_dump version 10.2 (Debian 10.2-1.pgdg90+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: DATABASE postgres; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON DATABASE postgres IS 'default administrative connection database';


--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

--
-- Name: fn_atualizar_estoque(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION fn_atualizar_estoque() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF (TG_OP = 'INSERT') THEN
    UPDATE LOGUS_PRODUTO SET ESTOQUE = ESTOQUE + NEW.QUANTIDADE WHERE ID = NEW.PRODUTO_ID;
    RETURN NEW;
  ELSIF (TG_OP = 'UPDATE') THEN
    IF (NEW.PRODUTO_ID = OLD.PRODUTO_ID) THEN
      UPDATE LOGUS_PRODUTO SET ESTOQUE = ESTOQUE + (NEW.QUANTIDADE - OLD.QUANTIDADE) WHERE ID = NEW.PRODUTO_ID; 
      RETURN NEW;
    ELSE
      UPDATE LOGUS_PRODUTO SET ESTOQUE = ESTOQUE - OLD.QUANTIDADE WHERE ID = OLD.PRODUTO_ID; 
      UPDATE LOGUS_PRODUTO SET ESTOQUE = ESTOQUE + NEW.QUANTIDADE WHERE ID = NEW.PRODUTO_ID;
      RETURN NEW;
    END IF;
  ELSIF (TG_OP = 'DELETE') THEN
    UPDATE LOGUS_PRODUTO SET ESTOQUE = ESTOQUE - OLD.QUANTIDADE WHERE ID = OLD.PRODUTO_ID; 
    RETURN OLD;
  END IF;
  RETURN NULL;
END$$;


ALTER FUNCTION public.fn_atualizar_estoque() OWNER TO postgres;

--
-- Name: fn_deletar_itens_entrada(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION fn_deletar_itens_entrada() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  DELETE FROM LOGUS_ITENSENTRADA WHERE ENTRADA_ID=OLD.ID;
  RETURN OLD;
END
$$;


ALTER FUNCTION public.fn_deletar_itens_entrada() OWNER TO postgres;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: auth_group; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE auth_group (
    id integer NOT NULL,
    name character varying(80) NOT NULL
);


ALTER TABLE auth_group OWNER TO postgres;

--
-- Name: auth_group_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE auth_group_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE auth_group_id_seq OWNER TO postgres;

--
-- Name: auth_group_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE auth_group_id_seq OWNED BY auth_group.id;


--
-- Name: auth_group_permissions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE auth_group_permissions (
    id integer NOT NULL,
    group_id integer NOT NULL,
    permission_id integer NOT NULL
);


ALTER TABLE auth_group_permissions OWNER TO postgres;

--
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE auth_group_permissions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE auth_group_permissions_id_seq OWNER TO postgres;

--
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE auth_group_permissions_id_seq OWNED BY auth_group_permissions.id;


--
-- Name: auth_permission; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE auth_permission (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    content_type_id integer NOT NULL,
    codename character varying(100) NOT NULL
);


ALTER TABLE auth_permission OWNER TO postgres;

--
-- Name: auth_permission_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE auth_permission_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE auth_permission_id_seq OWNER TO postgres;

--
-- Name: auth_permission_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE auth_permission_id_seq OWNED BY auth_permission.id;


--
-- Name: auth_user; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE auth_user (
    id integer NOT NULL,
    password character varying(128) NOT NULL,
    last_login timestamp with time zone,
    is_superuser boolean NOT NULL,
    username character varying(150) NOT NULL,
    first_name character varying(30) NOT NULL,
    last_name character varying(150) NOT NULL,
    email character varying(254) NOT NULL,
    is_staff boolean NOT NULL,
    is_active boolean NOT NULL,
    date_joined timestamp with time zone NOT NULL
);


ALTER TABLE auth_user OWNER TO postgres;

--
-- Name: auth_user_groups; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE auth_user_groups (
    id integer NOT NULL,
    user_id integer NOT NULL,
    group_id integer NOT NULL
);


ALTER TABLE auth_user_groups OWNER TO postgres;

--
-- Name: auth_user_groups_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE auth_user_groups_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE auth_user_groups_id_seq OWNER TO postgres;

--
-- Name: auth_user_groups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE auth_user_groups_id_seq OWNED BY auth_user_groups.id;


--
-- Name: auth_user_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE auth_user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE auth_user_id_seq OWNER TO postgres;

--
-- Name: auth_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE auth_user_id_seq OWNED BY auth_user.id;


--
-- Name: auth_user_user_permissions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE auth_user_user_permissions (
    id integer NOT NULL,
    user_id integer NOT NULL,
    permission_id integer NOT NULL
);


ALTER TABLE auth_user_user_permissions OWNER TO postgres;

--
-- Name: auth_user_user_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE auth_user_user_permissions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE auth_user_user_permissions_id_seq OWNER TO postgres;

--
-- Name: auth_user_user_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE auth_user_user_permissions_id_seq OWNED BY auth_user_user_permissions.id;


--
-- Name: django_admin_log; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE django_admin_log (
    id integer NOT NULL,
    action_time timestamp with time zone NOT NULL,
    object_id text,
    object_repr character varying(200) NOT NULL,
    action_flag smallint NOT NULL,
    change_message text NOT NULL,
    content_type_id integer,
    user_id integer NOT NULL,
    CONSTRAINT django_admin_log_action_flag_check CHECK ((action_flag >= 0))
);


ALTER TABLE django_admin_log OWNER TO postgres;

--
-- Name: django_admin_log_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE django_admin_log_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE django_admin_log_id_seq OWNER TO postgres;

--
-- Name: django_admin_log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE django_admin_log_id_seq OWNED BY django_admin_log.id;


--
-- Name: django_content_type; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE django_content_type (
    id integer NOT NULL,
    app_label character varying(100) NOT NULL,
    model character varying(100) NOT NULL
);


ALTER TABLE django_content_type OWNER TO postgres;

--
-- Name: django_content_type_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE django_content_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE django_content_type_id_seq OWNER TO postgres;

--
-- Name: django_content_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE django_content_type_id_seq OWNED BY django_content_type.id;


--
-- Name: django_migrations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE django_migrations (
    id integer NOT NULL,
    app character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    applied timestamp with time zone NOT NULL
);


ALTER TABLE django_migrations OWNER TO postgres;

--
-- Name: django_migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE django_migrations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE django_migrations_id_seq OWNER TO postgres;

--
-- Name: django_migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE django_migrations_id_seq OWNED BY django_migrations.id;


--
-- Name: django_session; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE django_session (
    session_key character varying(40) NOT NULL,
    session_data text NOT NULL,
    expire_date timestamp with time zone NOT NULL
);


ALTER TABLE django_session OWNER TO postgres;

--
-- Name: logus_entrada; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE logus_entrada (
    id integer NOT NULL,
    data date NOT NULL,
    valortotal numeric(10,2) NOT NULL,
    fornecedor_id integer NOT NULL
);


ALTER TABLE logus_entrada OWNER TO postgres;

--
-- Name: logus_entrada_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE logus_entrada_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE logus_entrada_id_seq OWNER TO postgres;

--
-- Name: logus_entrada_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE logus_entrada_id_seq OWNED BY logus_entrada.id;


--
-- Name: logus_familymember; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE logus_familymember (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    relationship character varying(100) NOT NULL,
    profile_id integer
);


ALTER TABLE logus_familymember OWNER TO postgres;

--
-- Name: logus_familymember_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE logus_familymember_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE logus_familymember_id_seq OWNER TO postgres;

--
-- Name: logus_familymember_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE logus_familymember_id_seq OWNED BY logus_familymember.id;


--
-- Name: logus_fornecedor; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE logus_fornecedor (
    id integer NOT NULL,
    nome character varying(100) NOT NULL,
    email character varying(254) NOT NULL,
    fone1 character varying(20) NOT NULL,
    fone2 character varying(20) NOT NULL,
    data_pub date NOT NULL,
    tipo character varying(1) NOT NULL
);


ALTER TABLE logus_fornecedor OWNER TO postgres;

--
-- Name: logus_fornecedor_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE logus_fornecedor_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE logus_fornecedor_id_seq OWNER TO postgres;

--
-- Name: logus_fornecedor_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE logus_fornecedor_id_seq OWNED BY logus_fornecedor.id;


--
-- Name: logus_itensentrada; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE logus_itensentrada (
    id integer NOT NULL,
    quantidade numeric(10,3) NOT NULL,
    entrada_id integer NOT NULL,
    produto_id integer NOT NULL,
    valoru numeric(10,2) NOT NULL,
    valort numeric(10,2) NOT NULL
);


ALTER TABLE logus_itensentrada OWNER TO postgres;

--
-- Name: logus_itensentrada_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE logus_itensentrada_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE logus_itensentrada_id_seq OWNER TO postgres;

--
-- Name: logus_itensentrada_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE logus_itensentrada_id_seq OWNED BY logus_itensentrada.id;


--
-- Name: logus_produto; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE logus_produto (
    id integer NOT NULL,
    descricao character varying(50) NOT NULL,
    valor numeric(10,2) NOT NULL,
    estoque numeric(10,3) NOT NULL
);


ALTER TABLE logus_produto OWNER TO postgres;

--
-- Name: logus_produto_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE logus_produto_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE logus_produto_id_seq OWNER TO postgres;

--
-- Name: logus_produto_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE logus_produto_id_seq OWNED BY logus_produto.id;


--
-- Name: logus_profile; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE logus_profile (
    id integer NOT NULL,
    first_name character varying(100) NOT NULL,
    last_name character varying(100) NOT NULL,
    created_date timestamp with time zone NOT NULL
);


ALTER TABLE logus_profile OWNER TO postgres;

--
-- Name: logus_profile_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE logus_profile_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE logus_profile_id_seq OWNER TO postgres;

--
-- Name: logus_profile_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE logus_profile_id_seq OWNED BY logus_profile.id;


--
-- Name: auth_group id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY auth_group ALTER COLUMN id SET DEFAULT nextval('auth_group_id_seq'::regclass);


--
-- Name: auth_group_permissions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY auth_group_permissions ALTER COLUMN id SET DEFAULT nextval('auth_group_permissions_id_seq'::regclass);


--
-- Name: auth_permission id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY auth_permission ALTER COLUMN id SET DEFAULT nextval('auth_permission_id_seq'::regclass);


--
-- Name: auth_user id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY auth_user ALTER COLUMN id SET DEFAULT nextval('auth_user_id_seq'::regclass);


--
-- Name: auth_user_groups id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY auth_user_groups ALTER COLUMN id SET DEFAULT nextval('auth_user_groups_id_seq'::regclass);


--
-- Name: auth_user_user_permissions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY auth_user_user_permissions ALTER COLUMN id SET DEFAULT nextval('auth_user_user_permissions_id_seq'::regclass);


--
-- Name: django_admin_log id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY django_admin_log ALTER COLUMN id SET DEFAULT nextval('django_admin_log_id_seq'::regclass);


--
-- Name: django_content_type id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY django_content_type ALTER COLUMN id SET DEFAULT nextval('django_content_type_id_seq'::regclass);


--
-- Name: django_migrations id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY django_migrations ALTER COLUMN id SET DEFAULT nextval('django_migrations_id_seq'::regclass);


--
-- Name: logus_entrada id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY logus_entrada ALTER COLUMN id SET DEFAULT nextval('logus_entrada_id_seq'::regclass);


--
-- Name: logus_familymember id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY logus_familymember ALTER COLUMN id SET DEFAULT nextval('logus_familymember_id_seq'::regclass);


--
-- Name: logus_fornecedor id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY logus_fornecedor ALTER COLUMN id SET DEFAULT nextval('logus_fornecedor_id_seq'::regclass);


--
-- Name: logus_itensentrada id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY logus_itensentrada ALTER COLUMN id SET DEFAULT nextval('logus_itensentrada_id_seq'::regclass);


--
-- Name: logus_produto id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY logus_produto ALTER COLUMN id SET DEFAULT nextval('logus_produto_id_seq'::regclass);


--
-- Name: logus_profile id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY logus_profile ALTER COLUMN id SET DEFAULT nextval('logus_profile_id_seq'::regclass);


--
-- Data for Name: auth_group; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY auth_group (id, name) FROM stdin;
2	Almoxarife
\.


--
-- Data for Name: auth_group_permissions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY auth_group_permissions (id, group_id, permission_id) FROM stdin;
8	2	28
9	2	29
12	2	42
13	2	47
\.


--
-- Data for Name: auth_permission; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY auth_permission (id, name, content_type_id, codename) FROM stdin;
1	Can add log entry	1	add_logentry
2	Can change log entry	1	change_logentry
3	Can delete log entry	1	delete_logentry
4	Can add user	2	add_user
5	Can change user	2	change_user
6	Can delete user	2	delete_user
7	Can add permission	3	add_permission
8	Can change permission	3	change_permission
9	Can delete permission	3	delete_permission
10	Can add group	4	add_group
11	Can change group	4	change_group
12	Can delete group	4	delete_group
13	Can add content type	5	add_contenttype
14	Can change content type	5	change_contenttype
15	Can delete content type	5	delete_contenttype
16	Can add session	6	add_session
17	Can change session	6	change_session
18	Can delete session	6	delete_session
19	Can add family member	7	add_familymember
20	Can change family member	7	change_familymember
21	Can delete family member	7	delete_familymember
22	Can add entrada	8	add_entrada
23	Can change entrada	8	change_entrada
24	Can delete entrada	8	delete_entrada
25	Can add profile	9	add_profile
26	Can change profile	9	change_profile
27	Can delete profile	9	delete_profile
28	Can add fornecedor	10	add_fornecedor
29	Can change fornecedor	10	change_fornecedor
30	Can delete fornecedor	10	delete_fornecedor
31	Can add produto	11	add_produto
32	Can change produto	11	change_produto
33	Can delete produto	11	delete_produto
34	Can add itens entrada	12	add_itensentrada
35	Can change itens entrada	12	change_itensentrada
36	Can delete itens entrada	12	delete_itensentrada
42	Permitir listar fornecedores	10	list_fornecedor
43	Can add user profile	13	add_userprofile
44	Can change user profile	13	change_userprofile
45	Can delete user profile	13	delete_userprofile
46	Permitir listar produtos	11	list_produto
47	Permitir listar entradas	8	list_entrada
\.


--
-- Data for Name: auth_user; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY auth_user (id, password, last_login, is_superuser, username, first_name, last_name, email, is_staff, is_active, date_joined) FROM stdin;
5	pbkdf2_sha256$100000$36EkO8iQUfjd$3oa61X800e7Q6rNzB3/8rObk59TxIx6ybWkj5ZK1W8M=	2018-03-12 11:42:27.41663+00	f	rodrigo			maltarodrigo@hotmail.com	f	t	2018-03-09 11:56:05+00
4	pbkdf2_sha256$100000$dniKMyutolGG$FilkIBKToX0yE+kWK7iXW1h9pUIds5sgAR+YgGCd39s=	2018-03-12 12:39:51.645749+00	f	teste			andrelfmz@hotmail.com	f	t	2018-03-04 19:45:54+00
3	pbkdf2_sha256$100000$vExhGPHjKxO4$4AwDihOCTGqeC8lIbWg1+o9QHCNzbxqJ/paZNm5Vlzg=	2018-03-17 18:42:05.088756+00	t	admin				t	t	2018-03-02 16:54:39.406604+00
6	pbkdf2_sha256$100000$skNSqk1FauPc$I1ttIWP+O7+a5sDNi9PWA0EBHo+3VoTij2oKqQoeZcA=	\N	f	teste2				f	t	2018-03-09 12:47:08+00
\.


--
-- Data for Name: auth_user_groups; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY auth_user_groups (id, user_id, group_id) FROM stdin;
2	4	2
3	5	2
\.


--
-- Data for Name: auth_user_user_permissions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY auth_user_user_permissions (id, user_id, permission_id) FROM stdin;
\.


--
-- Data for Name: django_admin_log; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY django_admin_log (id, action_time, object_id, object_repr, action_flag, change_message, content_type_id, user_id) FROM stdin;
3	2018-03-04 19:45:54.766126+00	4	teste	1	[{"added": {}}]	2	3
4	2018-03-07 19:32:59.839992+00	1	entradas	1	[{"added": {}}]	4	3
5	2018-03-07 19:33:18.239876+00	4	teste	2	[{"changed": {"fields": ["groups"]}}]	2	3
6	2018-03-08 00:05:33.538818+00	4	teste	2	[{"changed": {"fields": ["groups"]}}]	2	3
7	2018-03-08 00:05:47.483714+00	1	entradas	3		4	3
8	2018-03-08 13:25:17.815321+00	4	teste	2	[{"changed": {"fields": ["user_permissions"]}}]	2	3
9	2018-03-08 13:37:25.524324+00	4	teste	2	[{"changed": {"fields": ["user_permissions"]}}]	2	3
10	2018-03-08 13:45:50.180762+00	4	teste	2	[{"changed": {"fields": ["user_permissions"]}}]	2	3
11	2018-03-08 13:50:10.458725+00	4	teste	2	[{"changed": {"fields": ["user_permissions"]}}]	2	3
12	2018-03-08 14:04:47.596465+00	4	teste	2	[{"changed": {"fields": ["user_permissions"]}}]	2	3
13	2018-03-08 14:06:29.624887+00	4	teste	2	[{"changed": {"fields": ["user_permissions"]}}]	2	3
14	2018-03-08 14:08:09.689388+00	4	teste	2	[{"changed": {"fields": ["user_permissions"]}}]	2	3
15	2018-03-08 14:15:32.087938+00	4	teste	2	[{"changed": {"fields": ["user_permissions"]}}]	2	3
16	2018-03-08 14:17:47.300465+00	4	teste	2	[{"changed": {"fields": ["user_permissions"]}}]	2	3
17	2018-03-08 14:19:14.620181+00	4	teste	2	[{"changed": {"fields": ["user_permissions"]}}]	2	3
18	2018-03-08 15:09:14.170149+00	4	teste	2	[{"changed": {"fields": ["is_active"]}}]	2	3
19	2018-03-08 15:11:13.046692+00	4	teste	2	[{"changed": {"fields": ["is_active"]}}]	2	3
20	2018-03-08 15:12:36.656899+00	2	Almoxarife	1	[{"added": {}}]	4	3
21	2018-03-08 15:12:51.445807+00	4	teste	2	[{"changed": {"fields": ["groups", "user_permissions"]}}]	2	3
22	2018-03-08 15:15:34.51023+00	2	Almoxarife	2	[{"changed": {"fields": ["permissions"]}}]	4	3
23	2018-03-08 16:38:28.341262+00	2	Almoxarife	2	[{"changed": {"fields": ["permissions"]}}]	4	3
24	2018-03-09 11:50:06.368738+00	4	teste	2	[{"changed": {"fields": ["is_staff"]}}]	2	3
25	2018-03-09 11:53:30.541531+00	4	teste	2	[{"changed": {"fields": ["is_staff"]}}]	2	3
26	2018-03-09 11:56:05.329239+00	5	rodrigo	1	[{"added": {}}]	2	3
27	2018-03-09 12:03:31.497457+00	5	rodrigo	2	[{"changed": {"fields": ["groups"]}}]	2	3
28	2018-03-09 12:26:13.536865+00	5	rodrigo	2	[{"changed": {"fields": ["is_active"]}}]	2	3
29	2018-03-09 12:30:36.752365+00	5	rodrigo	2	[{"changed": {"fields": ["is_active"]}}]	2	3
30	2018-03-09 12:47:08.255501+00	6	teste2	1	[{"added": {}}]	2	3
31	2018-03-09 12:47:37.432235+00	6	teste2	2	[]	2	3
32	2018-03-09 13:23:12.575201+00	4	teste	2	[{"changed": {"fields": ["last_login"]}}]	2	3
33	2018-03-09 18:56:50.888604+00	1	UserProfile object (1)	1	[{"added": {}}]	13	3
34	2018-03-09 18:56:57.924971+00	2	UserProfile object (2)	1	[{"added": {}}]	13	3
35	2018-03-09 18:57:19.370059+00	1	UserProfile object (1)	3		13	3
36	2018-03-09 19:07:06.762328+00	2	UserProfile object (2)	2	[]	13	3
37	2018-03-09 21:58:42.452257+00	4	teste	2	[{"changed": {"fields": ["email"]}}]	2	3
38	2018-03-12 11:19:47.068885+00	2	Almoxarife	2	[{"changed": {"fields": ["permissions"]}}]	4	3
39	2018-03-12 11:21:18.267153+00	2	Almoxarife	2	[]	4	3
40	2018-03-12 11:22:24.706166+00	2	Almoxarife	2	[{"changed": {"fields": ["permissions"]}}]	4	3
41	2018-03-12 11:23:39.848082+00	5	rodrigo	2	[{"changed": {"fields": ["email"]}}]	2	3
42	2018-03-12 12:41:21.507009+00	2	Almoxarife	2	[{"changed": {"fields": ["permissions"]}}]	4	3
\.


--
-- Data for Name: django_content_type; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY django_content_type (id, app_label, model) FROM stdin;
1	admin	logentry
2	auth	user
3	auth	permission
4	auth	group
5	contenttypes	contenttype
6	sessions	session
7	logus	familymember
8	logus	entrada
9	logus	profile
10	logus	fornecedor
11	logus	produto
12	logus	itensentrada
13	logus	userprofile
\.


--
-- Data for Name: django_migrations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY django_migrations (id, app, name, applied) FROM stdin;
1	contenttypes	0001_initial	2018-02-28 17:32:43.828363+00
2	auth	0001_initial	2018-02-28 17:32:44.087155+00
3	admin	0001_initial	2018-02-28 17:32:44.179095+00
4	admin	0002_logentry_remove_auto_add	2018-02-28 17:32:44.209353+00
5	contenttypes	0002_remove_content_type_name	2018-02-28 17:32:44.239586+00
6	auth	0002_alter_permission_name_max_length	2018-02-28 17:32:44.256684+00
7	auth	0003_alter_user_email_max_length	2018-02-28 17:32:44.276103+00
8	auth	0004_alter_user_username_opts	2018-02-28 17:32:44.293452+00
9	auth	0005_alter_user_last_login_null	2018-02-28 17:32:44.312375+00
10	auth	0006_require_contenttypes_0002	2018-02-28 17:32:44.317637+00
11	auth	0007_alter_validators_add_error_messages	2018-02-28 17:32:44.339282+00
12	auth	0008_alter_user_username_max_length	2018-02-28 17:32:44.381245+00
13	auth	0009_alter_user_last_name_max_length	2018-02-28 17:32:44.40757+00
14	logus	0001_initial	2018-02-28 17:32:44.518365+00
15	logus	0002_auto_20171111_1640	2018-02-28 17:32:44.620576+00
16	logus	0003_auto_20171111_1833	2018-02-28 17:32:44.653974+00
17	logus	0004_auto_20171111_1916	2018-02-28 17:32:44.668909+00
18	logus	0005_remove_itensentrada_valort	2018-02-28 17:32:44.682098+00
19	logus	0006_itensentrada__valort	2018-02-28 17:32:44.725988+00
20	logus	0007_auto_20171113_1510	2018-02-28 17:32:44.754748+00
21	logus	0008_auto_20171117_1349	2018-02-28 17:32:44.778835+00
22	logus	0009_auto_20171117_1349	2018-02-28 17:32:44.788924+00
23	logus	0010_auto_20171117_1350	2018-02-28 17:32:44.806296+00
24	logus	0011_auto_20171117_1350	2018-02-28 17:32:44.817155+00
25	logus	0012_auto_20171120_2115	2018-02-28 17:32:44.838439+00
26	logus	0013_auto_20171120_2214	2018-02-28 17:32:44.853007+00
27	logus	0014_auto_20171120_2216	2018-02-28 17:32:44.864233+00
28	logus	0015_auto_20171204_0926	2018-02-28 17:32:44.917875+00
29	logus	0016_auto_20171204_1121	2018-02-28 17:32:45.124952+00
30	logus	0017_auto_20171204_1541	2018-02-28 17:32:45.175143+00
31	logus	0018_auto_20171206_1103	2018-02-28 17:32:45.223522+00
32	logus	0019_auto_20171206_1507	2018-02-28 17:32:45.258449+00
33	logus	0020_auto_20171206_1525	2018-02-28 17:32:45.306897+00
34	logus	0021_auto_20171206_1537	2018-02-28 17:32:45.361263+00
35	logus	0022_auto_20171207_1907	2018-02-28 17:32:45.38475+00
36	logus	0023_auto_20171207_1913	2018-02-28 17:32:45.408032+00
37	logus	0024_auto_20171214_1402	2018-02-28 17:32:45.465208+00
38	logus	0025_auto_20171226_1004	2018-02-28 17:32:45.501907+00
39	sessions	0001_initial	2018-02-28 17:32:45.555982+00
40	logus	0026_auto_20180308_1029	2018-03-08 13:30:11.785657+00
41	logus	0027_auto_20180308_1034	2018-03-08 13:34:46.337362+00
42	logus	0028_auto_20180308_1039	2018-03-08 13:39:26.670206+00
43	logus	0029_auto_20180308_1103	2018-03-08 14:03:16.440065+00
44	logus	0030_userprofile	2018-03-09 18:53:15.781543+00
45	logus	0031_auto_20180309_1552	2018-03-09 18:53:15.932141+00
46	logus	0032_auto_20180309_1630	2018-03-09 19:30:56.832618+00
47	logus	0033_auto_20180311_2213	2018-03-12 01:13:21.474338+00
\.


--
-- Data for Name: django_session; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY django_session (session_key, session_data, expire_date) FROM stdin;
zst1kp4agk8rd0xfc3ger2lz0wxt91s5	MmFhZTRmMzk0NzViZDcxYWFkZWMwMzEzNDRmZTQyMGVjNWEzYzFkYTp7Il9hdXRoX3VzZXJfaWQiOiIzIiwiX2F1dGhfdXNlcl9iYWNrZW5kIjoiZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5kcy5Nb2RlbEJhY2tlbmQiLCJfYXV0aF91c2VyX2hhc2giOiJjM2VlNTI4M2VhMTlkN2UyNzNhY2Y2N2YxMDM0Y2QyYjQwYjY4NTBkIn0=	2018-03-05 17:08:31.290336+00
719k9nk8o6g8tyaf69nobvom2k124df1	YWM1ZDBmYWI3NGYwNWQ2OTc0MGY5NzhjNGFkM2NiYTc5ZTE2MGZmYjp7Il9hdXRoX3VzZXJfaGFzaCI6ImMzZWU1MjgzZWExOWQ3ZTI3M2FjZjY3ZjEwMzRjZDJiNDBiNjg1MGQiLCJfYXV0aF91c2VyX2lkIjoiMyIsIl9hdXRoX3VzZXJfYmFja2VuZCI6ImRqYW5nby5jb250cmliLmF1dGguYmFja2VuZHMuTW9kZWxCYWNrZW5kIn0=	2018-03-09 15:53:26.6379+00
gm0s2b1yopxn3mo9pn8j4ktn1o8s4b95	ZjZjNjQ1NzZkNWVmNmNiOTkwZjE1NmI1YzBmMGVjMDg5MWUwNDIzMjp7Il9hdXRoX3VzZXJfYmFja2VuZCI6ImRqYW5nby5jb250cmliLmF1dGguYmFja2VuZHMuTW9kZWxCYWNrZW5kIiwiX2F1dGhfdXNlcl9pZCI6IjMiLCJfYXV0aF91c2VyX2hhc2giOiJjM2VlNTI4M2VhMTlkN2UyNzNhY2Y2N2YxMDM0Y2QyYjQwYjY4NTBkIn0=	2018-03-05 17:19:20.970186+00
a3xk6ad8vpu55xoyhzuvkziv2za9m417	ZjZjNjQ1NzZkNWVmNmNiOTkwZjE1NmI1YzBmMGVjMDg5MWUwNDIzMjp7Il9hdXRoX3VzZXJfYmFja2VuZCI6ImRqYW5nby5jb250cmliLmF1dGguYmFja2VuZHMuTW9kZWxCYWNrZW5kIiwiX2F1dGhfdXNlcl9pZCI6IjMiLCJfYXV0aF91c2VyX2hhc2giOiJjM2VlNTI4M2VhMTlkN2UyNzNhY2Y2N2YxMDM0Y2QyYjQwYjY4NTBkIn0=	2018-03-18 20:04:24.653893+00
i6w7pwn8k22hp6idb1k9po3j2exvr8fg	N2VkNTUwZDdkOWQzM2YzMDliMjRkZGVhMzUxOGZmZDczNzViNmM3MDp7Il9hdXRoX3VzZXJfYmFja2VuZCI6ImRqYW5nby5jb250cmliLmF1dGguYmFja2VuZHMuTW9kZWxCYWNrZW5kIiwiX2F1dGhfdXNlcl9pZCI6IjQiLCJfYXV0aF91c2VyX2hhc2giOiIxZGE3NDZlNWY4YzRlOTVmNzU3MDEyMTMzNGE2ODYzYzhjMGFiNzg2In0=	2018-03-18 20:22:05.948013+00
22sxnj6c9o97tsvkjjyw64i15htby3j2	YWM1ZDBmYWI3NGYwNWQ2OTc0MGY5NzhjNGFkM2NiYTc5ZTE2MGZmYjp7Il9hdXRoX3VzZXJfaGFzaCI6ImMzZWU1MjgzZWExOWQ3ZTI3M2FjZjY3ZjEwMzRjZDJiNDBiNjg1MGQiLCJfYXV0aF91c2VyX2lkIjoiMyIsIl9hdXRoX3VzZXJfYmFja2VuZCI6ImRqYW5nby5jb250cmliLmF1dGguYmFja2VuZHMuTW9kZWxCYWNrZW5kIn0=	2018-03-17 16:43:14.632192+00
8vfnp2fissg6ei0l73nwzbvc86pgbl0j	YWM1ZDBmYWI3NGYwNWQ2OTc0MGY5NzhjNGFkM2NiYTc5ZTE2MGZmYjp7Il9hdXRoX3VzZXJfaGFzaCI6ImMzZWU1MjgzZWExOWQ3ZTI3M2FjZjY3ZjEwMzRjZDJiNDBiNjg1MGQiLCJfYXV0aF91c2VyX2lkIjoiMyIsIl9hdXRoX3VzZXJfYmFja2VuZCI6ImRqYW5nby5jb250cmliLmF1dGguYmFja2VuZHMuTW9kZWxCYWNrZW5kIn0=	2018-03-16 20:31:10.26926+00
m7za0x4l5n0uclf5uelteiybii2q7s6e	ZGQ5YWY5OGVmODYzNDBjYWZiMzZkZjY4NTk4MGM1ZWMyZTMwYWVmYzp7Il9hdXRoX3VzZXJfaGFzaCI6ImMzZWU1MjgzZWExOWQ3ZTI3M2FjZjY3ZjEwMzRjZDJiNDBiNjg1MGQiLCJfYXV0aF91c2VyX2JhY2tlbmQiOiJkamFuZ28uY29udHJpYi5hdXRoLmJhY2tlbmRzLk1vZGVsQmFja2VuZCIsIl9hdXRoX3VzZXJfaWQiOiIzIn0=	2018-03-06 12:04:21.586856+00
c5k1v6qnrdnjxhceh2olq6dexeoaqohq	ZGQ5YWY5OGVmODYzNDBjYWZiMzZkZjY4NTk4MGM1ZWMyZTMwYWVmYzp7Il9hdXRoX3VzZXJfaGFzaCI6ImMzZWU1MjgzZWExOWQ3ZTI3M2FjZjY3ZjEwMzRjZDJiNDBiNjg1MGQiLCJfYXV0aF91c2VyX2JhY2tlbmQiOiJkamFuZ28uY29udHJpYi5hdXRoLmJhY2tlbmRzLk1vZGVsQmFja2VuZCIsIl9hdXRoX3VzZXJfaWQiOiIzIn0=	2018-03-06 15:10:36.437216+00
zwxwaxxfhl7oz8j1eodnz65gi6makhyl	ZGQ5YWY5OGVmODYzNDBjYWZiMzZkZjY4NTk4MGM1ZWMyZTMwYWVmYzp7Il9hdXRoX3VzZXJfaGFzaCI6ImMzZWU1MjgzZWExOWQ3ZTI3M2FjZjY3ZjEwMzRjZDJiNDBiNjg1MGQiLCJfYXV0aF91c2VyX2JhY2tlbmQiOiJkamFuZ28uY29udHJpYi5hdXRoLmJhY2tlbmRzLk1vZGVsQmFja2VuZCIsIl9hdXRoX3VzZXJfaWQiOiIzIn0=	2018-03-06 17:34:16.393607+00
1nnd5vk27bsve0idnj4kl7og7g9nznmk	ODlhZGM3NWVmMjZiYmM4YjgzMDE1NGJhYWU4OGU4OWY3YjMzZjY1OTp7Il9hdXRoX3VzZXJfaWQiOiIzIiwiX2F1dGhfdXNlcl9oYXNoIjoiYzNlZTUyODNlYTE5ZDdlMjczYWNmNjdmMTAzNGNkMmI0MGI2ODUwZCIsIl9hdXRoX3VzZXJfYmFja2VuZCI6ImRqYW5nby5jb250cmliLmF1dGguYmFja2VuZHMuTW9kZWxCYWNrZW5kIn0=	2018-03-12 13:41:21.811906+00
st3n2oc41ahxlug28thufols7oyvfpfm	MmFhZTRmMzk0NzViZDcxYWFkZWMwMzEzNDRmZTQyMGVjNWEzYzFkYTp7Il9hdXRoX3VzZXJfaWQiOiIzIiwiX2F1dGhfdXNlcl9iYWNrZW5kIjoiZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5kcy5Nb2RlbEJhY2tlbmQiLCJfYXV0aF91c2VyX2hhc2giOiJjM2VlNTI4M2VhMTlkN2UyNzNhY2Y2N2YxMDM0Y2QyYjQwYjY4NTBkIn0=	2018-03-08 12:33:42.084802+00
07904zth6t5rxj6m16v8ykjnkltp483f	NWM4MTExZGY1OTBjMjUzNDQ1OGUzM2ZmMmVlYmVmOGU2NmU3ZWVjZDp7Il9hdXRoX3VzZXJfYmFja2VuZCI6ImRqYW5nby5jb250cmliLmF1dGguYmFja2VuZHMuTW9kZWxCYWNrZW5kIiwiX2F1dGhfdXNlcl9pZCI6IjQiLCJfYXV0aF91c2VyX2hhc2giOiJhZmIyZTVkZGI1YjBlMWQ0OWMxODA5ZTI2NDZkYzFkNDJjM2ZjOTAyIn0=	2018-03-05 17:01:00.320909+00
ug8lsrtaxqxuhzm05p5adt7t9vuk98ng	ZjZjNjQ1NzZkNWVmNmNiOTkwZjE1NmI1YzBmMGVjMDg5MWUwNDIzMjp7Il9hdXRoX3VzZXJfYmFja2VuZCI6ImRqYW5nby5jb250cmliLmF1dGguYmFja2VuZHMuTW9kZWxCYWNrZW5kIiwiX2F1dGhfdXNlcl9pZCI6IjMiLCJfYXV0aF91c2VyX2hhc2giOiJjM2VlNTI4M2VhMTlkN2UyNzNhY2Y2N2YxMDM0Y2QyYjQwYjY4NTBkIn0=	2018-03-05 17:01:49.012972+00
0dbp4mun0ndmrpj8fgoszxyl02p737id	NjA3Y2M5ZjI0OTFkNDQxNTgwZDQwYWM2MTA0ZjE2ZjMzOGQ0ZDljZjp7Il9hdXRoX3VzZXJfaWQiOiI0IiwiX2F1dGhfdXNlcl9oYXNoIjoiYWZiMmU1ZGRiNWIwZTFkNDljMTgwOWUyNjQ2ZGMxZDQyYzNmYzkwMiIsIl9hdXRoX3VzZXJfYmFja2VuZCI6ImRqYW5nby5jb250cmliLmF1dGguYmFja2VuZHMuTW9kZWxCYWNrZW5kIn0=	2018-03-09 12:42:29.275914+00
558mcr56va38una3ng3aace6192vf1ck	ZjZjNjQ1NzZkNWVmNmNiOTkwZjE1NmI1YzBmMGVjMDg5MWUwNDIzMjp7Il9hdXRoX3VzZXJfYmFja2VuZCI6ImRqYW5nby5jb250cmliLmF1dGguYmFja2VuZHMuTW9kZWxCYWNrZW5kIiwiX2F1dGhfdXNlcl9pZCI6IjMiLCJfYXV0aF91c2VyX2hhc2giOiJjM2VlNTI4M2VhMTlkN2UyNzNhY2Y2N2YxMDM0Y2QyYjQwYjY4NTBkIn0=	2018-03-05 17:02:24.805715+00
hc9uhjz7ezlgl3qzkffbr3q7jw6dyqw4	NjA3Y2M5ZjI0OTFkNDQxNTgwZDQwYWM2MTA0ZjE2ZjMzOGQ0ZDljZjp7Il9hdXRoX3VzZXJfaWQiOiI0IiwiX2F1dGhfdXNlcl9oYXNoIjoiYWZiMmU1ZGRiNWIwZTFkNDljMTgwOWUyNjQ2ZGMxZDQyYzNmYzkwMiIsIl9hdXRoX3VzZXJfYmFja2VuZCI6ImRqYW5nby5jb250cmliLmF1dGguYmFja2VuZHMuTW9kZWxCYWNrZW5kIn0=	2018-03-08 18:34:54.096432+00
ilypgdijcihekz78kxwane97e6k6x4x8	MmFhZTRmMzk0NzViZDcxYWFkZWMwMzEzNDRmZTQyMGVjNWEzYzFkYTp7Il9hdXRoX3VzZXJfaWQiOiIzIiwiX2F1dGhfdXNlcl9iYWNrZW5kIjoiZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5kcy5Nb2RlbEJhY2tlbmQiLCJfYXV0aF91c2VyX2hhc2giOiJjM2VlNTI4M2VhMTlkN2UyNzNhY2Y2N2YxMDM0Y2QyYjQwYjY4NTBkIn0=	2018-03-05 17:08:09.356162+00
qzwgvgcr7zfc5vpnlxacxm7rxnkiebq5	ODlhZGM3NWVmMjZiYmM4YjgzMDE1NGJhYWU4OGU4OWY3YjMzZjY1OTp7Il9hdXRoX3VzZXJfaWQiOiIzIiwiX2F1dGhfdXNlcl9oYXNoIjoiYzNlZTUyODNlYTE5ZDdlMjczYWNmNjdmMTAzNGNkMmI0MGI2ODUwZCIsIl9hdXRoX3VzZXJfYmFja2VuZCI6ImRqYW5nby5jb250cmliLmF1dGguYmFja2VuZHMuTW9kZWxCYWNrZW5kIn0=	2018-03-05 21:09:42.201648+00
oppt25da31h72qyti9onbeycf672j1cj	ZGQ5YWY5OGVmODYzNDBjYWZiMzZkZjY4NTk4MGM1ZWMyZTMwYWVmYzp7Il9hdXRoX3VzZXJfaGFzaCI6ImMzZWU1MjgzZWExOWQ3ZTI3M2FjZjY3ZjEwMzRjZDJiNDBiNjg1MGQiLCJfYXV0aF91c2VyX2JhY2tlbmQiOiJkamFuZ28uY29udHJpYi5hdXRoLmJhY2tlbmRzLk1vZGVsQmFja2VuZCIsIl9hdXRoX3VzZXJfaWQiOiIzIn0=	2018-03-06 20:57:53.430187+00
jv6j1y35iabqrsoz42qzc084570rjnpj	ZjZjNjQ1NzZkNWVmNmNiOTkwZjE1NmI1YzBmMGVjMDg5MWUwNDIzMjp7Il9hdXRoX3VzZXJfYmFja2VuZCI6ImRqYW5nby5jb250cmliLmF1dGguYmFja2VuZHMuTW9kZWxCYWNrZW5kIiwiX2F1dGhfdXNlcl9pZCI6IjMiLCJfYXV0aF91c2VyX2hhc2giOiJjM2VlNTI4M2VhMTlkN2UyNzNhY2Y2N2YxMDM0Y2QyYjQwYjY4NTBkIn0=	2018-03-08 01:07:50.960002+00
psdtzgdwtag9ys6fprd15z6gxazmwzsj	ZGQ5YWY5OGVmODYzNDBjYWZiMzZkZjY4NTk4MGM1ZWMyZTMwYWVmYzp7Il9hdXRoX3VzZXJfaGFzaCI6ImMzZWU1MjgzZWExOWQ3ZTI3M2FjZjY3ZjEwMzRjZDJiNDBiNjg1MGQiLCJfYXV0aF91c2VyX2JhY2tlbmQiOiJkamFuZ28uY29udHJpYi5hdXRoLmJhY2tlbmRzLk1vZGVsQmFja2VuZCIsIl9hdXRoX3VzZXJfaWQiOiIzIn0=	2018-03-08 20:11:51.158636+00
1wd4kyx4u41uh7wnkukp702zvnp3yqne	ODlhZGM3NWVmMjZiYmM4YjgzMDE1NGJhYWU4OGU4OWY3YjMzZjY1OTp7Il9hdXRoX3VzZXJfaWQiOiIzIiwiX2F1dGhfdXNlcl9oYXNoIjoiYzNlZTUyODNlYTE5ZDdlMjczYWNmNjdmMTAzNGNkMmI0MGI2ODUwZCIsIl9hdXRoX3VzZXJfYmFja2VuZCI6ImRqYW5nby5jb250cmliLmF1dGguYmFja2VuZHMuTW9kZWxCYWNrZW5kIn0=	2018-03-16 23:48:19.82492+00
y7fbc9uvt2wosysnsxksmcmbjn0635n2	MmZlMDkwNTYxNDAwMDgzMjU2ODRkN2M4MzkyMjNhODAzMTA4Nzc0ZDp7Il9hdXRoX3VzZXJfaWQiOiI0IiwiX2F1dGhfdXNlcl9iYWNrZW5kIjoiZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5kcy5Nb2RlbEJhY2tlbmQiLCJfYXV0aF91c2VyX2hhc2giOiI3YjA5ZGIxOTcwMDlhYThlOWIxMTAwNDYzNDY2MjVkMzZiZGViOWRmIn0=	2018-03-12 13:57:14.072039+00
l7nvpzsmyju00rj0csyvtswryziymw0u	YWMxZWZlNmZhYTlkZWNiMWIxZWM5N2ZlOWQ3YTFlZjRlNGE0MTBkNjp7Il9hdXRoX3VzZXJfYmFja2VuZCI6ImRqYW5nby5jb250cmliLmF1dGguYmFja2VuZHMuTW9kZWxCYWNrZW5kIiwiX2F1dGhfdXNlcl9oYXNoIjoiYWZiMmU1ZGRiNWIwZTFkNDljMTgwOWUyNjQ2ZGMxZDQyYzNmYzkwMiIsIl9hdXRoX3VzZXJfaWQiOiI0In0=	2018-03-08 22:06:48.223587+00
x7hhqftnuayo705z8sh5mpw3i6380jwl	YWM1ZDBmYWI3NGYwNWQ2OTc0MGY5NzhjNGFkM2NiYTc5ZTE2MGZmYjp7Il9hdXRoX3VzZXJfaGFzaCI6ImMzZWU1MjgzZWExOWQ3ZTI3M2FjZjY3ZjEwMzRjZDJiNDBiNjg1MGQiLCJfYXV0aF91c2VyX2lkIjoiMyIsIl9hdXRoX3VzZXJfYmFja2VuZCI6ImRqYW5nby5jb250cmliLmF1dGguYmFja2VuZHMuTW9kZWxCYWNrZW5kIn0=	2018-03-16 20:16:52.22654+00
0yeimt9bv1k5qwz7zln8qrmr2jttpupz	MDdlMGU5NzY3MGIyZGZmNjRiZWU0ZjFjOGE1Njc2MmIxOTBmNzg5ZDp7Il9hdXRoX3VzZXJfaWQiOiI1IiwiX2F1dGhfdXNlcl9oYXNoIjoiMTEzNmZlM2U5MmE5ODZmZjc2MDA4MTFmYjdkMzExZmUwZjQ0MWM2YiIsIl9hdXRoX3VzZXJfYmFja2VuZCI6ImRqYW5nby5jb250cmliLmF1dGguYmFja2VuZHMuTW9kZWxCYWNrZW5kIn0=	2018-03-12 12:43:04.869352+00
\.


--
-- Data for Name: logus_entrada; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY logus_entrada (id, data, valortotal, fornecedor_id) FROM stdin;
2	2018-02-28	182.40	2
3	2018-02-28	95.00	1
4	2018-03-01	405.75	2
5	2018-03-01	921.70	2
6	2018-03-06	55.10	1
7	2018-03-09	433.30	2
8	2018-03-09	27.55	1
9	2018-03-09	82.65	3
16	2018-03-09	936.70	1
17	2018-03-09	3651.75	1
18	2018-03-10	4869.00	2
19	2018-03-10	82.65	1
20	2018-03-16	2028.75	3
\.


--
-- Data for Name: logus_familymember; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY logus_familymember (id, name, relationship, profile_id) FROM stdin;
\.


--
-- Data for Name: logus_fornecedor; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY logus_fornecedor (id, nome, email, fone1, fone2, data_pub, tipo) FROM stdin;
1	KALUNGA	contato@kalunga.com.br	0982983492347	9827348234	2018-02-28	F
2	IBM	contato@ibm.com.br	345345346	45643243	2018-02-28	J
3	MALTA	maltarodrigo@hotmail.com	32680400	32680400	2018-03-09	J
\.


--
-- Data for Name: logus_itensentrada; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY logus_itensentrada (id, quantidade, entrada_id, produto_id, valoru, valort) FROM stdin;
3	3.000	2	2	27.55	82.65
4	5.000	2	1	19.95	99.75
5	2.000	3	1	19.95	39.90
6	2.000	3	2	27.55	55.10
7	1.000	4	3	405.75	405.75
8	4.000	5	2	27.55	110.20
9	2.000	5	3	405.75	811.50
10	2.000	6	2	27.55	55.10
11	1.000	7	2	27.55	27.55
12	1.000	7	3	405.75	405.75
13	1.000	8	2	27.55	27.55
14	3.000	9	2	27.55	82.65
20	34.000	16	2	27.55	936.70
21	9.000	17	3	405.75	3651.75
22	12.000	18	3	405.75	4869.00
23	3.000	19	2	27.55	82.65
24	5.000	20	3	405.75	2028.75
\.


--
-- Data for Name: logus_produto; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY logus_produto (id, descricao, valor, estoque) FROM stdin;
1	Pendrive 8 GB	19.95	7.000
2	Pendrive 16 GB	27.55	53.000
3	HD externo Seagate 1 TB	405.75	30.000
\.


--
-- Data for Name: logus_profile; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY logus_profile (id, first_name, last_name, created_date) FROM stdin;
\.


--
-- Name: auth_group_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('auth_group_id_seq', 2, true);


--
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('auth_group_permissions_id_seq', 13, true);


--
-- Name: auth_permission_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('auth_permission_id_seq', 47, true);


--
-- Name: auth_user_groups_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('auth_user_groups_id_seq', 3, true);


--
-- Name: auth_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('auth_user_id_seq', 6, true);


--
-- Name: auth_user_user_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('auth_user_user_permissions_id_seq', 12, true);


--
-- Name: django_admin_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('django_admin_log_id_seq', 42, true);


--
-- Name: django_content_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('django_content_type_id_seq', 13, true);


--
-- Name: django_migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('django_migrations_id_seq', 47, true);


--
-- Name: logus_entrada_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('logus_entrada_id_seq', 20, true);


--
-- Name: logus_familymember_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('logus_familymember_id_seq', 1, false);


--
-- Name: logus_fornecedor_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('logus_fornecedor_id_seq', 3, true);


--
-- Name: logus_itensentrada_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('logus_itensentrada_id_seq', 24, true);


--
-- Name: logus_produto_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('logus_produto_id_seq', 3, true);


--
-- Name: logus_profile_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('logus_profile_id_seq', 1, false);


--
-- Name: auth_group auth_group_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY auth_group
    ADD CONSTRAINT auth_group_name_key UNIQUE (name);


--
-- Name: auth_group_permissions auth_group_permissions_group_id_permission_id_0cd325b0_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_group_id_permission_id_0cd325b0_uniq UNIQUE (group_id, permission_id);


--
-- Name: auth_group_permissions auth_group_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_pkey PRIMARY KEY (id);


--
-- Name: auth_group auth_group_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY auth_group
    ADD CONSTRAINT auth_group_pkey PRIMARY KEY (id);


--
-- Name: auth_permission auth_permission_content_type_id_codename_01ab375a_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY auth_permission
    ADD CONSTRAINT auth_permission_content_type_id_codename_01ab375a_uniq UNIQUE (content_type_id, codename);


--
-- Name: auth_permission auth_permission_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY auth_permission
    ADD CONSTRAINT auth_permission_pkey PRIMARY KEY (id);


--
-- Name: auth_user_groups auth_user_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY auth_user_groups
    ADD CONSTRAINT auth_user_groups_pkey PRIMARY KEY (id);


--
-- Name: auth_user_groups auth_user_groups_user_id_group_id_94350c0c_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY auth_user_groups
    ADD CONSTRAINT auth_user_groups_user_id_group_id_94350c0c_uniq UNIQUE (user_id, group_id);


--
-- Name: auth_user auth_user_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY auth_user
    ADD CONSTRAINT auth_user_pkey PRIMARY KEY (id);


--
-- Name: auth_user_user_permissions auth_user_user_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_pkey PRIMARY KEY (id);


--
-- Name: auth_user_user_permissions auth_user_user_permissions_user_id_permission_id_14a6b632_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_user_id_permission_id_14a6b632_uniq UNIQUE (user_id, permission_id);


--
-- Name: auth_user auth_user_username_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY auth_user
    ADD CONSTRAINT auth_user_username_key UNIQUE (username);


--
-- Name: django_admin_log django_admin_log_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY django_admin_log
    ADD CONSTRAINT django_admin_log_pkey PRIMARY KEY (id);


--
-- Name: django_content_type django_content_type_app_label_model_76bd3d3b_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY django_content_type
    ADD CONSTRAINT django_content_type_app_label_model_76bd3d3b_uniq UNIQUE (app_label, model);


--
-- Name: django_content_type django_content_type_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY django_content_type
    ADD CONSTRAINT django_content_type_pkey PRIMARY KEY (id);


--
-- Name: django_migrations django_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY django_migrations
    ADD CONSTRAINT django_migrations_pkey PRIMARY KEY (id);


--
-- Name: django_session django_session_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY django_session
    ADD CONSTRAINT django_session_pkey PRIMARY KEY (session_key);


--
-- Name: logus_entrada logus_entrada_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY logus_entrada
    ADD CONSTRAINT logus_entrada_pkey PRIMARY KEY (id);


--
-- Name: logus_familymember logus_familymember_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY logus_familymember
    ADD CONSTRAINT logus_familymember_pkey PRIMARY KEY (id);


--
-- Name: logus_fornecedor logus_fornecedor_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY logus_fornecedor
    ADD CONSTRAINT logus_fornecedor_pkey PRIMARY KEY (id);


--
-- Name: logus_itensentrada logus_itensentrada_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY logus_itensentrada
    ADD CONSTRAINT logus_itensentrada_pkey PRIMARY KEY (id);


--
-- Name: logus_produto logus_produto_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY logus_produto
    ADD CONSTRAINT logus_produto_pkey PRIMARY KEY (id);


--
-- Name: logus_profile logus_profile_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY logus_profile
    ADD CONSTRAINT logus_profile_pkey PRIMARY KEY (id);


--
-- Name: auth_group_name_a6ea08ec_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_group_name_a6ea08ec_like ON auth_group USING btree (name varchar_pattern_ops);


--
-- Name: auth_group_permissions_group_id_b120cbf9; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_group_permissions_group_id_b120cbf9 ON auth_group_permissions USING btree (group_id);


--
-- Name: auth_group_permissions_permission_id_84c5c92e; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_group_permissions_permission_id_84c5c92e ON auth_group_permissions USING btree (permission_id);


--
-- Name: auth_permission_content_type_id_2f476e4b; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_permission_content_type_id_2f476e4b ON auth_permission USING btree (content_type_id);


--
-- Name: auth_user_groups_group_id_97559544; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_user_groups_group_id_97559544 ON auth_user_groups USING btree (group_id);


--
-- Name: auth_user_groups_user_id_6a12ed8b; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_user_groups_user_id_6a12ed8b ON auth_user_groups USING btree (user_id);


--
-- Name: auth_user_user_permissions_permission_id_1fbb5f2c; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_user_user_permissions_permission_id_1fbb5f2c ON auth_user_user_permissions USING btree (permission_id);


--
-- Name: auth_user_user_permissions_user_id_a95ead1b; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_user_user_permissions_user_id_a95ead1b ON auth_user_user_permissions USING btree (user_id);


--
-- Name: auth_user_username_6821ab7c_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_user_username_6821ab7c_like ON auth_user USING btree (username varchar_pattern_ops);


--
-- Name: django_admin_log_content_type_id_c4bce8eb; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX django_admin_log_content_type_id_c4bce8eb ON django_admin_log USING btree (content_type_id);


--
-- Name: django_admin_log_user_id_c564eba6; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX django_admin_log_user_id_c564eba6 ON django_admin_log USING btree (user_id);


--
-- Name: django_session_expire_date_a5c62663; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX django_session_expire_date_a5c62663 ON django_session USING btree (expire_date);


--
-- Name: django_session_session_key_c0390e0f_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX django_session_session_key_c0390e0f_like ON django_session USING btree (session_key varchar_pattern_ops);


--
-- Name: logus_entrada_fornecedor_id_d751ab11; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX logus_entrada_fornecedor_id_d751ab11 ON logus_entrada USING btree (fornecedor_id);


--
-- Name: logus_familymember_profile_id_8ebfd489; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX logus_familymember_profile_id_8ebfd489 ON logus_familymember USING btree (profile_id);


--
-- Name: logus_itensentrada_entrada_id_c1c8a2c0; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX logus_itensentrada_entrada_id_c1c8a2c0 ON logus_itensentrada USING btree (entrada_id);


--
-- Name: logus_itensentrada_produto_id_7d70fe53; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX logus_itensentrada_produto_id_7d70fe53 ON logus_itensentrada USING btree (produto_id);


--
-- Name: logus_entrada logus_entrada_bd; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER logus_entrada_bd BEFORE DELETE ON logus_entrada FOR EACH ROW EXECUTE PROCEDURE fn_deletar_itens_entrada();


--
-- Name: logus_itensentrada logus_itensentrada_ad; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER logus_itensentrada_ad AFTER DELETE ON logus_itensentrada FOR EACH ROW EXECUTE PROCEDURE fn_atualizar_estoque();


--
-- Name: logus_itensentrada logus_itensentrada_ai; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER logus_itensentrada_ai AFTER INSERT ON logus_itensentrada FOR EACH ROW EXECUTE PROCEDURE fn_atualizar_estoque();


--
-- Name: logus_itensentrada logus_itensentrada_au; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER logus_itensentrada_au AFTER UPDATE ON logus_itensentrada FOR EACH ROW EXECUTE PROCEDURE fn_atualizar_estoque();


--
-- Name: auth_group_permissions auth_group_permissio_permission_id_84c5c92e_fk_auth_perm; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY auth_group_permissions
    ADD CONSTRAINT auth_group_permissio_permission_id_84c5c92e_fk_auth_perm FOREIGN KEY (permission_id) REFERENCES auth_permission(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_group_permissions auth_group_permissions_group_id_b120cbf9_fk_auth_group_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_group_id_b120cbf9_fk_auth_group_id FOREIGN KEY (group_id) REFERENCES auth_group(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_permission auth_permission_content_type_id_2f476e4b_fk_django_co; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY auth_permission
    ADD CONSTRAINT auth_permission_content_type_id_2f476e4b_fk_django_co FOREIGN KEY (content_type_id) REFERENCES django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_user_groups auth_user_groups_group_id_97559544_fk_auth_group_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY auth_user_groups
    ADD CONSTRAINT auth_user_groups_group_id_97559544_fk_auth_group_id FOREIGN KEY (group_id) REFERENCES auth_group(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_user_groups auth_user_groups_user_id_6a12ed8b_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY auth_user_groups
    ADD CONSTRAINT auth_user_groups_user_id_6a12ed8b_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_user_user_permissions auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm FOREIGN KEY (permission_id) REFERENCES auth_permission(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_user_user_permissions auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: django_admin_log django_admin_log_content_type_id_c4bce8eb_fk_django_co; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY django_admin_log
    ADD CONSTRAINT django_admin_log_content_type_id_c4bce8eb_fk_django_co FOREIGN KEY (content_type_id) REFERENCES django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: django_admin_log django_admin_log_user_id_c564eba6_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY django_admin_log
    ADD CONSTRAINT django_admin_log_user_id_c564eba6_fk FOREIGN KEY (user_id) REFERENCES auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: logus_entrada logus_entrada_fornecedor_id_d751ab11_fk_logus_fornecedor_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY logus_entrada
    ADD CONSTRAINT logus_entrada_fornecedor_id_d751ab11_fk_logus_fornecedor_id FOREIGN KEY (fornecedor_id) REFERENCES logus_fornecedor(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: logus_familymember logus_familymember_profile_id_8ebfd489_fk_logus_profile_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY logus_familymember
    ADD CONSTRAINT logus_familymember_profile_id_8ebfd489_fk_logus_profile_id FOREIGN KEY (profile_id) REFERENCES logus_profile(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: logus_itensentrada logus_itensentrada_entrada_id_c1c8a2c0_fk_logus_entrada_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY logus_itensentrada
    ADD CONSTRAINT logus_itensentrada_entrada_id_c1c8a2c0_fk_logus_entrada_id FOREIGN KEY (entrada_id) REFERENCES logus_entrada(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: logus_itensentrada logus_itensentrada_produto_id_7d70fe53_fk_logus_produto_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY logus_itensentrada
    ADD CONSTRAINT logus_itensentrada_produto_id_7d70fe53_fk_logus_produto_id FOREIGN KEY (produto_id) REFERENCES logus_produto(id) DEFERRABLE INITIALLY DEFERRED;


--
-- PostgreSQL database dump complete
--

\connect template1

SET default_transaction_read_only = off;

--
-- PostgreSQL database dump
--

-- Dumped from database version 10.2 (Debian 10.2-1.pgdg90+1)
-- Dumped by pg_dump version 10.2 (Debian 10.2-1.pgdg90+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: DATABASE template1; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON DATABASE template1 IS 'default template for new databases';


--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- PostgreSQL database dump complete
--

--
-- PostgreSQL database cluster dump complete
--

