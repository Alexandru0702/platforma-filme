-- ============================================================
-- Script: 10_pkg_statistici.sql
-- Descriere: Creaza tabelul CUVINTE_CHEIE si pachetul PKG_STATISTICI
--            cu algoritmi pentru:
--              1. Analiza sentiment (3 surse: caracterizari, voturi, comentarii)
--              2. Recomandari personalizate pe baza categoriilor preferate
--              3. Predictii sezoniere dupa pattern-uri istorice
-- Compatibil: Oracle XE 11g (11.2.0.2)
-- ============================================================

-- Curatare obiecte existente
BEGIN EXECUTE IMMEDIATE 'DROP TABLE CUVINTE_CHEIE CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP SEQUENCE seq_cuvinte_cheie'; EXCEPTION WHEN OTHERS THEN NULL; END;
/

-- -------------------------------------------------------
-- Tabel CUVINTE_CHEIE
-- Utilizat in analiza sentiment pentru scanarea comentariilor
-- greutate: 1=slab, 2=mediu, 3=puternic (influenteaza scorul)
-- -------------------------------------------------------
CREATE TABLE CUVINTE_CHEIE (
                               id_cuvant     NUMBER          CONSTRAINT pk_cuvinte PRIMARY KEY,
                               cuvant        VARCHAR2(50)    CONSTRAINT nn_cuv_cuvant NOT NULL,
                               tip_sentiment VARCHAR2(10)    CONSTRAINT nn_cuv_tip NOT NULL
                                  CONSTRAINT ck_cuv_tip CHECK (tip_sentiment IN ('POZITIV','NEGATIV','NEUTRU')),
                               greutate      NUMBER(3)       DEFAULT 1
                                  CONSTRAINT ck_cuv_greutate CHECK (greutate BETWEEN 1 AND 5)
);

CREATE SEQUENCE seq_cuvinte_cheie START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;

-- Cuvinte POZITIVE (17 intrari)
INSERT INTO CUVINTE_CHEIE VALUES (seq_cuvinte_cheie.NEXTVAL, 'excelent',     'POZITIV', 3);
INSERT INTO CUVINTE_CHEIE VALUES (seq_cuvinte_cheie.NEXTVAL, 'superb',       'POZITIV', 3);
INSERT INTO CUVINTE_CHEIE VALUES (seq_cuvinte_cheie.NEXTVAL, 'fantastic',    'POZITIV', 3);
INSERT INTO CUVINTE_CHEIE VALUES (seq_cuvinte_cheie.NEXTVAL, 'exceptional',  'POZITIV', 3);
INSERT INTO CUVINTE_CHEIE VALUES (seq_cuvinte_cheie.NEXTVAL, 'minunat',      'POZITIV', 2);
INSERT INTO CUVINTE_CHEIE VALUES (seq_cuvinte_cheie.NEXTVAL, 'captivant',    'POZITIV', 2);
INSERT INTO CUVINTE_CHEIE VALUES (seq_cuvinte_cheie.NEXTVAL, 'impresionant', 'POZITIV', 2);
INSERT INTO CUVINTE_CHEIE VALUES (seq_cuvinte_cheie.NEXTVAL, 'emotionant',   'POZITIV', 2);
INSERT INTO CUVINTE_CHEIE VALUES (seq_cuvinte_cheie.NEXTVAL, 'spectaculos',  'POZITIV', 2);
INSERT INTO CUVINTE_CHEIE VALUES (seq_cuvinte_cheie.NEXTVAL, 'perfect',      'POZITIV', 3);
INSERT INTO CUVINTE_CHEIE VALUES (seq_cuvinte_cheie.NEXTVAL, 'magistral',    'POZITIV', 3);
INSERT INTO CUVINTE_CHEIE VALUES (seq_cuvinte_cheie.NEXTVAL, 'recomandat',   'POZITIV', 2);
INSERT INTO CUVINTE_CHEIE VALUES (seq_cuvinte_cheie.NEXTVAL, 'uimitor',      'POZITIV', 2);
INSERT INTO CUVINTE_CHEIE VALUES (seq_cuvinte_cheie.NEXTVAL, 'capodopera',   'POZITIV', 3);
INSERT INTO CUVINTE_CHEIE VALUES (seq_cuvinte_cheie.NEXTVAL, 'extraordinar', 'POZITIV', 3);
INSERT INTO CUVINTE_CHEIE VALUES (seq_cuvinte_cheie.NEXTVAL, 'fascinant',    'POZITIV', 2);
INSERT INTO CUVINTE_CHEIE VALUES (seq_cuvinte_cheie.NEXTVAL, 'deosebit',     'POZITIV', 1);

