-- ============================================================
-- Script: 04_populate.sql
-- Descriere: Populare toate tabelele cu date realiste
-- Minim 15 inregistrari per tabel, compatibil Oracle XE 11g
-- ============================================================

-- -------------------------------------------------------
-- CATEGORII (15 genuri de film)
-- -------------------------------------------------------
INSERT INTO CATEGORII VALUES (seq_categorii.NEXTVAL, 'Actiune',          'Filme cu scene de actiune intensa si adrenalina');
INSERT INTO CATEGORII VALUES (seq_categorii.NEXTVAL, 'Drama',            'Filme cu conflicte emotionale si povesti de viata');
INSERT INTO CATEGORII VALUES (seq_categorii.NEXTVAL, 'Comedie',          'Filme amuzante si distractive pentru toata familia');
INSERT INTO CATEGORII VALUES (seq_categorii.NEXTVAL, 'Thriller',         'Filme tensionate cu suspans si rasturnari de situatie');
INSERT INTO CATEGORII VALUES (seq_categorii.NEXTVAL, 'Stiinta-Fictiune', 'Filme bazate pe concepte stiintifice sau tehnologice viitoare');
INSERT INTO CATEGORII VALUES (seq_categorii.NEXTVAL, 'Horror',           'Filme care provoaca spaima si tensiune extrema');
INSERT INTO CATEGORII VALUES (seq_categorii.NEXTVAL, 'Romantism',        'Filme centrate pe relatii de dragoste si sentimente');
INSERT INTO CATEGORII VALUES (seq_categorii.NEXTVAL, 'Animatie',         'Filme animate pentru copii si adulti');
INSERT INTO CATEGORII VALUES (seq_categorii.NEXTVAL, 'Documentar',       'Filme bazate pe fapte reale si investigatii');
INSERT INTO CATEGORII VALUES (seq_categorii.NEXTVAL, 'Fantastic',        'Filme cu elemente de magie si lumi imaginare');
INSERT INTO CATEGORII VALUES (seq_categorii.NEXTVAL, 'Crima',            'Filme despre lumea interlopa si investigatii criminale');
INSERT INTO CATEGORII VALUES (seq_categorii.NEXTVAL, 'Biografie',        'Filme bazate pe viata unor personalitati reale');
INSERT INTO CATEGORII VALUES (seq_categorii.NEXTVAL, 'Aventura',         'Filme cu calatorii si descoperiri spectaculoase');
INSERT INTO CATEGORII VALUES (seq_categorii.NEXTVAL, 'Mister',           'Filme cu enigme si investigatii complexe');
INSERT INTO CATEGORII VALUES (seq_categorii.NEXTVAL, 'Western',          'Filme plasate in vestul salbatic american');

-- -------------------------------------------------------
-- FILME (17 filme cu rating initial 0, actualizat de trigger)
-- id_categorie: 1=Actiune,2=Drama,4=Thriller,5=Sci-Fi,7=Romantism,10=Fantastic,11=Crima
-- -------------------------------------------------------
INSERT INTO FILME VALUES (seq_filme.NEXTVAL, 'Inception',
                          'Un hot de vise intra in mintile oamenilor pentru a le fura secretele',
                          TO_DATE('2010-07-16','YYYY-MM-DD'), 148, 0, 5);

INSERT INTO FILME VALUES (seq_filme.NEXTVAL, 'The Dark Knight',
                          'Batman se confrunta cu Joker, un criminal haotic si imprevizibil',
                          TO_DATE('2008-07-18','YYYY-MM-DD'), 152, 0, 1);

INSERT INTO FILME VALUES (seq_filme.NEXTVAL, 'Interstellar',
                          'Un grup de astronauti calatoreste prin univers in cautarea unui nou camin',
                          TO_DATE('2014-11-07','YYYY-MM-DD'), 169, 0, 5);

INSERT INTO FILME VALUES (seq_filme.NEXTVAL, 'The Shawshank Redemption',
                          'Un bancher nevinovat supravietuieste sistemului penitenciar american',
                          TO_DATE('1994-09-23','YYYY-MM-DD'), 142, 0, 2);

INSERT INTO FILME VALUES (seq_filme.NEXTVAL, 'Forrest Gump',
                          'Viata extraordinara a unui om simplu care asista la momente istorice',
                          TO_DATE('1994-07-06','YYYY-MM-DD'), 142, 0, 2);

INSERT INTO FILME VALUES (seq_filme.NEXTVAL, 'The Matrix',
                          'Un programator descopera ca lumea este o simulare controlata de masini',
                          TO_DATE('1999-03-31','YYYY-MM-DD'), 136, 0, 5);

INSERT INTO FILME VALUES (seq_filme.NEXTVAL, 'Pulp Fiction',
                          'Povesti interconectate din lumea criminala a Los Angelesului',
                          TO_DATE('1994-10-14','YYYY-MM-DD'), 154, 0, 11);

INSERT INTO FILME VALUES (seq_filme.NEXTVAL, 'The Godfather',
                          'Saga familiei mafiote Corleone si lupta pentru putere',
                          TO_DATE('1972-03-24','YYYY-MM-DD'), 175, 0, 11);

INSERT INTO FILME VALUES (seq_filme.NEXTVAL, 'Fight Club',
                          'Un angajat nemultumit infiinteaza un club secret de lupte',
                          TO_DATE('1999-10-15','YYYY-MM-DD'), 139, 0, 4);

INSERT INTO FILME VALUES (seq_filme.NEXTVAL, 'Goodfellas',
                          'Ascensiunea si caderea unui mafiot in New York',
                          TO_DATE('1990-09-19','YYYY-MM-DD'), 146, 0, 11);

INSERT INTO FILME VALUES (seq_filme.NEXTVAL, 'Schindler''s List',
                          'Un om de afaceri german salveaza evrei din Holocaust',
                          TO_DATE('1993-12-15','YYYY-MM-DD'), 195, 0, 2);

INSERT INTO FILME VALUES (seq_filme.NEXTVAL, 'The Silence of the Lambs',
                          'Un agent FBI colaboreaza cu un cannibal pentru a prinde un criminal',
                          TO_DATE('1991-02-14','YYYY-MM-DD'), 118, 0, 4);

