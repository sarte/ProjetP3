ProjetP3
========

LFSAB1503-groupe 1246



Afin que toutes les parties du rapport que nous rédigons séparément soient un peu homogènes, voici quelques petites "règles" (entre guillemets) à suivre au niveau syntaxe :

Ne pas utiliser de :
- \bigbreak ;
- \\ ;
- etc.
Pour passer un espace.

**Insèrer un nombre**
Pour insèrer un nombre *seul* (sans unité) : utiliser
```
\numprint{42}
```

**Insèrer une grandeur**
Pour insèrer une grandeur physique avec unité : utiliser
```
\unit{42}{\meter\per\second}
```
Documentation : ftp://ftp.tex.ac.uk/ctan%3A/macros/latex/exptl/siunitx/siunitx.pdf

**Insèrer une figure**
Utiliser :

```
\begin{figure}[ht!]
 \centering
 \includegraphics[scale=0.6]{figure.png}
 \caption{Schéma}
 \label{scheme}
\end{figure}
```

**Formules mathématiques**
En ligne (dans une phrase) :
```
$x=42$
```
En bloc (saut à la ligne automatique et centré) :
```
$$x=42$$
```
Pour faire des parenthèses, crochets ou accolades dans des formules:
```
\left( \right) \left[ \right] \left{ \right}
```

**Pour faire un graphique**
PGFPlots : http://pgfplots.sourceforge.net/pgfplots.pdf

**Pour faire un circuit**
Circuitikz : http://ctan.math.washington.edu/tex-archive/graphics/pgf/contrib/circuitikz/circuitikzmanual.pdf

**Pour les noms propres placés au milieu d'un texte**

```
\textsc{Laplace}
```
**Citer ses sources**
dans le texte:
```
\cite{ xxx }
```
ensuite, aller dans sources.bib, et compléter, selon le type de source (web, livre, ...). Attention, le xxx doit correspondre avec la référence http://fr.wikibooks.org/wiki/LaTeX/Gestion_de_la_bibliographie
