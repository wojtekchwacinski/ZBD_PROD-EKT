--1. TABELKA DOSTAWCA_MATERIAŁU
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

--2.TABELKA KATEGORIA_PRODUKTU
CREATE TABLE kategoria_produktu (
    kategoria VARCHAR2(50) PRIMARY KEY
);

--3.TABELKA KLIENT
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

--4.TABELKA LINIA_PRODUKCYJNA
CREATE TABLE linia_produkcyjna (
    numer_linni_produkcyjnej               NUMBER(10) PRIMARY KEY, 
    szybkosc_produkcji 			   NUMBER(10) NOT NULL
);

--5.TABELKA MATERIAŁ
CREATE TABLE material (
    nazwa_materialu VARCHAR2(50) PRIMARY KEY
);

--6.TABELKA MIEJSCE_w_MAGAZYNIE
CREATE TABLE miejsce_w_magazynie (
    numer_alejki  NUMBER(10) PRIMARY KEY,
    numer_miejsca NUMBER(10) PRIMARY KEY,
    stan_miejsca  CHAR(1) NOT NULL
);

--7.TABLEKA 
CREATE TABLE pracownik (
    pesel                                      NUMBER(11) PRIMARY KEY,
    imie                                       VARCHAR2(50) NOT NULL,
    nazwisko                                   VARCHAR2(50) NOT NULL,
    data_zatrudnienia                          DATE NOT NULL,
    numer_konta                                NUMBER(26) NOT NULL,
    nazwa_stanowiska                           VARCHAR2(50) REFERENCES stanowisko(nazwa) NOT NULL,
    kod_pocztowy                               VARCHAR2(6) NOT NULL,
    ulica                                      VARCHAR2(50) NOT NULL,
    numer_budynku                              NUMBER(4) NOT NULL,
    miasto                                     VARCHAR2(50) NOT NULL,
    kraj                                       VARCHAR2(50) NOT NULL, 
    przypisana_linia 			       NUMBER(10) REFERENCES linia_produkcyjna(numer_linni_produkcyjnej) NOT NULL
);

--8.TABELKA PRODUKT
CREATE TABLE produkt (
    nazwa_produktu               VARCHAR2(50) PRIMARY KEY,
    cena_produkcji               NUMBER(15, 2) NOT NULL,
    opis                         VARCHAR2(200),
    kategoria                    VARCHAR2(50) REFERENCES kategoria_produktu(kategoria) NOT NULL
);

--9.TABELKA PRZYPISANIE_LINNI_PRODUKCYJNEJ
CREATE TABLE przypisane_linni_produkcyjnej (
    numer_zamowienia                	       NUMBER(10) REFERENCES zamowienie(numer_zamowienia) PRIMARY KEY, 
    numer_linni                                NUMBER(10) REFERENCES linia_produkcyjna(numer_linni_produkcyjnej) PRIMARY KEY,
    data_zajęcia                               DATE NOT NULL,
    data_zwolnienia                            DATE NOT NULL
);

--10.TABELKA STAN_ZAMÓWIENIA
CREATE TABLE stan_zamowienia (
    stan VARCHAR2(50) PRIMARY KEY
);

--11.TABELKA STANOWISKO 
CREATE TABLE stanowisko (
    nazwa            VARCHAR2(50) PRIMARY KEY,
    placa_podstawowa NUMBER(10, 2) NOT NULL,
    dodatki          NUMBER(6, 2)
);

--12.TABELKA WYMAGANY_MATERIAŁ
CREATE TABLE wymagany_material (
    ilosc_materialu          NUMBER(5) NOT NULL,
    nazwa_materialu          VARCHAR2(50) REFERENCES material(nazwa_materialu) PRIMARY KEY,
    nazwa_produktu           VARCHAR2(50) REFERENCES produkt(nazwa_produktu) PRIMARY KEY
);

--13.TABELKA ZAJĘTY_MIEJSCE
CREATE TABLE zajete_miejsce (
    ilosc_materialu                       NUMBER(10) NOT NULL, 
    numer_zamowienia                      NUMBER(10) REFERENCES zamowienie_materialu(numer_zamowienia) PRIMARY KEY,  
    numer_alejki                          NUMBER(10) REFERENCES miejsce_w_magazynie(numer_alejki) PRIMARY KEY,  
    numer_miejsca                         NUMBER(10) REFERENCES miejsce_w_magazynie(numer_miejsca) PRIMARY KEY
);

--14.TABELKA ZAMÓWIENIE
CREATE TABLE zamowienie (
    numer_zamowienia             NUMBER(10) PRIMARY KEY,
    data_zamowienia              DATE NOT NULL,
    nazwa_firmy                  VARCHAR2(50) REFERENCES klient(nazwa_firmy) NOT NULL,
    cena_zamowienia              NUMBER(15, 2) NOT NULL,
    przewidywana_data_realizacji DATE NOT NULL,
    stan                         VARCHAR2(50)   REFERENCES stan_zamowienia(stan) NOT NULL
);

--15.TABELKA 
CREATE TABLE zamowienie_materialu (
    numer_zamowienia                  NUMBER(10) PRIMARY KEY,
    cena_zakupu_materialu             NUMBER(15, 2) NOT NULL,
    ilosc                             NUMBER(10) NOT NULL,  
    materialu_nazwa_dostawcy VARCHAR2(70) REFERENCES dostawca_materialu(nazwa_dostawcy) NOT NULL,
    nazwa_materialu          VARCHAR2(50) REFERENCES material(nazwa_materialu) NOT NULL
);

--16.TABELKA ZAMÓWIONY_TYP_PRODUKTU
CREATE TABLE zamowiony_typ_produktu (
    ilosc                       NUMBER(10) NOT NULL,
    nazwa_produktu              VARCHAR2(50) REFERENCES produkt(nazwa_produktu) PRIMARY KEY,
    numer_zamowienia            NUMBER(10) REFERENCES zamowienie(numer_zamowienia) PRIMARY KEY
);