INSERT INTO FILME VALUES (seq_filme.NEXTVAL, 'Titanic',
                          'O poveste de dragoste pe fundalul tragediei vasului Titanic',
                          TO_DATE('1997-12-19','YYYY-MM-DD'), 195, 0, 7);

INSERT INTO FILME VALUES (seq_filme.NEXTVAL, 'Avatar',
                          'Un soldat paralizat exploreaza o planeta aliena cu un corp avatar',
                          TO_DATE('2009-12-18','YYYY-MM-DD'), 162, 0, 5);

INSERT INTO FILME VALUES (seq_filme.NEXTVAL, 'Gladiator',
                          'Un general roman se razbuna dupa ce familia i-a fost ucisa',
                          TO_DATE('2000-05-05','YYYY-MM-DD'), 155, 0, 1);

INSERT INTO FILME VALUES (seq_filme.NEXTVAL, 'The Lord of the Rings: The Fellowship',
                          'Un hobbit porneste intr-o aventura pentru a distruge Inelul Puterii',
                          TO_DATE('2001-12-19','YYYY-MM-DD'), 178, 0, 10);

INSERT INTO FILME VALUES (seq_filme.NEXTVAL, 'The Departed',
                          'Un politist si un informator actioneaza in tabere opuse',
                          TO_DATE('2006-10-06','YYYY-MM-DD'), 151, 0, 11);

-- -------------------------------------------------------
-- VERSIUNI_FILM (26 versiuni pentru filmele de mai sus)
-- -------------------------------------------------------
-- Film 1 - Inception
INSERT INTO VERSIUNI_FILM VALUES (seq_versiuni.NEXTVAL, 1, 'HD',      '1920x1080', 'Engleza',  NULL,    1);
INSERT INTO VERSIUNI_FILM VALUES (seq_versiuni.NEXTVAL, 1, '4K',      '3840x2160', 'Engleza',  NULL,    1);
INSERT INTO VERSIUNI_FILM VALUES (seq_versiuni.NEXTVAL, 1, 'HD',      '1920x1080', 'Romana',   'Romana',1);
-- Film 2 - The Dark Knight
INSERT INTO VERSIUNI_FILM VALUES (seq_versiuni.NEXTVAL, 2, 'HD',      '1920x1080', 'Engleza',  NULL,    1);
INSERT INTO VERSIUNI_FILM VALUES (seq_versiuni.NEXTVAL, 2, 'FULL_HD', '1920x1080', 'Engleza',  'Romana',1);
-- Film 3 - Interstellar
INSERT INTO VERSIUNI_FILM VALUES (seq_versiuni.NEXTVAL, 3, '4K',      '3840x2160', 'Engleza',  NULL,    1);
INSERT INTO VERSIUNI_FILM VALUES (seq_versiuni.NEXTVAL, 3, 'HD',      '1920x1080', 'Romana',   'Romana',1);
-- Film 4 - Shawshank
INSERT INTO VERSIUNI_FILM VALUES (seq_versiuni.NEXTVAL, 4, 'HD',      '1920x1080', 'Engleza',  NULL,    1);
-- Film 5 - Forrest Gump
INSERT INTO VERSIUNI_FILM VALUES (seq_versiuni.NEXTVAL, 5, 'HD',      '1920x1080', 'Engleza',  NULL,    1);
INSERT INTO VERSIUNI_FILM VALUES (seq_versiuni.NEXTVAL, 5, 'HD',      '1920x1080', 'Romana',   'Romana',1);
-- Film 6 - Matrix
INSERT INTO VERSIUNI_FILM VALUES (seq_versiuni.NEXTVAL, 6, 'HD',      '1920x1080', 'Engleza',  NULL,    1);
INSERT INTO VERSIUNI_FILM VALUES (seq_versiuni.NEXTVAL, 6, '4K',      '3840x2160', 'Engleza',  NULL,    1);
-- Film 7 - Pulp Fiction
INSERT INTO VERSIUNI_FILM VALUES (seq_versiuni.NEXTVAL, 7, 'HD',      '1920x1080', 'Engleza',  NULL,    1);
-- Film 8 - Godfather
INSERT INTO VERSIUNI_FILM VALUES (seq_versiuni.NEXTVAL, 8, 'HD',      '1920x1080', 'Engleza',  NULL,    1);
-- Film 9 - Fight Club
INSERT INTO VERSIUNI_FILM VALUES (seq_versiuni.NEXTVAL, 9, 'HD',      '1920x1080', 'Engleza',  NULL,    1);
INSERT INTO VERSIUNI_FILM VALUES (seq_versiuni.NEXTVAL, 9, 'HD',      '1920x1080', 'Romana',   'Romana',1);
-- Film 10 - Goodfellas
INSERT INTO VERSIUNI_FILM VALUES (seq_versiuni.NEXTVAL, 10,'HD',      '1920x1080', 'Engleza',  NULL,    1);
-- Film 11 - Schindler's List (versiune inactiva pt test trigger)
INSERT INTO VERSIUNI_FILM VALUES (seq_versiuni.NEXTVAL, 11,'HD',      '1920x1080', 'Engleza',  NULL,    1);
INSERT INTO VERSIUNI_FILM VALUES (seq_versiuni.NEXTVAL, 11,'SD',      '720x480',   'Engleza',  NULL,    0);
-- Film 12 - Silence of the Lambs
INSERT INTO VERSIUNI_FILM VALUES (seq_versiuni.NEXTVAL, 12,'HD',      '1920x1080', 'Engleza',  NULL,    1);
-- Film 13 - Titanic
INSERT INTO VERSIUNI_FILM VALUES (seq_versiuni.NEXTVAL, 13,'4K',      '3840x2160', 'Engleza',  NULL,    1);
INSERT INTO VERSIUNI_FILM VALUES (seq_versiuni.NEXTVAL, 13,'FULL_HD', '1920x1080', 'Romana',   'Romana',1);
-- Film 14 - Avatar
INSERT INTO VERSIUNI_FILM VALUES (seq_versiuni.NEXTVAL, 14,'4K',      '3840x2160', 'Engleza',  NULL,    1);
INSERT INTO VERSIUNI_FILM VALUES (seq_versiuni.NEXTVAL, 14,'FULL_HD', '1920x1080', 'Romana',   'Romana',1);
-- Film 15 - Gladiator
INSERT INTO VERSIUNI_FILM VALUES (seq_versiuni.NEXTVAL, 15,'HD',      '1920x1080', 'Engleza',  NULL,    1);
-- Film 16 - LOTR
INSERT INTO VERSIUNI_FILM VALUES (seq_versiuni.NEXTVAL, 16,'HD',      '1920x1080', 'Engleza',  NULL,    1);
-- Film 17 - Departed
INSERT INTO VERSIUNI_FILM VALUES (seq_versiuni.NEXTVAL, 17,'HD',      '1920x1080', 'Engleza',  NULL,    1);

