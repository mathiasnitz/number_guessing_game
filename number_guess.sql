--
-- PostgreSQL database dump
--

-- Dumped from database version 12.17 (Ubuntu 12.17-1.pgdg22.04+1)
-- Dumped by pg_dump version 12.17 (Ubuntu 12.17-1.pgdg22.04+1)

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

DROP DATABASE number_guess;
--
-- Name: number_guess; Type: DATABASE; Schema: -; Owner: freecodecamp
--

CREATE DATABASE number_guess WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'C.UTF-8' LC_CTYPE = 'C.UTF-8';


ALTER DATABASE number_guess OWNER TO freecodecamp;

\connect number_guess

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
-- Name: games; Type: TABLE; Schema: public; Owner: freecodecamp
--

CREATE TABLE public.games (
    game_id integer NOT NULL,
    user_id integer,
    number_of_guesses integer
);


ALTER TABLE public.games OWNER TO freecodecamp;

--
-- Name: games_game_id_seq; Type: SEQUENCE; Schema: public; Owner: freecodecamp
--

CREATE SEQUENCE public.games_game_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.games_game_id_seq OWNER TO freecodecamp;

--
-- Name: games_game_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: freecodecamp
--

ALTER SEQUENCE public.games_game_id_seq OWNED BY public.games.game_id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: freecodecamp
--

CREATE TABLE public.users (
    user_id integer NOT NULL,
    username character varying(22) NOT NULL,
    games_played integer,
    best_game integer
);


ALTER TABLE public.users OWNER TO freecodecamp;

--
-- Name: users_user_id_seq; Type: SEQUENCE; Schema: public; Owner: freecodecamp
--

CREATE SEQUENCE public.users_user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_user_id_seq OWNER TO freecodecamp;

--
-- Name: users_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: freecodecamp
--

ALTER SEQUENCE public.users_user_id_seq OWNED BY public.users.user_id;


--
-- Name: games game_id; Type: DEFAULT; Schema: public; Owner: freecodecamp
--

ALTER TABLE ONLY public.games ALTER COLUMN game_id SET DEFAULT nextval('public.games_game_id_seq'::regclass);


--
-- Name: users user_id; Type: DEFAULT; Schema: public; Owner: freecodecamp
--

ALTER TABLE ONLY public.users ALTER COLUMN user_id SET DEFAULT nextval('public.users_user_id_seq'::regclass);


--
-- Data for Name: games; Type: TABLE DATA; Schema: public; Owner: freecodecamp
--

