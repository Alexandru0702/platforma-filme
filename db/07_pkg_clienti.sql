-- ============================================================
-- Script: 07_pkg_clienti.sql
-- Descriere: Pachet PL/SQL pentru gestionarea clientilor
-- Compatibil: Oracle XE 11g
-- ============================================================

CREATE OR REPLACE PACKAGE pkg_clienti AS

    PROCEDURE get_all_clienti(p_cursor OUT SYS_REFCURSOR);

    PROCEDURE get_client_by_id(p_id_client IN NUMBER, p_cursor OUT SYS_REFCURSOR);

    PROCEDURE insert_client(
        p_prenume       IN VARCHAR2,
        p_nume          IN VARCHAR2,
        p_telefon_acasa IN VARCHAR2,
        p_adresa        IN VARCHAR2,
        p_oras          IN VARCHAR2,
        p_email         IN VARCHAR2,
        p_telefon_mobil IN VARCHAR2,
        p_id_client     OUT NUMBER
    );

    PROCEDURE update_client(
        p_id_client     IN NUMBER,
        p_prenume       IN VARCHAR2,
        p_nume          IN VARCHAR2,
        p_telefon_acasa IN VARCHAR2,
        p_adresa        IN VARCHAR2,
        p_oras          IN VARCHAR2,
        p_email         IN VARCHAR2,
        p_telefon_mobil IN VARCHAR2
    );

    PROCEDURE delete_client(p_id_client IN NUMBER);

    -- Istoricul vizualizarilor unui client
    PROCEDURE get_istoric_client(p_id_client IN NUMBER, p_cursor OUT SYS_REFCURSOR);

    -- Statistici profil cinematografic client
    PROCEDURE get_profil_client(p_id_client IN NUMBER, p_cursor OUT SYS_REFCURSOR);

    -- Filmele votate de un client
    PROCEDURE get_voturi_client(p_id_client IN NUMBER, p_cursor OUT SYS_REFCURSOR);

END pkg_clienti;
/

CREATE OR REPLACE PACKAGE BODY pkg_clienti AS

    PROCEDURE get_all_clienti(p_cursor OUT SYS_REFCURSOR) AS
BEGIN
OPEN p_cursor FOR
SELECT id_client, prenume, nume, telefon_acasa,
       adresa, oras, email, telefon_mobil, data_inregistrare
FROM   CLIENTI
ORDER  BY nume, prenume;
END get_all_clienti;

    PROCEDURE get_client_by_id(p_id_client IN NUMBER, p_cursor OUT SYS_REFCURSOR) AS
BEGIN
OPEN p_cursor FOR
SELECT id_client, prenume, nume, telefon_acasa,
       adresa, oras, email, telefon_mobil, data_inregistrare
FROM   CLIENTI
WHERE  id_client = p_id_client;
END get_client_by_id;

    PROCEDURE insert_client(
        p_prenume       IN VARCHAR2,
        p_nume          IN VARCHAR2,
        p_telefon_acasa IN VARCHAR2,
        p_adresa        IN VARCHAR2,
        p_oras          IN VARCHAR2,
        p_email         IN VARCHAR2,
        p_telefon_mobil IN VARCHAR2,
        p_id_client     OUT NUMBER
    ) AS
        v_count NUMBER;
BEGIN
        -- Validare email unic
        IF p_email IS NOT NULL THEN
SELECT COUNT(*) INTO v_count FROM CLIENTI WHERE UPPER(email) = UPPER(p_email);
IF v_count > 0 THEN
                RAISE_APPLICATION_ERROR(-20020,
                    'Adresa de email "' || p_email || '" este deja inregistrata in sistem.');
END IF;
END IF;

        p_id_client := seq_clienti.NEXTVAL;
INSERT INTO CLIENTI (id_client, prenume, nume, telefon_acasa, adresa, oras, email, telefon_mobil, data_inregistrare)
VALUES (p_id_client, p_prenume, p_nume, p_telefon_acasa, p_adresa, p_oras, p_email, p_telefon_mobil, SYSDATE);
COMMIT;
END insert_client;

    PROCEDURE update_client(
        p_id_client     IN NUMBER,
        p_prenume       IN VARCHAR2,
        p_nume          IN VARCHAR2,
        p_telefon_acasa IN VARCHAR2,
        p_adresa        IN VARCHAR2,
        p_oras          IN VARCHAR2,
        p_email         IN VARCHAR2,
        p_telefon_mobil IN VARCHAR2
    ) AS
        v_count NUMBER;
