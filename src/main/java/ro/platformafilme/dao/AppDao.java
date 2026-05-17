package ro.platformafilme.dao;

import oracle.jdbc.OracleTypes;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.core.SqlOutParameter;
import org.springframework.jdbc.core.SqlParameter;
import org.springframework.jdbc.core.namedparam.MapSqlParameterSource;
import org.springframework.jdbc.core.simple.SimpleJdbcCall;
import org.springframework.stereotype.Repository;
import ro.platformafilme.model.*;

import java.sql.Date;
import java.sql.Types;
import java.util.List;
import java.util.Map;

@Repository
public class AppDao {

    private final JdbcTemplate jdbc;

    public AppDao(JdbcTemplate jdbc) {
        this.jdbc = jdbc;
    }

    // ================================================================
    // FILME
    // ================================================================

    @SuppressWarnings("unchecked")
    public List<Film> getAllFilme() {
        Map<String, Object> out = new SimpleJdbcCall(jdbc)
                .withCatalogName("PKG_FILME").withProcedureName("GET_ALL_FILME")
                .withoutProcedureColumnMetaDataAccess()
                .declareParameters(new SqlOutParameter("p_cursor", OracleTypes.CURSOR, filmMapper()))
                .execute(new MapSqlParameterSource());
        return (List<Film>) out.get("p_cursor");
    }

    @SuppressWarnings("unchecked")
    public Film getFilmById(Long id) {
        Map<String, Object> out = new SimpleJdbcCall(jdbc)
                .withCatalogName("PKG_FILME").withProcedureName("GET_FILM_BY_ID")
                .withoutProcedureColumnMetaDataAccess()
                .declareParameters(
                        new SqlParameter("p_id_film", Types.NUMERIC),
                        new SqlOutParameter("p_cursor", OracleTypes.CURSOR, filmMapper()))
                .execute(new MapSqlParameterSource().addValue("p_id_film", id));
        List<Film> list = (List<Film>) out.get("p_cursor");
        return list != null && !list.isEmpty() ? list.get(0) : null;
    }

    @SuppressWarnings("unchecked")
    public List<Film> getFilmeByCategorie(Long idCategorie) {
        Map<String, Object> out = new SimpleJdbcCall(jdbc)
                .withCatalogName("PKG_FILME").withProcedureName("GET_FILME_BY_CATEGORIE")
                .withoutProcedureColumnMetaDataAccess()
                .declareParameters(
                        new SqlParameter("p_id_categorie", Types.NUMERIC),
                        new SqlOutParameter("p_cursor", OracleTypes.CURSOR, filmMapper()))
                .execute(new MapSqlParameterSource().addValue("p_id_categorie", idCategorie));
        return (List<Film>) out.get("p_cursor");
    }

    @SuppressWarnings("unchecked")
    public List<Film> getTopFilme(int nr) {
        Map<String, Object> out = new SimpleJdbcCall(jdbc)
                .withCatalogName("PKG_FILME").withProcedureName("GET_TOP_FILME")
                .withoutProcedureColumnMetaDataAccess()
                .declareParameters(
                        new SqlParameter("p_nr", Types.NUMERIC),
                        new SqlOutParameter("p_cursor", OracleTypes.CURSOR, filmMapper()))
                .execute(new MapSqlParameterSource().addValue("p_nr", nr));
        return (List<Film>) out.get("p_cursor");
    }

    public Long insertFilm(Film f) {
        Map<String, Object> out = new SimpleJdbcCall(jdbc)
                .withCatalogName("PKG_FILME").withProcedureName("INSERT_FILM")
                .withoutProcedureColumnMetaDataAccess()
                .declareParameters(
                        new SqlParameter("p_titlu", Types.VARCHAR),
                        new SqlParameter("p_descriere", Types.VARCHAR),
                        new SqlParameter("p_data_lansare", Types.DATE),
                        new SqlParameter("p_durata", Types.NUMERIC),
                        new SqlParameter("p_id_categorie", Types.NUMERIC),
                        new SqlOutParameter("p_id_film", Types.NUMERIC))
                .execute(new MapSqlParameterSource()
                        .addValue("p_titlu", f.getTitlu())
                        .addValue("p_descriere", f.getDescriere())
                        .addValue("p_data_lansare", f.getDataLansare() != null ? Date.valueOf(f.getDataLansare()) : null)
                        .addValue("p_durata", f.getDurata())
                        .addValue("p_id_categorie", f.getIdCategorie()));
        return ((Number) out.get("p_id_film")).longValue();
    }

