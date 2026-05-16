-- ============================================================
-- Script: 09_pkg_interactiune.sql
-- Descriere: Pachet PL/SQL pentru vizualizari, voturi,
--            comentarii si caracterizari
-- Exceptii custom prinse in aplicatia Java:
--   -20001: versiune inactiva (trigger)
--   -20040: vot duplicat
--   -20041: nota invalida
-- Compatibil: Oracle XE 11g
-- ============================================================

CREATE OR REPLACE PACKAGE pkg_interactiune AS

    -- VIZUALIZARI
    PROCEDURE add_vizualizare(
        p_id_client   IN NUMBER,
        p_id_versiune IN NUMBER,
        p_durata      IN NUMBER,
        p_stare       IN VARCHAR2,
        p_id_viz      OUT NUMBER
    );

    PROCEDURE get_vizualizari_film(p_id_film IN NUMBER, p_cursor OUT SYS_REFCURSOR);

    -- VOTURI
    -- Ridica -20040 daca clientul a mai votat deja acest film
    PROCEDURE add_vot(
        p_id_client IN NUMBER,
        p_id_film   IN NUMBER,
        p_nota      IN NUMBER
    );

    PROCEDURE update_vot(p_id_client IN NUMBER, p_id_film IN NUMBER, p_nota_noua IN NUMBER);

    PROCEDURE get_voturi_film(p_id_film IN NUMBER, p_cursor OUT SYS_REFCURSOR);

    -- COMENTARII
    PROCEDURE add_comentariu(
        p_id_client IN NUMBER,
        p_id_film   IN NUMBER,
        p_id_actor  IN NUMBER,
        p_continut  IN VARCHAR2,
        p_id_com    OUT NUMBER
    );

    PROCEDURE delete_comentariu(p_id_comentariu IN NUMBER, p_id_client IN NUMBER);

    PROCEDURE get_comentarii_film(p_id_film IN NUMBER, p_cursor OUT SYS_REFCURSOR);

    PROCEDURE get_comentarii_actor(p_id_actor IN NUMBER, p_cursor OUT SYS_REFCURSOR);

    -- CARACTERIZARI
    PROCEDURE add_caracterizare(
        p_id_client  IN NUMBER,
        p_id_film    IN NUMBER,
        p_id_optiune IN NUMBER
    );

    PROCEDURE remove_caracterizare(
        p_id_client  IN NUMBER,
        p_id_film    IN NUMBER,
        p_id_optiune IN NUMBER
    );

    PROCEDURE get_caracterizari_film(p_id_film IN NUMBER, p_cursor OUT SYS_REFCURSOR);

    PROCEDURE get_optiuni_disponibile(p_cursor OUT SYS_REFCURSOR);

    -- Caracterizarile unui client pentru un film specific
    PROCEDURE get_caracterizari_client_film(
        p_id_client IN NUMBER,
        p_id_film   IN NUMBER,
        p_cursor    OUT SYS_REFCURSOR
    );

END pkg_interactiune;
/

CREATE OR REPLACE PACKAGE BODY pkg_interactiune AS

    -- -------------------------------------------------------
    -- VIZUALIZARI
    -- -------------------------------------------------------
    PROCEDURE add_vizualizare(
        p_id_client   IN NUMBER,
        p_id_versiune IN NUMBER,
        p_durata      IN NUMBER,
        p_stare       IN VARCHAR2,
        p_id_viz      OUT NUMBER
    ) AS
BEGIN
        -- Triggerul trg_prevent_inactive_version verifica automat daca versiunea e activa
        -- Si ridica -20001 daca nu este (prins in Java)
        p_id_viz := seq_vizualizari.NEXTVAL;
INSERT INTO VIZUALIZARI (id_vizualizare, id_client, id_versiune,
                         data_vizualizare, durata_vizionata, stare)
VALUES (p_id_viz, p_id_client, p_id_versiune, SYSDATE, p_durata, p_stare);
COMMIT;
END add_vizualizare;

    PROCEDURE get_vizualizari_film(p_id_film IN NUMBER, p_cursor OUT SYS_REFCURSOR) AS
BEGIN
OPEN p_cursor FOR
SELECT v.id_vizualizare, v.data_vizualizare, v.durata_vizionata, v.stare,
       c.prenume || ' ' || c.nume AS client,
       vf.format, vf.limba
