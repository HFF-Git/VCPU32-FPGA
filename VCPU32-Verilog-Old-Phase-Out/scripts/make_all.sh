# Bash Script to process all verilog files in Test-Benches
#
#

SIM_DIR=../simulation

pwd

for source in *.v; do
    target="${source%.*}.vvp"
    echo "build "  $target " from " $source
    iverilog -o $SIM_DIR/$target $source
done