BEGIN
SELECT COUNT(*) INTO v_count FROM CLIENTI WHERE id_client = p_id_client;
IF v_count = 0 THEN
            RAISE_APPLICATION_ERROR(-20021, 'Clientul cu ID=' || p_id_client || ' nu exista.');
END IF;

        -- Validare email unic (exclude clientul curent)
        IF p_email IS NOT NULL THEN
SELECT COUNT(*) INTO v_count
FROM   CLIENTI
WHERE  UPPER(email) = UPPER(p_email) AND id_client != p_id_client;
IF v_count > 0 THEN
                RAISE_APPLICATION_ERROR(-20020, 'Adresa de email este deja folosita de alt client.');
END IF;
END IF;

UPDATE CLIENTI
SET    prenume = p_prenume, nume = p_nume,
       telefon_acasa = p_telefon_acasa, adresa = p_adresa,
       oras = p_oras, email = p_email, telefon_mobil = p_telefon_mobil
WHERE  id_client = p_id_client;
COMMIT;
END update_client;

    PROCEDURE delete_client(p_id_client IN NUMBER) AS
        v_count NUMBER;
BEGIN
SELECT COUNT(*) INTO v_count FROM VIZUALIZARI WHERE id_client = p_id_client;
IF v_count > 0 THEN
            RAISE_APPLICATION_ERROR(-20022,
                'Clientul nu poate fi sters - are ' || v_count || ' vizualizari inregistrate.');
END IF;

DELETE FROM CARACTERIZARI_CLIENT WHERE id_client = p_id_client;
DELETE FROM COMENTARII WHERE id_client = p_id_client;
DELETE FROM VOTURI WHERE id_client = p_id_client;
DELETE FROM CLIENTI WHERE id_client = p_id_client;
COMMIT;
END delete_client;

    PROCEDURE get_istoric_client(p_id_client IN NUMBER, p_cursor OUT SYS_REFCURSOR) AS
BEGIN
OPEN p_cursor FOR
SELECT v.id_vizualizare, v.data_vizualizare, v.durata_vizionata, v.stare,
       f.titlu AS titlu_film, vf.format, vf.limba,
       c.nume  AS categorie
FROM   VIZUALIZARI v
           JOIN   VERSIUNI_FILM vf ON vf.id_versiune = v.id_versiune
           JOIN   FILME f          ON f.id_film      = vf.id_film
           JOIN   CATEGORII c      ON c.id_categorie = f.id_categorie
WHERE  v.id_client = p_id_client
ORDER  BY v.data_vizualizare DESC;
END get_istoric_client;

    PROCEDURE get_profil_client(p_id_client IN NUMBER, p_cursor OUT SYS_REFCURSOR) AS
BEGIN
        -- Returnare statistici agregat pe categorii vizionate
OPEN p_cursor FOR
SELECT c.nume AS categorie,
       COUNT(DISTINCT f.id_film) AS filme_vizionate,
       COUNT(v.id_vizualizare)   AS total_vizualizari,
       ROUND(AVG(vt.nota), 2)    AS rating_mediu_acordat
FROM   VIZUALIZARI v
           JOIN   VERSIUNI_FILM vf ON vf.id_versiune = v.id_versiune
           JOIN   FILME f          ON f.id_film      = vf.id_film
           JOIN   CATEGORII c      ON c.id_categorie = f.id_categorie
           LEFT JOIN VOTURI vt     ON vt.id_film = f.id_film AND vt.id_client = p_id_client
WHERE  v.id_client = p_id_client
GROUP  BY c.id_categorie, c.nume
ORDER  BY total_vizualizari DESC;
END get_profil_client;

    PROCEDURE get_voturi_client(p_id_client IN NUMBER, p_cursor OUT SYS_REFCURSOR) AS
BEGIN
OPEN p_cursor FOR
SELECT vt.id_vot, vt.nota, vt.data_vot,
       f.id_film, f.titlu, f.rating AS rating_global
FROM   VOTURI vt
           JOIN   FILME f ON f.id_film = vt.id_film
WHERE  vt.id_client = p_id_client
ORDER  BY vt.data_vot DESC;
END get_voturi_client;

END pkg_clienti;
/