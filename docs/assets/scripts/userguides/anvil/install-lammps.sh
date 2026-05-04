# download lammps-lammps-23Jun2022 from LAMMPS webpage and untar it
wget https://download.lammps.org/tars/lammps-stable.tar.gz
tar -xzvf lammps-stable.tar.gz
cd lammps-23Jun2022

# create and change to a build directory
mkdir build; cd build;   

# Setup module environments
module purge;
ml modtree/cpu;
ml hdf5 fftw gsl netlib-lapack;
ml cmake anaconda;

# enable most packages and setup Python package library path
cmake -C ../cmake/presets/most.cmake -D PYTHON_EXECUTABLE=$CONDA_PYTHON_EXE ../cmake

# compilation
make -j 12