INSERT INTO public.games VALUES (13, 5, 321);
INSERT INTO public.games VALUES (80, 23, 368);
INSERT INTO public.games VALUES (44, 13, 206);
INSERT INTO public.games VALUES (7, 1, 91);
INSERT INTO public.games VALUES (8, 3, NULL);
INSERT INTO public.games VALUES (93, 27, 368);
INSERT INTO public.games VALUES (17, 3, 8);
INSERT INTO public.games VALUES (51, 15, 205);
INSERT INTO public.games VALUES (25, 3, 9);
INSERT INTO public.games VALUES (26, 3, NULL);
INSERT INTO public.games VALUES (9, 3, 8);
INSERT INTO public.games VALUES (27, 3, 1);
INSERT INTO public.games VALUES (59, 17, 415);
INSERT INTO public.games VALUES (94, 28, 163);
INSERT INTO public.games VALUES (61, 16, 362);
INSERT INTO public.games VALUES (60, 16, 210);
INSERT INTO public.games VALUES (91, 25, 366);
INSERT INTO public.games VALUES (67, 18, 147);
INSERT INTO public.games VALUES (40, 10, 376);
INSERT INTO public.games VALUES (39, 10, 211);
INSERT INTO public.games VALUES (10, 4, 178);
INSERT INTO public.games VALUES (50, 14, 124);
INSERT INTO public.games VALUES (92, 27, 209);
INSERT INTO public.games VALUES (88, 26, 284);
INSERT INTO public.games VALUES (87, 26, 175);
INSERT INTO public.games VALUES (2, 1, 137);
INSERT INTO public.games VALUES (41, 10, 552);
INSERT INTO public.games VALUES (21, 7, 410);
INSERT INTO public.games VALUES (30, 9, 215);
INSERT INTO public.games VALUES (15, 4, 203);
INSERT INTO public.games VALUES (1, 1, 137);
INSERT INTO public.games VALUES (54, 14, 199);
INSERT INTO public.games VALUES (11, 4, 314);
INSERT INTO public.games VALUES (76, 20, 206);
INSERT INTO public.games VALUES (22, 6, 211);
INSERT INTO public.games VALUES (68, 18, 185);
INSERT INTO public.games VALUES (23, 6, 121);
INSERT INTO public.games VALUES (62, 16, 170);
INSERT INTO public.games VALUES (43, 12, 224);
INSERT INTO public.games VALUES (95, 28, 222);
INSERT INTO public.games VALUES (18, 6, 213);
INSERT INTO public.games VALUES (45, 13, 308);
INSERT INTO public.games VALUES (71, 20, 345);
INSERT INTO public.games VALUES (16, 4, 338);
INSERT INTO public.games VALUES (46, 12, 216);
INSERT INTO public.games VALUES (56, 16, 211);
INSERT INTO public.games VALUES (53, 14, 127);
INSERT INTO public.games VALUES (55, 14, 171);
INSERT INTO public.games VALUES (19, 6, 394);
INSERT INTO public.games VALUES (75, 20, 208);
INSERT INTO public.games VALUES (81, 22, 167);
INSERT INTO public.games VALUES (12, 5, 199);
INSERT INTO public.games VALUES (14, 4, 212);
INSERT INTO public.games VALUES (3, 2, 77);
INSERT INTO public.games VALUES (5, 1, 107);
INSERT INTO public.games VALUES (31, 9, 419);
INSERT INTO public.games VALUES (37, 11, 160);
INSERT INTO public.games VALUES (20, 7, 206);
INSERT INTO public.games VALUES (4, 2, 219);
INSERT INTO public.games VALUES (32, 8, 210);
INSERT INTO public.games VALUES (28, 8, 215);
INSERT INTO public.games VALUES (35, 10, 212);
INSERT INTO public.games VALUES (78, 22, 386);
INSERT INTO public.games VALUES (6, 1, 193);
INSERT INTO public.games VALUES (29, 8, 341);
INSERT INTO public.games VALUES (96, 27, 119);
INSERT INTO public.games VALUES (47, 12, 285);
INSERT INTO public.games VALUES (63, 18, 218);
INSERT INTO public.games VALUES (97, 27, 192);
INSERT INTO public.games VALUES (48, 12, 348);
INSERT INTO public.games VALUES (73, 21, 410);
INSERT INTO public.games VALUES (33, 8, 417);
INSERT INTO public.games VALUES (72, 21, 148);
INSERT INTO public.games VALUES (36, 10, 630);
INSERT INTO public.games VALUES (52, 15, 408);
INSERT INTO public.games VALUES (85, 25, 206);
INSERT INTO public.games VALUES (79, 23, 169);
INSERT INTO public.games VALUES (66, 19, 391);
INSERT INTO public.games VALUES (74, 20, 207);
INSERT INTO public.games VALUES (24, 6, 214);
INSERT INTO public.games VALUES (69, 18, 244);
INSERT INTO public.games VALUES (65, 19, 213);
INSERT INTO public.games VALUES (34, 8, 207);
INSERT INTO public.games VALUES (49, 14, 208);
INSERT INTO public.games VALUES (38, 11, 614);
INSERT INTO public.games VALUES (83, 22, 171);
INSERT INTO public.games VALUES (42, 12, 202);
INSERT INTO public.games VALUES (77, 22, 207);
INSERT INTO public.games VALUES (90, 25, 215);
INSERT INTO public.games VALUES (84, 24, 10);
INSERT INTO public.games VALUES (57, 16, 169);
INSERT INTO public.games VALUES (58, 17, 209);
INSERT INTO public.games VALUES (64, 18, 222);
INSERT INTO public.games VALUES (82, 22, 291);
INSERT INTO public.games VALUES (70, 20, 214);
INSERT INTO public.games VALUES (86, 25, 430);
INSERT INTO public.games VALUES (89, 25, 98);
INSERT INTO public.games VALUES (98, 27, 213);


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: freecodecamp
--

