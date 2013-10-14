---
layout: post
title: "Influence of Reputation on Gricean Maxims"
date: 2013-10-14 01:04
comments: true
categories: [R, pragmatics]
---
As part of the course "Game Theory and Pragmatics" by [Jason Quinley](http://www.sfs.uni-tuebingen.de/~jquinley/) at the [Institute of Linguistics](http://www.sfs.uni-tuebingen.de/en/chairs.html), I wanted to explore the influence of reputation on obeying the Gricean Maxims using data from the Q&A website Stackoverflow. 

Pragmatics is a subfield in linguistics, defined as "dealing with the origins, uses, and effects of signs within the total behavior of the interpreters of signs" ([Morris, 1946][Morris1946]).
Pragmatics tries to explain why a simple sentence like "It's raining." has a lot of different interpretations, for example([Franke, 2009][Franke2009]):
<ul>
<li>The speaker advises we should take an umbrella.</li>
<li>The speaker declares the picnic cancelled.</li>
<li>The speaker is sick of living in amsterdam.</li>
</ul>

<!-- more -->

Herbert Grice introduced certain assumptions ([Grice, 1975][Grice1975]) that people rely on when making pragmatic inferences in normal circumstances. He formulated the *Cooperative Principle*: "Make your contribution such as its required, at the stage at which it occurs, by the accepted purpose or direction of the talk exchange in which your engaged.". Using this principle, he derived four *Maxims of Conversation*, presented as guidelines:

* Maxim of Quality: Do not say what you believe to be false. Do not say that for which you lack evidance.
* Maxim of Quantity: Make your contribution as informative as is required for the current purpose of the exchange.
* Maxim of Relation: Be relevant.
* Maxim of Manner: Avoid ambiguity. Be brief and orderly.

Grice showed that hearers can systematically interpret utterances and infer additional information that goes beyond the semantic meaning of the uttered sentence, based on the assumption that the speaker obeys the Maxims.

The data for studying the influence of reputation on the maxims stems from the question and answer website [Stackoverflow](https://stackoverflow.com) (SO).
Users of the site pose programming related ques tions which others try to answer. They are encouraged to vote on the usefulness
of a question or an answer, thereby directly affecting others reputation score.
Because SO is collaboratively edited website, reputation directly determines the
privileges of a user, ranging from voting down and editing to voting on closing
or deleting questions and answers. Thus, reputation on SO is among other thing
a measure of how much the community trusts a user.
Stackoverflow provides [monthly data dumps](http://blog.stackoverflow.com/2009/06/stack-overflow-creative-commons-data-dump/).

<div class="text-image">
<img src="/InfluenceRepGrice/analyseDataset-reputationDensityPlain.png">
<div>Figure 1</div>
</div>

In Figure 1 we see that there are a lot of users with low reputation, higher reputation
is getting more and more uncommon. The dashed line represents the mean.
This can be explained in part by the fact that users start out with a reputation score of one.
It looks like the distribution is following a power law, which is strengthened by Figure 2 showing that the distribution is
approximately log-normal, when users with reputation scores equal to one are excluded.

<div class="text-image">
<img src="/InfluenceRepGrice/analyseDataset-reputationDensityLog.png">
<div>Figure 2</div>
</div>

In the following we will measure the effect of reputation by focussing on whether a question was closed or left open.
This classification task was posted on [kaggle](http://www.kaggle.com/c/predict-closed-questions-on-stack-overflow).  

<div class="text-image">
<img src="/InfluenceRepGrice/analyseDataset-reputationBoxplot.png">
<div>Figure 3</div>
</div>

When investigating the density of reputations given the question was closed or left open
we can see that closed questions are posed mainly by users with low reputation
(Figure 3). One interpretation is that a user with low reputation belongs
to one of two different user categories, whose members have an incentive to
choosing low effort. Those are users who have low reputation because they are
not trustful and new users who discount the future immensely because they have
a single specific question.
The inverse argument, that questions posed by users with higher reputation
have a lower probability of ending up closed is strengthened
using a logistic regression model with reputation being the only predicting variable. 
This model was estimated using a dataset of 50% closed questions, whereas normally about 6% of questions end up closed.
The decision boundary is where the model estimates a 50%
probability of a closed question - it lies at a reputation of 491. 
The result is that reputation is a significant influence and this model alone has an accuracy of 59.44% on test data.

When closing a question a moderator specifies a [reason](http://stackoverflow.com/faq\#close) for doing so, namely off topic, not constructive, not a real question, or too localized.
**Interestingly, there seems to be a relation between the Gricean Maxims and the reasons for closing a question.**
Questions labeled *off topic* (not related to programming) and *too localized*
(unlikely to help future visitors) clearly violate the maxim of relevance. *Not a
real question* are those that are ambiguous, vague, incomplete, overly broad, or
rhetorical, hence the maxims of manner and quantity are both violated. 
The maxim of quality is violated by questions labeled *not constructive* because they are not supported by facts. 
Rather, it would solicit debate, since there is no true answer.

<div class="text-image">
<img src="/InfluenceRepGrice/analyseDataset-reputationMaximsDensity.png">
<div>Figure 4</div>
</div>

Figure 4 reveals that reputation influences which maxims are violated. 
Most questions that are incomplete are posed by low reputation users, while
controversial questions are posed by high reputation users.
In other words, violations of the maxim of quality are more likely from users with high reputation, 
whereas the opposite is true for the maxim of quantity and manner.
Not shown is that questions that are labeled *too localized* are in a similar reputation range like *not a real question*, 
and *off topic* questions do not differ much from open questions.

In conclusion, even though we trust high reputation people, they are not precise about truth.
This is by no means a bad thing, as long as we take this characteristic into account when interpreting their intent.

**[Code of the analysis](https://github.com/jonasnick/Gricean-Classifier)**
[Morris1946]: http://psycnet.apa.org/psycinfo/1946-02822-000
[Franke2009]: http://staff.science.uva.nl/~mfranke/Papers/Franke_PhD_thesis.pdf
[Grice1975]: http://books.google.ch/books?id=73zw8IG7mtcC&lpg=PA270&ots=b59dMg5U5W&dq=grice%20logic%20and%20conversation&lr&pg=PA270#v=onepage&q=grice%20logic%20and%20conversation&f=false
