
# ---- Load libraries ----
library(tidyverse)

# ---- Config ----
sleep <- read_csv("Figure7A_IndividualSleepProfiles.csv")

# ---- Color palette ----
pal <- c(
  "CantonS" = "#E69F00",
  "w1118" = "#CC79A7",
  "APPLd" = "#F0E442",
  "Appl_T2A_GAL4" = "#009E73"
)

# ---- Plotting Theme ----
sleep_theme <- theme_classic(base_size = 12) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1), legend.position = "none")


# ---- Preprocess ----
sleep <- sleep %>%
  mutate(
    time_hr = (t / 3600) %% 24,
    awake = 1 - asleep   # asleep = 0–1 fractional sleep per 15-min bin
  )

# ---- Compute Anticipation Indices ----

## Morning Anticipation Index (MAI)
mai <- sleep %>%
  group_by(uid, genotype) %>%
  summarise(
    night_awake = sum(awake[time_hr >= 12 & time_hr < 24]) * 15,
    last3h_awake = sum(awake[time_hr >= 21 & time_hr < 24]) * 15,
    MAI = last3h_awake / pmax(night_awake, 1e-9)
  )

## Evening Anticipation Index (EAI)
eai <- sleep %>%
  group_by(uid, genotype) %>%
  summarise(
    day_awake = sum(awake[time_hr >= 0 & time_hr < 12]) * 15,
    last3h_evening_awake = sum(awake[time_hr >= 9 & time_hr < 12]) * 15,
    EAI = last3h_evening_awake / pmax(day_awake, 1e-9)
  )

# ---- Compute all pairwise t-tests (BH-adjusted) ----

# Helper function
pairwise_ttests <- function(df, value_col = "MAI") {
  genotypes <- unique(df$genotype)
  combs <- combn(genotypes, 2, simplify = FALSE)
  results <- map_dfr(combs, function(gr) {
    g1 <- gr[1]; g2 <- gr[2]
    d1 <- df %>% filter(genotype == g1) %>% pull(!!sym(value_col))
    d2 <- df %>% filter(genotype == g2) %>% pull(!!sym(value_col))
    test <- t.test(d1, d2)
    tibble(
      group1 = g1,
      group2 = g2,
      p_value = test$p.value
    )
  })
  results %>%
    mutate(p_adj_BH = p.adjust(p_value, method = "BH")) %>%
    arrange(p_adj_BH)
}

# Morning and evening
mai_pvals <- pairwise_ttests(mai, "MAI")
eai_pvals <- pairwise_ttests(eai, "EAI")

# Write to CSV
write_csv(mai_pvals, "MAI_pairwise_pvalues.csv")
write_csv(eai_pvals, "EAI_pairwise_pvalues.csv")

# ---- Plotting ----
p_mai <- ggplot(mai, aes(genotype, MAI, fill = genotype)) +
  geom_violin(trim = FALSE, color = "black", alpha = 0.15) +
  geom_boxplot(width = 0.12, outlier.shape = NA, color = "white", alpha = 0.9) +
  geom_jitter(width = 0.1, size = 1.2, alpha = 0.7) +
  scale_fill_manual(values = pal, guide = "none") +
  labs(y = "Morning Anticipation Index (MAI)", x = NULL) +
  sleep_theme

p_eai <- ggplot(eai, aes(genotype, EAI, fill = genotype)) +
  geom_violin(trim = FALSE, color = "black", alpha = 0.15) +
  geom_boxplot(width = 0.12, outlier.shape = NA, color = "white", alpha = 0.9) +
  geom_jitter(width = 0.1, size = 1.2, alpha = 0.7) +
  scale_fill_manual(values = pal, guide = "none") +
  labs(y = "Evening Anticipation Index (EAI)", x = NULL) +
  sleep_theme

# ---- Save ----
ggsave("MAI_violin_clean.png", p_mai, width = 5, height = 5, dpi = 600)
ggsave("EAI_violin_clean.png", p_eai, width = 5, height = 5, dpi = 600)


