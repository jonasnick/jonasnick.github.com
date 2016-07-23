---
layout: post
title: "Regressionsmodelle und Parameterschätzverfahren"
date: 2013-03-15 17:26
comments: true
categories: [R, Sweave, LaTeX, regression, machine learning]
---

<img src="/images/regressionPresentation-linearFit.png" width="500">

[Eine Einführung](regression.pdf), die als Ausarbeitung für das Seminar "Maschinelles Lernen" an der Universität Tübingen entstanden ist. Die Grundlagen linearer, nichtlinearer, logistischer und Bayes Regression werden behandelt, sowie Verfahren zur Schätzung der Modellparameter aus statistischen Annahmen vorgestellt.
Anschließend wird die logistische Regression auf den Titanic Datensatz angewandt und unter anderem gezeigt, dass das Motto "Frauen und Kinder zuerst" bei der Katastrophe zutraf.

**Every plot is produced using the open source statistic software [R](http://www.r-project.org/) inside the $\LaTeX$ file (Sweave). Code is [here](https://github.com/jonasnick/regression/blob/master/ausarbeitung/ausarbeitung.Rnw).**

> Charakteristisch für überwachtes maschinelles Lernen, zu der auch die Regression gehört, ist das Beschreiben der Beziehung von Zielvariable und erklärender Variable aus vorliegenden Daten, also Realisierungen von Zufallsvariablen.  

> Das Regressionsmodell stellt $y$ durch die Summe einer Hypothese von $x$ und einem Fehlerterm $\epsilon$ dar.

> $$
y = h(x) + \epsilon
$$


[<center>**PDF weiterlesen**</center>](/papers/regression.pdf)
