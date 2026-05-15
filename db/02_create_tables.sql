CREATE TABLE CATEGORII (
                           id_categorie    NUMBER          CONSTRAINT pk_categorii PRIMARY KEY,
                           nume            VARCHAR2(100)   CONSTRAINT nn_cat_nume NOT NULL,
                           descriere       VARCHAR2(500),
                           CONSTRAINT uk_categorie_nume UNIQUE (nume)
);

CREATE TABLE FILME (
                       id_film         NUMBER          CONSTRAINT pk_filme PRIMARY KEY,
                       titlu           VARCHAR2(200)   CONSTRAINT nn_film_titlu NOT NULL,
                       descriere       VARCHAR2(2000),
                       data_lansare    DATE,
                       durata          NUMBER(4)       CONSTRAINT ck_film_durata CHECK (durata > 0),
                       rating          NUMBER(4,2)     DEFAULT 0 CONSTRAINT ck_film_rating CHECK (rating >= 0 AND rating <= 10),
                       id_categorie    NUMBER          CONSTRAINT nn_film_cat NOT NULL,
                       CONSTRAINT fk_film_categorie FOREIGN KEY (id_categorie) REFERENCES CATEGORII(id_categorie)
);

CREATE TABLE VERSIUNI_FILM (
                               id_versiune     NUMBER          CONSTRAINT pk_versiuni PRIMARY KEY,
                               id_film         NUMBER          CONSTRAINT nn_vers_film NOT NULL,
                               format          VARCHAR2(20)    CONSTRAINT nn_vers_format NOT NULL
                                    CONSTRAINT ck_vers_format CHECK (format IN ('SD','HD','FULL_HD','4K','8K')),
                               rezolutie       VARCHAR2(20),
                               limba           VARCHAR2(50)    CONSTRAINT nn_vers_limba NOT NULL,
                               subtitrare      VARCHAR2(50),
                               activ           NUMBER(1)       DEFAULT 1 CONSTRAINT ck_vers_activ CHECK (activ IN (0,1)),
                               CONSTRAINT fk_versiune_film FOREIGN KEY (id_film) REFERENCES FILME(id_film)
);

CREATE TABLE ACTORI (
                        id_actor        NUMBER          CONSTRAINT pk_actori PRIMARY KEY,
                        prenume         VARCHAR2(100)   CONSTRAINT nn_actor_prenume NOT NULL,
                        nume_familie    VARCHAR2(100)   CONSTRAINT nn_actor_nume NOT NULL,
                        nume_scena      VARCHAR2(200),
                        data_nastere    DATE,
                        nationalitate   VARCHAR2(100)
);

CREATE TABLE DISTRIBUTIE (
                             id_distributie  NUMBER          CONSTRAINT pk_distributie PRIMARY KEY,
                             id_film         NUMBER          CONSTRAINT nn_dist_film NOT NULL,
                             id_actor        NUMBER          CONSTRAINT nn_dist_actor NOT NULL,
                             rol             VARCHAR2(200),
                             tip_rol         VARCHAR2(20)    CONSTRAINT ck_dist_tip CHECK (tip_rol IN ('PRINCIPAL','SECUNDAR','FIGURATIE')),
                             comentariu      VARCHAR2(1000),
                             CONSTRAINT fk_dist_film FOREIGN KEY (id_film) REFERENCES FILME(id_film),
                             CONSTRAINT fk_dist_actor FOREIGN KEY (id_actor) REFERENCES ACTORI(id_actor),
                             CONSTRAINT uk_distributie UNIQUE (id_film, id_actor)
);

CREATE TABLE CLIENTI (
                         id_client           NUMBER          CONSTRAINT pk_clienti PRIMARY KEY,
                         prenume             VARCHAR2(100)   CONSTRAINT nn_client_prenume NOT NULL,
                         nume                VARCHAR2(100)   CONSTRAINT nn_client_nume NOT NULL,
                         telefon_acasa       VARCHAR2(20)    CONSTRAINT nn_client_tel NOT NULL,
                         adresa              VARCHAR2(300),
                         oras                VARCHAR2(100),
                         email               VARCHAR2(200),
                         telefon_mobil       VARCHAR2(20),
                         data_inregistrare   DATE            DEFAULT SYSDATE,
                         CONSTRAINT uk_client_email UNIQUE (email),
                         CONSTRAINT ck_client_email CHECK (email IS NULL OR email LIKE '%@%.%')
);

