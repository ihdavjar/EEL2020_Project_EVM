## Goal of the project
In democratic nations around the world, electronic voting machines are employed during elections. However, since these voting machines are vulnerable to hacking, we created a tester using verilog-hdl and a Pynq-z2 board.

* [evm.pdf](https://github.com/ihdavjar/EEL2020_Project_EVM/blob/63212c4a97fedc2c9091562fed9d1f6c008b4d34/evm.pdf) This contains detailed explaination about various components in this project.

* This [Video](https://drive.google.com/file/d/1lvnXGruU8pRUw1dd6P-zCE52TZ84mwpk/view?usp=sharing) report explains each and every aspect of this project

# Future Imporvements
The tester now creates data, feeds it to the EVM, and then examines the discrepancy between the output of the EVM and the actual result. However, this approach is unable to identify the root source of the EVM issue. Therefore, it would be much better and quicker to design a data-driven tester.
