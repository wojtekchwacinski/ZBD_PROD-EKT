CREATE OR REPLACE FUNCTION obliczKosztProdukcji(nazwa_produktu_param VARCHAR2) RETURN NUMBER IS
    koszt_produkcji NUMBER(15, 2) := 0;

BEGIN
  
    FOR r IN (SELECT wm.ilosc_materialu, m.cena_zakupu_materialu
              FROM wymagany_material wm
              JOIN material m ON wm.nazwa_materialu = m.nazwa_materialu
              WHERE wm.nazwa_produktu = nazwa_produktu_param)
    LOOP
        koszt_produkcji := koszt_produkcji + (r.ilosc_materialu * r.cena_zakupu_materialu);
    END LOOP;
        --doliczam robocizne do tego mebelka 
        koszt_produkcji := koszt_produkcji * 1.2;

    

    RETURN koszt_produkcji;
END;
