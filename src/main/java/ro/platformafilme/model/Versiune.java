package ro.platformafilme.model;
public class Versiune {
    private Long idVersiune; private Long idFilm; private String format;
    private String rezolutie; private String limba; private String subtitrare; private Boolean activ;
    public Versiune() {}
    public Long getIdVersiune() { return idVersiune; } public void setIdVersiune(Long v) { idVersiune = v; }
    public Long getIdFilm() { return idFilm; } public void setIdFilm(Long v) { idFilm = v; }
    public String getFormat() { return format; } public void setFormat(String v) { format = v; }
    public String getRezolutie() { return rezolutie; } public void setRezolutie(String v) { rezolutie = v; }
    public String getLimba() { return limba; } public void setLimba(String v) { limba = v; }
    public String getSubtitrare() { return subtitrare; } public void setSubtitrare(String v) { subtitrare = v; }
    public Boolean getActiv() { return activ; } public void setActiv(Boolean v) { activ = v; }
}