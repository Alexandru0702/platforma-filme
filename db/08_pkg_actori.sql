-- ============================================================
-- Script: 08_pkg_actori.sql
-- Descriere: Pachet PL/SQL pentru gestionarea actorilor si distributiei
-- Compatibil: Oracle XE 11g
-- ============================================================

CREATE OR REPLACE PACKAGE pkg_actori AS

    PROCEDURE get_all_actori(p_cursor OUT SYS_REFCURSOR);

    PROCEDURE get_actor_by_id(p_id_actor IN NUMBER, p_cursor OUT SYS_REFCURSOR);

    PROCEDURE insert_actor(
        p_prenume      IN VARCHAR2,
        p_nume_familie IN VARCHAR2,
        p_nume_scena   IN VARCHAR2,
        p_data_nastere IN DATE,
        p_nationalitate IN VARCHAR2,
        p_id_actor     OUT NUMBER
    );

    PROCEDURE update_actor(
        p_id_actor     IN NUMBER,
        p_prenume      IN VARCHAR2,
        p_nume_familie IN VARCHAR2,
        p_nume_scena   IN VARCHAR2,
        p_data_nastere IN DATE,
        p_nationalitate IN VARCHAR2
    );

    PROCEDURE delete_actor(p_id_actor IN NUMBER);

    -- Filmele in care apare un actor
    PROCEDURE get_filme_actor(p_id_actor IN NUMBER, p_cursor OUT SYS_REFCURSOR);

    -- Actorii dintr-un film (distributia)
    PROCEDURE get_distributie_film(p_id_film IN NUMBER, p_cursor OUT SYS_REFCURSOR);

    -- Adauga un actor in distributia unui film
    PROCEDURE add_distributie(
        p_id_film   IN NUMBER,
        p_id_actor  IN NUMBER,
        p_rol       IN VARCHAR2,
        p_tip_rol   IN VARCHAR2,
        p_comentariu IN VARCHAR2
    );

    -- Sterge un actor din distributia unui film
    PROCEDURE remove_distributie(p_id_film IN NUMBER, p_id_actor IN NUMBER);

END pkg_actori;
/

CREATE OR REPLACE PACKAGE BODY pkg_actori AS

    PROCEDURE get_all_actori(p_cursor OUT SYS_REFCURSOR) AS
BEGIN
OPEN p_cursor FOR
SELECT a.id_actor, a.prenume, a.nume_familie, a.nume_scena,
       a.data_nastere, a.nationalitate,
       COUNT(d.id_distributie) AS nr_filme
FROM   ACTORI a
           LEFT JOIN DISTRIBUTIE d ON d.id_actor = a.id_actor
GROUP  BY a.id_actor, a.prenume, a.nume_familie, a.nume_scena,
          a.data_nastere, a.nationalitate
ORDER  BY a.nume_familie, a.prenume;
END get_all_actori;

    PROCEDURE get_actor_by_id(p_id_actor IN NUMBER, p_cursor OUT SYS_REFCURSOR) AS
BEGIN
OPEN p_cursor FOR
SELECT id_actor, prenume, nume_familie, nume_scena, data_nastere, nationalitate
FROM   ACTORI
WHERE  id_actor = p_id_actor;
END get_actor_by_id;

    PROCEDURE insert_actor(
        p_prenume       IN VARCHAR2,
        p_nume_familie  IN VARCHAR2,
        p_nume_scena    IN VARCHAR2,
        p_data_nastere  IN DATE,
        p_nationalitate IN VARCHAR2,
        p_id_actor      OUT NUMBER
    ) AS
BEGIN
        p_id_actor := seq_actori.NEXTVAL;
