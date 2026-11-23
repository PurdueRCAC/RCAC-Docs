# Make 20 small sample files, data/sample_01.txt to data/sample_20.txt.
# Each sample_NN.txt holds the numbers 1 to NN, one per line.
mkdir -p data
for i in $(seq -w 1 20); do
    seq "$i" > "data/sample_$i.txt"
done

# List the files, one path per line, for the examples that read a list.
ls data/sample_*.txt > inputs.txt
