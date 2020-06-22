from sklearn.metrics import precision_recall_fscore_support
from sklearn.metrics import roc_curve, roc_auc_score
from sklearn.metrics import confusion_matrix,classification_report
import pandas as pd
from scipy import stats


import matplotlib.pyplot as plt
import numpy as np

%matplotlib inline


def print_cm(cm, labels, hide_zeroes=False, hide_diagonal=False, hide_threshold=None):
    """pretty print for confusion matrixes"""
    columnwidth = max([len(x) for x in labels] + [5])  # 5 is value length
    empty_cell = " " * columnwidth
    
    # Begin CHANGES
    fst_empty_cell = (columnwidth-3)//2 * " " + "t/p" + (columnwidth-3)//2 * " "
    
    if len(fst_empty_cell) < len(empty_cell):
        fst_empty_cell = " " * (len(empty_cell) - len(fst_empty_cell)) + fst_empty_cell
    # Print header
    print("    " + fst_empty_cell, end=" ")
    # End CHANGES
    
    for label in labels:
        print("%{0}s".format(columnwidth) % label, end=" ")
        
    print()
    # Print rows
    for i, label1 in enumerate(labels):
        print("    %{0}s".format(columnwidth) % label1, end=" ")
        for j in range(len(labels)):
            cell = "%{0}.1f".format(columnwidth) % cm[i, j]
            if hide_zeroes:
                cell = cell if float(cm[i, j]) != 0 else empty_cell
            if hide_diagonal:
                cell = cell if i != j else empty_cell
            if hide_threshold:
                cell = cell if cm[i, j] > hide_threshold else empty_cell
            print(cell, end=" ")
        print()


def feature_importance(model, name, note):
    coefs = pd.DataFrame(np.dstack((
        x_unscaled.columns,model.named_steps[name].coef_.round(4)))[0], 
                         columns = ['Features','Coefficients']).\
    sort_values('Coefficients',ascending=True).set_index('Features')
    
    coefs.plot(kind='barh', figsize=(9,7))
    plt.title(name + ' ' + note)
    plt.axvline(x=0, color='.5')
    plt.subplots_adjust(left=.3)
    
    print(coefs)


def logitMetrics(x,y, model):
    logit_tr_acc = model.score(x, y)
    logit_tr_pr, logit_tr_re, logit_tr_f1, _ = precision_recall_fscore_support(y, model.predict(x))

    print(" Logit Train Accuracy : %1.3f" % (logit_tr_acc))
    print(" Logit Train Precision: %1.3f (no fraud) and %1.3f (fraud)" % (logit_tr_pr[0], logit_tr_pr[1]))
    print(" Logit Train Recall   : %1.3f (no fraud) and %1.3f (fraud)" % (logit_tr_re[0], logit_tr_re[1]))
    print(" Logit Train F1 Score : %1.3f (no fraud) and %1.3f (fraud)" % (logit_tr_f1[0], logit_tr_f1[1]))
    
def ROC(x,y, model):
    y_probs_logit = pd.DataFrame(model.predict_proba(x))[1]
    fpr, tpr, thresholds = roc_curve(y, y_probs_logit)
    auc = roc_auc_score(y, y_probs_logit)  # Computes auc
    
    plt.figure()
    lw = 2
    plt.plot(fpr, tpr, color='darkorange', lw=lw,
            label='ROC logit (area = %0.2f)' % auc)

    plt.plot([0, 1], [0, 1], color='navy', lw=lw, linestyle='--')
    plt.xlim([0, 1.02])
    plt.ylim([0, 1.02])
    plt.xlabel('False Positive Rate')
    plt.ylabel('True Positive Rate')
    plt.title('Receiver Operating Curve')
    plt.legend(loc="lower right")
    plt.show()