INSERT INTO ACTORI (id_actor, prenume, nume_familie, nume_scena, data_nastere, nationalitate)
VALUES (p_id_actor, p_prenume, p_nume_familie, p_nume_scena, p_data_nastere, p_nationalitate);
COMMIT;
END insert_actor;

    PROCEDURE update_actor(
        p_id_actor      IN NUMBER,
        p_prenume       IN VARCHAR2,
        p_nume_familie  IN VARCHAR2,
        p_nume_scena    IN VARCHAR2,
        p_data_nastere  IN DATE,
        p_nationalitate IN VARCHAR2
    ) AS
        v_count NUMBER;
BEGIN
SELECT COUNT(*) INTO v_count FROM ACTORI WHERE id_actor = p_id_actor;
IF v_count = 0 THEN
            RAISE_APPLICATION_ERROR(-20030, 'Actorul cu ID=' || p_id_actor || ' nu exista.');
END IF;

UPDATE ACTORI
SET    prenume = p_prenume, nume_familie = p_nume_familie,
       nume_scena = p_nume_scena, data_nastere = p_data_nastere,
       nationalitate = p_nationalitate
WHERE  id_actor = p_id_actor;
COMMIT;
END update_actor;

    PROCEDURE delete_actor(p_id_actor IN NUMBER) AS
        v_count NUMBER;
BEGIN
DELETE FROM DISTRIBUTIE WHERE id_actor = p_id_actor;
DELETE FROM COMENTARII   WHERE id_actor = p_id_actor;
DELETE FROM ACTORI       WHERE id_actor = p_id_actor;
COMMIT;
END delete_actor;

    PROCEDURE get_filme_actor(p_id_actor IN NUMBER, p_cursor OUT SYS_REFCURSOR) AS
BEGIN
OPEN p_cursor FOR
SELECT f.id_film, f.titlu, f.rating, f.data_lansare,
       d.rol, d.tip_rol, d.comentariu, c.nume AS categorie
FROM   DISTRIBUTIE d
           JOIN   FILME f     ON f.id_film      = d.id_film
           JOIN   CATEGORII c ON c.id_categorie = f.id_categorie
WHERE  d.id_actor = p_id_actor
ORDER  BY f.data_lansare DESC;
END get_filme_actor;

    PROCEDURE get_distributie_film(p_id_film IN NUMBER, p_cursor OUT SYS_REFCURSOR) AS
BEGIN
OPEN p_cursor FOR
SELECT a.id_actor, a.prenume, a.nume_familie,
       NVL(a.nume_scena, a.prenume || ' ' || a.nume_familie) AS nume_display,
       a.nationalitate, d.rol, d.tip_rol, d.comentariu
FROM   DISTRIBUTIE d
           JOIN   ACTORI a ON a.id_actor = d.id_actor
WHERE  d.id_film = p_id_film
ORDER  BY DECODE(d.tip_rol, 'PRINCIPAL', 1, 'SECUNDAR', 2, 3);
END get_distributie_film;

    PROCEDURE add_distributie(
        p_id_film    IN NUMBER,
        p_id_actor   IN NUMBER,
        p_rol        IN VARCHAR2,
        p_tip_rol    IN VARCHAR2,
        p_comentariu IN VARCHAR2
    ) AS
        v_count NUMBER;
BEGIN
        -- Verificam daca asocierea exista deja
SELECT COUNT(*) INTO v_count
FROM   DISTRIBUTIE
WHERE  id_film = p_id_film AND id_actor = p_id_actor;

IF v_count > 0 THEN
            RAISE_APPLICATION_ERROR(-20031,
                'Actorul este deja inregistrat in distributia acestui film.');
END IF;

INSERT INTO DISTRIBUTIE (id_distributie, id_film, id_actor, rol, tip_rol, comentariu)
VALUES (seq_distributie.NEXTVAL, p_id_film, p_id_actor, p_rol, p_tip_rol, p_comentariu);
COMMIT;
END add_distributie;

    PROCEDURE remove_distributie(p_id_film IN NUMBER, p_id_actor IN NUMBER) AS
BEGIN
DELETE FROM DISTRIBUTIE WHERE id_film = p_id_film AND id_actor = p_id_actor;
COMMIT;
END remove_distributie;

END pkg_actori;
/