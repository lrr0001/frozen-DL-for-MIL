import misvm
import numpy
import pickle
import random

def my_classifier(bags_train,bags_test,labels_train,gamm,cost):
    classifier = misvm.MISVM(C = cost,gamma = gamm,max_iters = 50)
    #x_bag1 = [[1.0,1.5,2.0,2.5],[1.1,1.4,2.1,2.5],[0.9,1.4,2.1,2.6]]
    #x_bag2 = [[1.1,1.4,2.1,2.4],[1.2,1.4,2.2,2.5],[0.9,1.6,2.2,2.4]]
    #x_bag3 = [[1.0,1.6,2.2,2.7],[1.0,1.6,2.2,2.6],[0.8,1.3,2.3,2.4]]
    #x_bag4 = [[5.1,5.4,6.1,6.6],[5.2,5.5,6.2,6.3],[4.8,5.2,6.3,6.4]]
    #x_bag5 = [[5.2,5.6,6.2,6.4],[5.3,5.4,6.3,6.5],[4.9,5.2,6.3,6.6]]
    #x_bag6 = [[5.1,5.4,6.1,6.3],[5.1,5.3,6.4,6.5],[4.9,5.3,6.0,6.3]]

    #x2_bag1 = [[1.0,1.5,2.0,2.5],[1.1,1.4,2.1,2.5],[0.9,1.4,2.1,2.6]]
    #x2_bag2 = [[0.8,1.3,2.2,2.3],[1.1,1.4,2.1,2.5],[1.0,1.5,2.0,2.5]]
    #x2_bag3 = [[5.1,5.4,6.1,6.3],[5.1,5.3,6.4,6.5],[5.0,5.5,6.0,6.5]]


    #x = [numpy.array(x_bag1),numpy.array(x_bag2),numpy.array(x_bag3),numpy.array(x_bag4),numpy.array(x_bag5),numpy.array(x_bag6)]
    x = bags_train
    x2 = bags_test
    #x2 = [numpy.array(x2_bag1),numpy.array(x2_bag2),numpy.array(x2_bag3)]
    #y = [1.0,1.0,1.0,-1.0,-1.0,-1.0]
    y = labels_train


    #classifier.fit(bags_train,labels_train)
    classifier.fit(x,y)
    labels_test = classifier.predict(x2)
    #labels_test = classifier.predict(bags_test)
    return labels_test

def my_cos(x):
    y = numpy.cos(x)
    return y

def pickleSave(filename,save_list):
    f = open(filename,'wb')
    for save_item in save_list:
        pickle.dump(save_item,f)

def getMISVMAccuracy(curr_str,cost_exp):
    f = open(curr_str,'rb')
    training_bags = pickle.load(f)
    val_bags = pickle.load(f)
    training_labels = pickle.load(f)
    val_labels = pickle.load(f)
    f.close()
#    classifier1 = misvm.miSVM(C = 2**cost_exp,gamma = 2**gamm_exp,kernel = 'rbf')
    classifier1 = misvm.miSVM(C = 2**cost_exp,kernel = 'linear')
    classifier1.fit(training_bags,training_labels)
    estimated_labels = classifier1.predict(val_bags)
    estimated_train_labels = classifier1.predict(training_bags)
    match_diff = numpy.dot(numpy.sign(estimated_labels),val_labels)
    match_sum = numpy.dot(numpy.absolute(numpy.sign(estimated_labels)),numpy.absolute(val_labels))
    zero_fraction = float(estimated_labels.size - match_sum)/estimated_labels.size
    print('zero fraction: ' + str(zero_fraction))
    accuracy = float(match_diff + estimated_labels.size)/(2.0*estimated_labels.size)
    match_diff = numpy.dot(numpy.sign(estimated_train_labels),training_labels)
    match_sum = numpy.dot(numpy.absolute(numpy.sign(estimated_train_labels)),numpy.absolute(training_labels))
    train_accuracy = float(match_diff + estimated_train_labels.size)/(2.0*estimated_train_labels.size)
    return (accuracy,train_accuracy);


def generateValSearchResults():
    f = open('ValidationRuns/searchSpace.pickle','rb')
    class_set = pickle.load(f)
    cost_exp_set = pickle.load(f)
    f.close()
    print(type(class_set))
    print(type(cost_exp_set))
    try:
        class_set_list = list(class_set)
    except TypeError:
        class_set_list = list([class_set])
    try:
        cost_exp_set_list = list(cost_exp_set)
    except TypeError:
        cost_exp_set_list = list([cost_exp_set])

    for cc in class_set_list:
        for cost_exp in cost_exp_set_list:
            curr_str0 = 'ValidationRuns/true_coef_val' + str(int(cc)) + '.pickle'

            curr_str1 = 'ValidationRuns/fzn_ksvd_lbl_val' + str(int(cc)) + '.pickle'

            curr_str2 = 'ValidationRuns/ul_ksvd_lbl_val' + str(int(cc)) + '.pickle'

            curr_str3 = 'ValidationRuns/ul_pca_lbl_val' + str(int(cc)) + '.pickle'

            (true_coef_acc, true_coef_acc_train) = getMISVMAccuracy(curr_str0,cost_exp)
            print('true coef: ' + str(true_coef_acc) + '/' + str(true_coef_acc_train))
            
            (fzn_ksvd_acc, fzn_ksvd_acc_train) = getMISVMAccuracy(curr_str1,cost_exp)
            print('frozen k-SVD: ' + str(fzn_ksvd_acc) + '/' + str(fzn_ksvd_acc_train))
            (ul_ksvd_acc, ul_ksvd_acc_train) = getMISVMAccuracy(curr_str2,cost_exp)
            print('UL k-SVD: ' + str(ul_ksvd_acc) + '/' + str(ul_ksvd_acc_train))
            (ul_pca_acc, ul_pca_acc_train) = getMISVMAccuracy(curr_str3,cost_exp)
            #ul_pca_acc = -1.0
            #ul_pca_acc_train = -1.0
            print('PCA: ' + str(ul_pca_acc) + '/' + str(ul_pca_acc_train))

            with open('searchSpaceResults.txt','a') as search_results:
#                    search_results.write(str(int(cc)) + ',' + str(int(gamm_exp)) + ',' + str(int(cost_exp)) + ':' + str(fzn_ksvd_acc) + ', ' + str(ul_ksvd_acc) + ', ' + str(ul_pca_acc) + '\n')
                search_results.write(str(int(cc)) + ',' + str(int(cost_exp)) + ':' + str(true_coef_acc) + '/' + str(true_coef_acc_train) + ', ' + str(fzn_ksvd_acc) + '/' + str(fzn_ksvd_acc_train) + ', ' + str(ul_ksvd_acc) +'/' + str(ul_ksvd_acc_train) + ', ' + str(ul_pca_acc) + '/' + str(ul_pca_acc_train) + '\n')
                     

