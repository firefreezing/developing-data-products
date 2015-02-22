library(shiny)
# library(ggplot2)  # for the diamonds dataset

shinyUI(fluidPage(
  title = 'Examples of DataTables',
  
  titlePanel("The Paradox for Accuracy and Kappa Statistic"),
  
  sidebarLayout(
    sidebarPanel(
      conditionalPanel(
        'input.dataset === "Paradox"',
        helpText('To see a demonstration, click the "Demo" tab.')
        ),
      
      conditionalPanel(
        'input.dataset === "Demo"',
        helpText('Set the values of several parameters:'),
        sliderInput("prevalence", "Prevalence (%):", 
                    min = 0, max = 100, value = 70, step = 1),
        br(),
        sliderInput("sensitivity", "Sensitivity (%):",
                    min = 0, max = 100, value = 50, step = 1),
        br(),
        sliderInput("specificity", "Specificity (%):",
                    min = 0, max = 100, value = 50, step = 1),
        br()        
      )   # end of conditional panel
    ),    # end of sidebarPanel
    
    mainPanel(
      tabsetPanel(
        id = 'dataset',
        
        tabPanel('Paradox',
                 h5('Introduction:'),
                 p('The result of a classification problem in machine learning 
                   can be represented by
                   a confusion matrix. A confusion matrix is a fourfold table
                   showing the binary agreement between the classifier and the 
                   true data labels (also known as the "gold standard"). 
                   As an example, the following table shows a confusion matrix,
                   where columns indicate the true outcomes from the gold
                   standard and rows indicate the classification results
                   from a machine learning algorithm.'),
                 
                 tableOutput("myConfMatrixDemo"),
                 
                 p('One typical performance measure to assess a classifier
                   is the accuracy, which calculates the proportion of the
                   concordant results among all records. Mathematically, it can
                   be formulated as:'),

                 p('P_obs = (TP + TN)/population'),
                 
#                 h3(withMathJax('$$\\text{P}_{\\text{obs}} = \\frac{\\text{TP + TN}}
#                                {\\text{Total Population}}.$$')),
                 
                 p('Usually, a high accuracy indicates a high concordance between the classifier
                   and the truth. However, in certain cases a high accuracy
                   may due to the fact that the classifier agrees with the 
                   truth just by chance. To adjust this, in some research areas, particularly in
                   medical field on diagnosis, researchers use kappa statistic
                   to report the model performance. The advantage of the kappa
                   statistic is that it corrects the amount of agreement that 
                   can be expected to occur by chance. To calculate the kappa statistic,
                   we first computes the expected agreement by chance:'),

                 p('P_exp = (TP + FN) * (TP + FP)/population^2 + 
                   (FN + TN) * (FP + TN)/population^2'),
                 
#                  h3(withMathJax('$$\\text{P}_{\\text{exp}} = \\frac{\\text{TP + FN}}
#                                 {\\text{Total Population}} * \\frac{\\text{TP + FP}}
#                                 {\\text{Total Population}} + \\frac{\\text{FN + TN}}
#                                 {\\text{Total Population}} * \\frac{\\text{FP + TN}}
#                                 {\\text{Total Population}}.$$')),
                 
                 p('Then, the kappa statistic is defined by'),

                 p('kappa = (p_obs - p_exp)/(1 - p_exp)'),
   
#                  h3(withMathJax('$$\\kappa = \\frac{\\text{P}_{\\text{obs}} - \\text{P}_{\\text{exp}}}
#                                 {1 - \\text{P}_{\\text{exp}}}.$$')),
                 
                 p('Kappa statistic takes value between -1 and 1, where a kappa of 0
                   indicates agreement equivalent to chance, kappa gets close to 1 
                   indicates strong agreement and close to -1 indicates strong
                   disagreement. Since kappa statistic is a correction term for accuracy, a first reaction
                   is that kappa and accuracy should have similar trend on each data.
                   However, in many real cases we find that high accuracy can sometimes
                   associate with kappa statistic close to 0. This phenomenon is
                   more often to happen when the dataset has a strong disproportinate 
                   prevalence (i.e., the original data has very low percentage of
                   positive cases, or vice versa). In general, for a data with 
                   significantly disproportionate prevalence, 
                   a low kappa value may not necessarily reflect low rates of
                   overall agreement.')
                 ),   # end of tabPanel
                 
                 tabPanel('Demo',
                          h5('Instruction:'),
                          
                          p('This demonstration shows how accuracy and kappa statistic
                            look like with data in different distributions.
                            Without loss of generality, we set the data size to be 10,000.
                            There are three tuning parameters in this demonstration - prevalence, 
                            sensitivity, and specificity. Prevalence is the true percent of
                            positve (yes) cases. Sensitivity is the percent of correctly
                            identified records among all positive (yes) cases. Specificity
                            is the percent of correctly identified records among all
                            negative (no) cases. One can customize these parameters to 
                            illustrate outcomes in different scenarios.'),
                          
                          br(),
                          
                          p('First, one could choose a relatively balanced 
                            prevalence with high sensitivity and specificity. 
                            Then gradually reduce the value prevalence and check 
                            its impact on kappa statistic and accuracy.'),
                          
                          br(),
                          
                          h5('Results:'),
                          p('The confusion matrix is (Column = the truth, or gold standard, 
                            Row = outcomes by the classifier):'),
                          tableOutput("myConfMatrix"),
                          br(),
                          p('The kappa statistic for the confusion matrix is:'),
                          textOutput("myKappa"),
                          br(),
                          p('The accuracy for the confusion matrix is:'),
                          textOutput("myAccuracy")
                 )    # end of tabPanel                                                   
                 

      ) # end of tabsetPanel
    )   # end of mainPanel
  ) # end of sidebarLayout
)   # end of fluidPage
)   # end of shinyUI