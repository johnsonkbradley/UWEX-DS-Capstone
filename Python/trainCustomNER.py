#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Jul 11 20:01:27 2024

@author: bradleyjohnson

This file will train the custom spacy NER model
"""

import spacy


#######################
# Setup the training data

train = [
    ("A-fib, rate controlled",{"entities":[(0,5,"Diagnosis")]}),
    ("Coronary artery disease s/p CABG CHF HTN AICD Atrial fibrillation Stroke",{"entities":[(0,23,"Diagnosis"),(28,32,"Diagnosis"),(33,36,"Diagnosis"),(37,40,"Diagnosis"),(41,45,"Diagnosis"),(46,65,"Diagnosis"),(66,72,"Diagnosis")]}),
    ("CT scan revealed unstable C spine fracture.",{"entities":[(26,42,"Diagnosis")]}),
    ("He had a cardiac pacemaker placement due to irregular heart rate and bradycardia.",{"entities":[(69,80,"Diagnosis")]}),
    ("Cardiac arrhythmia as noted above, has a pacemaker in place, prostate cancer with prostatectomy, and hypertension.",{"entities":[(8,18,"Diagnosis"),(70,76,"Diagnosis"),(101,113,"Diagnosis")]}),
    ("Fracture of the C6 as described involving the right pedicle",{"entities":[(0,8,"Diagnosis")]}),
    ("-- myositis s/p muscle biopsy at [**Hospital1 112**], possibly related to statin use",{"entities":[(3,11,"Diagnosis")]}),
    ("-- anemia",{"entities":[(3,9,"Diagnosis")]}),
    ("-- osteoarthritis",{"entities":[(3,17,"Diagnosis")]}),
    ("-- right nephrectomy [**2165**] due to renal cell carcinoma",{"entities":[(39,59,"Diagnosis")]}),
    ("-- chronic systolic CHF, EF 30-40%",{"entities":[(20,23,"Diagnosis")]}),
    ("PMH: hyperlipidemia, BRCA1 carrier",{"entities":[(5,19,"Diagnosis")]}),
    ("ECG showed sinus tachycardia.",{"entities":[(11,28,"Diagnosis")]}),
    ("- Bipolar Type 2, currently severe depression, requiring hospitalization at [**Doctor First Name **] in the past",{"entities":[(2,9,"Diagnosis"),(35,45,"Diagnosis")]}),
    ("- Insomnia",{"entities":[(2,10,"Diagnosis")]}),
    ("- GERD with severe esophagitis ([**2098**])",{"entities":[(19,30,"Diagnosis")]}),
    ("- Asthma, requiring 1x intubation in late teen (unclear if this was related to the theophylline)",{"entities":[(2,8,"Diagnosis")]}),
    ("1. Hypothyroid. 2. Coronary artery disease. 3. Hypertension. 4. Peptic ulcer disease status post gastrectomy for perforated ulcer. 5. Dementia. 6. Esophageal motility disorder. 7. Recurrent pneumonia.",{"entities":[(19,42,"Diagnosis"),(47,59,"Diagnosis"),(64,84,"Diagnosis"),(134,142,"Diagnosis")]}),
    ("There is no family history of premature coronary artery disease or sudden death.",{"entities":[(40,63,"Diagnosis")]}),
    ("RADIOLOGY: Chest x-ray on admission revealed mild congestive heart failure, markedly improved since the prior study of [**2188-8-17**]. ",{"entities":[(51,75,"Diagnosis")]}),
    ("Past Medical History: HTN hypothyroidism back pain w/sciatica plantar fasciitis",{"entities":[(22,25,"Diagnosis"),(26,40,"Diagnosis"),(53,61,"Diagnosis"),(62,79,"Diagnosis")]}),
    ("Family History: His family history is noted for father living age 75 with thyroid disease; mother living age 73 with heart disease, cancer and obesity; sister living age 42 with thyroid disease and two sisters ages 48 and 53 living with diabetes and obesity.",{"entities":[(74,89,"Diagnosis"),(117,130,"Diagnosis"),(132,138,"Diagnosis"),(143,150,"Diagnosis"),(178,193,"Diagnosis"),(237,245,"Diagnosis"),(250,257,"Diagnosis")]}),
    ("5. Dementia.",{"entities":[(4,12,"Diagnosis")]}),
    ("Patient with history of hypertension",{"entities":[(24,36,"Diagnosis")]}),
    ("HTN",{"entities":[(0,3,"Diagnosis")]})
]
#######################
# Convert data to .spacy format

nlp = spacy.load("en_core_web_sm")

import pandas as pd
import os
from tqdm import tqdm
from spacy.tokens import DocBin

db = DocBin() # create a DocBin object

for text, annot in tqdm(train): # data in previous format
    doc = nlp.make_doc(text) # create doc object from text
    ents = []
    for start, end, label in annot["entities"]: # add character indexes
        span = doc.char_span(start, end, label=label, alignment_mode="contract")
        if span is None:
            print("Skipping entity")
        else:
            ents.append(span)
    doc.ents = ents # label the text with the ents
    db.add(doc)

db.to_disk("./train.spacy") # save the docbin object

# run in the line to fill in the config file
#!python -m spacy init fill-config base_config.cfg config.cfg

# Run to train the model
#!python -m spacy train config.cfg --output ./output --paths.train ./train.spacy --paths.dev ./train.spacy


# Loading out trained model
nlp1 = spacy.load(r"./output/model-best") #load the best model
doc = nlp1("Past history: 1. A-fib 2. Chest pain 3. HTN") # input sample text
doc.ents










