#include "helper.h"

void inference_only()
{
    std::cout << "Loading mnist data...";
    MNIST dataset("./data/");
    dataset.read_test_data(0);
    std::cout << "Done" << std::endl;

    std::cout << "Loading model...";
    Network dnn = createNetwork_GPU();
    std::cout << "Done" << std::endl;

    dnn.forward(dataset.test_data);
    float acc = compute_accuracy(dnn.output(), dataset.test_labels);
    std::cout << std::endl;
    std::cout << "Test Accuracy: " << acc << std::endl;
    std::cout << std::endl;
}

int main(int argc, char *argv[])
{

    // int batch_size = 10000;

    // if (argc == 2)
    // {
    //     batch_size = atoi(argv[1]);
    // }

    // std::cout << "Test batch size: " << batch_size << std::endl;
    inference_only();

    return 0;
}