-- -------------------------------------------------------
-- ACTORI (17 actori)
-- -------------------------------------------------------
INSERT INTO ACTORI VALUES (seq_actori.NEXTVAL, 'Leonardo',  'DiCaprio',   'Leonardo DiCaprio', TO_DATE('1974-11-11','YYYY-MM-DD'), 'American');
INSERT INTO ACTORI VALUES (seq_actori.NEXTVAL, 'Christian', 'Bale',       'Christian Bale',    TO_DATE('1974-01-30','YYYY-MM-DD'), 'Britanic');
INSERT INTO ACTORI VALUES (seq_actori.NEXTVAL, 'Matthew',   'McConaughey','Matthew McConaughey',TO_DATE('1969-11-04','YYYY-MM-DD'), 'American');
INSERT INTO ACTORI VALUES (seq_actori.NEXTVAL, 'Morgan',    'Freeman',    'Morgan Freeman',    TO_DATE('1937-06-01','YYYY-MM-DD'), 'American');
INSERT INTO ACTORI VALUES (seq_actori.NEXTVAL, 'Tom',       'Hanks',      'Tom Hanks',         TO_DATE('1956-07-09','YYYY-MM-DD'), 'American');
INSERT INTO ACTORI VALUES (seq_actori.NEXTVAL, 'Keanu',     'Reeves',     'Keanu Reeves',      TO_DATE('1964-09-02','YYYY-MM-DD'), 'Canadian');
INSERT INTO ACTORI VALUES (seq_actori.NEXTVAL, 'John',      'Travolta',   'John Travolta',     TO_DATE('1954-02-18','YYYY-MM-DD'), 'American');
INSERT INTO ACTORI VALUES (seq_actori.NEXTVAL, 'Marlon',    'Brando',     'Marlon Brando',     TO_DATE('1924-04-03','YYYY-MM-DD'), 'American');
INSERT INTO ACTORI VALUES (seq_actori.NEXTVAL, 'Brad',      'Pitt',       'Brad Pitt',         TO_DATE('1963-12-18','YYYY-MM-DD'), 'American');
INSERT INTO ACTORI VALUES (seq_actori.NEXTVAL, 'Ray',       'Liotta',     'Ray Liotta',        TO_DATE('1954-12-18','YYYY-MM-DD'), 'American');
INSERT INTO ACTORI VALUES (seq_actori.NEXTVAL, 'Liam',      'Neeson',     'Liam Neeson',       TO_DATE('1952-06-07','YYYY-MM-DD'), 'Irlandez');
INSERT INTO ACTORI VALUES (seq_actori.NEXTVAL, 'Jodie',     'Foster',     'Jodie Foster',      TO_DATE('1962-11-19','YYYY-MM-DD'), 'American');
INSERT INTO ACTORI VALUES (seq_actori.NEXTVAL, 'Kate',      'Winslet',    'Kate Winslet',      TO_DATE('1975-10-05','YYYY-MM-DD'), 'Britanica');
INSERT INTO ACTORI VALUES (seq_actori.NEXTVAL, 'Sam',       'Worthington','Sam Worthington',   TO_DATE('1976-08-02','YYYY-MM-DD'), 'Australian');
INSERT INTO ACTORI VALUES (seq_actori.NEXTVAL, 'Russell',   'Crowe',      'Russell Crowe',     TO_DATE('1964-04-07','YYYY-MM-DD'), 'Neozeelandez');
INSERT INTO ACTORI VALUES (seq_actori.NEXTVAL, 'Viggo',     'Mortensen',  'Viggo Mortensen',   TO_DATE('1958-10-20','YYYY-MM-DD'), 'American');
INSERT INTO ACTORI VALUES (seq_actori.NEXTVAL, 'Jack',      'Nicholson',  'Jack Nicholson',    TO_DATE('1937-04-22','YYYY-MM-DD'), 'American');

