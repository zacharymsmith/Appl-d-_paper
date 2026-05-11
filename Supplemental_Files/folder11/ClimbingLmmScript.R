# Climbing velocity analysis (full script)


# ---------------------------- Configuration ---------------------------------
infile <- "Figure7D_RawClimbingData.csv"   # columns: date, genotype, biological_rep, technical_rep, height
outdir <- "analysis_climb_color_out"
cutoff_velocity <- 0.2931875                # cm/s threshold for non-responders
alpha <- 0.05

# ---------------------------- Libraries -------------------------------------
library(tidyverse)
library(lme4)
library(lmerTest)
library(emmeans)
library(performance)
library(ggpubr)
library(RColorBrewer)
library(scales)

# ---------------------------- I/O setup -------------------------------------
if (!dir.exists(outdir)) dir.create(outdir, recursive = TRUE)

# ---------------------------- Load & prep -----------------------------------
raw <- readr::read_csv(infile, show_col_types = FALSE) %>%
  mutate(
    date           = as.character(date) %>% str_squish(),
    genotype       = as.character(genotype) %>% str_squish(),
    biological_rep = as.factor(biological_rep),
    technical_rep  = as.factor(technical_rep),
    velocity_cm_s  = as.numeric(height) / 4
  ) %>%
  drop_na(date, genotype, velocity_cm_s)
raw <- raw %>% mutate(genotype = factor(genotype, levels = unique(genotype)))

# ---------------------------- Palette ---------------------------------------
palette <- c(
  "Appl_T2A_GAL4"          = "#8DD3C7",
  "APPLd"                  = "#FFFFB3",
  "CantonS"                = "#BEBADA",
  "w1118"                  = "#D9D9D9"
)


# ---------------------------- Non-responders --------------------------------
raw <- raw %>% mutate(non_responder = velocity_cm_s < cutoff_velocity)

nr_tbl <- raw %>%
  group_by(genotype) %>%
  summarise(
    n        = n(),
    non_resp = sum(non_responder),
    rate     = non_resp / n,
    ci_low   = prop.test(non_resp, n)$conf.int[1],
    ci_high  = prop.test(non_resp, n)$conf.int[2],
    .groups  = "drop"
  )
readr::write_csv(nr_tbl, file.path(outdir, "non_responder_rate_by_genotype.csv"))

# non-responder figure
p_nr <- ggplot(nr_tbl, aes(x = genotype, y = rate, fill = genotype)) +
  geom_col() +
  geom_errorbar(aes(ymin = ci_low, ymax = ci_high), width = 0.15) +
  scale_fill_manual(values = palette) +
  scale_y_continuous(labels = scales::percent_format(accuracy = 1)) +
  labs(x = "Genotype", y = "Non-responder rate",
       title = sprintf("Non-responders (< %.3f cm/s) with 95%% CI", cutoff_velocity)) +
  theme_minimal(base_size = 12) +
  theme(axis.text.x = element_text(angle = 20, hjust = 1), legend.position = "none")
ggsave(file.path(outdir, "plot_nonresponders_with_stats.png"), p_nr, width = 7.2, height = 4.6, dpi = 300)

# ---------------------------- Responders-only --------------------------------
responly <- raw %>% filter(!non_responder)

# ---------------------------- Mixed model -----------------------------------

model <- lmer(velocity_cm_s ~ genotype + (1 | date) + (1 | date:biological_rep) + (1 | date:biological_rep:technical_rep), data = responly)

capture.output({
  print(summary(model))
  print(anova(model))
}, file = file.path(outdir, "model_summary.txt"))

png(file.path(outdir, "model_diagnostics.png"), width = 1200, height = 800, res = 120)
suppressWarnings(performance::check_model(model))
dev.off()

# ---------------------------- EMMs & Tukey ----------------------------------
emm <- emmeans(model, ~ genotype)
emm_tbl <- as.data.frame(emm)
readr::write_csv(emm_tbl, file.path(outdir, "emm_by_genotype.csv"))

pairs_all <- pairs(emm, adjust = "tukey") %>% as.data.frame()

# Add star labels (for CSV use; NOT drawn on the clean plot)
add_stars <- function(p) dplyr::case_when(
  p < 0.001 ~ "***",
  p < 0.01  ~ "**",
  p < 0.05  ~ "*",
  TRUE      ~ "ns"
)
pairs_all <- pairs_all %>%
  mutate(sig = add_stars(p.value), p_adj_method = "Tukey")
readr::write_csv(pairs_all, file.path(outdir, "pairwise_tukey_all_with_stars.csv"))

