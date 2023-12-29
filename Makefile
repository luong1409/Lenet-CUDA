########################################################## Test Run Train on CPU #######################################################
test_classic.o:     test_classic.cc
	nvcc --compile test_classic.cc -I./ -L/usr/local/cuda/lib64 -lcudart

test_classic:       test_classic.o
	nvcc -o test_classic -lm -lcuda -lrt test_classic.o src/network.o src/mnist.o src/layer/*.o src/loss/*.o src/optimizer/*.o -I./ -L/usr/local/cuda/lib64 -lcudart

run_test_classic:       test_classic
	./test_classic

#########################################################################################################################################



########################################################## Test Run Inference on GPU #######################################################


infer_basic_GPU:     infer_basic_GPU.o custom
	nvcc -o infer_basic_GPU -lm -lcuda -lrt infer_basic_GPU.o helper.o src/network.o src/mnist.o src/layer/*.o src/loss/*.o src/layer/custom/*.o -I./ -L/usr/local/cuda/lib64 -lcudart

infer_basic_GPU.o:       infer_basic_GPU.cc
	nvcc --compile infer_basic_GPU.cc -I./ -L/usr/local/cuda/lib64 -lcudart

run_infer_basic_GPU:		infer_basic_GPU
	./infer_basic_GPU
#########################################################################################################################################

helper.o:        helper.cc
	nvcc --compile helper.cc -I./ -L/usr/local/cuda/lib64 -lcudart

network.o:      src/network.cc
	nvcc --compile src/network.cc -o src/network.o -I./ -L/usr/local/cuda/lib64 -lcudart

mnist.o:        src/mnist.cc
	nvcc --compile src/mnist.cc -o src/mnist.o  -I./ -L/usr/local/cuda/lib64 -lcudart

layer:      src/layer/conv.cc src/layer/ave_pooling.cc src/layer/fully_connected.cc src/layer/max_pooling.cc src/layer/relu.cc src/layer/sigmoid.cc src/layer/softmax.cc 
	nvcc --compile src/layer/ave_pooling.cc -o src/layer/ave_pooling.o -I./ -L/usr/local/cuda/lib64 -lcudart
	nvcc --compile src/layer/conv.cc -o src/layer/conv.o -I./ -L/usr/local/cuda/lib64 -lcudart
	nvcc --compile src/layer/conv_GPU.cu -o src/layer/conv_GPU.o -I./ -L/usr/local/cuda/lib64 -lcudart
	nvcc --compile src/layer/fully_connected.cc -o src/layer/fully_connected.o -I./ -L/usr/local/cuda/lib64 -lcudart
	nvcc --compile src/layer/max_pooling.cc -o src/layer/max_pooling.o -I./ -L/usr/local/cuda/lib64 -lcudart
	nvcc --compile src/layer/relu.cc -o src/layer/relu.o -I./ -L/usr/local/cuda/lib64 -lcudart
	nvcc --compile src/layer/sigmoid.cc -o src/layer/sigmoid.o -I./ -L/usr/local/cuda/lib64 -lcudart
	nvcc --compile src/layer/softmax.cc -o src/layer/softmax.o -I./ -L/usr/local/cuda/lib64 -lcudart

custom:
	nvcc --compile src/layer/custom/gpu-utils.cu -o src/layer/custom/gpu-utils.o -I./ -L/usr/local/cuda/lib64 -lcudart
	nvcc --compile src/layer/custom/gpu-new-forward-optimized.cu -o src/layer/custom/gpu-new-forward-optimized.o -I./ -L/usr/local/cuda/lib64 -lcudart
	# nvcc --compile src/layer/custom/gpu-new-forward-basic.cu -o src/layer/custom/gpu-new-forward-basic.o -I./ -L/usr/local/cuda/lib64 -lcudart

loss:       src/loss/cross_entropy_loss.cc src/loss/mse_loss.cc
	nvcc --compile src/loss/cross_entropy_loss.cc -o src/loss/cross_entropy_loss.o -I./ -L/usr/local/cuda/lib64 -lcudart
	nvcc --compile src/loss/mse_loss.cc -o src/loss/mse_loss.o -I./ -L/usr/local/cuda/lib64 -lcudart

optimizer:		src/optimizer/sgd.cc
	nvcc --compile src/optimizer/sgd.cc -o src/optimizer/sgd.o -I./ -L/usr/local/cuda/lib64 -lcudart


clean:
	rm m2
	rm m2.o

clean_o:
	rm -f *.o src/*.o src/layer/*.o src/loss/*.o src/optimizer/*.o src/layer/custom/*.o

setup:
	make clean_o
	make network.o
	make mnist.o
	make layer
	make loss
	make optimizer
	make helper.o

