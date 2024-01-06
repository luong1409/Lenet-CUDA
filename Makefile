##############################################################################
test_cpu.o: test_cpu.cc
	nvcc -arch=sm_75 --compile test_cpu.cc -I./ -L/usr/local/cuda/lib64 -lcudart

test_cpu: test_cpu.o
	nvcc -arch=sm_75 -o test_cpu -lm -lcuda -lrt test_cpu.o src/network.o src/mnist.o src/layer/*.o src/loss/*.o src/optimizer/*.o -I./ -L/usr/local/cuda/lib64 -lcudart

test_model_cpu: test_cpu
	./test_cpu

#############################################################################
test_gpu.o: test_gpu.cc
	nvcc -arch=sm_75 --compile test_gpu.cc -I./ -L/usr/local/cuda/lib64 -lcudart

test_gpu: test_gpu.o
	nvcc -arch=sm_75 -o test_gpu -lm -lcuda -lrt test_gpu.o src/network.o src/mnist.o src/layer/*.o src/loss/*.o src/optimizer/*.o src/layer/custom/*.o -I./ -L/usr/local/cuda/lib64 -lcudart

test_model_gpu: test_gpu
	./test_gpu

##############################################################################

train: train.o 
	nvcc -arch=sm_75 -o train -lm -lcuda -lrt train.o src/network.o src/mnist.o src/layer/*.o src/loss/*.o src/optimizer/*.o src/layer/custom/*.o -I./ -L/usr/local/cuda/lib64 -lcudart

train.o: train.cc
	nvcc -arch=sm_75 --compile train.cc -I./ -L/usr/local/cuda/lib64 -lcudart

train_model: train
	./train

############################################################################

dnnNetwork.o: dnnNetwork.cc
	nvcc -arch=sm_75 --compile dnnNetwork.cc -I./ -L/usr/local/cuda/lib64 -lcudart

network.o: src/network.cc
	nvcc -arch=sm_75 --compile src/network.cc -o src/network.o -I./ -L/usr/local/cuda/lib64 -lcudart

mnist.o: src/mnist.cc
	nvcc -arch=sm_75 --compile src/mnist.cc -o src/mnist.o  -I./ -L/usr/local/cuda/lib64 -lcudart

layer: src/layer/conv.cc src/layer/ave_pooling.cc src/layer/fully_connected.cc src/layer/max_pooling.cc src/layer/relu.cc src/layer/sigmoid.cc src/layer/softmax.cc 
	nvcc -arch=sm_75 --compile src/layer/ave_pooling.cc -o src/layer/ave_pooling.o -I./ -L/usr/local/cuda/lib64 -lcudart
	nvcc -arch=sm_75 --compile src/layer/conv.cc -o src/layer/conv.o -I./ -L/usr/local/cuda/lib64 -lcudart
	nvcc -arch=sm_75 --compile src/layer/conv_gpu.cc -o src/layer/conv_gpu.o -I./ -L/usr/local/cuda/lib64 -lcudart
	nvcc -arch=sm_75 --compile src/layer/fully_connected.cc -o src/layer/fully_connected.o -I./ -L/usr/local/cuda/lib64 -lcudart
	nvcc -arch=sm_75 --compile src/layer/max_pooling.cc -o src/layer/max_pooling.o -I./ -L/usr/local/cuda/lib64 -lcudart
	nvcc -arch=sm_75 --compile src/layer/relu.cc -o src/layer/relu.o -I./ -L/usr/local/cuda/lib64 -lcudart
	nvcc -arch=sm_75 --compile src/layer/sigmoid.cc -o src/layer/sigmoid.o -I./ -L/usr/local/cuda/lib64 -lcudart
	nvcc -arch=sm_75 --compile src/layer/softmax.cc -o src/layer/softmax.o -I./ -L/usr/local/cuda/lib64 -lcudart

basic: 
	rm -f src/layer/custom/*.o
	nvcc -arch=sm_75 --compile src/layer/custom/gpu-support.cu -o src/layer/custom/gpu-support.o -I./ -L/usr/local/cuda/lib64 -lcudart 
	nvcc -arch=sm_75 --compile src/layer/custom/gpu-new-forward.cu -o src/layer/custom/gpu-new-forward.o -I./ -L/usr/local/cuda/lib64 -lcudart

constant_mem: 
	rm -f src/layer/custom/*.o
	nvcc -arch=sm_75 --compile src/layer/custom/gpu-support.cu -o src/layer/custom/gpu-support.o -I./ -L/usr/local/cuda/lib64 -lcudart 
	nvcc -arch=sm_75 --compile src/layer/custom/gpu-new-forward_constant_mem.cu -o src/layer/custom/gpu-new-forward.o -I./ -L/usr/local/cuda/lib64 -lcudart

shared_mem:
	rm -f src/layer/custom/*.o
	nvcc -arch=sm_75 --compile src/layer/custom/gpu-support.cu -o src/layer/custom/gpu-support.o -I./ -L/usr/local/cuda/lib64 -lcudart 
	nvcc -arch=sm_75 --compile src/layer/custom/gpu-new-forward_shared_mem.cu -o src/layer/custom/gpu-new-forward.o -I./ -L/usr/local/cuda/lib64 -lcudart

combine: 
	rm -f src/layer/custom/*.o
	nvcc -arch=sm_75 --compile src/layer/custom/gpu-support.cu -o src/layer/custom/gpu-support.o -I./ -L/usr/local/cuda/lib64 -lcudart 
	nvcc -arch=sm_75 --compile src/layer/custom/gpu-new-forward_combine.cu -o src/layer/custom/gpu-new-forward.o -I./ -L/usr/local/cuda/lib64 -lcudart


loss: src/loss/cross_entropy_loss.cc src/loss/mse_loss.cc
	nvcc -arch=sm_75 --compile src/loss/cross_entropy_loss.cc -o src/loss/cross_entropy_loss.o -I./ -L/usr/local/cuda/lib64 -lcudart
	nvcc -arch=sm_75 --compile src/loss/mse_loss.cc -o src/loss/mse_loss.o -I./ -L/usr/local/cuda/lib64 -lcudart

optimizer: src/optimizer/sgd.cc
	nvcc -arch=sm_75 --compile src/optimizer/sgd.cc -o src/optimizer/sgd.o -I./ -L/usr/local/cuda/lib64 -lcudart

clean:
	rm -f infoGPU demo main train test
	rm -f *.o src/*.o src/layer/*.o src/loss/*.o src/optimizer/*.o src/layer/custom/*.o

setup:
	make network.o
	make mnist.o
	make layer
	make loss
	make optimizer

run: demo
	./demo