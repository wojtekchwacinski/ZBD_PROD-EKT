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
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            
            DBMS_OUTPUT.PUT_LINE('Brak danych dla produktu o nazwie ' || nazwa_produktu_param);
            RETURN NULL;
        WHEN OTHERS THEN
            
            DBMS_OUTPUT.PUT_LINE('Wystąpił błąd: ' || SQLERRM);
            RETURN NULL;
    END;
    

    RETURN koszt_produkcji;
END;
