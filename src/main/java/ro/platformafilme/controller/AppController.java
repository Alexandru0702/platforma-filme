package ro.platformafilme.controller;

import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import ro.platformafilme.dao.AppDao;
import ro.platformafilme.model.Actor;
import ro.platformafilme.model.Client;
import ro.platformafilme.model.Film;

import java.time.LocalDate;

@Controller
public class AppController {

    private final AppDao dao;

    public AppController(AppDao dao) {
        this.dao = dao;
    }

    // ================================================================
    // FILME
    // ================================================================

    @GetMapping("/filme")
    public String filmeList(Model model, @RequestParam(required = false) Long categorie) {
        model.addAttribute("filme", categorie != null ? dao.getFilmeByCategorie(categorie) : dao.getAllFilme());
        model.addAttribute("categorii", dao.getAllCategorii());
        model.addAttribute("topFilme", dao.getTopFilme(5));
        model.addAttribute("categorieSelectata", categorie);
        return "filme/lista";
    }

    @GetMapping("/filme/{id}")
    public String filmeDetalii(@PathVariable Long id, Model model) {
        Film film = dao.getFilmById(id);
        if (film == null) return "redirect:/filme";
        model.addAttribute("film", film);
        model.addAttribute("versiuni", dao.getVersioniFilm(id));
        model.addAttribute("clienti", dao.getAllClienti());   // necesar pentru formularele de interactiune
        return "filme/detalii";
    }

    @GetMapping("/filme/nou")
    public String filmeFormNou(Model model) {
        model.addAttribute("film", new Film());
        model.addAttribute("categorii", dao.getAllCategorii());
        model.addAttribute("modEdit", false);
        return "filme/form";
    }

    @PostMapping("/filme/nou")
    public String filmeAdauga(
            @RequestParam String titlu,
            @RequestParam(required = false) String descriere,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate dataLansare,
            @RequestParam(required = false) Integer durata,
            @RequestParam Long idCategorie,
            RedirectAttributes ra) {
        Film f = new Film();
        f.setTitlu(titlu); f.setDescriere(descriere);
        f.setDataLansare(dataLansare); f.setDurata(durata); f.setIdCategorie(idCategorie);
        Long id = dao.insertFilm(f);
        ra.addFlashAttribute("success", "Filmul a fost adaugat cu succes!");
        return "redirect:/filme/" + id;
    }

    @GetMapping("/filme/{id}/editeaza")
    public String filmeFormEdit(@PathVariable Long id, Model model) {
        Film film = dao.getFilmById(id);
        if (film == null) return "redirect:/filme";
        model.addAttribute("film", film);
        model.addAttribute("categorii", dao.getAllCategorii());
        model.addAttribute("modEdit", true);
        return "filme/form";
    }

    @PostMapping("/filme/{id}/editeaza")
    public String filmeEditeaza(
            @PathVariable Long id,
            @RequestParam String titlu,
            @RequestParam(required = false) String descriere,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate dataLansare,
            @RequestParam(required = false) Integer durata,
            @RequestParam Long idCategorie,
            RedirectAttributes ra) {
        Film f = new Film();
        f.setIdFilm(id); f.setTitlu(titlu); f.setDescriere(descriere);
        f.setDataLansare(dataLansare); f.setDurata(durata); f.setIdCategorie(idCategorie);
        dao.updateFilm(f);
        ra.addFlashAttribute("success", "Filmul a fost actualizat!");
        return "redirect:/filme/" + id;
    }

    @PostMapping("/filme/{id}/sterge")
    public String filmeSterge(@PathVariable Long id, RedirectAttributes ra) {
        dao.deleteFilm(id);
        ra.addFlashAttribute("success", "Filmul a fost sters!");
        return "redirect:/filme";
    }

    // ================================================================
    // INTERACTIUNE - VOT, VIZUALIZARE, COMENTARIU
    // ================================================================

    @PostMapping("/filme/{id}/vot")
    public String adaugaVot(@PathVariable Long id,
                            @RequestParam Long idClient,
                            @RequestParam int nota,
                            RedirectAttributes ra) {
        dao.addVot(idClient, id, nota);
        ra.addFlashAttribute("success", "Vot adaugat! Rating-ul filmului a fost actualizat automat.");
        return "redirect:/filme/" + id;
    }

    @PostMapping("/filme/{id}/vizualizare")
    public String adaugaVizualizare(@PathVariable Long id,
                                    @RequestParam Long idClient,
                                    @RequestParam Long idVersiune,
                                    @RequestParam(required = false) Integer durata,
                                    @RequestParam String stare,
                                    RedirectAttributes ra) {
        dao.addVizualizare(idClient, idVersiune, durata, stare);
        ra.addFlashAttribute("success", "Vizualizare inregistrata cu succes!");
        return "redirect:/filme/" + id;
    }

    @PostMapping("/filme/{id}/comentariu")
    public String adaugaComentariu(@PathVariable Long id,
                                   @RequestParam Long idClient,
                                   @RequestParam String continut,
                                   RedirectAttributes ra) {
        dao.addComentariu(idClient, id, continut);
        ra.addFlashAttribute("success", "Comentariu adaugat cu succes!");
        return "redirect:/filme/" + id;
    }