FROM   VIZUALIZARI v
           JOIN   CLIENTI c        ON c.id_client    = v.id_client
           JOIN   VERSIUNI_FILM vf ON vf.id_versiune = v.id_versiune
WHERE  vf.id_film = p_id_film
ORDER  BY v.data_vizualizare DESC;
END get_vizualizari_film;

    -- -------------------------------------------------------
    -- VOTURI
    -- -------------------------------------------------------
    PROCEDURE add_vot(
        p_id_client IN NUMBER,
        p_id_film   IN NUMBER,
        p_nota      IN NUMBER
    ) AS
        v_count NUMBER;
BEGIN
        -- Validare nota
        IF p_nota < 1 OR p_nota > 10 THEN
            RAISE_APPLICATION_ERROR(-20041,
                'Nota trebuie sa fie intre 1 si 10. Ati introdus: ' || p_nota);
END IF;

        -- Verificare vot duplicat (exceptie prinsa in Java)
SELECT COUNT(*) INTO v_count
FROM   VOTURI
WHERE  id_client = p_id_client AND id_film = p_id_film;

IF v_count > 0 THEN
            RAISE_APPLICATION_ERROR(-20040,
                'Ati votat deja acest film. Puteti modifica votul existent folosind optiunea de editare.');
END IF;

INSERT INTO VOTURI (id_vot, id_client, id_film, nota, data_vot)
VALUES (seq_voturi.NEXTVAL, p_id_client, p_id_film, p_nota, SYSDATE);
COMMIT;
-- Triggerul trg_update_rating_film actualizeaza automat rating-ul filmului
END add_vot;

    PROCEDURE update_vot(p_id_client IN NUMBER, p_id_film IN NUMBER, p_nota_noua IN NUMBER) AS
        v_count NUMBER;
BEGIN
        IF p_nota_noua < 1 OR p_nota_noua > 10 THEN
            RAISE_APPLICATION_ERROR(-20041, 'Nota trebuie sa fie intre 1 si 10.');
END IF;

SELECT COUNT(*) INTO v_count
FROM   VOTURI
WHERE  id_client = p_id_client AND id_film = p_id_film;

IF v_count = 0 THEN
            RAISE_APPLICATION_ERROR(-20042, 'Nu exista niciun vot al acestui client pentru filmul selectat.');
END IF;

UPDATE VOTURI SET nota = p_nota_noua, data_vot = SYSDATE
WHERE  id_client = p_id_client AND id_film = p_id_film;
COMMIT;
END update_vot;

    PROCEDURE get_voturi_film(p_id_film IN NUMBER, p_cursor OUT SYS_REFCURSOR) AS
BEGIN
OPEN p_cursor FOR
SELECT vt.id_vot, vt.nota, vt.data_vot,
       c.id_client, c.prenume || ' ' || c.nume AS client
FROM   VOTURI vt
           JOIN   CLIENTI c ON c.id_client = vt.id_client
WHERE  vt.id_film = p_id_film
ORDER  BY vt.data_vot DESC;
END get_voturi_film;

    -- -------------------------------------------------------
    -- COMENTARII
    -- -------------------------------------------------------
    PROCEDURE add_comentariu(
        p_id_client IN NUMBER,
        p_id_film   IN NUMBER,
        p_id_actor  IN NUMBER,
        p_continut  IN VARCHAR2,
        p_id_com    OUT NUMBER
    ) AS
BEGIN
        -- Triggerul trg_auto_tip_comentariu seteaza automat campul TIP
        p_id_com := seq_comentarii.NEXTVAL;
INSERT INTO COMENTARII (id_comentariu, id_client, id_film, id_actor,
                        continut, data_comentariu)
VALUES (p_id_com, p_id_client, p_id_film, p_id_actor, p_continut, SYSDATE);
COMMIT;
END add_comentariu;

    PROCEDURE delete_comentariu(p_id_comentariu IN NUMBER, p_id_client IN NUMBER) AS
        v_count NUMBER;
BEGIN
        -- Doar clientul care a scris comentariul il poate sterge
SELECT COUNT(*) INTO v_count
FROM   COMENTARII
WHERE  id_comentariu = p_id_comentariu AND id_client = p_id_client;

