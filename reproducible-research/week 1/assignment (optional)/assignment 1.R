payments <- read.csv("payments.csv")
str(payments)

# what is the relationship between mean covered charges (Average.Covered.Charges)
# and mean total payments (Average.Total.Payments) in New York?

sub.payments <- payments[grepl("NEW YORK", payments$Provider.City),]

with(sub.payments, plot(Average.Covered.Charges, Average.Total.Payments,
                        pch = 20,
                        main = expression(atop(
                          "Relationship between mean covered charges",
                          "and mean total payments in New York")),
                        xlab = "mean covered charges",
                        ylab = "mean total payments"
                        )
     )
model.lm <- lm(Average.Total.Payments ~ Average.Covered.Charges, sub.payments)
abline(model.lm, lty = 2, col = "grey")
legend("bottomright", lty = 2, col = "grey", legend = "linear regression")

# Make a plot (possibly multi-panel) that answers the question: how does the
# relationship between mean covered charges (Average.Covered.Charges) and
# mean total payments (Average.Total.Payments) vary by medical condition (DRG.Definition)
# and the state in which care was received (Provider.State)?

summary(payments$Provider.State)
summary(payments$DRG.Definition)
