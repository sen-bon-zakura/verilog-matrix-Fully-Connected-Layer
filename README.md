# verilog-matrix-Fully-Connected-Layer

Implement the matrix computation of the fully connected layer in a neural network: 

𝑦=ReLU(𝑊𝑋^𝑇+𝑏) and successfully simulate and verify it.

The values of W,𝑋,b can be set manually.

system architecture

Weight matrix W:Fixed as a 4×4 matrix.

Input data x: N*4 matrix,in this code use 256*4,but each operation is 4*4.

bias b:after calculation, need to add the basis.

relu:less than 0,out=0.

use fsm control:

![架構圖](https://github.com/user-attachments/assets/02e687d6-6b26-49ea-83fc-541e516cb4e0)

vivado wave:

![wave1](https://github.com/user-attachments/assets/d589d20f-d1ff-4472-b622-dbfee4510081)
