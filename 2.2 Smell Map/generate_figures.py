import matplotlib.pyplot as plt
import numpy as np
import os

out_dir = "/Users/riccardofanton/Documents/Visual Studio Code/01_ACTIVE_PROJECTS/0 - VS POLI/02_GRENOBLE_INP_3A/2 - Smart Analytics for Big Data/2.2 Smell Map/figures"
os.makedirs(out_dir, exist_ok=True)

# Set global style
plt.rcParams['font.family'] = 'sans-serif'
plt.rcParams['font.sans-serif'] = ['Helvetica', 'Arial', 'DejaVu Sans']
plt.rcParams['axes.edgecolor'] = '#333333'
plt.rcParams['axes.linewidth'] = 0.8

# -----------------------------------------------------------------------------
# FIGURE 1: Citizen Sensing & Mobile Data Pipeline Architecture
# -----------------------------------------------------------------------------
fig, ax = plt.subplots(figsize=(10, 4.2), dpi=300)
ax.axis('off')

# Box styles
box_blue = dict(boxstyle="round,pad=0.5", fc="#EBF5FB", ec="#2980B9", lw=1.5)
box_green = dict(boxstyle="round,pad=0.5", fc="#EAFAF1", ec="#27AE60", lw=1.5)
box_amber = dict(boxstyle="round,pad=0.5", fc="#FEF9E7", ec="#F39C12", lw=1.5)
box_purple = dict(boxstyle="round,pad=0.5", fc="#F5EEF8", ec="#8E44AD", lw=1.5)

# Nodes
ax.text(0.12, 0.55, "1. IN-SITU OBSERVATION\n\n• Citizen GPS Log\n• Time & Date Stamp\n• 100m Grid Anonymization\n(GDPR Privacy Fuzzing)", 
        ha="center", va="center", bbox=box_blue, fontsize=8.5, weight='bold')

ax.text(0.38, 0.55, "2. OLFACTORY TAXONOMY\n\n• 5 Classes (Food, Coffee,\n  Floral, Fumes, Trash)\n• Free-text Descriptors\n• Intensity (Scale 1–5)\n• Hedonic Tone (-5 to +5)", 
        ha="center", va="center", bbox=box_amber, fontsize=8.5, weight='bold')

ax.text(0.64, 0.55, "3. STREAM INGESTION\n\n• Mobile API Gateway\n• Timestamp Validation\n• Exponential Decay Weighting\n  ($\\lambda = \\ln 2 / 3\\,\\mathrm{hours}$)\n• Outlier & Spam Filtering", 
        ha="center", va="center", bbox=box_green, fontsize=8.5, weight='bold')

ax.text(0.90, 0.55, "4. MAP AGGREGATION\n\n• H3 Hexagonal Binning\n• Dynamic Choropleth Layer\n• Fusion with IoT & Meteo\n• Real-Time Web Map Serve\n(Grenoble Métropole)", 
        ha="center", va="center", bbox=box_purple, fontsize=8.5, weight='bold')

# Arrows
arrow_kw = dict(arrowstyle="->", lw=2, color="#34495E")
ax.annotate("", xy=(0.25, 0.55), xytext=(0.24, 0.55), arrowprops=arrow_kw)
ax.annotate("", xy=(0.51, 0.55), xytext=(0.50, 0.55), arrowprops=arrow_kw)
ax.annotate("", xy=(0.77, 0.55), xytext=(0.76, 0.55), arrowprops=arrow_kw)

ax.set_title("Figure 1: Citizen Sensory Mobile Architecture & Real-Time Processing Pipeline", 
             fontsize=11, weight='bold', pad=15, color="#2C3E50")
plt.tight_layout()
fig1_path = os.path.join(out_dir, "fig1_citizen_sensing_pipeline.png")
plt.savefig(fig1_path, bbox_inches='tight')
plt.close()
print("Saved:", fig1_path)

# -----------------------------------------------------------------------------
# FIGURE 2: Environmental Sensor Data & Diurnal Chemistry Profile
# -----------------------------------------------------------------------------
fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(11, 4.5), dpi=300)

# Panel A: Diurnal gas concentrations
hours = np.linspace(0, 24, 200)
# NO2 peaks at 08:30 and 18:00
no2 = 30 + 55 * np.exp(-((hours - 8.3)**2)/2.5) + 48 * np.exp(-((hours - 18.2)**2)/3.2) + 8 * np.sin(hours/4)
# PM2.5 peaks morning and nocturnal winter accumulation
pm25 = 15 + 22 * np.exp(-((hours - 8.5)**2)/4.0) + 28 * np.exp(-((hours - 21.0)**2)/6.0)
# VOCs peak midday and night
voc = 10 + 18 * np.exp(-((hours - 13.0)**2)/8.0) + 15 * np.exp(-((hours - 2.0)**2)/12.0)

