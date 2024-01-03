
#import PySpice as sp

from hspiceParser import import_export
import numpy as np
import pandas as pd

local_dir="./tests/"
tr_path = "./spiceTestCases/merged_test_output/".replace("./", local_dir)
tr_file = "merged_test_output.tr0"
output_n_v= "soln1_0"
output_n_i= "x1_fl_out"

def parseSpiceOut(filePath, TR_file, outputNode):
    TRdata = []
    TR_c   = []


    # for single output this is the output port

    Full_TR_FILE = filePath + TR_file

    Open_TR_FILE = open(filePath + TR_file)

    #line = line.replace("\n", "")
    #inputFileBase = line.replace(".sp", "_o.tr0")
    #csvFile= line.replace(".sp", "_o_tr0.csv")
    csvFile = Full_TR_FILE.replace(".tr0", "_tr0.csv")

    import_export(Full_TR_FILE, "csv")

    df = pd.read_csv(csvFile, delimiter = ",")

    TRdata.append(df)

    #print(df.columns)
    outputNode_v = " v_" + outputNode[0]
    outputNode_i = " i_" + outputNode[1]

    TR_out_pr = df.loc[0, outputNode_v]
    TR_out_fl = df.loc[0, outputNode_i]

    return TR_out_pr, TR_out_fl


def calcResistance(test_volt, test_curr):
    test_r = test_volt/test_curr
    return test_r

if __name__ == "__main__":
    
    [test_volt, test_curr] = parseSpiceOut(tr_path, tr_file, [output_n_v, output_n_i])

    test_r = test_volt/test_curr

    print(test_r)