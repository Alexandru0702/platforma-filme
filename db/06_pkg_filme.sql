-- ============================================================
-- Script: 06_pkg_filme.sql
-- Descriere: Pachet PL/SQL pentru gestionarea filmelor si versiunilor
-- Compatibil: Oracle XE 11g
-- ============================================================

CREATE OR REPLACE PACKAGE pkg_filme AS

    -- Returneaza toate filmele cu informatii despre categorie
    PROCEDURE get_all_filme(p_cursor OUT SYS_REFCURSOR);

    -- Returneaza un film dupa ID
    PROCEDURE get_film_by_id(p_id_film IN NUMBER, p_cursor OUT SYS_REFCURSOR);

    -- Returneaza filmele dintr-o categorie
    PROCEDURE get_filme_by_categorie(p_id_categorie IN NUMBER, p_cursor OUT SYS_REFCURSOR);

    -- Returneaza top N filme dupa rating
    PROCEDURE get_top_filme(p_nr IN NUMBER, p_cursor OUT SYS_REFCURSOR);

    -- Adauga un film nou, returneaza ID-ul generat
    PROCEDURE insert_film(
        p_titlu        IN VARCHAR2,
        p_descriere    IN VARCHAR2,
        p_data_lansare IN DATE,
        p_durata       IN NUMBER,
        p_id_categorie IN NUMBER,
        p_id_film      OUT NUMBER
    );

    -- Modifica un film existent
    PROCEDURE update_film(
        p_id_film      IN NUMBER,
        p_titlu        IN VARCHAR2,
        p_descriere    IN VARCHAR2,
        p_data_lansare IN DATE,
        p_durata       IN NUMBER,
        p_id_categorie IN NUMBER
    );

    -- Sterge un film (daca nu are vizualizari sau voturi)
    PROCEDURE delete_film(p_id_film IN NUMBER);

    -- Returneaza toate versiunile unui film
    PROCEDURE get_versiuni_film(p_id_film IN NUMBER, p_cursor OUT SYS_REFCURSOR);

    -- Adauga o versiune pentru un film
    PROCEDURE insert_versiune(
        p_id_film    IN NUMBER,
        p_format     IN VARCHAR2,
        p_rezolutie  IN VARCHAR2,
        p_limba      IN VARCHAR2,
        p_subtitrare IN VARCHAR2,
        p_id_versiune OUT NUMBER
    );

    -- Dezactiveaza o versiune (activ = 0)
    PROCEDURE dezactiveaza_versiune(p_id_versiune IN NUMBER);

    -- Returneaza toate categoriile
    PROCEDURE get_all_categorii(p_cursor OUT SYS_REFCURSOR);

END pkg_filme;
/

CREATE OR REPLACE PACKAGE BODY pkg_filme AS

    PROCEDURE get_all_filme(p_cursor OUT SYS_REFCURSOR) AS
BEGIN
OPEN p_cursor FOR
SELECT f.id_film, f.titlu, f.descriere, f.data_lansare,
       f.durata, f.rating, f.id_categorie, c.nume AS categorie
FROM   FILME f
           JOIN   CATEGORII c ON c.id_categorie = f.id_categorie
ORDER  BY f.rating DESC, f.titlu;
END get_all_filme;

    PROCEDURE get_film_by_id(p_id_film IN NUMBER, p_cursor OUT SYS_REFCURSOR) AS
BEGIN
OPEN p_cursor FOR
SELECT f.id_film, f.titlu, f.descriere, f.data_lansare,
       f.durata, f.rating, f.id_categorie, c.nume AS categorie
FROM   FILME f
           JOIN   CATEGORII c ON c.id_categorie = f.id_categorie
WHERE  f.id_film = p_id_film;
END get_film_by_id;

    PROCEDURE get_filme_by_categorie(p_id_categorie IN NUMBER, p_cursor OUT SYS_REFCURSOR) AS
BEGIN
OPEN p_cursor FOR
SELECT f.id_film, f.titlu, f.descriere, f.data_lansare,
       f.durata, f.rating, f.id_categorie, c.nume AS categorie
FROM   FILME f
           JOIN   CATEGORII c ON c.id_categorie = f.id_categorie
WHERE  f.id_categorie = p_id_categorie
ORDER  BY f.rating DESC;
END get_filme_by_categorie;

    PROCEDURE get_top_filme(p_nr IN NUMBER, p_cursor OUT SYS_REFCURSOR) AS
BEGIN
OPEN p_cursor FOR
SELECT * FROM (
                  SELECT f.id_film, f.titlu, f.descriere, f.data_lansare,
                         f.durata, f.rating, f.id_categorie, c.nume AS categorie
                  FROM   FILME f
                             JOIN   CATEGORII c ON c.id_categorie = f.id_categorie
                  ORDER  BY f.rating DESC
              ) WHERE ROWNUM <= p_nr;
