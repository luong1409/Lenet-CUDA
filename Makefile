test_classic.o:     test_classic.cc
	nvcc --compile test_classic.cc -I./ -L/usr/local/cuda/lib64 -lcudart

test_classic:       test_classic.o
	nvcc -o test_classic -lm -lcuda -lrt test_cpu.o src/network.o src/mnist.o src/layer/*.o src/loss/*.o src/optimizer/*.o -I./ -L/usr/local/cuda/lib64 -lcudart

run_test_classic:       test_classic
	./test_classic


m2:     m2.o custom
	nvcc -o m2 -lm -lcuda -lrt m2.o ece408net.o src/network.o src/mnist.o src/layer/*.o src/loss/*.o src/layer/custom/*.o ../libgputk/lib/libgputk.a -I./ 

m2.o:       m2.cc
	nvcc --compile m2.cc -I ../libgputk/ -I./

ece408net.o:        ece408net.cc
	nvcc --compile ece408net.cc -I ../libgputk/ -I./

network.o:      src/network.cc
	nvcc --compile src/network.cc -o src/network.o -I./ -L/usr/local/cuda/lib64 -lcudart

mnist.o:        src/mnist.cc
	nvcc --compile src/mnist.cc -o src/mnist.o  -I./ -L/usr/local/cuda/lib64 -lcudart

layer:      src/layer/conv.cc src/layer/ave_pooling.cc src/layer/fully_connected.cc src/layer/max_pooling.cc src/layer/relu.cc src/layer/sigmoid.cc src/layer/softmax.cc 
	nvcc --compile src/layer/ave_pooling.cc -o src/layer/ave_pooling.o -I./ -L/usr/local/cuda/lib64 -lcudart
	nvcc --compile src/layer/conv.cc -o src/layer/conv.o -I./ -L/usr/local/cuda/lib64 -lcudart
	nvcc --compile src/layer/fully_connected.cc -o src/layer/fully_connected.o -I./ -L/usr/local/cuda/lib64 -lcudart
	nvcc --compile src/layer/max_pooling.cc -o src/layer/max_pooling.o -I./ -L/usr/local/cuda/lib64 -lcudart
	nvcc --compile src/layer/relu.cc -o src/layer/relu.o -I./ -L/usr/local/cuda/lib64 -lcudart
	nvcc --compile src/layer/sigmoid.cc -o src/layer/sigmoid.o -I./ -L/usr/local/cuda/lib64 -lcudart
	nvcc --compile src/layer/softmax.cc -o src/layer/softmax.o -I./ -L/usr/local/cuda/lib64 -lcudart

custom:
	nvcc --compile src/layer/custom/cpu-new-forward.cc -o src/layer/custom/cpu-new-forward.o -I./ -L/usr/local/cuda/lib64 -lcudart
	nvcc --compile src/layer/custom/gpu-utils.cu -o src/layer/custom/gpu-utils.o -I./ -L/usr/local/cuda/lib64 -lcudart
	nvcc --compile src/layer/custom/new-forward.cu -o src/layer/custom/new-forward.o -I./ -L/usr/local/cuda/lib64 -lcudart

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
	# make clean_o
	# make clean
	make network.o
	make mnist.o
	make layer
	make loss
	make optimizer

run:        m2
	./m2 1000
