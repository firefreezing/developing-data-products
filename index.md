---
title       : Measure Machine Learning Classifier Performance
subtitle    : is "accuracy" THE criterion to evaluate agreement? 
author      : firefreezing
job         : data miner
framework   : io2012        # {io2012, html5slides, shower, dzslides, ...}
highlighter : highlight.js  # {highlight.js, prettify, highlight}
hitheme     : tomorrow      # 
widgets     : [mathjax]            # {mathjax, quiz, bootstrap}
mode        : selfcontained # {standalone, draft}
knit        : slidify::knit2slides
---

<!-- Limit image width and height -->
<style type='text/css'>
img {
    max-height: 560px;
    max-width: 964px;
}
</style>

<!-- Center image on slide -->
<script src="http://ajax.aspnetcdn.com/ajax/jQuery/jquery-1.7.min.js"></script>
<script type='text/javascript'>
$(function() {
    $("p:has(img)").addClass('centered');
});
</script>

## Classifier and Confusion Matrix

In a standard machine learning setting, the result of a classification algorithm (or classifier) can be presented by a confusion matrix: 

<div style='text-align: center;'>
    <img height='300' src='./figure./confMat.png' />
</div>

- One way to evaluate classifier performance is by **accuracy**

- Accuracy = (TP + TN)/population

- Question: is accuracy always a good indicator of agreement between the classifier and the truth?


--- .class #id 

## Example: Outcome with High Accuracy

Confusion matrix of a classifier X on 10,000 test data:

<div style='text-align: center;'>
    <img height='150' src='./figure./confMatExample.png' />
</div>

Classifier X has a high "accuracy":

```r
(100 + 9025)/10000
```

```
## [1] 0.9125
```

But does this classifier really perform such fantastic?

- the data has a very rare positive cases (5%), which are likely what we'd like to correctly identify
- for these rare postive cases, the classifier only has a 20% success rate! 

--- &twocol

## Alternative Measurement: Kappa Statistic

Kappa statistic is an alternative measurement to report concordance and it accounts for the situation that the classifer agrees with the truth just by chance. 

*** =left

- Kappa statistic can be viewed as a corrected version of accuracy
- Kappa lies on a -1 to 1 scale, where 1 is perfect agreement, 0 is exactly what would be expect by chance and -1 indicates perfect disagreement. 
- Math formulation:

$\text{P}_{\text{obs}} = \frac{\text{TP + TN}}{\text{population}}$ 

$\text{P}_{\text{exp}} = \frac{\text{TP + FN}}{\text{Population}} * \frac{\text{TP + FP}}{\text{Population}} + \frac{\text{FN + TN}}{\text{Population}} * \frac{\text{FP + TN}}{\text{Population}}$

$\kappa = \frac{\text{P}_{\text{obs}} - \text{P}_{\text{exp}}}{1 - \text{P}_{\text{exp}}}$

*** =right

<div style='text-align: center;'>
    <img height='300' src='./figure./confMat.png' />
</div>


--- .class #id 

## Previous Example: a Re-evaluation with Kappa 

<div style='text-align: center;'>
    <img height='150' src='./figure./confMatExample.png' />
</div>

Calculate the kappa statistic:

```r
TP = 100; FP = 475; FN = 400; TN = 9025; total <- TP + FP + FN + TN
p_obs <- (TP + TN)/total; p_exp <- (TP + FN)*(TP + FP)/total^2 + (FN + TN)*(FP + TN)/total^2
kappa <- (p_obs - p_exp)/(1 - p_exp)
round(kappa, 2)
```

```
## [1] 0.14
```

Kappa indicates that the performance of classifier X is not superb - 0.14 is close to 0! This is consistent with our intuition. 



