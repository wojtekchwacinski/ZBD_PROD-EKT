CREATE TABLE dostawca_materialu (
    nazwa_dostawcy VARCHAR2(70) PRIMARY KEY,
    numer_telefonu NUMBER(9) NOT NULL,
    adres_email    VARCHAR2(100),
    kod_pocztowy   VARCHAR2(6) NOT NULL,
    ulica          VARCHAR2(50) NOT NULL,
    numer_budynku  NUMBER(4) NOT NULL,
    miasto         VARCHAR2(50) NOT NULL,
    kraj           VARCHAR2(50) NOT NULL
);


CREATE TABLE kategoria_produktu (
    kategoria VARCHAR2(50) PRIMARY KEY
);

CREATE TABLE klient (
    nazwa_firmy    VARCHAR2(50) PRIMARY KEY,
    numer_telefonu NUMBER(9) NOT NULL,
    adres_email    VARCHAR2(50) NOT NULL,
    kod_pocztowy   VARCHAR2(6) NOT NULL,
    ulica          VARCHAR2(50) NOT NULL,
    numer_budynku  NUMBER(4) NOT NULL,
    miasto         VARCHAR2(50) NOT NULL,
    kraj           VARCHAR2(50) NOT NULL
);


CREATE TABLE linia_produkcyjna (
    numer_linni_produkcyjnej               NUMBER(10) PRIMARY KEY, 
    szybkosc_produkcji 			   NUMBER(10) NOT NULL
);


CREATE TABLE material (
    nazwa_materialu VARCHAR2(50) PRIMARY KEY
);


CREATE TABLE miejsce_w_magazynie (
    numer_alejki  NUMBER(10),
    numer_miejsca NUMBER(10),
    stan_miejsca  CHAR(1) NOT NULL,
	CONSTRAINT pKeyMagazyn PRIMARY KEY(numer_alejki, numer_miejsca)
);


CREATE TABLE pracownik (
    pesel                              NUMBER(11) PRIMARY KEY,
    imie                               VARCHAR2(50) NOT NULL,
    nazwisko                           VARCHAR2(50) NOT NULL,
    data_zatrudnienia                  DATE NOT NULL,
    numer_konta                        NUMBER(26) NOT NULL,
    nazwa_stanowiska                   VARCHAR2(50) REFERENCES stanowisko(nazwa) NOT NULL,
    kod_pocztowy                       VARCHAR2(6) NOT NULL,
    ulica                              VARCHAR2(50) NOT NULL,
    numer_budynku                      NUMBER(4) NOT NULL,
    miasto                             VARCHAR2(50) NOT NULL,
    kraj                               VARCHAR2(50) NOT NULL, 
    przypisana_linia 			       NUMBER(10) REFERENCES linia_produkcyjna(numer_linni_produkcyjnej) NOT NULL
);


CREATE TABLE produkt (
    nazwa_produktu               VARCHAR2(50) PRIMARY KEY,
    cena_produkcji               NUMBER(15, 2) NOT NULL,
    opis                         VARCHAR2(200),
    kategoria                    VARCHAR2(50) REFERENCES kategoria_produktu(kategoria) NOT NULL
);


CREATE TABLE przypisane_linni_produkcyjnej (
    numer_zamowienia                	       NUMBER(10) REFERENCES zamowienie(numer_zamowienia), 
    numer_linni                                NUMBER(10) REFERENCES linia_produkcyjna(numer_linni_produkcyjnej),
    data_zajęcia                               DATE NOT NULL,
    data_zwolnienia                            DATE NOT NULL,
	CONSTRAINT pKeyPrypLinProd PRIMARY KEY(numer_zamowienia, numer_linni)
);


CREATE TABLE stan_zamowienia (
    stan VARCHAR2(50) PRIMARY KEY
);

 
CREATE TABLE stanowisko (
    nazwa            VARCHAR2(50) PRIMARY KEY,
    placa_podstawowa NUMBER(10, 2) NOT NULL,
    dodatki          NUMBER(6, 2)
);


CREATE TABLE wymagany_material (
    ilosc_materialu          NUMBER(5) NOT NULL,
    nazwa_materialu          VARCHAR2(50) REFERENCES material(nazwa_materialu),
    nazwa_produktu           VARCHAR2(50) REFERENCES produkt(nazwa_produktu),
	CONSTRAINT pKeyWymMater PRIMARY KEY(nazwa_produktu, nazwa_materialu)
);


