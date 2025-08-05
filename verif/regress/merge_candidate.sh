# Copyright 2021 Thales DIS design services SAS
#
# Licensed under the Solderpad Hardware Licence, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# SPDX-License-Identifier: Apache-2.0 WITH SHL-2.0
# You may obtain a copy of the License at https://solderpad.org/licenses/
#
# Original Author: Jean-Roch COULON - Thales

# where are the tools
if ! [ -n "$RISCV" ]; then
  echo "Error: RISCV variable undefined"
  return
fi

if ! [ -n "$DV_SIMULATORS" ]; then
  DV_SIMULATORS=veri-testharness,spike
fi

# install the required tools
if [[ "$DV_SIMULATORS" == *"veri-testharness"* ]]; then
  source ./verif/regress/install-verilator.sh
fi
source ./verif/regress/install-spike.sh
source verif/regress/install-riscv-tests.sh

source ./verif/sim/setup-env.sh

if ! [ -n "$DV_TARGET" ]; then
  DV_TARGET=cv64a6_imafdc_sv39
fi

if ! [ -n "$DV_TESTLISTS" ]; then
  DV_TESTLISTS="../tests/testlist_riscv-tests-merge-p.yaml "
fi

if ! [ -n "$UVM_VERBOSITY" ]; then
    export UVM_VERBOSITY=UVM_NONE
fi

export DV_OPTS="$DV_OPTS --issrun_opts=+tb_performance_mode+debug_disable=1+UVM_VERBOSITY=$UVM_VERBOSITY"

cd verif/sim
for TESTLIST in $DV_TESTLISTS
do
  python3 cva6.py --testlist=$TESTLIST --target $DV_TARGET --iss=$DV_SIMULATORS --iss_yaml=cva6.yaml $DV_OPTS
done
cd -

# cd verif/sim
# for TESTLIST in $DV_TESTLISTS
# do
#   python3 cva6.py --testlist="../tests/testlist_riscv-tests-merge-p-fail.yaml" --target $DV_TARGET --iss=$DV_SIMULATORS --iss_yaml=cva6.yaml $DV_OPTS
# done
# cd -


# export DV_TARGET=cv64a6_imafdc_sv39
make clean
cd verif/sim/
make clean_all

python3 cva6.py --testlist=../tests/testlist_pmp-merge.yaml --target $DV_TARGET --iss_yaml=cva6.yaml --iss=$DV_SIMULATORS $DV_OPTS --linker=../../config/gen_from_riscv_config/linker/link.ld

make clean_all
cd -
# # make clean

export DV_TARGET=cv32a65x
make clean
cd verif/sim/
make clean_all

python3 cva6.py --testlist=../tests/testlist_riscv-tests-merge-mmu32.yaml --target $DV_TARGET --hwconfig_opts "cv32a65x MmuPresent=1" --iss_yaml=cva6.yaml --iss=$DV_SIMULATORS $DV_OPTS --linker=../../config/gen_from_riscv_config/linker/link.ld --gcc_opts="-lgcc " 

make clean_all
cd -

make clean
cd verif/sim/
make clean_all

python3 cva6.py --testlist=../tests/testlist_pmp-merge.yaml --target $DV_TARGET --iss_yaml=cva6.yaml --iss=$DV_SIMULATORS $DV_OPTS --linker=../../config/gen_from_riscv_config/cv32a60x/linker/link.ld


make clean_all
cd -

export DV_TARGET=cv32a60x
make clean
cd verif/sim/
make clean_all

python3 cva6.py --testlist=../tests/testlist_pmp-merge.yaml --target $DV_TARGET --hwconfig_opts "cv32a60x NrPMPEntries=8" --iss_yaml=cva6.yaml --iss=$DV_SIMULATORS $DV_OPTS --linker=../../config/gen_from_riscv_config/cv32a60x/linker/link.ld

make clean_all
cd -
# make clean

export DV_TARGET=cv32a6_imac_sv32
make clean
cd verif/sim/
make clean_all

python3 cva6.py --testlist=../tests/testlist_riscv-tests-merge-mmu32.yaml --target $DV_TARGET --iss_yaml=cva6.yaml --iss=$DV_SIMULATORS $DV_OPTS --linker=../../config/gen_from_riscv_config/linker/link.ld --gcc_opts="-lgcc " 

make clean_all
cd -

make clean
cd verif/sim/
make clean_all

python3 cva6.py --testlist=../tests/testlist_pmp-merge.yaml --target $DV_TARGET --iss_yaml=cva6.yaml --iss=$DV_SIMULATORS $DV_OPTS --linker=../../config/gen_from_riscv_config/cv32a60x/linker/link.ld

make clean_all
cd -
make clean



