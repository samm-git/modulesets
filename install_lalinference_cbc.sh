#!/bin/bash

# Create pe directory where the installation will be
mkdir -p ~/pe
cd ~/pe

# Download module sets for jhbuild
if [ ! -d ~/pe/modulesets ]; then
  git clone git://github.com/vivienr/modulesets.git ~/pe/modulesets
fi
cd ~/pe/modulesets
git pull

# Download and install jhbuild
mkdir -p ~/pe/src
if [ ! -d ~/pe/src/jhbuild ]; then
  git clone git://git.gnome.org/jhbuild ~/pe/src/jhbuild
  cd ~/pe/src/jhbuild
  ./autogen.sh --prefix=~/pe/.local/
  make
  make install
fi

# Set up jhbuild configuration files
mkdir -p ~/.config && cd ~/.config
ln -s ~/pe/modulesets/jhbuildrc

echo "prefix = '$HOME/pe/local/'" > ~/pe/modulesets/pe.jhbuildrc
echo "modulesets_dir = '$HOME/pe/modulesets'" >> ~/pe/modulesets/pe.jhbuildrc
echo "checkoutroot = '$HOME/pe/src'" >> ~/pe/modulesets/pe.jhbuildrc
echo "branches['lal']=(None,'lalinference_o2')" >> ~/pe/modulesets/pe.jhbuildrc
echo "branches['lalframe']=(None,'lalinference_o2')" >> ~/pe/modulesets/pe.jhbuildrc
echo "branches['lalmetaio']=(None,'lalinference_o2')" >> ~/pe/modulesets/pe.jhbuildrc
echo "branches['lalxml']=(None,'lalinference_o2')" >> ~/pe/modulesets/pe.jhbuildrc
echo "branches['lalburst']=(None,'lalinference_o2')" >> ~/pe/modulesets/pe.jhbuildrc
echo "branches['lalpulsar']=(None,'lalinference_o2')" >> ~/pe/modulesets/pe.jhbuildrc
echo "branches['lalstochastic']=(None,'lalinference_o2')" >> ~/pe/modulesets/pe.jhbuildrc
echo "branches['lalinspiral']=(None,'lalinference_o2')" >> ~/pe/modulesets/pe.jhbuildrc
echo "branches['lalsimulation']=(None,'lalinference_o2')" >> ~/pe/modulesets/pe.jhbuildrc
echo "branches['lalinference']=(None,'lalinference_o2')" >> ~/pe/modulesets/pe.jhbuildrc
echo "branches['lalapps']=(None,'lalinference_o2')" >> ~/pe/modulesets/pe.jhbuildrc
echo "branches['lalsuite-extra']=(None,'lalinference_o2')" >> ~/pe/modulesets/pe.jhbuildrc
echo "branches['glue']=(None,'lalinference_o2')" >> ~/pe/modulesets/pe.jhbuildrc
echo "branches['pylal']=(None,'lalinference_o2')" >> ~/pe/modulesets/pe.jhbuildrc
echo "branches['ligo']=(None,'lalinference_o2')" >> ~/pe/modulesets/pe.jhbuildrc
echo "branches['gracedb']=(None,'lalinference_o2')" >> ~/pe/modulesets/pe.jhbuildrc
echo "branches['lvalert']=(None,'lalinference_o2')" >> ~/pe/modulesets/pe.jhbuildrc
echo "" >> ~/pe/modulesets/pe.jhbuildrc
echo "intel_executables=['icc','icpc','ifort','mpiicc','mpiicpc','mpiifort','xiar']" >> ~/pe/modulesets/pe.jhbuildrc
echo "" >> ~/pe/modulesets/pe.jhbuildrc
echo "from distutils.spawn import find_executable" >> ~/pe/modulesets/pe.jhbuildrc
echo "def is_in_path(name):" >> ~/pe/modulesets/pe.jhbuildrc
echo '    """Check whether `name` is on PATH."""' >> ~/pe/modulesets/pe.jhbuildrc
echo "    return find_executable(name) is not None" >> ~/pe/modulesets/pe.jhbuildrc
echo "" >> ~/pe/modulesets/pe.jhbuildrc
echo "if all([is_in_path(name) for name in intel_executables]):" >> ~/pe/modulesets/pe.jhbuildrc
echo "   icc = True" >> ~/pe/modulesets/pe.jhbuildrc
echo "" >> ~/pe/modulesets/pe.jhbuildrc
echo "del name" >> ~/pe/modulesets/pe.jhbuildrc
echo "del intel_executables" >> ~/pe/modulesets/pe.jhbuildrc
echo "" >> ~/pe/modulesets/pe.jhbuildrc
echo "os.environ['LAL_DATA_PATH'] = '$HOME/ROM_data/'" >> ~/pe/modulesets/pe.jhbuildrc
echo "" >> ~/pe/modulesets/pe.jhbuildrc
ln -s ~/pe/modulesets/pe.jhbuildrc

# Install lalsuite from anonymous repository
~/pe/.local/bin/jhbuild build lalsuite

## If needed, install additional packages:
# ~/pe/.local/bin/jhbuild -f ~/.config/jhbuildrc run $SHELL --noprofile --norc
# pip install <package> --install-option="--prefix=~/pe/local/"

# Create initisalisation script
echo "#!/bin/bash" > ~/pe/lalinference_o2.sh
echo "$HOME/pe/.local/bin/jhbuild -f $HOME/.config/jhbuildrc run $SHELL --noprofile --norc" >> ~/pe/lalinference_o2.sh
chmod a+x ~/pe/lalinference_o2.sh