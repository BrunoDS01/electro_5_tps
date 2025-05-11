onerror {exit -code 1}
vlib work
vlog -work work tp2_e5_ERV25_grupo2.vo
vlog -work work bht_btb_waveform.vwf.vt
vsim -c -t 1ps -L cycloneive_ver -L altera_ver -L altera_mf_ver -L 220model_ver -L sgate_ver -L altera_lnsim_ver work.tp2_e5_ERV25_grupo2_vlg_vec_tst
vcd file -direction tp2_e5_ERV25_grupo2.msim.vcd
vcd add -internal tp2_e5_ERV25_grupo2_vlg_vec_tst/*
vcd add -internal tp2_e5_ERV25_grupo2_vlg_vec_tst/i1/*
proc simTimestamp {} {
    echo "Simulation time: $::now ps"
    if { [string equal running [runStatus]] } {
        after 2500 simTimestamp
    }
}
after 2500 simTimestamp
run -all
quit -f