    public void updateFilm(Film f) {
        new SimpleJdbcCall(jdbc)
                .withCatalogName("PKG_FILME").withProcedureName("UPDATE_FILM")
                .withoutProcedureColumnMetaDataAccess()
                .declareParameters(
                        new SqlParameter("p_id_film", Types.NUMERIC),
                        new SqlParameter("p_titlu", Types.VARCHAR),
                        new SqlParameter("p_descriere", Types.VARCHAR),
                        new SqlParameter("p_data_lansare", Types.DATE),
                        new SqlParameter("p_durata", Types.NUMERIC),
                        new SqlParameter("p_id_categorie", Types.NUMERIC))
                .execute(new MapSqlParameterSource()
                        .addValue("p_id_film", f.getIdFilm())
                        .addValue("p_titlu", f.getTitlu())
                        .addValue("p_descriere", f.getDescriere())
                        .addValue("p_data_lansare", f.getDataLansare() != null ? Date.valueOf(f.getDataLansare()) : null)
                        .addValue("p_durata", f.getDurata())
                        .addValue("p_id_categorie", f.getIdCategorie()));
    }

    public void deleteFilm(Long id) {
        new SimpleJdbcCall(jdbc)
                .withCatalogName("PKG_FILME").withProcedureName("DELETE_FILM")
                .withoutProcedureColumnMetaDataAccess()
                .declareParameters(new SqlParameter("p_id_film", Types.NUMERIC))
                .execute(new MapSqlParameterSource().addValue("p_id_film", id));
    }

    @SuppressWarnings("unchecked")
    public List<Versiune> getVersioniFilm(Long idFilm) {
        Map<String, Object> out = new SimpleJdbcCall(jdbc)
                .withCatalogName("PKG_FILME").withProcedureName("GET_VERSIUNI_FILM")
                .withoutProcedureColumnMetaDataAccess()
                .declareParameters(
                        new SqlParameter("p_id_film", Types.NUMERIC),
                        new SqlOutParameter("p_cursor", OracleTypes.CURSOR, versiuneMapper()))
                .execute(new MapSqlParameterSource().addValue("p_id_film", idFilm));
        return (List<Versiune>) out.get("p_cursor");
    }

    @SuppressWarnings("unchecked")
    public List<Categorie> getAllCategorii() {
        Map<String, Object> out = new SimpleJdbcCall(jdbc)
                .withCatalogName("PKG_FILME").withProcedureName("GET_ALL_CATEGORII")
                .withoutProcedureColumnMetaDataAccess()
                .declareParameters(new SqlOutParameter("p_cursor", OracleTypes.CURSOR, categorieMapper()))
                .execute(new MapSqlParameterSource());
        return (List<Categorie>) out.get("p_cursor");
    }

    // ================================================================
    // ACTORI
    // ================================================================

    @SuppressWarnings("unchecked")
    public List<Actor> getAllActori() {
        Map<String, Object> out = new SimpleJdbcCall(jdbc)
                .withCatalogName("PKG_ACTORI").withProcedureName("GET_ALL_ACTORI")
                .withoutProcedureColumnMetaDataAccess()
                .declareParameters(new SqlOutParameter("p_cursor", OracleTypes.CURSOR, actorMapper()))
                .execute(new MapSqlParameterSource());
        return (List<Actor>) out.get("p_cursor");
    }