CREATE TABLE VIZUALIZARI (
                             id_vizualizare      NUMBER          CONSTRAINT pk_vizualizari PRIMARY KEY,
                             id_client           NUMBER          CONSTRAINT nn_viz_client NOT NULL,
                             id_versiune         NUMBER          CONSTRAINT nn_viz_versiune NOT NULL,
                             data_vizualizare    DATE            DEFAULT SYSDATE CONSTRAINT nn_viz_data NOT NULL,
                             durata_vizionata    NUMBER(5),
                             stare               VARCHAR2(20)    DEFAULT 'COMPLETA'
                                        CONSTRAINT ck_viz_stare CHECK (stare IN ('COMPLETA','PARTIALA','ABANDONATA')),
                             CONSTRAINT fk_viz_client FOREIGN KEY (id_client) REFERENCES CLIENTI(id_client),
                             CONSTRAINT fk_viz_versiune FOREIGN KEY (id_versiune) REFERENCES VERSIUNI_FILM(id_versiune)
);

CREATE TABLE VOTURI (
                        id_vot      NUMBER          CONSTRAINT pk_voturi PRIMARY KEY,
                        id_client   NUMBER          CONSTRAINT nn_vot_client NOT NULL,
                        id_film     NUMBER          CONSTRAINT nn_vot_film NOT NULL,
                        nota        NUMBER(2)       CONSTRAINT nn_vot_nota NOT NULL
                                CONSTRAINT ck_vot_nota CHECK (nota BETWEEN 1 AND 10),
                        data_vot    DATE            DEFAULT SYSDATE,
                        CONSTRAINT fk_vot_client FOREIGN KEY (id_client) REFERENCES CLIENTI(id_client),
                        CONSTRAINT fk_vot_film FOREIGN KEY (id_film) REFERENCES FILME(id_film),
                        CONSTRAINT uk_vot_unic UNIQUE (id_client, id_film)
);

CREATE TABLE COMENTARII (
                            id_comentariu       NUMBER          CONSTRAINT pk_comentarii PRIMARY KEY,
                            id_client           NUMBER          CONSTRAINT nn_com_client NOT NULL,
                            id_film             NUMBER,
                            id_actor            NUMBER,
                            continut            VARCHAR2(4000)  CONSTRAINT nn_com_continut NOT NULL,
                            data_comentariu     DATE            DEFAULT SYSDATE,
                            tip                 VARCHAR2(10)    CONSTRAINT ck_com_tip CHECK (tip IN ('FILM','ACTOR')),
                            CONSTRAINT fk_com_client FOREIGN KEY (id_client) REFERENCES CLIENTI(id_client),
                            CONSTRAINT fk_com_film FOREIGN KEY (id_film) REFERENCES FILME(id_film),
                            CONSTRAINT fk_com_actor FOREIGN KEY (id_actor) REFERENCES ACTORI(id_actor),
                            CONSTRAINT ck_com_target CHECK (
                                (tip = 'FILM'  AND id_film  IS NOT NULL AND id_actor IS NULL) OR
                                (tip = 'ACTOR' AND id_actor IS NOT NULL AND id_film  IS NULL)
                                )
);

CREATE TABLE CARACTERIZARI_OPTIUNI (
                                       id_optiune      NUMBER          CONSTRAINT pk_optiuni PRIMARY KEY,
                                       denumire        VARCHAR2(100)   CONSTRAINT nn_opt_denumire NOT NULL,
                                       tip_sentiment   VARCHAR2(10)    CONSTRAINT ck_opt_sentiment CHECK (tip_sentiment IN ('POZITIV','NEGATIV','NEUTRU')),
                                       CONSTRAINT uk_optiune_denumire UNIQUE (denumire)
);

CREATE TABLE CARACTERIZARI_CLIENT (
                                      id_caracterizare    NUMBER  CONSTRAINT pk_caracterizari PRIMARY KEY,
                                      id_client           NUMBER  CONSTRAINT nn_caract_client NOT NULL,
                                      id_film             NUMBER  CONSTRAINT nn_caract_film NOT NULL,
                                      id_optiune          NUMBER  CONSTRAINT nn_caract_optiune NOT NULL,
                                      data_caracterizare  DATE    DEFAULT SYSDATE,
                                      CONSTRAINT fk_caract_client  FOREIGN KEY (id_client)  REFERENCES CLIENTI(id_client),
                                      CONSTRAINT fk_caract_film    FOREIGN KEY (id_film)    REFERENCES FILME(id_film),
                                      CONSTRAINT fk_caract_optiune FOREIGN KEY (id_optiune) REFERENCES CARACTERIZARI_OPTIUNI(id_optiune),
                                      CONSTRAINT uk_caracterizare  UNIQUE (id_client, id_film, id_optiune)
);

COMMIT;