-- Cuvinte NEGATIVE (13 intrari)
INSERT INTO CUVINTE_CHEIE VALUES (seq_cuvinte_cheie.NEXTVAL, 'plictisitor',  'NEGATIV', 3);
INSERT INTO CUVINTE_CHEIE VALUES (seq_cuvinte_cheie.NEXTVAL, 'slab',         'NEGATIV', 2);
INSERT INTO CUVINTE_CHEIE VALUES (seq_cuvinte_cheie.NEXTVAL, 'groaznic',     'NEGATIV', 3);
INSERT INTO CUVINTE_CHEIE VALUES (seq_cuvinte_cheie.NEXTVAL, 'dezamagitor',  'NEGATIV', 3);
INSERT INTO CUVINTE_CHEIE VALUES (seq_cuvinte_cheie.NEXTVAL, 'mediocru',     'NEGATIV', 2);
INSERT INTO CUVINTE_CHEIE VALUES (seq_cuvinte_cheie.NEXTVAL, 'teribil',      'NEGATIV', 2);
INSERT INTO CUVINTE_CHEIE VALUES (seq_cuvinte_cheie.NEXTVAL, 'monoton',      'NEGATIV', 2);
INSERT INTO CUVINTE_CHEIE VALUES (seq_cuvinte_cheie.NEXTVAL, 'neinteresant', 'NEGATIV', 2);
INSERT INTO CUVINTE_CHEIE VALUES (seq_cuvinte_cheie.NEXTVAL, 'dezamagit',    'NEGATIV', 2);
INSERT INTO CUVINTE_CHEIE VALUES (seq_cuvinte_cheie.NEXTVAL, 'superficial',  'NEGATIV', 1);
INSERT INTO CUVINTE_CHEIE VALUES (seq_cuvinte_cheie.NEXTVAL, 'previzibil',   'NEGATIV', 1);
INSERT INTO CUVINTE_CHEIE VALUES (seq_cuvinte_cheie.NEXTVAL, 'banal',        'NEGATIV', 1);
INSERT INTO CUVINTE_CHEIE VALUES (seq_cuvinte_cheie.NEXTVAL, 'penibil',      'NEGATIV', 3);

-- Cuvinte NEUTRE (5 intrari)
INSERT INTO CUVINTE_CHEIE VALUES (seq_cuvinte_cheie.NEXTVAL, 'interesant',   'NEUTRU',  1);
INSERT INTO CUVINTE_CHEIE VALUES (seq_cuvinte_cheie.NEXTVAL, 'acceptabil',   'NEUTRU',  1);
INSERT INTO CUVINTE_CHEIE VALUES (seq_cuvinte_cheie.NEXTVAL, 'normal',       'NEUTRU',  1);
INSERT INTO CUVINTE_CHEIE VALUES (seq_cuvinte_cheie.NEXTVAL, 'vizionat',     'NEUTRU',  1);
INSERT INTO CUVINTE_CHEIE VALUES (seq_cuvinte_cheie.NEXTVAL, 'urmarit',      'NEUTRU',  1);

COMMIT;

-- ============================================================
-- Specificatia pachetului PKG_STATISTICI
-- ============================================================
CREATE OR REPLACE PACKAGE PKG_STATISTICI AS

    -- Statistici globale ale platformei (un singur rand)
    PROCEDURE statistici_globale(p_cursor OUT SYS_REFCURSOR);

    -- Analiza sentiment pentru toate filmele
    -- Surse: caracterizari bifate + voturi + cuvinte-cheie din comentarii
    PROCEDURE sentiment_toate_filmele(p_cursor OUT SYS_REFCURSOR);

    -- Recomandari personalizate pentru un client
    -- Algoritm: top 3 categorii preferate -> filme nevizionate -> sortat dupa rating
    PROCEDURE recomandari_client(p_id_client IN NUMBER, p_cursor OUT SYS_REFCURSOR);

    -- Predictii sezoniere: distributia vizualizarilor pe luni
    PROCEDURE predictii_sezoniere(p_cursor OUT SYS_REFCURSOR);

    -- Predictii pe categorii per anotimp
    PROCEDURE predictii_categorii_sezon(p_cursor OUT SYS_REFCURSOR);