    @SuppressWarnings("unchecked")
    public Actor getActorById(Long id) {
        Map<String, Object> out = new SimpleJdbcCall(jdbc)
                .withCatalogName("PKG_ACTORI").withProcedureName("GET_ACTOR_BY_ID")
                .withoutProcedureColumnMetaDataAccess()
                .declareParameters(
                        new SqlParameter("p_id_actor", Types.NUMERIC),
                        new SqlOutParameter("p_cursor", OracleTypes.CURSOR, actorMapper()))
                .execute(new MapSqlParameterSource().addValue("p_id_actor", id));
        List<Actor> list = (List<Actor>) out.get("p_cursor");
        return list != null && !list.isEmpty() ? list.get(0) : null;
    }

    public Long insertActor(Actor a) {
        Map<String, Object> out = new SimpleJdbcCall(jdbc)
                .withCatalogName("PKG_ACTORI").withProcedureName("INSERT_ACTOR")
                .withoutProcedureColumnMetaDataAccess()
                .declareParameters(
                        new SqlParameter("p_prenume", Types.VARCHAR),
                        new SqlParameter("p_nume_familie", Types.VARCHAR),
                        new SqlParameter("p_nume_scena", Types.VARCHAR),
                        new SqlParameter("p_data_nastere", Types.DATE),
                        new SqlParameter("p_nationalitate", Types.VARCHAR),
                        new SqlOutParameter("p_id_actor", Types.NUMERIC))
                .execute(new MapSqlParameterSource()
                        .addValue("p_prenume", a.getPrenume())
                        .addValue("p_nume_familie", a.getNumeFamilie())
                        .addValue("p_nume_scena", a.getNumeScena())
                        .addValue("p_data_nastere", a.getDataNastere() != null ? Date.valueOf(a.getDataNastere()) : null)
                        .addValue("p_nationalitate", a.getNationalitate()));
        return ((Number) out.get("p_id_actor")).longValue();
    }

    public void updateActor(Actor a) {
        new SimpleJdbcCall(jdbc)
                .withCatalogName("PKG_ACTORI").withProcedureName("UPDATE_ACTOR")
                .withoutProcedureColumnMetaDataAccess()
                .declareParameters(
                        new SqlParameter("p_id_actor", Types.NUMERIC),
                        new SqlParameter("p_prenume", Types.VARCHAR),
                        new SqlParameter("p_nume_familie", Types.VARCHAR),
                        new SqlParameter("p_nume_scena", Types.VARCHAR),
                        new SqlParameter("p_data_nastere", Types.DATE),
                        new SqlParameter("p_nationalitate", Types.VARCHAR))
                .execute(new MapSqlParameterSource()
                        .addValue("p_id_actor", a.getIdActor())
                        .addValue("p_prenume", a.getPrenume())
                        .addValue("p_nume_familie", a.getNumeFamilie())
                        .addValue("p_nume_scena", a.getNumeScena())
                        .addValue("p_data_nastere", a.getDataNastere() != null ? Date.valueOf(a.getDataNastere()) : null)
                        .addValue("p_nationalitate", a.getNationalitate()));
    }

    public void deleteActor(Long id) {
        new SimpleJdbcCall(jdbc)
                .withCatalogName("PKG_ACTORI").withProcedureName("DELETE_ACTOR")
                .withoutProcedureColumnMetaDataAccess()
                .declareParameters(new SqlParameter("p_id_actor", Types.NUMERIC))
                .execute(new MapSqlParameterSource().addValue("p_id_actor", id));
    }

    @SuppressWarnings("unchecked")
    public List<Film> getFilmeActor(Long idActor) {
        Map<String, Object> out = new SimpleJdbcCall(jdbc)
                .withCatalogName("PKG_ACTORI").withProcedureName("GET_FILME_ACTOR")
                .withoutProcedureColumnMetaDataAccess()
                .declareParameters(
                        new SqlParameter("p_id_actor", Types.NUMERIC),
                        new SqlOutParameter("p_cursor", OracleTypes.CURSOR, (rs, i) -> {
                            Film film = new Film();
                            film.setIdFilm(rs.getLong("ID_FILM"));
                            film.setTitlu(rs.getString("TITLU"));
                            film.setRating(rs.getDouble("RATING"));
                            Date d = rs.getDate("DATA_LANSARE");
                            film.setDataLansare(d != null ? d.toLocalDate() : null);
                            film.setCategorie(rs.getString("CATEGORIE"));
                            return film;
                        }))
                .execute(new MapSqlParameterSource().addValue("p_id_actor", idActor));
        return (List<Film>) out.get("p_cursor");
    }

