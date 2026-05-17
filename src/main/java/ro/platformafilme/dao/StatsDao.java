package ro.platformafilme.dao;

import oracle.jdbc.OracleTypes;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.core.SqlOutParameter;
import org.springframework.jdbc.core.SqlParameter;
import org.springframework.jdbc.core.namedparam.MapSqlParameterSource;
import org.springframework.jdbc.core.simple.SimpleJdbcCall;
import org.springframework.stereotype.Repository;

import java.sql.ResultSetMetaData;
import java.sql.Types;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * DAO pentru apelarea pachetului PKG_STATISTICI.
 * Folosim un RowMapper generic (Map<String, Object>) deoarece
 * procedurile statistice returneaza structuri diferite.
 * Cheile Map-ului sunt numele coloanelor Oracle in lowercase.
 */
@Repository
public class StatsDao {

    private final JdbcTemplate jdbc;

    public StatsDao(JdbcTemplate jdbc) {
        this.jdbc = jdbc;
    }

    /**
     * Returneaza statistici globale ale platformei (un singur rand).
     * Coloane: nr_filme, nr_clienti, nr_vizualizari, nr_actori,
     *          nr_voturi, nr_comentarii, nota_medie_globala, rating_mediu_filme
     */
    @SuppressWarnings("unchecked")
    public Map<String, Object> getStatisticiGlobale() {
        Map<String, Object> out = buildCall("STATISTICI_GLOBALE")
                .declareParameters(new SqlOutParameter("p_cursor", OracleTypes.CURSOR, genericMapper()))
                .execute(new MapSqlParameterSource());
        List<Map<String, Object>> rows = (List<Map<String, Object>>) out.get("p_cursor");
        return (rows != null && !rows.isEmpty()) ? rows.get(0) : new LinkedHashMap<>();
    }

    /**
     * Returneaza analiza sentiment pentru toate filmele.
     * Coloane: id_film, titlu, rating, kar_pozitiv, kar_negativ, kar_neutru,
     *          vot_pozitiv, vot_neutru, vot_negativ, nota_medie,
     *          com_pozitiv, com_negativ, total_feedback,
     *          scor_sentiment, eticheta_sentiment
     */
    @SuppressWarnings("unchecked")
    public List<Map<String, Object>> getSentimentFilme() {
        Map<String, Object> out = buildCall("SENTIMENT_TOATE_FILMELE")
                .declareParameters(new SqlOutParameter("p_cursor", OracleTypes.CURSOR, genericMapper()))
                .execute(new MapSqlParameterSource());
        return (List<Map<String, Object>>) out.get("p_cursor");
    }

    /**
     * Returneaza recomandari de filme pentru un client dat.
     * Algoritm: top 3 categorii preferate -> filme nevizionate -> sortat dupa rating.
     * Coloane: id_film, titlu, rating, durata, data_lansare, categorie
     */
    @SuppressWarnings("unchecked")
    public List<Map<String, Object>> getRecomandari(Long idClient) {
        Map<String, Object> out = buildCall("RECOMANDARI_CLIENT")
                .declareParameters(
                        new SqlParameter("p_id_client", Types.NUMERIC),
                        new SqlOutParameter("p_cursor", OracleTypes.CURSOR, genericMapper()))
                .execute(new MapSqlParameterSource().addValue("p_id_client", idClient));
        return (List<Map<String, Object>>) out.get("p_cursor");
    }

    /**
     * Returneaza distributia vizualizarilor pe luni calendaristice.
     * Coloane: luna_nr, luna_nume, nr_vizualizari, procent
     */
    @SuppressWarnings("unchecked")
    public List<Map<String, Object>> getPredictiiSezoniere() {
        Map<String, Object> out = buildCall("PREDICTII_SEZONIERE")
                .declareParameters(new SqlOutParameter("p_cursor", OracleTypes.CURSOR, genericMapper()))
                .execute(new MapSqlParameterSource());
        return (List<Map<String, Object>>) out.get("p_cursor");
    }

    /**
     * Returneaza categoriile preferate per anotimp.
     * Coloane: sezon, categorie, nr_vizualizari
     */
    @SuppressWarnings("unchecked")
    public List<Map<String, Object>> getPredictiiCategoriiSezon() {
        Map<String, Object> out = buildCall("PREDICTII_CATEGORII_SEZON")
                .declareParameters(new SqlOutParameter("p_cursor", OracleTypes.CURSOR, genericMapper()))
                .execute(new MapSqlParameterSource());
        return (List<Map<String, Object>>) out.get("p_cursor");
    }

    // ---- Helper: construieste SimpleJdbcCall pentru PKG_STATISTICI ----

    private SimpleJdbcCall buildCall(String procedureName) {
        return new SimpleJdbcCall(jdbc)
                .withCatalogName("PKG_STATISTICI")
                .withProcedureName(procedureName)
                .withoutProcedureColumnMetaDataAccess();
    }

    // ---- RowMapper generic: returneaza fiecare rand ca Map<String, Object> ----
    // Cheile sunt numele coloanelor Oracle convertite la lowercase.
    // Valorile numerice sunt BigDecimal, cele de tip text sunt String.

    private RowMapper<Map<String, Object>> genericMapper() {
        return (rs, rowNum) -> {
            Map<String, Object> row = new LinkedHashMap<>();
            ResultSetMetaData md = rs.getMetaData();
            int cols = md.getColumnCount();
            for (int i = 1; i <= cols; i++) {
                String key = md.getColumnName(i).toLowerCase();
                Object val = rs.getObject(i);
                row.put(key, val);
            }
            return row;
        };
    }
}