    // ================================================================
    // ACTORI
    // ================================================================

    @GetMapping("/actori")
    public String actoriList(Model model) {
        model.addAttribute("actori", dao.getAllActori());
        return "actori/lista";
    }

    @GetMapping("/actori/nou")
    public String actoriFormNou(Model model) {
        model.addAttribute("actor", new Actor());
        model.addAttribute("modEdit", false);
        return "actori/form";
    }

    @PostMapping("/actori/nou")
    public String actoriAdauga(
            @RequestParam String prenume, @RequestParam String numeFamilie,
            @RequestParam(required = false) String numeScena,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate dataNastere,
            @RequestParam(required = false) String nationalitate,
            RedirectAttributes ra) {
        Actor a = new Actor();
        a.setPrenume(prenume); a.setNumeFamilie(numeFamilie); a.setNumeScena(numeScena);
        a.setDataNastere(dataNastere); a.setNationalitate(nationalitate);
        dao.insertActor(a);
        ra.addFlashAttribute("success", "Actorul a fost adaugat!");
        return "redirect:/actori";
    }

    @GetMapping("/actori/{id}/editeaza")
    public String actoriFormEdit(@PathVariable Long id, Model model) {
        Actor actor = dao.getActorById(id);
        if (actor == null) return "redirect:/actori";
        model.addAttribute("actor", actor);
        model.addAttribute("modEdit", true);
        return "actori/form";
    }

    @PostMapping("/actori/{id}/editeaza")
    public String actoriEditeaza(
            @PathVariable Long id,
            @RequestParam String prenume, @RequestParam String numeFamilie,
            @RequestParam(required = false) String numeScena,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate dataNastere,
            @RequestParam(required = false) String nationalitate,
            RedirectAttributes ra) {
        Actor a = new Actor();
        a.setIdActor(id); a.setPrenume(prenume); a.setNumeFamilie(numeFamilie);
        a.setNumeScena(numeScena); a.setDataNastere(dataNastere); a.setNationalitate(nationalitate);
        dao.updateActor(a);
        ra.addFlashAttribute("success", "Actorul a fost actualizat!");
        return "redirect:/actori";
    }

    @PostMapping("/actori/{id}/sterge")
    public String actoriSterge(@PathVariable Long id, RedirectAttributes ra) {
        dao.deleteActor(id);
        ra.addFlashAttribute("success", "Actorul a fost sters!");
        return "redirect:/actori";
    }

    // ================================================================
    // CLIENTI
    // ================================================================

    @GetMapping("/clienti")
    public String clientiList(Model model) {
        model.addAttribute("clienti", dao.getAllClienti());
        return "clienti/lista";
    }

    @GetMapping("/clienti/nou")
    public String clientiFormNou(Model model) {
        model.addAttribute("client", new Client());
        model.addAttribute("modEdit", false);
        return "clienti/form";
    }

    @PostMapping("/clienti/nou")
    public String clientiAdauga(
            @RequestParam String prenume, @RequestParam String nume,
            @RequestParam String telefonAcasa,
            @RequestParam(required = false) String adresa,
            @RequestParam(required = false) String oras,
            @RequestParam(required = false) String email,
            @RequestParam(required = false) String telefonMobil,
            RedirectAttributes ra) {
        Client c = new Client();
        c.setPrenume(prenume); c.setNume(nume); c.setTelefonAcasa(telefonAcasa);
        c.setAdresa(adresa); c.setOras(oras);
        c.setEmail(email != null && email.isEmpty() ? null : email);
        c.setTelefonMobil(telefonMobil);
        dao.insertClient(c);
        ra.addFlashAttribute("success", "Clientul a fost inregistrat!");
        return "redirect:/clienti";
    }

    @GetMapping("/clienti/{id}/editeaza")
    public String clientiFormEdit(@PathVariable Long id, Model model) {
        Client client = dao.getClientById(id);
        if (client == null) return "redirect:/clienti";
        model.addAttribute("client", client);
        model.addAttribute("modEdit", true);
        return "clienti/form";
    }

    @PostMapping("/clienti/{id}/editeaza")
    public String clientiEditeaza(
            @PathVariable Long id,
            @RequestParam String prenume, @RequestParam String nume,
            @RequestParam String telefonAcasa,
            @RequestParam(required = false) String adresa,
            @RequestParam(required = false) String oras,
            @RequestParam(required = false) String email,
            @RequestParam(required = false) String telefonMobil,
            RedirectAttributes ra) {
        Client c = new Client();
        c.setIdClient(id); c.setPrenume(prenume); c.setNume(nume);
        c.setTelefonAcasa(telefonAcasa); c.setAdresa(adresa); c.setOras(oras);
        c.setEmail(email != null && email.isEmpty() ? null : email);
        c.setTelefonMobil(telefonMobil);
        dao.updateClient(c);
        ra.addFlashAttribute("success", "Clientul a fost actualizat!");
        return "redirect:/clienti";
    }

    @PostMapping("/clienti/{id}/sterge")
    public String clientiSterge(@PathVariable Long id, RedirectAttributes ra) {
        dao.deleteClient(id);
        ra.addFlashAttribute("success", "Clientul a fost sters!");
        return "redirect:/clienti";
    }
}