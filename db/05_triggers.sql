-- ============================================================
-- Script: 05_triggers.sql
-- Descriere: Triggere pentru automatizarea operatiilor
-- Compatibil: Oracle XE 11g (11.2.0.2)
-- ============================================================

-- -------------------------------------------------------
-- TRIGGER 1: trg_update_rating_film
-- Scop: Recalculeaza automat rating-ul unui film dupa
--       fiecare INSERT/UPDATE/DELETE pe tabelul VOTURI
-- Tip: COMPOUND TRIGGER (Oracle 11g) - evita eroarea
--      ORA-04091 (mutating table)
-- -------------------------------------------------------
CREATE OR REPLACE TRIGGER trg_update_rating_film
FOR INSERT OR UPDATE OR DELETE ON VOTURI
    COMPOUND TRIGGER

    -- Stocam ID-urile filmelor afectate intre fazele triggerului
    TYPE t_ids IS TABLE OF NUMBER INDEX BY BINARY_INTEGER;
v_filme_afectate t_ids;
    v_idx            BINARY_INTEGER := 0;

    -- Faza ROW: colectam id_film-urile afectate (fara SELECT pe VOTURI)
    AFTER EACH ROW IS
BEGIN
        v_idx := v_idx + 1;
        IF INSERTING OR UPDATING THEN
            v_filme_afectate(v_idx) := :NEW.id_film;
ELSE -- DELETING
            v_filme_afectate(v_idx) := :OLD.id_film;
END IF;
END AFTER EACH ROW;

    -- Faza STATEMENT: acum tabelul nu mai e mutant, facem UPDATE
    AFTER STATEMENT IS
BEGIN
FOR i IN 1..v_filme_afectate.COUNT LOOP
UPDATE FILME
SET rating = (
    SELECT NVL(ROUND(AVG(nota), 2), 0)
    FROM   VOTURI
    WHERE  id_film = v_filme_afectate(i)
)
WHERE id_film = v_filme_afectate(i);
END LOOP;
END AFTER STATEMENT;

END trg_update_rating_film;
/

-- -------------------------------------------------------
-- TRIGGER 2: trg_prevent_inactive_version
-- Scop: Blocheaza vizualizarea unei versiuni de film inactive
--       Ridica exceptie custom prinsa in aplicatia Java
-- Tip: BEFORE INSERT FOR EACH ROW pe VIZUALIZARI
-- Exceptie: -20001 (prinsa in GlobalExceptionHandler.java)
-- -------------------------------------------------------
CREATE OR REPLACE TRIGGER trg_prevent_inactive_version
BEFORE INSERT ON VIZUALIZARI
FOR EACH ROW
DECLARE
v_activ  NUMBER(1);
    v_titlu  VARCHAR2(200);
BEGIN
    -- Verificam daca versiunea selectata este activa
SELECT vf.activ, f.titlu
INTO   v_activ, v_titlu
FROM   VERSIUNI_FILM vf
           JOIN   FILME f ON f.id_film = vf.id_film
WHERE  vf.id_versiune = :NEW.id_versiune;

IF v_activ = 0 THEN
        RAISE_APPLICATION_ERROR(-20001,
            'Versiunea selectata pentru "' || v_titlu ||
            '" nu este activa. Va rugam alegeti o alta versiune disponibila.');
END IF;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20002,
            'Versiunea cu ID=' || :NEW.id_versiune || ' nu exista in sistem.');
END trg_prevent_inactive_version;
/

-- -------------------------------------------------------
-- TRIGGER 3: trg_auto_tip_comentariu
-- Scop: Seteaza automat campul TIP din COMENTARII
--       in functie de ce FK este completat (id_film sau id_actor)
--       Elimina necesitatea setarii manuale a campului tip
-- Tip: BEFORE INSERT OR UPDATE FOR EACH ROW pe COMENTARII
-- -------------------------------------------------------
CREATE OR REPLACE TRIGGER trg_auto_tip_comentariu
BEFORE INSERT OR UPDATE ON COMENTARII
                            FOR EACH ROW
BEGIN
    IF :NEW.id_film IS NOT NULL AND :NEW.id_actor IS NULL THEN
        -- Comentariu despre un film
        :NEW.tip := 'FILM';
    ELSIF :NEW.id_actor IS NOT NULL AND :NEW.id_film IS NULL THEN
        -- Comentariu despre un actor
        :NEW.tip := 'ACTOR';
ELSE
        -- Niciun FK sau ambele FK completate = invalid
        RAISE_APPLICATION_ERROR(-20003,
            'Un comentariu trebuie asociat EXCLUSIV unui film SAU unui actor, nu ambelor simultan.');
END IF;
END trg_auto_tip_comentariu;
/

COMMIT;