END PKG_STATISTICI;
/

-- ============================================================
-- Corpul pachetului PKG_STATISTICI
-- ============================================================
CREATE OR REPLACE PACKAGE BODY PKG_STATISTICI AS

    -- ----------------------------------------------------------
    -- PROCEDURE: statistici_globale
    -- Returneaza: un singur rand cu numaratori si medii globale
    -- ----------------------------------------------------------
    PROCEDURE statistici_globale(p_cursor OUT SYS_REFCURSOR) AS
BEGIN
OPEN p_cursor FOR
SELECT
    (SELECT COUNT(*) FROM FILME)                                          AS nr_filme,
    (SELECT COUNT(*) FROM CLIENTI)                                        AS nr_clienti,
    (SELECT COUNT(*) FROM VIZUALIZARI)                                    AS nr_vizualizari,
    (SELECT COUNT(*) FROM ACTORI)                                         AS nr_actori,
    (SELECT COUNT(*) FROM VOTURI)                                         AS nr_voturi,
    (SELECT COUNT(*) FROM COMENTARII)                                     AS nr_comentarii,
    (SELECT NVL(ROUND(AVG(nota),  2), 0) FROM VOTURI)                    AS nota_medie_globala,
    (SELECT NVL(ROUND(AVG(rating),2), 0) FROM FILME WHERE rating > 0)    AS rating_mediu_filme
FROM DUAL;
END statistici_globale;

    -- ----------------------------------------------------------
    -- PROCEDURE: sentiment_toate_filmele
    -- Algoritm analiza sentiment pe 3 surse:
    --   Sursa 1: CARACTERIZARI_CLIENT (optiuni predefinite bifate)
    --            -> POZITIV/NEGATIV/NEUTRU din CARACTERIZARI_OPTIUNI.tip_sentiment
    --   Sursa 2: VOTURI (note acordate)
    --            -> nota >= 8  = POZITIV
    --            -> nota 5-7   = NEUTRU
    --            -> nota <= 4  = NEGATIV
    --   Sursa 3: COMENTARII (text liber, scanat cu cuvinte-cheie din CUVINTE_CHEIE)
    --            -> JOIN pe LIKE pentru potrivire cuvinte
    -- Scor final: (kar_pos - kar_neg)*2 + (vot_pos - vot_neg) + (com_pos - com_neg)
    -- Eticheta: POZITIV daca scor > 0, NEGATIV daca scor < 0, NEUTRU altfel
    -- ----------------------------------------------------------
    PROCEDURE sentiment_toate_filmele(p_cursor OUT SYS_REFCURSOR) AS
BEGIN
OPEN p_cursor FOR
            -- CTE 1: sentiment din caracterizari bifate
            WITH kar AS (
                SELECT cc.id_film,
                       SUM(CASE WHEN co.tip_sentiment = 'POZITIV' THEN 1 ELSE 0 END) AS kar_pos,
                       SUM(CASE WHEN co.tip_sentiment = 'NEGATIV' THEN 1 ELSE 0 END) AS kar_neg,
                       SUM(CASE WHEN co.tip_sentiment = 'NEUTRU'  THEN 1 ELSE 0 END) AS kar_neu
                FROM CARACTERIZARI_CLIENT cc
                JOIN CARACTERIZARI_OPTIUNI co ON co.id_optiune = cc.id_optiune
                GROUP BY cc.id_film
            ),
            -- CTE 2: sentiment din voturi (clasificate dupa nota)
            vot AS (
                SELECT id_film,
                       SUM(CASE WHEN nota >= 8            THEN 1 ELSE 0 END) AS vot_pos,
                       SUM(CASE WHEN nota BETWEEN 5 AND 7 THEN 1 ELSE 0 END) AS vot_neu,
                       SUM(CASE WHEN nota <= 4             THEN 1 ELSE 0 END) AS vot_neg,
                       ROUND(AVG(nota), 2)                                    AS nota_medie
                FROM VOTURI
                GROUP BY id_film
            ),
            -- CTE 3: sentiment din comentarii prin potrivire cuvinte-cheie
            -- LIKE '%cuvant%' - detecteaza prezenta cuvantului in comentariu
            -- COUNT DISTINCT pentru a evita numararea multipla a aceluiasi comentariu
            kom AS (
                SELECT cm.id_film,
                       COUNT(DISTINCT CASE WHEN ck.tip_sentiment = 'POZITIV'
                                           THEN cm.id_comentariu END) AS com_pos,
                       COUNT(DISTINCT CASE WHEN ck.tip_sentiment = 'NEGATIV'
                                           THEN cm.id_comentariu END) AS com_neg
                FROM COMENTARII cm
                JOIN CUVINTE_CHEIE ck
                    ON UPPER(cm.continut) LIKE '%' || UPPER(ck.cuvant) || '%'
                WHERE cm.id_film IS NOT NULL
                GROUP BY cm.id_film
            )
