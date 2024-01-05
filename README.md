# Lenet 5 version CUDA 
Source code of Lenet 5 model implemented by using C/C++.

# Members
|Name       |MSSV    |    
|:----------------|:------:|
|Nguyễn Minh Lương|19120571|
|Phạm Trần Gia Phú|20120348|
|Trần Phú Nguyện|...|

# Introduction
In this final project, we will implement and optimize the forward-pass of a convolutional layer utilizing CUDA. Convolutional layers are fundamental components of convolutional neural networks (CNNs).

Our optimized CUDA implementation of the convolutional layer will specifically cater to the inference process for layers C1 and C3.

To kickstart this endeavor, the Mini-DNN-CPP (Mini-DNN) framework will serve as a foundational platform for implementing a modified version of LeNet-5.

The chosen dataset for this project is Fashion MNIST, a collection of single-channel images with dimensions of 28 x 28 pixels. The output layer comprises 10 nodes, with each node representing the likelihood of the input belonging to one of the 10 classes, such as T-shirt, dress, sneaker, boot, and others.

# How to run
## Run Training Process
```shell
git clone https://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@github.com/luong1409/Lenet-CUDA.git
cd Lenet-CUDA
make clean
make setup
make train_model
```

## Run CPU (sequential) version and GPU version of Forward pass
```shell
git clone https://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@github.com/luong1409/Lenet-CUDA.git
cd Lenet-CUDA
make clean
make setup
make custom0
make test_model
```

# Dataset
[MNIST dataset](https://github.com/zalandoresearch/fashion-mnist), network will be a single channel images with dimensions of 28 x 28 pixels