END get_top_filme;

    PROCEDURE insert_film(
        p_titlu        IN VARCHAR2,
        p_descriere    IN VARCHAR2,
        p_data_lansare IN DATE,
        p_durata       IN NUMBER,
        p_id_categorie IN NUMBER,
        p_id_film      OUT NUMBER
    ) AS
        v_count NUMBER;
BEGIN
        -- Validare: titlul nu trebuie sa existe deja
SELECT COUNT(*) INTO v_count FROM FILME WHERE UPPER(titlu) = UPPER(p_titlu);
IF v_count > 0 THEN
            RAISE_APPLICATION_ERROR(-20010, 'Exista deja un film cu titlul "' || p_titlu || '".');
END IF;

        -- Validare: categoria trebuie sa existe
SELECT COUNT(*) INTO v_count FROM CATEGORII WHERE id_categorie = p_id_categorie;
IF v_count = 0 THEN
            RAISE_APPLICATION_ERROR(-20011, 'Categoria cu ID=' || p_id_categorie || ' nu exista.');
END IF;

        p_id_film := seq_filme.NEXTVAL;
INSERT INTO FILME (id_film, titlu, descriere, data_lansare, durata, rating, id_categorie)
VALUES (p_id_film, p_titlu, p_descriere, p_data_lansare, p_durata, 0, p_id_categorie);
COMMIT;
END insert_film;

    PROCEDURE update_film(
        p_id_film      IN NUMBER,
        p_titlu        IN VARCHAR2,
        p_descriere    IN VARCHAR2,
        p_data_lansare IN DATE,
        p_durata       IN NUMBER,
        p_id_categorie IN NUMBER
    ) AS
        v_count NUMBER;
BEGIN
SELECT COUNT(*) INTO v_count FROM FILME WHERE id_film = p_id_film;
IF v_count = 0 THEN
            RAISE_APPLICATION_ERROR(-20012, 'Filmul cu ID=' || p_id_film || ' nu exista.');
END IF;

UPDATE FILME
SET    titlu        = p_titlu,
       descriere    = p_descriere,
       data_lansare = p_data_lansare,
       durata       = p_durata,
       id_categorie = p_id_categorie
WHERE  id_film = p_id_film;
COMMIT;
END update_film;

    PROCEDURE delete_film(p_id_film IN NUMBER) AS
        v_count NUMBER;
BEGIN
SELECT COUNT(*) INTO v_count
FROM   VIZUALIZARI v
           JOIN   VERSIUNI_FILM vf ON vf.id_versiune = v.id_versiune
WHERE  vf.id_film = p_id_film;

IF v_count > 0 THEN
            RAISE_APPLICATION_ERROR(-20013,
                'Filmul nu poate fi sters deoarece are ' || v_count || ' vizualizari inregistrate.');
END IF;

DELETE FROM DISTRIBUTIE WHERE id_film = p_id_film;
DELETE FROM VOTURI       WHERE id_film = p_id_film;
DELETE FROM COMENTARII   WHERE id_film = p_id_film;
DELETE FROM CARACTERIZARI_CLIENT WHERE id_film = p_id_film;
DELETE FROM VERSIUNI_FILM WHERE id_film = p_id_film;
DELETE FROM FILME WHERE id_film = p_id_film;
COMMIT;
END delete_film;

    PROCEDURE get_versiuni_film(p_id_film IN NUMBER, p_cursor OUT SYS_REFCURSOR) AS
BEGIN
OPEN p_cursor FOR
SELECT id_versiune, id_film, format, rezolutie, limba, subtitrare, activ
FROM   VERSIUNI_FILM
WHERE  id_film = p_id_film
ORDER  BY format, limba;
END get_versiuni_film;

    PROCEDURE insert_versiune(
        p_id_film     IN NUMBER,
        p_format      IN VARCHAR2,
        p_rezolutie   IN VARCHAR2,
        p_limba       IN VARCHAR2,
        p_subtitrare  IN VARCHAR2,
        p_id_versiune OUT NUMBER
    ) AS
BEGIN
        p_id_versiune := seq_versiuni.NEXTVAL;
INSERT INTO VERSIUNI_FILM (id_versiune, id_film, format, rezolutie, limba, subtitrare, activ)
VALUES (p_id_versiune, p_id_film, p_format, p_rezolutie, p_limba, p_subtitrare, 1);
COMMIT;
END insert_versiune;

    PROCEDURE dezactiveaza_versiune(p_id_versiune IN NUMBER) AS
BEGIN
UPDATE VERSIUNI_FILM SET activ = 0 WHERE id_versiune = p_id_versiune;
COMMIT;
END dezactiveaza_versiune;

    PROCEDURE get_all_categorii(p_cursor OUT SYS_REFCURSOR) AS
BEGIN
OPEN p_cursor FOR
SELECT id_categorie, nume, descriere FROM CATEGORII ORDER BY nume;
END get_all_categorii;

END pkg_filme;
/