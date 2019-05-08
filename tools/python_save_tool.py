import numpy
import pickle

def pickleSave(filename,save_list):
    f = open(filename,'wb')
    for save_item in save_list:
        pickle.dump(save_item,f)

