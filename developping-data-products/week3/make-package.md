# Create a package

se mettre dans le dossier:
$ R

\> library(roxygen2)

\> roxygenize('.', roclets=c('rd', 'namespace'))

puis se mettre un dossier au dessus

$ R CMD INSTALL --no-multiarch --with-keep.source topten

maintenant dans R si on tape `library(topten)` ça marche

Pour les checks :
Au dessus du dossier

$ R CMD build topten

créer un tar.gz

Puis
$ R CMD check topten_0.1.0.tar.gz
