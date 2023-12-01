CREATE OR REPLACE PACKAGE dodaj AS
	TYPE INTARR IS TABLE OF NUMBER(10);
	TYPE VARCHRARR IS TABLE OF VARCHAR2(50);
	
	PROCEDURE dodajProdukt(iNazwa VARCHAR2(50), iCena NUMBER(15,2), iOpis VARCHAR2(200), iKategoria VARCHAR2(50), iArrCena IN INTARR, iArrMaterial IN VARCHRARR);
	--PROCEDURE dodajZamowienie();
END dodaj;
/

CREATE OR REPLACE PACKAGE BODY dodaj AS
	PROCEDURE dodajProdukt(iNazwa VARCHAR2(50), iCena NUMBER(15,2), iOpis VARCHAR2(200), iKategoria VARCHAR2(50), iArrIlosc IN INTARR, iArrMaterial IN VARCHRARR) AS
		ile NUMBER(10);
		mat VARCHAR2(50);
	BEGIN
		INSERT INTO produkt VALUES(iNazwa, iCena, iOpis, iKategoria);
		
		FOR ile, mat IN iArrIlosc.FIRST..iArrIlosc.LAST, iArrMaterial.First..iArrMaterial.LAST LOOP
			INPUT INTO wymagany_material VALUES(ile, mat, iNazwa);
		END LOOP;
		
	END dodajProdukt;
	/
END dodaj;
/

CREATE OR REPLACE PACKAGE dodaj AS
    TYPE INTARR IS TABLE OF NUMBER(10);
    TYPE VARCHRARR IS TABLE OF VARCHAR2(50);

    PROCEDURE dodajProdukt(iNazwa VARCHAR2, iCena NUMBER, iOpis VARCHAR2, iKategoria VARCHAR2, iArrIlosc IN INTARR, iArrMaterial IN VARCHRARR);
    -- PROCEDURE dodajZamowienie();
END dodaj;
/

CREATE OR REPLACE PACKAGE BODY dodaj AS
    PROCEDURE dodajProdukt(iNazwa VARCHAR2, iCena NUMBER, iOpis VARCHAR2, iKategoria VARCHAR2, iArrIlosc IN INTARR, iArrMaterial IN VARCHRARR) AS
        ile NUMBER(10);
        mat VARCHAR2(50);
    BEGIN
        INSERT INTO produkt VALUES(iNazwa, iCena, iOpis, iKategoria);

        FOR i IN iArrIlosc.FIRST..iArrIlosc.LAST LOOP
            ile := iArrIlosc(i);
            mat := iArrMaterial(i);

            INSERT INTO wymagany_material VALUES(ile, mat, iNazwa);
        END LOOP;

    END dodajProdukt;
END dodaj;
/
