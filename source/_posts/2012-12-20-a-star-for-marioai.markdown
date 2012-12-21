---
layout: post
title: "A* for MarioAI"
date: 2012-12-20 13:43
comments: true
categories: Astar, MarioAI, java
---
{% img /images/MarioScreenshot.png %}  
Check out my <a href="https://github.com/jonasnick/A-star">A\* Implementation</a>. 
Your nodes can be easily added by inheriting the ASearchNode class. 
The purpose of the A\* is to handle WorldNodes in the interface of the <a href="http://www.marioai.org">Mario AI Competion</a>. 
The aim of the competition is to develop an artificial agent in the game Infinite Mario Bros who completes a level fastest.
Like in Robin Baumgartens competition <a href="https://www.youtube.com/watch?v=DlkMs4ZHHr8">submission</a> the WorldNodes are generated using a simulation and then searched with the A\*. 
Our current goal at the Chair of Cognitive Modeling Tübingen is to connect the the planning with a rudimentary brain module which is capable of learning object interactions. 
Therefore the agent will wander around to collect knowledge about his environment and then exploit it according to its motivation. OP will surely deliver.