SELECT
    f.id_film,
    f.titlu,
    f.rating,
    -- Valori pe surse (pentru transparenta algoritmului)
    NVL(k.kar_pos, 0)    AS kar_pozitiv,
    NVL(k.kar_neg, 0)    AS kar_negativ,
    NVL(k.kar_neu, 0)    AS kar_neutru,
    NVL(v.vot_pos, 0)    AS vot_pozitiv,
    NVL(v.vot_neu, 0)    AS vot_neutru,
    NVL(v.vot_neg, 0)    AS vot_negativ,
    NVL(v.nota_medie, 0) AS nota_medie,
    NVL(c.com_pos, 0)    AS com_pozitiv,
    NVL(c.com_neg, 0)    AS com_negativ,
    -- Total feedback (suma tuturor semnalelor)
    NVL(k.kar_pos,0) + NVL(k.kar_neg,0) + NVL(k.kar_neu,0) +
    NVL(v.vot_pos,0) + NVL(v.vot_neu,0) + NVL(v.vot_neg,0) AS total_feedback,
    -- Scor sentiment combinat
    -- Caracterizarile conteaza dublu (mai structurate decat voturile)
    (NVL(k.kar_pos,0) - NVL(k.kar_neg,0)) * 2 +
    (NVL(v.vot_pos,0) - NVL(v.vot_neg,0))     +
    (NVL(c.com_pos,0) - NVL(c.com_neg,0))     AS scor_sentiment,
    -- Eticheta finala
    CASE
        WHEN (NVL(k.kar_pos,0) - NVL(k.kar_neg,0)) * 2 +
             (NVL(v.vot_pos,0) - NVL(v.vot_neg,0))     +
             (NVL(c.com_pos,0) - NVL(c.com_neg,0)) > 0 THEN 'POZITIV'
        WHEN (NVL(k.kar_pos,0) - NVL(k.kar_neg,0)) * 2 +
             (NVL(v.vot_pos,0) - NVL(v.vot_neg,0))     +
             (NVL(c.com_pos,0) - NVL(c.com_neg,0)) < 0 THEN 'NEGATIV'
        ELSE 'NEUTRU'
        END AS eticheta_sentiment
FROM FILME f
         LEFT JOIN kar k ON k.id_film = f.id_film
         LEFT JOIN vot v ON v.id_film = f.id_film
         LEFT JOIN kom c ON c.id_film = f.id_film
ORDER BY scor_sentiment DESC, f.rating DESC;
END sentiment_toate_filmele;

    -- ----------------------------------------------------------
    -- PROCEDURE: recomandari_client
    -- Algoritm de recomandare bazat pe preferinte:
    --   Pas 1: Identificam top 3 categorii cele mai vizionate de client
    --   Pas 2: Selectam filme din acele categorii pe care clientul NU le-a vazut
    --   Pas 3: Sortam dupa rating descrescator pentru a recomanda cele mai bune
    -- ----------------------------------------------------------
    PROCEDURE recomandari_client(p_id_client IN NUMBER, p_cursor OUT SYS_REFCURSOR) AS
BEGIN
OPEN p_cursor FOR
SELECT f.id_film, f.titlu, f.rating, f.durata, f.data_lansare,
       c.nume AS categorie
FROM FILME f
         JOIN CATEGORII c ON c.id_categorie = f.id_categorie