# For the annotated plot we’ll keep your previous “sig-only” subset
pairs_sig <- pairs_all %>% filter(p.value < alpha)
readr::write_csv(pairs_sig, file.path(outdir, "pairwise_tukey_sigOnly.csv"))

# ---------------------------- Raw distribution plots ------------------------
p_raw_resp <- ggplot(responly, aes(x = genotype, y = velocity_cm_s, fill = genotype, colour = genotype)) +
  geom_violin(trim = FALSE, alpha = 0.6) +
  geom_boxplot(width = 0.18, outlier.shape = NA, alpha = 0.5) +
  geom_jitter(width = 0.12, size = 0.9, alpha = 0.8) +
  stat_summary(fun = mean, geom = "point", size = 3, colour = "black") +
  scale_fill_manual(values = palette) +
  scale_colour_manual(values = palette) +
  labs(x = "Genotype", y = "Velocity (cm/s)", title = "Climbing velocity by genotype (responders only)") +
  theme_minimal(base_size = 12) +
  theme(axis.text.x = element_text(angle = 20, hjust = 1), legend.position = "none")
ggsave(file.path(outdir, "plot_raw_distributions_RESPONLY_coloured.png"), p_raw_resp, width = 7.2, height = 5.0, dpi = 300)

p_raw_all <- ggplot(raw, aes(x = genotype, y = velocity_cm_s, fill = genotype, colour = genotype)) +
  geom_violin(trim = FALSE, alpha = 0.6) +
  geom_boxplot(width = 0.18, outlier.shape = NA, alpha = 0.5) +
  geom_jitter(width = 0.12, size = 0.9, alpha = 0.8) +
  stat_summary(fun = mean, geom = "point", size = 3, colour = "black") +
  scale_fill_manual(values = palette) +
  scale_colour_manual(values = palette) +
  labs(x = "Genotype", y = "Velocity (cm/s)", title = "Climbing velocity by genotype (all data)") +
  theme_minimal(base_size = 12) +
  theme(axis.text.x = element_text(angle = 20, hjust = 1), legend.position = "none")
ggsave(file.path(outdir, "plot_raw_distributions_ALL_coloured.png"), p_raw_all, width = 7.2, height = 5.0, dpi = 300)

# ====================== SECTION A: WITH SIG BARS =============================
x_levels <- emm_tbl$genotype
p_emm_with <- ggplot(emm_tbl, aes(x = factor(genotype, levels = x_levels),
                                  y = emmean, ymin = lower.CL, ymax = upper.CL,
                                  colour = genotype)) +
  geom_point(size = 3) +
  geom_errorbar(width = 0.12) +
  scale_colour_manual(values = palette) +
  labs(x = "Genotype", y = "Model-estimated mean velocity (cm/s)",
       title = sprintf("Estimated marginal means ±95%% CI (Tukey, showing p<%.2f)", alpha)) +
  theme_minimal(base_size = 12) +
  theme(axis.text.x = element_text(angle = 20, hjust = 1), legend.position = "none")

if (nrow(pairs_sig) > 0) {
  pairs_sig_plot <- pairs_sig %>%
    separate(contrast, into = c("group1","group2"), sep = " - ", remove = FALSE) %>%
    mutate(
      xmin = match(group1, x_levels),
      xmax = match(group2, x_levels),
      y.position = max(emm_tbl$upper.CL, na.rm = TRUE) + 0.08 * (1:n()),
      label = sig   # "***", "**", "*"
    )
  p_emm_with <- p_emm_with +
    ggpubr::stat_pvalue_manual(
      pairs_sig_plot,
      xmin = "xmin", xmax = "xmax", y.position = "y.position",
      label = "label", tip.length = 0.01, size = 5
    )
}
ggsave(file.path(outdir, "plot_emm_WITH_SIGBARS_RESPONLY_coloured.png"),
       p_emm_with, width = 8.0, height = 5.6, dpi = 300)

# ====================== SECTION B: WITHOUT SIG BARS ==========================
p_emm_clean <- ggplot(emm_tbl, aes(x = factor(genotype, levels = x_levels),
                                   y = emmean, ymin = lower.CL, ymax = upper.CL,
                                   colour = genotype)) +
  geom_point(size = 3) +
  geom_errorbar(width = 0.12) +
  scale_colour_manual(values = palette) +
  labs(x = "Genotype", y = "Model-estimated mean velocity (cm/s)",
       title = "Estimated marginal means ±95% CI") +
  theme_minimal(base_size = 12) +
  theme(axis.text.x = element_text(angle = 20, hjust = 1), legend.position = "none")

ggsave(file.path(outdir, "plot_emm_CLEAN_RESPONLY_coloured.png"),
       p_emm_clean, width = 8.0, height = 5.6, dpi = 300)