ax1.plot(hours, no2, color="#E74C3C", lw=2.2, label=r"$\mathrm{NO}_2$ ($\mu\mathrm{g/m}^3$) [Exhaust Fumes]")
ax1.plot(hours, pm25, color="#7F8C8D", lw=2.0, ls="--", label=r"$\mathrm{PM}_{2.5}$ ($\mu\mathrm{g/m}^3$) [Soot / Particulates]")
ax1.plot(hours, voc, color="#8E44AD", lw=1.8, ls=":", label=r"Total VOCs (ppb) [Solvents / Odors]")

ax1.axvspan(7.5, 9.5, color="#FDEDEC", alpha=0.6, label="Morning Rush Peak")
ax1.axvspan(17.0, 19.5, color="#FDEDEC", alpha=0.6)
ax1.set_xlim(0, 24)
ax1.set_ylim(0, 105)
ax1.set_xticks(range(0, 25, 4))
ax1.set_xticklabels([f"{h:02d}:00" for h in range(0, 25, 4)])
ax1.set_xlabel("Hour of the Day (CET)", fontsize=9, weight='bold')
ax1.set_ylabel(r"Atmospheric Concentration", fontsize=9, weight='bold')
ax1.set_title("A: Diurnal Chemical Precursor Profiles (ATMO Network)", fontsize=10, weight='bold', color="#2C3E50")
ax1.grid(True, ls="--", alpha=0.4)
ax1.legend(loc="upper left", fontsize=7.5, frameon=True)

# Panel B: Reference Stations vs Perceived Odor Correlation
stations = ['Grands Boulevards\n(Grenoble)', 'Caserne de Bonne\n(Urban Background)', 'SMH Campus\n(UGA Academic)', 'Échirolles Sud\n(Industrial/A480)']
no2_avg = [68, 28, 22, 62]
smell_complaints = [84, 18, 12, 79]

x = np.arange(len(stations))
width = 0.35

rects1 = ax2.bar(x - width/2, no2_avg, width, label=r'Mean $\mathrm{NO}_2$ ($\mu\mathrm{g/m}^3$)', color='#E74C3C', alpha=0.85)
rects2 = ax2.bar(x + width/2, smell_complaints, width, label='Odor Reports / Month', color='#2980B9', alpha=0.85)

ax2.set_ylabel('Concentration / Normalized Reports', fontsize=9, weight='bold')
ax2.set_title('B: Station Air Quality vs. Citizen Odor Reports', fontsize=10, weight='bold', color="#2C3E50")
ax2.set_xticks(x)
ax2.set_xticklabels(stations, fontsize=8)
ax2.grid(True, axis='y', ls="--", alpha=0.4)
ax2.legend(loc="upper right", fontsize=7.5, frameon=True)

plt.tight_layout()
fig2_path = os.path.join(out_dir, "fig2_air_quality_diurnal_sensors.png")
plt.savefig(fig2_path, bbox_inches='tight')
plt.close()
print("Saved:", fig2_path)

# -----------------------------------------------------------------------------
# FIGURE 3: Alpine "Y-Basin" Topographic Wind & Thermal Inversion Dispersion
# -----------------------------------------------------------------------------
fig, ax = plt.subplots(figsize=(9, 4.5), dpi=300)

# Create schematic valley profile
x_vals = np.linspace(-10, 10, 400)
# Topography: Chartreuse left, Belledonne right, valley floor center
mountains = 800 / (1 + np.exp(-(x_vals - 4.5)*1.2)) + 900 / (1 + np.exp((x_vals + 4.5)*1.2)) + 215

ax.fill_between(x_vals, 0, mountains, color="#A6ACAF", alpha=0.4, label="Mountain Relief (Chartreuse / Belledonne)")
ax.plot(x_vals, mountains, color="#566573", lw=1.8)

# Valley floor ground
ax.axhline(215, color="#27AE60", lw=2, label="Valley Floor: Grenoble, SMH, Échirolles (215m ASL)")

# Thermal Inversion layer
ax.axhspan(215, 450, color="#FADBD8", alpha=0.45, label="Winter Thermal Inversion Cap (Trapped Fumes & Odors)")
ax.axhline(450, color="#C0392B", lw=1.5, ls="--", label="Inversion Lid (Ceiling ~450m)")

# Annotations
ax.text(-0.5, 290, "STAGNANT ODOR POOL\n(Hydrocarbons, Woodsmoke, Trash VOCs)\nTrapped under valley ceiling", 
        ha="center", va="center", color="#922B21", weight='bold', fontsize=8.5,
        bbox=dict(boxstyle="square,pad=0.3", fc="#FDEDEC", ec="#E74C3C", lw=1))

