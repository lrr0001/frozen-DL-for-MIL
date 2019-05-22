import numpy
import pickle

def pickleSave(filename,save_list):
    f = open(filename,'wb')
    for save_item in save_list:
        pickle.dump(save_item,f)

def pickleLoad(filename,number_of_items):
    output_list = []
    f = open(filename,'rb')
    for load_item in range(number_of_items):
        output_list.append(pickle.load(f))
    return tuple(output_list)
