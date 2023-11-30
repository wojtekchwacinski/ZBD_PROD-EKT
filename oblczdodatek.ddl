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
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            -- Obsługa sytuacji, gdy nie znaleziono danych dla danego pracownika
            DBMS_OUTPUT.PUT_LINE('Brak danych dla pracownika o PESEL ' || PeselParam);
            RETURN NULL;
        WHEN OTHERS THEN
            -- Obsługa innych błędów
            DBMS_OUTPUT.PUT_LINE('Wystąpił błąd: ' || SQLERRM);
            RETURN NULL;
    END;
    RETURN lata_pracy * dodatek;
END obliczDodatek;