IF v_count = 0 THEN
            RAISE_APPLICATION_ERROR(-20043,
                'Comentariul nu exista sau nu aveti permisiunea de a-l sterge.');
END IF;

DELETE FROM COMENTARII WHERE id_comentariu = p_id_comentariu;
COMMIT;
END delete_comentariu;

    PROCEDURE get_comentarii_film(p_id_film IN NUMBER, p_cursor OUT SYS_REFCURSOR) AS
BEGIN
OPEN p_cursor FOR
SELECT cm.id_comentariu, cm.continut, cm.data_comentariu,
       c.prenume || ' ' || c.nume AS client, cm.tip
FROM   COMENTARII cm
           JOIN   CLIENTI c ON c.id_client = cm.id_client
WHERE  cm.id_film = p_id_film
ORDER  BY cm.data_comentariu DESC;
END get_comentarii_film;

    PROCEDURE get_comentarii_actor(p_id_actor IN NUMBER, p_cursor OUT SYS_REFCURSOR) AS
BEGIN
OPEN p_cursor FOR
SELECT cm.id_comentariu, cm.continut, cm.data_comentariu,
       c.prenume || ' ' || c.nume AS client
FROM   COMENTARII cm
           JOIN   CLIENTI c ON c.id_client = cm.id_client
WHERE  cm.id_actor = p_id_actor
ORDER  BY cm.data_comentariu DESC;
END get_comentarii_actor;

    -- -------------------------------------------------------
    -- CARACTERIZARI
    -- -------------------------------------------------------
    PROCEDURE add_caracterizare(
        p_id_client  IN NUMBER,
        p_id_film    IN NUMBER,
        p_id_optiune IN NUMBER
    ) AS
        v_count NUMBER;
BEGIN
SELECT COUNT(*) INTO v_count
FROM   CARACTERIZARI_CLIENT
WHERE  id_client = p_id_client AND id_film = p_id_film AND id_optiune = p_id_optiune;

IF v_count = 0 THEN
            INSERT INTO CARACTERIZARI_CLIENT
                (id_caracterizare, id_client, id_film, id_optiune, data_caracterizare)
            VALUES (seq_caracterizari.NEXTVAL, p_id_client, p_id_film, p_id_optiune, SYSDATE);
COMMIT;
END IF;
END add_caracterizare;

    PROCEDURE remove_caracterizare(
        p_id_client  IN NUMBER,
        p_id_film    IN NUMBER,
        p_id_optiune IN NUMBER
    ) AS
BEGIN
DELETE FROM CARACTERIZARI_CLIENT
WHERE  id_client  = p_id_client
  AND    id_film    = p_id_film
  AND    id_optiune = p_id_optiune;
COMMIT;
END remove_caracterizare;

    PROCEDURE get_caracterizari_film(p_id_film IN NUMBER, p_cursor OUT SYS_REFCURSOR) AS
BEGIN
OPEN p_cursor FOR
SELECT co.denumire, co.tip_sentiment,
       COUNT(cc.id_caracterizare) AS nr_selectii
FROM   CARACTERIZARI_OPTIUNI co
           LEFT JOIN CARACTERIZARI_CLIENT cc
                     ON cc.id_optiune = co.id_optiune AND cc.id_film = p_id_film
GROUP  BY co.id_optiune, co.denumire, co.tip_sentiment
ORDER  BY nr_selectii DESC;
END get_caracterizari_film;

    PROCEDURE get_optiuni_disponibile(p_cursor OUT SYS_REFCURSOR) AS
BEGIN
OPEN p_cursor FOR
SELECT id_optiune, denumire, tip_sentiment
FROM   CARACTERIZARI_OPTIUNI
ORDER  BY tip_sentiment, denumire;
END get_optiuni_disponibile;

    PROCEDURE get_caracterizari_client_film(
        p_id_client IN NUMBER,
        p_id_film   IN NUMBER,
        p_cursor    OUT SYS_REFCURSOR
    ) AS
BEGIN
OPEN p_cursor FOR
SELECT co.id_optiune, co.denumire, co.tip_sentiment
FROM   CARACTERIZARI_CLIENT cc
           JOIN   CARACTERIZARI_OPTIUNI co ON co.id_optiune = cc.id_optiune
WHERE  cc.id_client = p_id_client AND cc.id_film = p_id_film;
END get_caracterizari_client_film;

END pkg_interactiune;
/