cd ReceptiveFields/
git pull
cd ..
python convert_notebook.py nbconvert/nbconvert.py ReceptiveFields/receptiveFields.ipynb
sed -i '8,$ d' ../_posts/2013-02-14-visualizing-receptive-fields.markdown
cat ReceptiveFields/receptiveFields.html >> ../_posts/2013-02-14-visualizing-receptive-fields.markdown 
