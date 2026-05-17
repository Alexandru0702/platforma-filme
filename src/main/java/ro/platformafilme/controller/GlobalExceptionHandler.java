package ro.platformafilme.controller;

import org.springframework.dao.DataAccessException;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;

import java.sql.SQLException;

/**
 * Handler global pentru exceptii - prinde erorile aruncate din PL/SQL
 * prin RAISE_APPLICATION_ERROR si le afiseaza utilizatorului.
 *
 * Exceptii custom definite in PL/SQL:
 *  -20001 : versiune film inactiva (trigger trg_prevent_inactive_version)
 *  -20003 : comentariu fara film sau actor (trigger trg_auto_tip_comentariu)
 *  -20010 : film cu titlu duplicat (pkg_filme)
 *  -20020 : email client duplicat (pkg_clienti)
 *  -20031 : actor deja in distributie (pkg_actori)
 *  -20040 : vot duplicat (pkg_interactiune)
 *  -20041 : nota invalida (pkg_interactiune)
 *  -20043 : stergere comentariu nepermisa (pkg_interactiune)
 */
@ControllerAdvice
public class GlobalExceptionHandler {

    /**
     * Prinde DataAccessException care include SQLException-urile Oracle
     * Extrage mesajul custom definit in PL/SQL prin RAISE_APPLICATION_ERROR
     */
    @ExceptionHandler(DataAccessException.class)
    public String handleDataAccessException(DataAccessException ex, Model model) {
        String mesajUtilizator = "A aparut o eroare la accesarea bazei de date.";
        String detalii = ex.getMessage();

        // Gasim cauza originala SQLException
        Throwable cauza = ex.getCause();
        if (cauza instanceof SQLException sqlEx) {
            int codEroare = sqlEx.getErrorCode();
            String mesajOracle = sqlEx.getMessage();

            // Erorile custom Oracle sunt in intervalul 20000-20999
            if (codEroare >= 20000 && codEroare <= 20999) {
                // Mesajul Oracle arata: "ORA-20040: mesaj custom\nORA-06512: at ...\n"
                // Extragem doar prima linie si eliminam prefixul ORA-XXXXX:
                String primulRand = mesajOracle.split("\n")[0];
                mesajUtilizator = primulRand.replaceFirst("ORA-\\d+:\\s*", "").trim();
            } else if (codEroare == 1) {
                // ORA-00001: unique constraint violated
                mesajUtilizator = "Datele introduse incalca o constrangere de unicitate. Verificati daca inregistrarea exista deja.";
            } else if (codEroare == 2292) {
                // ORA-02292: integrity constraint violated - child record found
                mesajUtilizator = "Inregistrarea nu poate fi stearsa deoarece are date asociate in alte tabele.";
            } else {
                mesajUtilizator = "Eroare baza de date (cod: " + codEroare + "): " + mesajOracle.split("\n")[0];
            }
            detalii = "Cod Oracle: " + codEroare;
        }

        model.addAttribute("titluEroare", "Operatiune nereusita");
        model.addAttribute("mesajEroare", mesajUtilizator);
        model.addAttribute("detaliiEroare", detalii);
        return "error";
    }

    /**
     * Handler general pentru orice alta exceptie neasteptata
     */
    @ExceptionHandler(Exception.class)
    public String handleGeneralException(Exception ex, Model model) {
        model.addAttribute("titluEroare", "Eroare neasteptata");
        model.addAttribute("mesajEroare", "A aparut o eroare neasteptata. Va rugam incercati din nou.");
        model.addAttribute("detaliiEroare", ex.getMessage());
        return "error";
    }
}