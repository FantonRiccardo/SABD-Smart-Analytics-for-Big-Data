library(modelr)
library(ggplot2)
library(dplyr)
gender <- sample(c("Man", "Woman"), prob = c(1 / 2, 1 / 2), size = 120, replace = TRUE) # nolint: line_length_linter.
x1 <- runif(n = 120, min = 0, max = 10)
epsi <- rnorm(n = 120, mean = 0, sd = 2)
y <- 3 + 1.3 * as.numeric(gender == "Man") + 1.5 * x1 + as.numeric(gender == "Man") * x1 * -1.8 + epsi # nolint
sim3 <- data.frame(y, x1, gender)
plot(sim3)
lm()
summary(OLS1 <- lm(data = sim3, y ~ x1 * gender))
summary(OLS2 <- lm(data = sim3, y ~ x1))
summary(OLS3 <- lm(data = sim3, y ~ x1 + gender))
summary(OLS4 <- lm(data = sim3, y ~ 1))
summary(OLS5 <- lm(data = sim3, y ~ -1 + x1))
summary(OLS6 <- lm(data = sim3, y ~ -1 + x1 + gender))

pred <- predict.lm(OLS1, sim3)
plot(sim3$x1, pred)

grid <- sim3 %>%
    data_grid(x1, gender) %>%
    gather_predictions(OLS1, OLS2, OLS3, OLS4, OLS5, OLS6)
ggplot(sim3, aes(x1, y, color = gender)) +
    geom_point() +
    geom_line(data = grid, aes(y = pred)) +
    facet_wrap(~model)

list.m <- sapply(paste0("OLS", 1:6), get)
list.R2 <- sapply(list.m, function(m) summary(m)$r.squared)
list.R2 <- data.frame(list.R2)
list.R2 %>% arrange(list.R2)

sim3 <- sim3 %>%
  add_residuals(OLS3, var = "resid_OLS3") %>%
  add_residuals(OLS1, var = "resid_OLS1")

ggplot(sim3, aes(x1, resid_OLS3, color = gender)) +
  geom_point() +
  geom_hline(yintercept = 0, linetype = "dashed") +
  geom_smooth(method = "lm", se = FALSE)

sum(residuals(OLS1)^2) # ~454  (errore quadratico dimezzato, modello vero)
sum(residuals(OLS3)^2) # ~996
sum(residuals(OLS6)^2) # ~996  (identico a OLS3 al centesimo)

ggplot(sim3, aes(x1, resid_OLS1, color = gender)) +
  geom_point() +
  geom_hline(yintercept = 0, linetype = "dashed") +
  geom_smooth(method = "lm", se = FALSE)

anova(OLS3, OLS1)

par(mfrow = c(2, 2))
plot(OLS1)
par(mfrow = c(1, 1))