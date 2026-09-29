# Smart Analytics for Big Data (SABD) — INP GI (3A)

> **Istituzione**: Grenoble INP – Génie Industriel / GAEL  
> **Docenti**: Prof. Iragaël Joly, Prof. G. Vargas, Dr. Nhung Dang  
> **Piattaforma didattica**: [Caseine Moodle – SABD (Course ID 644)](https://moodle.caseine.org/course/view.php?id=644)  
> **Volume orario totale**: 48 Ore  

---

## Panoramica dei Deliverable e Valutazioni

Il corso è strutturato su **3 pilastri di valutazione**:

1. 🏆 **Data Challenge (Competizione / Caso Industriale)**:
   - **Introduzione**: 20 Ottobre
   - **Valutazione Finale / Defense**: **8 Dicembre** (09:00 – 12:15)
2. 🚗 **TP Projet Mobilité (Progetto Applicato)**:
   - **Prima Presentazione**: **1 Dicembre** (08:30 – 11:45)
   - **Soutenance Finale (Discussione)**: **12 Gennaio** (08:00 – 13:00)
   - **Consegna Rapporto Finale**: **28 Gennaio**
3. 📝 **Examen Scritto (Prof. I. Joly)**:
   - **Data**: **15 Dicembre** (09:00 – 10:30)

---

## Calendario Completo del Semestre

| Data | Docente | Ore | Mattina 1 (08:30–10:00) | Mattina 2 (10:15–11:45) | Fine Mattina (11:45–13:00) | Homework / Milestone |
|---|---|---|---|---|---|---|
| **22 Set** | I. Joly | 3h | — | AI & Data Science Overview (09:45) | Lifecycle, AI Regulation, Sustainability, GenAI | Install Party |
| **29 Set** | I. Joly | 3h | Data Quality & Diagnosis | Data Quality & Diagnosis | — | Setup & Ripasso App 1/2 |
| **06 Ott** | G. Vargas | 4h | Data Management & Pipelines | Governance, Reproductibilité, Durabilité | **Intro - TP Mobility** | *HW Mobility: Literature review* |
| **13 Ott** | I. Joly | 4h | Algorithms Survey: Regression | Feature Selection, Dim. Reduction, Var. Importance | TP Mobility | *HW Mobility: Theoretical & conceptual model* |
| **20 Ott** | I. Joly | 4h | Algorithms Survey: Classification | **Data Challenge Introduction** | Evaluation Metrics, Cross-Validation, Confusion Matrix | *HW Data Challenge & Mobility: Data processing* |
| **27 Ott** | *TOUSSAINT* | — | *Vacanze* | *Vacanze* | *Vacanze* | — |
| **03 Nov** | G. Vargas | 3h | Workflow & Reproducibility (09:00) | Pipelines, Version Control, Literate Programming | — | *HW Data Challenge & Mobility: Data processing* |
| **10 Nov** | Joly / Dang | 4h | Problem Definition | Causal Inference Basics, DAGs | TP Mobility / TP Data Challenge | *HW Data Challenge & Mobility: Analytics & Modeling* |
| **17 Nov** | G. Vargas | 3h | Federated Learning & Privacy | **Industrial Seminar: Neovision** | — | *HW Data Challenge & Mobility: Analytics & Modeling* |
| **24 Nov** | I. Joly | 4h | TP Mobility / TP Data Challenge | **Industrial Seminar: Efimove** | Unsupervised Learning (k-means, DBSCAN) | *HW Data Challenge & Mobility: Analytics & Modeling* |
| **01 Dic** | I. Joly | 4h | **First Presentation on TP Mobility** | **First Presentation on TP Mobility** | TP Mobility / TP Data Challenge | Finalizzazione Data Challenge |
| **08 Dic** | Joly + Coll. | 3h | **DATA CHALLENGE EVALUATION (09:00)** | **DATA CHALLENGE EVALUATION (10:45–12:15)** | — | **Milestone: Defense Data Challenge** |
| **15 Dic** | I. Joly | 1.5h | **EXAMEN - I. JOLY (09:00 – 10:30)** | — | — | **Milestone: Prova Scritta** |
| **22-29 Dic**| *NOËL* | — | *Vacanze di Natale* | *Vacanze di Natale* | *Vacanze di Natale* | — |
| **05 Gen** | I. Joly | 3h | Laws and Norms Seminars (09:00) | Laws and Norms Seminars | TP Mobility (10:45 – 11:30) | Preparazione Soutenance |
| **12 Gen** | Joly + Coll. | 4.5h | **TP PROJET MOBILITÉ — SOUTENANCE (08:00 – 13:00)** | **TP PROJET MOBILITÉ — SOUTENANCE** | **Soutenance Finale** | **Milestone: Discussione Finale** |
| **19 Gen** | Non Encadré| — | TP Mobility (Lavoro Autonomo) | TP Mobility (Lavoro Autonomo) | — | Stesura Rapporto Finale |
| **28 Gen** | — | — | — | — | — | **DEADLINE: Rendu Rapport Final** |

---

## Organizzazione del Workspace

```
Smart Analytics for Big Data/
├── README.md                 ← Piano semestrale, milestone e scadenze
├── data/                     ← Dataset condivisi (Data Challenge, Mobility, Movies)
├── lectures/                 ← Slide e appunti per modulo
│   ├── 01_data_management/   ← Quality, Pipelines, Governance (G. Vargas)
│   ├── 02_algorithms/        ← Regression, Classification, Unsupervised (I. Joly)
│   ├── 03_causality/         ← Causal Inference & DAGs (Nhung Dang)
│   └── 04_seminars/          ← Neovision, Efimove, Laws & Norms
├── projects/
│   ├── 01_data_challenge/    ← Codice, dati e slide per la defense dell'8 Dicembre
│   └── 02_tp_mobility/       ← Letteratura, modelli, slide (12 Gen) e report (28 Gen)
└── notebooks/                ← Esercitazioni settimanali (App1 Movies, App2 Starwars, ecc.)
```

---

## Riferimenti Bibliografici & Manuali

- 📖 [`Peter Dalgaard – Introductory Statistics with R (2nd Ed.)`](file:///Users/riccardofanton/Documents/Visual%20Studio%20Code/01_ACTIVE_PROJECTS/0%20-%20VS%20POLI/02_GRENOBLE_INP_3A/2%20-%20Smart%20Analytics%20for%20Big%20Data/references/Peter_Dalgaard_Introductory_Statistics_with_R.md): Indice ragionato, compendio di sintassi, modelli di regressione lineare/logistica/Poisson e formule statistiche R.
- 📖 [`Yanchang Zhao – R Reference Card for Data Mining`](file:///Users/riccardofanton/Documents/Visual%20Studio%20Code/01_ACTIVE_PROJECTS/0%20-%20VS%20POLI/02_GRENOBLE_INP_3A/2%20-%20Smart%20Analytics%20for%20Big%20Data/references/Yanchang_Zhao_R_Reference_Card_Data_Mining.md): Compendio e cheat sheet sistematico per Data Mining e Machine Learning in R (regole d'associazione, alberi/random forest, reti neurali/SVM, clustering gerarchico/k-means/DBSCAN, outlier detection, serie temporali, text mining ed elaborazione parallela).
- 📖 [`Winston Chang – R Graphics Cookbook (O'Reilly)`](file:///Users/riccardofanton/Documents/Visual%20Studio%20Code/01_ACTIVE_PROJECTS/0%20-%20VS%20POLI/02_GRENOBLE_INP_3A/2%20-%20Smart%20Analytics%20for%20Big%20Data/references/Winston_Chang_R_Graphics_Cookbook.md): Manuale completo di ricette per visualizzazioni con `ggplot2` (barre, linee, ribbon di confidenza, scatter plot, modelli di regressione, istogrammi, box plot, violin plot, annotazioni matematiche, faceting, palette cromatiche, esportazione vettoriale).
- 📖 [`Paul D. Allison – Logistic Regression Using SAS: Theory and Application (2nd Ed.)`](file:///Users/riccardofanton/Documents/Visual%20Studio%20Code/01_ACTIVE_PROJECTS/0%20-%20VS%20POLI/02_GRENOBLE_INP_3A/2%20-%20Smart%20Analytics%20for%20Big%20Data/references/Paul_Allison_Logistic_Regression.md): Teoria e stima di massima verosimiglianza per esiti binari, multinomiali, ordinali, scelte discrete (McFadden conditional logit), panel/longitudinali (GEE, GLMM, fixed-effects) e conteggi (Poisson, Negative Binomial, ZIP/ZINB) con mappatura completa SAS $\leftrightarrow$ R.
- 📖 [`Paul D. Allison – Survival Analysis Using SAS: A Practical Guide (2nd Ed.)`](file:///Users/riccardofanton/Documents/Visual%20Studio%20Code/01_ACTIVE_PROJECTS/0%20-%20VS%20POLI/02_GRENOBLE_INP_3A/2%20-%20Smart%20Analytics%20for%20Big%20Data/references/Paul_Allison_Survival_Analysis.md): Analisi di durata, censoring, stimatore Kaplan-Meier, test log-rank, modelli parametrici AFT (Weibull, log-normale), modello semiparametrico di Cox e rischi competitivi con mappatura SAS $\leftrightarrow$ R.

---

## Contatti Docenti

- **Prof. Iragaël Joly**: `iragael.joly@grenoble-inp.fr` | `ijoly.research@gmail.com` (Bureau K015, Site Viallet)
- **Prof. G. Vargas**: Data Management & Privacy
- **Dr. Nhung Dang**: Causal Inference & Problem Definition


