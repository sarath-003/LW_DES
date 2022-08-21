# LightWeightDES-decryption

This Repository has a verilog project of implementing Lightweight DES(decryption only).

This project was done by a group of 5 memebers for the course ECN 104 as Course Project. The 5 members of the team are:

1. Jatin Meena (20116042)
2. Sarath S (20116089)
3. Gaurav R Kochar (20116033)
4. Jothi Krishnan M (20116043)
5. Jasvinder Singh (20116040)

There are 3 folders in this repository.



# Verilog codes:
  This folder has all the verilog codes, that is 3 ".v" files including a testbench file. The files 'Main.v' and 'subkey-generator.v' are
the actual modules of the Light Weight DES.

# Schematics:
  This folder has the schematics of the blockdiagram, which were simulated in Xilinx Vivado, we used in the project. In detail, it has two pdfs.
 Namely 'schematic_main.pdf' and 'schematic_subkey.pdf' which contains the simulation in landscape format. Now there is another file named
 'schematic.sch' which can be imported into Vivado or any other simulator to see the schematics.
 
 # Waveform:
    This folder contains a file named ' simulation1.wcfg' which is the waveform obtained after the succesful compilation of the project.
    In this Simulation the input, 64 bit hex numbers, cipher text (i.e ctext) and key ( i.e key) are "01c0c0fdfbd0deb0" and "1d6a5ae5516dfa93" respectively.
    The output we got after 17 clock cycles(1 + 16 rounds) is "de5895031b0dc891".
