lambda <- 0.2
n <- 40
nb_simu <- 1000

means_simu <- data.frame(mean = replicate(nb_simu, mean(rexp(n, lambda))))

theoric_mean <- 1/0.2
theoric_sd <- (1/0.2)/sqrt(n)
library(ggplot2)

ggplot(means_simu, aes(x=mean)) +
  geom_histogram(aes(y=..density..), binwidth=.1, colour="gold", fill="gold2") +
  geom_line(aes(y = ..density.., colour = 'Empirical'), stat = 'density', size = 1) +
  geom_vline(aes(xintercept=mean(mean, na.rm=TRUE)),
             color="red", linetype="dashed", size=1) +
  stat_function(fun = dnorm, aes(colour = 'Theoritical'), args = c(mean=theoric_mean, sd = theoric_sd), size = 1) +
  scale_colour_manual(values=c("red", "blue"), name="Densities") +
  ylab("Density") + xlab("z") + ggtitle("Mean values distribution") +
  theme(plot.title = element_text(hjust = 0.5))

result = data.frame(mean = c(mean(means_simu$mean), theoric_mean), standard_deviatation = c(sd(means_simu$mean), theoric_sd), variance = c(sd(means_simu$mean)^2, theoric_sd^2))
colnames(result) = c("Mean", "Standard Deviation", "Variance")
row.names(result) = c("Empirical", "Theoric")