-- -------------------------------------------------------
-- DISTRIBUTIE (20 intrari film-actor cu rol)
-- -------------------------------------------------------
INSERT INTO DISTRIBUTIE VALUES (seq_distributie.NEXTVAL, 1,  1,  'Dom Cobb',                   'PRINCIPAL', 'Performanta complexa intr-un rol multidimensional');
INSERT INTO DISTRIBUTIE VALUES (seq_distributie.NEXTVAL, 2,  2,  'Bruce Wayne / Batman',       'PRINCIPAL', 'Cel mai bun Batman din cinematografie');
INSERT INTO DISTRIBUTIE VALUES (seq_distributie.NEXTVAL, 2,  4,  'Lucius Fox',                 'SECUNDAR',  'Rol suport esential pentru poveste');
INSERT INTO DISTRIBUTIE VALUES (seq_distributie.NEXTVAL, 3,  3,  'Cooper',                     'PRINCIPAL', 'Rol emotionant, unul dintre cele mai bune ale sale');
INSERT INTO DISTRIBUTIE VALUES (seq_distributie.NEXTVAL, 4,  4,  'Ellis Red Redding',          'PRINCIPAL', 'Morgan Freeman in rolul vietii');
INSERT INTO DISTRIBUTIE VALUES (seq_distributie.NEXTVAL, 5,  5,  'Forrest Gump',               'PRINCIPAL', 'Rol iconic, Tom Hanks la apogeul carierei');
INSERT INTO DISTRIBUTIE VALUES (seq_distributie.NEXTVAL, 6,  6,  'Neo / Thomas Anderson',      'PRINCIPAL', 'Keanu Reeves transformat intr-o icoana pop');
INSERT INTO DISTRIBUTIE VALUES (seq_distributie.NEXTVAL, 7,  7,  'Vincent Vega',               'PRINCIPAL', 'Revenire spectaculoasa a lui Travolta');
INSERT INTO DISTRIBUTIE VALUES (seq_distributie.NEXTVAL, 8,  8,  'Don Vito Corleone',          'PRINCIPAL', 'Performanta legendara, definitorie pentru cariera');
INSERT INTO DISTRIBUTIE VALUES (seq_distributie.NEXTVAL, 9,  9,  'Tyler Durden',               'PRINCIPAL', 'Brad Pitt la cel mai cool al sau');
INSERT INTO DISTRIBUTIE VALUES (seq_distributie.NEXTVAL, 10, 10, 'Henry Hill',                 'PRINCIPAL', 'Ray Liotta in rolul sau de referinta');
INSERT INTO DISTRIBUTIE VALUES (seq_distributie.NEXTVAL, 11, 11, 'Oskar Schindler',            'PRINCIPAL', 'Liam Neeson in rolul cel mai important al carierei');
INSERT INTO DISTRIBUTIE VALUES (seq_distributie.NEXTVAL, 12, 12, 'Clarice Starling',           'PRINCIPAL', 'Jodie Foster castigatoare de Oscar pentru acest rol');
INSERT INTO DISTRIBUTIE VALUES (seq_distributie.NEXTVAL, 13, 1,  'Jack Dawson',                'PRINCIPAL', 'DiCaprio la debut international major');
INSERT INTO DISTRIBUTIE VALUES (seq_distributie.NEXTVAL, 13, 13, 'Rose DeWitt Bukater',        'SECUNDAR',  'Kate Winslet intr-un rol definitiv romantism');
INSERT INTO DISTRIBUTIE VALUES (seq_distributie.NEXTVAL, 14, 14, 'Jake Sully',                 'PRINCIPAL', 'Sam Worthington in primul sau mare rol');
INSERT INTO DISTRIBUTIE VALUES (seq_distributie.NEXTVAL, 15, 15, 'Maximus Decimus Meridius',   'PRINCIPAL', 'Russell Crowe castigator de Oscar');
INSERT INTO DISTRIBUTIE VALUES (seq_distributie.NEXTVAL, 16, 16, 'Aragorn',                    'PRINCIPAL', 'Viggo Mortensen intr-un rol de o viata');
INSERT INTO DISTRIBUTIE VALUES (seq_distributie.NEXTVAL, 17, 17, 'Frank Costello',             'PRINCIPAL', 'Jack Nicholson terific ca antagonist');
INSERT INTO DISTRIBUTIE VALUES (seq_distributie.NEXTVAL, 17, 1,  'Billy Costigan',             'PRINCIPAL', 'DiCaprio excelent in acest thriller');

-- -------------------------------------------------------
-- CLIENTI (16 clienti romani)
-- -------------------------------------------------------
INSERT INTO CLIENTI (id_client,prenume,nume,telefon_acasa,adresa,oras,email,telefon_mobil,data_inregistrare)
VALUES (seq_clienti.NEXTVAL,'Ion','Popescu','0232100001','Strada Unirii 1','Iasi','ion.popescu@gmail.com','0721000001',TO_DATE('2024-01-10','YYYY-MM-DD'));

INSERT INTO CLIENTI (id_client,prenume,nume,telefon_acasa,adresa,oras,email,telefon_mobil,data_inregistrare)
VALUES (seq_clienti.NEXTVAL,'Maria','Ionescu','0232100002','Strada Palat 2','Bucuresti','maria.ionescu@yahoo.com','0722000002',TO_DATE('2024-01-15','YYYY-MM-DD'));

INSERT INTO CLIENTI (id_client,prenume,nume,telefon_acasa,adresa,oras,email,telefon_mobil,data_inregistrare)
VALUES (seq_clienti.NEXTVAL,'Alexandru','Popa','0264100003','Calea Victoriei 3','Cluj-Napoca','alex.popa@gmail.com','0723000003',TO_DATE('2024-02-01','YYYY-MM-DD'));

INSERT INTO CLIENTI (id_client,prenume,nume,telefon_acasa,adresa,oras,email,telefon_mobil,data_inregistrare)
VALUES (seq_clienti.NEXTVAL,'Elena','Constantin','0256100004','Strada Libertatii 4','Timisoara','elena.constantin@gmail.com','0724000004',TO_DATE('2024-02-10','YYYY-MM-DD'));

INSERT INTO CLIENTI (id_client,prenume,nume,telefon_acasa,adresa,oras,email,telefon_mobil,data_inregistrare)
VALUES (seq_clienti.NEXTVAL,'Andrei','Dumitrescu','0232100005','Bulevardul Independentei 5','Iasi',NULL,'0725000005',TO_DATE('2024-02-20','YYYY-MM-DD'));

INSERT INTO CLIENTI (id_client,prenume,nume,telefon_acasa,adresa,oras,email,telefon_mobil,data_inregistrare)
VALUES (seq_clienti.NEXTVAL,'Ana','Georgescu','0268100006','Piata Unirii 6','Brasov','ana.georgescu@yahoo.com','0726000006',TO_DATE('2024-03-01','YYYY-MM-DD'));

INSERT INTO CLIENTI (id_client,prenume,nume,telefon_acasa,adresa,oras,email,telefon_mobil,data_inregistrare)
VALUES (seq_clienti.NEXTVAL,'Mihai','Moldovan','0264100007','Strada Florilor 7','Cluj-Napoca',NULL,'0727000007',TO_DATE('2024-03-10','YYYY-MM-DD'));

INSERT INTO CLIENTI (id_client,prenume,nume,telefon_acasa,adresa,oras,email,telefon_mobil,data_inregistrare)
VALUES (seq_clienti.NEXTVAL,'Cristina','Stancu','0213100008','Calea Dorobantilor 8','Bucuresti','cristina.stancu@gmail.com','0728000008',TO_DATE('2024-03-15','YYYY-MM-DD'));