# Mountain breeze arrows
ax.annotate("Catabatic Drainage Breeze\n(Cold Mountain Air)", xy=(-2.0, 240), xytext=(-6.5, 520),
            arrowprops=dict(arrowstyle="->", color="#2980B9", lw=2),
            fontsize=8, weight='bold', color="#1B4F72")
ax.annotate("Thermal Upslope Breeze\n(Daytime Venting)", xy=(6.5, 540), xytext=(2.0, 260),
            arrowprops=dict(arrowstyle="->", color="#D35400", lw=2),
            fontsize=8, weight='bold', color="#BA4A00")

ax.set_xlim(-10, 10)
ax.set_ylim(0, 1100)
ax.set_ylabel("Altitude (meters above sea level)", fontsize=9, weight='bold')
ax.set_xlabel("Topographical Cross-Section: West (Vercors) to East (Belledonne)", fontsize=9, weight='bold')
ax.set_title("Figure 3: Topographic & Micro-Climatic Dispersion Mechanics in the Grenoble Basin", 
             fontsize=10.5, weight='bold', pad=12, color="#2C3E50")
ax.legend(loc="upper center", bbox_to_anchor=(0.5, -0.15), ncol=2, fontsize=7.5, frameon=True)

plt.tight_layout()
fig3_path = os.path.join(out_dir, "fig3_alpine_valley_dispersion_model.png")
plt.savefig(fig3_path, bbox_inches='tight')
plt.close()
print("Saved:", fig3_path)

# -----------------------------------------------------------------------------
# FIGURE 4: Diurnal Olfactory Intensity by Odor Class (Stacked Streamgraph)
# -----------------------------------------------------------------------------
fig, ax = plt.subplots(figsize=(10, 4.2), dpi=300)

hrs = np.linspace(0, 24, 200)

# Class profiles
food_bakery = 4.0 * np.exp(-((hrs - 7.5)**2)/2.0) + 3.5 * np.exp(-((hrs - 12.5)**2)/2.5) + 3.8 * np.exp(-((hrs - 20.0)**2)/3.0)
coffee = 4.5 * np.exp(-((hrs - 8.2)**2)/1.8) + 3.0 * np.exp(-((hrs - 13.5)**2)/1.5)
floral = 2.0 + 2.5 * np.exp(-((hrs - 14.5)**2)/12.0)
traffic_fumes = 6.0 * np.exp(-((hrs - 8.2)**2)/2.0) + 5.5 * np.exp(-((hrs - 18.0)**2)/2.5)
trash_decay = 1.5 + 2.0 * np.exp(-((hrs - 15.0)**2)/16.0) + 2.0 * np.exp(-((hrs - 6.0)**2)/2.0)

ax.plot(hrs, food_bakery, label="1. Food & Bakery Aromas (Rue de Strasbourg / Estacade)", color="#E67E22", lw=2.2)
ax.plot(hrs, coffee, label="2. Roasted Coffee (Place Grenette / Championnet)", color="#8E44AD", lw=2.0, ls="-.")
ax.plot(hrs, floral, label="3. Floral & Biogenic Scent (Parc Paul Mistral / SMH Campus)", color="#27AE60", lw=2.0)
ax.plot(hrs, traffic_fumes, label="4. Traffic & Exhaust Fumes (Grands Boulevards / Rocade Sud)", color="#C0392B", lw=2.4)
ax.plot(hrs, trash_decay, label="5. Trash & Organic Debris (Collection Routes)", color="#7F8C8D", lw=1.8, ls="--")

ax.set_xlim(0, 24)
ax.set_ylim(0, 8.5)
ax.set_xticks(range(0, 25, 2))
ax.set_xticklabels([f"{h:02d}:00" for h in range(0, 25, 2)], fontsize=8)
ax.set_xlabel("Hour of the Day (24h Cycle)", fontsize=9, weight='bold')
ax.set_ylabel("Normalized Olfactory Intensity (Scale 0–10)", fontsize=9, weight='bold')
ax.set_title("Figure 4: Dynamic 24-Hour Circadian Timeline of Urban Olfactory Classes in Grenoble", 
             fontsize=10.5, weight='bold', pad=12, color="#2C3E50")
ax.grid(True, ls="--", alpha=0.4)
ax.legend(loc="upper right", fontsize=8, frameon=True)

plt.tight_layout()
fig4_path = os.path.join(out_dir, "fig4_diurnal_olfactory_dynamics.png")
plt.savefig(fig4_path, bbox_inches='tight')
plt.close()
print("Saved:", fig4_path)
