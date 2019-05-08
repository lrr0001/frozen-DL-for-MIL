import pickle
import numpy
import misvm

def get_bag_labels(bag_labels_str):
    f = open(bag_labels_str,'rb')
    bag_labels = pickle.load(f)
    datatype = pickle.load(f)
    f.close()
    return bag_labels


def get_learned_coef(learned_coef_str):
    f = open(learned_coef_str,'rb')
    learned_coef_bags = pickle.load(f)
    f.close()
    return learned_coef_bags



def misvm_from_dependency_string(dependency_str):
    f = open(dependency_str,'rb')
    prestr = pickle.load(f)
    poststr = "inputNodesPython/"
    bag_labels_train_str = prestr + poststr + pickle.load(f)
    bag_labels_val_str = prestr + poststr + pickle.load(f)
    bag_labels_test_str = prestr + poststr + pickle.load(f)
    learned_coef_train_str = prestr + poststr + pickle.load(f)
    learned_coef_val_str = prestr + poststr + pickle.load(f)
    learned_coef_test_str = prestr + poststr + pickle.load(f)
    poststr = "outputNodesPython/"
    estimated_bag_labels_train_str = prestr + poststr + pickle.load(f)
    estimated_bag_labels_val_str = prestr + poststr + pickle.load(f)
    estimated_bag_labels_test_str = prestr + poststr + pickle.load(f)
    cc = pickle.load(f)
    cost_exp = pickle.load(f)
    use_pca = pickle.load(f)
    if use_pca:
        pca_r = pickle.load(f)
    f.close()
    
    learned_coef_bags_train = get_learned_coef(learned_coef_train_str)
    bag_labels_train = get_bag_labels(bag_labels_train_str)
    
    misvmClassifier = misvm.miSVM(C = 2**cost_exp,kernel = 'linear',max_iters = 16)
    misvmClassifier.fit(learned_coef_bags_train,bag_labels_train)
    estimated_labels_train = misvmClassifier.predict(learned_coef_bags_train)
    f = open(estimated_bag_labels_train_str,'wb')
    pickle.dump(estimated_labels_train,f)
    pickle.dump("train",f)
    f.close()
    
    del learned_coef_bags_train
    del bag_labels_train
    
    learned_coef_bags_val = get_learned_coef(learned_coef_val_str)
     
    estimated_bag_labels_val = misvmClassifier.predict(learned_coef_bags_val)

    f = open(estimated_bag_labels_val_str,'wb')
    pickle.dump(estimated_bag_labels_val,f)
    pickle.dump("val",f)
    f.close()

    del learned_coef_bags_val
    
    learned_coef_bags_test = get_learned_coef(learned_coef_test_str)

    estimated_bag_labels_test = misvmClassifier.predict(learned_coef_bags_test)
    f = open(estimated_bag_labels_test_str,'wb')
    pickle.dump(estimated_bag_labels_test,f)
    pickle.dump("test",f)
    f.close()

    

