package ro.platformafilme.model;
import java.time.LocalDate;
public class Client {
    private Long idClient; private String prenume; private String nume;
    private String telefonAcasa; private String adresa; private String oras;
    private String email; private String telefonMobil; private LocalDate dataInregistrare;
    public Client() {}
    public Long getIdClient() { return idClient; } public void setIdClient(Long v) { idClient = v; }
    public String getPrenume() { return prenume; } public void setPrenume(String v) { prenume = v; }
    public String getNume() { return nume; } public void setNume(String v) { nume = v; }
    public String getTelefonAcasa() { return telefonAcasa; } public void setTelefonAcasa(String v) { telefonAcasa = v; }
    public String getAdresa() { return adresa; } public void setAdresa(String v) { adresa = v; }
    public String getOras() { return oras; } public void setOras(String v) { oras = v; }
    public String getEmail() { return email; } public void setEmail(String v) { email = v; }
    public String getTelefonMobil() { return telefonMobil; } public void setTelefonMobil(String v) { telefonMobil = v; }
    public LocalDate getDataInregistrare() { return dataInregistrare; } public void setDataInregistrare(LocalDate v) { dataInregistrare = v; }
    public String getNumeComplet() { return prenume + " " + nume; }
}