INSERT INTO CLIENTI (id_client,prenume,nume,telefon_acasa,adresa,oras,email,telefon_mobil,data_inregistrare)
VALUES (seq_clienti.NEXTVAL,'Bogdan','Rusu','0232100009','Strada Eminescu 9','Iasi',NULL,'0729000009',TO_DATE('2024-04-01','YYYY-MM-DD'));

INSERT INTO CLIENTI (id_client,prenume,nume,telefon_acasa,adresa,oras,email,telefon_mobil,data_inregistrare)
VALUES (seq_clienti.NEXTVAL,'Laura','Marin','0256100010','Bulevardul Unirii 10','Timisoara','laura.marin@yahoo.com','0730000010',TO_DATE('2024-04-10','YYYY-MM-DD'));

INSERT INTO CLIENTI (id_client,prenume,nume,telefon_acasa,adresa,oras,email,telefon_mobil,data_inregistrare)
VALUES (seq_clienti.NEXTVAL,'Radu','Apostol','0241100011','Strada Pacii 11','Constanta',NULL,'0731000011',TO_DATE('2024-04-20','YYYY-MM-DD'));

INSERT INTO CLIENTI (id_client,prenume,nume,telefon_acasa,adresa,oras,email,telefon_mobil,data_inregistrare)
VALUES (seq_clienti.NEXTVAL,'Daniela','Chirila','0232100012','Aleea Stadionului 12','Iasi','daniela.chirila@gmail.com','0732000012',TO_DATE('2024-05-01','YYYY-MM-DD'));

INSERT INTO CLIENTI (id_client,prenume,nume,telefon_acasa,adresa,oras,email,telefon_mobil,data_inregistrare)
VALUES (seq_clienti.NEXTVAL,'Stefan','Vasile','0213100013','Calea Mosilor 13','Bucuresti',NULL,'0733000013',TO_DATE('2024-05-10','YYYY-MM-DD'));

INSERT INTO CLIENTI (id_client,prenume,nume,telefon_acasa,adresa,oras,email,telefon_mobil,data_inregistrare)
VALUES (seq_clienti.NEXTVAL,'Alina','Dinu','0264100014','Strada Muzicii 14','Cluj-Napoca','alina.dinu@yahoo.com','0734000014',TO_DATE('2024-05-20','YYYY-MM-DD'));

INSERT INTO CLIENTI (id_client,prenume,nume,telefon_acasa,adresa,oras,email,telefon_mobil,data_inregistrare)
VALUES (seq_clienti.NEXTVAL,'Cosmin','Florescu','0256100015','Piata Revolutiei 15','Timisoara',NULL,'0735000015',TO_DATE('2024-06-01','YYYY-MM-DD'));

INSERT INTO CLIENTI (id_client,prenume,nume,telefon_acasa,adresa,oras,email,telefon_mobil,data_inregistrare)
VALUES (seq_clienti.NEXTVAL,'Ioana','Niculescu','0268100016','Strada Independentei 16','Brasov','ioana.niculescu@gmail.com','0736000016',TO_DATE('2024-06-10','YYYY-MM-DD'));

-- -------------------------------------------------------
-- VIZUALIZARI (20 vizualizari, versiuni 1-17 sunt active)
-- id_versiune 19 (SD Schindler) este INACTIV - pentru testul triggerului
-- -------------------------------------------------------
INSERT INTO VIZUALIZARI (id_vizualizare,id_client,id_versiune,data_vizualizare,durata_vizionata,stare)
VALUES (seq_vizualizari.NEXTVAL, 1, 1,  TO_DATE('2025-01-15','YYYY-MM-DD'), 148, 'COMPLETA');
INSERT INTO VIZUALIZARI (id_vizualizare,id_client,id_versiune,data_vizualizare,durata_vizionata,stare)
VALUES (seq_vizualizari.NEXTVAL, 1, 4,  TO_DATE('2025-01-20','YYYY-MM-DD'), 152, 'COMPLETA');
INSERT INTO VIZUALIZARI (id_vizualizare,id_client,id_versiune,data_vizualizare,durata_vizionata,stare)
VALUES (seq_vizualizari.NEXTVAL, 2, 1,  TO_DATE('2025-02-10','YYYY-MM-DD'), 148, 'COMPLETA');
INSERT INTO VIZUALIZARI (id_vizualizare,id_client,id_versiune,data_vizualizare,durata_vizionata,stare)
VALUES (seq_vizualizari.NEXTVAL, 2, 6,  TO_DATE('2025-02-15','YYYY-MM-DD'),  60, 'PARTIALA');
INSERT INTO VIZUALIZARI (id_vizualizare,id_client,id_versiune,data_vizualizare,durata_vizionata,stare)
VALUES (seq_vizualizari.NEXTVAL, 3, 11, TO_DATE('2025-01-05','YYYY-MM-DD'), 136, 'COMPLETA');
INSERT INTO VIZUALIZARI (id_vizualizare,id_client,id_versiune,data_vizualizare,durata_vizionata,stare)
VALUES (seq_vizualizari.NEXTVAL, 3, 21, TO_DATE('2025-02-14','YYYY-MM-DD'), 195, 'COMPLETA');
INSERT INTO VIZUALIZARI (id_vizualizare,id_client,id_versiune,data_vizualizare,durata_vizionata,stare)
VALUES (seq_vizualizari.NEXTVAL, 4, 9,  TO_DATE('2025-03-01','YYYY-MM-DD'), 142, 'COMPLETA');
INSERT INTO VIZUALIZARI (id_vizualizare,id_client,id_versiune,data_vizualizare,durata_vizionata,stare)
VALUES (seq_vizualizari.NEXTVAL, 4, 11, TO_DATE('2025-03-15','YYYY-MM-DD'),  45, 'PARTIALA');
INSERT INTO VIZUALIZARI (id_vizualizare,id_client,id_versiune,data_vizualizare,durata_vizionata,stare)
VALUES (seq_vizualizari.NEXTVAL, 5, 15, TO_DATE('2025-01-20','YYYY-MM-DD'), 139, 'COMPLETA');
INSERT INTO VIZUALIZARI (id_vizualizare,id_client,id_versiune,data_vizualizare,durata_vizionata,stare)
VALUES (seq_vizualizari.NEXTVAL, 5, 23, TO_DATE('2025-01-25','YYYY-MM-DD'), 162, 'COMPLETA');
INSERT INTO VIZUALIZARI (id_vizualizare,id_client,id_versiune,data_vizualizare,durata_vizionata,stare)
VALUES (seq_vizualizari.NEXTVAL, 6, 1,  TO_DATE('2025-03-10','YYYY-MM-DD'),  80, 'PARTIALA');
INSERT INTO VIZUALIZARI (id_vizualizare,id_client,id_versiune,data_vizualizare,durata_vizionata,stare)
VALUES (seq_vizualizari.NEXTVAL, 6, 13, TO_DATE('2025-03-20','YYYY-MM-DD'), 154, 'COMPLETA');
INSERT INTO VIZUALIZARI (id_vizualizare,id_client,id_versiune,data_vizualizare,durata_vizionata,stare)
VALUES (seq_vizualizari.NEXTVAL, 7, 14, TO_DATE('2025-04-12','YYYY-MM-DD'), 175, 'COMPLETA');
INSERT INTO VIZUALIZARI (id_vizualizare,id_client,id_versiune,data_vizualizare,durata_vizionata,stare)
VALUES (seq_vizualizari.NEXTVAL, 7, 25, TO_DATE('2025-04-20','YYYY-MM-DD'),  20, 'ABANDONATA');
INSERT INTO VIZUALIZARI (id_vizualizare,id_client,id_versiune,data_vizualizare,durata_vizionata,stare)
VALUES (seq_vizualizari.NEXTVAL, 8, 17, TO_DATE('2025-05-05','YYYY-MM-DD'), 146, 'COMPLETA');
INSERT INTO VIZUALIZARI (id_vizualizare,id_client,id_versiune,data_vizualizare,durata_vizionata,stare)
VALUES (seq_vizualizari.NEXTVAL, 8, 18, TO_DATE('2025-05-10','YYYY-MM-DD'), 195, 'COMPLETA');
INSERT INTO VIZUALIZARI (id_vizualizare,id_client,id_versiune,data_vizualizare,durata_vizionata,stare)
VALUES (seq_vizualizari.NEXTVAL, 9, 11, TO_DATE('2025-06-01','YYYY-MM-DD'), 136, 'COMPLETA');
INSERT INTO VIZUALIZARI (id_vizualizare,id_client,id_versiune,data_vizualizare,durata_vizionata,stare)
VALUES (seq_vizualizari.NEXTVAL,10, 21, TO_DATE('2025-02-14','YYYY-MM-DD'), 195, 'COMPLETA');
INSERT INTO VIZUALIZARI (id_vizualizare,id_client,id_versiune,data_vizualizare,durata_vizionata,stare)
VALUES (seq_vizualizari.NEXTVAL,11,  6, TO_DATE('2025-06-20','YYYY-MM-DD'), 169, 'COMPLETA');
INSERT INTO VIZUALIZARI (id_vizualizare,id_client,id_versiune,data_vizualizare,durata_vizionata,stare)
VALUES (seq_vizualizari.NEXTVAL,12, 23, TO_DATE('2025-06-25','YYYY-MM-DD'),  90, 'PARTIALA');