CREATE TABLE zajete_miejsce (
    ilosc_materialu                       NUMBER(10) NOT NULL, 
    numer_zamowienia                      NUMBER(10) REFERENCES zamowienie_materialu(numer_zamowienia),  
    numer_alejki                          NUMBER(10) REFERENCES miejsce_w_magazynie(numer_alejki),  
    numer_miejsca                         NUMBER(10) REFERENCES miejsce_w_magazynie(numer_miejsca),
	CONSTRAINT pKeyZajMiejsca PRIMARY KEY(numer_zamowienia, numer_alejki, numer_miejsca)
);


CREATE TABLE zamowienie (
    numer_zamowienia             NUMBER(10) PRIMARY KEY,
    data_zamowienia              DATE NOT NULL,
    nazwa_firmy                  VARCHAR2(50) REFERENCES klient(nazwa_firmy) NOT NULL,
    cena_zamowienia              NUMBER(15, 2) NOT NULL,
    przewidywana_data_realizacji DATE NOT NULL,
    stan                         VARCHAR2(50)   REFERENCES stan_zamowienia(stan) NOT NULL
);


CREATE TABLE zamowienie_materialu (
    numer_zamowienia                  NUMBER(10) PRIMARY KEY,
    cena_zakupu_materialu             NUMBER(15, 2) NOT NULL,
    ilosc                             NUMBER(10) NOT NULL,  
    materialu_nazwa_dostawcy VARCHAR2(70) REFERENCES dostawca_materialu(nazwa_dostawcy) NOT NULL,
    nazwa_materialu          VARCHAR2(50) REFERENCES material(nazwa_materialu) NOT NULL
);


CREATE TABLE zamowiony_typ_produktu (
    ilosc                       NUMBER(10) NOT NULL,
    nazwa_produktu              VARCHAR2(50) REFERENCES produkt(nazwa_produktu),
    numer_zamowienia            NUMBER(10) REFERENCES zamowienie(numer_zamowienia),
	CONSTRAINT pKeyZamTypProd PRIMARY KEY(numer_zamowienia, nazwa_produktu)
);

--Funkcje

CREATE OR REPLACE FUNCTION obliczDodatek(PeselParam VARCHAR2) RETURN NUMBER IS
    data_zatrudnienia DATE;
    dzis DATE;
    lata_pracy NUMBER;
    dodatek NUMBER;
    nazwa_st VARCHAR2(50);
BEGIN
    SELECT data_zatrudnienia INTO data_zatrudnienia FROM Pracownik WHERE Pesel = PeselParam;
    select nazwa_stanowiska into nazwa_st from pracownik where Pesel = PeselParam;
    dzis := SYSDATE;
    SELECT placa_dodatkowa into dodatek from STANOWISKO where nazwa = nazwa_st;
    lata_pracy := EXTRACT(YEAR FROM dzis) - EXTRACT(YEAR FROM data_zatrudnienia);
    RETURN lata_pracy * dodatek;
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
        -- Obsługa sytuacji, gdy nie znaleziono danych dla danego pracownika
        DBMS_OUTPUT.PUT_LINE('Brak danych dla pracownika o PESEL ' || PeselParam);
        RETURN NULL;
    WHEN OTHERS THEN
        -- Obsługa innych błędów
        DBMS_OUTPUT.PUT_LINE('Wystąpił błąd: ' || SQLERRM);
        RETURN NULL;
   
END obliczDodatek;

CREATE OR REPLACE FUNCTION obliczKosztProdukcji(nazwa_produktu_param VARCHAR2) RETURN NUMBER IS
    koszt_produkcji NUMBER(15, 2) := 0;

BEGIN
  
    FOR r IN (SELECT wm.ilosc_materialu, m.cena_zakupu_materialu
              FROM wymagany_material wm
              JOIN ZAMOWIENIE_MATERIALU m ON wm.nazwa_materialu = m.nazwa_materialu
              WHERE wm.nazwa_produktu = nazwa_produktu_param)
    LOOP
        koszt_produkcji := koszt_produkcji + (r.ilosc_materialu * r.cena_zakupu_materialu);
    END LOOP;
        --doliczam robocizne do tego mebelka 
        koszt_produkcji := koszt_produkcji * 1.2;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            
            DBMS_OUTPUT.PUT_LINE('Brak danych dla produktu o nazwie ' || nazwa_produktu_param);
            RETURN NULL;
        WHEN OTHERS THEN
            
            DBMS_OUTPUT.PUT_LINE('Wystąpił błąd: ' || SQLERRM);
            RETURN NULL;
    
    

    RETURN koszt_produkcji;
END;

--sekwencje

CREATE SEQUENCE seqLinProd
	START WITH 1
	INCREMENT BY 1
	MINVALUE 1;
	
CREATE SEQUENCE seqZamMater
	START WITH 1
	INCREMENT BY 1
	MINVALUE 1;

CREATE SEQUENCE seqZamowienia
	START WITH 1
	INCREMENT BY 1
	MINVALUE 1;

--procedury


