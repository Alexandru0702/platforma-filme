package ro.platformafilme.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import ro.platformafilme.dao.AppDao;
import ro.platformafilme.dao.StatsDao;
import ro.platformafilme.model.Client;

import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/statistici")
public class StatisticiController {

    private final StatsDao statsDao;
    private final AppDao   appDao;

    public StatisticiController(StatsDao statsDao, AppDao appDao) {
        this.statsDao = statsDao;
        this.appDao   = appDao;
    }

    /**
     * Dashboard principal de statistici.
     * Incarca:
     *  - stats globale (numaratori, medii)
     *  - analiza sentiment pentru toate filmele
     *  - lista clienti (pentru dropdown recomandari)
     *  - predictii sezoniere lunare
     *  - predictii pe categorii per anotimp
     *  - recomandari (doar daca e selectat un client)
     */
    @GetMapping
    public String dashboard(
            Model model,
            @RequestParam(required = false) Long idClient) {

        // Statistici globale
        Map<String, Object> stats = statsDao.getStatisticiGlobale();
        model.addAttribute("stats", stats);

        // Analiza sentiment (toate filmele)
        List<Map<String, Object>> sentiment = statsDao.getSentimentFilme();
        model.addAttribute("sentiment", sentiment);

        // Lista clienti pentru dropdown-ul de recomandari
        List<Client> clienti = appDao.getAllClienti();
        model.addAttribute("clienti", clienti);

        // Predictii sezoniere
        List<Map<String, Object>> predictii = statsDao.getPredictiiSezoniere();
        model.addAttribute("predictii", predictii);

        // Predictii pe categorii per anotimp
        List<Map<String, Object>> categoriiSezon = statsDao.getPredictiiCategoriiSezon();
        model.addAttribute("categoriiSezon", categoriiSezon);

        // Recomandari personalizate (doar daca clientul e selectat)
        if (idClient != null) {
            List<Map<String, Object>> recomandari = statsDao.getRecomandari(idClient);
            model.addAttribute("recomandari", recomandari);
            model.addAttribute("idClientSelectat", idClient);

            // Gasim numele clientului selectat pentru afisare
            for (Client c : clienti) {
                if (c.getIdClient().equals(idClient)) {
                    model.addAttribute("numeClientSelectat", c.getNumeComplet());
                    break;
                }
            }
        }

        return "statistici/index";
    }
}