INSERT INTO public.users VALUES (2, 'user_1743177402056', 2, 77);
INSERT INTO public.users VALUES (17, 'user_1743179185622', 2, NULL);
INSERT INTO public.users VALUES (1, 'user_1743177402057', 5, 137);
INSERT INTO public.users VALUES (16, 'user_1743179185623', 5, 150);
INSERT INTO public.users VALUES (5, 'user_1743177839169', 2, 321);
INSERT INTO public.users VALUES (4, 'user_1743177839170', 5, NULL);
INSERT INTO public.users VALUES (7, 'user_1743178293075', 2, NULL);
INSERT INTO public.users VALUES (19, 'user_1743179279903', 2, NULL);
INSERT INTO public.users VALUES (6, 'user_1743178293076', 5, 121);
INSERT INTO public.users VALUES (18, 'user_1743179279904', 5, 36);
INSERT INTO public.users VALUES (3, 'Matt', 6, 8);
INSERT INTO public.users VALUES (9, 'user_1743178671175', 2, NULL);
INSERT INTO public.users VALUES (21, 'user_1743179468706', 2, NULL);
INSERT INTO public.users VALUES (8, 'user_1743178671176', 5, 341);
INSERT INTO public.users VALUES (20, 'user_1743179468707', 5, NULL);
INSERT INTO public.users VALUES (11, 'user_1743178869027', 2, NULL);
INSERT INTO public.users VALUES (10, 'user_1743178869028', 5, 162);
INSERT INTO public.users VALUES (23, 'user_1743179631682', 2, NULL);
INSERT INTO public.users VALUES (22, 'user_1743179631683', 5, 131);
INSERT INTO public.users VALUES (13, 'user_1743178956819', 2, 308);
INSERT INTO public.users VALUES (24, 'Thorsten', 1, NULL);
INSERT INTO public.users VALUES (12, 'user_1743178956820', 5, 61);
INSERT INTO public.users VALUES (26, 'user_1743179835291', 2, NULL);
INSERT INTO public.users VALUES (15, 'user_1743179040039', 2, 156);
INSERT INTO public.users VALUES (25, 'user_1743179835292', 5, 98);
INSERT INTO public.users VALUES (14, 'user_1743179040040', 5, 124);
INSERT INTO public.users VALUES (28, 'user_1743180052465', 2, NULL);
INSERT INTO public.users VALUES (27, 'user_1743180052466', 5, 19);


--
-- Name: games_game_id_seq; Type: SEQUENCE SET; Schema: public; Owner: freecodecamp
--

SELECT pg_catalog.setval('public.games_game_id_seq', 98, true);


--
-- Name: users_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: freecodecamp
--

SELECT pg_catalog.setval('public.users_user_id_seq', 28, true);


--
-- Name: games games_pkey; Type: CONSTRAINT; Schema: public; Owner: freecodecamp
--

ALTER TABLE ONLY public.games
    ADD CONSTRAINT games_pkey PRIMARY KEY (game_id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: freecodecamp
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (user_id);


--
-- Name: games games_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: freecodecamp
--

ALTER TABLE ONLY public.games
    ADD CONSTRAINT games_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id);


--
-- PostgreSQL database dump complete
--