    // ================================================================
    // CLIENTI
    // ================================================================

    @SuppressWarnings("unchecked")
    public List<Client> getAllClienti() {
        Map<String, Object> out = new SimpleJdbcCall(jdbc)
                .withCatalogName("PKG_CLIENTI").withProcedureName("GET_ALL_CLIENTI")
                .withoutProcedureColumnMetaDataAccess()
                .declareParameters(new SqlOutParameter("p_cursor", OracleTypes.CURSOR, clientMapper()))
                .execute(new MapSqlParameterSource());
        return (List<Client>) out.get("p_cursor");
    }

    @SuppressWarnings("unchecked")
    public Client getClientById(Long id) {
        Map<String, Object> out = new SimpleJdbcCall(jdbc)
                .withCatalogName("PKG_CLIENTI").withProcedureName("GET_CLIENT_BY_ID")
                .withoutProcedureColumnMetaDataAccess()
                .declareParameters(
                        new SqlParameter("p_id_client", Types.NUMERIC),
                        new SqlOutParameter("p_cursor", OracleTypes.CURSOR, clientMapper()))
                .execute(new MapSqlParameterSource().addValue("p_id_client", id));
        List<Client> list = (List<Client>) out.get("p_cursor");
        return list != null && !list.isEmpty() ? list.get(0) : null;
    }

    public Long insertClient(Client c) {
        Map<String, Object> out = new SimpleJdbcCall(jdbc)
                .withCatalogName("PKG_CLIENTI").withProcedureName("INSERT_CLIENT")
                .withoutProcedureColumnMetaDataAccess()
                .declareParameters(
                        new SqlParameter("p_prenume", Types.VARCHAR),
                        new SqlParameter("p_nume", Types.VARCHAR),
                        new SqlParameter("p_telefon_acasa", Types.VARCHAR),
                        new SqlParameter("p_adresa", Types.VARCHAR),
                        new SqlParameter("p_oras", Types.VARCHAR),
                        new SqlParameter("p_email", Types.VARCHAR),
                        new SqlParameter("p_telefon_mobil", Types.VARCHAR),
                        new SqlOutParameter("p_id_client", Types.NUMERIC))
                .execute(new MapSqlParameterSource()
                        .addValue("p_prenume", c.getPrenume())
                        .addValue("p_nume", c.getNume())
                        .addValue("p_telefon_acasa", c.getTelefonAcasa())
                        .addValue("p_adresa", c.getAdresa())
                        .addValue("p_oras", c.getOras())
                        .addValue("p_email", c.getEmail())
                        .addValue("p_telefon_mobil", c.getTelefonMobil()));
        return ((Number) out.get("p_id_client")).longValue();
    }

    public void updateClient(Client c) {
        new SimpleJdbcCall(jdbc)
                .withCatalogName("PKG_CLIENTI").withProcedureName("UPDATE_CLIENT")
                .withoutProcedureColumnMetaDataAccess()
                .declareParameters(
                        new SqlParameter("p_id_client", Types.NUMERIC),
                        new SqlParameter("p_prenume", Types.VARCHAR),
                        new SqlParameter("p_nume", Types.VARCHAR),
                        new SqlParameter("p_telefon_acasa", Types.VARCHAR),
                        new SqlParameter("p_adresa", Types.VARCHAR),
                        new SqlParameter("p_oras", Types.VARCHAR),
                        new SqlParameter("p_email", Types.VARCHAR),
                        new SqlParameter("p_telefon_mobil", Types.VARCHAR))
                .execute(new MapSqlParameterSource()
                        .addValue("p_id_client", c.getIdClient())
                        .addValue("p_prenume", c.getPrenume())
                        .addValue("p_nume", c.getNume())
                        .addValue("p_telefon_acasa", c.getTelefonAcasa())
                        .addValue("p_adresa", c.getAdresa())
                        .addValue("p_oras", c.getOras())
                        .addValue("p_email", c.getEmail())
                        .addValue("p_telefon_mobil", c.getTelefonMobil()));
    }

