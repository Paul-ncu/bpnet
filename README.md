 在大电流对铅酸蓄电池循环放电的过程中，记录每次充放电的端电压和内存。
因为蓄电池的容量是一个过程值，无法直接测量，根据大量的文献证实，铅酸蓄电池的容量与内阻和端电压密切相关。
利用bp神经网络，内阻和端电压为label，容量为target进行训练。
最终能够根据端电压和内阻进行预测电池容量。