-- -------------------------------------------------------
-- VOTURI (17 voturi - va declansa triggerul de rating)
-- -------------------------------------------------------
INSERT INTO VOTURI VALUES (seq_voturi.NEXTVAL,  1,  1,  9, TO_DATE('2025-01-16','YYYY-MM-DD'));
INSERT INTO VOTURI VALUES (seq_voturi.NEXTVAL,  1,  2,  8, TO_DATE('2025-01-21','YYYY-MM-DD'));
INSERT INTO VOTURI VALUES (seq_voturi.NEXTVAL,  2,  1, 10, TO_DATE('2025-02-11','YYYY-MM-DD'));
INSERT INTO VOTURI VALUES (seq_voturi.NEXTVAL,  2,  3,  8, TO_DATE('2025-02-16','YYYY-MM-DD'));
INSERT INTO VOTURI VALUES (seq_voturi.NEXTVAL,  3,  6,  9, TO_DATE('2025-01-06','YYYY-MM-DD'));
INSERT INTO VOTURI VALUES (seq_voturi.NEXTVAL,  3, 13, 10, TO_DATE('2025-02-15','YYYY-MM-DD'));
INSERT INTO VOTURI VALUES (seq_voturi.NEXTVAL,  4,  5,  7, TO_DATE('2025-03-02','YYYY-MM-DD'));
INSERT INTO VOTURI VALUES (seq_voturi.NEXTVAL,  4,  6,  8, TO_DATE('2025-03-16','YYYY-MM-DD'));
INSERT INTO VOTURI VALUES (seq_voturi.NEXTVAL,  5,  9,  9, TO_DATE('2025-01-21','YYYY-MM-DD'));
INSERT INTO VOTURI VALUES (seq_voturi.NEXTVAL,  5, 14,  8, TO_DATE('2025-01-26','YYYY-MM-DD'));
INSERT INTO VOTURI VALUES (seq_voturi.NEXTVAL,  6,  1,  7, TO_DATE('2025-03-11','YYYY-MM-DD'));
INSERT INTO VOTURI VALUES (seq_voturi.NEXTVAL,  6,  7,  9, TO_DATE('2025-03-21','YYYY-MM-DD'));
INSERT INTO VOTURI VALUES (seq_voturi.NEXTVAL,  7,  8, 10, TO_DATE('2025-04-13','YYYY-MM-DD'));
INSERT INTO VOTURI VALUES (seq_voturi.NEXTVAL,  7, 15,  6, TO_DATE('2025-04-21','YYYY-MM-DD'));
INSERT INTO VOTURI VALUES (seq_voturi.NEXTVAL,  8, 10,  8, TO_DATE('2025-05-06','YYYY-MM-DD'));
INSERT INTO VOTURI VALUES (seq_voturi.NEXTVAL,  8, 11, 10, TO_DATE('2025-05-11','YYYY-MM-DD'));
INSERT INTO VOTURI VALUES (seq_voturi.NEXTVAL,  9,  6,  9, TO_DATE('2025-06-02','YYYY-MM-DD'));