WHERE f.id_categorie IN (
    -- Subinterogare top-N cu pattern Oracle: ORDER BY in inline view + ROWNUM in exterior
    SELECT id_categorie FROM (
                                 SELECT f2.id_categorie,
                                        COUNT(*) AS nr_vizualizari_categorie
                                 FROM   VIZUALIZARI v
                                            JOIN   VERSIUNI_FILM vf ON vf.id_versiune = v.id_versiune
                                            JOIN   FILME f2         ON f2.id_film     = vf.id_film
                                 WHERE  v.id_client = p_id_client
                                 GROUP  BY f2.id_categorie
                                 ORDER  BY nr_vizualizari_categorie DESC
                             ) WHERE ROWNUM <= 3
)
  AND f.id_film NOT IN (
    -- Filmele deja vizionate de client (in orice versiune)
    SELECT DISTINCT f3.id_film
    FROM   VIZUALIZARI v2
               JOIN   VERSIUNI_FILM vf2 ON vf2.id_versiune = v2.id_versiune
               JOIN   FILME f3          ON f3.id_film      = vf2.id_film
    WHERE  v2.id_client = p_id_client
)
ORDER BY f.rating DESC;
END recomandari_client;

    -- ----------------------------------------------------------
    -- PROCEDURE: predictii_sezoniere
    -- Analiza pattern-uri de vizualizare pe luni calendaristice.
    -- Folosim SUM(COUNT(*)) OVER () ca functie analitica pentru
    -- a calcula procentul fara o a doua interogare.
    -- Rezultatul arata in ce luni sunt mai multe vizualizari
    -- (util pentru a prezice perioade cu trafic ridicat).
    -- ----------------------------------------------------------
    PROCEDURE predictii_sezoniere(p_cursor OUT SYS_REFCURSOR) AS
BEGIN
OPEN p_cursor FOR
SELECT
    TO_CHAR(v.data_vizualizare, 'MM') AS luna_nr,
    CASE TO_CHAR(v.data_vizualizare, 'MM')
        WHEN '01' THEN 'Ianuarie'    WHEN '02' THEN 'Februarie'
        WHEN '03' THEN 'Martie'      WHEN '04' THEN 'Aprilie'
        WHEN '05' THEN 'Mai'         WHEN '06' THEN 'Iunie'
        WHEN '07' THEN 'Iulie'       WHEN '08' THEN 'August'
        WHEN '09' THEN 'Septembrie'  WHEN '10' THEN 'Octombrie'
        WHEN '11' THEN 'Noiembrie'   WHEN '12' THEN 'Decembrie'
        END AS luna_nume,
    COUNT(*) AS nr_vizualizari,
    -- Procentul din totalul vizualizarilor (functie analitica)
    ROUND(COUNT(*) * 100 / SUM(COUNT(*)) OVER (), 1) AS procent
FROM VIZUALIZARI v
GROUP BY TO_CHAR(v.data_vizualizare, 'MM')
ORDER BY luna_nr;
END predictii_sezoniere;

    -- ----------------------------------------------------------
    -- PROCEDURE: predictii_categorii_sezon
    -- Identifica ce categorii de filme sunt preferate per anotimp.
    -- Util pentru a prezice ce filme sa fie promovate in anumite perioade.
    -- ----------------------------------------------------------
    PROCEDURE predictii_categorii_sezon(p_cursor OUT SYS_REFCURSOR) AS
BEGIN
OPEN p_cursor FOR
SELECT
    CASE
        WHEN TO_CHAR(v.data_vizualizare, 'MM') IN ('12','01','02') THEN 'Iarna'
        WHEN TO_CHAR(v.data_vizualizare, 'MM') IN ('03','04','05') THEN 'Primavara'
        WHEN TO_CHAR(v.data_vizualizare, 'MM') IN ('06','07','08') THEN 'Vara'
        ELSE 'Toamna'
        END AS sezon,
    c.nume AS categorie,
    COUNT(*) AS nr_vizualizari
FROM VIZUALIZARI v
         JOIN VERSIUNI_FILM vf ON vf.id_versiune = v.id_versiune
         JOIN FILME f          ON f.id_film      = vf.id_film
         JOIN CATEGORII c      ON c.id_categorie = f.id_categorie
GROUP BY
    CASE
        WHEN TO_CHAR(v.data_vizualizare, 'MM') IN ('12','01','02') THEN 'Iarna'
        WHEN TO_CHAR(v.data_vizualizare, 'MM') IN ('03','04','05') THEN 'Primavara'
        WHEN TO_CHAR(v.data_vizualizare, 'MM') IN ('06','07','08') THEN 'Vara'
        ELSE 'Toamna'
        END,
    c.id_categorie,
    c.nume
ORDER BY sezon, nr_vizualizari DESC;
END predictii_categorii_sezon;

END PKG_STATISTICI;
/