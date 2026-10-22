fn main() {
    let lake_snes_dir = std::path::Path::new("../../cores/snes_core/lake_snes");
    println!("cargo:rerun-if-changed={}", lake_snes_dir.display());

    let c_files = [
        "apu.c",
        "cart.c",
        "cpu.c",
        "dma.c",
        "dsp.c",
        "input.c",
        "ppu.c",
        "snes.c",
        "snes_other.c",
        "spc.c",
        "statehandler.c",
    ];

    let mut build = cc::Build::new();
    build.include(lake_snes_dir);
    build.flag_if_supported("-Wno-unused-parameter");
    build.flag_if_supported("-Wno-sign-compare");
    build.flag_if_supported("-Wno-unused-function");
    build.flag_if_supported("-Wno-c23-extensions");
    build.opt_level(3);

    for file in &c_files {
        build.file(lake_snes_dir.join(file));
    }

    build.compile("lake_snes_c");
}