    public void deleteClient(Long id) {
        new SimpleJdbcCall(jdbc)
                .withCatalogName("PKG_CLIENTI").withProcedureName("DELETE_CLIENT")
                .withoutProcedureColumnMetaDataAccess()
                .declareParameters(new SqlParameter("p_id_client", Types.NUMERIC))
                .execute(new MapSqlParameterSource().addValue("p_id_client", id));
    }

    // ================================================================
    // ROW MAPPERS
    // ================================================================

    private RowMapper<Film> filmMapper() {
        return (rs, i) -> {
            Film f = new Film();
            f.setIdFilm(rs.getLong("ID_FILM"));
            f.setTitlu(rs.getString("TITLU"));
            f.setDescriere(rs.getString("DESCRIERE"));
            Date d = rs.getDate("DATA_LANSARE");
            f.setDataLansare(d != null ? d.toLocalDate() : null);
            f.setDurata(rs.getInt("DURATA"));
            f.setRating(rs.getDouble("RATING"));
            f.setIdCategorie(rs.getLong("ID_CATEGORIE"));
            f.setCategorie(rs.getString("CATEGORIE"));
            return f;
        };
    }

    private RowMapper<Actor> actorMapper() {
        return (rs, i) -> {
            Actor a = new Actor();
            a.setIdActor(rs.getLong("ID_ACTOR"));
            a.setPrenume(rs.getString("PRENUME"));
            a.setNumeFamilie(rs.getString("NUME_FAMILIE"));
            a.setNumeScena(rs.getString("NUME_SCENA"));
            Date d = rs.getDate("DATA_NASTERE");
            a.setDataNastere(d != null ? d.toLocalDate() : null);
            a.setNationalitate(rs.getString("NATIONALITATE"));
            try { a.setNrFilme(rs.getInt("NR_FILME")); } catch (Exception ignored) {}
            return a;
        };
    }

    private RowMapper<Client> clientMapper() {
        return (rs, i) -> {
            Client c = new Client();
            c.setIdClient(rs.getLong("ID_CLIENT"));
            c.setPrenume(rs.getString("PRENUME"));
            c.setNume(rs.getString("NUME"));
            c.setTelefonAcasa(rs.getString("TELEFON_ACASA"));
            c.setAdresa(rs.getString("ADRESA"));
            c.setOras(rs.getString("ORAS"));
            c.setEmail(rs.getString("EMAIL"));
            c.setTelefonMobil(rs.getString("TELEFON_MOBIL"));
            Date d = rs.getDate("DATA_INREGISTRARE");
            c.setDataInregistrare(d != null ? d.toLocalDate() : null);
            return c;
        };
    }

    private RowMapper<Categorie> categorieMapper() {
        return (rs, i) -> {
            Categorie c = new Categorie();
            c.setIdCategorie(rs.getLong("ID_CATEGORIE"));
            c.setNume(rs.getString("NUME"));
            c.setDescriere(rs.getString("DESCRIERE"));
            return c;
        };
    }

    private RowMapper<Versiune> versiuneMapper() {
        return (rs, i) -> {
            Versiune v = new Versiune();
            v.setIdVersiune(rs.getLong("ID_VERSIUNE"));
            v.setIdFilm(rs.getLong("ID_FILM"));
            v.setFormat(rs.getString("FORMAT"));
            v.setRezolutie(rs.getString("REZOLUTIE"));
            v.setLimba(rs.getString("LIMBA"));
            v.setSubtitrare(rs.getString("SUBTITRARE"));
            v.setActiv(rs.getInt("ACTIV") == 1);
            return v;
        };
    }
}