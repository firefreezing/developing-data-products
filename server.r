library(shiny)

# self-defined function to calculate the corresponding kappa statistic,
# overall accuracy, and other performance measures
# (s.t. positive predicted value (PPV) and negative predicted value (NPV))
KappaStat <- function(prevalence, sensitivity, specificity){
  
  # prevalance: percentage of true postive cases
  # sensitivity: true positive rate among all positive cases
  # specificity: true negative rate among all negative cases
  
  CondPos <- 10000 * prevalence
  CondNeg <- 10000 * (1-prevalence)
  
  TP <- CondPos * sensitivity         # true positive cases 
  FN <- CondPos * (1 - sensitivity)   # false negative cases
  
  TN <- CondNeg * specificity         # true negative cases
  FP <- CondNeg * (1 - specificity)   # false positive cases
  
  TestPos <- TP + FP                  # test outcome postive cases
  TestNeg <- FN + TN                  # test outcome negative cases
  
  ObsAcry <- (TP + TN)/10000          # observed accuracy
  ExpAcry <- (CondNeg * TestNeg + CondPos * TestPos)/10^8
  # expected accuracy
  
  # Compose data frame for the confusion matrix
  ConfMat <- data.frame(
    Yes = c(round(TP, 0), round(FN, 0)),
    No = c(round(FP, 0), round(TN, 0)),
    row.names = c("Yes", "No"),
    stringsAsFactors=FALSE)
  
  return(list(confMatrix = ConfMat,
              accuracy = ObsAcry,
              kappa = (ObsAcry - ExpAcry)/(1 - ExpAcry),
              ppv = TP / (TP + FP),
              npv = TN / (TN + FN)))
}

shinyServer(function(input, output) {
  
  confMatrix <- reactive({KappaStat(as.numeric(input$prevalence)/100,
                                    as.numeric(input$sensitivity)/100,
                                    as.numeric(input$specificity)/100)$confMatrix})
  
  kappa <- reactive(KappaStat(as.numeric(input$prevalence)/100,
                              as.numeric(input$sensitivity)/100,
                              as.numeric(input$specificity)/100)$kappa)
  
  accuracy <- reactive(KappaStat(as.numeric(input$prevalence)/100,
                              as.numeric(input$sensitivity)/100,
                              as.numeric(input$specificity)/100)$accuracy)
 
  confMatrixDemo <- reactive({
    data.frame(
      Yes = c("True Positive (TP)", "False Negative (FN)"),
      No = c("False Positive (FP)", "True Negative (TN)"),
      row.names = c("Yes", "No"),
      stringsAsFactors=FALSE)
  })
  
#   confMatrixDemo <- reactive({
#     data.frame(
#       Yes = c("True Positive", "False Negative", "Positive Condition"),
#       No = c("False Positive", "True Negative", "Negative Condition"),
#       RowSum = c("Positive Test Outcome", "Negative Test Outcome",
#                  "Total Population"),
#       row.names = c("Yes", "No", "ColSum"),
#       stringsAsFactors=FALSE)
#   })
  
  
#   ppv <- reactive(KappaStat(as.numeric(input$prevalence)/100,
#                               as.numeric(input$sensitivity)/100,
#                               as.numeric(input$specificity)/100)$ppv)
#   
#   npv <- reactive(KappaStat(as.numeric(input$prevalence)/100,
#                             as.numeric(input$sensitivity)/100,
#                             as.numeric(input$specificity)/100)$npv)
  
  output$myConfMatrix <- renderTable({confMatrix()})
  output$myConfMatrixDemo <- renderTable({confMatrixDemo()})
  output$myKappa <- renderText({round(kappa(), 3)})
  output$myAccuracy <- renderText({round(accuracy(), 3)})
#   output$myPPV <- renderText({ppv()})
#   output$myNPV <- renderText({npv()})
  
})  # end of ShinyServer