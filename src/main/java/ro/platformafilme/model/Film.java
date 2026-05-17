package ro.platformafilme.model;
import java.time.LocalDate;
public class Film {
    private Long idFilm; private String titlu; private String descriere;
    private LocalDate dataLansare; private Integer durata; private Double rating;
    private Long idCategorie; private String categorie;
    public Film() {}
    public Long getIdFilm() { return idFilm; } public void setIdFilm(Long v) { idFilm = v; }
    public String getTitlu() { return titlu; } public void setTitlu(String v) { titlu = v; }
    public String getDescriere() { return descriere; } public void setDescriere(String v) { descriere = v; }
    public LocalDate getDataLansare() { return dataLansare; } public void setDataLansare(LocalDate v) { dataLansare = v; }
    public Integer getDurata() { return durata; } public void setDurata(Integer v) { durata = v; }
    public Double getRating() { return rating; } public void setRating(Double v) { rating = v; }
    public Long getIdCategorie() { return idCategorie; } public void setIdCategorie(Long v) { idCategorie = v; }
    public String getCategorie() { return categorie; } public void setCategorie(String v) { categorie = v; }
}