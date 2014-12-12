---
layout: post
title: "FCW Kernel"
date: 2014-12-12 01:50
comments: true
categories: [machine learning, python]
---
A Feature Coinciding Walk Kernel classifies nodes in a graph.

This project is a python port of [Coinciding Walk Kernels](https://github.com/rmgarnett/coinciding_walk_kernel) (CWK) [1] and introduces an extension of the model called Feature-CWK (FCWK). If you want to jump right into some code see the [benchmark](https://nbviewer.ipython.org/github/jonasnick/FCW-Kernel/blob/master/benchmark.ipynb).

CW-Kernels deal with the problem of node classification (aka link-based classification) in which a set of features and labels for items are given just as in regular classification. In addition, a node classification algorithm accepts a graph of of items and item-item links. It has been shown that the additional information that is inherent in the network structure improves performance for certain algorithms and datasets.

[<center>**Read More**</center>](https://github.com/jonasnick/FCW-Kernel)
