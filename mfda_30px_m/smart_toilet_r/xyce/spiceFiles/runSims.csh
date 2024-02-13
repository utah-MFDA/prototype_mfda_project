#/bin/tcsh

cd mfda_30px_m/smart_toilet_r/xyce/spiceFiles/

mkdir ./smart_toilet_r_H2O.
hspice -i ./smart_toilet_r_H2O..sp -o ./smart_toilet_r_H2O./smart_toilet_r_H2O._o

mkdir ./smart_toilet_r_Sample.
hspice -i ./smart_toilet_r_Sample..sp -o ./smart_toilet_r_Sample./smart_toilet_r_Sample._o

mkdir ./smart_toilet_r_Tag.
hspice -i ./smart_toilet_r_Tag..sp -o ./smart_toilet_r_Tag./smart_toilet_r_Tag._o