-- -------------------------------------------------------
-- COMENTARII (18 comentarii - triggerul seteaza automat tip)
-- Specificam doar id_film SAU id_actor, nu ambele
-- -------------------------------------------------------
INSERT INTO COMENTARII (id_comentariu,id_client,id_film,id_actor,continut,data_comentariu)
VALUES (seq_comentarii.NEXTVAL, 1, 1, NULL, 'Inception este un film exceptional cu o structura narativa de o complexitate rara', TO_DATE('2025-01-17','YYYY-MM-DD'));

INSERT INTO COMENTARII (id_comentariu,id_client,id_film,id_actor,continut,data_comentariu)
VALUES (seq_comentarii.NEXTVAL, 1, 2, NULL, 'The Dark Knight ramane cel mai bun film cu super-eroi realizat vreodata', TO_DATE('2025-01-22','YYYY-MM-DD'));

INSERT INTO COMENTARII (id_comentariu,id_client,id_film,id_actor,continut,data_comentariu)
VALUES (seq_comentarii.NEXTVAL, 2, 1, NULL, 'Efectele vizuale si scenariul sunt absolut fascinante. Nolan la cel mai bun al sau', TO_DATE('2025-02-12','YYYY-MM-DD'));

INSERT INTO COMENTARII (id_comentariu,id_client,id_film,id_actor,continut,data_comentariu)
VALUES (seq_comentarii.NEXTVAL, 2, NULL, 1, 'Leonardo DiCaprio demonstreaza o versatilitate actorala remarcabila in fiecare rol', TO_DATE('2025-02-17','YYYY-MM-DD'));

INSERT INTO COMENTARII (id_comentariu,id_client,id_film,id_actor,continut,data_comentariu)
VALUES (seq_comentarii.NEXTVAL, 3, 6, NULL, 'Matrix a revolutionat genul sci-fi, un film de referinta absoluta', TO_DATE('2025-01-07','YYYY-MM-DD'));

INSERT INTO COMENTARII (id_comentariu,id_client,id_film,id_actor,continut,data_comentariu)
VALUES (seq_comentarii.NEXTVAL, 3, 13, NULL, 'Titanic ramane un film emotionant si spectaculos, vizibil si astazi', TO_DATE('2025-02-16','YYYY-MM-DD'));

INSERT INTO COMENTARII (id_comentariu,id_client,id_film,id_actor,continut,data_comentariu)
VALUES (seq_comentarii.NEXTVAL, 4, 5, NULL, 'Forrest Gump este o capodopera cinematografica americana de neuitat', TO_DATE('2025-03-03','YYYY-MM-DD'));

INSERT INTO COMENTARII (id_comentariu,id_client,id_film,id_actor,continut,data_comentariu)
VALUES (seq_comentarii.NEXTVAL, 4, NULL, 5, 'Tom Hanks este unul dintre cei mai buni actori ai generatiei sale, complet convingator', TO_DATE('2025-03-04','YYYY-MM-DD'));

INSERT INTO COMENTARII (id_comentariu,id_client,id_film,id_actor,continut,data_comentariu)
VALUES (seq_comentarii.NEXTVAL, 5, 9, NULL, 'Fight Club este un film provocator si inteligent cu un final neasteptat', TO_DATE('2025-01-22','YYYY-MM-DD'));

INSERT INTO COMENTARII (id_comentariu,id_client,id_film,id_actor,continut,data_comentariu)
VALUES (seq_comentarii.NEXTVAL, 5, 14, NULL, 'Avatar revolutioneaza experienta vizuala cinematografica, spectacular', TO_DATE('2025-01-27','YYYY-MM-DD'));

INSERT INTO COMENTARII (id_comentariu,id_client,id_film,id_actor,continut,data_comentariu)
VALUES (seq_comentarii.NEXTVAL, 6, 1, NULL, 'Un film care te face sa gandesti profund, recomandat cu caldura tuturor', TO_DATE('2025-03-12','YYYY-MM-DD'));

INSERT INTO COMENTARII (id_comentariu,id_client,id_film,id_actor,continut,data_comentariu)
VALUES (seq_comentarii.NEXTVAL, 6, 7, NULL, 'Pulp Fiction este inovator si captivant de la inceput pana la sfarsit', TO_DATE('2025-03-22','YYYY-MM-DD'));

INSERT INTO COMENTARII (id_comentariu,id_client,id_film,id_actor,continut,data_comentariu)
VALUES (seq_comentarii.NEXTVAL, 7, 8, NULL, 'The Godfather este perfectiunea cinematografiei americane, un monument', TO_DATE('2025-04-14','YYYY-MM-DD'));

INSERT INTO COMENTARII (id_comentariu,id_client,id_film,id_actor,continut,data_comentariu)
VALUES (seq_comentarii.NEXTVAL, 7, NULL, 8, 'Marlon Brando livreaza o performanta de neuitat, definitiva pentru cariera sa', TO_DATE('2025-04-15','YYYY-MM-DD'));

INSERT INTO COMENTARII (id_comentariu,id_client,id_film,id_actor,continut,data_comentariu)
VALUES (seq_comentarii.NEXTVAL, 8, 10, NULL, 'Goodfellas este o capodopera a genului gangster, Scorsese la apogeu', TO_DATE('2025-05-07','YYYY-MM-DD'));

INSERT INTO COMENTARII (id_comentariu,id_client,id_film,id_actor,continut,data_comentariu)
VALUES (seq_comentarii.NEXTVAL, 8, 11, NULL, 'Schindler s List este un film cutremurator si absolut necesar istoriei cinematografice', TO_DATE('2025-05-12','YYYY-MM-DD'));

INSERT INTO COMENTARII (id_comentariu,id_client,id_film,id_actor,continut,data_comentariu)
VALUES (seq_comentarii.NEXTVAL, 9, NULL, 6, 'Keanu Reeves este perfect in rolul lui Neo, credibil si carismatic', TO_DATE('2025-06-03','YYYY-MM-DD'));

INSERT INTO COMENTARII (id_comentariu,id_client,id_film,id_actor,continut,data_comentariu)
VALUES (seq_comentarii.NEXTVAL,10, 13, NULL, 'Titanic este un film superb si emotionant pana la lacrimi, vizionat de doua ori', TO_DATE('2025-02-15','YYYY-MM-DD'));

