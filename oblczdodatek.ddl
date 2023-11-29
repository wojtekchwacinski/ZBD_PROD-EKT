CREATE OR REPLACE FUNCTION obliczDodatek(PeselParam VARCHAR2) RETURN NUMBER IS
    data_zatrudnienia DATE;
    dzis DATE;
    lata_pracy NUMBER;
BEGIN
    SELECT data_zatrudnienia INTO data_zatrudnienia FROM Pracownik WHERE Pesel = PeselParam;
    dzis := SYSDATE;
    lata_pracy := EXTRACT(YEAR FROM dzis) - EXTRACT(YEAR FROM data_zatrudnienia);
    RETURN lata_pracy * 100;
END obliczDodatek;
