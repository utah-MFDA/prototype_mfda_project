
import re


MFDA_keys = [
    'DESIGN_NAME',
    'DIE_AREA',
    'CORE_AREA',
    'IO']

Print_keys = [
    'PX_VAL',
    'LAYER_VAL',
    'BOT_LAYER_VAL',
    'LPV_VAL',
    'XBULK_VAL',
    'YBULK_VAL',
    'ZBULK_VAL',
    'DEF_SCALE_VAL',
    'PITCH',
    'RES_VAL']

Vars = {}

for key in MFDA_keys:
    Vars[key] = ''

Vars['PRINTING_PARAMETERS'] = {} 


def loadVariablesFromMFDA(inFile):
    
    for line in inFile.split(';'):
        # removes leading white space and part before #(comment)
        line = line.strip()
        temp_line = ''
        for newline in line.split('\n'):
            temp_line =+ newline.split('#')[0]
        # remove double+ spaces
        line = re.sub(' +', ' ', temp_line)
        
def makeOpenROADFiles(template_path):
    pass


def makeOpenSCADFiles(template_path):
    pass


if __name__ == "__main__":

    mfdaFile = arg1

    vars = loadVariablesFromMFDA(mfdaFile)
