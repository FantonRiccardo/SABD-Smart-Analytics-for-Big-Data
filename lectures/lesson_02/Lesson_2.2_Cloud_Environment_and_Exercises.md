# Lesson 2.2: Setting a Cloud Environment for Data Driven Industry 4.0

> **Corso**: Smart Analytics for Big Data (SABD / 5GUC3500) — Grenoble INP / UGA  
> **Docenti**: Dra. Genoveva Vargas Solar (CNRS, LIRIS), Salvador Paredes  
> **Piattaforma**: [Caseine Moodle – Section 9 (Lesson 2.2)](https://moodle.caseine.org/course/view.php?id=644&section=9)  
> **Repository Codice / Esercizi**: [GitHub javieraespinosa/ense3](https://github.com/javieraespinosa/ense3)  

---

## 1. Quadro Concettuale & Risorse Didattiche

La lezione 2.2 approfondisce la transizione dai sistemi analitici *in-house* alle infrastrutture cloud scalabili per l'Industria 4.0, dove i modelli e i flussi di dati guidano i processi decisionali.

### Risorse Didattiche e Riferimenti Teorici
* **Presentazione Introduttiva**: [From in-house to large scale data driven Industry 4.0](https://moodle.caseine.org/mod/url/view.php?id=83349)
  * Modello dati e calcolo distribuito per rispondere a quesiti analitici complessi.
  * Repository GitHub associato: [`javieraespinosa/ense3`](https://github.com/javieraespinosa/ense3) (dataset `adult.data`, capitoli `ch02` con `educ_figdp_1_Data.csv`, `ch03`, `ch04`, `ch06`–`ch08`).
* **Ambienti di Esecuzione Cloud**: [Designing and enacting data science experiments on the Cloud](https://moodle.caseine.org/mod/url/view.php?id=83528)
  * Esecuzione di esperimenti su **Kaggle** e **Google Colab**.
* **Algebra Relazionale & Basi Dati**: [Relational Algebra Chapter](https://moodle.caseine.org/mod/url/view.php?id=83578)
  * Jeffrey D. Ullman, Jennifer Widom, *A First Course In Database Systems (2022)*.
* **Semantica degli Operatori di Join**: [JOIN Families memento](https://moodle.caseine.org/mod/url/view.php?id=83576)
  * Inner join, Left/Right outer join, Full outer join, Cross join, Semi-join e Anti-join.

---

## 2. Dettaglio Esercitazioni & Deliverable

> [!IMPORTANT]
> **UNICO DELIVERABLE OBBLIGATORIO DA CONSEGNARE:**  
> L'unico esercizio con consegna formale per questo modulo è l'**Exercise 2 (Smell Cartography)**, da caricare in formato **PDF** su Caseine entro **Venerdì 16 Ottobre 2026 (fine giornata)**.  
> Gli altri assignment (A1, Ex 3, Ex 4) sono tutorial ed esercitazioni pratiche di laboratorio / Kaggle per consolidamento metodologico in aula.

### Exercise 2 (Assignment 2.2) — Data Collection Campaign: Smell Cartography (CONSEGNA FORMALE)
* **Link Caseine**: [Assignment ID 83530](https://moodle.caseine.org/mod/assign/view.php?id=83530)
* **Specifica Completa**: [vargas-solar.com / Smell Cartography Campaign](http://vargas-solar.com/data-centric-smart-everything/data-collection-campaign-building-a-smell-cartography/)
* **Scadenza Ufficiale**: **Venerdì 16 Ottobre 2026, entro fine giornata** (end of the day / 23:55–23:59)
* **Organizzazione**: Gruppi fino a 5 studenti (o lavoro individuale).
* **Perimetro Territoriale**: Grenoble, Saint-Martin-d'Hères ed Échirolles.
* **Obiettivo**: Progettare una campagna di raccolta dati per mappare l'identità olfattiva urbana (sensory urbanism ex paper *smell_22.pdf*) caratterizzando le sorgenti informative secondo il modello delle **5V dei Big Data** (Volume, Velocity, Variety, Veracity, Value).
* **Deliverable Richiesto**: Documento **PDF** da caricare su Caseine contenente:
  1. Titolo dell'esercitazione e **nomi completi di tutti i membri del gruppo**.
  2. **Tabella a 4 colonne**:
     - *Colonna 1*: Tipologia di dati da raccogliere (es. segnalazioni cittadine georeferenziate, sensori IoT aria/VOC, dati meteo/vento, POI ristorazione/industria, post social geotaggati).
     - *Colonna 2*: Proprietà Big Data associate (Volume, Velocity, Variety, Veracity, Value).
     - *Colonna 3*: Contributo alla costruzione dell'identità olfattiva (strada, quartiere, città).
     - *Colonna 4*: Strategia di raccolta (campagne crowd-sourcing, sensori fissi/mobili, scraping, open data metropolitani).
  3. **Discussione critica** (in linguaggio naturale) su come integrare i dati nella cartografia (ammesse figure e mappe).
  4. Rispetto dei criteri DEI (linguaggio neutro, inclusivo e privo di bias).

### Exercise 3 (Assignment 2.3): Dataset Quantitative Profile & Cleaning
* **Link Caseine**: [Assignment ID 83531](https://moodle.caseine.org/mod/assign/view.php?id=83531)
* **Specifica Completa**: [vargas-solar.com / HO-1 Bis Tables Manipulation](http://vargas-solar.com/data-centric-smart-everything/ho-1-bis-exploring-datasets-getting-acquainted-with-tables-manipulation/)
* **Materiali**: Notebook Kaggle [HO-1](https://www.kaggle.com/code/gevargas/ho-1-data-exploration-quantitative-2024) (versione R: [HO-1 EGI Table Operations R](https://www.kaggle.com/code/gevargas/ho1-egi-table-operations-r)).
* **Dataset di Lavoro**: `educ_figdp_1_Data.csv` (spesa pubblica in istruzione dei paesi UE nel primo decennio degli anni 2000).
* **Task**:
  1. Mappa concettuale (*mind map*) degli operatori relazionali e delle corrispondenti funzioni Python `pandas`.
  2. Schema grafico della pipeline per rispondere alla domanda: *"How similar were EU countries when they invested in education throughout the first decade of the XXI century?"*.
  3. Interpretazione critica dei grafici e dei risultati finali.
* **Consegna**: Condivisione del notebook Kaggle con la docente, indicando i membri del team e il corso di studi.

### Exercise 4 (Assignment 2.4): Analysing Mobility in the City
* **Link Caseine**: [Assignment ID 83532](https://moodle.caseine.org/mod/assign/view.php?id=83532)
* **Specifica Completa / Gist**: [Gist gevargas / tabular-data-exploration-students-version.ipynb](https://gist.github.com/gevargas/fe9c512f6b268282be329aff210b0d20)
* **Documenti di Supporto su Caseine**:
  - [Mobility Data Presentation](https://moodle.caseine.org/mod/resource/view.php?id=83572)
  - [Dictionary of Variables - Mobility Data](https://moodle.caseine.org/mod/resource/view.php?id=83574)
* **Connessione con il TP Projet Mobilité**:
  - Utilizza i dati dell'indagine campionaria EMD 2010 di Grenoble presenti in locale in `02_tp_mobility/Files_OK_2026/` (`allgre_3DF.RData`, dizionario `DICO_VAR_EMD_GRE2010_v23.xlsx`).
  - Introduce l'esplorazione tabellare dei 4 livelli gerarchici: Tratta (`PB_V26`), Spostamento (`allgreD`), Individuo (`allgreI`), Famiglia (`allgreM`).

---

## 3. Mappatura Risorse Locali nel Repository SABD

Tutte le cartelle e i dati di supporto sono organizzati nel workspace locale:
* **Esercitazioni e Dataset Lezione 2**: `01_ACTIVE_PROJECTS/0 - VS POLI/02_GRENOBLE_INP_3A/2 - Smart Analytics for Big Data/lectures/lesson_02/`
  * Cartella dataset grezzi: `lectures/lesson_02/Datasets-20260929/` (`AirQuality.pdf`, `Dataset_presentation.pdf`, `EXT.csv`, `INT.csv`, `air_quality_analysis.R`).
  * Slide teoriche: `lectures/lesson_02/SABD_Data_Quality.pdf`.
* **Progetto Mobilità & GIS**: `01_ACTIVE_PROJECTS/0 - VS POLI/02_GRENOBLE_INP_3A/2 - Smart Analytics for Big Data/02_tp_mobility/Files_OK_2026/`
  * Dati R consolidati: `allgre_3DF.RData`, `allgre.PB_V26.RData`.
  * Shapefile geografici: `FOND_MAP/NewESRI.shp` (97 zone Cerema).
  * Script Rmd e milestone M1: `M1_Topic_1_2_Daily_Travel_Times.pdf`, `SABD_Project_MOBILITY_Part1_2026_V2.Rmd`.
* **Bibliografia e Compendi Metodologici**: `01_ACTIVE_PROJECTS/0 - VS POLI/02_GRENOBLE_INP_3A/2 - Smart Analytics for Big Data/references/`
  * R Reference Card for Data Mining, R Graphics Cookbook, Dalgaard R Statistics, Allison Logistic Regression.