-- -------------------------------------------------------
-- CARACTERIZARI_OPTIUNI (17 optiuni predefinite)
-- -------------------------------------------------------
INSERT INTO CARACTERIZARI_OPTIUNI VALUES (seq_optiuni.NEXTVAL, 'Mi-a placut',                    'POZITIV');
INSERT INTO CARACTERIZARI_OPTIUNI VALUES (seq_optiuni.NEXTVAL, 'Nu mi-a placut',                 'NEGATIV');
INSERT INTO CARACTERIZARI_OPTIUNI VALUES (seq_optiuni.NEXTVAL, 'Interesant',                     'POZITIV');
INSERT INTO CARACTERIZARI_OPTIUNI VALUES (seq_optiuni.NEXTVAL, 'Emotionant',                     'POZITIV');
INSERT INTO CARACTERIZARI_OPTIUNI VALUES (seq_optiuni.NEXTVAL, 'Plictisitor',                    'NEGATIV');
INSERT INTO CARACTERIZARI_OPTIUNI VALUES (seq_optiuni.NEXTVAL, 'As recomanda',                   'POZITIV');
INSERT INTO CARACTERIZARI_OPTIUNI VALUES (seq_optiuni.NEXTVAL, 'As mai viziona',                 'POZITIV');
INSERT INTO CARACTERIZARI_OPTIUNI VALUES (seq_optiuni.NEXTVAL, 'Actor principal apreciat',       'POZITIV');
INSERT INTO CARACTERIZARI_OPTIUNI VALUES (seq_optiuni.NEXTVAL, 'Scenariu slab',                  'NEGATIV');
INSERT INTO CARACTERIZARI_OPTIUNI VALUES (seq_optiuni.NEXTVAL, 'Efecte speciale impresionante',  'POZITIV');
INSERT INTO CARACTERIZARI_OPTIUNI VALUES (seq_optiuni.NEXTVAL, 'Regie excelenta',                'POZITIV');
INSERT INTO CARACTERIZARI_OPTIUNI VALUES (seq_optiuni.NEXTVAL, 'Coloana sonora superba',         'POZITIV');
INSERT INTO CARACTERIZARI_OPTIUNI VALUES (seq_optiuni.NEXTVAL, 'Prea lung',                      'NEGATIV');
INSERT INTO CARACTERIZARI_OPTIUNI VALUES (seq_optiuni.NEXTVAL, 'Final neasteptat',               'NEUTRU');
INSERT INTO CARACTERIZARI_OPTIUNI VALUES (seq_optiuni.NEXTVAL, 'Film supraapreciat',             'NEGATIV');
INSERT INTO CARACTERIZARI_OPTIUNI VALUES (seq_optiuni.NEXTVAL, 'Recomandat familie',             'POZITIV');
INSERT INTO CARACTERIZARI_OPTIUNI VALUES (seq_optiuni.NEXTVAL, 'Violent',                        'NEUTRU');

-- -------------------------------------------------------
-- CARACTERIZARI_CLIENT (20 selectii client-film-optiune)
-- -------------------------------------------------------
INSERT INTO CARACTERIZARI_CLIENT VALUES (seq_caracterizari.NEXTVAL, 1,  1,  1,  SYSDATE);
INSERT INTO CARACTERIZARI_CLIENT VALUES (seq_caracterizari.NEXTVAL, 1,  1,  3,  SYSDATE);
INSERT INTO CARACTERIZARI_CLIENT VALUES (seq_caracterizari.NEXTVAL, 1,  1,  6,  SYSDATE);
INSERT INTO CARACTERIZARI_CLIENT VALUES (seq_caracterizari.NEXTVAL, 1,  2,  1,  SYSDATE);
INSERT INTO CARACTERIZARI_CLIENT VALUES (seq_caracterizari.NEXTVAL, 2,  1,  1,  SYSDATE);
INSERT INTO CARACTERIZARI_CLIENT VALUES (seq_caracterizari.NEXTVAL, 2,  1,  10, SYSDATE);
INSERT INTO CARACTERIZARI_CLIENT VALUES (seq_caracterizari.NEXTVAL, 2,  1,  11, SYSDATE);
INSERT INTO CARACTERIZARI_CLIENT VALUES (seq_caracterizari.NEXTVAL, 2,  3,  4,  SYSDATE);
INSERT INTO CARACTERIZARI_CLIENT VALUES (seq_caracterizari.NEXTVAL, 3,  6,  1,  SYSDATE);
INSERT INTO CARACTERIZARI_CLIENT VALUES (seq_caracterizari.NEXTVAL, 3,  6,  14, SYSDATE);
INSERT INTO CARACTERIZARI_CLIENT VALUES (seq_caracterizari.NEXTVAL, 3,  13, 4,  SYSDATE);
INSERT INTO CARACTERIZARI_CLIENT VALUES (seq_caracterizari.NEXTVAL, 3,  13, 12, SYSDATE);
INSERT INTO CARACTERIZARI_CLIENT VALUES (seq_caracterizari.NEXTVAL, 4,  5,  4,  SYSDATE);
INSERT INTO CARACTERIZARI_CLIENT VALUES (seq_caracterizari.NEXTVAL, 4,  5,  16, SYSDATE);
INSERT INTO CARACTERIZARI_CLIENT VALUES (seq_caracterizari.NEXTVAL, 5,  9,  3,  SYSDATE);
INSERT INTO CARACTERIZARI_CLIENT VALUES (seq_caracterizari.NEXTVAL, 5,  9,  14, SYSDATE);
INSERT INTO CARACTERIZARI_CLIENT VALUES (seq_caracterizari.NEXTVAL, 6,  1,  6,  SYSDATE);
INSERT INTO CARACTERIZARI_CLIENT VALUES (seq_caracterizari.NEXTVAL, 6,  7,  1,  SYSDATE);
INSERT INTO CARACTERIZARI_CLIENT VALUES (seq_caracterizari.NEXTVAL, 7,  8,  1,  SYSDATE);
INSERT INTO CARACTERIZARI_CLIENT VALUES (seq_caracterizari.NEXTVAL, 7,  8,  8,  SYSDATE);

COMMIT;