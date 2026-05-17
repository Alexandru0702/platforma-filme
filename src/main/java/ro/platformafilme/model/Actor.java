package ro.platformafilme.model;
import java.time.LocalDate;
public class Actor {
    private Long idActor; private String prenume; private String numeFamilie;
    private String numeScena; private LocalDate dataNastere; private String nationalitate; private Integer nrFilme;
    public Actor() {}
    public Long getIdActor() { return idActor; } public void setIdActor(Long v) { idActor = v; }
    public String getPrenume() { return prenume; } public void setPrenume(String v) { prenume = v; }
    public String getNumeFamilie() { return numeFamilie; } public void setNumeFamilie(String v) { numeFamilie = v; }
    public String getNumeScena() { return numeScena; } public void setNumeScena(String v) { numeScena = v; }
    public LocalDate getDataNastere() { return dataNastere; } public void setDataNastere(LocalDate v) { dataNastere = v; }
    public String getNationalitate() { return nationalitate; } public void setNationalitate(String v) { nationalitate = v; }
    public Integer getNrFilme() { return nrFilme; } public void setNrFilme(Integer v) { nrFilme = v; }
    public String getNumeDisplay() { return numeScena != null && !numeScena.isEmpty() ? numeScena : prenume + " " + numeFamilie; }
}